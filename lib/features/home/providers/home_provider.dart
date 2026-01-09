import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:justicia_administrativa_web/features/home/models/home_data.dart';
import 'package:justicia_administrativa_web/features/home/repositories/home_repository.dart';

part 'home_provider.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.loading() = _Loading;
  const factory HomeState.data(HomeData data) = _Data;
  const factory HomeState.error(Object error, StackTrace stackTrace) = _Error;
}

class HomeNotifier extends StateNotifier<AsyncValue<HomeData>> {
  final HomeRepository _repository;
  
  HomeNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadInitialData() async {
    state = const AsyncValue.loading();
    
    try {
      final data = await _repository.getHomeData();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshData() async {
    state = const AsyncValue.loading();
    await loadInitialData();
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository();
});

final homeDataProvider = StateNotifierProvider<HomeNotifier, AsyncValue<HomeData>>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return HomeNotifier(repository);
});

// Specific data selectors
final clientsProvider = Provider<AsyncValue<List<ClientModel>>>((ref) {
  return ref.watch(homeDataProvider).whenData((data) => data.clients);
});

final servicesProvider = Provider<AsyncValue<List<ServiceModel>>>((ref) {
  return ref.watch(homeDataProvider).whenData((data) => data.services);
});

final testimonialsProvider = Provider<AsyncValue<List<TestimonialModel>>>((ref) {
  return ref.watch(homeDataProvider).whenData((data) => data.testimonials);
});