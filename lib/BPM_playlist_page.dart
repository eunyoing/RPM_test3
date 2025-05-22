import 'package:flutter/material.dart';
import 'models/song_class.dart';
import 'song_class.dart'; // ✅ allSongs 정의된 파일 (예: song_data.dart)
import 'BPM_music_player_page.dart';
import 'countdown_page.dart';

class BpmPlaylistPage extends StatefulWidget {
  final int bpm;

  const BpmPlaylistPage({required this.bpm});

  @override
  State<BpmPlaylistPage> createState() => _BpmPlaylistPageState();
}

class _BpmPlaylistPageState extends State<BpmPlaylistPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Song> filteredSongs = allSongs.where((song) => song.bpm == widget.bpm).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFF670C),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF670C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 4),
          const Text(
            "BPM",
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            "${widget.bpm}",
            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Divider(thickness: 2, color: Colors.black),
          Expanded(
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: filteredSongs.isEmpty
                  ? const Center(
                child: Text("해당 BPM의 노래가 없습니다.", style: TextStyle(color: Colors.black87, fontSize: 18)),
              )
                  : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredSongs.length,
                      itemBuilder: (context, index) {
                        final song = filteredSongs[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.asset(
                                  song.imagePath,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(song.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    Text(song.artist, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.play_arrow, color: Colors.black),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BpmPlayerPage(
                                        bpm: widget.bpm,
                                        songs: filteredSongs,
                                        initialIndex: index,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (filteredSongs.length > 1)
                    Column(
                      children: [
                        Slider(
                          value: currentIndex.toDouble(),
                          min: 0,
                          max: (filteredSongs.length - 1).toDouble(),
                          divisions: filteredSongs.length - 1,
                          onChanged: (value) {
                            setState(() {
                              currentIndex = value.toInt();
                            });
                          },
                        ),
                        Text(
                          "${filteredSongs[currentIndex].title} - ${filteredSongs[currentIndex].artist}",
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const Divider(thickness: 2, color: Colors.black),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: filteredSongs.isNotEmpty
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CountdownPage(
                      onFinish: () {
                        Navigator.pop(context);
                      },
                      bpm: widget.bpm,
                    ),
                  ),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                disabledBackgroundColor: Colors.white38,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "시작하기",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
