import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:justicia_administrativa_web/core/theme/app_theme.dart';
import 'package:justicia_administrativa_web/shared/widgets/responsive_builder.dart';
import 'package:justicia_administrativa_web/features/home/models/client_model.dart';

class ClientLogosSection extends StatefulWidget {
  final List<ClientModel> clients;
  
  const ClientLogosSection({
    super.key,
    required this.clients,
  });

  @override
  State<ClientLogosSection> createState() => _ClientLogosSectionState();
}

class _ClientLogosSectionState extends State<ClientLogosSection> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.clients.isEmpty) {
      return const SizedBox.shrink();
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: AppTheme.divider.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: ResponsiveBuilder(
          builder: (context, sizingInfo) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                vertical: sizingInfo.isMobile ? 40.h : 60.h,
              ),
              child: Column(
                children: [
                  // Section Title
                  _buildSectionTitle(context),
                  
                  SizedBox(height: sizingInfo.isMobile ? 32.h : 48.h),
                  
                  // Client Logos Display
                  if (sizingInfo.isMobile)
                    _buildMobileCarousel()
                  else if (sizingInfo.isTablet)
                    _buildTabletGrid()
                  else
                    _buildDesktopScroll(),
                  
                  // Trust Indicators
                  if (!sizingInfo.isMobile)
                    Padding(
                      padding: EdgeInsets.only(top: 48.h),
                      child: _buildTrustIndicators(sizingInfo),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Column(
      children: [
        Text(
          'Clientes que confían en nosotros',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textTertiary,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        )
          .animate()
          .fadeIn(duration: 600.ms)
          .slideY(begin: 0.2, end: 0),
        
        SizedBox(height: 8.h),
        
        Container(
          width: 60.w,
          height: 3.h,
          decoration: BoxDecoration(
            gradient: AppTheme.goldGradient,
            borderRadius: BorderRadius.circular(1.5.r),
          ),
        )
          .animate(delay: 200.ms)
          .scaleX(begin: 0, end: 1, duration: 400.ms),
      ],
    );
  }

  Widget _buildMobileCarousel() {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: widget.clients.length,
          itemBuilder: (context, index, realIndex) {
            return _ClientLogoItem(
              client: widget.clients[index],
              index: index,
              isMobile: true,
            );
          },
          options: CarouselOptions(
            height: 120.h,
            autoPlay: !_isHovered,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOut,
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
            viewportFraction: 0.7,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        
        SizedBox(height: 24.h),
        
        // Carousel Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.clients.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: _currentIndex == entry.key ? 24.w : 8.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: _currentIndex == entry.key
                      ? AppTheme.accentGold
                      : AppTheme.divider,
                ),
              )
                .animate(target: _currentIndex == entry.key ? 1 : 0)
                .scaleX(end: 1.0, begin: 0.8, duration: 200.ms),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTabletGrid() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 32.w,
        runSpacing: 32.h,
        children: widget.clients.asMap().entries.map((entry) {
          return _ClientLogoItem(
            client: entry.value,
            index: entry.key,
            isMobile: false,
          )
            .animate(delay: (entry.key * 100).ms)
            .fadeIn(duration: 500.ms)
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
        }).toList(),
      ),
    );
  }

  Widget _buildDesktopScroll() {
    // Duplicate the list for infinite scroll effect
    final duplicatedClients = [...widget.clients, ...widget.clients];
    
    return SizedBox(
      height: 100.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              // Gradient masks for fade effect
              Positioned.fill(
                child: Row(
                  children: [
                    Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Scrolling logos
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final scrollOffset = _animationController.value * 
                        (widget.clients.length * 200.w);
                    
                    return Transform.translate(
                      offset: Offset(-scrollOffset, 0),
                      child: Row(
                        children: duplicatedClients.map((client) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: _ClientLogoItem(
                              client: client,
                              index: 0,
                              isMobile: false,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTrustIndicators(ResponsiveSizingInfo sizingInfo) {
    final indicators = [
      {'icon': Icons.verified, 'text': '${widget.clients.length}+ Clientes'},
      {'icon': Icons.star, 'text': '4.9 Calificación'},
      {'icon': Icons.trending_up, 'text': '95% Retención'},
      {'icon': Icons.timer, 'text': '24/7 Soporte'},
    ];
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: indicators.asMap().entries.map((entry) {
          final indicator = entry.value;
          return Expanded(
            child: _TrustIndicator(
              icon: indicator['icon'] as IconData,
              text: indicator['text'] as String,
              delay: entry.key * 100,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ClientLogoItem extends StatefulWidget {
  final ClientModel client;
  final int index;
  final bool isMobile;

  const _ClientLogoItem({
    required this.client,
    required this.index,
    required this.isMobile,
  });

  @override
  State<_ClientLogoItem> createState() => _ClientLogoItemState();
}

class _ClientLogoItemState extends State<_ClientLogoItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Logo de cliente: ${widget.client.name}',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            // Optional: Handle client logo tap
            if (widget.client.websiteUrl != null) {
              // Launch URL
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: widget.isMobile ? 180.w : 150.w,
            height: widget.isMobile ? 100.h : 80.h,
            padding: EdgeInsets.all(widget.isMobile ? 16.w : 12.w),
            decoration: BoxDecoration(
              color: _isHovered 
                  ? AppTheme.background 
                  : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: _isHovered 
                    ? AppTheme.accentGold.withOpacity(0.3)
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppTheme.accentGold.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: widget.client.logoUrl != null
                  ? _buildLogoImage()
                  : _buildTextLogo(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoImage() {
    if (widget.client.logoUrl!.endsWith('.svg')) {
      return SvgPicture.network(
        widget.client.logoUrl!,
        placeholderBuilder: (context) => _buildLogoShimmer(),
        color: _isHovered ? null : AppTheme.textSecondary,
        colorBlendMode: _isHovered ? BlendMode.dst : BlendMode.srcIn,
      );
    }
    
    return CachedNetworkImage(
      imageUrl: widget.client.logoUrl!,
      placeholder: (context, url) => _buildLogoShimmer(),
      errorWidget: (context, url, error) => _buildTextLogo(),
      color: _isHovered ? null : AppTheme.textSecondary,
      colorBlendMode: _isHovered ? BlendMode.dst : BlendMode.srcIn,
    );
  }

  Widget _buildTextLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.client.industry != null)
          Icon(
            _getIndustryIcon(widget.client.industry!),
            size: 32.sp,
            color: _isHovered 
                ? AppTheme.accentGold 
                : AppTheme.textSecondary,
          )
            .animate(target: _isHovered ? 1 : 0)
            .scale(end: const Offset(1.1, 1.1))
            .rotate(end: 0.05),
        
        SizedBox(height: 8.h),
        
        Text(
          widget.client.name,
          style: TextStyle(
            fontSize: widget.isMobile ? 14.sp : 16.sp,
            fontWeight: FontWeight.w600,
            color: _isHovered 
                ? AppTheme.primaryNavy 
                : AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildLogoShimmer() {
    return Shimmer.fromColors(
      baseColor: AppTheme.divider,
      highlightColor: AppTheme.divider.withOpacity(0.5),
      child: Container(
        width: 100.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  IconData _getIndustryIcon(String industry) {
    switch (industry.toLowerCase()) {
      case 'legal':
      case 'notaría':
        return Icons.gavel;
      case 'gobierno':
      case 'government':
        return Icons.account_balance;
      case 'tecnología':
      case 'technology':
        return Icons.computer;
      case 'educación':
      case 'education':
        return Icons.school;
      case 'salud':
      case 'health':
        return Icons.local_hospital;
      case 'finanzas':
      case 'finance':
        return Icons.account_balance_wallet;
      default:
        return Icons.business;
    }
  }
}

class _TrustIndicator extends StatelessWidget {
  final IconData icon;
  final String text;
  final int delay;

  const _TrustIndicator({
    required this.icon,
    required this.text,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        children: [
          Icon(
            icon,
            size: 28.sp,
            color: AppTheme.accentGold,
          )
            .animate(delay: delay.ms)
            .fadeIn(duration: 500.ms)
            .scale(begin: const Offset(0.5, 0.5)),
          
          SizedBox(height: 8.h),
          
          Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          )
            .animate(delay: (delay + 100).ms)
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}

// Client Model
class ClientModel {
  final String id;
  final String name;
  final String? logoUrl;
  final String? websiteUrl;
  final String? industry;
  final DateTime? clientSince;
  final String? testimonial;
  
  const ClientModel({
    required this.id,
    required this.name,
    this.logoUrl,
    this.websiteUrl,
    this.industry,
    this.clientSince,
    this.testimonial,
  });
  
  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      industry: json['industry'] as String?,
      clientSince: json['clientSince'] != null 
          ? DateTime.parse(json['clientSince'] as String)
          : null,
      testimonial: json['testimonial'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'websiteUrl': websiteUrl,
      'industry': industry,
      'clientSince': clientSince?.toIso8601String(),
      'testimonial': testimonial,
    };
  }
}