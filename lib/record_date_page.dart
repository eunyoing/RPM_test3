import 'package:flutter/material.dart';
import 'goal_detail.dart';
import 'record_dis_page.dart';
import 'record_set_page.dart';

class DateGoalPage extends StatefulWidget {
  const DateGoalPage({super.key});

  @override
  State<DateGoalPage> createState() => _DateGoalPageState();
}

class _DateGoalPageState extends State<DateGoalPage> {
  List<String> records = [
    "2025.03.25 | 1km | 10분",
    "2025.03.30 | 5km | 40분",
    "2025.04.05 | 2km | 15분",
    "2025.04.08 | 3km | 30분",
  ];
  String sortOption = '날짜순';

  void _onTapRecord(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GoalDetailPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalRowCount = 10; // 보여주고 싶은 전체 줄 개수

    return Scaffold(
      backgroundColor: const Color(0xFFFF670C),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // 상단 바
            Row(
              children: [
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RecordPage()),),
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
            const SizedBox(height: 20),

            // 드롭다운
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  const Spacer(),
                  DropdownButton<String>(
                    value: sortOption,
                    icon: const Icon(Icons.arrow_drop_down),
                    underline: Container(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    dropdownColor: Colors.white,
                    onChanged: (value) {
                      if (value == '거리순') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RecordDistancePage()),
                        );
                      } else {
                        setState(() {
                          sortOption = value!;
                        });
                      }
                    },
                    items: ['날짜순', '거리순']
                        .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),

            const Divider(thickness: 1.5, color: Colors.black),

            // 헤더
            Row(
              children: const [
                SizedBox(width: 20),
                Text('No', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 20),
                VerticalDivider(width: 1, thickness: 1, color: Colors.black),
                SizedBox(width: 20),
                Text('기록', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(thickness: 1.5, color: Colors.black),

            // 목록
            Expanded(
              child: Stack(
                children: [
                  // 세로줄: 리스트 전체에 이어지도록 고정
                  Positioned(
                    left: 60, // 번호(30) + 여백(10 + 26)
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),

                  // 리스트 내용

            ListView.separated(
            itemCount: totalRowCount,
              separatorBuilder: (_, __) =>
              const Divider(thickness: 1, color: Colors.black),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onTapRecord(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 36),
                        Expanded(
                          child: Text(
                            index < records.length ? records[index] : '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
}
