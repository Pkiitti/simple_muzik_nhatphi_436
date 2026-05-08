// lib/services/permission_service.dart
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Hàm xin quyền thông minh: Xin cả hai, chỉ cần 1 trong 2 được cho phép là OK
  Future<bool> requestSmartPermission() async {
    // Xin đồng thời cả quyền Bộ nhớ (máy cũ) và quyền Âm thanh (máy mới)
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.audio,
    ].request();

    // Trả về true nếu một trong hai quyền được cấp
    return statuses[Permission.storage]!.isGranted ||
        statuses[Permission.audio]!.isGranted;
  }

  // Các hàm cũ bạn có thể giữ lại hoặc xóa đi nếu không dùng
  Future<bool> requestStoragePermission() async => await Permission.storage.request().isGranted;
  Future<bool> requestAudioPermission() async => await Permission.audio.request().isGranted;
}