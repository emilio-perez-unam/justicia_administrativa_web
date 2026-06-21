import 'package:flutter/material.dart';
import '../components/contact.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Column(children: [SizedBox(height: 88), ContactSection()]),
    );
  }
}
