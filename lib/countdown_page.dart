import 'package:flutter/material.dart';
import 'package:rpm_test3/BPM_function_pageview.dart';
import 'BPM_function_1.dart'; // ✅ 실제 위치에 맞게 import 경로 조정해줘

class CountdownPage extends StatefulWidget {
  final VoidCallback onFinish;
  final int bpm; // ✅ 추가

  const CountdownPage({
    required this.onFinish,
    required this.bpm, // ✅ 추가
    Key? key,
  }) : super(key: key);

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

    // ✅ 카운트 다운 완료 → BPM_function_1 페이지로 이동
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BpmSlide(bpm: widget.bpm)),
      );
    }
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
