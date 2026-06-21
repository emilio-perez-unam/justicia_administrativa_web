// Renders the authenticated user profile block for the portal sidebar.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/config/cache_config.dart';
import '../../../router.dart';

/// Displays the signed-in user's avatar, name, email, and presence marker.
class PortalSidebarProfile extends StatelessWidget {
  final Color navyColor;
  final Color goldColor;

  const PortalSidebarProfile({
    super.key,
    required this.navyColor,
    required this.goldColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: ListenableBuilder(
        listenable: AppRouter.authNotifier,
        builder: (context, _) {
          final displayName = AppRouter.authNotifier.displayName;
          final email = AppRouter.authNotifier.email;
          final initials = _getInitials(displayName);
          final avatarUrl =
              AppRouter.authNotifier.currentUser?.userMetadata?['avatar_url']
                  as String?;

          return Row(
            children: [
              _PortalAvatar(
                initials: initials,
                avatarUrl: avatarUrl,
                goldColor: goldColor,
                navyColor: navyColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName.isNotEmpty ? displayName : 'Usuario',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.blue.shade200,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

String _getInitials(String name) {
  if (name.isEmpty) return '?';
  final parts = name.trim().split(' ');
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  return parts[0][0].toUpperCase();
}

class _PortalAvatar extends StatelessWidget {
  final String initials;
  final String? avatarUrl;
  final Color goldColor;
  final Color navyColor;

  const _PortalAvatar({
    required this.initials,
    required this.avatarUrl,
    required this.goldColor,
    required this.navyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipOval(
          child: avatarUrl != null && avatarUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: avatarUrl!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  cacheManager: CacheConfig.instance,
                  placeholder: (context, url) => Container(
                    color: goldColor.withValues(alpha: 0.2),
                    child: const Icon(LucideIcons.user, color: Colors.white),
                  ),
                  errorWidget: (context, url, error) =>
                      _InitialsAvatar(initials: initials, goldColor: goldColor),
                )
              : _InitialsAvatar(initials: initials, goldColor: goldColor),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(color: navyColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String initials;
  final Color goldColor;

  const _InitialsAvatar({required this.initials, required this.goldColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: goldColor.withValues(alpha: 0.2),
        border: Border.all(color: goldColor, width: 2),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(color: goldColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
