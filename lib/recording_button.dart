import 'package:flutter/material.dart';

class RecordingButton extends StatefulWidget {
  final Function() onStartRecording;
  final Function() onStopRecording;
  final Function() onFetchResponse;

  const RecordingButton({
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
            widget.onStopRecording();
            setState(() {
              recordButtonState = RecordButtonState.waiting;
            });
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
      child: Text(getButtonText()),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(fontSize: 20),
      ),
    );
  }

  String getButtonText() {
    switch (recordButtonState) {
      case RecordButtonState.idle:
        return "발화 시작";
      case RecordButtonState.recording:
        return "발화 종료";
      case RecordButtonState.waiting:
        return "응답 대기";
      default:
        return "";
    }
  }
}

enum RecordButtonState { idle, recording, waiting }
