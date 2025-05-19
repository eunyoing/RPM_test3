import 'package:flutter/material.dart';
import 'UserInfo.dart'; // ✅ 이 줄이 중요!

class ResultPage extends StatelessWidget {
  final UserInfo userInfo;

  const ResultPage({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    final bmi = userInfo.bmi;
    final category = userInfo.bmiCategory;

    return Scaffold(
      appBar: AppBar(title: Text("BMI 결과")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${userInfo.nickname}님의 BMI는"),
            SizedBox(height: 8),
            Text(
              bmi.toStringAsFixed(1),
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("판정: $category", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("돌아가기"),
            ),
          ],
        ),
      ),
    );
  }
}
