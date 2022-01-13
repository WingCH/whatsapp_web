import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  }

  void onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;
    print('[FLUTTER] onWebViewCreated');
    controller.addJavaScriptHandler(
        handlerName: 'renderedContent',
        callback: (args) {
          print('[FLUTTER] renderedContent');

          setupQrCodeUI();
        });
  }

  void onLoadStop(InAppWebViewController controller, Uri? url) async {
    final String rawJs =
        await rootBundle.loadString('assets/js/mutationObserver.js');
    await controller.evaluateJavascript(source: rawJs);
  }

  void setupQrCodeUI() {
    webViewController?.evaluateJavascript(
      source:
          'document.getElementsByClassName(\'landing-wrapper\')[0].style.minWidth = "0";'
          'document.getElementsByClassName(\'landing-header\')[0].style.display = "none";',
    );
  }
}
