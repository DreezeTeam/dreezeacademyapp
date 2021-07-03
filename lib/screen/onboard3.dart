import 'package:kindergaten/Size_Config/Config.dart';
import 'package:kindergaten/account/joinus.dart';
import 'package:kindergaten/apptheme/app_theme.dart';
import 'package:flutter/material.dart';


class OnboardThree extends StatefulWidget {
  static final routeName = '/onboard3';
  @override
  _OnboardThreeState createState() => _OnboardThreeState();
}

class _OnboardThreeState extends State<OnboardThree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:appThemeDark.backgroundColor ,
      body: SafeArea(


        child: Container(
          height: Config.yMargin(context, 100),
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          color:appThemeDark.backgroundColor ,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
//background: #433BEE;
            children: [

                SizedBox(),
              Container(
                height: Config.yMargin(context, 20),
                width: Config.xMargin(context, 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Past Questions by Topics", style: appThemeDark.textTheme.display2),
                    SizedBox(height: 5,),
                    Text("Get past questions based on topics", style: appThemeDark.textTheme.display3),
                    Text("you want to study and practice them.", style: appThemeDark.textTheme.display3),
                    Text(" You can also check you ranks with", style: appThemeDark.textTheme.display3),
                    Text("other students", style: appThemeDark.textTheme.display3),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(20)

                          ),
                        ),
                        SizedBox(width: 4,),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(20)

                          ),
                        ),
                        SizedBox(width: 4,),
                        Container(
                          height: 10,
                          width: 14,
                          decoration: BoxDecoration(
                              color: appThemeDark.primaryColor,
                              borderRadius: BorderRadius.circular(20)

                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),



              Container(
                width: Config.xMargin(context, 100),
                  decoration: BoxDecoration(
                    color: appThemeDark.buttonColor,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: FlatButton(
                      textColor: Colors.white,

                      onPressed:(){
                        Navigator.of(context).pushReplacementNamed(JoinUS.routeName);
                      }, child: Text("START LEARNING")))
              // Container(
              //   height: Config.yMargin(context, 100),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
