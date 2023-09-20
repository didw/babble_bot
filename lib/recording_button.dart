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
      child: getButtonChild(),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16.0),
        shape: CircleBorder(), // 원형 버튼
      ),
    );
  }

  Widget getButtonChild() {
    switch (recordButtonState) {
      case RecordButtonState.idle:
        return Icon(Icons.mic, size: 24.0);
      case RecordButtonState.recording:
        return Icon(Icons.stop, size: 24.0);
      case RecordButtonState.waiting:
        return SizedBox(
          width: 24.0,
          height: 24.0,
          child: CircularProgressIndicator(color: Colors.white),
        );
      default:
        return Icon(Icons.error, size: 24.0);
    }
  }
}

enum RecordButtonState { idle, recording, waiting }
