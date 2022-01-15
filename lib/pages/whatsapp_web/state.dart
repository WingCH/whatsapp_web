import 'package:get/get.dart';

enum WhatsappWebStatus {
  landing,
  chat,
  loading,
}

class WhatsappWebState {
  final Uri initUri = Uri.parse('https://web.whatsapp.com/');

  Rx<WhatsappWebStatus?> status = Rx<WhatsappWebStatus?>(null);
  Rx<String?> chatroomName = Rx<String?>(null);
}
