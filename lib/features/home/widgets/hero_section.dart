import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:justicia_administrativa_web/core/theme/app_theme.dart';
import 'package:justicia_administrativa_web/shared/widgets/responsive_builder.dart';
import 'package:justicia_administrativa_web/shared/widgets/animated_button.dart';
import 'package:lottie/lottie.dart';

class HeroSection extends StatefulWidget {
  final ScrollController scrollController;
  final bool isVisible;

  const HeroSection({
    super.key,
    required this.scrollController,
    required this.isVisible,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _parallaxController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _parallaxController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    widget.scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    setState(() {
      _scrollOffset = widget.scrollController.offset;
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_handleScroll);
    _parallaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final heroHeight = sizingInfo.isMobile
            ? MediaQuery.of(context).size.height * 0.9
            : sizingInfo.isTablet
            ? MediaQuery.of(context).size.height * 0.8
            : 700.h;

        return SizedBox(
          height: heroHeight,
          width: double.infinity,
          child: Stack(
            children: [
              // Parallax background
              Positioned(
                top: -_scrollOffset * 0.5,
                left: 0,
                right: 0,
                height: heroHeight + 100,
                child: _buildBackground(),
              ),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),

              // Content
              Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 1200.w),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: _buildContent(sizingInfo),
                ),
              ),

              // Floating elements
              if (!sizingInfo.isMobile) _buildFloatingElements(),

              // Scroll indicator
              if (widget.isVisible)
                Positioned(
                  bottom: 32.h,
                  left: 0,
                  right: 0,
                  child: _buildScrollIndicator(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryNavy,
                AppTheme.primaryNavy.withBlue(180),
              ],
            ),
          ),
        ),

        // Animated mesh gradient
        Positioned.fill(
          child: CustomPaint(
            painter: MeshGradientPainter(scrollOffset: _scrollOffset),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(ResponsiveSizingInfo sizingInfo) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated title
        if (widget.isVisible)
          SizedBox(
            height: sizingInfo.isMobile ? 120.h : 150.h,
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: sizingInfo.isMobile ? 28.sp : 48.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Transformando el Derecho\nAdministrativo Mexicano con\nInteligencia Artificial',
                    textAlign: TextAlign.center,
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
              ),
            ),
          ).animate().fadeIn(duration: 1000.ms).slideY(begin: 0.2, end: 0),

        SizedBox(height: 24.h),

        // Subtitle with glass effect
        Container(
              padding: EdgeInsets.all(16.w),
              child: Text(
                'Con un equipo multidisciplinario conformado por juristas referentes en Iberoamérica y expertos en tecnologías digitales.',
                style: TextStyle(
                  fontSize: sizingInfo.isMobile ? 14.sp : 18.sp,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            )
            .asGlass(
              tintColor: Colors.white,
              clipBorderRadius: BorderRadius.circular(12.r),
              blur: 10,
            )
            .animate(delay: 500.ms)
            .fadeIn(duration: 800.ms)
            .slideY(begin: 0.2, end: 0),

        SizedBox(height: 48.h),

        // CTA Buttons
        _buildCTAButtons(sizingInfo)
            .animate(delay: 800.ms)
            .fadeIn(duration: 800.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildCTAButtons(ResponsiveSizingInfo sizingInfo) {
    final buttons = [
      AnimatedButton(
        onPressed: () {
          // Navigate to consultation
        },
        child: Text(
          'Consulta Legal',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        gradient: const LinearGradient(
          colors: [AppTheme.accentGold, AppTheme.accentGoldLight],
        ),
        borderRadius: BorderRadius.circular(30.r),
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
      ),
      SizedBox(
        width: sizingInfo.isMobile ? 0 : 16.w,
        height: sizingInfo.isMobile ? 16.h : 0,
      ),
      AnimatedButton(
        onPressed: () {
          // Navigate to AI demo
        },
        child: Text(
          'Demo IA',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        isOutlined: true,
        borderColor: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
      ),
    ];

    return sizingInfo.isMobile
        ? Column(children: buttons)
        : Row(mainAxisAlignment: MainAxisAlignment.center, children: buttons);
  }

  Widget _buildFloatingElements() {
    return Stack(
      children: [
        // Floating legal icon
        Positioned(
          top: 100.h,
          left: 50.w,
          child:
              Lottie.asset(
                    'assets/animations/legal_float.json',
                    width: 100.w,
                    height: 100.h,
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .rotate(duration: 10.seconds)
                  .fadeIn(),
        ),

        // Floating tech icon
        Positioned(
          bottom: 150.h,
          right: 50.w,
          child:
              Lottie.asset(
                    'assets/animations/tech_float.json',
                    width: 120.w,
                    height: 120.h,
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .rotate(
                    duration: 12.seconds,
                    direction: RotateDirection.counterClockwise,
                  )
                  .fadeIn(),
        ),
      ],
    );
  }

  Widget _buildScrollIndicator() {
    return Column(
      children: [
        Text(
          'Scroll para descubrir más',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white.withOpacity(0.7),
              size: 24.sp,
            )
            .animate(onPlay: (controller) => controller.repeat())
            .slideY(
              begin: 0,
              end: 0.3,
              duration: 1.seconds,
              curve: Curves.easeInOut,
            )
            .fadeOut(begin: 1, end: 0),
      ],
    );
  }
}

// Custom painter for animated mesh gradient
class MeshGradientPainter extends CustomPainter {
  final double scrollOffset;

  MeshGradientPainter({required this.scrollOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [AppTheme.accentGold.withOpacity(0.1), Colors.transparent],
        center: Alignment(
          -0.5 + (scrollOffset * 0.001),
          -0.5 + (scrollOffset * 0.001),
        ),
        radius: 1.5,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(MeshGradientPainter oldDelegate) {
    return oldDelegate.scrollOffset != scrollOffset;
  }
}
