import 'package:flutter/material.dart';
import 'package:justicia_administrativa_web/shared/widgets/app_header.dart';
import 'package:justicia_administrativa_web/shared/widgets/app_footer.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key, required this.child});

  final Widget child;

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final ScrollController _scrollController = ScrollController();
  bool _showFooter = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (!_showFooter) {
        setState(() => _showFooter = true);
      }
    } else {
      if (_showFooter) {
        setState(() => _showFooter = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  widget.child,
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _showFooter ? null : 0,
                    child: _showFooter ? const AppFooter() : null,
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
