// Route-level composition for the live Justicia Administrativa homepage.
import 'package:flutter/material.dart';

import '../components/hero.dart';
import '../components/home/home_dual_expertise_section.dart';
import '../components/home/home_preview_cards_section.dart';

/// Assembles the homepage from focused, section-level presentation widgets.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        HeroSection(),
        HomeDualExpertiseSection(),
        HomePreviewCardsSection(),
      ],
    );
  }
}
