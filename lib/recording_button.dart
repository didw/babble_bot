import 'package:flutter/material.dart';

class RecordingButton extends StatefulWidget {
  final Function() onStartRecording;
  // final Function() onStopRecording;
  final Future<void> Function() onStopRecording;
  final Function() onFetchResponse;

  const RecordingButton({super.key, 
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onFetchResponse,
  });

  @override
  _RecordingButtonState createState() => _RecordingButtonState();
}

class _RecordingButtonState extends State<RecordingButton> {
  RecordButtonState recordButtonState = RecordButtonState.idle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        switch (recordButtonState) {
          case RecordButtonState.idle:
            widget.onStartRecording();
            setState(() {
              recordButtonState = RecordButtonState.recording;
            });
            break;
          case RecordButtonState.recording:
            setState(() {
              recordButtonState = RecordButtonState.waiting;
            });
            await widget.onStopRecording();
            await widget.onFetchResponse();
            setState(() {
              recordButtonState = RecordButtonState.idle;
            });
            break;
          case RecordButtonState.waiting:
            // 무시
            break;
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        shape: const CircleBorder(), // 원형 버튼
      ),
      child: getButtonChild(),
    );
  }

  Widget getButtonChild() {
    switch (recordButtonState) {
      case RecordButtonState.idle:
        return const Icon(Icons.mic, size: 24.0);
      case RecordButtonState.recording:
        return const Icon(Icons.stop, size: 24.0);
      case RecordButtonState.waiting:
        return const SizedBox(
          width: 24.0,
          height: 24.0,
          child: CircularProgressIndicator(color: Colors.white),
        );
      default:
        return const Icon(Icons.error, size: 24.0);
    }
  }
}

enum RecordButtonState { idle, recording, waiting }
