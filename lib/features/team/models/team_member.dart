import 'package:equatable/equatable.dart';

enum MemberType { all, lawyer, engineer, consultant }

class TeamMember extends Equatable {
  final String id;
  final String name;
  final String title;
  final String imageUrl;
  final String location;
  final MemberType type;
  final List<String> specialties;
  final List<String> details;
  final List<String> admissions;
  final bool isFeatured;
  final String? linkedinUrl;
  final String? githubUrl;
  final String? email;
  final String? phone;
  final String? fullBio;
  final List<String>? education;
  final List<String>? achievements;
  final List<String>? previousPositions;

  const TeamMember({
    required this.id,
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.type,
    required this.specialties,
    required this.details,
    required this.admissions,
    required this.isFeatured,
    this.linkedinUrl,
    this.githubUrl,
    this.email,
    this.phone,
    this.fullBio,
    this.education,
    this.achievements,
    this.previousPositions,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    title,
    imageUrl,
    location,
    type,
    specialties,
    details,
    admissions,
    isFeatured,
    linkedinUrl,
    githubUrl,
    email,
    phone,
    fullBio,
    education,
    achievements,
    previousPositions,
  ];
}
