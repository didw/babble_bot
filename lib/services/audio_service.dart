import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final Record _audioRecorder = Record();
  final AudioPlayer audioPlayer = AudioPlayer();
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;

  AudioService() {
    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      _recordState = recordState;
    });
  }

  Future<void> startRecording(String path) async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // Starting the recording
        await _audioRecorder.start(
          path: path, // specify the path to save the audio recording
          encoder: AudioEncoder.wav, // specify the encoder
        );
        _recordState = RecordState.record;
      }
    } catch (e) {
      print('Failed to start recording: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      if (path != null) {
        print('Recording stopped and saved to: $path');
      }
      _recordState = RecordState.stop;
    } catch (e) {
      print('Failed to stop recording: $e');
    }
  }

  Future<void> playTtsAudio(Uint8List audioData, String savePath) async {
    try {
      // 1. Save the audio data to a file
      final file = File(savePath);
      await file.writeAsBytes(audioData, flush: true);

      // 2. Play the audio file
      await audioPlayer.play(DeviceFileSource(savePath));
    } catch (e) {
      print("Failed to play TTS audio: $e");
    }
  }

  RecordState get recordState => _recordState;

  void dispose() {
    _recordSub?.cancel();
    _audioRecorder.dispose();
  }
}
