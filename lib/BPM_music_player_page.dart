import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'audio_manager.dart';
import 'models/song_class.dart';
import 'voulume _control_page.dart'; // 기존 코드 유지

class BpmPlayerPage extends StatefulWidget {
  final List<Song> songs;
  final int initialIndex;

  const BpmPlayerPage({
    Key? key,
    required this.songs,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<BpmPlayerPage> createState() => _BpmPlayerPageState();
}

class _BpmPlayerPageState extends State<BpmPlayerPage> {
  late AudioPlayer _audioPlayer;
  int currentIndex = 0;
  bool isPlaying = false;

  double musicVolume = 1.0;
  double metronomeVolume = 0.3;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  Timer? _metronomeTimer;

  Song get currentSong => widget.songs[currentIndex];

  @override
  void initState() {
    super.initState();

    AudioManager.replacePlayer();
    _audioPlayer = AudioManager.player;
    currentIndex = widget.initialIndex;

    _clickPlayer = AudioPlayer(); // ✅ 메트로놈 플레이어 준비
    _clickPlayer!.setAsset('assets/audio/metronome.mp3'); // ✅ 한 번만 로딩!

    // ✅ 바로 여기! — 재생 상태 변화 감지해서 UI에 반영
    _audioPlayer.playingStream.listen((playing) {
      setState(() {
        isPlaying = playing;
      });
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _playNext();
      }
    });

    _audioPlayer.positionStream.listen((pos) {
      setState(() {
        _position = pos;
      });
    });

    _audioPlayer.durationStream.listen((dur) {
      setState(() {
        _duration = dur ?? Duration.zero;
      });
    });

    _playAudio();
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.setAsset(currentSong.audioPath);
      await _audioPlayer.load();
      await _audioPlayer.setVolume(musicVolume);
      await _audioPlayer.play();

      Future.delayed(const Duration(milliseconds: 100), () {
        _startMetronome();
      });
      setState(() => isPlaying = true);
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
    _stopMetronome();
    setState(() => isPlaying = false);
  }

  Future<void> _playPrevious() async {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      await _playAudio();
    }
  }

  Future<void> _playNext() async {
    if (currentIndex < widget.songs.length - 1) {
      setState(() {
        currentIndex++;
      });
      await _playAudio();
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 메트로놈 시작 함수: 매 틱마다 새 AudioPlayer 인스턴스로 재생
  void _startMetronome() {
    _stopMetronome(); // 이전 타이머 제거

    final bpm = AudioManager.currentBpm;
    if (bpm <= 0) return;

    final intervalMs = (60000 / bpm).round();

    _metronomeTimer = Timer.periodic(
      Duration(milliseconds: intervalMs),
          (_) {
        _playMetronomeClick();
      },
    );
  }

  AudioPlayer? _clickPlayer;

  Future<void> _playMetronomeClick() async {
    try {
      // 최초 1회만 생성
      _clickPlayer ??= AudioPlayer();

      await _clickPlayer!.setAsset('assets/audio/metronome.mp3');
      await _clickPlayer!.setVolume(metronomeVolume);
      await _clickPlayer!.play();
    } catch (e) {
      print('🔴 메트로놈 재생 오류: $e');
    }
  }


  // 메트로놈 정지 함수
  void _stopMetronome() {
    _metronomeTimer?.cancel();
    _metronomeTimer = null;
  }
  // ──────────────────────────────────────────────────────────────────────────

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _stopMetronome();
    _audioPlayer.dispose();
    super.dispose();
    _clickPlayer?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remainingSongs = widget.songs.sublist(currentIndex + 1);

    return Scaffold(
      backgroundColor: const Color(0xFFFF670C),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF670C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            _audioPlayer.stop();
            _stopMetronome();
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: const [
            Icon(Icons.music_note, color: Colors.black),
            SizedBox(width: 4),
            Text(
              "music",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Text(
                    "${currentSong.bpm}",
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    "BPM",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Divider(thickness: 1, color: Colors.black),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
              child: Row(
                children: const [
                  Icon(Icons.radio_button_unchecked, size: 20),
                  SizedBox(width: 6),
                  Text("재생 중인 곡", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            _buildSongTile(currentSong),
            const Divider(thickness: 1, color: Colors.black),
            Expanded(
              child: remainingSongs.isEmpty
                  ? const Center(
                child: Text(
                  "재생 대기 중인 곡이 없습니다.",
                  style: TextStyle(color: Colors.white70),
                ),
              )
                  : ListView.builder(
                itemCount: remainingSongs.length,
                itemBuilder: (context, index) {
                  final song = remainingSongs[index];
                  final realIndex = currentIndex + 1 + index;

                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        currentIndex = realIndex;
                      });
                      await _playAudio();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            song.imagePath,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(song.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(song.artist),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: Row(
                children: [
                  Text(_formatDuration(_position), style: const TextStyle(color: Colors.white)),
                  Expanded(
                    child: Slider(
                      value: _position.inMilliseconds.toDouble().clamp(0, _duration.inMilliseconds.toDouble()),
                      max: _duration.inMilliseconds.toDouble(),
                      onChanged: (value) async {
                        final position = Duration(milliseconds: value.toInt());
                        await _audioPlayer.seek(position);
                      },
                      activeColor: Colors.white,
                      inactiveColor: Colors.white54,
                    ),
                  ),
                  Text(_formatDuration(_duration), style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.volume_up, size: 32, color: Colors.white),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VolumeControlPage(
                            musicVolume: musicVolume,
                            metronomeVolume: metronomeVolume,
                            onVolumeChanged: (newMusic, newMetronome) {
                              setState(() {
                                musicVolume = newMusic;
                                metronomeVolume = newMetronome;
                                _audioPlayer.setVolume(musicVolume);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous, size: 40, color: Colors.white),
                      onPressed: _playPrevious,
                    ),
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                        size: 60,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          _pauseAudio();
                        } else {
                          _playAudio();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, size: 40, color: Colors.white),
                      onPressed: _playNext,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSongTile(Song song) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(song.imagePath, width: 40, height: 40, fit: BoxFit.cover),
        ),
        title: Text(song.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(song.artist),
      ),
    );
  }
}
