import 'package:flutter/material.dart';
import 'package:flutter_animation_tween/liningPainter.dart';
import 'package:flutter_animation_tween/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double left=0;
  double right=0;
  double top=0;
  double bottom=0;
  double opacity=1.0;
  void action()
  {
    setState(() {
        if(top==0&&left==0){
          setState(() {
            top+=65;
            left+=255;
          });
      }else if(top!=0){
        setState(() {
          top-=65;
        });
      }else if(left!=0)
      {
        top+=65;
      left-=255;
      }
    });
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPaint(
            painter: LiningPainter(),
            child: Container(
              width: 300,
              height: 100,
              child: Stack(
                children: [
                  Positioned(
                    left: 10,
                    child: AnimatedPositioned(
                      top: top,
                      left: left,
                      duration: Duration(seconds: 2),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Colors.black,
                          )
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ) 
      ,),
      floatingActionButton: FloatingActionButton(onPressed: action),
    );
  }
}
