import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class BpmMapPage extends StatefulWidget {
  final int bpm;
  final int seconds;

  const BpmMapPage({
    Key? key,
    required this.bpm,
    required this.seconds,
  }) : super(key: key);

  @override
  State<BpmMapPage> createState() => _BpmMapPageState();
}

class _BpmMapPageState extends State<BpmMapPage> with AutomaticKeepAliveClientMixin {
  int _bpm = 0;
  int _seconds = 0;

  @override
  void didUpdateWidget(covariant BpmMapPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seconds != widget.seconds || oldWidget.bpm != widget.bpm) {
      setState(() {
        _seconds = widget.seconds;
        _bpm = widget.bpm;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _bpm = widget.bpm;
    _seconds = widget.seconds;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final kilometers = (_seconds / 3600) * (_bpm / 150 * 8);
    final speed = (_bpm / 150) * 8;
    final calories = (kilometers * 60).round();

    String paceString;
    if (kilometers == 0 || _seconds <= 60) {
      paceString = '--:--"';
    } else {
      final paceMinutes = (_seconds / 60) / kilometers;
      final min = paceMinutes.floor();
      final sec = ((paceMinutes - min) * 60).round();
      paceString = '${min.toString().padLeft(1)}`${sec.toString().padLeft(2, '0')}"';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFF670C),
      body: Column(
        children: [
          Flexible(
            flex: 8,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(36.3624, 127.3449),
                zoom: 16,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              color: Color(0xFFFF670C),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDataColumn(paceString, '페이스'),
                      _buildDataColumn(_formatTime(_seconds), '시간'),
                      _buildDataColumn('$calories', '칼로리'),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataColumn(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 18)),
      ],
    );
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours >= 1) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }
}
