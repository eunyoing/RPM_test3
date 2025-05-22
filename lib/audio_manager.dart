import 'package:just_audio/just_audio.dart';

class AudioManager {
  static AudioPlayer _player = AudioPlayer(); // private

  static AudioPlayer get player => _player;

  static void setVolume(double volume) {
    _player.setVolume(volume);
  }

  static void replacePlayer() {
    _player.dispose();       // 기존 player 정리
    _player = AudioPlayer(); // 새 player 생성
  }

  static int currentBpm = 140;
}
