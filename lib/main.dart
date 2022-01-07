import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'page/whatsapp_web/binding.dart';
import 'page/whatsapp_web/view.dart';

void main() {
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
