import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:lottie/lottie.dart';
import 'package:justicia_administrativa_web/core/theme/app_theme.dart';
import 'package:justicia_administrativa_web/shared/widgets/responsive_builder.dart';
import 'package:justicia_administrativa_web/shared/widgets/animated_container.dart';
import 'package:justicia_administrativa_web/shared/widgets/animated_button.dart';
import 'package:justicia_administrativa_web/services/email_service.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:ui';
import 'dart:math' as math;

class CTASection extends ConsumerStatefulWidget {
  final bool isVisible;
  
  const CTASection({
    super.key,
    required this.isVisible,
  });

  @override
  ConsumerState<CTASection> createState() => _CTASectionState();
}

class _CTASectionState extends ConsumerState<CTASection>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _formController;
  late AnimationController _successController;
  late AnimationController _particleController;
  
  bool _formVisible = false;
  bool _isSubmitting = false;
  bool _showSuccess = false;
  bool _isHovered = false;
  
  // Form group
  late FormGroup _form;
  
  // Animation controllers for different states
  String _selectedService = 'legal';
  final List<String> _services = ['legal', 'technology', 'consulting', 'training'];

  @override
  void initState() {
    super.initState();
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    
    _formController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _successController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    // Initialize reactive form
    _initializeForm();
    
    // Show form after delay if visible
    if (widget.isVisible) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _formVisible = true);
          _formController.forward();
        }
      });
    }
  }

  void _initializeForm() {
    _form = FormGroup({
      'name': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(3),
        ],
      ),
      'email': FormControl<String>(
        validators: [
          Validators.required,
          Validators.email,
        ],
      ),
      'phone': FormControl<String>(
        validators: [
          Validators.pattern(r'^\+?[\d\s\-\(\)]+$'),
        ],
      ),
      'company': FormControl<String>(),
      'service': FormControl<String>(
        value: 'legal',
        validators: [Validators.required],
      ),
      'message': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(10),
        ],
      ),
      'urgency': FormControl<String>(value: 'normal'),
      'budget': FormControl<String>(),
      'acceptTerms': FormControl<bool>(
        value: false,
        validators: [Validators.requiredTrue],
      ),
    });
  }

  @override
  void didUpdateWidget(CTASection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _formVisible = true);
          _formController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _formController.dispose();
    _successController.dispose();
    _particleController.dispose();
    _form.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_form.valid) {
      setState(() => _isSubmitting = true);
      
      // Animate submission
      _particleController.forward();
      
      try {
        final success = await EmailService.sendContactForm(
          name: _form.control('name').value,
          email: _form.control('email').value,
          company: _form.control('company').value ?? '',
          message: _buildMessage(),
        );
        
        if (success) {
          setState(() {
            _showSuccess = true;
            _isSubmitting = false;
          });
          _successController.forward();
          
          // Reset form after delay
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              _form.reset();
              setState(() => _showSuccess = false);
              _successController.reverse();
            }
          });
        } else {
          _showError();
        }
      } catch (e) {
        _showError();
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    } else {
      _form.markAllAsTouched();
    }
  }

  String _buildMessage() {
    final values = _form.value;
    return '''
Service Type: ${values['service']}
Phone: ${values['phone'] ?? 'Not provided'}
Urgency: ${values['urgency']}
Budget Range: ${values['budget'] ?? 'Not specified'}
Message: ${values['message']}
''';
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al enviar el formulario. Por favor, intente nuevamente.'),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 100.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.background,
              AppTheme.background.withBlue(240),
              AppTheme.background.withRed(245),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background
            Positioned.fill(
              child: _buildAnimatedBackground(),
            ),
            
            // Particle effects when submitting
            if (_isSubmitting)
              Positioned.fill(
                child: _buildParticleEffect(),
              ),
            
            // Main content
            Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 1200.w),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: ResponsiveBuilder(
                  builder: (context, sizingInfo) {
                    return _buildContent(sizingInfo);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return CustomPaint(
          painter: CTABackgroundPainter(
            animation: _backgroundController.value,
            isHovered: _isHovered,
          ),
        );
      },
    );
  }

  Widget _buildParticleEffect() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            animation: _particleController.value,
          ),
        );
      },
    );
  }

  Widget _buildContent(ResponsiveSizingInfo sizingInfo) {
    if (sizingInfo.isMobile) {
      return Column(
        children: [
          _buildHeader(sizingInfo),
          SizedBox(height: 48.h),
          _buildFeatures(sizingInfo),
          SizedBox(height: 48.h),
          _buildFormSection(sizingInfo),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Information
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(sizingInfo),
              SizedBox(height: 48.h),
              _buildFeatures(sizingInfo),
              SizedBox(height: 32.h),
              _buildContactInfo(sizingInfo),
            ],
          ),
        ),
        
        SizedBox(width: sizingInfo.isTablet ? 40.w : 60.w),
        
        // Right side - Form
        Expanded(
          flex: 6,
          child: _buildFormSection(sizingInfo),
        ),
      ],
    );
  }

  Widget _buildHeader(ResponsiveSizingInfo sizingInfo) {
    return Column(
      crossAxisAlignment: sizingInfo.isMobile 
          ? CrossAxisAlignment.center 
          : CrossAxisAlignment.start,
      children: [
        if (widget.isVisible)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'CONSULTA GRATUITA',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
          )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
        
        SizedBox(height: 24.h),
        
        if (widget.isVisible)
          Text(
            '¿Necesita asesoría legal o\nsoluciones tecnológicas?',
            style: TextStyle(
              fontSize: sizingInfo.isMobile ? 32.sp : 42.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryNavy,
              height: 1.2,
            ),
            textAlign: sizingInfo.isMobile ? TextAlign.center : TextAlign.start,
          )
            .animate(delay: 200.ms)
            .fadeIn(duration: 800.ms)
            .slideY(begin: 0.2, end: 0),
        
        SizedBox(height: 16.h),
        
        if (widget.isVisible)
          Text(
            'Complete el formulario y un especialista se pondrá en contacto con usted inmediatamente para analizar su caso y ofrecerle las mejores soluciones.',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
            textAlign: sizingInfo.isMobile ? TextAlign.center : TextAlign.start,
          )
            .animate(delay: 400.ms)
            .fadeIn(duration: 800.ms),
      ],
    );
  }

  Widget _buildFeatures(ResponsiveSizingInfo sizingInfo) {
    final features = [
      {
        'icon': Icons.verified_user,
        'title': 'Asesoría Personalizada',
        'description': 'Expertos en derecho administrativo',
      },
      {
        'icon': Icons.rocket_launch,
        'title': 'Soluciones Tecnológicas',
        'description': 'IA adaptada a sus necesidades',
      },
      {
        'icon': Icons.attach_money,
        'title': 'Primera Consulta Sin Costo',
        'description': 'Evaluación gratuita de su caso',
      },
      {
        'icon': Icons.access_time,
        'title': 'Respuesta en 24 horas',
        'description': 'Atención prioritaria garantizada',
      },
    ];

    return Column(
      children: features.asMap().entries.map((entry) {
        return _FeatureItem(
          icon: entry.value['icon'] as IconData,
          title: entry.value['title'] as String,
          description: entry.value['description'] as String,
          delay: entry.key * 100,
          isVisible: widget.isVisible,
        );
      }).toList(),
    );
  }

  Widget _buildContactInfo(ResponsiveSizingInfo sizingInfo) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryNavy.withOpacity(0.05),
            AppTheme.primaryNavy.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.primaryNavy.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Icon(
                Icons.phone,
                size: 24.sp,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Llámenos directamente',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '+52 1 311 125 0906',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryNavy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
      .animate(delay: 600.ms, target: widget.isVisible ? 1 : 0)
      .fadeIn(duration: 800.ms)
      .slideX(begin: -0.1, end: 0);
  }

  Widget _buildFormSection(ResponsiveSizingInfo sizingInfo) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      transform: Matrix4.identity()
        ..translate(0.0, _isHovered ? -5.0 : 0.0),
      child: Container(
        padding: EdgeInsets.all(sizingInfo.isMobile ? 24.w : 40.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryNavy.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.95),
                    Colors.white.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: _showSuccess 
                  ? _buildSuccessMessage()
                  : _buildForm(sizingInfo),
            ),
          ),
        ),
      ),
    )
      .animate(
        delay: 400.ms,
        target: _formVisible ? 1 : 0,
      )
      .fadeIn(duration: 800.ms)
      .slideY(begin: 0.3, end: 0);
  }

  Widget _buildForm(ResponsiveSizingInfo sizingInfo) {
    return ReactiveForm(
      formGroup: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form header
          Row(
            children: [
              Icon(
                Icons.edit_document,
                size: 28.sp,
                color: AppTheme.primaryNavy,
              ),
              SizedBox(width: 12.w),
              Text(
                'Solicite información',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryNavy,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 32.h),
          
          // Service selection
          _buildServiceSelector(),
          
          SizedBox(height: 24.h),
          
          // Form fields
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'name',
                  'Nombre completo',
                  Icons.person,
                  'Juan Pérez',
                ),
              ),
              if (!sizingInfo.isMobile) ...[
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildTextField(
                    'email',
                    'Correo electrónico',
                    Icons.email,
                    'correo@ejemplo.com',
                  ),
                ),
              ],
            ],
          ),
          
          if (sizingInfo.isMobile) ...[
            SizedBox(height: 16.h),
            _buildTextField(
              'email',
              'Correo electrónico',
              Icons.email,
              'correo@ejemplo.com',
            ),
          ],
          
          SizedBox(height: 16.h),
          
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'phone',
                  'Teléfono (opcional)',
                  Icons.phone,
                  '+52 1234567890',
                ),
              ),
              if (!sizingInfo.isMobile) ...[
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildTextField(
                    'company',
                    'Empresa (opcional)',
                    Icons.business,
                    'Nombre de su empresa',
                  ),
                ),
              ],
            ],
          ),
          
          if (sizingInfo.isMobile) ...[
            SizedBox(height: 16.h),
            _buildTextField(
              'company',
              'Empresa (opcional)',
              Icons.business,
              'Nombre de su empresa',
            ),
          ],
          
          SizedBox(height: 16.h),
          
          // Urgency and budget
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'urgency',
                  'Urgencia',
                  Icons.schedule,
                  {
                    'urgent': 'Urgente (24h)',
                    'normal': 'Normal (3-5 días)',
                    'flexible': 'Flexible',
                  },
                ),
              ),
              if (!sizingInfo.isMobile) ...[
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildDropdown(
                    'budget',
                    'Presupuesto',
                    Icons.attach_money,
                    {
                      'small': '< $10,000 MXN',
                      'medium': '$10,000 - $50,000 MXN',
                      'large': '> $50,000 MXN',
                      'discuss': 'A discutir',
                    },
                  ),
                ),
              ],
            ],
          ),
          
          if (sizingInfo.isMobile) ...[
            SizedBox(height: 16.h),
            _buildDropdown(
              'budget',
              'Presupuesto',
              Icons.attach_money,
              {
                'small': '< $10,000 MXN',
                'medium': '$10,000 - $50,000 MXN',
                'large': '> $50,000 MXN',
                'discuss': 'A discutir',
              },
            ),
          ],
          
          SizedBox(height: 16.h),
          
          // Message
          _buildTextArea(
            'message',
            'Describa brevemente su consulta',
            Icons.message,
            'Cuéntenos sobre su caso o necesidad...',
          ),
          
          SizedBox(height: 24.h),
          
          // Terms checkbox
          ReactiveCheckboxListTile(
            formControlName: 'acceptTerms',
            title: Text(
              'Acepto los términos y condiciones y la política de privacidad',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppTheme.textSecondary,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: AppTheme.accentGold,
          ),
          
          SizedBox(height: 32.h),
          
          // Submit button
          _buildSubmitButton(sizingInfo),
        ],
      ),
    );
  }

  Widget _buildServiceSelector() {
    final services = {
      'legal': {'icon': Icons.gavel, 'label': 'Asesoría Legal'},
      'technology': {'icon': Icons.computer, 'label': 'Soluciones IA'},
      'consulting': {'icon': Icons.business_center, 'label': 'Consultoría'},
      'training': {'icon': Icons.school, 'label': 'Capacitación'},
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Qué servicio necesita?',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: services.entries.map((entry) {
            final isSelected = _selectedService == entry.key;
            return InkWell(
              onTap: () {
                setState(() => _selectedService = entry.key);
                _form.control('service').value = entry.key;
              },
              borderRadius: BorderRadius.circular(12.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppTheme.goldGradient : null,
                  color: isSelected ? null : AppTheme.background,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected 
                        ? Colors.transparent 
                        : AppTheme.divider,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      entry.value['icon'] as IconData,
                      size: 20.sp,
                      color: isSelected 
                          ? Colors.white 
                          : AppTheme.textSecondary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      entry.value['label'] as String,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: isSelected 
                            ? FontWeight.w600 
                            : FontWeight.w500,
                        color: isSelected 
                            ? Colors.white 
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String controlName,
    String label,
    IconData icon,
    String hint,
  ) {
    return ReactiveTextField(
      formControlName: controlName,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppTheme.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppTheme.primaryNavy, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppTheme.error),
        ),
        filled: true,
        fillColor: AppTheme.background,
      ),
      validationMessages: {
        'required': (error) => 'Este campo es requerido',
        'email': (error) => 'Ingrese un correo válido',
        'minLength': (error) => 'Mínimo 3 caracteres',
      },
    );
  }

  Widget _buildDropdown(
    String controlName,
    String label,
    IconData icon,
    Map<String, String> items,
  ) {
    return ReactiveDropdownField<String>(
      formControlName: controlName,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppTheme.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppTheme.primaryNavy, width: 2),
        ),
        filled: true,
        fillColor: AppTheme.background,
      ),
      items: items.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
    );
  }

  Widget _buildTextArea(
    String controlName,
    String label,
    IconData icon,
    String hint,
  ) {
    return ReactiveTextField(
      formControlName: controlName,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: 60.h),
          child: Icon(icon, size: 20.sp),
        ),
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppTheme.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppTheme.primaryNavy, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppTheme.error),
        ),
        filled: true,
        fillColor: AppTheme.background,
      ),
      validationMessages: {
        'required': (error) => 'Este campo es requerido',
        'minLength': (error) => 'Mínimo 10 caracteres',
      },
    );
  }

  Widget _buildSubmitButton(ResponsiveSizingInfo sizingInfo) {
    return SizedBox(
      width: double.infinity,
      child: AnimatedButton(
        onPressed: _isSubmitting ? null : _submitForm,
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(12.r),
        padding: EdgeInsets.symmetric(
          vertical: 16.h,
        ),
        child: _isSubmitting
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Enviando...',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.send,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Enviar solicitud',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      padding: EdgeInsets.all(40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/success.json',
            width: 150.w,
            height: 150.h,
            repeat: false,
          ),
          SizedBox(height: 24.h),
          Text(
            '¡Solicitud enviada con éxito!',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryNavy,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Nos pondremos en contacto con usted en las próximas 24 horas.',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
      .animate()
      .fadeIn(duration: 600.ms)
      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }
}

// Feature item widget
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int delay;
  final bool isVisible;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.delay,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 20.sp,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryNavy,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle,
            size: 20.sp,
            color: AppTheme.success,
          ),
        ],
      ),
    )
      .animate(
        delay: delay.ms,
        target: isVisible ? 1 : 0,
      )
      .fadeIn(duration: 500.ms)
      .slideX(begin: -0.1, end: 0);
  }
}

// Background painter
class CTABackgroundPainter extends CustomPainter {
  final double animation;
  final bool isHovered;

  CTABackgroundPainter({
    required this.animation,
    required this.isHovered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Draw morphing shapes
    for (int i = 0; i < 5; i++) {
      final progress = (animation + i * 0.2) % 1.0;
      final radius = 50 + progress * 150;
      final opacity = (1 - progress) * (isHovered ? 0.08 : 0.05);
      
      paint.color = AppTheme.accentGold.withOpacity(opacity);
      
      final offset = Offset(
        size.width * (0.2 + i * 0.15),
        size.height * 0.5 + math.sin(progress * math.pi * 2) * 50,
      );
      
      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(CTABackgroundPainter oldDelegate) {
    return animation != oldDelegate.animation ||
           isHovered != oldDelegate.isHovered;
  }
}

// Particle painter for success animation
class ParticlePainter extends CustomPainter {
  final double animation;

  ParticlePainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final random = math.Random(42);
    
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = size.height - (animation * size.height * 1.5);
      final opacity = (1 - animation) * 0.8;
      final radius = 2 + random.nextDouble() * 4;
      
      paint.color = AppTheme.accentGold.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}