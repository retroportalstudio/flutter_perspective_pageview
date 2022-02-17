import 'package:flutter/material.dart';
import 'package:perspective_pageview/perspective_pageview.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter PageView',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: PerspectivePageView(
            hasShadow: true, // Enable-Disable Shadow
            shadowColor: Colors.black12, // Change Color
            aspectRatio: PVAspectRatio.square, // Add Aspect Ratio
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  debugPrint("Statement One");
                },
                child: Container(
                  color: Colors.red,
                ),
              ),
              GestureDetector(
                onTap: () {
                  debugPrint("Statement Two");
                },
                child: Container(
                  color: Colors.green,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
