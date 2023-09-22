import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // 마이크 권한 확인 및 요청
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  // 파일 시스템 접근 권한 확인 및 요청
  Future<bool> requestFilePermission() async {
    final status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }
}
