import 'package:flutter/material.dart';
import 'package:movielog/common_app_bar.dart';

class MovieScreen extends StatelessWidget {
  const MovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '영화',
      ),
    );
  }
}