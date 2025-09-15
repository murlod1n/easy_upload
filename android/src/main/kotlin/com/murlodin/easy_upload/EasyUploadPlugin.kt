package com.murlodin.easy_upload

import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

private const val METHOD_CHANNEL_NAME = "easy_upload"
private const val METHOD_UPLOAD_FILES = "uploadFiles"

// NOTIFICATION
internal const val NOTIFICATION_CHANNEL_ID_KEY = "notification_channel_id"

// PARAMS KEY
internal const val FILE_PATH_KEY = "file_path"
internal const val UPLOAD_URL_KEY = "upload_url"


/** EasyUploadPlugin */
class EasyUploadPlugin: FlutterPlugin, MethodCallHandler {

  private lateinit var channel : MethodChannel
  private lateinit var context: Context


  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL_NAME)
    channel.setMethodCallHandler(this)

  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if(call.method == METHOD_UPLOAD_FILES) {

      val intent = Intent(context, FileUploadService::class.java)

      intent.putExtra(FILE_PATH_KEY, call.argument<String>(FILE_PATH_KEY))
      intent.putExtra(UPLOAD_URL_KEY, call.argument<String>(UPLOAD_URL_KEY))

      context.startService(intent)

      result.success(null)

    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }


}
