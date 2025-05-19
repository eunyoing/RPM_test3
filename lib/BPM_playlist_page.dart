import 'package:flutter/material.dart';
import 'models/song_class.dart';
import 'BPM_music_player_page.dart';
import 'countdown_page.dart';

class BpmPlaylistPage extends StatelessWidget {
  final int bpm;

  BpmPlaylistPage({required this.bpm});

  final List<Song> allSongs = [
    Song(
      title: "Power",
      artist: "지드래곤",
      bpm: 180,
      audioPath: "assets/audio/power.mp3",
      imagePath: "assets/images/musicplay.jpg",
    ),
    Song(
      title: "Super Shy",
      artist: "뉴진스",
      bpm: 150,
      audioPath: "assets/audio/Super_Shy.mp3",
      imagePath: "assets/images/musicplay.jpg",
    ),
    Song(
      title: "Supersonic",
      artist: "프로미스나인",
      bpm: 140,
      audioPath: "assets/audio/Supersonic.mp3",
      imagePath: "assets/images/musicplay.jpg",
    ),
    Song(
      title: "Love 119",
      artist: "RIIZE",
      bpm: 99,
      audioPath: "assets/audio/love_119.mp3",
      imagePath: "assets/images/musicplay.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<Song> filteredSongs = allSongs.where((song) => song.bpm == bpm).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFF670C),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF670C),
        elevation: 0,
        title: const Text("BPM", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Text(
            "$bpm",
            style: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 2, color: Colors.black),
          Expanded(
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: filteredSongs.isEmpty
                  ? const Center(
                child: Text(
                  "해당 BPM의 노래가 없습니다.",
                  style: TextStyle(color: Colors.black87, fontSize: 18),
                ),
              )
                  : Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: filteredSongs.length,
                  itemBuilder: (context, index) {
                    final song = filteredSongs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Container(
                        color: Colors.grey[200],
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              song.imagePath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            song.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            "${song.artist} • ${song.bpm} BPM",
                            style: const TextStyle(color: Colors.black87),
                          ),
                          trailing: const Icon(Icons.play_arrow, color: Colors.black),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BpmPlayerPage(
                                  songs: filteredSongs,
                                  initialIndex: index,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BpmPlayerPage(
                              songs: filteredSongs,
                              initialIndex: 0,
                            ),
                          ),
                        );
                      },
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
          )
        ],
      ),
    );
  }
}
