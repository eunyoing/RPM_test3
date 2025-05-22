import 'package:flutter/material.dart';
import 'main_goal_record.dart';
import 'main_map.dart';
import 'record_bpm_page.dart';
import 'sub_BPM_set_page.dart';

class FuncPage extends StatelessWidget {
  const FuncPage({Key? key}) : super(key: key);
  Widget _buildImageButton({
    required String imagePath,
    required String buttonText,
    required VoidCallback onTap,
    bool showChallengeTag = false,
  }) {
    return Column(
      children: [
     ClipRect(
    child: Image.asset(
          imagePath,
          width: 220,
          height: 220,
          fit: BoxFit.cover,
        ),
     ),
        const SizedBox(height: 1),
        Stack(
          children: [
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                minimumSize: const Size(240, 100),
                padding: const EdgeInsets.symmetric(vertical: 1), // 🔸 내부 여백 줄이기
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            if (showChallengeTag)
              Positioned(
                top: 15,
                left: 8,
                child: Transform.rotate(
                  angle: -0.7,
                  child: Text(
                    '도전!',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

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
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MapPage(isLocationAgreed: true, showLoginBanner: false,)),
                ),
                icon: const Icon(Icons.home, size: 40, color: Colors.black),
              ),
            ),
            // 중앙 버튼 영역
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildImageButton(
                    imagePath: 'assets/images/tongtongtongBPM.png',
                    buttonText: 'BPM 설정',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BpmSelectPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildImageButton(
                    imagePath: 'assets/images/tongtongtonggoal.png',
                    buttonText: '목표 설정',
                    showChallengeTag: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GoalRecordPage()),
                      );
                    },
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
        if (text == "목표 설정") {
          //Navigator.push(
          //  context,
          //  MaterialPageRoute(builder: (_) => const GoalRecordPage()),
          //);
        } else if (text == "BPM 설정") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BpmSelectPage()),
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
      child: Text(text,
        style: const TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
