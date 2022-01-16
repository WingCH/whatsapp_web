import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'logic.dart';

class WhatsappWebPage extends StatelessWidget {
  final logic = Get.find<WhatsappWebLogic>();
  final state = Get.find<WhatsappWebLogic>().state;

  WhatsappWebPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        logic.showContactList();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    key: logic.webViewKey,
                    initialUrlRequest: URLRequest(
                      url: state.initUri,
                    ),
                    initialOptions: logic.options,
                    onWebViewCreated: logic.onWebViewCreated,
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT,
                      );
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;

                      // BUG: https://github.com/pichillilorenzo/flutter_inappwebview/issues/863
                      // FIX: iOS 用useShouldOverrideUrlLoading會about:blank白畫面
                      if (uri == state.initUri) {
                        return NavigationActionPolicy.ALLOW;
                      }
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
                    onLoadStop: logic.onLoadStop,
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
                      print('[WEB] $consoleMessage');
                    },
                    onDownloadStart: (_controller, url) async {
                      print('onDownloadStart $url');

                      var jsContent =
                          await rootBundle.loadString('assets/js/base64.js');
                      await _controller.evaluateJavascript(
                        source: jsContent.replaceAll(
                          'blobUrlPlaceholder',
                          url.toString(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // ButtonBar(
            //   alignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     ElevatedButton(
            //       child: const Icon(Icons.arrow_back),
            //       onPressed: () {
            //         logic.webViewController?.goBack();
            //       },
            //     ),
            //     ElevatedButton(
            //       child: const Icon(Icons.arrow_forward),
            //       onPressed: () {
            //         logic.webViewController?.goForward();
            //       },
            //     ),
            //     ElevatedButton(
            //       child: const Icon(Icons.refresh),
            //       onPressed: () {
            //         logic.webViewController?.reload();
            //       },
            //     ),
            //   ],
            // ),
          ]),
        ),
      ),
    );
  }
}
