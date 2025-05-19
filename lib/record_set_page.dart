import 'package:flutter/material.dart';
import 'main_goal_record.dart';
import 'main_map.dart';
import 'record_bpm_page.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF670C),
      body: SafeArea(
        child: Stack(
          children: [
            // 좌측 상단 로고 및 텍스트
            Positioned(
              top: 16,
              left: 16,
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, size: 20),
                  const SizedBox(width: 4),
                  const Text(
                    'record',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // 우측 상단 홈 아이콘 (눌렀을 때 동작 가능하도록 GestureDetector로 감싸기)
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MapPage(isLocationAgreed: true)),
                ),
                icon: const Icon(Icons.home, size: 40, color: Colors.black),
              ),
            ),
            // 중앙 버튼 영역
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildButton("BPM 설정 기록", context),

                  const SizedBox(height: 70),
                  Stack(
                    children: [
                      _buildButton("목표 설정 기록", context),
                      Positioned(
                        top: 0,    // 버튼 위쪽으로 살짝 올리기
                        left: -7,   // 버튼 왼쪽으로 살짝 이동
                        child: Transform.rotate(
                          angle: -0.7, // 대각선 방향으로 기울이기 (음수는 시계 반대 방향 회전)
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF670C),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '도전!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (text == "목표 설정 기록") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GoalRecordPage()),
          );
        } else if (text == "BPM 설정 기록") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BpmRecordPage()),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        minimumSize: const Size(240, 100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      child: Text(text),
    );
  }
}
