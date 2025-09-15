import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:easy_upload/easy_upload.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _easyUploadPlugin = EasyUpload();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              FilledButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final file = await picker.pickImage(source: ImageSource.gallery);
                  _easyUploadPlugin.uploadFile(file!.path, 'https://api.tiamomed.by/api/v1/files');
                },
                child: Text('Upload files')
              )
            ]
          ),
        ),
      ),
    );
  }
}
