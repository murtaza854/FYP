import 'package:flutter/material.dart';

class ComingSoonScreen extends StatelessWidget {
  static const routeName = '/coming-soon';
  const ComingSoonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coming Soon'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text('Coming Soon'),
      ),
    );
  }
}
