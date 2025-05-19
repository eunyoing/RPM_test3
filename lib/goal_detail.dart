import 'package:flutter/material.dart';
import 'main_goal_record.dart';
class GoalDetailPage extends StatelessWidget {
  const GoalDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF670C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0), // 🔧 좌우 여백 추가
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 🔧 왼쪽 정렬
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalRecordPage()),),
                    icon: const Icon(Icons.arrow_back, size: 35,color: Colors.black),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Row(
                      children: const [
                        Icon(Icons.local_fire_department, size: 27),
                        SizedBox(width: 4),
                        Text(
                          "record (목표 설정)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 27),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 30),

              // BPM
              const Text(
                "120",
                style: TextStyle(
                    fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const Text("BPM",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 40),

              // 거리
              const Text("거리",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  width: 260, // 🔧 가로 폭 줄이기
                  child: LinearProgressIndicator(
                    value: 0.9,
                    minHeight: 20, // 🔧 막대 높이 증가
                    backgroundColor: Colors.white,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("→ 90% (실패)",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("1km", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),

              // 시간
              const Text("시간",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  width: 260,
                  child: LinearProgressIndicator(
                    value: 0.85,
                    minHeight: 20,
                    backgroundColor: Colors.white,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("→ 85% (실패)",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("10분", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 30),

              // 평균 페이스
              const Text("평균 페이스",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              const Text("--- 평균페이스 ---",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black)),
              const SizedBox(height: 30),

              // 칼로리
              const Text("칼로리",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              const Text("60",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black)),
              const SizedBox(height: 40),

              // playlist
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PlaylistPage()),
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.headphones, size: 24),
                      SizedBox(width: 8),
                      Text("제공된 playlist",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔧 예시용 PlaylistPage (이름만 만든 상태)
class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Playlist")),
      body: const Center(child: Text("여기에 플레이리스트 내용을 넣어주세요.")),
    );
  }
}
