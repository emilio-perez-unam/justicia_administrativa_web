// Composes the public contact page from focused, contact-local sections.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/theme/app_theme_extension.dart';
import '../router.dart';
import '../../domains/contact/actors/contact_form_actor.dart';
import '../../domains/contact/application/submit_contact_inquiry_use_case.dart';
import '../../domains/contact/domain/contact_inquiry.dart';
import '../../domains/contact/domain/value_objects/contact_message.dart';
import '../../domains/contact/domain/value_objects/email_address.dart';
import '../../domains/contact/domain/value_objects/person_name.dart';
import 'section_container.dart';

part 'contact/contact_form.dart';
part 'contact/contact_form_submit.dart';
part 'contact/contact_form_fields.dart';
part 'contact/contact_office_card.dart';
part 'contact/contact_offices.dart';
part 'contact/contact_section_models.dart';

/// Public contact section with header, office locations, and inquiry form.
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ContactHeader(),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: context.colors.border)),
          ),
          child: MaxWidth(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => context.go(AppRouter.home),
                  child: Text(
                    "Inicio",
                    style: TextStyle(color: context.colors.mutedForeground),
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: context.colors.mutedForeground,
                ),
                const SizedBox(width: 8),
                Text(
                  "Contacto",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const _OfficesSection(),
        const _ContactFormSection(),
      ],
    );
  }
}
