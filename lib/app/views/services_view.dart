import 'package:flutter/material.dart';
import '../components/services.dart';

class ServicesView extends StatelessWidget {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [SizedBox(height: 88), ServicesSection()]);
  }
}
