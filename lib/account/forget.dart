import 'package:kindergaten/Size_Config/Config.dart';
import 'package:kindergaten/apptheme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class ForgetPassword extends StatefulWidget {
  static final routeName = '/signup';
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailf = TextEditingController();
  var loading =false;
  void handlereset()async{
    setState(() {
      loading=true;
    });
    print('lrwse');
    var par = {'e':'${emailf.text}'};
    var url =Uri.parse('https://kindergaten.com/forget_pass.php');
    var resp = await http.post(url, body: par);
    if(resp.statusCode ==200){
      setState(() {
        loading=false;
      });
    }
 print(resp.body);

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: Config.yMargin(context,100),
        width: Config.xMargin(context,100),
        child: Center(
          child: Container(
            height: Config.yMargin(context,33),
            width: Config.xMargin(context,100),
            padding: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color:  Color.fromRGBO(33, 32, 41, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: Config.yMargin(context, 8),
                  width: Config.xMargin(context,8),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      //borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage('images/dreezecircle.png')
                      )
                  ),
                  //      child: Image.asset('images/banner.png', fit: BoxFit.cover,)
                ),
                TextFormField(
                  controller: emailf,

                  style: appThemeDark.textTheme.display2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(54, 52, 68, 1),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      //
                      //borderSide: BorderSide(color: Colors.white),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color:appThemeDark.buttonColor),
                    ),


                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    prefixIcon: Icon(Icons.email_outlined,
                      color: appThemeDark.buttonColor,),
                    labelText: "Email",

                    labelStyle: appThemeDark.textTheme.display2,

                  ),
                  validator: (value){
                    if(value.isEmpty){
                      return 'Please enter emaile';
                    }
                    return null;
                  },
                ),
            loading?CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            )
                :Container(
                  width: Config.xMargin(context, 100),
                  height: Config.yMargin(context, 6.5),
                  decoration: BoxDecoration(
                      color: appThemeDark.buttonColor,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: FlatButton(
                    onPressed: (){


                   handlereset();
                    },
                    child: Text('Reset',style: appThemeDark.textTheme.display2,),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
