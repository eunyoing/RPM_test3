// ✅ BPM 운동 트래킹 페이지 구현
import 'dart:async';
import 'package:flutter/material.dart';
import 'main_map.dart';

late int _bpm;

class BpmTrackerPage extends StatefulWidget {
  final int bpm;
  final int seconds;
  final void Function(int) onTick;

  const BpmTrackerPage({
    Key? key,
    required this.bpm,
    required this.seconds,
    required this.onTick,
  }) : super(key: key);

  @override
  State<BpmTrackerPage> createState() => _BpmTrackerPageState();
}

class _BpmTrackerPageState extends State<BpmTrackerPage> with AutomaticKeepAliveClientMixin {
  late Timer _timer;
  int _seconds = 0;
  bool _isRunning = true;

  @override
  bool get wantKeepAlive => true;

  double get _kilometers => (_seconds / 3600) * (_bpm / 150 * 8);
  double get _speedKmPerHour => (_bpm / 150) * 8;
  double get _pace => _speedKmPerHour > 0 ? 60 / _speedKmPerHour : 0;
  int get _calories => (_kilometers * 60).round();

  @override
  void initState() {
    super.initState();
    _bpm = widget.bpm;
    _startTimer();
  }

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _seconds++;
        widget.onTick(_seconds);
      });
    });
  }

  void _stopTimer() {
    _isRunning = false;
    _timer.cancel();
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() => _seconds = 0);
  }

  void _toggleTimer() {
    if (_isRunning) {
      _stopTimer();
    } else {
      _startTimer();
    }
    setState(() {});
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }

  String _formatPace() {
    if (_kilometers == 0 || _seconds <= 60) return '--:--"';
    final paceMinutes = (_seconds / 60) / _kilometers;
    final min = paceMinutes.floor();
    final sec = ((paceMinutes - min) * 60).round();
    return '${min.toString().padLeft(1)}\'${sec.toString().padLeft(2, '0')}"';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _buildDataColumn(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFF670C),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text('${widget.bpm}', style: const TextStyle(fontSize: 90, fontWeight: FontWeight.bold)),
                const Text('BPM', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 270),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDataColumn(_formatPace(), '페이스'),
                      _buildDataColumn(_kilometers.toStringAsFixed(2), '킬로미터'),
                    ],
                  ),
                  const SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDataColumn(_formatTime(_seconds), '시간'),
                      _buildDataColumn('$_calories', '칼로리'),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _stopTimer();
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('그만 달리시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('아니요'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx); // 다이얼로그 닫기
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const MapPage(isLocationAgreed: true, showLoginBanner: false)),
                              );
                            },
                            child: const Text('네'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(32),
                  ),
                  child: const Icon(Icons.stop, color: Colors.black, size: 48),
                ),
                ElevatedButton(
                  onPressed: _toggleTimer,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(32),
                  ),
                  child: Text(
                    _isRunning ? '정지' : '계속',
                    style: const TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}