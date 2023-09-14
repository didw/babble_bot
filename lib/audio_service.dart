import 'package:flutter_sound/flutter_sound.dart';

class AudioRecorderService {
  FlutterSoundRecorder? myRecorder;

  Future<void> init() async {
    myRecorder = FlutterSoundRecorder();
    await myRecorder!.openRecorder();
  }

  Future<void> dispose() async {
    await myRecorder!.closeRecorder();
    myRecorder = null;
  }

  Future<void> startRecording(String path) async {
    await myRecorder!.startRecorder(
      toFile: path,
      codec: Codec.pcm16WAV,
    );
  }

  Future<void> stopRecording() async {
    await myRecorder!.stopRecorder();
  }
}
