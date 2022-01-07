import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class WhatsappWebPage extends StatelessWidget {
  final logic = Get.find<WhatsappWebLogic>();
  final state = Get.find<WhatsappWebLogic>().state;

  WhatsappWebPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('WhatsappWebPage'),
      ),
    );
  }
}
