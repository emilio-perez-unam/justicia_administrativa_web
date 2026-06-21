import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_theme_extension.dart';
import 'section_container.dart';

part 'about/about_affiliation_leadership.dart';
part 'about/about_header_intro.dart';
part 'about/about_leadership_quote.dart';
part 'about/about_mission_awards.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _AboutHeader(),
        SectionContainer(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
          child: const Column(
            children: [
              _IntroSection(),
              SizedBox(height: 96),
              _MissionVisionSection(),
              SizedBox(height: 96),
              _AwardsSection(),
              SizedBox(height: 96),
              _AffiliationBanner(),
              SizedBox(height: 96),
              _SocialResponsibilitySection(),
              SizedBox(height: 96),
              _LeadershipSection(),
              SizedBox(height: 96),
              _FounderQuoteSection(),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Hero header
// ---------------------------------------------------------------------------
