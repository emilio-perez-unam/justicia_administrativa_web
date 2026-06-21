import 'package:flutter/material.dart';
import '../components/team.dart';

class TeamView extends StatelessWidget {
  const TeamView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [SizedBox(height: 88), TeamSection()]);
  }
}
