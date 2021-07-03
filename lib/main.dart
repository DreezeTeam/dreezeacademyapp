import 'dart:io';
import 'package:kindergaten/Model/playModel.dart';
import 'package:kindergaten/account/forget.dart';
import 'package:kindergaten/account/joinus.dart';
import 'package:kindergaten/provider/homenotifier.dart';
import 'package:kindergaten/screen/homescreen.dart';
import 'package:kindergaten/screen/mycourses.dart';
import 'package:kindergaten/screen/playScreen.dart';
import 'package:kindergaten/screen/splash.dart';

import 'package:kindergaten/provider/notifier.dart';
import './screen/onboard1.dart';
import './screen/onboard2.dart';
import './screen/onboard3.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:m3u/m3u.dart';
import 'package:provider/provider.dart';

import 'apptheme/app_theme.dart';
void main() {
  runApp(
      MyApp()
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black54
  ));
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
  }


  @override

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create :(ctx) =>  SideNotifier()
        ),
        ChangeNotifierProvider(
            create :(ctx) =>  HomeNotifier()
        ),
        ChangeNotifierProvider(
            create :(ctx) =>  VideosModelProvider()
        ),
      ],
      child: MaterialApp(
        theme: appThemeDark,
        debugShowCheckedModeBanner: false,
        title: 'kindergaten',

        initialRoute: '/',
        routes: {
          '/':(ctx) => SplashScreen(),
          HomeScreen.routeName:(ctx)=>HomeScreen(),
          ForgetPassword.routeName:(ctx)=>ForgetPassword(),
          MyCourses.routeName: (ctx) => MyCourses(),
          OnboardOne.routeName: (ctx) => OnboardOne(),
          OnboardTwo.routeName: (ctx) => OnboardTwo(),
          OnboardThree.routeName: (ctx) => OnboardThree(),
          JoinUS.routeName:(ctx)=>JoinUS(),
          PlayScreen.routeName:(ctx)=>PlayScreen()
          //    SignUp.routeName:(ctx)=>SignUp(),
          // //   PlayerScreen.routeName:(ctx)=>PlayerScreen(),
          //    SubscriptionScreen.routeName:(ctx)=>SubscriptionScreen()

        },
      ),
    );
  }
}
