import 'dart:io';
import 'package:kindergaten/Size_Config/Config.dart';
import 'package:kindergaten/apptheme/app_theme.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  String name='';
  String email ='';
  String dropdownValue = 'Light';
  String birthday ="Jul 16";
  int gradepoint;
  String _imageFile;
  GalleryMode _galleryMode = GalleryMode.image;


  void fetchdetails() async{
    final  sharedPreferences = await SharedPreferences.getInstance();
    setState(() {

      //username = sharedPreferences.getString('username');
      name = "${sharedPreferences.getString('firstN')??"FirstName"} ${sharedPreferences.getString('LastName')??"LastName"}";
      email = sharedPreferences.getString('email')??"Email";
      gradepoint=sharedPreferences.getInt('gradepoint')??00;
      birthday=sharedPreferences.getString('birthday')??"Jul 16";
      if(sharedPreferences.getString("image") != null){
        _imageFile = sharedPreferences.getString("image").trim();
      }

    });

  }

  //  _recent = await dbHelper.queryAllRecently();



  Future<void> imagepicker ()async{
    SharedPreferences.setMockInitialValues({});
    final  sharedPreferences = await SharedPreferences.getInstance();
    final picked = await ImagePickers.pickerPaths(
        galleryMode: _galleryMode,
        showGif: true,
        showCamera: true,
        cropConfig :CropConfig(enableCrop: true,height: 1,width: 1),
        compressSize: 500,
        uiConfig: UIConfig(uiThemeColor: Color(0xffff0000),

        )
    );

    setState(() {
      _imageFile = picked.first.path;
    });
    sharedPreferences.setString("image", _imageFile);


  }
  bool _switch =true;
  @override
  void initState() {
    fetchdetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Container(
          height: Config.yMargin(context, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: Config.yMargin(context, 21),
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                child: Stack(
                  children: [
                    Container(
                      height: Config.yMargin(context,14),
                      decoration: BoxDecoration(
                          color: appThemeDark.primaryColor
                      ),
                    ),
                    Positioned(
                      left: 24,
                      bottom: 0,
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              color: Colors.transparent,
                              child: Stack(
                                // alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 45,
                                    backgroundImage: AssetImage('images/physics.png'),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 5,

                                    child: Container(
                                      // alignment: Alignment.bottomRight,
                                      height: Config.yMargin(context, 3.5),
                                      width: Config.xMargin(context, 7),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(90)
                                      ),
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.edit_rounded,
                                            size: 15,
                                            color: appThemeDark.backgroundColor,
                                          ), onPressed:(){

                                      }),

                                    ),
                                  )
                                ],

                              ),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white
                                ),),
                                SizedBox(height: 8,),
                                Text("Birthday: ${birthday.toString()}",style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),),
                                Text("Grade Point: ${gradepoint.toString()}",style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),),


                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: [
                                //     Icon(
                                //       Icons.location_on_rounded,
                                //       size: 15,
                                //         color: Colors.black54
                                //     ),
                                //     Text("Ikeja,Lagos",style: TextStyle(
                                //         fontFamily: 'Raleway',
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.w400,
                                //         fontStyle: FontStyle.normal,
                                //         color: Colors.black54
                                //     ),)
                                //   ],
                                // )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: Config.yMargin(context, 3),),

              TabBar(
                indicatorColor: Color.fromRGBO(67, 59, 238, 0.56),
                indicatorWeight: 4.0,
                isScrollable: true,
                indicatorPadding: const EdgeInsets.only(left: 10),
                tabs: [
                  Container(
                      width: Config.xMargin(context, 45),

                      height: 40,
                      child: Center(child: Text("Result  ",style: appThemeDark.textTheme.title,))),
                  Container(
                      width: Config.xMargin(context, 45),
                      child: Center(child: Text("General Settings",style: appThemeDark.textTheme.title,)))
                ],),


              Expanded(
                child: TabBarView(

                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //    height: Config.yMargin(context, 90),
                      children: [
                        SizedBox(height: Config.yMargin(context, 5),),
                        Container(
                          padding: const EdgeInsets.only(left: 17,right: 17),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Profile Settings", style: appThemeDark.textTheme.subtitle,),
                              Divider(
                                color: Colors.black54,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Theme", style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      color:Colors.black54
                                  )),
                                  Container(
                                    padding: const EdgeInsets.all(3.0),
                                    height: Config.yMargin(context, 4),

                                    child: DropdownButton<String>(
                                      value: dropdownValue,
                                      icon: Icon(Icons.keyboard_arrow_down,
                                        color: Colors.blue,),
                                      iconSize: 20,
                                      elevation: 16,
                                      style: TextStyle(
                                        //  color: Colors.deepPurple
                                      ),
                                      underline: Container(
                                          height: 2,
                                          color: Colors.transparent
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          dropdownValue = newValue;
                                        });
                                      },
                                      items: <String>['Light', 'Dark']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value, style: TextStyle(
                                              fontFamily: 'Raleway',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color:Colors.black54
                                          )),
                                        );
                                      })
                                          .toList(),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Text("Push Notifications", style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      color:Colors.black54
                                  )),
                                  Switch(value:_switch,
                                      activeTrackColor: Colors.blue,


                                      //   activeTrackColor: Colors.white,
                                      activeColor: Colors.blue,

                                      onChanged: (onChanged){
                                        setState(() {
                                          _switch =onChanged;
                                        });
                                      })

                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: Config.yMargin(context, 5),),


                        Container(
                          padding: const EdgeInsets.only(left: 17,right: 17),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Account", style: appThemeDark.textTheme.subtitle,),
                              Divider(
                                color: Colors.black54,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Two factor authentication", style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      color:Colors.black54
                                  )),
                                  IconButton(icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.blue,
                                    size: 15,

                                  ), onPressed: (){})
                                ],
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: Config.yMargin(context, 5),),
                        Container(
                          padding: const EdgeInsets.only(left: 17,right: 17),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Support", style: appThemeDark.textTheme.subtitle,),
                              Divider(
                                color: Colors.black54,
                              ),
                              SizedBox(height: 15,),
                              InkWell(
                                child: Text("Contact us", style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color:Colors.black54
                                )),
                                onTap: (){},
                              ),
                              SizedBox(height: 15,),
                              InkWell(
                                child: Text("FAQs", style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color:Colors.black54
                                )),
                                onTap: (){},
                              )
                            ],
                          ),
                        )

                      ],


                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(height: Config.yMargin(context, 5),),
                        Container(
                          padding: const EdgeInsets.only(left: 17,right: 17),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Profile Settings", style: appThemeDark.textTheme.subtitle,),
                              Divider(
                                color: Colors.black54,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Theme", style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      color:Colors.black54
                                  )),
                                  Container(
                                    padding: const EdgeInsets.all(3.0),
                                    height: Config.yMargin(context, 4),

                                    child: DropdownButton<String>(
                                      value: dropdownValue,
                                      icon: Icon(Icons.keyboard_arrow_down,
                                        color: Colors.blue,),
                                      iconSize: 20,
                                      elevation: 16,
                                      style: TextStyle(
                                        //  color: Colors.deepPurple
                                      ),
                                      underline: Container(
                                          height: 2,
                                          color: Colors.transparent
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          dropdownValue = newValue;
                                        });
                                      },
                                      items: <String>['Light', 'Dark']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value, style: TextStyle(
                                              fontFamily: 'Raleway',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color:Colors.black54
                                          )),
                                        );
                                      })
                                          .toList(),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Text("Push Notifications", style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      color:Colors.black54
                                  )),
                                  Switch(value:_switch,
                                      activeTrackColor: Colors.blue,


                                      //   activeTrackColor: Colors.white,
                                      activeColor: Colors.blue,

                                      onChanged: (onChanged){
                                        setState(() {
                                          _switch =onChanged;
                                        });
                                      })

                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: Config.yMargin(context, 5),),


                        Container(
                          padding: const EdgeInsets.only(left: 17,right: 17),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Account", style: appThemeDark.textTheme.subtitle,),
                              Divider(
                                color: Colors.black54,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Two factor authentication", style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      color:Colors.black54
                                  )),
                                  IconButton(icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.blue,
                                    size: 15,

                                  ), onPressed: (){})
                                ],
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: Config.yMargin(context, 5),),
                        Container(
                          padding: const EdgeInsets.only(left: 17,right: 17),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Support", style: appThemeDark.textTheme.subtitle,),
                              Divider(
                                color: Colors.black54,
                              ),
                              SizedBox(height: 15,),
                              InkWell(
                                child: Text("Contact us", style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color:Colors.black54
                                )),
                                onTap: (){},
                              ),
                              SizedBox(height: 15,),
                              InkWell(
                                child: Text("FAQs", style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color:Colors.black54
                                )),
                                onTap: (){},
                              )
                            ],
                          ),
                        )

                      ],


                    ),
                  ], ),
              ),

            ],

          )),
    );
  }
}
