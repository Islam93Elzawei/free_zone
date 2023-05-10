import 'package:flutter/material.dart';

class FullScreen extends StatefulWidget {
  const FullScreen({super.key, required this.url});
  final String url;
  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network(
          widget.url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
