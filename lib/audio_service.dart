import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';

class AudioService {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;

  AudioService() {
    _recorder = FlutterSoundRecorder();
  }

  Future<void> startRecording(String path) async {
    await _recorder!.openRecorder();
    await _recorder!.startRecorder(
      toFile: path,
      codec: Codec.pcm16,
    );
    _isRecording = true;
  }

  Future<void> stopRecording() async {
    await _recorder!.stopRecorder();
    await _recorder!.closeRecorder();
    _isRecording = false;
  }

  bool get isRecording => _isRecording;
}
