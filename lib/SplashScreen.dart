import 'dart:async';
import 'package:flutter/material.dart';
import 'package:picturetranscriptor/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () => Navigator.push(context, PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => HomePage(),
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation1),
          child: child,
        );
      },
    )));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "Picture",
                style: TextStyle(
                    color: Color(0xE8AA79F3),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'PirataOne-Regular',
                    fontSize: MediaQuery.of(context).size.width/5
                )
            ),
            Text("Transcriptor",style: TextStyle(
                color: Color(0xE8AA79F3),
                fontWeight: FontWeight.normal,
                fontFamily: 'PirataOne-Regular',
                fontSize: MediaQuery.of(context).size.width/5
            )
            )
          ],
        ),
      ),
    );
  }
}
