import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
                initialUrlRequest:
                    URLRequest(url: WebUri("https://flutter.dev")),
                initialSettings: settings,
                
                
                  
              )
    );
  }
}