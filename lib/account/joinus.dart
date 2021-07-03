import 'package:kindergaten/Size_Config/Config.dart';
import 'package:kindergaten/apptheme/app_theme.dart';
import 'package:kindergaten/provider/JoinProvider.dart';
import 'package:kindergaten/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:country_calling_code_picker/picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
enum AuthMode { Signup, Login }

class JoinUS extends StatefulWidget {
  static final routeName = '/login';
  @override
  _JoinUSState createState() => _JoinUSState();
}

class _JoinUSState extends State<JoinUS> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController _username= TextEditingController();
  var _hide = true;
  var login = true;
  var signup = false;
  var error = '';
  var loading=false;
  var error2 ="";
  var _continuesetup=true;
  var loading2 = false;
  AuthMode _authMode = AuthMode.Login;
  DateTime selectedDate = DateTime.now();
  String _selectstatus='Student/Professional';
  String _selectgende='Male';
  String _genderChar='m';

  String _statusChar='s';
  final  _key = GlobalKey<FormState>();
  final  _key2 = GlobalKey<FormState>();
  Country _selectedCountry = Country.NG;
  //Country _selectedCountry = Country(asset:"assets/flags/ng_flag.png", dialingCode: "234", isoCode: null,name: "Nigeria");
 // Country _selectedCountry = Country();

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  void loginFunction()async{
    setState((){
      loading =true;
    });
    JoinUsProvider.Login(_username.value.text, password.value.text).then((value) async{



      var username = value.toString().split('|').first;
      var emaile = value.toString().split('|').last;

      if(emaile.toLowerCase().trim() == _username.text.toLowerCase().trim()
          ||_username.text.toLowerCase().trim() == username.toLowerCase().trim()){

        try{
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

          sharedPreferences.setString('username', username);
          sharedPreferences.setString('firstN', username);
          sharedPreferences.setString('LastName', emaile);
          sharedPreferences.setString('email', emaile);
          sharedPreferences.setBool('login', true);

          setState((){
            error  = "Successfully";
            loading =false;
          });
        //  print(sharedPreferences.get('username'));
       Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        }catch(Exception){
          setState((){
            error  = Exception.toString();
            loading =false;
          });
        }



        // sharedPreferences.setString('username', username);
        // sharedPreferences.setString('email', emaile);
        // sharedPreferences.setBool('login', true);

      }else{
        setState(() {
          loading = false;
          error  = value;
        });

      }



    });
  
    // setState((){
    //   error ="${resp.statusCode}";
    // });
    //
  

  }
  void signupnFunction()async{
    setState(() {
      loading2 = true;
      error2 ="";
    });



 //   var par = {'u':'${_username.text}','e':'${email.text}','p':'${password.text}'};
    JoinUsProvider.signupmethod('${_username.text}','$_statusChar','${email.text}','${password.text}').then((value) async{
      print("....................here.....................");
      print(value);
      print("....................here.....................");
      setState(() {
        loading2 = false;
        error2 ="";
      });

      var split = value.toString().split('|').first;
      if(split.toLowerCase().trim() == 'signup_success'.toLowerCase().trim()){
        try{
         
          final sharedPreferences = await SharedPreferences.getInstance();

          sharedPreferences.setBool('login', true);
          sharedPreferences.setString('username', _username.value.text);
          setState(() {
            error2 = "";

            _continuesetup=false;
          });
        }catch(e){
          setState(() {
            error2 = e.toString();

            _continuesetup=false;
          });
        }


      }else{
        setState(() {
          error2 = value.toString();
        });
      }
    });

    // var url ='https://www.dreezetv.com/signup_tv.php';
    // var resp = await http.post(url, body: par);
    //





  }
  void signupcomplete()async{
    setState(() {
      loading2 = true;
      error2 ="";
    });
     JoinUsProvider.CompleteSetup('${_username.text}', '${email.text}',
         '${password.text}',
         '${firstname.text}', '${lastname.text}', '+${_selectedCountry.dialingCode} ${number.text}',
         '${_selectedCountry.name}', '$_genderChar', selectedDate).then((value) async{

       if(value.toLowerCase().trim() =="complete_signup_success".toLowerCase().trim()) {
         final sharedPreferences = await SharedPreferences.getInstance();
         sharedPreferences.setString('firstN', firstname.value.text);
         sharedPreferences.setString('lastN', lastname.value.text);
         sharedPreferences.setString('dob', "${selectedDate.toLocal()}".split(' ')[0]);
         
         _showCompleted().then((value) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
         });


       }
       setState(() {
         loading2 = false;
         error2 ="";
       });


     });

  }

  String _statusConverter(String value){
    switch(value){
      case "Student/Professional":
        return "s";
      case 'Teacher':
        return 't';
      case 'Parent':
        return 'p';
      case 'School/Institution' :
        return 'i';
      case 'Company':
        return 'c';
      case 'Organization' :
        return 'o';
      default :
        return "t";
    }

  }
  String _genderConverter(String value) {
    switch (value) {
      case "Male":
        return "m";
      case 'Female':
        return 'f';
      case 'Other':
        return 'f';
      default :
        return "m";
    }
  }
  Widget country(){
    return
      Padding(
        padding: const EdgeInsets.only(left: 12),
        child: CountryPicker(
          dialingCodeTextStyle: appThemeDark.textTheme.display2,
          dense: false,
          showFlag: true,  //displays flag, true by default
          showDialingCode: true, //displays dialing code, false by default
          showName: false, //displays country name, true by default
          showCurrency: false, //eg. 'British pound'
          showCurrencyISO: false, //eg. 'GBP'
          onChanged: (Country country) {
            setState(() {
              _selectedCountry = country;

            });
          },
          selectedCountry: _selectedCountry,
        ),
      );
  }
    Future _showCompleted(){
    return    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop(true);
          });
          return Dialog(
            child: Container(
              height: Config.yMargin(context, 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: Config.yMargin(context, 10),

                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/success.png')
                      )
                    ),
                  ),
                  Text("Success!", style: appThemeDark.textTheme.title,),
                  Text("You are registered successfully!!", style: appThemeDark.textTheme.title,),


                ],

              ),
            ),
          );
        });

    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appThemeDark.backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          height: Config.yMargin(context,100),
          margin: const EdgeInsets.only(left: 22,right: 22),

          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: Config.yMargin(context, 10),
              ),

              Container(
               // height: Config.yMargin(context, 50),
                height: _authMode == AuthMode.Signup? Config.yMargin(context,60):Config.yMargin(context,50),
                // color: Colors.lightBlue,
                child:_authMode == AuthMode.Login?

                Form(

                  key:_key,
                  child:Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome", style: appThemeDark.textTheme.title, ),
                      SizedBox(height: 15,),
                      Container(
                      //  height: 42.62,
                        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                        child: TextFormField(
                          controller: _username,
                          
                          cursorColor: appThemeDark.buttonColor,
                          style: appThemeDark.textTheme.display2,
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),),
                            prefixIcon: Icon(
                                Icons.email_outlined,
                              color: appThemeDark.iconTheme.color,
                                ),
                            labelText: "Username",

                            labelStyle: appThemeDark.textTheme.display2,
                            isDense: true,                      // Added this
                            contentPadding: EdgeInsets.all(8),
                          ),
                          validator: (value){
                            if(value.isEmpty){
                              return 'Please enter your username/email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 15,),
                      Container(
                        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                        child: TextFormField(
                          cursorColor: appThemeDark.buttonColor,
                          controller: password,
                          obscureText: _hide,
                          style: appThemeDark.textTheme.display2,
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),),
                              prefixIcon: Icon(Icons.lock,
                                color: appThemeDark.iconTheme.color,
                              ),
                              labelText: "Password",

                              labelStyle:  appThemeDark.textTheme.display2,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: appThemeDark.iconTheme.color,

                                ),
                                onPressed: (){
                                  setState(() {
                                    _hide = !_hide;
                                  });
                                },
                              ),
                            isDense: true,                      // Added this
                            contentPadding: EdgeInsets.all(8),

                          ),
                          validator: (value){
                            if(value.isEmpty){
                              return 'Please enter password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 15,),


                      if(error.isNotEmpty)
                        Center(child: Text('$error',  style: appThemeDark.textTheme.display2,textAlign: TextAlign.center,)),


                    ],
                  ) ,
                ):

                    _continuesetup?
                     Form(
                  key: _key,
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Join Us", style: appThemeDark.textTheme.title, ),
                      SizedBox(height: 15,),
                      Container(
                        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                        child: TextFormField(
                          controller:_username,
                          style: appThemeDark.textTheme.display2,
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),),
                            prefixIcon: Icon(Icons.person,
                              color: appThemeDark.iconTheme.color,
                            ),
                            labelText: "Username",

                            labelStyle: appThemeDark.textTheme.display2,
                            isDense: true,                      // Added this
                            contentPadding: EdgeInsets.all(8), // Added this
                          ),
                          validator: (value){
                            if(value.isEmpty){
                              return 'Please enter username';
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: 15,),
                      Container(
                        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                        child: TextFormField(

                          controller: email,

                          style: appThemeDark.textTheme.display2,
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),),
                            prefixIcon: Icon(Icons.email_outlined,
                              color: appThemeDark.iconTheme.color,
                                ),
                            labelText: "Email",

                            labelStyle: appThemeDark.textTheme.display2,
                            isDense: true,                      // Added this
                            contentPadding: EdgeInsets.all(8),

                          ),
                          validator: (value){
                            if(value.isEmpty){
                              return 'Please enter email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 15,),

                      Container(
                        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                        child: TextFormField(

                          controller: password,
                          obscureText: _hide,
                          style: appThemeDark.textTheme.display2,
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),),
                              labelText: "Password",

                              labelStyle: appThemeDark.textTheme.display2,
                              prefixIcon: Icon(Icons.lock_outline,
                               color: appThemeDark.iconTheme.color,),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    Icons.remove_red_eye,
                                  color: appThemeDark.iconTheme.color,

                                ),
                                onPressed: (){
                                  setState(() {
                                    _hide = !_hide;
                                  });
                                },
                              ),
                            isDense: true,                      // Added this
                            contentPadding: EdgeInsets.all(8),

                          ),
                          validator: (value){
                            if(value.isEmpty){
                              return 'Please enter password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 15,),
                      Container(
                        padding: const EdgeInsets.only(left:8.0,right: 8.0),
                     margin: const EdgeInsets.only(left:8.0,right: 8.0),
                     //  p: const EdgeInsets.only(left: 4),
                       // width: Config.xMargin(context,100),
                        height:  42.62,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black12)
                        ),
                        child: DropdownButton<String>(
                          value:_selectstatus,
                          icon: Icon(Icons.keyboard_arrow_down,
                            color: appThemeDark.iconTheme.color,),
                          iconSize: 20,
                          elevation: 16,
                          isExpanded: true,
                          style: TextStyle(
                            //  color: Colors.deepPurple
                          ),
                          underline: Container(
                              height: 2,
                              color: Colors.transparent
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              _selectstatus = newValue;

                              _statusChar=  _statusConverter(_selectstatus);
                            });
                            setState(() {
                              loading2 = false;
                              error2 ="";
                              _continuesetup=false;
                            });

                          },

                          items: <String>['Student/Professional','Teacher','Parent','School/Institution','Company','Organization']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black
                              ),),
                            );
                          })
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 8,),
                      if(error2.isNotEmpty)  Flexible(child: Text('$error2',  style: appThemeDark.textTheme.display2,)),


                    ],
                  ) ,
                ):
                     Form(
                      key: _key,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Join Us", style: appThemeDark.textTheme.title, ),
                          SizedBox(height: 15,),
                          Container(
                            padding: const EdgeInsets.only(left: 8.0,right: 8.0),

                            child: TextFormField(

                              controller:firstname,
                              style: appThemeDark.textTheme.display2,
                              decoration: InputDecoration(
                                labelText: "First Name",
                                border: new OutlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.black),),
                                labelStyle: appThemeDark.textTheme.display2,
                                prefixIcon: Icon(Icons.person,
                                  color: appThemeDark.iconTheme.color,),
                                isDense: true,                      // Added this
                                contentPadding: EdgeInsets.all(8),

                              ),
                              validator: (value){
                                if(value.isEmpty){
                                  return 'Please enter firstname';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 15,),
                          Container(
                            padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                            child: TextFormField(

                              controller:lastname,
                              style: appThemeDark.textTheme.display2,
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.black),),
                                prefixIcon: Icon(Icons.person,
                                  color: appThemeDark.iconTheme.color,),
                                labelText: "Last Name",

                                labelStyle: appThemeDark.textTheme.display2,
                                isDense: true,                      // Added this
                                contentPadding: EdgeInsets.all(8),

                              ),
                              validator: (value){
                                if(value.isEmpty){
                                  return 'Please enter lastname';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 15,),
                          Container(
                            padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                            child: TextFormField(
                              style: appThemeDark.textTheme.display2,
                              controller: number,
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.black),),
                                 prefixIcon: country(),
                                labelText: "Phone",

                                labelStyle:  appThemeDark.textTheme.display2,
                                isDense: true,                      // Added this
                                contentPadding: EdgeInsets.all(8),

                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], // Only numbers can be entered
                              validator: (value){
                                if(value.isEmpty){
                                  return 'Please enter phone';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 15,),
                          Container(
                            padding: const EdgeInsets.only(left:8.0,right: 8.0),
                           margin: const EdgeInsets.only(left: 8.0,right: 8.0),
                            width: Config.xMargin(context,100),
                            height: 42.62,
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black12)
                            ),
                            child: DropdownButton<String>(
                              value:_selectgende,
                              icon: Icon(Icons.keyboard_arrow_down,
                                color: appThemeDark.iconTheme.color,),
                              iconSize: 20,
                              elevation: 16,
                              isExpanded: true,
                              style: TextStyle(
                                //  color: Colors.deepPurple
                              ),
                              underline: Container(
                                  height: 2,
                                  color: Colors.transparent
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  _selectgende = newValue;

                                  _genderChar=  _genderConverter(_selectstatus);

                                });


                              },

                              items: <String>['Male','Female','Other']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black
                                  ),),
                                );
                              })
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: 15,),
                            Container(
                              padding: const EdgeInsets.only(left:8.0,right: 8.0),
                              margin: const EdgeInsets.only(left: 8.0,right: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${selectedDate.toLocal()}".split(' ')[0],
                                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  // SizedBox(
                                  //   height: 20.0,
                                  // ),
                                  RaisedButton(
                                    onPressed: () => _selectDate(context), // Refer step 3
                                    child: Text(
                                      'Select Birthday',
                                      style:
                                      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                           //       color: Colors.greenAccent,
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 15,),

                          if(error2.isNotEmpty)  Flexible(child: Center(child: Text('$error2',  style: appThemeDark.textTheme.display2,))),


                        ],
                      ) ,
                    ),
              ),



              _authMode == AuthMode.Login?
              Column(
                children: [
                  loading ?CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(appThemeDark.buttonColor),
                  ) :
                  Container(
                    width: Config.xMargin(context, 100),
                    height: Config.yMargin(context, 6.5),
                    decoration: BoxDecoration(
                        color: appThemeDark.buttonColor,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: FlatButton(
                      onPressed: (){
                        if(_key.currentState.validate()){
                          loginFunction();
                        }


                      },
                      child: Text('SIGN IN',style: appThemeDark.textTheme.display3,),
                    ),
                  ),

                  FlatButton(
                   // textColor: Colors.white,
                    onPressed: (){
                      _switchAuthMode();
                    },
                    child: Text('Dont have an account? Sign Up ',style: appThemeDark.textTheme.display4,),
                  ),
                ],
              ):
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      InkWell(
                        onTap: (){

                         // country();
                         // _switchAuthMode();
                        },
                        child: Container(
                          height: Config.yMargin(context, 5.0),
                          child: Center(child: Text('Forget Password ?', style: appThemeDark.textTheme.display4,)),
                        ),
                      ),
                    ],
                  ),
                  loading2?CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(appThemeDark.buttonColor),
                  ) : _continuesetup?
                  Container(
                      width: Config.xMargin(context, 100),
                      height: Config.yMargin(context, 6.0),
                      decoration: BoxDecoration(
                          color: appThemeDark.buttonColor,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: FlatButton(
                        textColor: Colors.white,
                        onPressed: (){
                          if(_key.currentState.validate()){
                            _statusChar=  _statusConverter(_selectstatus);
                          signupnFunction();
                          }

                        },
                        child: Text('Sign Up'),
                      )):
                  Container(
                      width: Config.xMargin(context, 100),
                      height: Config.yMargin(context, 6.0),
                      decoration: BoxDecoration(
                          color: appThemeDark.buttonColor,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: FlatButton(
                        textColor: Colors.white,
                        onPressed: (){
                          if(_key.currentState.validate()){

                          signupcomplete();
                          }

                        },
                        child: Text('Complete Setup'),
                      )),
                  InkWell(
                    onTap: (){
                      _switchAuthMode();
                    },
                    child: Container(
                      height: Config.yMargin(context, 5.0),
                      child: Center(child: Text('Login',style:TextStyle(
                        color: appThemeDark.buttonColor,
                      ))),
                    ),
                  )
                ],
              ),
            ],

          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });

  }


}
