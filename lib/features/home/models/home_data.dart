// lib/features/home/models/home_data.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:justicia_administrativa_web/features/home/models/client_model.dart';
import 'package:justicia_administrativa_web/features/home/models/service_model.dart';
import 'package:justicia_administrativa_web/features/home/models/testimonial_model.dart';

part 'home_data.freezed.dart';
part 'home_data.g.dart';

@freezed
class HomeData with _$HomeData {
  const factory HomeData({
    required List<ClientModel> clients,
    required List<ServiceModel> services,
    required List<TestimonialModel> testimonials,
    @Default([]) List<Achievement> achievements,
    CompanyInfo? companyInfo,
  }) = _HomeData;

  factory HomeData.fromJson(Map<String, dynamic> json) =>
      _$HomeDataFromJson(json);

  // Factory for default/mock data
  factory HomeData.empty() =>
      HomeData(clients: [], services: [], testimonials: [], achievements: []);

  factory HomeData.mock() => HomeData(
    clients: [
      ClientModel(id: '1', name: 'Notaría Pública 42', industry: 'Legal'),
    ],
    services: [
      ServiceModel(
        id: '1',
        title: 'Inteligencia Artificial',
        description: 'Desarrollo de software jurídico personalizado.',
        icon: 'smart_toy',
        features: [
          'Desarrollo de software jurídico personalizado',
          'Entrenamiento de algoritmos especializados',
          'Sistemas de análisis predictivo',
        ],
        route: '/ai-solutions',
      ),
      ServiceModel(
        id: '2',
        title: 'Transformación Digital',
        description: 'Convertir expedientes físicos en archivos digitales.',
        icon: 'transform',
        features: [
          'Digitalización de expedientes',
          'Control y búsqueda inmediata',
          'Ecosistema digital completo',
        ],
        route: '/legal-services',
      ),
      ServiceModel(
        id: '3',
        title: 'Consultoría Jurídica',
        description: 'Asesoría legal especializada.',
        icon: 'gavel',
        features: [
          'Contratación pública',
          'Responsabilidad patrimonial del Estado',
          'Amparo en materia administrativa',
        ],
        route: '/legal-services',
      ),
    ],
    testimonials: [
      TestimonialModel(
        id: '1',
        name: 'Notario Público',
        position: 'Notaría Pública 42',
        company: 'Ciudad de México',
        testimonial:
            'La implementación de las soluciones tecnológicas ha modernizado significativamente nuestros procesos.',
        rating: 5.0,
        date: DateTime.now(),
      ),
    ],
    achievements: [
      Achievement(icon: 'school', value: '20+', label: 'Años de Experiencia'),
      Achievement(icon: 'emoji_events', value: '500+', label: 'Casos Ganados'),
      Achievement(icon: 'groups', value: '50+', label: 'Clientes Corporativos'),
    ],
    companyInfo: CompanyInfo(
      name: 'Justicia Administrativa',
      tagline: 'Transformando el Derecho Administrativo con IA',
      phone: '+52 1 311 125 0906',
      email: 'contacto@justicia-administrativa.mx',
      address: 'Ciudad de México, México',
    ),
  );
}

@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    required String icon,
    required String value,
    required String label,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
}

@freezed
class CompanyInfo with _$CompanyInfo {
  const factory CompanyInfo({
    required String name,
    required String tagline,
    required String phone,
    required String email,
    required String address,
    String? website,
    Map<String, String>? socialLinks,
  }) = _CompanyInfo;

  factory CompanyInfo.fromJson(Map<String, dynamic> json) =>
      _$CompanyInfoFromJson(json);
}
