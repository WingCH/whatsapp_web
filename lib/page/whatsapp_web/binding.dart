import 'package:get/get.dart';

import 'logic.dart';

class WhatsappWebBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WhatsappWebLogic());
  }
}
