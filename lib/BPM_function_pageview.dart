import 'package:flutter/material.dart';
import 'BPM_function_1.dart';
import 'BPM_function_1_Music.dart' as music;
import 'keepAlivepage.dart';
import 'song_class.dart';
import 'BPM_function_1_map.dart';

class BpmSlide extends StatefulWidget {
  final int bpm;
  const BpmSlide({Key? key, required this.bpm}) : super(key: key);

  @override
  State<BpmSlide> createState() => _BpmSlideWrapperState();
}

class _BpmSlideWrapperState extends State<BpmSlide> {
  late final PageController _controller;
  int trackerSeconds = 0;

  late int bpm; // 🔥 상태로 bpm 따로 선언

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 1);
    bpm = widget.bpm; // 초기값 설정
  }

  void _updateSeconds(int newSeconds) {
    setState(() => trackerSeconds = newSeconds);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSongs = allSongs.where((song) => song.bpm == bpm).toList(); // bpm 기준으로 필터링

    return Scaffold(
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        children: [
          KeepAlivePage(
            child: BpmMapPage(
              bpm: bpm,
              seconds: trackerSeconds,
            ),
          ),
          KeepAlivePage(
            child: BpmTrackerPage(
              bpm: bpm,
              seconds: trackerSeconds,
              onTick: _updateSeconds,
            ),
          ),
          KeepAlivePage(
            key: ValueKey('music-$bpm-${filteredSongs.length}'),
            child: music.BpmMusicPage(
              bpm: bpm,
              songs: filteredSongs,
              initialIndex: 0,
            ),
          ),
        ],
      ),
    );
  }
}