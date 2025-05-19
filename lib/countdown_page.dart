import 'package:flutter/material.dart';

class CountdownPage extends StatefulWidget {
  final VoidCallback onFinish;

  const CountdownPage({required this.onFinish, Key? key}) : super(key: key);

  @override
  State<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  int _count = 3;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() async {
    while (_count > 1) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _count--;
      });
    }
    await Future.delayed(const Duration(seconds: 1));
    widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF670C),
      body: Center(
        child: Text(
          '$_count',
          style: const TextStyle(
            fontSize: 120,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
