// lib/features/home/models/client_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_model.freezed.dart';
part 'client_model.g.dart';

@freezed
class ClientModel with _$ClientModel {
  const ClientModel._();

  const factory ClientModel({
    required String id,
    required String name,
    String? logoUrl,
    String? websiteUrl,
    String? industry,
    DateTime? clientSince,
    String? testimonial,
    String? description,
    @Default(true) bool isActive,
    @Default(0) int displayOrder,
    ClientType? clientType,
    Map<String, dynamic>? metadata,
  }) = _ClientModel;

  factory ClientModel.fromJson(Map<String, dynamic> json) =>
      _$ClientModelFromJson(json);

  // Helper methods
  String get displayName =>
      name.length > 30 ? '${name.substring(0, 27)}...' : name;

  bool get hasLogo => logoUrl != null && logoUrl!.isNotEmpty;

  bool get hasTestimonial => testimonial != null && testimonial!.isNotEmpty;

  String get formattedClientSince {
    if (clientSince == null) return '';
    final years = DateTime.now().difference(clientSince!).inDays ~/ 365;
    if (years > 0) {
      return 'Cliente desde hace $years ${years == 1 ? 'año' : 'años'}';
    }
    final months = DateTime.now().difference(clientSince!).inDays ~/ 30;
    if (months > 0) {
      return 'Cliente desde hace $months ${months == 1 ? 'mes' : 'meses'}';
    }
    return 'Nuevo cliente';
  }

  // Factory constructors for common client types
  factory ClientModel.notary({
    required String id,
    required String name,
    required String number,
    String? location,
    String? logoUrl,
    DateTime? clientSince,
  }) {
    return ClientModel(
      id: id,
      name: 'Notaría Pública $number',
      industry: 'Notaría',
      clientType: ClientType.notary,
      logoUrl: logoUrl,
      clientSince: clientSince,
      metadata: {'notaryNumber': number, 'location': location},
    );
  }

  factory ClientModel.government({
    required String id,
    required String name,
    required String department,
    String? logoUrl,
    DateTime? clientSince,
  }) {
    return ClientModel(
      id: id,
      name: name,
      industry: 'Gobierno',
      clientType: ClientType.government,
      logoUrl: logoUrl,
      clientSince: clientSince,
      metadata: {'department': department},
    );
  }

  factory ClientModel.corporate({
    required String id,
    required String name,
    required String sector,
    String? logoUrl,
    String? websiteUrl,
    DateTime? clientSince,
  }) {
    return ClientModel(
      id: id,
      name: name,
      industry: sector,
      clientType: ClientType.corporate,
      logoUrl: logoUrl,
      websiteUrl: websiteUrl,
      clientSince: clientSince,
    );
  }

  factory ClientModel.educational({
    required String id,
    required String name,
    required String type,
    String? logoUrl,
    String? websiteUrl,
    DateTime? clientSince,
  }) {
    return ClientModel(
      id: id,
      name: name,
      industry: 'Educación',
      clientType: ClientType.educational,
      logoUrl: logoUrl,
      websiteUrl: websiteUrl,
      clientSince: clientSince,
      metadata: {'institutionType': type},
    );
  }

  // Mock data factory
  static List<ClientModel> mockClients() {
    return [
      ClientModel.notary(
        id: '1',
        name: 'Notaría Pública 42',
        number: '42',
        location: 'Ciudad de México',
        clientSince: DateTime(2022, 6, 15),
      ),
      ClientModel.government(
        id: '2',
        name: 'Secretaría de Administración',
        department: 'Gobierno del Estado',
        clientSince: DateTime(2021, 3, 1),
      ),
      ClientModel.corporate(
        id: '3',
        name: 'Grupo Empresarial Mexicano',
        sector: 'Servicios Financieros',
        websiteUrl: 'https://example.com',
        clientSince: DateTime(2023, 1, 10),
      ),
      ClientModel.educational(
        id: '4',
        name: 'Universidad Nacional',
        type: 'Universidad Pública',
        clientSince: DateTime(2022, 9, 1),
      ),
      const ClientModel(
        id: '5',
        name: 'Despacho Jurídico González',
        industry: 'Legal',
        clientSince: null,
        testimonial:
            'Excelente servicio de transformación digital para nuestro despacho.',
      ),
      const ClientModel(
        id: '6',
        name: 'Tribunal Administrativo',
        industry: 'Judicial',
        clientSince: null,
      ),
    ];
  }
}

enum ClientType {
  notary,
  government,
  corporate,
  educational,
  legal,
  judicial,
  other,
}

extension ClientTypeExtension on ClientType {
  String get displayName {
    switch (this) {
      case ClientType.notary:
        return 'Notaría';
      case ClientType.government:
        return 'Gobierno';
      case ClientType.corporate:
        return 'Corporativo';
      case ClientType.educational:
        return 'Educativo';
      case ClientType.legal:
        return 'Legal';
      case ClientType.judicial:
        return 'Judicial';
      case ClientType.other:
        return 'Otro';
    }
  }

  String get icon {
    switch (this) {
      case ClientType.notary:
        return 'gavel';
      case ClientType.government:
        return 'account_balance';
      case ClientType.corporate:
        return 'business';
      case ClientType.educational:
        return 'school';
      case ClientType.legal:
        return 'balance';
      case ClientType.judicial:
        return 'gavel';
      case ClientType.other:
        return 'business_center';
    }
  }
}
