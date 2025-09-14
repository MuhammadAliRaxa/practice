import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  bool networkAvailable=true;
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  InAppWebViewSettings settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    supportMultipleWindows: true,
    javaScriptCanOpenWindowsAutomatically: true,
    disableDefaultErrorPage: true,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    cacheEnabled: true,
    
    clearCache: false,
    userAgent: Platform.isAndroid
          ? "Mozilla/5.0 (Linux; Android 13; Pixel 6) AppleWebKit/537.36 "
            "(KHTML, like Gecko) Chrome/115.0.0.0 Mobile Safari/537.36"
          : "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) "
            "AppleWebKit/605.1.15 (KHTML, like Gecko) "
            "Version/16.0 Mobile/15E148 Safari/604.1",
    limitsNavigationsToAppBoundDomains: true
  );
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();
    _requestPermissions();

    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: Colors.blue),
      onRefresh: () async {
        await webViewController?.reload();
      },
    );

    setState(() {});
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.locationWhenInUse,
      if (Platform.isAndroid) Permission.storage,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if(webViewController!=null){
          if(await webViewController!.canGoBack()){
            await webViewController!.goBack();
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri("https://cloud.botycam.com")),
            initialSettings: settings,
            pullToRefreshController: pullToRefreshController,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onPermissionRequest: (controller, permissionRequest) async{
                    return PermissionResponse(
                      resources: permissionRequest.resources,
                      action:PermissionResponseAction.GRANT
                    );
                  },
          ),
        ),
      ),
    );
  }
}
