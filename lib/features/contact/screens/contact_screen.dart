import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';
import 'package:justicia_administrativa_web/core/constants/spacing.dart';
import 'package:justicia_administrativa_web/core/constants/typography.dart';
import 'package:latlong2/latlong.dart';
import 'package:responsive_builder/responsive_builder.dart';

// A simple data model for an office location
class _Office {
  final String city;
  final String designation;
  final String address;
  final String phone1;
  final String phone2;
  final String schedule;
  final String amenities;
  final List<String> specialties;
  final Color themeColor;
  final IconData icon;

  const _Office({
    required this.city,
    required this.designation,
    required this.address,
    required this.phone1,
    required this.phone2,
    required this.schedule,
    required this.amenities,
    required this.specialties,
    required this.themeColor,
    required this.icon,
  });
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          _HeroSection(),
          _BreadcrumbSection(),
          _OfficesSection(),
          _ContactFormSection(),
        ],
      ),
    );
  }
}

// MARK: - Screen Sections

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        color: AppColors.primaryNavy.withOpacity(0.7),
        // TODO: Replace with your actual hero image for the contact page
        image: const DecorationImage(
          image: AssetImage('assets/images/contact_hero_background.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.primaryNavy,
            BlendMode.overlay,
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pagePadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contáctenos',
                  style: AppTypography.displayLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 757),
                  child: Text(
                    'Estamos a su disposición para resolver sus consultas legales y tecnológicas. Nuestro equipo internacional está listo para atenderle.',
                    style: AppTypography.bodyLarge.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BreadcrumbSection extends StatelessWidget {
  const _BreadcrumbSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pagePadding,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.home_filled,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('Inicio', style: AppTypography.bodySmall),
                const SizedBox(width: AppSpacing.xs),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textTertiary,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Contacto',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OfficesSection extends StatelessWidget {
  const _OfficesSection();

  // Data for the office cards
  static final List<_Office> offices = [
    const _Office(
      city: 'Ciudad de México',
      designation: 'Sede Principal',
      address:
          'Av. Presidente Masaryk 111, Polanco, Miguel Hidalgo, 11560 CDMX',
      phone1: '+52 (55) 1234-5678',
      phone2: '+52 (55) 8765-4321',
      schedule: 'Lun - Vie: 9:00 - 18:00',
      amenities: 'Estacionamiento disponible',
      specialties: [
        'Administrativo',
        'Corporativo',
        'Licitaciones',
        'IA Legal',
      ],
      themeColor: AppColors.primaryNavy,
      icon: Icons.business_sharp,
    ),
    const _Office(
      city: 'Guadalajara',
      designation: 'Tech Hub',
      address: 'Av. Américas 1254, Country Club, 44610 Guadalajara, Jalisco',
      phone1: '+52 (33) 3456-7890',
      phone2: '+52 (33) 9876-5432',
      schedule: 'Lun - Vie: 8:30 - 17:30',
      amenities: 'Acceso para startups',
      specialties: ['Startups', 'LegalTech', 'IA Legal', 'Regulatorio'],
      themeColor: AppColors.techBlue,
      icon: Icons.developer_mode,
    ),
    const _Office(
      city: 'Miami',
      designation: 'Operaciones LatAm',
      address: '1001 Brickell Bay Dr, Suite 1200, Miami, FL 33131',
      phone1: '+1 (305) 456-7890',
      phone2: 'miami@justiciaadmin.com',
      schedule: 'Mon - Fri: 9:00 - 17:00',
      amenities: 'Atención bilingüe',
      specialties: [
        'Internacional',
        'Transacciones',
        'Inversiones',
        'Expansión',
      ],
      themeColor: AppColors.primaryNavy,
      icon: Icons.public,
    ),
    const _Office(
      city: 'Madrid',
      designation: 'Operaciones UE',
      address: 'Calle de Serrano 41, 4ª planta, 28001 Madrid, España',
      phone1: '+34 91 123 4567',
      phone2: 'madrid@justiciaadmin.com',
      schedule: 'Lun - Vie: 9:30 - 18:30',
      amenities: 'Asesoría en GDPR',
      specialties: ['Derecho UE', 'Inversiones', 'RegTech', 'IA Legal'],
      themeColor: AppColors.techBlue,
      icon: Icons.euro_symbol,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl,
        horizontal: AppSpacing.pagePadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Column(
            children: [
              Text('Nuestras Oficinas', style: AppTypography.headingLarge),
              const SizedBox(height: AppSpacing.xxxl),
              _InteractiveMap(offices: offices),
              const SizedBox(height: AppSpacing.xxxl),
              ResponsiveBuilder(
                builder: (context, sizing) {
                  final crossAxisCount = sizing.isMobile
                      ? 1
                      : (sizing.isTablet ? 2 : 4);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppSpacing.lg,
                      mainAxisSpacing: AppSpacing.lg,
                      childAspectRatio: 0.5,
                    ),
                    itemCount: offices.length,
                    itemBuilder: (context, index) =>
                        _OfficeCard(office: offices[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InteractiveMap extends StatelessWidget {
  final List<_Office> offices;

  const _InteractiveMap({required this.offices});

  @override
  Widget build(BuildContext context) {
    // Define coordinates for each office
    final Map<String, LatLng> officeCoordinates = {
      'Ciudad de México': LatLng(19.4326, -99.1332),
      'Guadalajara': LatLng(20.6597, -103.3496),
      'Miami': LatLng(25.7617, -80.1918),
      'Madrid': LatLng(40.4168, -3.7038),
    };

    // Create Marker widgets from your office data
    final markers = offices
        .map((office) {
          final coordinates = officeCoordinates[office.city];
          if (coordinates == null) return null;

          return Marker(
            point: coordinates,
            width: 80,
            height: 80,
            child: Tooltip(
              message: "${office.city}\n${office.designation}",
              child: Icon(
                Icons.location_pin,
                size: 50,
                color: office.themeColor,
              ),
            ),
          );
        })
        .whereType<Marker>()
        .toList(); // Filter out any nulls

    return SizedBox(
      height: 500, // Define a height for the map container
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(23.6345, -102.5528), // Centered on Mexico
            initialZoom: 4.5,
          ),
          children: [
            // The map background tiles
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.justiciaadministrativa.app',
            ),
            // The layer for your office markers
            MarkerLayer(markers: markers),
          ],
        ),
      ),
    );
  }
}

class _OfficeCard extends StatelessWidget {
  final _Office office;
  const _OfficeCard({required this.office});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            color: office.themeColor,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(office.icon, color: office.themeColor, size: 32),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  office.city,
                  style: AppTypography.headingSmall.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  office.designation,
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(icon: Icons.location_on, text: office.address),
                  _InfoRow(icon: Icons.phone, text: office.phone1),
                  _InfoRow(icon: Icons.alternate_email, text: office.phone2),
                  const Divider(height: AppSpacing.lg),
                  _InfoRow(icon: Icons.schedule, text: office.schedule),
                  _InfoRow(icon: Icons.local_parking, text: office.amenities),
                  const Divider(height: AppSpacing.lg),
                  Text(
                    'Especialización',
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: office.specialties
                        .map((spec) => Chip(label: Text(spec)))
                        .toList(),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: office.themeColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text('Contactar Oficina'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(text, style: AppTypography.bodySmall)),
        ],
      ),
    );
  }
}

class _ContactFormSection extends StatefulWidget {
  const _ContactFormSection();

  @override
  State<_ContactFormSection> createState() => _ContactFormSectionState();
}

class _ContactFormSectionState extends State<_ContactFormSection> {
  final _formKey = GlobalKey<FormState>();
  String? _consultaType;
  String? _preferredOffice;
  bool _isUrgent = false;
  String? _contactMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl,
        horizontal: AppSpacing.pagePadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contáctenos', style: AppTypography.headingLarge),
                    const SizedBox(height: AppSpacing.xl),
                    ResponsiveBuilder(
                      builder: (context, sizing) {
                        if (sizing.isMobile) {
                          return Column(
                            children: const [
                              _FullNameField(),
                              SizedBox(height: AppSpacing.lg),
                              _EmailField(),
                            ],
                          );
                        }
                        return Row(
                          children: const [
                            Expanded(child: _FullNameField()),
                            SizedBox(width: AppSpacing.lg),
                            Expanded(child: _EmailField()),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ResponsiveBuilder(
                      builder: (context, sizing) {
                        if (sizing.isMobile) {
                          return Column(
                            children: const [
                              _PhoneField(),
                              SizedBox(height: AppSpacing.lg),
                              _CompanyField(),
                            ],
                          );
                        }
                        return Row(
                          children: const [
                            Expanded(child: _PhoneField()),
                            SizedBox(width: AppSpacing.lg),
                            Expanded(child: _CompanyField()),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _buildSectionTitle('Tipo de consulta *'),
                    Wrap(
                      spacing: AppSpacing.lg,
                      children: [
                        _buildRadio<String>(
                          'Servicios Legales',
                          'legal',
                          _consultaType,
                          (v) => setState(() => _consultaType = v),
                        ),
                        _buildRadio<String>(
                          'Soluciones IA',
                          'ai',
                          _consultaType,
                          (v) => setState(() => _consultaType = v),
                        ),
                        _buildRadio<String>(
                          'Ambos',
                          'both',
                          _consultaType,
                          (v) => setState(() => _consultaType = v),
                        ),
                        _buildRadio<String>(
                          'Otro',
                          'other',
                          _consultaType,
                          (v) => setState(() => _consultaType = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildSectionTitle('Oficina de preferencia'),
                    DropdownButtonFormField<String>(
                      value: _preferredOffice,
                      hint: const Text('Seleccione una oficina'),
                      onChanged: (value) =>
                          setState(() => _preferredOffice = value),
                      items: _OfficesSection.offices.map((office) {
                        return DropdownMenuItem(
                          value: office.city,
                          child: Text(office.city),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _buildSectionTitle('Mensaje *'),
                    TextFormField(
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Describa su consulta o requerimiento',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    CheckboxListTile(
                      title: const Text(
                        'Este asunto requiere atención urgente (respuesta en 4 horas hábiles)',
                      ),
                      value: _isUrgent,
                      onChanged: (value) =>
                          setState(() => _isUrgent = value ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildSectionTitle('Método de contacto preferido'),
                    Row(
                      children: [
                        _buildRadio<String>(
                          'Correo electrónico',
                          'email',
                          _contactMethod,
                          (v) => setState(() => _contactMethod = v),
                        ),
                        const SizedBox(width: AppSpacing.xl),
                        _buildRadio<String>(
                          'Llamada telefónica',
                          'phone',
                          _contactMethod,
                          (v) => setState(() => _contactMethod = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement form submission logic
                        },
                        child: const Text('Enviar Mensaje'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRadio<T>(
    String title,
    T value,
    T? groupValue,
    ValueChanged<T?> onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<T>(value: value, groupValue: groupValue, onChanged: onChanged),
        Text(title),
      ],
    );
  }
}

// MARK: - Form Field Widgets

class _FullNameField extends StatelessWidget {
  const _FullNameField();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Nombre completo *',
        hintText: 'Ingrese su nombre',
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Correo electrónico *',
        hintText: 'correo@ejemplo.com',
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Teléfono',
        hintText: '+52 (55) 1234-5678',
      ),
    );
  }
}

class _CompanyField extends StatelessWidget {
  const _CompanyField();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Empresa',
        hintText: 'Nombre de su empresa',
      ),
    );
  }
}
