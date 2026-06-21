import 'package:flutter/material.dart';
import '../components/about.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Column(children: [SizedBox(height: 88), AboutSection()]),
    );
  }
}
