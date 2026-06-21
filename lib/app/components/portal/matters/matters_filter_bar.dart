// Owns the responsive search and status-filter controls for portal matters.

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_theme_extension.dart';

const _matterStatusFilters = ['Todos', 'En proceso', 'Completado'];

/// Pinned search and status filter surface for the matters list.
class MattersFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedStatus;
  final bool isMobile;
  final ValueChanged<String> onStatusSelected;

  const MattersFilterBar({
    super.key,
    required this.searchController,
    required this.selectedStatus,
    required this.isMobile,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.only(bottom: 32),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isMobile
            ? _buildMobileLayout(context)
            : _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _MatterSearchField(
          controller: searchController,
          hintText: 'Buscar por expediente...',
        ),
        const Divider(height: 1),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: _matterStatusFilters.map((status) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _MatterFilterChip(
                  status: status,
                  selectedStatus: selectedStatus,
                  onStatusSelected: onStatusSelected,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: _MatterSearchField(
            controller: searchController,
            hintText: 'Buscar por expediente o título...',
          ),
        ),
        Container(width: 1, height: 24, color: colors.border),
        const SizedBox(width: 8),
        ..._matterStatusFilters.map((status) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _MatterChoiceChip(
              status: status,
              selectedStatus: selectedStatus,
              onStatusSelected: onStatusSelected,
            ),
          );
        }),
      ],
    );
  }
}

class _MatterSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const _MatterSearchField({required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          LucideIcons.search,
          size: 18,
          color: colors.mutedForeground,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}

class _MatterFilterChip extends StatelessWidget {
  final String status;
  final String selectedStatus;
  final ValueChanged<String> onStatusSelected;

  const _MatterFilterChip({
    required this.status,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedStatus == status;
    final colors = context.colors;
    const navyColor = Color(0xFF1E3A8A);

    return FilterChip(
      label: Text(status),
      selected: isSelected,
      onSelected: (_) => onStatusSelected(status),
      checkmarkColor: navyColor,
      selectedColor: Colors.blue.shade50,
      backgroundColor: Colors.transparent,
      labelStyle: TextStyle(
        color: isSelected ? navyColor : colors.mutedForeground,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

class _MatterChoiceChip extends StatelessWidget {
  final String status;
  final String selectedStatus;
  final ValueChanged<String> onStatusSelected;

  const _MatterChoiceChip({
    required this.status,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedStatus == status;
    final colors = context.colors;
    const navyColor = Color(0xFF1E3A8A);

    return ChoiceChip(
      label: Text(status),
      selected: isSelected,
      onSelected: (_) => onStatusSelected(status),
      selectedColor: Colors.blue.shade50,
      backgroundColor: Colors.transparent,
      labelStyle: TextStyle(
        color: isSelected ? navyColor : colors.mutedForeground,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide.none,
      ),
      showCheckmark: false,
    );
  }
}
