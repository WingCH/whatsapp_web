import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'logic.dart';

class WhatsappWebPage extends StatelessWidget {
  final logic = Get.find<WhatsappWebLogic>();
  final state = Get.find<WhatsappWebLogic>().state;

  WhatsappWebPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Official InAppWebView website')),
      body: SafeArea(
        child: Column(children: <Widget>[
          Expanded(
            child: Obx(() {
              return Stack(
                children: [
                  InAppWebView(
                    key: logic.webViewKey,
                    initialUrlRequest: URLRequest(
                      url: Uri.parse('https://web.whatsapp.com/'),
                    ),
                    initialOptions: logic.options,
                    onWebViewCreated: (controller) {
                      logic.webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      logic.urlController.text = url.toString();
                    },
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;
                      return NavigationActionPolicy.CANCEL;
                      // if (![
                      //   'http',
                      //   'https',
                      //   'file',
                      //   'chrome',
                      //   'data',
                      //   'javascript',
                      //   'about'
                      // ].contains(uri.scheme)) {
                      //   print(uri.toString());
                      //   // if (await canLaunch(uri)) {
                      //   //   // Launch the App
                      //   //   await launch(
                      //   //     url,
                      //   //   );
                      //   //   // and cancel the request
                      //   //   return NavigationActionPolicy.CANCEL;
                      //   // }
                      // }
                      //
                      // return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) async {
                      await controller.evaluateJavascript(source: '''
MutationObserver = window.MutationObserver || window.WebKitMutationObserver;

var observer = new MutationObserver(function(mutations, observer) {
    // fired when a mutation occurs
    console.log(mutations, observer);
    // ...
});

observer.observe(document, {
  subtree: true,
  attributes: true
  //...
});
            ''');
                    },
                    onLoadError: (controller, url, code, message) {
                      print('[onLoadError] url: $url');
                      print('[onLoadError] code: $code');
                      print('[onLoadError] message: $message');
                    },
                    onProgressChanged: (controller, progress) async {
                      print('[onProgressChanged] progress: $progress');
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      print('[onUpdateVisitedHistory] url: $url');
                      print('[onUpdateVisitedHistory] url: $url');
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                    },
                  ),
                  logic.progress < 1.0
                      ? LinearProgressIndicator(value: logic.progress.value)
                      : Container(),
                ],
              );
            }),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: const Icon(Icons.arrow_back),
                onPressed: () {
                  logic.webViewController?.goBack();
                },
              ),
              ElevatedButton(
                child: const Icon(Icons.arrow_forward),
                onPressed: () {
                  logic.webViewController?.goForward();
                },
              ),
              ElevatedButton(
                child: const Icon(Icons.refresh),
                onPressed: () {
                  logic.webViewController?.reload();
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
