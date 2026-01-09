import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glass/glass.dart';
import 'package:justicia_administrativa_web/core/theme/app_theme.dart';

/// A collection of reusable animated container widgets for the application
library animated_containers;

/// Base animated container with customizable properties
class AnimatedGradientContainer extends StatefulWidget {
  final Widget child;
  final List<Color>? gradientColors;
  final Duration animationDuration;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final List<BoxShadow>? boxShadow;
  final bool animate;
  final VoidCallback? onTap;

  const AnimatedGradientContainer({
    super.key,
    required this.child,
    this.gradientColors,
    this.animationDuration = const Duration(seconds: 3),
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.constraints,
    this.boxShadow,
    this.animate = true,
    this.onTap,
  });

  @override
  State<AnimatedGradientContainer> createState() => 
      _AnimatedGradientContainerState();
}

class _AnimatedGradientContainerState extends State<AnimatedGradientContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultColors = [
      AppTheme.primaryNavy,
      AppTheme.primaryNavy.withBlue(200),
      AppTheme.techBlue,
    ];

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            constraints: widget.constraints,
            margin: widget.margin,
            padding: widget.padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1 + 2 * _animation.value, -1),
                end: Alignment(1 - 2 * _animation.value, 1),
                colors: widget.gradientColors ?? defaultColors,
              ),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(16.r),
              boxShadow: widget.boxShadow,
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// Pulsing container for emphasis
class PulsingContainer extends StatefulWidget {
  final Widget child;
  final Color? pulseColor;
  final Duration duration;
  final double maxScale;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  
  const PulsingContainer({
    super.key,
    required this.child,
    this.pulseColor,
    this.duration = const Duration(milliseconds: 1500),
    this.maxScale = 1.05,
    this.padding,
    this.borderRadius,
  });

  @override
  State<PulsingContainer> createState() => _PulsingContainerState();
}

class _PulsingContainerState extends State<PulsingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.5,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulsing background
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: (widget.pulseColor ?? AppTheme.accentGold)
                      .withOpacity(_opacityAnimation.value),
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(12.r),
                ),
                child: Opacity(
                  opacity: 0,
                  child: widget.child,
                ),
              ),
            );
          },
        ),
        // Main content
        Container(
          padding: widget.padding,
          child: widget.child,
        ),
      ],
    );
  }
}

/// Morphing shape container
class MorphingContainer extends StatefulWidget {
  final Widget child;
  final List<BorderRadius> borderRadiusList;
  final Duration duration;
  final List<Color>? colors;
  final EdgeInsets? padding;
  final double? width;
  final double? height;

  const MorphingContainer({
    super.key,
    required this.child,
    this.borderRadiusList = const [],
    this.duration = const Duration(seconds: 3),
    this.colors,
    this.padding,
    this.width,
    this.height,
  });

  @override
  State<MorphingContainer> createState() => _MorphingContainerState();
}

class _MorphingContainerState extends State<MorphingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<BorderRadius> _radiusList;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _radiusList = widget.borderRadiusList.isNotEmpty
        ? widget.borderRadiusList
        : [
            BorderRadius.circular(20.r),
            BorderRadius.circular(40.r),
            BorderRadius.only(
              topLeft: Radius.circular(40.r),
              bottomRight: Radius.circular(40.r),
            ),
            BorderRadius.only(
              topRight: Radius.circular(40.r),
              bottomLeft: Radius.circular(40.r),
            ),
          ];

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _radiusList.length;
        });
        _controller.forward(from: 0);
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors ??
        [
          AppTheme.primaryNavy.withOpacity(0.1),
          AppTheme.techBlue.withOpacity(0.1),
        ];

    return AnimatedContainer(
      duration: widget.duration,
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: _radiusList[_currentIndex],
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: widget.child,
    );
  }
}

/// Shimmer loading container
class ShimmerContainer extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<ShimmerContainer> createState() => _ShimmerContainerState();
}

class _ShimmerContainerState extends State<ShimmerContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? AppTheme.divider;
    final highlightColor = 
        widget.highlightColor ?? AppTheme.divider.withOpacity(0.5);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Glassmorphic animated container
class AnimatedGlassContainer extends StatefulWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Duration duration;
  final bool animate;
  final VoidCallback? onTap;

  const AnimatedGlassContainer({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.1,
    this.borderRadius,
    this.padding,
    this.margin,
    this.duration = const Duration(seconds: 2),
    this.animate = true,
    this.onTap,
  });

  @override
  State<AnimatedGlassContainer> createState() => 
      _AnimatedGlassContainerState();
}

class _AnimatedGlassContainerState extends State<AnimatedGlassContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _blurAnimation = Tween<double>(
      begin: widget.blur * 0.8,
      end: widget.blur * 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            margin: widget.margin,
            padding: widget.padding,
            child: widget.child,
          ).asGlass(
            tintColor: Colors.white.withOpacity(widget.opacity),
            clipBorderRadius: widget.borderRadius ?? BorderRadius.circular(16.r),
            blur: _blurAnimation.value,
          );
        },
      ),
    );
  }
}

/// Parallax container for scroll effects
class ParallaxContainer extends StatelessWidget {
  final Widget child;
  final double offset;
  final double speed;
  final Alignment alignment;

  const ParallaxContainer({
    super.key,
    required this.child,
    required this.offset,
    this.speed = 0.5,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, offset * speed),
      child: Align(
        alignment: alignment,
        child: child,
      ),
    );
  }
}

/// Reveal container with slide effect
class RevealContainer extends StatelessWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;
  final Curve curve;
  final Axis direction;
  final double distance;

  const RevealContainer({
    super.key,
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic,
    this.direction = Axis.vertical,
    this.distance = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: duration,
      opacity: isVisible ? 1.0 : 0.0,
      curve: curve,
      child: AnimatedSlide(
        duration: duration,
        offset: isVisible
            ? Offset.zero
            : direction == Axis.vertical
                ? Offset(0, distance)
                : Offset(distance, 0),
        curve: curve,
        child: child,
      ),
    );
  }
}

/// Floating action container with bob animation
class FloatingContainer extends StatefulWidget {
  final Widget child;
  final double floatDistance;
  final Duration duration;

  const FloatingContainer({
    super.key,
    required this.child,
    this.floatDistance = 10,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<FloatingContainer> createState() => _FloatingContainerState();
}

class _FloatingContainerState extends State<FloatingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.floatDistance,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_animation.value),
          child: widget.child,
        );
      },
    );
  }
}

/// Expandable container with smooth animation
class ExpandableContainer extends StatelessWidget {
  final Widget child;
  final Widget? expandedChild;
  final bool isExpanded;
  final Duration duration;
  final Curve curve;
  final EdgeInsets? padding;
  final Decoration? decoration;

  const ExpandableContainer({
    super.key,
    required this.child,
    this.expandedChild,
    required this.isExpanded,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.padding,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      padding: padding,
      decoration: decoration,
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: curve,
        switchOutCurve: curve,
        child: isExpanded ? (expandedChild ?? child) : child,
      ),
    );
  }
}