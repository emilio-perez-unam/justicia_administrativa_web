import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:justicia_administrativa_web/core/theme/app_theme.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class AnimatedBackground extends StatefulWidget {
  final AnimationStyle style;
  final List<Color>? colors;
  final double speed;
  final double opacity;
  final bool interactive;
  
  const AnimatedBackground({
    super.key,
    this.style = AnimationStyle.particles,
    this.colors,
    this.speed = 1.0,
    this.opacity = 1.0,
    this.interactive = false,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _waveController;
  late AnimationController _meshController;
  
  double _mouseX = 0;
  double _mouseY = 0;
  
  final List<Particle> _particles = [];
  final List<Connection> _connections = [];
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: (20 / widget.speed).round()),
      vsync: this,
    )..repeat();
    
    _waveController = AnimationController(
      duration: Duration(seconds: (10 / widget.speed).round()),
      vsync: this,
    )..repeat();
    
    _meshController = AnimationController(
      duration: Duration(seconds: (30 / widget.speed).round()),
      vsync: this,
    )..repeat();
    
    _initializeParticles();
  }
  
  void _initializeParticles() {
    final random = math.Random();
    for (int i = 0; i < 50; i++) {
      _particles.add(
        Particle(
          position: Offset(
            random.nextDouble(),
            random.nextDouble(),
          ),
          velocity: Offset(
            (random.nextDouble() - 0.5) * 0.001,
            (random.nextDouble() - 0.5) * 0.001,
          ),
          radius: random.nextDouble() * 3 + 1,
          color: (widget.colors ?? _defaultColors)[
            random.nextInt((widget.colors ?? _defaultColors).length)
          ],
        ),
      );
    }
  }
  
  List<Color> get _defaultColors => [
    AppTheme.primaryNavy.withOpacity(0.3),
    AppTheme.techBlue.withOpacity(0.2),
    AppTheme.accentGold.withOpacity(0.1),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _waveController.dispose();
    _meshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.interactive) {
      return MouseRegion(
        onHover: (event) {
          setState(() {
            _mouseX = event.localPosition.dx;
            _mouseY = event.localPosition.dy;
          });
        },
        child: _buildBackground(),
      );
    }
    return _buildBackground();
  }

  Widget _buildBackground() {
    return Opacity(
      opacity: widget.opacity,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _waveController,
          _meshController,
        ]),
        builder: (context, child) {
          return CustomPaint(
            painter: _getBackgroundPainter(),
            size: Size.infinite,
          );
        },
      ),
    );
  }

  CustomPainter _getBackgroundPainter() {
    switch (widget.style) {
      case AnimationStyle.particles:
        return ParticleBackgroundPainter(
          particles: _particles,
          animation: _controller.value,
          mousePosition: Offset(_mouseX, _mouseY),
          interactive: widget.interactive,
        );
      case AnimationStyle.waves:
        return WaveBackgroundPainter(
          animation: _waveController.value,
          colors: widget.colors ?? _defaultColors,
        );
      case AnimationStyle.mesh:
        return MeshGradientPainter(
          animation: _meshController.value,
          colors: widget.colors ?? _defaultColors,
        );
      case AnimationStyle.geometric:
        return GeometricBackgroundPainter(
          animation: _controller.value,
          colors: widget.colors ?? _defaultColors,
        );
      case AnimationStyle.liquid:
        return LiquidBackgroundPainter(
          animation: _controller.value,
          colors: widget.colors ?? _defaultColors,
          mousePosition: Offset(_mouseX, _mouseY),
        );
      case AnimationStyle.network:
        return NetworkBackgroundPainter(
          particles: _particles,
          animation: _controller.value,
          mousePosition: Offset(_mouseX, _mouseY),
          interactive: widget.interactive,
        );
    }
  }
}

enum AnimationStyle {
  particles,
  waves,
  mesh,
  geometric,
  liquid,
  network,
}

// Particle model
class Particle {
  Offset position;
  Offset velocity;
  double radius;
  Color color;
  double life;
  
  Particle({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
    this.life = 1.0,
  });
  
  void update() {
    position += velocity;
    
    // Wrap around edges
    if (position.dx < 0) position = Offset(1, position.dy);
    if (position.dx > 1) position = Offset(0, position.dy);
    if (position.dy < 0) position = Offset(position.dx, 1);
    if (position.dy > 1) position = Offset(position.dx, 0);
  }
}

// Connection model for network style
class Connection {
  final Particle start;
  final Particle end;
  final double strength;
  
  Connection({
    required this.start,
    required this.end,
    required this.strength,
  });
}

// Particle Background Painter
class ParticleBackgroundPainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;
  final Offset mousePosition;
  final bool interactive;
  
  ParticleBackgroundPainter({
    required this.particles,
    required this.animation,
    required this.mousePosition,
    required this.interactive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    for (var particle in particles) {
      particle.update();
      
      final x = particle.position.dx * size.width;
      final y = particle.position.dy * size.height;
      
      // Interactive effect
      double scale = 1.0;
      if (interactive) {
        final distance = (Offset(x, y) - mousePosition).distance;
        if (distance < 100) {
          scale = 1.5 - (distance / 100) * 0.5;
        }
      }
      
      // Draw particle with glow effect
      paint.shader = RadialGradient(
        colors: [
          particle.color,
          particle.color.withOpacity(0),
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(x, y),
          radius: particle.radius * scale * 3,
        ),
      );
      
      canvas.drawCircle(
        Offset(x, y),
        particle.radius * scale * 3,
        paint,
      );
      
      // Draw core
      paint.shader = null;
      paint.color = particle.color;
      canvas.drawCircle(
        Offset(x, y),
        particle.radius * scale,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticleBackgroundPainter oldDelegate) {
    return true;
  }
}

// Wave Background Painter
class WaveBackgroundPainter extends CustomPainter {
  final double animation;
  final List<Color> colors;
  
  WaveBackgroundPainter({
    required this.animation,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    for (int i = 0; i < 3; i++) {
      final path = Path();
      final phase = animation * math.pi * 2 + (i * math.pi / 3);
      
      path.moveTo(0, size.height);
      
      for (double x = 0; x <= size.width; x += 10) {
        final y = size.height * 0.5 +
            math.sin((x / size.width) * math.pi * 2 + phase) *
            size.height * 0.1 * (i + 1);
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, size.height);
      path.close();
      
      paint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors[i % colors.length].withOpacity(0.1),
          colors[i % colors.length].withOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(WaveBackgroundPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}

// Mesh Gradient Painter
class MeshGradientPainter extends CustomPainter {
  final double animation;
  final List<Color> colors;
  
  MeshGradientPainter({
    required this.animation,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Create mesh points
    final points = <Offset>[];
    final cols = 5;
    final rows = 5;
    
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        final x = (j / (cols - 1)) * size.width +
            math.sin(animation * math.pi * 2 + i + j) * 20;
        final y = (i / (rows - 1)) * size.height +
            math.cos(animation * math.pi * 2 + i - j) * 20;
        points.add(Offset(x, y));
      }
    }
    
    // Draw mesh triangles
    for (int i = 0; i < rows - 1; i++) {
      for (int j = 0; j < cols - 1; j++) {
        final index = i * cols + j;
        final p1 = points[index];
        final p2 = points[index + 1];
        final p3 = points[index + cols];
        final p4 = points[index + cols + 1];
        
        // Triangle 1
        final path1 = Path()
          ..moveTo(p1.dx, p1.dy)
          ..lineTo(p2.dx, p2.dy)
          ..lineTo(p3.dx, p3.dy)
          ..close();
        
        paint.shader = LinearGradient(
          colors: [
            colors[(i + j) % colors.length].withOpacity(0.1),
            colors[(i + j + 1) % colors.length].withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(path1.getBounds());
        
        canvas.drawPath(path1, paint);
        
        // Triangle 2
        final path2 = Path()
          ..moveTo(p2.dx, p2.dy)
          ..lineTo(p4.dx, p4.dy)
          ..lineTo(p3.dx, p3.dy)
          ..close();
        
        canvas.drawPath(path2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(MeshGradientPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}

// Geometric Background Painter
class GeometricBackgroundPainter extends CustomPainter {
  final double animation;
  final List<Color> colors;
  
  GeometricBackgroundPainter({
    required this.animation,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Draw rotating polygons
    for (int i = 0; i < 5; i++) {
      final radius = 50.0 + i * 50;
      final sides = 3 + i * 2;
      final rotation = animation * math.pi * 2 * (i % 2 == 0 ? 1 : -1);
      
      paint.color = colors[i % colors.length].withOpacity(0.2 - i * 0.03);
      
      _drawPolygon(
        canvas,
        Offset(centerX, centerY),
        radius,
        sides,
        rotation,
        paint,
      );
    }
    
    // Draw connecting lines
    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * math.pi * 2 + animation * math.pi;
      final start = Offset(
        centerX + math.cos(angle) * 50,
        centerY + math.sin(angle) * 50,
      );
      final end = Offset(
        centerX + math.cos(angle) * 250,
        centerY + math.sin(angle) * 250,
      );
      
      paint.shader = LinearGradient(
        colors: [
          colors[0].withOpacity(0.1),
          colors[1].withOpacity(0),
        ],
      ).createShader(Rect.fromPoints(start, end));
      
      canvas.drawLine(start, end, paint);
    }
  }
  
  void _drawPolygon(
    Canvas canvas,
    Offset center,
    double radius,
    int sides,
    double rotation,
    Paint paint,
  ) {
    final path = Path();
    
    for (int i = 0; i <= sides; i++) {
      final angle = (i / sides) * math.pi * 2 + rotation;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(GeometricBackgroundPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}

// Liquid Background Painter
class LiquidBackgroundPainter extends CustomPainter {
  final double animation;
  final List<Color> colors;
  final Offset mousePosition;
  
  LiquidBackgroundPainter({
    required this.animation,
    required this.colors,
    required this.mousePosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Draw metaball blobs
    final blobs = <Blob>[];
    
    for (int i = 0; i < 5; i++) {
      final angle = (i / 5) * math.pi * 2 + animation * math.pi * 2;
      final x = size.width / 2 + math.cos(angle) * size.width * 0.2;
      final y = size.height / 2 + math.sin(angle) * size.height * 0.2;
      
      blobs.add(
        Blob(
          position: Offset(x, y),
          radius: 50 + math.sin(animation * math.pi * 2 + i) * 20,
          color: colors[i % colors.length],
        ),
      );
    }
    
    // Add mouse blob if interactive
    if (mousePosition != Offset.zero) {
      blobs.add(
        Blob(
          position: mousePosition,
          radius: 40,
          color: colors.first,
        ),
      );
    }
    
    // Draw blobs with metaball effect
    for (final blob in blobs) {
      paint.shader = RadialGradient(
        colors: [
          blob.color.withOpacity(0.3),
          blob.color.withOpacity(0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(
        Rect.fromCircle(
          center: blob.position,
          radius: blob.radius * 2,
        ),
      );
      
      canvas.drawCircle(blob.position, blob.radius * 2, paint);
    }
    
    // Apply blur for liquid effect
    canvas.saveLayer(Rect.largest, Paint()..imageFilter = ui.ImageFilter.blur(
      sigmaX: 20,
      sigmaY: 20,
    ));
    canvas.restore();
  }

  @override
  bool shouldRepaint(LiquidBackgroundPainter oldDelegate) {
    return animation != oldDelegate.animation ||
           mousePosition != oldDelegate.mousePosition;
  }
}

// Network Background Painter
class NetworkBackgroundPainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;
  final Offset mousePosition;
  final bool interactive;
  
  NetworkBackgroundPainter({
    required this.particles,
    required this.animation,
    required this.mousePosition,
    required this.interactive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;
    
    // Update and draw particles
    for (var particle in particles) {
      particle.update();
      
      final x = particle.position.dx * size.width;
      final y = particle.position.dy * size.height;
      
      // Draw connections
      for (var other in particles) {
        if (particle == other) continue;
        
        final otherX = other.position.dx * size.width;
        final otherY = other.position.dy * size.height;
        final distance = math.sqrt(
          math.pow(x - otherX, 2) + math.pow(y - otherY, 2),
        );
        
        if (distance < 100) {
          final opacity = (1 - distance / 100) * 0.2;
          paint
            ..color = particle.color.withOpacity(opacity)
            ..strokeWidth = 1;
          
          canvas.drawLine(
            Offset(x, y),
            Offset(otherX, otherY),
            paint,
          );
        }
      }
      
      // Draw particle
      paint
        ..style = PaintingStyle.fill
        ..color = particle.color;
      
      canvas.drawCircle(
        Offset(x, y),
        particle.radius,
        paint,
      );
    }
    
    // Interactive mouse effect
    if (interactive && mousePosition != Offset.zero) {
      for (var particle in particles) {
        final x = particle.position.dx * size.width;
        final y = particle.position.dy * size.height;
        final distance = (Offset(x, y) - mousePosition).distance;
        
        if (distance < 150) {
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = (1 - distance / 150) * 2
            ..color = AppTheme.accentGold.withOpacity(
              (1 - distance / 150) * 0.5,
            );
          
          canvas.drawLine(
            Offset(x, y),
            mousePosition,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(NetworkBackgroundPainter oldDelegate) {
    return true;
  }
}

// Blob model for liquid effect
class Blob {
  final Offset position;
  final double radius;
  final Color color;
  
  Blob({
    required this.position,
    required this.radius,
    required this.color,
  });
}