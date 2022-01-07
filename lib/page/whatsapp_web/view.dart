import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'logic.dart';

class WhatsappWebPage extends StatelessWidget {
  final logic = Get.find<WhatsappWebLogic>();
  final state = Get
      .find<WhatsappWebLogic>()
      .state;

  WhatsappWebPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
          appBar: AppBar(title: const Text('Official InAppWebView website')),
          body: SafeArea(
              child: Column(children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search)),
                  controller: logic.urlController,
                  keyboardType: TextInputType.url,
                  onSubmitted: (value) {
                    var url = Uri.parse(value);
                    if (url.scheme.isEmpty) {
                      url =
                          Uri.parse('https://www.google.com/search?q=' + value);
                    }
                    logic.webViewController
                        ?.loadUrl(urlRequest: URLRequest(url: url));
                  },
                ),
                Expanded(
                  child: Obx(() {
                    return Stack(
                      children: [
                        InAppWebView(
                          key: logic.webViewKey,
                          initialUrlRequest:
                          URLRequest(url: Uri.parse(
                              'https://inappwebview.dev/')),
                          initialOptions: logic.options,
                          pullToRefreshController: logic
                              .pullToRefreshController,
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

                            if (![
                              'http',
                              'https',
                              'file',
                              'chrome',
                              'data',
                              'javascript',
                              'about'
                            ].contains(uri.scheme)) {
                              print(uri.toString());
                              // if (await canLaunch(uri)) {
                              //   // Launch the App
                              //   await launch(
                              //     url,
                              //   );
                              //   // and cancel the request
                              //   return NavigationActionPolicy.CANCEL;
                              // }
                            }

                            return NavigationActionPolicy.ALLOW;
                          },
                          onLoadStop: (controller, url) async {
                            logic.pullToRefreshController.endRefreshing();
                            logic.urlController.text = url.toString();
                          },
                          onLoadError: (controller, url, code, message) {
                            logic.pullToRefreshController.endRefreshing();
                          },
                          onProgressChanged: (controller, progress) {
                            if (progress == 100) {
                              logic.pullToRefreshController.endRefreshing();
                            }
                            logic.progress.value = progress / 100;
                            // logic.urlController.text = this.url;
                          },
                          onUpdateVisitedHistory: (controller, url,
                              androidIsReload) {
                            // setState(() {
                            //   this.url = url.toString();
                            //   urlController.text = this.url;
                            // });
                            logic.urlController.text = url.toString();
                          },
                          onConsoleMessage: (controller, consoleMessage) {
                            print(consoleMessage);
                          },
                        ),
                        logic.progress < 1.0
                            ? LinearProgressIndicator(value: logic.progress
                            .value)
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
              ]))),
    );
  }
}
