import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'easy_upload_method_channel.dart';

abstract class EasyUploadPlatform extends PlatformInterface {
  /// Constructs a EasyUploadPlatform.
  EasyUploadPlatform() : super(token: _token);

  static final Object _token = Object();

  static EasyUploadPlatform _instance = MethodChannelEasyUpload();

  /// The default instance of [EasyUploadPlatform] to use.
  ///
  /// Defaults to [MethodChannelEasyUpload].
  static EasyUploadPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EasyUploadPlatform] when
  /// they register themselves.
  static set instance(EasyUploadPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> uploadFile(String filePath, String serverUrl) {
    throw UnimplementedError('uploadFiles() has not been implemented.');
  }
}
