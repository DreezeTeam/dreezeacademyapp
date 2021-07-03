import 'package:kindergaten/Model/attributeModel.dart';
import 'package:kindergaten/Model/model.dart';
import 'package:kindergaten/Model/playModel.dart';
import 'package:kindergaten/Size_Config/Config.dart';
import 'package:kindergaten/apptheme/app_theme.dart';
import 'package:kindergaten/provider/homenotifier.dart';
import 'package:kindergaten/provider/notifier.dart';
import 'package:kindergaten/provider/services.dart';
import 'package:kindergaten/screen/playScreen.dart';
import 'package:kindergaten/screen/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../widgets/exploreitem.dart';

class Explore extends StatefulWidget {
  const Explore({Key key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  int xy =3;
  int pageFocus=0;
   void handleKey( RawKeyEvent key) {
   // print("Event runtimeType is ${key.runtimeType.toString()}");
    if(key.runtimeType.toString() == 'RawKeyUpEvent'){

      RawKeyEventDataAndroid data = key.data as RawKeyEventDataAndroid;
      String _keyCode;
      _keyCode = data.keyCode.toString(); //

      //   print("why does this run twice $_keyCode");
      if(data.keyCode ==22){

        if(pageFocus >= 0){

          final x =  Provider.of<SideNotifier>(context, listen: false).openit;
          if(x){
            Provider.of<SideNotifier>(context, listen: false).changeopen();
          }else{
            setState(() {
              // pageFocus++;
              if(pageFocus <= attribue.length-1){
                pageFocus++;


                if(pageFocus>4){
                  jumpdown(pageFocus);
                }
              }

            });
          //  print('right$pageFocus $xy');
          }





        }
      }
      else if(data.keyCode ==21){

        if(pageFocus == 0){
          final y =  Provider.of<SideNotifier>(context, listen: false).openit;
          final position = Provider.of<SideNotifier>(context, listen: false).x;
    //      print('$position po');
          if(!y){
            Provider.of<SideNotifier>(context, listen: false).changeopen();
          }


        }else{

            setState(() {
              pageFocus--;

            });

            jumpup(pageFocus);



        }

      }
      else if(data.keyCode ==19){
        final y =  Provider.of<SideNotifier>(context, listen: false).openit;
        if(y){
          Provider.of<SideNotifier>(context, listen: false).changeview(2);


        }else{
          setState(() {
            // if(verticalCounter < contents.length -1){
            //   verticalCounter++;
            //   controller.jumpToPage(verticalCounter);
            // }


          });}


      }
      else if (data.keyCode ==20){

        //up for page view

        final y =  Provider.of<SideNotifier>(context, listen: false).openit;

        if(y){
         print('open ');
          Provider.of<SideNotifier>(context, listen: false).changeview(4);

        }else{
          setState(() {
            // if(verticalCounter < contents.length -1){
            //   verticalCounter++;
            //   controller.jumpToPage(verticalCounter);
            // }


          });}
      }
      else if (data.keyCode ==4||data.keyCode ==67){
        if(pageFocus >= 0){

          final x =  Provider.of<SideNotifier>(context, listen: false).openit;
          if(!x){
            Provider.of<SideNotifier>(context, listen: false).changeopen();
          }else{
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx){
                  // return PlayerScreen(contents[verticalCounter].subhead ,pageFocus,contents );
                  return SplashScreen();
                }
            ));

          }

        }

      }

    }

  }
  ScrollController controller = ScrollController();
 List<ListModel> contents =[];
  List<AttributeModel> toddlerscontents=[];
  List<ListModel> seriescontents=[];

   List<AttributeModel> attribue = [];
  List<AttributeModel> preschoolcontents = [];
  List<AttributeModel> nurserycontents = [];
  List<AttributeModel> receptioncontents = [];
   List<AttributeModel> searchcontent = [];
   bool search = false;
   var _dispose = false;
   int  indexTop =1;
   var depence = true;
 @override
 void didChangeDependencies()async{
if(depence){
  contents =  FetchServices.returnfetch();
  for(int i=0; i<contents.length;i++){
    if(contents[i].Headname.toLowerCase().trim() == "Toddlers".toLowerCase().trim()){
      toddlerscontents = contents[i].subhead;
    }else if(contents[i].Headname.toLowerCase().trim() == "Preschool".toLowerCase().trim()){
      preschoolcontents= contents[i].subhead;
    } else if(contents[i].Headname.toLowerCase().trim() == "Nursery 2".toLowerCase().trim()){
      nurserycontents = contents[i].subhead;
     } else if(contents[i].Headname.toLowerCase().trim() == "Reception".toLowerCase().trim()){
      receptioncontents = contents[i].subhead;
}
  }
  }
  depence  = false;


   super.didChangeDependencies();
 }
 // void fetchmovies(){
 //   if(movies.length>0)return;
 //   TvShows.fetchmovies().then((value)  {
 //     if(_dispose)return;
 //     setState(() {
 //       moviescontents = value;
 //
 //       moviescontents.forEach((element) {
 //         element.subhead.forEach((element) {
 //           movies.add(element) ;
 //         });
 //
 //       });
 //       print("${movies.length}");
 //     });
 //
 //
 //
 //   });
 // }
 //
 //  void fetchseries(){
 //    if(seriescontents.length>0)return;
 //    TvShows.fetchmovies().then((value)  {
 //      if(_dispose)return;
 //      setState(() {
 //        seriescontents = value;
 //
 //        seriescontents.forEach((element) {
 //          element.subhead.forEach((element) {
 //            series.add(element) ;
 //          });
 //
 //        });
 //       // print("${movies.length}");
 //      });
 //
 //
 //
 //    });
 //  }

  get newItemCount => (indexTop==1? attribue.length/10:toddlerscontents.length/10).round();
   void jumpdown(int x){
     print((x+1).remainder(3));
if((x+1).remainder(3) ==1) {
  final _width = controller.position.maxScrollExtent / 12 +
      (context.size.height / 12)+10;
  //
  final value = x / newItemCount * _width;
  // print("${attribue.length/3}  $value  ${x+1} rr ${(x+1).remainder(3)}");
  //  controller.jumpTo(value);
  // final _width = Config.xMargin(context, 23);
  controller.animateTo(
      value, duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);
}

   }
  void jumpup(int x){
    print((x+1).remainder(3));
    if(x>5){
    if((x+1).remainder(3) ==0) {
      final _width = controller.position.maxScrollExtent / 12 +
          (context.size.height / 12)+10;
      //
      final value = x / newItemCount * _width;
      // print("${attribue.length/3}  $value  ${x+1} rr ${(x+1).remainder(3)}");
      //  controller.jumpTo(value);
      // final _width = Config.xMargin(context, 23);
      controller.animateTo(
          value, duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);
    }
    }else{
      final _width = controller.position.maxScrollExtent/attribue.length +
          (context.size.height/attribue.length);
      //
      final value = x / newItemCount * _width;
      controller.animateTo(
          value, duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);
    }

  }
var _textController = TextEditingController();
  @override
  void initState() {
    // WidgetsFlutterBinding.ensureInitialized();
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  //  _delegate = _MySearchDelegate(attribue);
  }

  @override
  void dispose() {
   _textController.dispose();
   _dispose =true;
    super.dispose();
  }

  Widget _circular(){
    if(indexTop ==1){
    return  ExploreItems(toddlerscontents);

    }else if(indexTop ==2){
    return ExploreItems(preschoolcontents);
    }else if(indexTop ==3){
      return ExploreItems(nurserycontents);
    }else{
      return ExploreItems(receptioncontents);
    }
   // return Flexible(
   //    child: Center(child: CircularProgressIndicator(
   //
   //      valueColor: new AlwaysStoppedAnimation<Color>(appThemeDark.buttonColor),
   //    ) ,),
   //  );
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return

     width >900?
      Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appThemeDark.backgroundColor,
      body: SafeArea(
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKey:handleKey ,
          child: contents.length > 0 ?Container(
            height: Config.yMargin(context, 100),
            margin:const EdgeInsets.only(top:16),
            child: Column(
              children: [
                Container(
                  // color: Colors.white,
                  color: appThemeDark.backgroundColor,
                  height: Config.yMargin(context,16.0),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 15),

                        decoration: BoxDecoration(
                          color:    Color.fromRGBO(54, 52, 68, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: Config.yMargin(context, 6.0),
                        child:InkWell(
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Text("Explore", style: appThemeDark.textTheme.display2,),
                                Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                          onTap: (){
                            if(indexTop==1){
                              showSearch(context: context, delegate: MoviesSearchDelegate(toddlerscontents));
                            }else if(indexTop==2){
                              showSearch(context: context, delegate: MoviesSearchDelegate(preschoolcontents));
                            }else if(indexTop==3){
                              showSearch(context: context, delegate: MoviesSearchDelegate(nurserycontents));
                            }else if(indexTop==3){
                              showSearch(context: context, delegate: MoviesSearchDelegate(receptioncontents));
                            }
                          },
                        ),
                      ),
                      Container(
                        color: appThemeDark.backgroundColor,
                        //   color:Colors.white,
                        //  margin: const EdgeInsets.only(bottom: 5),
                        height:Config.yMargin(context,6.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: Config.xMargin(context, 23),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: indexTop==1? appThemeDark.buttonColor:appThemeDark.backgroundColor,
                                  border: Border.all(
                                    color:indexTop==2||indexTop==3? appThemeDark.buttonColor:appThemeDark.backgroundColor,
                                  )
                              ),
                              child: FlatButton(onPressed: (){
                                setState(() {
                                  indexTop = 1;
                                });
                                //fetchmovies();
                              }, child: Text("Channels",style: appThemeDark.textTheme.display2,)),
                            ),
                            SizedBox(width: 5,),
                            Container(
                              width: Config.xMargin(context, 23),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: indexTop==2? appThemeDark.buttonColor:appThemeDark.backgroundColor,
                                  border: Border.all(
                                    color: indexTop==1 ||indexTop==3? appThemeDark.buttonColor:appThemeDark.backgroundColor,
                                  )
                              ),
                              child: FlatButton(onPressed: (){
                                setState(() {

                                  // fetchmovies();
                                  indexTop = 2;
                                });
                                print(attribue.length);

                              }, child: Text("Movies",style: appThemeDark.textTheme.display2,)),
                            ),
                            SizedBox(width: 5,),
                            Container(
                              width: Config.xMargin(context, 23),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: indexTop==3? appThemeDark.buttonColor:appThemeDark.backgroundColor,
                                  border: Border.all(
                                    color: indexTop==1||indexTop==2? appThemeDark.buttonColor:appThemeDark.backgroundColor,
                                  )
                              ),
                              child: FlatButton(onPressed: (){
                                setState(() {

                                  // fetchseries();
                                  indexTop = 3;
                                });

                              }, child: Text("Series",style: appThemeDark.textTheme.display2,)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                indexTop ==1?
                attribue != null?      Flexible(
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    //shrinkWrap: true,
                    controller: controller,
                    itemCount:attribue.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 6/5.5,
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (ctx, indexL){
                      return InkWell(
                        child: Container(
                          height: Config.yMargin(context, 30),

                          padding: EdgeInsets.all(8.0),
                          color: appThemeDark.backgroundColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              attribue[indexL].tvglogo.isNotEmpty
                                  ?  Container(
                                height: Config.yMargin(context, 25),
                                width:  Config.xMargin(context, 23),
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

                                        image: NetworkImage(attribue[indexL].tvglogo)
                                    )

                                ),
                                // child: Image.network(contents[page1index].subhead[indexL].tvglogo,
                                // fit: BoxFit.fill,),

                              ):
                              Container(
                                  height: Config.yMargin(context, 25),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(18)),
                                    border: Border.all(

                                      // color:
                                      // Focus.of(context).hasPrimaryFocus
                                      //     ? Colors.white:Colors.transparent,

                                        width: 3),
                                  )),
                              SizedBox(height: 10,),
                              Flexible(
                                child: Text(preschoolcontents[indexL].title,style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),),
                              ),

                            ],
                          ),
                        ),
                        onTap: (){
                          Provider.of<HomeNotifier>(context, listen: false).changeview(2);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx){
                                //return vlcPlayer(moviescontents,movies[indexL],2);
                                 return PlayScreen();
                                //     return TestingScreen(indexL,contents,page1index);
                              }
                          ));
                        },
                      );
                    },
                  ),
                ):
                Center(child: CircularProgressIndicator(

                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ) ,):
                indexTop ==2?
                Flexible(
                  // height: Config.yMargin(context, 90),
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    controller: controller,
                    itemCount:  preschoolcontents.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 9/14,
                      crossAxisCount: 4,
                    ),
                    itemBuilder: (ctx, index){
                      return InkWell(
                        child: Container(
                          height: Config.yMargin(context, 36),

                          // padding: EdgeInsets.all(8.0),
                          color: appThemeDark.backgroundColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              preschoolcontents[index].tvglogo.isNotEmpty
                                  ?  Container(
                                height: Config.yMargin(context, 34),
                                width:  Config.xMargin(context, 15),
                                decoration: BoxDecoration(
                                    color: appThemeDark.backgroundColor,
                                    image: DecorationImage(
                                        fit: BoxFit.contain,

                                        image: NetworkImage(toddlerscontents[index].tvglogo)
                                    )

                                ),
                                // child: Image.network(contents[page1index].subhead[indexL].tvglogo,
                                // fit: BoxFit.fill,),

                              ):
                              Container(
                                  height: Config.yMargin(context, 34),
                                  decoration: BoxDecoration(
                                  )),
                              SizedBox(height: 5,),
                              Flexible(
                                child: Text(preschoolcontents[index].title,style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),),
                              ),

                            ],
                          ),
                        ),
                        onTap: (){
                          Provider.of<HomeNotifier>(context, listen: false).changeview(2);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx){
                                //return vlcPlayer(moviescontents,movies[index],2);
                                return PlayScreen();
                                //     return TestingScreen(indexL,contents,page1index);
                              }
                          ));
                        },
                      );


                    },
                  ),
                ): Flexible(
                  child: Center(child: CircularProgressIndicator(

                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ) ,),
                ),
              ],
            ),
          ):
          Center(child: CircularProgressIndicator(

            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          ) ,),
        ),
      ),
    )
    : Scaffold(
       resizeToAvoidBottomInset: false,
      backgroundColor: appThemeDark.backgroundColor,

       body: contents.length > 0 ?Container(
         height: Config.yMargin(context, 100),
         width: double.infinity,
         margin: const EdgeInsets.only(left: 10, top: 40, right: 10),
         child:
         Column(
           children: [

             Container(
             // color: Colors.white,
               color: appThemeDark.backgroundColor,
               height: Config.yMargin(context,13.0),
               margin: const EdgeInsets.only(top: 10),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   Container(
                    padding: const EdgeInsets.only(left: 10, right: 15),

                     decoration: BoxDecoration(
                       border: Border.all(color: Colors.black),
                       borderRadius: BorderRadius.circular(10),
                     ),
                     height: Config.yMargin(context, 5.5),
                     child:InkWell(
                       splashColor: Colors.transparent,
                       hoverColor: Colors.transparent,
                       child: Center(
                         child: Row(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [

                             Text("Explore${toddlerscontents.length}", style: appThemeDark.textTheme.display2,),
                             Icon(
                               Icons.search,
                               color: Colors.black,
                               size: 20,
                             )
                           ],
                         ),
                       ),
                       onTap: (){
                         if(indexTop==1){
                         showSearch(context: context, delegate: MoviesSearchDelegate(toddlerscontents));
                       }else if(indexTop==2){
                         showSearch(context: context, delegate: MoviesSearchDelegate(preschoolcontents));
                       }else if(indexTop==3){
                         showSearch(context: context, delegate: MoviesSearchDelegate(nurserycontents));
                       }else if(indexTop==3){
                         showSearch(context: context, delegate: MoviesSearchDelegate(receptioncontents));
                       }

                       },
                     ),
                   ),
                   Container(
                    color: appThemeDark.backgroundColor,
                  //   color:Colors.white,
                  //  margin: const EdgeInsets.only(bottom: 5),
                     height:Config.yMargin(context,4.5),
                     child: ListView(
                      scrollDirection: Axis.horizontal,

                       children: [
                         Container(
                           width: Config.xMargin(context, 26),
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(5),
                               color: indexTop==1? appThemeDark.buttonColor:appThemeDark.backgroundColor,
                               border: Border.all(
                                 color:indexTop==2||indexTop==3? appThemeDark.buttonColor:appThemeDark.backgroundColor,
                               )
                           ),
                           child: FlatButton(onPressed: (){
                             setState(() {
                               indexTop = 1;
                             });
                             //fetchmovies();
                           }, child: Text("Toddlers",style:indexTop==1?appThemeDark.textTheme.display3: appThemeDark.textTheme.display2,)),
                         ),
                         SizedBox(width: 5,),
                         Container(
                           width: Config.xMargin(context, 27),
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(5),
                               color: indexTop==2? appThemeDark.buttonColor:appThemeDark.backgroundColor,
                               border: Border.all(
                                 color: indexTop==1 ||indexTop==3? appThemeDark.buttonColor:appThemeDark.backgroundColor,
                               )
                           ),
                           child: FlatButton(onPressed: (){
                             setState(() {

                               // fetchmovies();
                               indexTop = 2;
                             });
                             print(attribue.length);

                           }, child: Text("Preschool",style:indexTop==2?appThemeDark.textTheme.display3: appThemeDark.textTheme.display2,)),
                         ),
                         SizedBox(width: 5,),
                         Container(
                           width: Config.xMargin(context, 26),
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(5),
                               color: indexTop==3? appThemeDark.buttonColor:appThemeDark.backgroundColor,
                               border: Border.all(
                                 color: indexTop==1||indexTop==2? appThemeDark.buttonColor:appThemeDark.backgroundColor,
                               )
                           ),
                           child: FlatButton(onPressed: (){
                             setState(() {

                              // fetchseries();
                               indexTop = 3;
                             });

                           }, child: Text("Nursery 2",style:indexTop==3?appThemeDark.textTheme.display3: appThemeDark.textTheme.display2,)),
                         ),
                         SizedBox(width: 5,),
                         Container(
                           width: Config.xMargin(context, 28),
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(5),
                               color: indexTop==4? appThemeDark.buttonColor:appThemeDark.backgroundColor,
                               border: Border.all(
                                 color: indexTop==1||indexTop==2||indexTop==3? appThemeDark.buttonColor:appThemeDark.backgroundColor,
                               )
                           ),
                           child: FlatButton(onPressed: (){
                             setState(() {

                               // fetchseries();
                               indexTop = 4;
                             });

                           }, child: Text("Reception",style:indexTop==3?appThemeDark.textTheme.display3: appThemeDark.textTheme.display2,)),
                         )
                       ],
                     ),
                   ),
                 ],
               ),
             ),

           _circular(),





           ],
         )
       ):
       Center(child: CircularProgressIndicator(

         valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
       ) ,),
     );
  }
}

class MoviesSearchDelegate extends SearchDelegate<AttributeModel>{
  List<AttributeModel> attribute;
  List<ListModel> contents;
  int screen;
  MoviesSearchDelegate(this.attribute);

  // @override
  // ThemeData appBarTheme(BuildContext context) {
  //   final ThemeData theme = ThemeData.dark();
  //   return theme.copyWith(
  //
  //       inputDecorationTheme: InputDecorationTheme(
  //
  //           hintStyle: TextStyle(color: theme.primaryTextTheme.title.color),
  //           filled: true,
  //
  //           fillColor: appThemeDark.primaryColorLight,
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(15)),
  //             borderSide: BorderSide(color:Colors.white),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //
  //             borderRadius: BorderRadius.all(Radius.circular(15)),
  //             borderSide: BorderSide(color:Colors.white),
  //           ),
  //           isDense: true,
  //           contentPadding: EdgeInsets.only(top: 25, left: 10),
  //           enabledBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(15)
  //           )),
  //       primaryColorDark: Colors.black,
  //       backgroundColor:   Colors.white,
  //
  //       buttonColor: Color.fromRGBO(67,59,238,1),
  //       textSelectionColor: Color.fromRGBO(67,59,238,1),
  //       primaryTextTheme: theme.primaryTextTheme,
  //       textTheme: theme.textTheme.copyWith(
  //           title: theme.textTheme.title
  //               .copyWith(color: theme.primaryTextTheme.title.color)));
  // }
  @override
  List<Widget> buildActions(BuildContext context) {
   return [
     IconButton(icon: Icon(
       Icons.clear
     ), onPressed: ()async{
       await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
       Navigator.pop(context);
     })


   ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon:Icon(Icons.arrow_back), onPressed:()async{
      await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      Navigator.pop(context);
    });

  }

  @override
  Widget buildResults(BuildContext context) {

    // var mylist = query.isEmpty
    //     ? this.attribute
    //     : this.attribute.where((element) => element.title.toLowerCase().contains(query.toLowerCase())).toList();
    // return GridView.builder(
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //       mainAxisSpacing: 10,
    //       crossAxisSpacing: 10,
    //       childAspectRatio: 1.0,
    //       crossAxisCount: 3,
    //     ),
    //   itemCount: mylist.length,
    //     shrinkWrap: true,
    //     itemBuilder: (ctx, index){
    //   return Container(
    //       height: Config.yMargin(context, 20),
    //       width:  Config.xMargin(context, 35),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //       mylist[index].tvglogo.isNotEmpty?
    //         Container(
    //           height: Config.yMargin(context, 10.5),
    //           decoration: BoxDecoration(
    //               color: appThemeDark.primaryColorLight,
    //
    //               borderRadius: BorderRadius.all(Radius.circular(10)),
    //               image: DecorationImage(
    //                   fit: BoxFit.contain,
    //
    //                   image: NetworkImage(mylist[index].tvglogo)
    //               )
    //
    //           ),
    //           // child: Image.network(contents[page1index].subhead[indexL].tvglogo,
    //           // fit: BoxFit.fill,),
    //
    //         ):
    //
    //         Container(
    //             height: Config.yMargin(context, 10.5),
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.all(Radius.circular(15)),
    //               border: Border.all(
    //
    //                   width: 3),
    //             )),
    //         SizedBox(height: 10,),
    //         Expanded(
    //           child: Text(mylist[index].title,style: TextStyle(
    //             fontSize:12,
    //             color: Colors.white,
    //           ),),
    //         ),
    //
    //       ],
    //     ),
    //
    //   );
    // });
    return  Container(
      color: appThemeDark.backgroundColor,
      child: Center(child: Text("You have not select any item...",style: TextStyle(
          color: Colors.black,
          fontSize: 15
      ),
      overflow: TextOverflow.ellipsis,)),
    );
  }


  @override
  Widget buildSuggestions(BuildContext context) {
   // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
   var mylist = query.isEmpty
       ? this.attribute
       : this.attribute.where((element) => element.title.toLowerCase().contains(query.toLowerCase())).toList();
    print(query);
    print(mylist.length);
    print(attribute.length);
   return mylist.isEmpty?Container(
     color: appThemeDark.backgroundColor,
     child: Center(child: Text("No Result Found...",style: TextStyle(
       color: Colors.black,
       fontSize: 15
     ),)),
   ) :
   Container(
     color: Colors.white,
     padding: const EdgeInsets.only(top: 10),
     child: ListView.builder(
         itemCount: mylist.length,
         itemBuilder: (ctx, index){
         return Padding(
           padding: const EdgeInsets.all(5.0),
           child: InkWell(
             child: ListTile(
               leading: Image.network('${mylist[index].tvglogo}'),
             title: Text("${mylist[index].title}", style: appThemeDark.textTheme.title,
             overflow: TextOverflow.ellipsis,),),
             onTap: (){
               Provider.of<HomeNotifier>(context, listen: false).changeview(2);
               Navigator.of(context).push(MaterialPageRoute(
                   builder: (ctx){
                     return PlayScreen();
                     // return FlickPlayer2(this.contents,mylist[index],this.screen);
                     //     return TestingScreen(indexL,contents,page1index);
                   }
               ));
             },
           ),
         );
     }),
   );
  }

}