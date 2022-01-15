import 'package:get/get.dart';

enum WhatsappWebPageStatus {
  landing,
  main,
  loading,
}

enum WhatsappWebMainStatus {
  contactList,
  content,
}

class WhatsappWebState {
  final Uri initUri = Uri.parse('https://web.whatsapp.com/');

  Rx<WhatsappWebPageStatus?> pageStatus = Rx<WhatsappWebPageStatus?>(null);
  Rx<WhatsappWebMainStatus?> mainStatus = Rx<WhatsappWebMainStatus?>(null);
}
