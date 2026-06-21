import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'components/footer.dart';
import 'components/navbar.dart';
import 'components/shared/command_palette_modal.dart';

enum _LayoutTransitionProfile { mobile, tablet, desktop }

class AppLayout extends StatelessWidget {
  final Widget child;
  final String routeLocation;

  const AppLayout({
    super.key,
    required this.child,
    required this.routeLocation,
  });

  _LayoutTransitionProfile _profileForWidth(double width) {
    if (width < 768) return _LayoutTransitionProfile.mobile;
    if (width < 1200) return _LayoutTransitionProfile.tablet;
    return _LayoutTransitionProfile.desktop;
  }

  Duration _durationForProfile(_LayoutTransitionProfile profile) {
    return switch (profile) {
      _LayoutTransitionProfile.mobile => const Duration(milliseconds: 280),
      _LayoutTransitionProfile.tablet => const Duration(milliseconds: 230),
      _LayoutTransitionProfile.desktop => const Duration(milliseconds: 190),
    };
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final profile = _profileForWidth(screenWidth);

    return CommandPaletteModal(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SelectionArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    _RouteBodyTransition(
                      routeLocation: routeLocation,
                      duration: _durationForProfile(profile),
                      profile: profile,
                      child: child,
                    ),
                    const FooterSection(),
                  ],
                ),
              ),
              const Positioned.fill(child: Navbar()),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteBodyTransition extends StatelessWidget {
  const _RouteBodyTransition({
    required this.routeLocation,
    required this.duration,
    required this.profile,
    required this.child,
  });

  final String routeLocation;
  final Duration duration;
  final _LayoutTransitionProfile profile;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final fillColor = Theme.of(context).scaffoldBackgroundColor;

    return ClipRect(
      child: PageTransitionSwitcher(
        duration: duration,
        reverse: false,
        layoutBuilder: (entries) => Stack(children: entries),
        transitionBuilder: (transitionedChild, primary, secondary) {
          return ColoredBox(
            color: fillColor,
            child: switch (profile) {
              _LayoutTransitionProfile.mobile => _mobileTransition(
                primary,
                secondary,
                transitionedChild,
              ),
              _LayoutTransitionProfile.tablet => _tabletTransition(
                primary,
                secondary,
                transitionedChild,
                fillColor,
              ),
              _LayoutTransitionProfile.desktop => _desktopTransition(
                primary,
                secondary,
                transitionedChild,
                fillColor,
              ),
            },
          );
        },
        child: KeyedSubtree(
          key: ValueKey(routeLocation),
          child: RepaintBoundary(child: child),
        ),
      ),
    );
  }

  Widget _mobileTransition(
    Animation<double> primary,
    Animation<double> secondary,
    Widget child,
  ) {
    final incomingSlide =
        Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: primary,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );
    final incomingFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: primary,
        curve: const Interval(0.1, 1.0, curve: Curves.easeOut),
      ),
    );
    final outgoingSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.02, 0),
    ).animate(CurvedAnimation(parent: secondary, curve: Curves.easeOutCubic));

    return SlideTransition(
      position: outgoingSlide,
      child: FadeTransition(
        opacity: incomingFade,
        child: SlideTransition(position: incomingSlide, child: child),
      ),
    );
  }

  Widget _tabletTransition(
    Animation<double> primary,
    Animation<double> secondary,
    Widget child,
    Color fillColor,
  ) {
    return SharedAxisTransition(
      animation: primary,
      secondaryAnimation: secondary,
      transitionType: SharedAxisTransitionType.scaled,
      fillColor: fillColor,
      child: child,
    );
  }

  Widget _desktopTransition(
    Animation<double> primary,
    Animation<double> secondary,
    Widget child,
    Color fillColor,
  ) {
    return FadeThroughTransition(
      animation: primary,
      secondaryAnimation: secondary,
      fillColor: fillColor,
      child: child,
    );
  }
}
