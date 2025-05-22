import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'BPM_playlist_page.dart';
import 'countdown_page.dart';
import 'BPM_function_1.dart';
import 'audio_manager.dart';
import 'first.dart';

class BpmSelectPage extends StatefulWidget {
  const BpmSelectPage({Key? key}) : super(key: key);

  @override
  _BpmSelectPageState createState() => _BpmSelectPageState();
}

class _BpmSelectPageState extends State<BpmSelectPage>with RouteAware {
  int _bpm = 140;
  double _sliderValue = 100;

  Timer? _metronomeTimer;
  AudioPlayer? _clickPlayer;

  @override
  void initState() {
    super.initState();
    _startMetronomeLoop();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    _startMetronomeLoop(); // 다시 메트로놈 재생
  }

  @override
  void dispose() {
    _stopMetronomeLoop();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _startMetronomeLoop() {
    _stopMetronomeLoop(); // 기존 타이머 정리

    final intervalMs = (60000 / _bpm).round();

    _metronomeTimer = Timer.periodic(Duration(milliseconds: intervalMs), (_) async {
      try {
        _clickPlayer?.dispose(); // 이전 재생기 제거
        _clickPlayer = AudioPlayer();
        await _clickPlayer!.setAsset('assets/audio/metronome.mp3');
        await _clickPlayer!.setVolume(_sliderValue / 100);
        await _clickPlayer!.play();
      } catch (e) {
        print("❌ 메트로놈 오류: $e");
      }
    });
  }

  void _stopMetronomeLoop() {
    _metronomeTimer?.cancel();
    _metronomeTimer = null;
    _clickPlayer?.dispose();
    _clickPlayer = null;
  }

  void _increaseBpm() {
    setState(() {
      if (_bpm < 200) _bpm++;
      AudioManager.currentBpm = _bpm; // ✅ 여기!
    });
    _startMetronomeLoop();
  }

  void _decreaseBpm() {
    setState(() {
      if (_bpm > 40) _bpm--;
      AudioManager.currentBpm = _bpm; // ✅ 여기!
    });
    _startMetronomeLoop();
  }

  void _showBpmInputDialog() {
    final TextEditingController controller = TextEditingController(text: '$_bpm');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFE2C6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('BPM 입력', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              hintText: '예: 120',
              hintStyle: TextStyle(color: Colors.black45),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                final input = int.tryParse(controller.text);
                if (input != null && input >= 40 && input <= 200) {
                  setState(() {
                    _bpm = input;
                    AudioManager.currentBpm = _bpm;
                  });
                  Navigator.pop(context);
                  _startMetronomeLoop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF670C),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'BPM 설정',
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.black), // 🔹 글자 크기 줄임
            ),
            const SizedBox(height: 50),
            const Icon(Icons.monitor_heart, size: 150, color: Colors.black), // 🔹 아이콘 크기 줄임
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _circleButton(Icons.remove, _decreaseBpm, size: 36),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: _showBpmInputDialog,
                  child: GestureDetector(
                    onTap: _showBpmInputDialog,
                    child: Text(
                    '  $_bpm  ',
                    style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black), // 🔹 숫자 크기도 살짝 줄임
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                _circleButton(Icons.add, _increaseBpm, size: 36),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              '숫자를 눌러 직접 입력할 수 있어요',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  const Icon(Icons.volume_up, color: Colors.black, size: 37), // 🔹 아이콘 크기 줄임
                  Expanded(
                    child: Slider(
                      value: _sliderValue,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      activeColor: Colors.black,
                      inactiveColor: Colors.black26,
                      onChanged: (double newValue) {
                        setState(() {
                          _sliderValue = newValue;
                        });
                        AudioManager.setVolume(newValue / 100);
                      },
                    ),
                  ),
                  // 숫자 제거 or 축소
                  Text(
                    _sliderValue.round().toString(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _stopMetronomeLoop(); // 종료 후 이동
                Navigator.push(
                  // context,
                  // MaterialPageRoute(
                  //   builder: (_) => CountdownPage(
                  //     bpm: _bpm, // ✅ 전달
                  //     onFinish: () {
                  //       Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BpmPlaylistPage(bpm: _bpm),
                            // ✅ 다시 전달
                          ),
                  //       );
                  //     },
                  //   ),
                  // ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(
                  '다음',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onPressed, {double size = 40}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(10),
      ),
      child: Icon(icon, color: Colors.black, size: size), // 🔹 아이콘 크기 조절
    );
  }
}
