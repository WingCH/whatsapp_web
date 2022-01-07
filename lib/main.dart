import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'pages/whatsapp_web/binding.dart';
import 'pages/whatsapp_web/view.dart';

Future<void> main() async {
  // https://inappwebview.dev/docs/get-started/installation/
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: iOS Permission
  await Permission.camera.request();
  await Permission.microphone.request();
  await Permission.storage.request();

  if (Platform.isAndroid) {
    // https://inappwebview.dev/docs/debugging-webviews/
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Whatsapp Web',
      getPages: [
        GetPage(
          name: '/',
          page: () => WhatsappWebPage(),
          binding: WhatsappWebBinding(),
        ),
      ],
    );
  }
}
