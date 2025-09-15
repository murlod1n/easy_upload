import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'constants/easy_upload_constants.dart';
import 'easy_upload_platform_interface.dart';

/// An implementation of [EasyUploadPlatform] that uses method channels.
class MethodChannelEasyUpload extends EasyUploadPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(methodChannelName);

  @override
  Future<void> uploadFile(String filePath, String serverUrl) {
    return methodChannel.invokeMethod<void>(methodUploadFile, {
      filePathKey: filePath,
      uploadUrlKey: serverUrl,
    });
  }

}
