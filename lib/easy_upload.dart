
import 'easy_upload_platform_interface.dart';

class EasyUpload {

  Future<void> uploadFile(String filePath, String serverUrl) {
    return EasyUploadPlatform.instance.uploadFile(filePath, serverUrl);
  }

}
