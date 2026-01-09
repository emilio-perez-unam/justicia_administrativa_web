import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:justicia_administrativa_web/core/theme/app_theme.dart';
import 'package:justicia_administrativa_web/shared/widgets/responsive_builder.dart';
import 'package:justicia_administrativa_web/features/home/models/service_model.dart';

class ServicesSection extends StatelessWidget {
  final List<ServiceModel> services;
  final bool isVisible;

  const ServicesSection({
    super.key,
    required this.services,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80.h),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200.w),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              // Section title with animation
              _buildSectionTitle(context),

              SizedBox(height: 56.h),

              // Services grid
              ResponsiveBuilder(
                builder: (context, sizingInfo) {
                  final crossAxisCount = sizingInfo.isMobile
                      ? 1
                      : sizingInfo.isTablet
                      ? 2
                      : 3;

                  return AnimationLimiter(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 24.w,
                        mainAxisSpacing: 24.h,
                        childAspectRatio: sizingInfo.isMobile ? 1.2 : 0.85,
                      ),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          columnCount: crossAxisCount,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _ServiceCard(
                                service: services[index],
                                index: index,
                                isVisible: isVisible,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Column(
      children: [
        if (isVisible)
          Text(
            'Nuestros Servicios',
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryNavy,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0),

        SizedBox(height: 16.h),

        Container(
          width: 80.w,
          height: 4.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.accentGold, AppTheme.accentGoldLight],
            ),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ).animate(delay: 200.ms).scaleX(begin: 0, end: 1, duration: 600.ms),
      ],
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final ServiceModel service;
  final int index;
  final bool isVisible;

  const _ServiceCard({
    required this.service,
    required this.index,
    required this.isVisible,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -8.0 : 0.0),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppTheme.primaryNavy.withOpacity(0.15)
                    : Colors.black.withOpacity(0.08),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
            border: Border.all(
              color: _isHovered
                  ? AppTheme.accentGold.withOpacity(0.5)
                  : AppTheme.divider,
              width: _isHovered ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon with animation
              _buildIcon(),

              SizedBox(height: 16.h),

              // Title
              AutoSizeText(
                widget.service.title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryNavy,
                ),
                maxLines: 2,
                minFontSize: 16,
              ),

              SizedBox(height: 12.h),

              // Divider
              Container(
                height: 2.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.accentGold,
                      AppTheme.accentGold.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),

              SizedBox(height: 16.h),

              // Features list
              Expanded(child: _buildFeaturesList()),

              SizedBox(height: 16.h),

              // CTA Button
              _buildCTAButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
          width: 56.w,
          height: 56.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryNavy.withOpacity(0.1),
                AppTheme.primaryNavy.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            widget.service.icon,
            size: 32.sp,
            color: AppTheme.primaryNavy,
          ),
        )
        .animate(target: _isHovered ? 1 : 0)
        .rotate(duration: 300.ms, end: 0.05)
        .scale(end: const Offset(1.1, 1.1));
  }

  Widget _buildFeaturesList() {
    final displayFeatures = _isExpanded
        ? widget.service.features
        : widget.service.features.take(3).toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayFeatures.length,
        itemBuilder: (context, index) {
          return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16.sp,
                      color: AppTheme.accentGold,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        displayFeatures[index],
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .animate(delay: (index * 50).ms)
              .fadeIn(duration: 300.ms)
              .slideX(begin: -0.1, end: 0);
        },
      ),
    );
  }

  Widget _buildCTAButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Navigate to service detail
        },
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Conocer más',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryNavy,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.arrow_forward,
                size: 16.sp,
                color: AppTheme.primaryNavy,
              ).animate(target: _isHovered ? 1 : 0).slideX(begin: 0, end: 0.2),
            ],
          ),
        ),
      ),
    );
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }
}
