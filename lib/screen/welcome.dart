import 'dart:async';
import 'dart:convert';
import 'package:kindergaten/provider/services.dart';
import 'package:kindergaten/screen/playScreen.dart';

import '../Model/playModel.dart';
import 'package:kindergaten/Model/attributeModel.dart';
import 'package:kindergaten/Model/model.dart';
import 'package:kindergaten/Model/subheadmodel.dart';
import 'package:kindergaten/Size_Config/Config.dart';
import 'package:kindergaten/apptheme/app_theme.dart';
import 'package:kindergaten/provider/homenotifier.dart';
import 'package:kindergaten/provider/notifier.dart';
import '../screen/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:video_thumbnail_generator/video_thumbnail_generator.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kindergaten/provider/databaseHelper.dart';

import 'mycourses.dart';
class Welcome extends StatefulWidget {

  Welcome({Key key}) : super(key: key);

  @override
  _TvTabScreenState createState() => _TvTabScreenState();
}

class _TvTabScreenState extends State<Welcome> {
  //  List< Map<String,List<M3uGenericEntry>> > list = [];
  //List<ListModel> list = [];
  bool isCollapsed = true;
var _dispose  = false;

  List<ListModel> contents =[];
  int verticalCounter = 0;
  GlobalKey actionKey;
  int itemcounter = 0;

  final focus = FocusNode();
  int pageFocus = 0;
  ScrollController listcontroller = ScrollController();
  ScrollController controllerPopUp = ScrollController();
 // final controller = ScrollController();
  PageController controller = PageController(viewportFraction: 1);
  bool open = false;
  double topcontainer = 0;
  int c = 0;
  int popFocus =0;
  final dbHelper = DataBaseOpener.instance;
  int opennum =0;
  var showPopup=false;
  String filterValue = "";
  OverlayEntry _overlayEntry;
  double height, width, xPosition, yPosition;
  bool isDropdownOpened = false;
  OverlayEntry floatingDropdown;
  String dropdownValue = 'SS1';
  String username="";
  String name="";
  String selectedClass = "Nursery";

 String x='0';
 String y='0';
 String url="";
  List<VideosModelProvider> _recent = [];
 PersistentBottomSheetController _bottomSheetController;
  void jump(int x){
    final _width = Config.xMargin(context, 23);
    listcontroller.animateTo(_width*x,duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);
  }

  void _handleKey(RawKeyEvent key) {
    if(key.runtimeType.toString() == 'RawKeyUpEvent'){

      RawKeyEventDataAndroid data = key.data as RawKeyEventDataAndroid;
      String _keyCode;
      _keyCode = data.keyCode.toString(); //

    //  print("why does this run twice $_keyCode");
      if(data.keyCode ==22){
        // jump();
if(showPopup){

}else{
        if(pageFocus >= 0){

          final x =  Provider.of<SideNotifier>(context, listen: false).openit;
          if(x){
            Provider.of<SideNotifier>(context, listen: false).changeopen();
          }
          setState(() {
            if(pageFocus < contents[verticalCounter].subhead.length-1){
              pageFocus++;

              if(pageFocus>=4){
                jump(pageFocus);
              }
            }



          });





        }}
      }
      else if(data.keyCode ==21) {

      if(!showPopup){
        if(pageFocus == 0){
          final y =  Provider.of<SideNotifier>(context, listen: false).openit;
          final position = Provider.of<SideNotifier>(context, listen: false).x;
          print('$position po');
          if(!y){
            Provider.of<SideNotifier>(context, listen: false).changeopen();
          }


        }else{
          pageFocus--;
          jump(pageFocus);

        }
      }

      }
      else if(data.keyCode ==19){final _height = Config.yMargin(context, 100);
        //down for pageview
        print('up');

        final y =  Provider.of<SideNotifier>(context, listen: false).openit;
        if(y){
          Provider.of<SideNotifier>(context, listen: false).changeview(1);


        }else{
          setState(() {

            if( verticalCounter >= 1){
              pageFocus =0;

              verticalCounter--;
              controller.jumpToPage(verticalCounter);
              // controller.animateTo(verticalCounter,duration: Duration(seconds: 2),
              // curve: Curves.fastOutSlowIn);
              jump(pageFocus);
            }

          });

        }




      }
      else if (data.keyCode ==20){
        final _height = Config.yMargin(context, 100);
        //up for page view

        final y =  Provider.of<SideNotifier>(context, listen: false).openit;

        if(y){
          print('open $opennum');

          Provider.of<SideNotifier>(context, listen: false).changeview(2);

        }else{
          setState(() {

            print('down');
            if(verticalCounter < contents.length -1){
              pageFocus =0;
              verticalCounter++;
              controller.jumpToPage(verticalCounter);
              // controller.animateTo(_height*verticalCounter, duration: Duration(seconds: 2),
              //     curve: Curves.fastOutSlowIn);
              jump(pageFocus);
            }


          });}
      }
      else if(data.keyCode ==66||data.keyCode ==23){
     //   print('$pageFocus');

          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx){
              // return PlayerScreen(contents[verticalCounter].subhead ,pageFocus,contents );
        //      return ChewieTesting(contents[verticalCounter].subhead ,pageFocus,contents );
              return PlayScreen();
            }
          ));


      }
      else if (data.keyCode ==4){

        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx){
              // return PlayerScreen(contents[verticalCounter].subhead ,pageFocus,contents );
              return SplashScreen();
            }
        ));
      }

      // return true;
    }
  }
  OverlayEntry _createOverlayEntry() {

    RenderBox renderBox = context.findRenderObject();
    return OverlayEntry(
        builder: (context) => Positioned(
          left: (xPosition),
          width: 50,
          top: yPosition + height,
          height: 4 * height + 40,
          child: Container(

            child: Column(
              children: [
                SizedBox(
                  height: 2,
                ),
                Align(
                  alignment: Alignment(-0.0, 0),
                  child: ClipPath(
                    clipper: ArrowClipper(),
                    child: Container(
                      height: 10,
                      width: 15,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Material(
                    borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    elevation: 4.0,
                    child: Container(
                      width: 50,
                      child: Column(

                        //  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        //  padding: EdgeInsets.zero,

                        //    padding: EdgeInsets.only(right: 10),
                        //  shrinkWrap: true,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('SS1',style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black
                          ),),
                          Text('SS1',style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black
                          ),),
                          Text('SS1',style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black
                          ),),
                          // ListTile(
                          //   title: Text('SS1',style: TextStyle(
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w400,
                          //       color: Colors.black
                          //   ),),
                          // ),
                          // ListTile(
                          //   title: Text('SS2'),
                          // ),
                          // ListTile(
                          //   title: Text('SS3'),
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
  void findDropdownData() {
    RenderBox renderBox = actionKey.currentContext.findRenderObject();
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
    print(height);
    print(width);
    print(xPosition);
    print(yPosition);
  }

  void fetchdetails()async{
    final sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      username = sharedPreferences.getString('username');
      name = "${sharedPreferences.getString('firstN')??"FirstName"} ${sharedPreferences.getString('LastName')??"LastName"}";
    });

    //  _recent = await dbHelper.queryAllRecently();



  }

  @override
  void initState() {
    _dispose  = false;
    actionKey = LabeledGlobalKey(selectedClass);
    fetchdetails();
    super.initState();

  }
  String r ="";
  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }
 @override
  void didChangeDependencies() {
   if(_dispose)return;
    try{
      print('im here tv');
      FetchServices.fetchclass().then((value)  {
        if(_dispose)return;
        setState(() {
          contents = value;

        });

      });

    }catch(Exception){
      setState(() {
        r = Exception.toString();

      });
    }


    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return
      width >900?
      RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey:_handleKey ,
      child: contents.isNotEmpty?

      Container(
          margin: const EdgeInsets.only(left: 5, top: 8),
          height: Config.yMargin(context, 100),
          width: double.infinity,
          child: PageView.builder(
          itemCount: contents.length,
          scrollDirection: Axis.vertical,
          controller: controller,

          itemBuilder: (ctx, page1index){

            return Container(
              color: appThemeDark.backgroundColor,
              width: Config.xMargin(context, 50),
              height: Config.yMargin(context, 100),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(contents[page1index].Headname, style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white
                        ),),
                        IconButton(icon: Icon(
                          Icons.double_arrow,
                          color: Colors.white,
                          size: 20,
                        ), onPressed: (){
                          setState(() {
                            showPopup = true;
                          });

                          _showSearchTv(contents[page1index], page1index);
                         // _showSearchDialogTv(contents[page1index], page1index);
                        })
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: Config.yMargin(context, 60),
                        color: appThemeDark.backgroundColor,
                      width: Config.xMargin(context, 100),
                      child:  ListView.builder(
                          shrinkWrap: true,
                          controller: listcontroller,
                          itemCount:contents[page1index].subhead.length,
                          scrollDirection: Axis.horizontal,

                          itemBuilder: (ctx, indexL){


                              return Container(
                              height: Config.yMargin(context, 50),
                              width:  Config.xMargin(context, 23),
                              padding: EdgeInsets.all(8.0),
                                color: appThemeDark.backgroundColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  contents[page1index].subhead[indexL].tvglogo.isNotEmpty
                                      ?  Container(
                                    height: Config.yMargin(context, 25),
                                    //  width: ,
                                      decoration: BoxDecoration(
                                        color: appThemeDark.primaryColorLight,
                                          border: Border.all(
                                           color: pageFocus ==indexL ? Colors.white:Colors.transparent, width: 3
                                          ),
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18),
                                              bottomRight: Radius.circular(18),bottomLeft: Radius.circular(18)
                                          ),

                                          image: DecorationImage(
                                              fit: BoxFit.cover,

                                              image: NetworkImage(contents[page1index].subhead[indexL].tvglogo)
                                          )

                                      ),
                                    // child: Image.network(contents[page1index].subhead[indexL].tvglogo,
                                    // fit: BoxFit.fill,),

                                  ):
                                  Container(
                                      height: Config.yMargin(context, 25),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        border: Border.all(

                                            // color:
                                            // Focus.of(context).hasPrimaryFocus
                                            //     ? Colors.white:Colors.transparent,

                                            width: 3),
                                      )),
                                  SizedBox(height: 10,),
                                  Flexible(
                                    child: Text(contents[page1index].subhead[indexL].title,style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),),
                                  ),

                                ],
                              ),
                            );

                          },
                        )

                    ),

                    SizedBox(height: 10,),
                    if(page1index+1 <contents.length) Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('${contents[page1index+1].Headname }', style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white
                      ),),
                    ),
                    SizedBox(height: 10,),
                    if(page1index+1 < contents.length)  Expanded(
                      child: Align(

                        alignment: Alignment.bottomCenter,
                        child: Container(
                       //   color: Colors.white,
                            height: Config.yMargin(context, 19),
                         //  padding: EdgeInsets.all(8.0),
                            width: Config.xMargin(context, 100),
                          child: SingleChildScrollView(
                            child: Container(
                              height: Config.yMargin(context, 22),
                              width: Config.xMargin(context, 21),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  if(contents[page1index+1].subhead.length>0)     Container(
                                    height: Config.yMargin(context, 22),
                                    width:  Config.xMargin(context, 23),
                                      padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        color: appThemeDark.primaryColorLight,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18)),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(contents[page1index+1].subhead[0].tvglogo)
                                        )

                                    ),
                                    // child: Image.network(contents[page1index].subhead[indexL].tvglogo,
                                    // fit: BoxFit.fill,),

                                  ),
                                  if(contents[page1index+1].subhead.length>1)     Container(
                                    height: Config.yMargin(context, 22),
                                    width: Config.xMargin(context, 22),
                                    margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    decoration: BoxDecoration(
                                        color: appThemeDark.primaryColorLight,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18)),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,

                                            image: NetworkImage(contents[page1index+1].subhead[1].tvglogo,)
                                        )

                                    ),
                                     // child: Image.network(contents[page1index+1].subhead[1].tvglogo,
                                     // fit: BoxFit.contain,
                                     //  width:  Config.xMargin(context, 23),
                                     //  // width: ,
                                     // ),

                                  ),
                                  if(contents[page1index+1].subhead.length>2)   Container(
                                    height: Config.yMargin(context, 22),
                                    width: Config.xMargin(context, 22),
                                    margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    decoration: BoxDecoration(
                                        color: appThemeDark.primaryColorLight,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18)),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(contents[page1index+1].subhead[2].tvglogo)
                                        )

                                    ),
                                    // child: Image.network(contents[page1index].subhead[indexL].tvglogo,
                                    // fit: BoxFit.fill,),

                                  ),
                                  if(contents[page1index+1].subhead.length>3)   Container(
                                    height: Config.yMargin(context, 22),
                                    width: Config.xMargin(context, 22),
                                    margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    decoration: BoxDecoration(
                                        color: appThemeDark.primaryColorLight,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18)),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(contents[page1index+1].subhead[3].tvglogo)
                                        )

                                    ),


                                  ),
                                ],
                              ),
                            ),
                          )


                        ),
                      ),
                    ),

                  ]
              ),
            );

          }


            ),
        )

      :
      Center(child: CircularProgressIndicator(

        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
      ) ,),


    ):
      contents.isNotEmpty?

      Scaffold(
        body: SafeArea(
          child: Container(
            height: Config.yMargin(context, 100),
            width: double.infinity,
          // padding: const EdgeInsets.only(left: 15,right: 15),

            color: appThemeDark.backgroundColor,
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    width: Config.xMargin(context, 100),
                    height: Config.yMargin(context, 8),
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Dreeze Learning", style: appThemeDark.textTheme.title,),

                        Row(
                          children: [
                            IconButton(icon: Icon(
                                Icons.share
                            ), onPressed: (){

                              // showSearch(context: context, delegate: VideoSearchDelegate());

                            }),

                            GestureDetector(
                              key:actionKey,
                              child: Container(
                                  padding: const EdgeInsets.all(3.0),
                                  height: Config.yMargin(context, 4),
                                  width: Config.xMargin(context,14),
                                  margin: const EdgeInsets.only(left: 4),
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black12)
                                  ),
                                  child:Center(
                                      child: Text("$selectedClass",style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black
                                      ),))
                              ),
                              onTap: (){

                                if (isDropdownOpened) {
                                  this._overlayEntry.remove();
                                } else {
                                  this._overlayEntry = this._createOverlayEntry();
                                  Overlay.of(context).insert(this._overlayEntry);
                                  findDropdownData();
                                  //    floatingDropdown = _createFloatingDropdown();
                                  //    Overlay.of(context).insert(floatingDropdown);
                                }

                                isDropdownOpened = !isDropdownOpened;

                              },
                            )

                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: contents.length,
                            scrollDirection: Axis.vertical,
                            controller: controller,
                            padding: const EdgeInsets.only(left: 15),
                            itemBuilder: (ctx, page1index){

                              return Container(
                               color: appThemeDark.backgroundColor,
                                width: Config.xMargin(context, 100),
                               height: Config.yMargin(context, 28),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(contents[page1index].Headname, style: appThemeDark.textTheme.title,),
                                          IconButton(icon: Icon(
                                            Icons.double_arrow,
                                            color: Colors.black,
                                            size: 20,
                                          ), onPressed: (){
                                           _showSearchDialog(contents[page1index], page1index);
                                          })
                                        ],
                                      ),
                                      Container(
                                          height: Config.yMargin(context, 20),
                                          color: appThemeDark.backgroundColor,
                                          width: Config.xMargin(context, 100),
                                          child:  ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:contents[page1index].subhead.length,
                                            scrollDirection: Axis.horizontal,

                                            itemBuilder: (ctx, indexL){
                                              return InkWell(
                                                child: Container(
                                                  height: Config.yMargin(context, 20),
                                                  width:  Config.xMargin(context, 33),
                                                  margin: EdgeInsets.only(right: 8),
                                                  color: appThemeDark.backgroundColor,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      contents[page1index].subhead[indexL].tvglogo.isNotEmpty?
                                                      Container(
                                                        height: Config.yMargin(context,10.5),
                                                        decoration: BoxDecoration(
                                                            color: appThemeDark.primaryColorLight,

                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                            image: DecorationImage(
                                                                fit: BoxFit.cover,

                                                                image: NetworkImage(contents[page1index].subhead[indexL].tvglogo)
                                                            )

                                                        ),
                                                        // child: Image.network(contents[page1index].subhead[indexL].tvglogo,
                                                        // fit: BoxFit.fill,),

                                                      ):

                                                      Container(
                                                          height: Config.yMargin(context, 10.5),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                                            border: Border.all(

                                                                width: 3),
                                                          )),
                                                      SizedBox(height: 10,),
                                                      Expanded(
                                                        child: Text(contents[page1index].subhead[indexL].title,style: TextStyle(
                                                          fontSize:12,
                                                          color: Colors.black,
                                                        ),),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                                onTap: (){
                                                  Navigator.of(context).pushNamed(
                                                      PlayScreen.routeName);
                                                  Provider.of<HomeNotifier>(context, listen: false).changeview(0);
                                                },
                                              );

                                            },
                                          )

                                      ),

                                    ]
                                ),
                              );

                            }


                        ),
                      ),
                      if(_recent.length>1)
                      Container(

                        height: 170,


                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:[
                                  Container(
                                    margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                                    child: Text("Recently Watched", style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12

                                    ),),
                                  ),

                                  IconButton(
                                    icon: Icon(
                                      Icons.double_arrow,
                                      size: 20,
                                    ),
                                    onPressed: (){
                                      // _showSearchDialog();
                                    },
                                  ),

                                ]
                            ),
                            StreamBuilder(
                                stream: dbHelper.queryAllRecently().asStream(),
                                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  }
                                  _recent  = snapshot.data;
                                  //print(_recent.toString());
                                  return Container(
                                    height: 120,

                                    width: double.infinity,

                                    child: ListView.builder(
                                        itemCount: _recent.length,
                                        //shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (ctx, index) {
                                          return InkWell(
                                            //   "https://www.dreezeacademy.com${_currentPlaying.videoSource.trim()}"
                                            child: Padding(
                                              padding: const EdgeInsets.only(right:8.0, left: 8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 120,
                                                    height: 100,
                                                    child: Stack(

                                                      children: [

                                                        ThumbnailImage(
                                                          alignment: Alignment.topLeft,
                                                          fit: BoxFit.cover,

                                                          videoUrl:
                                                          "https://www.dreezeacademy.com${_recent[index].videoSource.trim()}",
                                                          width: 120,
                                                          height: 100,
                                                        ),
                                                        Align(
                                                          alignment: Alignment.center,
                                                          child: Icon(
                                                            Icons.play_circle_outline_outlined,
                                                            color:Colors.white,
                                                            size: 30,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Text("${_recent[index].videoName}")
                                                ],
                                              ),
                                            ),

                                            onTap: (){},

                                          );
                                        }),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),







              ],
            ),
          ),
        ),
      )

          :
      Center(child: CircularProgressIndicator(

        valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
      ) ,);
  }
  Future<void> _showSearchDialog(ListModel list, int indexMain){
    showModalBottomSheet(

        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(

            decoration: BoxDecoration(
                shape:BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                color: appThemeDark.backgroundColor
            ),
            height: Config.yMargin(context, 90),
            child: Container(
              padding: const EdgeInsets.all(6.0),
              height: Config.yMargin(context,90),
              child: Column(

                children: [
                  Container(height: 5,
                    width :Config.xMargin(context, 30),

                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10)
                  ),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new  Container(
                          padding: new EdgeInsets.only(
                              right: 10.0,
                              left: 10.0),
                          child: Text('${list.Headname}',style: appThemeDark.textTheme.title,)),

                      new  Container(
                          alignment: Alignment.topRight,
                          padding: new EdgeInsets.only(

                              right: 10.0),
                          child: IconButton(icon: Icon(
                            Icons.close,
                            size: 25,
                            color: Colors.white,

                          ),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },)),
                    ],
                  ),
                  SizedBox(height: 5,),


                  new   Expanded(
                    child:  GridView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount:list.lenght,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        //childAspectRatio: 5/7,
                        childAspectRatio:MediaQuery.of(context).size.width <800? 5/7: 9/18,
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (ctx, index){
                        return InkWell(
                          child: Container(
                            height: MediaQuery.of(context).size.width <800?Config.yMargin(context, 20):
                            Config.yMargin(context, 40),
                            width:  Config.xMargin(context, 33),
                            // padding: EdgeInsets.all(8.0),
                            color: appThemeDark.backgroundColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                list.subhead[index].tvglogo.isNotEmpty
                                    ?  Container(
                                  height: Config.yMargin(context,9.5),

                                  decoration: BoxDecoration(
                                      color: appThemeDark.primaryColorLight,
                                      borderRadius: BorderRadius.circular(13),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,

                                          image: NetworkImage(list.subhead[index].tvglogo)
                                      )

                                  ),
                                  // child: Image.network(contents[page1index].subhead[indexL].tvglogo,
                                  // fit: BoxFit.fill,),

                                ):
                                Container(
                                    height: Config.yMargin(context, 9.5),
                                    decoration: BoxDecoration(
                                    )),
                                SizedBox(height: 5,),
                                Flexible(
                                  child: Text(list.subhead[index].title,style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),),
                                ),

                              ],
                            ),
                          ),
                          onTap: (){
                            // Provider.of<HomeNotifier>(context, listen: false).changeview(0);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx){
                                //  return PlayPage(index,contents,indexMain,1);
                                  return PlayScreen();
                                  //     return TestingScreen(indexL,contents,page1index);
                                }
                            ));
                          },
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),

          );
        }
    );




  }
 // get newItemCount => (indexTop==1? attribue.length/10:movies.length/10).round();
  void jumpdown(int x,int length){
 var   newItemCount = (length/10).round();
    print((x+1).remainder(4));
    if((x+1).remainder(4) ==1) {
      final _width =controllerPopUp.position.maxScrollExtent / 12 +
          (context.size.height / 12)+10;
      //
      final value = x / newItemCount * _width;
      // print("${attribue.length/3}  $value  ${x+1} rr ${(x+1).remainder(3)}");
      //  controller.jumpTo(value);
      // final _width = Config.xMargin(context, 23);
      controllerPopUp.animateTo(
          value, duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);
    }

  }

  Future<void> _showSearchTv(ListModel list, int indexMain){
    //print( Provider.of<SideNotifier>(context, listen: false).y);
    showModalBottomSheet(

        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return  StatefulBuilder(
          builder: (BuildContext bc,StateSetter setState) {

          return  RawKeyboardListener(
            focusNode: FocusNode(),
            autofocus: true,
            onKey:(RawKeyEvent key){
           if(key.runtimeType.toString() == 'RawKeyUpEvent'){
             RawKeyEventDataAndroid data = key.data as RawKeyEventDataAndroid;
            // print(data.keyCode.toString());
           if(data.keyCode ==22){
             if(popFocus <list.subhead.length-1){
               setState(() {

                 popFocus++;
               });
            jumpdown(popFocus, list.lenght);
             }

           }
            else if(data.keyCode ==21){
             // if(popFocus>5){
             //   if((popFocus+1).remainder(3) ==0) {
             //     final _width = controller.position.maxScrollExtent / 12 +
             //         (context.size.height / 12)+10;
             //     //
             //     final value = popFocus / newItemCount * _width;
             //     // print("${attribue.length/3}  $value  ${x+1} rr ${(x+1).remainder(3)}");
             //     //  controller.jumpTo(value);
             //     // final _width = Config.xMargin(context, 23);
             //     controller.animateTo(
             //         value, duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);
             //   }
             // }else{
             //   final _width = controller.position.maxScrollExtent/list.length +
             //       (context.size.height/attribue.length);
             //   //
             //   final value = x / newItemCount * _width;
             //   controller.animateTo(
             //       value, duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);
             // }

             }
           }
            } ,
            child: Container(

                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    color: appThemeDark.backgroundColor
                ),
                height: Config.yMargin(context, 100),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  height: Config.yMargin(context, 100),
                  child: Column(

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new Container(
                              padding: new EdgeInsets.only(
                                  right: 10.0,
                                  left: 10.0),
                              child: Text('${list.Headname}', style: appThemeDark.textTheme.title,)),

                          new Container(
                              alignment: Alignment.topRight,
                              padding: new EdgeInsets.only(

                                  right: 10.0),
                              child: IconButton(icon: Icon(
                                Icons.close,
                                size: 25,
                                color: Colors.white,

                              ),
                                onPressed: () {
                                  setState(() {
                                    showPopup = false;
                                  });
                                  Navigator.of(context).pop();
                                },)),
                        ],
                      ),
                      SizedBox(height: 5,),


                      new Expanded(
                        child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          controller: controllerPopUp,
                          itemCount: list.lenght,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 6.0 / 6.5,
                            crossAxisCount: 4,
                          ),
                          itemBuilder: (ctx, index) {
                            return InkWell(
                              child: Container(
                                //    height: Config.yMargin(context,25),
                                //   width:  Config.xMargin(context, 23),
                                color: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    list.subhead[index].tvglogo.isNotEmpty
                                        ? Container(
                                      height: Config.yMargin(context, 26),

                                      decoration: BoxDecoration(
                                          color: appThemeDark.primaryColorLight,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color:popFocus == index ? Colors.white : Colors
                                              .transparent,
                                              width: 2),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,

                                              image: NetworkImage(
                                                  list.subhead[index].tvglogo)
                                          )

                                      ),
                                      // child: Image.network(contents[page1index].subhead[indexL].tvglogo,
                                      // fit: BoxFit.fill,),

                                    ) :
                                    Container(
                                        height: Config.yMargin(context, 23),
                                        decoration: BoxDecoration(
                                        )),
                                    SizedBox(height: 5,),
                                    Flexible(
                                      child: Text(list.subhead[index].title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),),
                                    ),

                                  ],
                                ),
                              ),
                              onTap: () {
                                Provider.of<HomeNotifier>(context, listen: false)
                                    .changeview(0);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) {
                                      return PlayScreen();
                                      // return PlayPage(index,contents,indexMain,1);
                                      //     return TestingScreen(indexL,contents,page1index);
                                    }
                                ));
                              },
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),

              ),
          );

          }
          );
        }
    );




  }

}
class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}