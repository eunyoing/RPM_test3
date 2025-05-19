import 'package:flutter/material.dart';
import 'goal_detail.dart';
import 'record_dis_page.dart';
import 'record_set_page.dart';
import 'record_date_page.dart';
import 'record_BPM_bpm_page.dart';
import 'record_BPM_date_page.dart';

class BpmRecordPage extends StatefulWidget {
  const BpmRecordPage({super.key});

  @override
  State<BpmRecordPage> createState() => _BpmRecordPageState();
}

class _BpmRecordPageState extends State<BpmRecordPage> {
  List<String> records = [
    "2025.03.25 | 120 bpm",
    "2025.03.30 | 110 bpm",
    "2025.04.05 | 90 bpm",
    "2025.04.08 | 130 bpm",
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
    int totalRowCount = 10; // 총 줄 수

    return Scaffold(
      backgroundColor: const Color(0xFFFF670C),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // 상단 중앙 정렬된 타이틀
            Row(
              children: [
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RecordPage()),),
                  icon: const Icon(Icons.arrow_back,size: 35,color: Colors.black,),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Row(
                    children: const [
                      Icon(Icons.local_fire_department, size: 27),
                      SizedBox(width: 4),
                      Text(
                        "record (bpm 설정)",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 27),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 32),
              ],
            ),
            const SizedBox(height: 20),

            // 정렬 드롭다운
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
                        color: Colors.black, fontWeight: FontWeight.bold),
                    dropdownColor: Colors.white,
                    onChanged: (value) {
                      if (value == 'bpm순') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RecordBpPage()),
                        );
                      } else if (value == '날짜순') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RecordBpDatePage()),
                        );
                      }
                    },
                    items: ['날짜순', 'bpm순']
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
            // 테이블 헤더 줄
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
                  // 세로줄
                  Positioned(
                    left: 55,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                  ListView.builder(
                    itemCount: totalRowCount,
                    itemBuilder: (context, index) {
                      final hasData = index < records.length;
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (hasData) _onTapRecord(index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const SizedBox(
                                      width: 1), // 세로줄은 Stack으로 대체됨
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      hasData ? records[index] : '',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(color: Colors.black),
                        ],
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
