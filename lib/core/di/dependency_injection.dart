import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:hive/hive.dart';
import '../services/performance_interceptor.dart';
import '../services/auth_service.dart';
import '../services/voice_service.dart';
import '../services/offline_interceptor.dart';
import '../services/sync_service.dart';
import '../services/fuzzy_search_service.dart';
import '../services/export_service.dart';
import '../../domains/contact/application/contact_inquiry_repository.dart';
import '../../domains/contact/application/submit_contact_inquiry_use_case.dart';
import '../../domains/contact/infrastructure/supabase_contact_inquiry_repository.dart';
import '../../domains/auth/application/auth_repository.dart';
import '../../domains/auth/application/request_password_reset_use_case.dart';
import '../../domains/auth/application/reset_password_use_case.dart';
import '../../domains/auth/infrastructure/supabase_auth_repository.dart';
import '../../domains/portal_calendar/application/use_cases/create_calendar_event_use_case.dart';
import '../../domains/portal_calendar/application/use_cases/load_calendar_entries_use_case.dart';
import '../../domains/portal_calendar/application/use_cases/load_calendar_matters_use_case.dart';
import '../../domains/portal_calendar/application/use_cases/update_calendar_task_status_use_case.dart';
import '../../domains/portal_calendar/domain/repositories/portal_calendar_repository.dart';
import '../../domains/portal_calendar/infrastructure/portal_service_calendar_repository.dart';
import '../../domains/portal_messaging/application/load_recent_messages_use_case.dart';
import '../../domains/portal_messaging/application/portal_messaging_repository.dart';
import '../../domains/portal_messaging/infrastructure/portal_service_messaging_repository.dart';
import '../../domains/billing/application/billing_repository.dart';
import '../../domains/billing/application/load_invoices_use_case.dart';
import '../../domains/billing/infrastructure/portal_service_billing_repository.dart';
import '../../domains/legal_corpus/application/legal_corpus_gateway.dart';
import '../../domains/legal_corpus/infrastructure/supabase_legal_corpus_gateway.dart';
import '../../domains/documents/application/documents_repository.dart';
import '../../domains/documents/application/load_documents_use_case.dart';
import '../../domains/documents/application/upload_document_use_case.dart';
import '../../domains/documents/infrastructure/portal_service_documents_repository.dart';
import '../../domains/matters/application/matters_repository.dart';
import '../../domains/matters/application/load_matters_use_case.dart';
import '../../domains/matters/infrastructure/portal_service_matters_repository.dart';
import '../../domains/ai_consultation/application/ai_consultation_repository.dart';
import '../../domains/ai_consultation/application/send_consultation_message_use_case.dart';
import '../../domains/ai_consultation/infrastructure/supabase_ai_consultation_repository.dart';
import '../../domains/portal_settings/application/portal_settings_repository.dart';
import '../../domains/portal_settings/application/update_profile_use_case.dart';
import '../../domains/portal_settings/application/change_password_use_case.dart';
import '../../domains/portal_settings/infrastructure/supabase_portal_settings_repository.dart';
import '../../domains/blog/application/blog_admin_repository.dart';
import '../../domains/blog/application/load_all_posts_use_case.dart';
import '../../domains/blog/application/create_post_use_case.dart';
import '../../domains/blog/application/update_post_use_case.dart';
import '../../domains/blog/application/delete_post_use_case.dart';
import '../../domains/blog/application/set_published_use_case.dart';
import '../../domains/blog/application/set_featured_use_case.dart';
import '../../domains/blog/infrastructure/supabase_blog_admin_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  getIt.registerLazySingleton<Logger>(() => logger);
  logger.i("DI: Starting setup");
  logger.i("DI: Logger registered");

  try {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    logger.i("DI: Dio created");

    Box? queueBox;
    try {
      logger.i("DI: Opening Hive box");
      queueBox = await Hive.openBox('offline_queue');
      logger.i("DI: Hive box opened");
    } catch (e) {
      logger.e("DI: Failed to open Hive box 'offline_queue'", error: e);
    }

    logger.i("DI: Adding RetryInterceptor");
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: logger.i,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 5),
        ],
      ),
    );

    if (queueBox != null) {
      logger.i("DI: Adding OfflineInterceptor");
      // Use a local variable to be absolutely sure about null safety in flow analysis
      final box = queueBox;
      dio.interceptors.add(OfflineInterceptor(box, logger));
    }

    logger.i("DI: Adding PerformanceInterceptor");
    dio.interceptors.add(PerformanceInterceptor(logger));

    logger.i("DI: Adding Logging Interceptor");
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );

    logger.i("DI: Registering singletons");
    getIt.registerLazySingleton<Dio>(() => dio);
    getIt.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    );
    getIt.registerLazySingleton<LocalAuthentication>(
      () => LocalAuthentication(),
    );
    getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

    getIt.registerLazySingleton<AuthService>(
      () => AuthService(
        getIt<FlutterSecureStorage>(),
        getIt<LocalAuthentication>(),
        getIt<SupabaseClient>(),
      ),
    );

    getIt.registerLazySingleton<VoiceService>(() => VoiceService());
    getIt.registerLazySingleton<FuzzySearchService>(() => FuzzySearchService());
    getIt.registerLazySingleton<ExportService>(() => ExportService());
    // ── Contact slice ──────────────────────────────────────────────────────
    getIt.registerLazySingleton<ContactInquiryRepository>(
      () => SupabaseContactInquiryRepository(),
    );
    getIt.registerFactory<SubmitContactInquiryUseCase>(
      () => SubmitContactInquiryUseCase(getIt<ContactInquiryRepository>()),
    );

    // ── Auth / password-recovery slice ─────────────────────────────────────
    getIt.registerLazySingleton<AuthRepository>(() => SupabaseAuthRepository());
    getIt.registerFactory<RequestPasswordResetUseCase>(
      () => RequestPasswordResetUseCase(getIt<AuthRepository>()),
    );
    getIt.registerFactory<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(getIt<AuthRepository>()),
    );

    getIt.registerLazySingleton<PortalCalendarRepository>(
      () => const PortalServiceCalendarRepository(),
    );
    getIt.registerLazySingleton<LoadCalendarEntriesUseCase>(
      () => LoadCalendarEntriesUseCase(getIt<PortalCalendarRepository>()),
    );
    getIt.registerLazySingleton<LoadCalendarMattersUseCase>(
      () => LoadCalendarMattersUseCase(getIt<PortalCalendarRepository>()),
    );
    getIt.registerLazySingleton<CreateCalendarEventUseCase>(
      () => CreateCalendarEventUseCase(getIt<PortalCalendarRepository>()),
    );
    getIt.registerLazySingleton<UpdateCalendarTaskStatusUseCase>(
      () => UpdateCalendarTaskStatusUseCase(getIt<PortalCalendarRepository>()),
    );

    // ── Billing slice ──────────────────────────────────────────────────────
    getIt.registerLazySingleton<BillingRepository>(
      () => const PortalServiceBillingRepository(),
    );
    getIt.registerFactory<LoadInvoicesUseCase>(
      () => LoadInvoicesUseCase(getIt<BillingRepository>()),
    );

    // ── Legal corpus slice ─────────────────────────────────────────────────
    getIt.registerLazySingleton<LegalCorpusGateway>(
      () => SupabaseLegalCorpusGateway(),
    );

    // ── Documents slice ────────────────────────────────────────────────────
    getIt.registerLazySingleton<DocumentsRepository>(
      () => const PortalServiceDocumentsRepository(),
    );
    getIt.registerFactory<LoadDocumentsUseCase>(
      () => LoadDocumentsUseCase(getIt<DocumentsRepository>()),
    );
    getIt.registerFactory<UploadDocumentUseCase>(
      () => UploadDocumentUseCase(getIt<DocumentsRepository>()),
    );

    // ── Matters slice ──────────────────────────────────────────────────────
    getIt.registerLazySingleton<MattersRepository>(
      () => const PortalServiceMattersRepository(),
    );
    getIt.registerFactory<LoadMattersUseCase>(
      () => LoadMattersUseCase(getIt<MattersRepository>()),
    );

    // ── Portal-messaging slice ─────────────────────────────────────────────
    getIt.registerLazySingleton<PortalMessagingRepository>(
      () => const PortalServiceMessagingRepository(),
    );
    getIt.registerFactory<LoadRecentMessagesUseCase>(
      () => LoadRecentMessagesUseCase(getIt<PortalMessagingRepository>()),
    );

    // ── AI consultation slice ──────────────────────────────────────────────
    getIt.registerLazySingleton<AiConsultationRepository>(
      () => SupabaseAiConsultationRepository(),
    );
    getIt.registerFactory<SendConsultationMessageUseCase>(
      () => SendConsultationMessageUseCase(getIt<AiConsultationRepository>()),
    );

    // ── Portal settings slice ──────────────────────────────────────────────
    getIt.registerLazySingleton<PortalSettingsRepository>(
      () => const SupabasePortalSettingsRepository(),
    );
    getIt.registerFactory<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(getIt<PortalSettingsRepository>()),
    );
    getIt.registerFactory<ChangePasswordUseCase>(
      () => ChangePasswordUseCase(getIt<PortalSettingsRepository>()),
    );

    // ── Blog admin (write side) slice ──────────────────────────────────────
    getIt.registerLazySingleton<BlogAdminRepository>(
      () => const SupabaseBlogAdminRepository(),
    );
    getIt.registerFactory<LoadAllPostsUseCase>(
      () => LoadAllPostsUseCase(getIt<BlogAdminRepository>()),
    );
    getIt.registerFactory<CreatePostUseCase>(
      () => CreatePostUseCase(getIt<BlogAdminRepository>()),
    );
    getIt.registerFactory<UpdatePostUseCase>(
      () => UpdatePostUseCase(getIt<BlogAdminRepository>()),
    );
    getIt.registerFactory<DeletePostUseCase>(
      () => DeletePostUseCase(getIt<BlogAdminRepository>()),
    );
    getIt.registerFactory<SetPublishedUseCase>(
      () => SetPublishedUseCase(getIt<BlogAdminRepository>()),
    );
    getIt.registerFactory<SetFeaturedUseCase>(
      () => SetFeaturedUseCase(getIt<BlogAdminRepository>()),
    );

    if (queueBox != null) {
      logger.i("DI: Registering SyncService");
      final box = queueBox;
      getIt.registerLazySingleton<SyncService>(
        () => SyncService(dio, box, logger),
      );
    }

    logger.i("DI: Setup complete");
  } catch (e, s) {
    logger.f("DI: Critical initialization error", error: e, stackTrace: s);
  }
}
