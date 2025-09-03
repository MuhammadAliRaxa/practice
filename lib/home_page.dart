import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {

  final mediaStore=MediaStore();

  final GlobalKey webViewKey = GlobalKey();

  bool networkAvailable=true;

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(isInspectable: kDebugMode,mediaPlaybackRequiresUserGesture: false,allowsInlineMediaPlayback: true,allowsAirPlayForMediaPlayback: true,geolocationEnabled: true,
    allowContentAccess: true,
    supportMultipleWindows: true,  
    javaScriptCanOpenWindowsAutomatically: true,  
    limitsNavigationsToAppBoundDomains: true,
        javaScriptEnabled: true,
        userAgent:  
        "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) "
          "AppleWebKit/605.1.15 (KHTML, like Gecko) "
          "Version/16.0 Mobile/15E148 Safari/604.1",
        cacheMode: CacheMode.LOAD_DEFAULT,
        mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,);
  PullToRefreshController? pullToRefreshController;
  PullToRefreshSettings pullToRefreshSettings = PullToRefreshSettings(
    color: Colors.blue,
  );
  bool pullToRefreshEnabled = true;


  @override
  void initState() {
    super.initState();
    requestPermissions();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: pullToRefreshSettings,
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }




  Future<void> requestPermissions() async {
    await [
    Permission.camera,
    Permission.microphone,
    Permission.locationWhenInUse,
  ].request();
}

Future<void> downloadAndSaveToGallery(String url, String filename, {bool isVideo = false}) async {
  // Ask for storage permission
  if (await Permission.storage.request().isGranted) {
    Directory? downloadsDir;

    if (Platform.isAndroid) {
      downloadsDir = Directory("/storage/emulated/0/Download");
    } else if (Platform.isIOS) {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    String savePath = "${downloadsDir!.path}/$filename";

    // Download file
    await Dio().download(url, savePath);

    print("✅ File downloaded to: $savePath");

    // Save to gallery (important for Photos app visibility)
  }
}

// Future<bool> isPWAInstalled() async {  
//   final prefs = await SharedPreferences.getInstance();  
//   return prefs.getBool('isInstalled') ?? false;  
// }  
  
// void setPWAInstalled({bool installed = true}) async {  
//   final prefs = await SharedPreferences.getInstance();  
//   await prefs.setBool('isInstalled', installed);  
// }

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
            child: Column(children: <Widget>[
              Expanded(
                child: InAppWebView(
                key: webViewKey,
                initialUrlRequest:
                    URLRequest(url: WebUri("https://cloud.botycam.com")),
                initialSettings: settings,
                onPermissionRequest: (controller, permissionRequest) async{
                  return PermissionResponse(
                    resources: permissionRequest.resources,
                    action:PermissionResponseAction.GRANT
                  );
                },
                onGeolocationPermissionsShowPrompt: (controller, origin) async {
                return GeolocationPermissionShowPromptResponse(
                origin: origin,
                allow: true,
                retain: true,
                  );
                },
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (InAppWebViewController controller) {
                  webViewController = controller;
                },
                onLoadStop: (controller, url) {
                  pullToRefreshController?.endRefreshing();
                },
                onReceivedError: (controller, request, error) {
                  pullToRefreshController?.endRefreshing();
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController?.endRefreshing();
                  }
                },

                onDownloadStartRequest: (controller, request) async {
          // Ask permission
          if (await Permission.storage.isGranted) {
            String url = request.url.toString();
            
            await downloadAndSaveToGallery(url, "${Random().nextInt(68127687)}_image.mp4");

          
          }else{
            String url = request.url.toString();
            await Permission.storage.request();
            
            await downloadAndSaveToGallery(url, "${Random().nextInt(68127687)}_image.mp4");
          }
          },    
              )),
            ]),
          )),
    );
  }
}
