import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:justicia_administrativa_web/core/theme/app_theme.dart';
import 'package:justicia_administrativa_web/shared/widgets/responsive_builder.dart';
import 'dart:math' as math;

class LoadingSkeleton extends StatefulWidget {
  final SkeletonType type;
  final int itemCount;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final bool showAnimation;

  const LoadingSkeleton({
    super.key,
    this.type = SkeletonType.page,
    this.itemCount = 1,
    this.height,
    this.width,
    this.padding,
    this.showAnimation = true,
  });

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        switch (widget.type) {
          case SkeletonType.page:
            return _buildPageSkeleton(sizingInfo);
          case SkeletonType.card:
            return _buildCardSkeleton(sizingInfo);
          case SkeletonType.list:
            return _buildListSkeleton(sizingInfo);
          case SkeletonType.grid:
            return _buildGridSkeleton(sizingInfo);
          case SkeletonType.profile:
            return _buildProfileSkeleton(sizingInfo);
          case SkeletonType.article:
            return _buildArticleSkeleton(sizingInfo);
          case SkeletonType.custom:
            return _buildCustomSkeleton();
        }
      },
    );
  }

  Widget _buildPageSkeleton(ResponsiveSizingInfo sizingInfo) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero skeleton
          _HeroSkeleton(
            shimmerController: _shimmerController,
            sizingInfo: sizingInfo,
          ),

          SizedBox(height: 40.h),

          // Content sections
          ..._buildContentSections(sizingInfo),
        ],
      ),
    );
  }

  Widget _buildCardSkeleton(ResponsiveSizingInfo sizingInfo) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 200.h,
      padding: widget.padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: AppTheme.divider,
        highlightColor: AppTheme.divider.withOpacity(0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 16.h),

            // Title
            Container(
              height: 20.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 12.h),

            // Subtitle
            Container(
              height: 14.h,
              width: sizingInfo.screenSize.width * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListSkeleton(ResponsiveSizingInfo sizingInfo) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.itemCount,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        return _ListItemSkeleton(
          shimmerController: _shimmerController,
          index: index,
          sizingInfo: sizingInfo,
        );
      },
    );
  }

  Widget _buildGridSkeleton(ResponsiveSizingInfo sizingInfo) {
    final crossAxisCount = sizingInfo.isMobile
        ? 2
        : sizingInfo.isTablet
        ? 3
        : 4;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.8,
      ),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return _GridItemSkeleton(
          shimmerController: _shimmerController,
          index: index,
        );
      },
    );
  }

  Widget _buildProfileSkeleton(ResponsiveSizingInfo sizingInfo) {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          // Avatar
          Shimmer.fromColors(
            baseColor: AppTheme.divider,
            highlightColor: AppTheme.divider.withOpacity(0.5),
            child: CircleAvatar(radius: 60.r, backgroundColor: Colors.white),
          ),

          SizedBox(height: 24.h),

          // Name
          Shimmer.fromColors(
            baseColor: AppTheme.divider,
            highlightColor: AppTheme.divider.withOpacity(0.5),
            child: Container(
              height: 24.h,
              width: 200.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // Bio
          Shimmer.fromColors(
            baseColor: AppTheme.divider,
            highlightColor: AppTheme.divider.withOpacity(0.5),
            child: Container(
              height: 16.h,
              width: 300.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),

          SizedBox(height: 40.h),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              return _StatSkeleton(
                shimmerController: _shimmerController,
                delay: index * 100,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleSkeleton(ResponsiveSizingInfo sizingInfo) {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Shimmer.fromColors(
            baseColor: AppTheme.divider,
            highlightColor: AppTheme.divider.withOpacity(0.5),
            child: Container(
              height: 32.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Metadata
          Row(
            children: [
              Shimmer.fromColors(
                baseColor: AppTheme.divider,
                highlightColor: AppTheme.divider.withOpacity(0.5),
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: AppTheme.divider,
                    highlightColor: AppTheme.divider.withOpacity(0.5),
                    child: Container(
                      height: 14.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Shimmer.fromColors(
                    baseColor: AppTheme.divider,
                    highlightColor: AppTheme.divider.withOpacity(0.5),
                    child: Container(
                      height: 12.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 32.h),

          // Content paragraphs
          ...List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _ParagraphSkeleton(
                shimmerController: _shimmerController,
                lines: index == 0 ? 3 : math.Random().nextInt(4) + 2,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCustomSkeleton() {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      child: Shimmer.fromColors(
        baseColor: AppTheme.divider,
        highlightColor: AppTheme.divider.withOpacity(0.5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContentSections(ResponsiveSizingInfo sizingInfo) {
    return [
      // Features section
      Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            _SectionHeaderSkeleton(shimmerController: _shimmerController),
            SizedBox(height: 32.h),
            _buildGridSkeleton(sizingInfo),
          ],
        ),
      ),

      SizedBox(height: 60.h),

      // About section
      Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          children: [
            if (!sizingInfo.isMobile)
              Expanded(
                child: _ImageSkeleton(
                  shimmerController: _shimmerController,
                  height: 300.h,
                ),
              ),
            if (!sizingInfo.isMobile) SizedBox(width: 40.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeaderSkeleton(shimmerController: _shimmerController),
                  SizedBox(height: 24.h),
                  _ParagraphSkeleton(
                    shimmerController: _shimmerController,
                    lines: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }
}

enum SkeletonType { page, card, list, grid, profile, article, custom }

// Hero Skeleton Component
class _HeroSkeleton extends StatelessWidget {
  final AnimationController shimmerController;
  final ResponsiveSizingInfo sizingInfo;

  const _HeroSkeleton({
    required this.shimmerController,
    required this.sizingInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizingInfo.isMobile ? 400.h : 600.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryNavy.withOpacity(0.05),
            AppTheme.primaryNavy.withOpacity(0.02),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title skeleton
          Shimmer.fromColors(
            baseColor: AppTheme.divider,
            highlightColor: AppTheme.divider.withOpacity(0.5),
            child: Container(
              height: 48.h,
              width: sizingInfo.isMobile ? 300.w : 600.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // Subtitle skeleton
          Shimmer.fromColors(
            baseColor: AppTheme.divider,
            highlightColor: AppTheme.divider.withOpacity(0.5),
            child: Container(
              height: 20.h,
              width: sizingInfo.isMobile ? 250.w : 400.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),

          SizedBox(height: 40.h),

          // Buttons skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ButtonSkeleton(shimmerController: shimmerController),
              SizedBox(width: 16.w),
              _ButtonSkeleton(shimmerController: shimmerController),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }
}

// List Item Skeleton
class _ListItemSkeleton extends StatelessWidget {
  final AnimationController shimmerController;
  final int index;
  final ResponsiveSizingInfo sizingInfo;

  const _ListItemSkeleton({
    required this.shimmerController,
    required this.index,
    required this.sizingInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar
              Shimmer.fromColors(
                baseColor: AppTheme.divider,
                highlightColor: AppTheme.divider.withOpacity(0.5),
                child: CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Colors.white,
                ),
              ),

              SizedBox(width: 16.w),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppTheme.divider,
                      highlightColor: AppTheme.divider.withOpacity(0.5),
                      child: Container(
                        height: 16.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Shimmer.fromColors(
                      baseColor: AppTheme.divider,
                      highlightColor: AppTheme.divider.withOpacity(0.5),
                      child: Container(
                        height: 14.h,
                        width: sizingInfo.screenSize.width * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate(delay: (index * 100).ms)
        .fadeIn(duration: 500.ms)
        .slideX(begin: 0.1, end: 0);
  }
}

// Grid Item Skeleton
class _GridItemSkeleton extends StatelessWidget {
  final AnimationController shimmerController;
  final int index;

  const _GridItemSkeleton({
    required this.shimmerController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Image
              Shimmer.fromColors(
                baseColor: AppTheme.divider,
                highlightColor: AppTheme.divider.withOpacity(0.5),
                child: Container(
                  height: 150.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppTheme.divider,
                      highlightColor: AppTheme.divider.withOpacity(0.5),
                      child: Container(
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Shimmer.fromColors(
                      baseColor: AppTheme.divider,
                      highlightColor: AppTheme.divider.withOpacity(0.5),
                      child: Container(
                        height: 12.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate(delay: (index * 50).ms)
        .fadeIn(duration: 500.ms)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }
}

// Helper Skeleton Components
class _ButtonSkeleton extends StatelessWidget {
  final AnimationController shimmerController;

  const _ButtonSkeleton({required this.shimmerController});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.divider,
      highlightColor: AppTheme.divider.withOpacity(0.5),
      child: Container(
        height: 48.h,
        width: 120.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
      ),
    );
  }
}

class _SectionHeaderSkeleton extends StatelessWidget {
  final AnimationController shimmerController;

  const _SectionHeaderSkeleton({required this.shimmerController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: AppTheme.divider,
          highlightColor: AppTheme.divider.withOpacity(0.5),
          child: Container(
            height: 32.h,
            width: 250.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Shimmer.fromColors(
          baseColor: AppTheme.divider,
          highlightColor: AppTheme.divider.withOpacity(0.5),
          child: Container(
            height: 4.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ),
      ],
    );
  }
}

class _ParagraphSkeleton extends StatelessWidget {
  final AnimationController shimmerController;
  final int lines;

  const _ParagraphSkeleton({required this.shimmerController, this.lines = 3});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final isLast = index == lines - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Shimmer.fromColors(
            baseColor: AppTheme.divider,
            highlightColor: AppTheme.divider.withOpacity(0.5),
            child: Container(
              height: 14.h,
              width: isLast ? 200.w : double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ImageSkeleton extends StatelessWidget {
  final AnimationController shimmerController;
  final double height;

  const _ImageSkeleton({required this.shimmerController, required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.divider,
      highlightColor: AppTheme.divider.withOpacity(0.5),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }
}

class _StatSkeleton extends StatelessWidget {
  final AnimationController shimmerController;
  final int delay;

  const _StatSkeleton({required this.shimmerController, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Shimmer.fromColors(
              baseColor: AppTheme.divider,
              highlightColor: AppTheme.divider.withOpacity(0.5),
              child: Container(
                height: 32.h,
                width: 60.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Shimmer.fromColors(
              baseColor: AppTheme.divider,
              highlightColor: AppTheme.divider.withOpacity(0.5),
              child: Container(
                height: 14.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ],
        )
        .animate(delay: delay.ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.2, end: 0);
  }
}
