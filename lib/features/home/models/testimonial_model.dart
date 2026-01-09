// lib/features/home/models/testimonial_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'testimonial_model.freezed.dart';
part 'testimonial_model.g.dart';

@freezed
class TestimonialModel with _$TestimonialModel {
  const TestimonialModel._();

  const factory TestimonialModel({
    required String id,
    required String name,
    required String position,
    String? company,
    required String testimonial,
    required double rating,
    required DateTime date,
    String? imageUrl,
    String? videoUrl,
    @Default(true) bool isActive,
    @Default(false) bool isFeatured,
    @Default(0) int displayOrder,
    TestimonialType? type,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) = _TestimonialModel;

  factory TestimonialModel.fromJson(Map<String, dynamic> json) =>
      _$TestimonialModelFromJson(json);

  // Helper methods
  String get displayName =>
      name.length > 50 ? '${name.substring(0, 47)}...' : name;

  String get shortTestimonial => testimonial.length > 150
      ? '${testimonial.substring(0, 147)}...'
      : testimonial;

  String get formattedDate {
    final months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'Hace $years ${years == 1 ? 'año' : 'años'}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'Hace $months ${months == 1 ? 'mes' : 'meses'}';
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace $weeks ${weeks == 1 ? 'semana' : 'semanas'}';
    } else if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}';
    } else {
      return 'Hoy';
    }
  }

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;

  int get ratingInt => rating.round();

  String get ratingStars {
    final fullStars = rating.floor();
    final hasHalfStar = (rating - fullStars) >= 0.5;
    final emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return '★' * fullStars + (hasHalfStar ? '⯨' : '') + '☆' * emptyStars;
  }

  // Factory constructors for different testimonial types
  factory TestimonialModel.notary({
    required String id,
    required String name,
    required String notaryNumber,
    required String testimonial,
    double rating = 5.0,
    DateTime? date,
    String? imageUrl,
  }) {
    return TestimonialModel(
      id: id,
      name: name,
      position: 'Notario Público',
      company: 'Notaría Pública $notaryNumber',
      testimonial: testimonial,
      rating: rating,
      date: date ?? DateTime.now(),
      imageUrl: imageUrl,
      type: TestimonialType.notary,
      metadata: {'notaryNumber': notaryNumber},
    );
  }

  factory TestimonialModel.corporate({
    required String id,
    required String name,
    required String position,
    required String company,
    required String testimonial,
    double rating = 5.0,
    DateTime? date,
    String? imageUrl,
    List<String>? tags,
  }) {
    return TestimonialModel(
      id: id,
      name: name,
      position: position,
      company: company,
      testimonial: testimonial,
      rating: rating,
      date: date ?? DateTime.now(),
      imageUrl: imageUrl,
      type: TestimonialType.corporate,
      tags: tags,
    );
  }

  factory TestimonialModel.government({
    required String id,
    required String name,
    required String position,
    required String department,
    required String testimonial,
    double rating = 5.0,
    DateTime? date,
  }) {
    return TestimonialModel(
      id: id,
      name: name,
      position: position,
      company: department,
      testimonial: testimonial,
      rating: rating,
      date: date ?? DateTime.now(),
      type: TestimonialType.government,
    );
  }

  factory TestimonialModel.legal({
    required String id,
    required String name,
    required String firm,
    required String testimonial,
    double rating = 5.0,
    DateTime? date,
    String? imageUrl,
  }) {
    return TestimonialModel(
      id: id,
      name: name,
      position: 'Abogado',
      company: firm,
      testimonial: testimonial,
      rating: rating,
      date: date ?? DateTime.now(),
      imageUrl: imageUrl,
      type: TestimonialType.legal,
    );
  }

  // Mock data factory
  static List<TestimonialModel> mockTestimonials() {
    return [
      TestimonialModel.notary(
        id: '1',
        name: 'Lic. Juan Carlos Hernández',
        notaryNumber: '42',
        testimonial:
            'La implementación de las soluciones tecnológicas de Justicia Administrativa ha modernizado significativamente nuestros procesos. La eficiencia y precisión en el manejo de documentación legal ha mejorado notablemente. El equipo demostró un profundo conocimiento tanto del marco legal como de las herramientas tecnológicas.',
        rating: 5.0,
        date: DateTime(2024, 10, 15),
      ),
      TestimonialModel.corporate(
        id: '2',
        name: 'María González Pérez',
        position: 'Directora Legal',
        company: 'Grupo Empresarial Mexicano',
        testimonial:
            'El sistema de inteligencia artificial desarrollado para nuestro departamento legal ha reducido el tiempo de análisis de contratos en un 70%. La precisión en la identificación de cláusulas de riesgo es impresionante.',
        rating: 4.8,
        date: DateTime(2024, 9, 20),
        tags: ['IA', 'Contratos', 'Eficiencia'],
      ),
      TestimonialModel.government(
        id: '3',
        name: 'Ing. Roberto Martínez',
        position: 'Director de Modernización',
        department: 'Secretaría de Administración',
        testimonial:
            'La transformación digital de nuestros procesos administrativos ha sido exitosa. El equipo de Justicia Administrativa comprendió perfectamente nuestras necesidades y desarrolló soluciones a medida que han mejorado la atención ciudadana.',
        rating: 4.9,
        date: DateTime(2024, 8, 5),
      ),
      TestimonialModel.legal(
        id: '4',
        name: 'Lic. Ana Patricia Ruiz',
        firm: 'Despacho Ruiz y Asociados',
        testimonial:
            'Como despacho boutique, necesitábamos soluciones tecnológicas que nos permitieran competir con firmas más grandes. La plataforma desarrollada nos ha permitido gestionar casos complejos con mayor eficiencia.',
        rating: 5.0,
        date: DateTime(2024, 7, 12),
      ),
      const TestimonialModel(
        id: '5',
        name: 'Dr. Fernando López',
        position: 'Magistrado',
        company: 'Tribunal Administrativo',
        testimonial:
            'La implementación del sistema de gestión de expedientes ha revolucionado nuestro trabajo. La búsqueda de precedentes y la generación de estadísticas ahora toman minutos en lugar de días.',
        rating: 4.7,
        date: null,
        isFeatured: true,
      ),
    ];
  }
}

enum TestimonialType {
  notary,
  corporate,
  government,
  legal,
  academic,
  judicial,
  other,
}

extension TestimonialTypeExtension on TestimonialType {
  String get displayName {
    switch (this) {
      case TestimonialType.notary:
        return 'Notaría';
      case TestimonialType.corporate:
        return 'Corporativo';
      case TestimonialType.government:
        return 'Gobierno';
      case TestimonialType.legal:
        return 'Legal';
      case TestimonialType.academic:
        return 'Académico';
      case TestimonialType.judicial:
        return 'Judicial';
      case TestimonialType.other:
        return 'Otro';
    }
  }

  String get icon {
    switch (this) {
      case TestimonialType.notary:
        return 'gavel';
      case TestimonialType.corporate:
        return 'business';
      case TestimonialType.government:
        return 'account_balance';
      case TestimonialType.legal:
        return 'balance';
      case TestimonialType.academic:
        return 'school';
      case TestimonialType.judicial:
        return 'gavel';
      case TestimonialType.other:
        return 'comment';
    }
  }

  String get color {
    switch (this) {
      case TestimonialType.notary:
        return '#1B3A57'; // primaryNavy
      case TestimonialType.corporate:
        return '#2196F3'; // techBlue
      case TestimonialType.government:
        return '#D4AF37'; // accentGold
      case TestimonialType.legal:
        return '#1B3A57';
      case TestimonialType.academic:
        return '#4CAF50';
      case TestimonialType.judicial:
        return '#9C27B0';
      case TestimonialType.other:
        return '#757575';
    }
  }
}
