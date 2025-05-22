import 'package:flutter/material.dart';

class VolumeControlPage extends StatefulWidget {
  final double musicVolume;
  final double metronomeVolume;
  final Function(double, double) onVolumeChanged;

  const VolumeControlPage({
    Key? key,
    required this.musicVolume,
    required this.metronomeVolume,
    required this.onVolumeChanged,
  }) : super(key: key);

  @override
  State<VolumeControlPage> createState() => _VolumeControlPageState();
}

class _VolumeControlPageState extends State<VolumeControlPage> {
  late double _musicVolume;
  late double _metronomeVolume;

  @override
  void initState() {
    super.initState();
    _musicVolume = widget.musicVolume;
    _metronomeVolume = widget.metronomeVolume;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF670C),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/tongtongtong_sound.png', height: 350), // 귀여운 캐릭터 이미지
            const SizedBox(height: 20),
            // const Text(
            //   "음악과 메트로놈의\n소리를 조절할 수 있어요.",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 40),
            _buildSlider("메트로놈", _metronomeVolume, (val) {
              setState(() {
                _metronomeVolume = val;
              });
            }),
            _buildSlider("음악", _musicVolume, (val) {
              setState(() {
                _musicVolume = val;
              });
            }),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              onPressed: () {
                widget.onVolumeChanged(_musicVolume, _metronomeVolume);
                Navigator.pop(context);
              },
              child: const Text("닫기", style: TextStyle(color: Colors.black, fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.volume_up, color: Colors.black),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
            ],
          ),
          Slider(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.black,
            inactiveColor: Colors.white70,
          ),
        ],
      ),
    );
  }
}