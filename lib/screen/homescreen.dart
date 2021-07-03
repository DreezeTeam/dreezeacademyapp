import 'package:kindergaten/screen/Subscription.dart';
import 'package:kindergaten/screen/explore.dart';

import '../provider/homenotifier.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../Size_Config/Config.dart';
import '../Model/attributeModel.dart';
import '../Model/model.dart';
import '../Model/subheadmodel.dart';
import '../account/profile.dart';
import '../apptheme/app_theme.dart';
import '../provider/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './welcome.dart';
import './Statistics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
class HomeScreen extends StatefulWidget {
  static final routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget currentItem;
 // Widget currentItem = SubscriptionScreen();
  var isCollapsed = true;
  var name = false;
  int opennum =0;
   String title="Channels";
   var dependence =true;
  @override
  void initState() {
    super.initState();

  }

  bool open = true;
  int bottomIndex=0;
  List<ListModel> contents =[];
  List<dynamic> _body = [Welcome(),Statistics(),Explore(),SubscriptionScreen(),Profile()];
  List<AttributeModel> list =[];
   @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    // WidgetsFlutterBinding.ensureInitialized();
    final x =Provider.of<SideNotifier>(context).x;

    final sideopen = Provider.of<SideNotifier>(context,listen: true).openit;
    print("$x xxxx $sideopen opppennnnnn");

    final width = MediaQuery.of(context).size.width;

    return
               width>900 ?
               Scaffold(
     resizeToAvoidBottomInset: false,
      
      backgroundColor:   appThemeDark.backgroundColor,

      body: Row(
        children: [

            sideopen?    Container(
               width: Config.xMargin(context, 20),
               height:  Config.yMargin(context, 100),
              color: appThemeDark.backgroundColor,
               child: Column(
                 children: [

                   SizedBox(height:  Config.yMargin(context, 1)),

                   ListView.builder(
                     itemCount: 8,
                     shrinkWrap: true,
                     scrollDirection: Axis.vertical,
                     itemBuilder: (ctx, index){
                       if(index == 1){
                         return  Container(
                           height:  Config.yMargin(context, 8),
                           decoration: BoxDecoration(
                             color: x==1 ? Colors.white:Colors.transparent,
                             //border: Border.all(  color: Focus.of(context).hasPrimaryFocus ? Colors.white:Colors.transparent, width: 5),
                           ),
                           child: Row(
                          //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                               SizedBox(width: Config.xMargin(context, 1.5),),
                               Icon(
                                 Icons.home,
                                 size: 25,
                                 color: x ==1 ? Colors.black87:Colors.white,
                               ),
                               SizedBox(width: Config.xMargin(context, 1.5),),
                               Text('Channels',style: TextStyle(
                                   fontSize: 20,
                                 color: x ==1 ? Colors.black87:Colors.white,
                               ),),
                             ],
                           ),
                         );}
                       if(index == 2){
                         return  Container(
                           height:  Config.yMargin(context, 8),
                           decoration: BoxDecoration(
                             color: x==2 ? Colors.white:Colors.transparent,
                           //  border: Border.all(  color: Focus.of(context).hasPrimaryFocus ? Colors.white:Colors.transparent, width: 5),
                           ),
                           child: Row(
                             //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               SizedBox(width: Config.xMargin(context, 1.5),),
                               Icon(
                                 Icons.movie,
                                 size: 25,
                                 color: x ==2 ? Colors.black87:Colors.white,
                               ),
                               SizedBox(width: Config.xMargin(context, 1.5),),
                               Text('Movies',style: TextStyle(
                                   fontSize:  20,
                                 color: x ==2 ? Colors.black87:Colors.white,
                               ),),
                             ],
                           ),
                         );}
                       if(index == 3){
                         return  Container(
                           height:  Config.yMargin(context, 8),
                           decoration: BoxDecoration(
                             color: x ==3 ? Colors.white:Colors.transparent,
                             //  border: Border.all(  color: Focus.of(context).hasPrimaryFocus ? Colors.white:Colors.transparent, width: 5),
                           ),
                           child: Row(
                             //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               SizedBox(width: Config.xMargin(context, 1.5),),
                               Icon(
                                 Icons.search,
                                 size: 25,
                                 color: x ==3 ? Colors.black87:Colors.white,
                               ),
                               SizedBox(width: Config.xMargin(context, 1.5),),
                               Text('Explore',style: TextStyle(
                                   fontSize: 20,
                                 color: x ==3 ? Colors.black87:Colors.white,
                               ),),
                             ],
                           ),
                         );}
                       if(index == 4){
                         return  Container(
                           height:  Config.yMargin(context, 8),
                           decoration: BoxDecoration(
                            color: x ==4 ? Colors.white:Colors.transparent,
                             //  border: Border.all(  color: Focus.of(context).hasPrimaryFocus ? Colors.white:Colors.transparent, width: 5),
                           ),
                           child: Row(
                             //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               SizedBox(width: Config.xMargin(context, 1.5),),
                               Icon(
                                 Icons.subscriptions,
                                 size: 25,
                                 color: x ==4 ? Colors.black87:Colors.white,
                               ),
                               SizedBox(width: Config.xMargin(context, 1.5),),
                               Text('Subscription',style: TextStyle(
                                   fontSize: 20,
                                 color: x == 4? Colors.black87:Colors.white,
                               ),),
                             ],
                           ),
                         );}
                       if(index == 5){
                         return  Container(
                           height:  Config.yMargin(context, 8),
                           decoration: BoxDecoration(
                             color: x ==5 ? Colors.white:Colors.transparent,
                             //  border: Border.all(  color: Focus.of(context).hasPrimaryFocus ? Colors.white:Colors.transparent, width: 5),
                           ),
                           child: Row(
                             //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               SizedBox(width: Config.xMargin(context, 1.5),),
                               Icon(
                                 Icons.account_circle,
                                 size: 25,
                                 color: x ==5 ? Colors.black87:Colors.white,
                               ),
                               SizedBox(width: Config.xMargin(context, 1.5),),
                               Text('Account',style: TextStyle(
                                 fontSize: 20,
                                 color: x ==5 ? Colors.black87:Colors.white,
                               ),),
                             ],
                           ),
                         );}
                       if(index == 6){
                         return  Container(
                           height:  Config.yMargin(context, 8),
                           decoration: BoxDecoration(
                             color: x==6 ? Colors.white:Colors.transparent,
                             //border: Border.all(  color: Focus.of(context).hasPrimaryFocus ? Colors.white:Colors.transparent, width: 5),
                           ),
                           child: Row(
                             //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                               SizedBox(width: Config.xMargin(context, 1.5),),
                               Icon(
                                 Icons.favorite,
                                 size: 25,
                                 color: x ==6 ? Colors.black87:Colors.white,
                               ),
                               SizedBox(width: Config.xMargin(context, 1.5),),
                               Text('Favourites',style: TextStyle(
                                 fontSize: 20,
                                 color: x ==6 ? Colors.black87:Colors.white,
                               ),),
                             ],
                           ),
                         );}
                       if(index == 7){
                         return  Container(
                           height:  Config.yMargin(context, 8),
                           decoration: BoxDecoration(
                             color: x ==7 ? Colors.white:Colors.transparent,
                             //  border: Border.all(  color: Focus.of(context).hasPrimaryFocus ? Colors.white:Colors.transparent, width: 5),
                           ),
                           child: Row(
                             //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               SizedBox(width: Config.xMargin(context, 1.5),),
                               Icon(
                                 Icons.subscriptions,
                                 size: 25,
                                 color: x ==7 ? Colors.black87:Colors.white,
                               ),
                               SizedBox(width: Config.xMargin(context, 1.5),),
                               Text('Downloads',style: TextStyle(
                                 fontSize: 20,
                                 color: x ==7 ? Colors.black87:Colors.white,
                               ),),
                             ],
                           ),
                         );}
                       return Container(
                           height:  Config.yMargin(context, 10),
                           child: Row(
                             children: [
                               SizedBox(width: Config.xMargin(context, 1.0),),
                               Container(
                                 height:  Config.yMargin(context, 4),
                                 width: Config.xMargin(context, 3),
                                 decoration: BoxDecoration(
                                   image: DecorationImage(
                                     fit: BoxFit.contain,
                                     image: AssetImage('images/dreezecircle.png'),
                                   )
                                 ),

                               ),
                               SizedBox(width: Config.xMargin(context, 1.0),),
                               Text('kindergaten',
                               style: TextStyle(
                                 fontSize: 22,
                                  color:Colors.white,
                                 fontWeight: FontWeight.bold
                               ),),
                             ],
                           ),


                         );
                     },
                   ),
                 ],
               ),
             ):
            Container(
              width: Config.xMargin(context, 5),
              height:  Config.yMargin(context, 100),
              color: appThemeDark.backgroundColor,
              child: Column(
                children: [

                  SizedBox(height:  Config.yMargin(context, 1)),

                  ListView.builder(
                    itemCount: 8,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (ctx, index){
                      if(index == 1){
                        return  Container(
                          height:  Config.yMargin(context, 8),
                          decoration: BoxDecoration(
                            color: x==1? Colors.white:Colors.transparent,
                            //border: Border.all(  color: Focus.of(context).hasPrimaryFocus ? Colors.white:Colors.transparent, width: 5),
                          ),
                          child: Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 6,),
                              Icon(
                                  Icons.home,
                                  size: 25,
                                color: x ==1 ? Colors.black87:Colors.white,
                              ),
                              SizedBox(width: 6,),
                            ],
                          ),
                        );}
                      if(index == 2){
                        return  Container(
                          height:  Config.yMargin(context, 8),
                          decoration: BoxDecoration(
                            color: x==2 ? Colors.white:Colors.transparent,
                            //  border: Border.all(  color: Focus.of(context).hasPrimaryFocus ? Colors.white:Colors.transparent, width: 5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 6,),
                              Icon(
                                Icons.movie,
                                size: 25,
                                color: x ==2 ? Colors.black87:Colors.white,
                              ),
                              SizedBox(width: 6,),
                            ],
                          ),
                        );}
                      if(index == 3){
                        return  Container(
                          height:  Config.yMargin(context, 8),
                          decoration: BoxDecoration(
                            color: x==3 ? Colors.white:Colors.transparent,
                            //  border: Border.all(  color: Focus.of(context).hasPrimaryFocus ? Colors.white:Colors.transparent, width: 5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 6,),
                              Icon(
                                Icons.search,
                                size: 25,
                                color: x ==3 ? Colors.black87:Colors.white,
                              ),
                              SizedBox(width: 6,),

                            ],
                          ),
                        );}
                      if(index == 4){
                        return  Container(
                          height:  Config.yMargin(context, 8),
                          decoration: BoxDecoration(
                            color: x==4 ? Colors.white:Colors.transparent,
                            //  border: Border.all(  color: Focus.of(context).hasPrimaryFocus ? Colors.white:Colors.transparent, width: 5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 6,),
                              Icon(
                                Icons.subscriptions,
                                size: 25,
                                color: x ==4? Colors.black87:Colors.white,
                              ),
                              SizedBox(width: 6,),

                            ],
                          ),
                        );}
                      if(index == 5){
                        return  Container(
                          height:  Config.yMargin(context, 8),
                          decoration: BoxDecoration(
                            color: x==5 ? Colors.white:Colors.transparent,
                          //  color: x ==5 ? Colors.white:Colors.transparent,
                            //  border: Border.all(  color: Focus.of(context).hasPrimaryFocus ? Colors.white:Colors.transparent, width: 5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 6,),
                              Icon(
                                Icons.account_circle_outlined,
                                size: 25,
                                color: x ==5 ? Colors.black87:Colors.white,
                              ),
                              SizedBox(width: 6,),
                            ],
                          ),
                        );}
                      if(index == 6){
                        return  Container(
                          height:  Config.yMargin(context, 8),
                          decoration: BoxDecoration(
                            color: x==6 ? Colors.white:Colors.transparent,
                            //border: Border.all(  color: Focus.of(context).hasPrimaryFocus ? Colors.white:Colors.transparent, width: 5),
                          ),
                          child: Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 6,),
                              Icon(
                                Icons.favorite,
                                size: 25,
                                color: x ==6 ? Colors.black87:Colors.white,
                              ),
                              SizedBox(width: 6,),
                            ],
                          ),
                        );}
                      if(index == 7){
                        return  Container(
                          height:  Config.yMargin(context, 8),
                          decoration: BoxDecoration(
                            color: x==7 ? Colors.white:Colors.transparent,
                            //  color: x ==5 ? Colors.white:Colors.transparent,
                            //  border: Border.all(  color: Focus.of(context).hasPrimaryFocus ? Colors.white:Colors.transparent, width: 5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 6,),
                              Icon(
                                  Icons.file_download,
                                  size: 25,
                                color: x ==7 ? Colors.black87:Colors.white,
                              ),
                              SizedBox(width: 6,),
                            ],
                          ),
                        );}

                      return  Container(
                        height:  Config.yMargin(context, 10),
                        child: Row(
                          children: [
                            SizedBox(width: Config.xMargin(context, 1.0),),
                            Container(
                              height:  Config.yMargin(context, 4),
                              width: Config.xMargin(context, 3),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: AssetImage('images/dreezecircle.png'),
                                  )
                              ),

                            ),

                          ],
                        ),


                      );

                    },
                  ),
                ],
              ),
            ),


        ],
      ),

      ):


               Scaffold(
                 resizeToAvoidBottomInset: false,

                 backgroundColor:   appThemeDark.backgroundColor,

                  body: _body[bottomIndex],

                 floatingActionButton: Container(
                   height: 40,
                   child: FloatingActionButton(

                     backgroundColor: appThemeDark.primaryColor,
                     onPressed: (){

                     },
                     child: Stack(
                       children: [
                         Icon(
                             Icons.notifications
                         ),
                         Icon(

                           Icons.circle,
                           color: Colors.red,
                           size: 10,
                         )
                       ],
                     ),
                   ),
                 ),
                 bottomNavigationBar: BottomNavigationBar(
                   showSelectedLabels: true,
                   showUnselectedLabels: true,
                   backgroundColor: appThemeDark.backgroundColor,
                   type: BottomNavigationBarType.fixed ,
                   selectedItemColor: appThemeDark.buttonColor,
                   selectedIconTheme: IconThemeData(
                       color: appThemeDark.buttonColor
                   ),
                   unselectedItemColor: Colors.black54,
                   unselectedIconTheme: IconThemeData(
                       color: Colors.black54
                   ),
                   currentIndex: bottomIndex,
                   items: [

                     BottomNavigationBarItem(
                         title: Text("Home"),

                         icon: Icon(
                           Icons.home,
                           size: 24,
                           //   color: Colors.black54,
                         )
                     ),
                     BottomNavigationBarItem(
                         title: Text("Statistics"),
                         icon: Icon(
                           Icons.data_usage,
                           size: 24,

                         )),

                     BottomNavigationBarItem(
                         title: Text("Explore"),
                         icon: Icon(
                           Icons.search,
                           size: 24,
                         )),
                     BottomNavigationBarItem(
                         title: Text("Subscription"),
                         icon: Icon(
                           Icons.subscriptions,
                           size: 24,
                         )),

                     BottomNavigationBarItem(
                         title: Text("Account"),
                         icon: Icon(
                           Icons.person,
                           size: 24,

                         )),

                   ],
                   onTap: _changebottom,
                 ),
               );

  }
  void _changebottom(int index){
     setState(() {
       bottomIndex = index;
     });

  }

 }
