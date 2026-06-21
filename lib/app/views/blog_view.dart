import 'package:flutter/material.dart';
import '../components/blog.dart';

class BlogView extends StatelessWidget {
  const BlogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Column(children: [SizedBox(height: 88), BlogSection()]),
    );
  }
}
