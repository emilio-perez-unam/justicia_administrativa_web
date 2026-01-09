import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:justicia_administrativa_web/features/home/widgets/hero_section.dart';
import 'package:justicia_administrativa_web/features/home/widgets/client_logos_section.dart';
import 'package:justicia_administrativa_web/features/home/widgets/dual_expertise_section.dart';
import 'package:justicia_administrativa_web/features/home/widgets/services_section.dart';
import 'package:justicia_administrativa_web/features/home/widgets/founder_section.dart';
import 'package:justicia_administrativa_web/features/home/widgets/testimonials_section.dart';
import 'package:justicia_administrativa_web/features/home/widgets/cta_section.dart';
import 'package:justicia_administrativa_web/features/home/widgets/animated_background.dart';
import 'package:justicia_administrativa_web/features/home/models/home_data.dart';
import 'package:justicia_administrativa_web/features/home/providers/home_provider.dart';
import 'package:justicia_administrativa_web/shared/widgets/loading_skeleton.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeController;
  final Map<String, bool> _visibleSections = {};

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController.forward();

    // Initialize home data
    Future.microtask(
      () => ref.read(homeDataProvider.notifier).loadInitialData(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeDataProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          const AnimatedBackground(),

          // Main content
          homeState.when(
            loading: () => const LoadingSkeleton(),
            error: (error, _) => _ErrorWidget(error: error.toString()),
            data: (data) => _buildContent(data),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(HomeData data) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Hero Section with Parallax
        SliverToBoxAdapter(
          child: VisibilityDetector(
            key: const Key('hero-section'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.1 &&
                  !(_visibleSections['hero'] ?? false)) {
                setState(() => _visibleSections['hero'] = true);
              }
            },
            child: HeroSection(
              scrollController: _scrollController,
              isVisible: _visibleSections['hero'] ?? false,
            ),
          ),
        ),

        // Client Logos with fade-in animation
        SliverToBoxAdapter(
          child: VisibilityDetector(
            key: const Key('client-logos'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.3 &&
                  !(_visibleSections['clients'] ?? false)) {
                setState(() => _visibleSections['clients'] = true);
              }
            },
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: (_visibleSections['clients'] ?? false) ? 1.0 : 0.0,
              child: ClientLogosSection(clients: data.clients).animate().slideY(
                begin: 0.1,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              ),
            ),
          ),
        ),

        // Dual Expertise with stagger animation
        SliverToBoxAdapter(
          child: VisibilityDetector(
            key: const Key('expertise'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.3 &&
                  !(_visibleSections['expertise'] ?? false)) {
                setState(() => _visibleSections['expertise'] = true);
              }
            },
            child: DualExpertiseSection(
              isVisible: _visibleSections['expertise'] ?? false,
            ),
          ),
        ),

        // Services Section
        SliverToBoxAdapter(
          child: VisibilityDetector(
            key: const Key('services'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.2 &&
                  !(_visibleSections['services'] ?? false)) {
                setState(() => _visibleSections['services'] = true);
              }
            },
            child: ServicesSection(
              services: data.services,
              isVisible: _visibleSections['services'] ?? false,
            ),
          ),
        ),

        // Founder Section
        SliverToBoxAdapter(
          child: VisibilityDetector(
            key: const Key('founder'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.3 &&
                  !(_visibleSections['founder'] ?? false)) {
                setState(() => _visibleSections['founder'] = true);
              }
            },
            child: FounderSection(
              isVisible: _visibleSections['founder'] ?? false,
            ),
          ),
        ),

        // Testimonials
        SliverToBoxAdapter(
          child: VisibilityDetector(
            key: const Key('testimonials'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.3 &&
                  !(_visibleSections['testimonials'] ?? false)) {
                setState(() => _visibleSections['testimonials'] = true);
              }
            },
            child: TestimonialsSection(
              testimonials: data.testimonials,
              isVisible: _visibleSections['testimonials'] ?? false,
            ),
          ),
        ),

        // CTA Section
        SliverToBoxAdapter(
          child: VisibilityDetector(
            key: const Key('cta'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.3 &&
                  !(_visibleSections['cta'] ?? false)) {
                setState(() => _visibleSections['cta'] = true);
              }
            },
            child: CTASection(isVisible: _visibleSections['cta'] ?? false),
          ),
        ),
      ],
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String error;

  const _ErrorWidget({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 16.h),
          Text(
            'Error loading content',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
