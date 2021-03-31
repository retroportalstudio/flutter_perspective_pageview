import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perspective_pageview/perspective_pageview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter PageView',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: PerspectivePageView(
              hasShadow: true, // Enable-Disable Shadow
              shadowColor: Colors.black12, // Change Color
              aspectRatio: PVAspectRatio.SIXTEEN_NINE, // Add Aspect Ratio
              children: <Widget>[
                GestureDetector(
                  onTap: () => debugPrint("Statement One"),
                  child: Container(color: Colors.red),
                ),
                GestureDetector(
                  onTap: () => debugPrint("Statement Two"),
                  child: Container(color: Colors.green),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
