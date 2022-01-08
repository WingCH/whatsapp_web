import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class JavascriptCommunication1Example extends StatefulWidget {
  const JavascriptCommunication1Example({Key? key}) : super(key: key);

  @override
  _JavascriptCommunication1ExampleState createState() =>
      _JavascriptCommunication1ExampleState();
}

class _JavascriptCommunication1ExampleState
    extends State<JavascriptCommunication1Example> {
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('JavaScript Handlers')),
        body: SafeArea(
          child: Column(children: <Widget>[
            Expanded(
              child: InAppWebView(
                initialData: InAppWebViewInitialData(data: """
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    </head>
    <body>
        <h1>JavaScript Handlers</h1>
        <script>
        
            window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
            console.log("[WEB] Trigger flutterInAppWebViewPlatformReady");
            console.log("[WEB] call handlerFoo");
                window.flutter_inappwebview.callHandler('handlerFoo')
                  .then(function(result) {
                   console.log("[WEB] handlerFoo received result: "+ JSON.stringify(result));
                    // print to the console the data coming
                    // from the Flutter side.
                    
                    
                    console.log("[WEB] call handlerFooWithArgs");
                    window.flutter_inappwebview
                      .callHandler('handlerFooWithArgs', 1, true, ['bar', 5], {foo: 'baz'}, result);
                });
            });
        </script>
    </body>
</html>
                      """),
                initialOptions: options,
                onWebViewCreated: (controller) {
                  controller.addJavaScriptHandler(
                      handlerName: 'handlerFoo',
                      callback: (args) {
                        print('[FLUTTER] handlerFoo received result');
                        print('[FLUTTER] handlerFoo return data');
                        // return data to the JavaScript side!
                        return {'bar': 'bar_value', 'baz': 'baz_value'};
                      });

                  controller.addJavaScriptHandler(
                      handlerName: 'handlerFooWithArgs',
                      callback: (args) {
                        print('[FLUTTER] handlerFooWithArgs received result: ' + args.toString());
                        // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
                      });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage.message);
                  // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
