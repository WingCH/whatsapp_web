import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'state.dart';

class WhatsappWebLogic extends GetxController {
  final WhatsappWebState state = WhatsappWebState();

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      userAgent:
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15',
      supportZoom: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,

    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  final urlController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    ever<WhatsappWebStatus?>(state.status, (status) {
      switch (status) {
        case WhatsappWebStatus.landing:
          // Adjust landing page ui
          webViewController?.evaluateJavascript(
            source:
                'document.getElementsByClassName(\'landing-wrapper\')[0].style.minWidth = "0";'
                'document.getElementsByClassName(\'landing-header\')[0].style.display = "none";',
          );
          break;
        case WhatsappWebStatus.chat:
          // Adjust chat page ui
          webViewController?.evaluateJavascript(
              source:
                  ' document.querySelector(\'#app > div.app-wrapper-web > div.two\').style.minWidth = "0";');
          hideShowChatContent(hide: true);
          break;
        case WhatsappWebStatus.loading:
        case null:
          // TODO: Handle this case.
          break;
      }
    });
  }

  void onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;
    print('[FLUTTER] onWebViewCreated');
    controller.addJavaScriptHandler(
        handlerName: 'pageStatusHandler',
        callback: (args) {
          int code = args.first;
          state.status.value = WhatsappWebStatus.values[code];
        });

    controller.addJavaScriptHandler(
        handlerName: 'chatroomChange',
        callback: (args) {
          String chatroomName = args.first;
          print(chatroomName);
        });
  }

  void onLoadStop(InAppWebViewController controller, Uri? url) async {
    final String rawJs =
        await rootBundle.loadString('assets/js/mutationObserver.js');
    await controller.evaluateJavascript(source: rawJs);
  }

  void changeView() {
    // show chat list
  }

  void hideShowChatContent({required bool hide}) {
    String display = hide ? 'none' : '';
    webViewController?.evaluateJavascript(
      source:
          'document.querySelectorAll(\'#app > div.app-wrapper-web > div.two > div\')[3].style.display = "$display";',
    );
  }

  void hideShowContactList({required bool hide}) {
    String display = hide ? 'none' : '';
    webViewController?.evaluateJavascript(
      source:
          'document.querySelectorAll(\'#app > div.app-wrapper-web > div.two > div\')[2].style.display = "$display";',
    );
  }
}
