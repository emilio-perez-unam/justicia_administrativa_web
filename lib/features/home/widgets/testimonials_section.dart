import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:justicia_administrativa_web/core/theme/app_theme.dart';
import 'package:justicia_administrativa_web/shared/widgets/responsive_builder.dart';
import 'package:justicia_administrativa_web/shared/widgets/animated_container.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:ui';
import 'dart:math' as math;

class TestimonialsSection extends StatefulWidget {
  final List<TestimonialModel> testimonials;
  final bool isVisible;

  const TestimonialsSection({
    super.key,
    required this.testimonials,
    required this.isVisible,
  });

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection>
    with TickerProviderStateMixin {
  final CarouselController _carouselController = CarouselController();
  late AnimationController _backgroundController;
  late AnimationController _floatController;
  int _currentIndex = 0;
  bool _isAutoPlaying = true;

  // Animation controllers for different elements
  late AnimationController _quotesController;
  late Animation<double> _quotesAnimation;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _quotesController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _quotesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _quotesController, curve: Curves.easeInOut),
    );

    if (widget.isVisible) {
      _quotesController.forward();
    }
  }

  @override
  void didUpdateWidget(TestimonialsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _quotesController.forward();
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _floatController.dispose();
    _quotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create default testimonials if none provided
    final testimonials = widget.testimonials.isNotEmpty
        ? widget.testimonials
        : _getDefaultTestimonials();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 100.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.background, AppTheme.background.withBlue(248)],
        ),
      ),
      child: Stack(
        children: [
          // Animated background
          Positioned.fill(child: _buildAnimatedBackground()),

          // Main content
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 1200.w),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  // Section header
                  _buildSectionHeader(),

                  SizedBox(height: 60.h),

                  // Testimonials carousel
                  ResponsiveBuilder(
                    builder: (context, sizingInfo) {
                      if (testimonials.isEmpty) {
                        return _buildEmptyState(sizingInfo);
                      }
                      return _buildTestimonialsCarousel(
                        testimonials,
                        sizingInfo,
                      );
                    },
                  ),

                  SizedBox(height: 48.h),

                  // Trust badges
                  _buildTrustBadges(),
                ],
              ),
            ),
          ),

          // Floating decorative elements
          if (!ResponsiveBuilder.getSizingInfo(context).isMobile)
            _buildFloatingElements(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return CustomPaint(
          painter: TestimonialsBackgroundPainter(
            animation: _backgroundController.value,
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader() {
    return Column(
      children: [
        if (widget.isVisible)
          Text(
            'TESTIMONIOS',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              color: AppTheme.accentGold,
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),

        SizedBox(height: 16.h),

        if (widget.isVisible)
          Text(
                'Lo que dicen nuestros clientes',
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryNavy,
                ),
                textAlign: TextAlign.center,
              )
              .animate(delay: 200.ms)
              .fadeIn(duration: 800.ms)
              .slideY(begin: 0.2, end: 0),

        SizedBox(height: 16.h),

        Container(
          width: 80.w,
          height: 4.h,
          decoration: BoxDecoration(
            gradient: AppTheme.goldGradient,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ).animate(delay: 400.ms).scaleX(begin: 0, end: 1, duration: 600.ms),

        SizedBox(height: 24.h),

        if (widget.isVisible)
          Container(
            constraints: BoxConstraints(maxWidth: 600.w),
            child: Text(
              'Descubra cómo hemos transformado los procesos legales de nuestros clientes con soluciones innovadoras',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ).animate(delay: 600.ms).fadeIn(duration: 800.ms),
      ],
    );
  }

  Widget _buildTestimonialsCarousel(
    List<TestimonialModel> testimonials,
    ResponsiveSizingInfo sizingInfo,
  ) {
    final viewportFraction = sizingInfo.isMobile
        ? 0.9
        : sizingInfo.isTablet
        ? 0.8
        : 0.4;

    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isAutoPlaying = false),
          onExit: (_) => setState(() => _isAutoPlaying = true),
          child: CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: testimonials.length,
            itemBuilder: (context, index, realIndex) {
              return _TestimonialCard(
                testimonial: testimonials[index],
                index: index,
                isActive: index == _currentIndex,
                isVisible: widget.isVisible,
              );
            },
            options: CarouselOptions(
              height: sizingInfo.isMobile ? 450.h : 400.h,
              autoPlay: _isAutoPlaying,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
              autoPlayCurve: Curves.easeInOutCubic,
              enlargeCenterPage: true,
              enlargeFactor: 0.15,
              viewportFraction: viewportFraction,
              onPageChanged: (index, reason) {
                setState(() => _currentIndex = index);
              },
            ),
          ),
        ),

        SizedBox(height: 40.h),

        // Carousel controls
        _buildCarouselControls(testimonials.length),
      ],
    );
  }

  Widget _buildCarouselControls(int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        IconButton(
          onPressed: () => _carouselController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppTheme.primaryNavy,
            size: 20.sp,
          ),
        ),

        SizedBox(width: 16.w),

        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(itemCount, (index) {
            final isActive = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: isActive ? 32.w : 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: isActive ? AppTheme.accentGold : AppTheme.divider,
                borderRadius: BorderRadius.circular(4.r),
              ),
            );
          }),
        ),

        SizedBox(width: 16.w),

        // Next button
        IconButton(
          onPressed: () => _carouselController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
          icon: Icon(
            Icons.arrow_forward_ios,
            color: AppTheme.primaryNavy,
            size: 20.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ResponsiveSizingInfo sizingInfo) {
    return Container(
      padding: EdgeInsets.all(48.w),
      child: Column(
        children: [
          // Coming soon card
          _ComingSoonCard(),

          SizedBox(height: 32.h),

          // CTA card
          _CTACard(sizingInfo: sizingInfo),
        ],
      ),
    );
  }

  Widget _buildTrustBadges() {
    final badges = [
      {'value': '95%', 'label': 'Satisfacción'},
      {'value': '500+', 'label': 'Casos Resueltos'},
      {'value': '4.9', 'label': 'Calificación'},
      {'value': '24/7', 'label': 'Soporte'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: badges.asMap().entries.map((entry) {
          return _TrustBadge(
            value: entry.value['value']!,
            label: entry.value['label']!,
            delay: entry.key * 100,
            isVisible: widget.isVisible,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFloatingElements() {
    return Stack(
      children: [
        // Floating quote marks
        Positioned(
          top: 50.h,
          left: 50.w,
          child: AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 10 * _floatController.value),
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(
                    Icons.format_quote,
                    size: 80.sp,
                    color: AppTheme.accentGold,
                  ),
                ),
              );
            },
          ),
        ),

        Positioned(
          bottom: 50.h,
          right: 50.w,
          child: AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -10 * _floatController.value),
                child: Transform.rotate(
                  angle: math.pi,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(
                      Icons.format_quote,
                      size: 80.sp,
                      color: AppTheme.accentGold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<TestimonialModel> _getDefaultTestimonials() {
    return [
      TestimonialModel(
        id: '1',
        name: 'Notario Público',
        position: 'Notaría Pública 42',
        company: 'Ciudad de México',
        testimonial:
            'La implementación de las soluciones tecnológicas de Justicia Administrativa ha modernizado significativamente nuestros procesos. La eficiencia y precisión en el manejo de documentación legal ha mejorado notablemente.',
        rating: 5,
        date: DateTime.now().subtract(const Duration(days: 30)),
        imageUrl: null,
      ),
    ];
  }
}

// Testimonial Card Widget
class _TestimonialCard extends StatefulWidget {
  final TestimonialModel testimonial;
  final int index;
  final bool isActive;
  final bool isVisible;

  const _TestimonialCard({
    required this.testimonial,
    required this.index,
    required this.isActive,
    required this.isVisible,
  });

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.identity()
              ..translate(0.0, _isHovered ? -10.0 : 0.0)
              ..scale(_isHovered ? 1.05 : 1.0),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: widget.isActive
                        ? AppTheme.accentGold.withOpacity(0.2)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: widget.isActive ? 30 : 20,
                    offset: Offset(0, widget.isActive ? 15 : 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: widget.isActive
                            ? AppTheme.accentGold.withOpacity(0.3)
                            : Colors.white.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Quote icon
                        Container(
                              width: 48.w,
                              height: 48.h,
                              decoration: BoxDecoration(
                                gradient: AppTheme.goldGradient,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.format_quote,
                                  size: 28.sp,
                                  color: Colors.white,
                                ),
                              ),
                            )
                            .animate(target: widget.isActive ? 1 : 0)
                            .rotate(duration: 500.ms, end: 0.05)
                            .scale(end: const Offset(1.1, 1.1)),

                        SizedBox(height: 24.h),

                        // Testimonial text
                        Expanded(
                          child: Text(
                            '"${widget.testimonial.testimonial}"',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppTheme.textPrimary,
                              fontStyle: FontStyle.italic,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Rating
                        RatingBarIndicator(
                          rating: widget.testimonial.rating.toDouble(),
                          itemBuilder: (context, index) =>
                              Icon(Icons.star, color: AppTheme.accentGold),
                          itemCount: 5,
                          itemSize: 20.sp,
                          unratedColor: AppTheme.divider,
                        ),

                        SizedBox(height: 16.h),

                        // Author info
                        Column(
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: 30.r,
                              backgroundColor: AppTheme.primaryNavy.withOpacity(
                                0.1,
                              ),
                              backgroundImage:
                                  widget.testimonial.imageUrl != null
                                  ? CachedNetworkImageProvider(
                                      widget.testimonial.imageUrl!,
                                    )
                                  : null,
                              child: widget.testimonial.imageUrl == null
                                  ? Icon(
                                      Icons.person,
                                      size: 30.sp,
                                      color: AppTheme.primaryNavy,
                                    )
                                  : null,
                            ),

                            SizedBox(height: 12.h),

                            // Name
                            Text(
                              widget.testimonial.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryNavy,
                              ),
                            ),

                            // Position
                            Text(
                              widget.testimonial.position,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppTheme.textSecondary,
                              ),
                            ),

                            // Company
                            if (widget.testimonial.company != null)
                              Text(
                                widget.testimonial.company!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppTheme.textTertiary,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
        .animate(
          delay: (widget.index * 100).ms,
          target: widget.isVisible ? 1 : 0,
        )
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.3, end: 0);
  }
}

// Coming Soon Card
class _ComingSoonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(40.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, AppTheme.background],
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: AppTheme.divider, width: 2),
          ),
          child: Column(
            children: [
              Icon(Icons.auto_awesome, size: 48.sp, color: AppTheme.accentGold),
              SizedBox(height: 24.h),
              Text(
                'Próximamente más testimonios',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryNavy,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Estamos trabajando con nuevos clientes para transformar sus procesos legales',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 800.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }
}

// CTA Card
class _CTACard extends StatelessWidget {
  final ResponsiveSizingInfo sizingInfo;

  const _CTACard({required this.sizingInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(40.w),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            children: [
              Icon(Icons.chat, size: 48.sp, color: Colors.white),
              SizedBox(height: 24.h),
              Text(
                '¿Quiere ser nuestro próximo caso de éxito?',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                'Contáctenos para conocer cómo podemos ayudarle',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () {
                  // Navigate to contact
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGold,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 16.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: Text(
                  'Contactar ahora',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryNavy,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate(delay: 200.ms)
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.2, end: 0);
  }
}

// Trust Badge
class _TrustBadge extends StatelessWidget {
  final String value;
  final String label;
  final int delay;
  final bool isVisible;

  const _TrustBadge({
    required this.value,
    required this.label,
    required this.delay,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryNavy,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: AppTheme.textSecondary),
            ),
          ],
        )
        .animate(delay: delay.ms, target: isVisible ? 1 : 0)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.3, end: 0);
  }
}

// Background Painter
class TestimonialsBackgroundPainter extends CustomPainter {
  final double animation;

  TestimonialsBackgroundPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // Draw animated circles
    for (int i = 0; i < 3; i++) {
      final progress = (animation + i * 0.33) % 1.0;
      final radius = 100 + progress * 300;
      final opacity = (1 - progress) * 0.03;

      paint.color = AppTheme.accentGold.withOpacity(opacity);

      canvas.drawCircle(
        Offset(size.width * (0.2 + i * 0.3), size.height * 0.5),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(TestimonialsBackgroundPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}

// Testimonial Model
class TestimonialModel {
  final String id;
  final String name;
  final String position;
  final String? company;
  final String testimonial;
  final double rating;
  final DateTime date;
  final String? imageUrl;

  TestimonialModel({
    required this.id,
    required this.name,
    required this.position,
    this.company,
    required this.testimonial,
    required this.rating,
    required this.date,
    this.imageUrl,
  });
}
