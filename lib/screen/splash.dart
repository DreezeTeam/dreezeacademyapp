import 'package:kindergaten/Size_Config/Config.dart';
import 'package:kindergaten/apptheme/app_theme.dart';
import 'package:kindergaten/screen/homescreen.dart';
import 'package:kindergaten/screen/onboard1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool login = false;
  var _dependence = true;

  @override
  void didChangeDependencies() async {
    if (_dependence) {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        WidgetsFlutterBinding.ensureInitialized();
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      } else if (MediaQuery.of(context).orientation == Orientation.landscape &&
          MediaQuery.of(context).size.width < 800) {
        WidgetsFlutterBinding.ensureInitialized();
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
      final sharedPreferences = await SharedPreferences.getInstance();
      print(sharedPreferences.getBool('login'));
      if (sharedPreferences.getBool('login') != null) {
        setState(() {
          //  login =false;
          print("lllllllllllllllllllll");
          login = sharedPreferences.getBool('login');
        });
      } else {
        login = false;
      }
    }
    _dependence = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appThemeDark.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: Config.yMargin(context, 40),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('images/daLogo.png'),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: const EdgeInsets.only(right: 15, bottom: 15),
                      child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                              login
                                  ? HomeScreen.routeName
                                  : OnboardOne.routeName,
                            );
                          },
                          child: Text("Next")),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
