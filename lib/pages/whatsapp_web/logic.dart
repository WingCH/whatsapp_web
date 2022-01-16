import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

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
      useOnDownloadStart: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
      allowsBackForwardNavigationGestures: false,
      // useOnNavigationResponse: true,
    ),
  );

  final urlController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    ever<WhatsappWebPageStatus?>(state.pageStatus, (pageStatus) async {
      switch (pageStatus) {
        case WhatsappWebPageStatus.landing:
          // Adjust landing page ui
          webViewController?.evaluateJavascript(
            source:
                'document.getElementsByClassName(\'landing-wrapper\')[0].style.minWidth = "0";'
                'document.getElementsByClassName(\'landing-header\')[0].style.display = "none";',
          );
          break;
        case WhatsappWebPageStatus.main:
          print('WhatsappWebPageStatus.main');
          // Adjust main page ui
          webViewController?.evaluateJavascript(
            source:
                'document.querySelector(\'#app > div.app-wrapper-web > div.two, #app > div.app-wrapper-web > div.three\').style.minWidth = "0";'
                'document.querySelector(\'#app > div.app-wrapper-web > div.two, #app > div.app-wrapper-web > div.three\').style.minHeight = "0";'
                'document.querySelector(\'#app > div.app-wrapper-web > div.two > div:nth-child(2) > div:nth-child(3), #app > div.app-wrapper-web > div.three > div:nth-child(2) > div:nth-child(3)\').style.width = "100%"',
          );

          final String rawJs =
              await rootBundle.loadString('assets/js/contactListListener.js');
          await webViewController?.evaluateJavascript(source: rawJs);
          hideShowChatContent(hide: true);
          break;
        case WhatsappWebPageStatus.loading:
        case null:
          // TODO: Handle this case.
          break;
      }
    });

    ever<WhatsappWebMainStatus?>(state.mainStatus, (mainStatus) {
      switch (mainStatus) {
        case WhatsappWebMainStatus.contactList:
          hideShowContactList(hide: false);
          hideShowChatContent(hide: true);
          break;
        case WhatsappWebMainStatus.content:
          hideShowContactList(hide: true);
          hideShowChatContent(hide: false);
          break;
        case null:
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
          state.pageStatus.value = WhatsappWebPageStatus.values[code];
        });

    controller.addJavaScriptHandler(
        handlerName: 'contactListOnClick',
        callback: (_) {
          state.mainStatus.value = WhatsappWebMainStatus.content;
        });

    controller.addJavaScriptHandler(
      handlerName: 'blobToBase64Handler',
      callback: (data) async {
        if (data.isNotEmpty) {
          final String receivedFileInBase64 = data[0];
          final String receivedMimeType = data[1];
          final String fileName = data[2];
          final String fileType = receivedMimeType.split('/').last;

          print('receivedFileInBase64: $receivedFileInBase64');
          print('receivedMimeType: $receivedMimeType');
          print('fileName: $fileName');
          print('fileType: $fileType');

          _createFileFromBase64(receivedFileInBase64, fileName, fileType);
        }
      },
    );
  }

  _createFileFromBase64(
      String base64content, String fileName, String yourExtension) async {
    var bytes = base64Decode(base64content.replaceAll('\n', ''));
    final output = await getExternalStorageDirectory();
    final String outputPath = output?.path ?? '';
    final file = File('$outputPath/$fileName.$yourExtension');
    await file.writeAsBytes(bytes.buffer.asUint8List());
    print('$outputPath/$fileName.$yourExtension');
    await OpenFile.open('$outputPath/$fileName.$yourExtension');
  }

  void onLoadStop(InAppWebViewController controller, Uri? url) async {
    final String rawJs =
        await rootBundle.loadString('assets/js/mutationObserver.js');
    await controller.evaluateJavascript(source: rawJs);
  }

  void showContactList() {
    state.mainStatus.value = WhatsappWebMainStatus.contactList;
  }

  void hideShowChatContent({required bool hide}) {
    String display = hide ? 'none' : '';
    webViewController?.evaluateJavascript(
      source:
          'document.querySelectorAll(\'#app > div.app-wrapper-web > div.two > div, #app > div.app-wrapper-web > div.three > div\')[3].style.display = "$display";',
    );
  }

  void hideShowContactList({required bool hide}) {
    String display = hide ? 'none' : '';
    webViewController?.evaluateJavascript(
      source:
          'document.querySelectorAll(\'#app > div.app-wrapper-web > div.two > div, #app > div.app-wrapper-web > div.three > div\')[2].style.display = "$display";',
    );
  }

  Future<bool> handleWillPop() async {
    showContactList();
    // webViewController?.evaluateJavascript(
    //   source: 'latestChatroomName = "";',
    // );
    return false;
  }
}
