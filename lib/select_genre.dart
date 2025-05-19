import 'package:flutter/material.dart';
import 'artist_select_page.dart';
import 'main_map.dart';

class SelectGenrePage extends StatefulWidget {
  @override
  _SelectGenrePageState createState() => _SelectGenrePageState();
}

class _SelectGenrePageState extends State<SelectGenrePage> {
  final List<String> genres = [
    '전체', '가요', '댄스', '팝송',
    '인디', 'R&B', '클래식', '트로트'
  ];

  Set<String> selectedGenres = {}; // ✅ 선택된 장르들 저장

  // ✅ 토글 함수: 전체/부분 선택 처리
  void _toggleGenre(String genre) {
    setState(() {
      if (genre == '전체') {
        if (selectedGenres.contains('전체')) {
          selectedGenres.clear();
        } else {
          selectedGenres = genres.toSet();
        }
      } else {
        if (selectedGenres.contains(genre)) {
          selectedGenres.remove(genre);
          selectedGenres.remove('전체'); // 하나라도 해제되면 전체 해제
        } else {
          selectedGenres.add(genre);

          final rest = genres.where((g) => g != '전체');
          if (rest.every((g) => selectedGenres.contains(g))) {
            selectedGenres.add('전체'); // 전부 선택되면 전체 자동 선택
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF670C),
      appBar: AppBar(
        backgroundColor: Color(0xFFFF670C),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 8),
            Text(
              "RPM",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "선호하는 노래 장르를 선택하세요",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Divider(thickness: 2, color: Colors.black),
            SizedBox(height: 24),

            // ✅ 장르 선택 그리드
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 33,
                crossAxisSpacing: 13,
                childAspectRatio: 1.8,
                children: genres.map((genre) {
                  final isSelected = selectedGenres.contains(genre);
                  return ElevatedButton(
                    onPressed: () => _toggleGenre(genre),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.grey[400] : Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      genre,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),

            Divider(thickness: 2, color: Colors.black),
            SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MapPage(isLocationAgreed: true),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("건너뛰기", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ArtistSelectPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("다음", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}


