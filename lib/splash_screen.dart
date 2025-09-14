import 'package:flutter/material.dart';
import 'package:flutter_animation_tween/custom_parent_widget.dart';
import 'package:flutter_animation_tween/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    delay();
  }
  void delay()async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomParentWidget(child: WebPage()),));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/bodycam.png"),
      ),
    );
  }
}