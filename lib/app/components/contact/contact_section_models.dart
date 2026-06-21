// Defines contact-section view data that is local to the contact page.

part of '../contact.dart';

const _contactNavyColor = Color(0xFF0F172A);

// A single, honest location entry. Verified contact details (street, phone,
// hours) are intentionally omitted until real data is provided; the working
// inquiry form below is the primary contact channel.
const _contactOffices = [
  _OfficeData(
    city: "Ciudad de México",
    role: "Oficina principal",
    headerColor: _contactNavyColor,
    buttonColor: _contactNavyColor,
    icon: LucideIcons.building2,
    address: "Ciudad de México, México",
    tags: ["Administrativo", "Corporativo", "Licitaciones", "IA Legal"],
  ),
];

class _OfficeData {
  final String city;
  final String role;
  final Color headerColor;
  final Color buttonColor;
  final IconData icon;
  final String address;
  final List<String> tags;

  const _OfficeData({
    required this.city,
    required this.role,
    required this.headerColor,
    required this.buttonColor,
    required this.icon,
    required this.address,
    required this.tags,
  });
}
