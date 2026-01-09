import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:justicia_administrativa_web/core/theme/app_theme.dart';
import 'package:justicia_administrativa_web/shared/widgets/responsive_builder.dart';
import 'package:justicia_administrativa_web/shared/widgets/animated_container.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DualExpertiseSection extends StatefulWidget {
  final bool isVisible;
  
  const DualExpertiseSection({
    super.key,
    required this.isVisible,
  });

  @override
  State<DualExpertiseSection> createState() => _DualExpertiseSectionState();
}

class _DualExpertiseSectionState extends State<DualExpertiseSection> 
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  bool _cardsVisible = false;
  int _hoveredCard = -1;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Delay card visibility for stagger effect
    if (widget.isVisible) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() => _cardsVisible = true);
        }
      });
    }
  }

  @override
  void didUpdateWidget(DualExpertiseSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() => _cardsVisible = true);
        }
      });
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.background,
            AppTheme.background.withBlue(250),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: _buildBackgroundPattern(),
          ),
          
          // Main Content
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 1200.w),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  // Section Header
                  _buildSectionHeader(),
                  
                  SizedBox(height: 56.h),
                  
                  // Expertise Cards
                  ResponsiveBuilder(
                    builder: (context, sizingInfo) {
                      return _buildExpertiseCards(sizingInfo);
                    },
                  ),
                  
                  SizedBox(height: 48.h),
                  
                  // Connection Visual
                  if (widget.isVisible)
                    _buildConnectionVisual(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return CustomPaint(
          painter: GeometricPatternPainter(
            rotation: _rotationController.value * 2 * 3.14159,
            primaryColor: AppTheme.primaryNavy.withOpacity(0.03),
            secondaryColor: AppTheme.techBlue.withOpacity(0.02),
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
            'Nuestra Propuesta de Valor',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: AppTheme.accentGold,
            ),
          )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
        
        SizedBox(height: 16.h),
        
        if (widget.isVisible)
          Text(
            'Excelencia Legal + Innovación Tecnológica',
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryNavy,
              height: 1.2,
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
        )
          .animate(delay: 400.ms)
          .scaleX(begin: 0, end: 1, duration: 600.ms),
        
        SizedBox(height: 24.h),
        
        if (widget.isVisible)
          Container(
            constraints: BoxConstraints(maxWidth: 600.w),
            child: Text(
              'Combinamos décadas de experiencia en derecho administrativo con las últimas tecnologías de inteligencia artificial para ofrecer soluciones jurídicas más eficientes, precisas y accesibles.',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          )
            .animate(delay: 600.ms)
            .fadeIn(duration: 800.ms),
      ],
    );
  }

  Widget _buildExpertiseCards(ResponsiveSizingInfo sizingInfo) {
    final cards = [
      _ExpertiseCardData(
        title: 'Excelencia Legal Tradicional',
        subtitle: 'Más de 20 años de experiencia',
        description: 'Ofrecemos servicios jurídicos de primer nivel con abogados especializados en derecho administrativo mexicano, respaldados por décadas de experiencia y un historial comprobado de éxito.',
        icon: Icons.gavel,
        iconColor: AppTheme.primaryNavy,
        gradientColors: [
          AppTheme.primaryNavy.withOpacity(0.1),
          AppTheme.primaryNavy.withOpacity(0.05),
        ],
        features: [
          'Amplia experiencia en tribunales administrativos',
          'Asesoría especializada en regulación mexicana',
          'Representación legal ante autoridades federales',
          'Estrategias legales personalizadas',
        ],
        stats: [
          {'label': 'Casos Ganados', 'value': '500+'},
          {'label': 'Años de Experiencia', 'value': '20+'},
          {'label': 'Clientes Satisfechos', 'value': '95%'},
        ],
        animationAsset: 'assets/animations/legal_excellence.json',
      ),
      _ExpertiseCardData(
        title: 'Innovación Tecnológica',
        subtitle: 'IA de última generación',
        description: 'Integramos tecnologías de inteligencia artificial y aprendizaje automático para revolucionar la práctica legal, ofreciendo soluciones más rápidas, precisas y eficientes.',
        icon: Icons.psychology,
        iconColor: AppTheme.techBlue,
        gradientColors: [
          AppTheme.techBlue.withOpacity(0.1),
          AppTheme.techBlue.withOpacity(0.05),
        ],
        features: [
          'Análisis automatizado de documentos legales',
          'Modelos de IA entrenados en leyes mexicanas',
          'Monitoreo regulatorio en tiempo real',
          'Predicción de resultados judiciales',
        ],
        stats: [
          {'label': 'Documentos Procesados', 'value': '10K+'},
          {'label': 'Precisión IA', 'value': '98%'},
          {'label': 'Tiempo Ahorrado', 'value': '70%'},
        ],
        animationAsset: 'assets/animations/tech_innovation.json',
      ),
    ];

    if (sizingInfo.isMobile) {
      return Column(
        children: cards.asMap().entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: 24.h),
            child: _buildExpertiseCard(
              entry.value,
              entry.key,
              sizingInfo,
            ),
          );
        }).toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cards.asMap().entries.map((entry) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: _buildExpertiseCard(
              entry.value,
              entry.key,
              sizingInfo,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExpertiseCard(
    _ExpertiseCardData data,
    int index,
    ResponsiveSizingInfo sizingInfo,
  ) {
    final isHovered = _hoveredCard == index;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredCard = index),
      onExit: (_) => setState(() => _hoveredCard = -1),
      child: VisibilityDetector(
        key: Key('expertise-card-$index'),
        onVisibilityChanged: (info) {
          // Trigger animations when visible
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          transform: Matrix4.identity()
            ..translate(0.0, isHovered ? -10.0 : 0.0)
            ..scale(isHovered ? 1.02 : 1.0),
          child: Container(
            height: sizingInfo.isMobile ? null : 650.h,
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isHovered
                    ? [
                        Colors.white,
                        Colors.white.withOpacity(0.95),
                      ]
                    : [
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.8),
                      ],
              ),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: isHovered
                    ? data.iconColor.withOpacity(0.3)
                    : Colors.white.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isHovered
                      ? data.iconColor.withOpacity(0.15)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: isHovered ? 30 : 20,
                  offset: Offset(0, isHovered ? 15 : 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Icon
                _buildCardHeader(data, isHovered),
                
                SizedBox(height: 24.h),
                
                // Title & Subtitle
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: data.iconColor,
                  ),
                ),
                
                SizedBox(height: 8.h),
                
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.accentGold,
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // Description
                Text(
                  data.description,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppTheme.textSecondary,
                    height: 1.6,
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Features
                ...data.features.asMap().entries.map((entry) {
                  return _buildFeatureItem(
                    entry.value,
                    entry.key,
                    data.iconColor,
                  );
                }).toList(),
                
                const Spacer(),
                
                // Stats
                _buildStats(data.stats, data.iconColor),
              ],
            ),
          ).asGlass(
            tintColor: Colors.white,
            clipBorderRadius: BorderRadius.circular(24.r),
            blur: 10,
          ),
        )
          .animate(
            delay: (index * 200).ms,
            target: _cardsVisible ? 1 : 0,
          )
          .fadeIn(duration: 800.ms)
          .slideY(begin: 0.3, end: 0)
          .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
      ),
    );
  }

  Widget _buildCardHeader(_ExpertiseCardData data, bool isHovered) {
    return Row(
      children: [
        Container(
          width: 72.w,
          height: 72.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: data.gradientColors),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isHovered && data.animationAsset != null)
                Lottie.asset(
                  data.animationAsset,
                  width: 48.w,
                  height: 48.h,
                )
              else
                Icon(
                  data.icon,
                  size: 40.sp,
                  color: data.iconColor,
                ),
            ],
          ),
        )
          .animate(target: isHovered ? 1 : 0)
          .rotate(duration: 400.ms, end: 0.05)
          .scale(end: const Offset(1.1, 1.1)),
        
        const Spacer(),
        
        // Animated badge
        if (isHovered)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 16.sp,
                  color: Colors.white,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Excelencia',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
            .animate()
            .fadeIn(duration: 300.ms)
            .slideX(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildFeatureItem(String feature, int index, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 2.h),
            child: Icon(
              Icons.check_circle,
              size: 18.sp,
              color: AppTheme.accentGold,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    )
      .animate(
        delay: ((index + 3) * 100).ms,
        target: _cardsVisible ? 1 : 0,
      )
      .fadeIn(duration: 500.ms)
      .slideX(begin: -0.1, end: 0);
  }

  Widget _buildStats(List<Map<String, String>> stats, Color color) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.05),
            color.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: color.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((stat) {
          return Expanded(
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1 + (_pulseController.value * 0.05),
                      child: Text(
                        stat['value']!,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 4.h),
                Text(
                  stat['label']!,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildConnectionVisual() {
    return Container(
      height: 120.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Connection Line
          Container(
            height: 2.h,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
            ),
          )
            .animate()
            .scaleX(begin: 0, end: 1, duration: 1000.ms),
          
          // Center Node
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentGold.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.add,
                size: 40.sp,
                color: Colors.white,
              ),
            ),
          )
            .animate(delay: 500.ms)
            .scale(begin: const Offset(0, 0), end: const Offset(1, 1))
            .then()
            .animate(onPlay: (controller) => controller.repeat())
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
              duration: 2.seconds,
              curve: Curves.easeInOut,
            )
            .then()
            .scale(
              begin: const Offset(1.1, 1.1),
              end: const Offset(1, 1),
              duration: 2.seconds,
              curve: Curves.easeInOut,
            ),
          
          // Orbiting Elements
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * 3.14159,
                child: Stack(
                  children: [
                    // Legal Icon Orbit
                    Transform.translate(
                      offset: Offset(150.w, 0),
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryNavy,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.gavel,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    // Tech Icon Orbit
                    Transform.translate(
                      offset: Offset(-150.w, 0),
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: AppTheme.techBlue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.memory,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    )
      .animate(delay: 1000.ms)
      .fadeIn(duration: 800.ms);
  }
}

class _ExpertiseCardData {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color iconColor;
  final List<Color> gradientColors;
  final List<String> features;
  final List<Map<String, String>> stats;
  final String? animationAsset;

  _ExpertiseCardData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.gradientColors,
    required this.features,
    required this.stats,
    this.animationAsset,
  });
}

// Custom Painter for geometric background pattern
class GeometricPatternPainter extends CustomPainter {
  final double rotation;
  final Color primaryColor;
  final Color secondaryColor;

  GeometricPatternPainter({
    required this.rotation,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw rotating hexagon pattern
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width * 0.3;

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 * 3.14159 / 180) + rotation;
      final x1 = centerX + radius * Math.cos(angle);
      final y1 = centerY + radius * Math.sin(angle);
      
      final nextAngle = ((i + 1) * 60 * 3.14159 / 180) + rotation;
      final x2 = centerX + radius * Math.cos(nextAngle);
      final y2 = centerY + radius * Math.sin(nextAngle);

      paint.color = i % 2 == 0 ? primaryColor : secondaryColor;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }

    // Draw inner patterns
    for (double r = radius * 0.3; r < radius; r += radius * 0.2) {
      for (int i = 0; i < 12; i++) {
        final angle = (i * 30 * 3.14159 / 180) - rotation * 0.5;
        final x = centerX + r * Math.cos(angle);
        final y = centerY + r * Math.sin(angle);
        
        paint.color = primaryColor.withOpacity(0.3);
        canvas.drawCircle(Offset(x, y), 2, paint..style = PaintingStyle.fill);
      }
    }
  }

  @override
  bool shouldRepaint(GeometricPatternPainter oldDelegate) {
    return rotation != oldDelegate.rotation;
  }
}

// Required import for math functions
import 'dart:math' as Math;