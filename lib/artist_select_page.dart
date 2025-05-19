import 'package:flutter/material.dart';
import 'main_map.dart';

class ArtistSelectPage extends StatefulWidget {
  @override
  _ArtistSelectPageState createState() => _ArtistSelectPageState();
}

class _ArtistSelectPageState extends State<ArtistSelectPage> {
  TextEditingController _searchController = TextEditingController();
  final Map<String, String> artistImages = {
    '아이유 (IU)': 'assets/images/idol/IU.png',
    'BTS': 'assets/images/idol/bts.png',
    '싸이 (PSY)': 'assets/images/idol/psy.png',
    '블랙핑크': 'assets/images/idol/blackpink.png',
    '뉴진스': 'assets/images/idol/newjeans.png',
    '엑소': 'assets/images/idol/exo.png',
    '지코': 'assets/images/idol/zico.png',
    '태연': 'assets/images/idol/taeyeon.png',
    '볼빨간사춘기': 'assets/images/idol/bol4.png',
  };

  List<String> allArtists = [
    '싸이 (PSY)',
    '아이유 (IU)',
    'BTS',
    '블랙핑크',
    '뉴진스',
    '엑소',
    '지코',
    '태연',
    '볼빨간사춘기'
  ];

  List<String> filteredArtists = [];
  Set<String> selectedArtists = {}; // ✅ 여러 선택

  @override
  void initState() {
    super.initState();
    filteredArtists = List.from(allArtists);
  }

  void _searchArtist(String query) {
    setState(() {
      filteredArtists = allArtists
          .where((artist) => artist.toLowerCase().contains(query.toLowerCase()) ||
          artist.contains(query)) // ✅ 한글 필터
          .toList();
    });
  }

  void _toggleSelect(String artist) {
    setState(() {
      if (selectedArtists.contains(artist)) {
        selectedArtists.remove(artist);
      } else {
        selectedArtists.add(artist);
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
        centerTitle: true,
        title: Text(
          'RPM',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: 26,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Center(
              child: Text(
                "선호하는 아티스트를 선택하세요",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            SizedBox(height: 16),

            // 검색창
            TextField(
              controller: _searchController,
              onChanged: _searchArtist,
              decoration: InputDecoration(
                hintText: '아티스트 이름을 입력하세요',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),

            // 아티스트 리스트
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // ✅ 리스트 배경 흰색
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(8),
                child: ListView.separated(
                  itemCount: filteredArtists.length,
                  separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
                  itemBuilder: (context, index) {
                    final artist = filteredArtists[index];
                    final isSelected = selectedArtists.contains(artist);
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage(artistImages[artist] ?? 'assets/images/default.png'),
                        backgroundColor: Colors.grey[300],
                      ),
                      title: Text(
                        artist,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold, // ✅ 여기에 포함!
                        ),
                      ),                      subtitle: Text(
                      "장르 | 소속 | etc...",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                      trailing: Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? Colors.black : Colors.grey,
                      ),
                      onTap: () => _toggleSelect(artist),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 12),

            // 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => MapPage(isLocationAgreed: true)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("건너뛰기", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 선택된 아티스트를 출력 (디버그 용)
                    print("선택된 아티스트: $selectedArtists");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => MapPage(isLocationAgreed: true)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("확인", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
