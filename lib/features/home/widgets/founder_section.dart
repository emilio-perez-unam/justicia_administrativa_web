import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:lottie/lottie.dart';
import 'package:justicia_administrativa_web/core/theme/app_theme.dart';
import 'package:justicia_administrativa_web/shared/widgets/responsive_builder.dart';
import 'package:justicia_administrativa_web/shared/widgets/animated_container.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FounderSection extends StatefulWidget {
  final bool isVisible;

  const FounderSection({super.key, required this.isVisible});

  @override
  State<FounderSection> createState() => _FounderSectionState();
}

class _FounderSectionState extends State<FounderSection>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _quoteController;
  late AnimationController _backgroundController;
  bool _imageLoaded = false;
  bool _quoteVisible = false;
  bool _isHovered = false;
  double _mouseX = 0;
  double _mouseY = 0;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _quoteController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // Trigger quote animation after delay
    if (widget.isVisible) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _quoteVisible = true);
          _quoteController.forward();
        }
      });
    }
  }

  @override
  void didUpdateWidget(FounderSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _quoteVisible = true);
          _quoteController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _quoteController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      onHover: (event) {
        setState(() {
          _mouseX = event.localPosition.dx;
          _mouseY = event.localPosition.dy;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 100.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.background,
              AppTheme.background.withBlue(245),
              AppTheme.background.withRed(245),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            Positioned.fill(child: _buildAnimatedBackground()),

            // Main content
            Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 1200.w),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: ResponsiveBuilder(
                  builder: (context, sizingInfo) {
                    return _buildContent(sizingInfo);
                  },
                ),
              ),
            ),

            // Decorative elements
            if (!ResponsiveBuilder.getSizingInfo(context).isMobile)
              _buildDecorativeElements(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return CustomPaint(
          painter: FounderBackgroundPainter(
            animation: _backgroundController.value,
            mouseX: _mouseX,
            mouseY: _mouseY,
          ),
        );
      },
    );
  }

  Widget _buildContent(ResponsiveSizingInfo sizingInfo) {
    if (sizingInfo.isMobile) {
      return Column(
        children: [
          _buildTitle(sizingInfo),
          SizedBox(height: 40.h),
          _buildFounderImage(sizingInfo),
          SizedBox(height: 40.h),
          _buildFounderInfo(sizingInfo),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Image
        Expanded(flex: 5, child: _buildFounderImage(sizingInfo)),

        SizedBox(width: sizingInfo.isTablet ? 40.w : 60.w),

        // Right side - Info
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(sizingInfo),
              SizedBox(height: 40.h),
              _buildFounderInfo(sizingInfo),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(ResponsiveSizingInfo sizingInfo) {
    return Column(
      crossAxisAlignment: sizingInfo.isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (widget.isVisible)
          Text(
            'Liderazgo Visionario',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: AppTheme.accentGold,
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),

        SizedBox(height: 8.h),

        Container(
          width: 60.w,
          height: 3.h,
          decoration: BoxDecoration(
            gradient: AppTheme.goldGradient,
            borderRadius: BorderRadius.circular(1.5.r),
          ),
        ).animate(delay: 200.ms).scaleX(begin: 0, end: 1, duration: 400.ms),
      ],
    );
  }

  Widget _buildFounderImage(ResponsiveSizingInfo sizingInfo) {
    final imageSize = sizingInfo.isMobile
        ? 280.w
        : sizingInfo.isTablet
        ? 350.w
        : 450.w;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative circles
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -10 * _floatController.value),
                child: Container(
                  width: imageSize + 100,
                  height: imageSize + 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.accentGold.withOpacity(0.1),
                        AppTheme.accentGold.withOpacity(0.05),
                        Colors.transparent,
                      ],
                      stops: const [0.4, 0.7, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          // Image container with parallax
          Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_isHovered ? 0.03 : 0)
                  ..rotateX(_isHovered ? -0.03 : 0),
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryNavy.withOpacity(0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 20),
                      ),
                      if (_isHovered)
                        BoxShadow(
                          color: AppTheme.accentGold.withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Main image
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: 'assets/images/alfredo.jpg',
                          placeholder: (context, url) =>
                              _buildImagePlaceholder(),
                          errorWidget: (context, url, error) =>
                              _buildFallbackImage(),
                          imageBuilder: (context, imageProvider) {
                            if (!_imageLoaded) {
                              Future.microtask(() {
                                if (mounted)
                                  setState(() => _imageLoaded = true);
                              });
                            }
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 600),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Overlay gradient
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppTheme.primaryNavy.withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),

                      // Glass overlay on hover
                      if (_isHovered)
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ).animate().fadeIn(duration: 300.ms),
                    ],
                  ),
                ),
              )
              .animate(target: widget.isVisible ? 1 : 0)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 800.ms,
                curve: Curves.easeOutBack,
              )
              .fadeIn(duration: 600.ms),

          // Professional badge
          if (_imageLoaded)
            Positioned(
              bottom: 20,
              right: sizingInfo.isMobile ? null : 20,
              child: _buildProfessionalBadge(),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return ShimmerContainer(
      width: double.infinity,
      height: double.infinity,
      borderRadius: BorderRadius.circular(1000),
      baseColor: AppTheme.divider,
      highlightColor: AppTheme.divider.withOpacity(0.5),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryNavy.withOpacity(0.1),
            AppTheme.primaryNavy.withOpacity(0.2),
          ],
        ),
      ),
      child: Center(
        child: Icon(Icons.person, size: 100.sp, color: AppTheme.primaryNavy),
      ),
    );
  }

  Widget _buildProfessionalBadge() {
    return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: AppTheme.goldGradient,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentGold.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified, size: 16.sp, color: Colors.white),
              SizedBox(width: 6.w),
              Text(
                'CEO & Fundador',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
        .animate(delay: 800.ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.5, end: 0);
  }

  Widget _buildFounderInfo(ResponsiveSizingInfo sizingInfo) {
    return Column(
      crossAxisAlignment: sizingInfo.isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // Name and title
        _buildNameTitle(sizingInfo),

        SizedBox(height: 32.h),

        // Quote with glass effect
        _buildQuoteSection(sizingInfo),

        SizedBox(height: 40.h),

        // Achievements
        _buildAchievements(sizingInfo),

        SizedBox(height: 40.h),

        // Social links
        _buildSocialLinks(sizingInfo),
      ],
    );
  }

  Widget _buildNameTitle(ResponsiveSizingInfo sizingInfo) {
    return Column(
      crossAxisAlignment: sizingInfo.isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (widget.isVisible)
          Text(
                'Lic. Alfredo Delgadillo López',
                style: TextStyle(
                  fontSize: sizingInfo.isMobile ? 28.sp : 36.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryNavy,
                ),
                textAlign: sizingInfo.isMobile
                    ? TextAlign.center
                    : TextAlign.start,
              )
              .animate()
              .fadeIn(duration: 800.ms, delay: 200.ms)
              .slideX(begin: sizingInfo.isMobile ? 0 : -0.1, end: 0),

        SizedBox(height: 12.h),

        if (widget.isVisible)
          Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryNavy.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: AppTheme.primaryNavy.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16.sp,
                      color: AppTheme.textSecondary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Ciudad de México, México',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 400.ms)
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
      ],
    );
  }

  Widget _buildQuoteSection(ResponsiveSizingInfo sizingInfo) {
    return AnimatedGlassContainer(
      animate: _quoteVisible,
      blur: 20,
      opacity: 0.05,
      padding: EdgeInsets.all(sizingInfo.isMobile ? 24.w : 32.w),
      borderRadius: BorderRadius.circular(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              .animate(target: _quoteVisible ? 1 : 0)
              .rotate(duration: 500.ms, end: 0.1)
              .fadeIn(),

          SizedBox(height: 20.h),

          // Quote text with typewriter effect
          if (_quoteVisible)
            AnimatedDefaultTextStyle(
                  style: TextStyle(
                    fontSize: sizingInfo.isMobile ? 15.sp : 17.sp,
                    color: AppTheme.textPrimary,
                    fontStyle: FontStyle.italic,
                    height: 1.7,
                  ),
                  duration: const Duration(milliseconds: 300),
                  child: SelectableText(
                    'Las posibles vulneraciones a derechos fundamentales por el uso de tecnologías quedan limitadas cuando se implementan como marco los principios generales del derecho administrativo; y los problemas del derecho administrativo, son mitigados cuando se utilizan tecnologías. Se complementan.\n\nPor lo tanto, la clave para implementar las tecnologías digitales más avanzadas de manera continua sin sacrificar el interés general ni vulnerar derechos fundamentales es advertir los problemas que genera el lenguaje con que está construido el derecho administrativo.',
                    textAlign: sizingInfo.isMobile
                        ? TextAlign.center
                        : TextAlign.start,
                  ),
                )
                .animate()
                .fadeIn(duration: 1000.ms, delay: 300.ms)
                .slideY(begin: 0.1, end: 0),

          SizedBox(height: 16.h),

          // Author signature
          Align(
                alignment: sizingInfo.isMobile
                    ? Alignment.center
                    : Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: AppTheme.accentGold, width: 3),
                    ),
                  ),
                  child: Text(
                    '— Alfredo Delgadillo',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentGold,
                    ),
                  ),
                ),
              )
              .animate(target: _quoteVisible ? 1 : 0, delay: 800.ms)
              .fadeIn()
              .slideX(begin: 0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildAchievements(ResponsiveSizingInfo sizingInfo) {
    final achievements = [
      {'icon': Icons.school, 'value': '20+', 'label': 'Años de\nExperiencia'},
      {'icon': Icons.emoji_events, 'value': '500+', 'label': 'Casos\nGanados'},
      {'icon': Icons.groups, 'value': '50+', 'label': 'Clientes\nCorporativos'},
      {
        'icon': Icons.article,
        'value': '30+',
        'label': 'Publicaciones\nAcadémicas',
      },
    ];

    return Column(
      crossAxisAlignment: sizingInfo.isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Trayectoria Destacada',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryNavy,
          ),
        ),

        SizedBox(height: 24.h),

        Wrap(
          spacing: sizingInfo.isMobile ? 16.w : 24.w,
          runSpacing: 16.h,
          alignment: sizingInfo.isMobile
              ? WrapAlignment.center
              : WrapAlignment.start,
          children: achievements.asMap().entries.map((entry) {
            return _AchievementCard(
              icon: entry.value['icon'] as IconData,
              value: entry.value['value'] as String,
              label: entry.value['label'] as String,
              delay: entry.key * 100,
              isVisible: widget.isVisible,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSocialLinks(ResponsiveSizingInfo sizingInfo) {
    final socialLinks = [
      {'icon': Icons.link, 'url': 'https://linkedin.com', 'label': 'LinkedIn'},
      {
        'icon': Icons.email,
        'url': 'mailto:alfredo@justicia.mx',
        'label': 'Email',
      },
      {'icon': Icons.article, 'url': '#', 'label': 'Blog'},
    ];

    return Row(
      mainAxisAlignment: sizingInfo.isMobile
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: socialLinks.asMap().entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: _SocialButton(
            icon: entry.value['icon'] as IconData,
            url: entry.value['url'] as String,
            label: entry.value['label'] as String,
            delay: entry.key * 100,
            isVisible: widget.isVisible,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDecorativeElements() {
    return Stack(
      children: [
        // Floating legal icon
        Positioned(
          top: 100.h,
          left: 50.w,
          child: FloatingContainer(
            floatDistance: 20,
            duration: const Duration(seconds: 4),
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.gavel,
                size: 60.sp,
                color: AppTheme.primaryNavy,
              ),
            ),
          ),
        ),

        // Floating tech icon
        Positioned(
          bottom: 100.h,
          right: 50.w,
          child: FloatingContainer(
            floatDistance: 15,
            duration: const Duration(seconds: 5),
            child: Opacity(
              opacity: 0.1,
              child: Icon(Icons.memory, size: 50.sp, color: AppTheme.techBlue),
            ),
          ),
        ),
      ],
    );
  }
}

// Achievement card widget
class _AchievementCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final int delay;
  final bool isVisible;

  const _AchievementCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.delay,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 120.w,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryNavy.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 28.sp, color: AppTheme.accentGold),
              SizedBox(height: 8.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryNavy,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppTheme.textSecondary,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
        .animate(delay: delay.ms, target: isVisible ? 1 : 0)
        .fadeIn(duration: 500.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }
}

// Social button widget
class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String url;
  final String label;
  final int delay;
  final bool isVisible;

  const _SocialButton({
    required this.icon,
    required this.url,
    required this.label,
    required this.delay,
    required this.isVisible,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.identity()
              ..translate(0.0, _isHovered ? -5.0 : 0.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Launch URL
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? AppTheme.primaryNavy
                        : AppTheme.primaryNavy.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppTheme.primaryNavy.withOpacity(0.1),
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 20.sp,
                    color: _isHovered ? Colors.white : AppTheme.primaryNavy,
                  ),
                ),
              ),
            ),
          ),
        )
        .animate(delay: widget.delay.ms, target: widget.isVisible ? 1 : 0)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.3, end: 0);
  }
}

// Custom painter for background
class FounderBackgroundPainter extends CustomPainter {
  final double animation;
  final double mouseX;
  final double mouseY;

  FounderBackgroundPainter({
    required this.animation,
    required this.mouseX,
    required this.mouseY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // Draw animated circles
    for (int i = 0; i < 5; i++) {
      final progress = (animation + i * 0.2) % 1.0;
      final radius = 50 + progress * 200;
      final opacity = (1 - progress) * 0.05;

      paint.color = AppTheme.accentGold.withOpacity(opacity);

      canvas.drawCircle(
        Offset(
          size.width * 0.8 + mouseX * 0.02,
          size.height * 0.3 + mouseY * 0.02,
        ),
        radius,
        paint,
      );
    }

    // Draw geometric patterns
    final patternPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppTheme.primaryNavy.withOpacity(0.03);

    for (int i = 0; i < 10; i++) {
      final y = size.height * (i / 10);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), patternPaint);
    }
  }

  @override
  bool shouldRepaint(FounderBackgroundPainter oldDelegate) {
    return animation != oldDelegate.animation ||
        mouseX != oldDelegate.mouseX ||
        mouseY != oldDelegate.mouseY;
  }
}
