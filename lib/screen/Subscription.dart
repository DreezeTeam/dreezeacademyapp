import 'dart:async';
import 'dart:io';
import 'package:kindergaten/Model/pricemodel.dart';
import 'package:kindergaten/Size_Config/Config.dart';
import 'package:kindergaten/apptheme/app_theme.dart';
import 'package:kindergaten/provider/notifier.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;
import 'package:kindergaten/provider/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String paystackPublicKey = 'pk_live_7f31d9ff902a04c195174c3f7f58e21f6706b77c';
//String paystackPublicKey = 'pk_test_90c118f713846c7c39ca1afbd715813394e60f00';
class SubscriptionScreen extends StatefulWidget {
  static final routeName = '/subscription';
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _verticalSizeBox = const SizedBox(height: 20.0);
  final _horizontalSizeBox = const SizedBox(width: 10.0);
  // ignore: close_sinks
  StreamController<String> controllerstream = StreamController<String>();
  var _border = new Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.red,
  );
  int _radioValue = 0;
  CheckoutMethod _method;
  bool _inProgress = false;
  String _cardNumber;
  String _cvv;
  int _expiryMonth = 0;
  int _expiryYear = 0;
  var _dispose =false;
  int amount =10;
  int indexmore=-1;
  GlobalKey actionKey;
  List<PriceModel>  priceList = [];
  // final plugin = PaystackPlugin();
  String filterValue = "";
  OverlayEntry _overlayEntry;
  double height, width, xPosition, yPosition;
  bool isDropdownOpened = false;
  OverlayEntry floatingDropdown;
  String dropdownValue = 'SS1';
  String username="";
  String name="";
  String selectedClass = "Nursery";
  @override
  void initState() {
    // WidgetsFlutterBinding.ensureInitialized();
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _method = _parseStringToMethod("Card");
    actionKey = LabeledGlobalKey(selectedClass);
    fetchdetails();
    PaystackPlugin.initialize(publicKey: paystackPublicKey);

    super.initState();
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
  @override
  void dispose() {
    _dispose=true;
    super.dispose();
  }
  String uname ="";
  var _dependence = true;
  @override
  Future<void> didChangeDependencies() async {
    if(_dependence) {
    try{
      FetchServices.fetchprices().then((value)  {
        if(_dispose)return;
        setState(() {
         priceList = value;
        });
      });
      final  sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        uname =   sharedPreferences.getString('username');

      });
      _dependence = false;
    }catch(Exception){
      // setState(() {
      //   r = Exception.toString();
      //
      // });
    }
    }

    super.didChangeDependencies();
  }
 void handleKey( RawKeyEvent key) {
    //print("Event runtimeType is ${key.runtimeType.toString()}");
    if(key.runtimeType.toString() == 'RawKeyUpEvent'){

      RawKeyEventDataAndroid data = key.data as RawKeyEventDataAndroid;
      String _keyCode;
      _keyCode = data.keyCode.toString(); //

       print("why does this run twice $_keyCode");
      if(data.keyCode ==22){
        // if(pageFocus >= 0){

          final x =  Provider.of<SideNotifier>(context, listen: false).openit;
          if(x){
            Provider.of<SideNotifier>(context, listen: false).changeopen();
          }


        // }
      }
      else if(data.keyCode ==21){

        // if(pageFocus == 0){
          final y =  Provider.of<SideNotifier>(context, listen: false).openit;
          final position = Provider.of<SideNotifier>(context, listen: false).x;
          print('$position po');
          if(!y){
            Provider.of<SideNotifier>(context, listen: false).changeopen();
          }
        //
        //
        // }

      }
      else if(data.keyCode ==19){
        print('up');
        final y =  Provider.of<SideNotifier>(context, listen: false).openit;
        if(y){
          Provider.of<SideNotifier>(context, listen: false).changeview(3);


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
          //    print('open $opennum');
          Provider.of<SideNotifier>(context, listen: false).changeview(5);
          //   print('open $opennum');

          //print('open $opennum');
          //opennum =1;
          // Provider.of<SideNotifier>(context, listen: false).changeview();





        }else{
          setState(() {
            // if(verticalCounter < contents.length -1){
            //   verticalCounter++;
            //   controller.jumpToPage(verticalCounter);
            // }


          });}
      }

    }

  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return new Scaffold(
       key: _scaffoldKey,
      backgroundColor: appThemeDark.backgroundColor,
      body:

      width >800?

      RawKeyboardListener(
          focusNode: FocusNode(),
        autofocus: true,
        onKey:handleKey ,
        child: priceList.length > 0 ?
          new Container(
            color:appThemeDark.backgroundColor,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
            child: new SingleChildScrollView(
              child: new ListBody(

                children: <Widget>[
                  //    SizedBox(height: Config.yMargin(context, 2),),
                  Container(child: Center(child: new Text('Our Great Deal Jump on them.',style: appThemeDark.textTheme.title,))),
                  SizedBox(height: Config.yMargin(context, 2),),

                  // Container(
                  //   alignment: Alignment.center,
                  //   color: appThemeDark.backgroundColor,
                  //   width: Config.xMargin(context, 100),
                  //   height: Config.yMargin(context, 64),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text('Starter Package', style: appThemeDark.textTheme.title,),
                  //       SizedBox(height: Config.yMargin(context, 1),),
                  //       Container(
                  //         height: Config.yMargin(context, 60),
                  //
                  //         child: ListView(
                  //           // shrinkWrap: true,
                  //           scrollDirection: Axis.horizontal,
                  //           children: [
                  //             Container(
                  //               height: Config.yMargin(context,60),
                  //               width: Config.xMargin(context, 25),
                  //               margin:const EdgeInsets.only(right:20),
                  //               child: new Card(
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(10.0),
                  //                 ),
                  //                 child: Center(child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                   children: [
                  //                     Text('${priceList[0].month}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 18,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Text('${priceList[0].package}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 21,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Text('${priceList[0].original}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 19,
                  //                       fontWeight: FontWeight.w500,
                  //                       decoration: TextDecoration.lineThrough,
                  //                     ),),
                  //                     Text('${priceList[0].main}', style:TextStyle(
                  //                         color: appThemeDark.buttonColor,
                  //                         fontSize: 28,
                  //                         fontWeight: FontWeight.w500
                  //                     ),),
                  //                     Text('${priceList[0].discount}% Off', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 21,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Container(
                  //                       margin: const EdgeInsets.only(left: 10, right: 10),
                  //                       child: Column(
                  //                         crossAxisAlignment: CrossAxisAlignment.end,
                  //                         children: [
                  //                           Text(indexmore !=0
                  //                               ?'${priceList[0].description.substring(0,49)} ':
                  //                           '${priceList[0].description}', style:TextStyle(
                  //
                  //                             color: appThemeDark.buttonColor,
                  //                             fontSize: 15,
                  //                             fontWeight: FontWeight.w400,
                  //
                  //
                  //                           ),
                  //                             textAlign: TextAlign.center,
                  //                             softWrap: true,
                  //                           ),
                  //                           InkWell(
                  //                             child: Padding(
                  //                               padding: const EdgeInsets.only(left: 10, right: 10),
                  //                               child: Text(indexmore ==0 ?'less':'more', style:TextStyle(
                  //
                  //                                 color: appThemeDark.buttonColor,
                  //                                 fontSize: 15,
                  //                                 fontWeight: FontWeight.w400,
                  //
                  //
                  //                               ),
                  //                                 textAlign: TextAlign.center,
                  //                                 softWrap: true,
                  //                               ),
                  //                             ),
                  //                             onTap: (){
                  //                               if(indexmore == 0){
                  //                                 setState(() {
                  //                                   indexmore = -1;
                  //                                 });
                  //                               }else {
                  //                                 setState(() {
                  //                                   indexmore = 0;
                  //                                 });
                  //                               }
                  //                             },
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //
                  //                     Container(
                  //                       width: Config.xMargin(context, 100),
                  //                       margin: const EdgeInsets.only(left: 10, right: 10),
                  //                       decoration: BoxDecoration(
                  //                         borderRadius: BorderRadius.circular(10),
                  //                         color: appThemeDark.buttonColor,
                  //                       ),
                  //
                  //                       child: FlatButton(
                  //                         child: Text("Subscribe Now", style:TextStyle(
                  //                           color: Colors.white,
                  //                           fontSize: 16,
                  //                           fontWeight: FontWeight.w400,
                  //
                  //
                  //                         )),
                  //                         onPressed: (){
                  //                           // setState(() {
                  //                           //   amount = int.parse('${priceList[0].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
                  //                           // });
                  //
                  //
                  //
                  //
                  //                           _handleCheckout(context, amount);
                  //                         },
                  //                       ),
                  //                     )
                  //
                  //                   ],
                  //                 )),
                  //
                  //               ),
                  //             ),
                  //             Container(
                  //               height: Config.yMargin(context,60),
                  //               width: Config.xMargin(context, 25),
                  //               margin:const EdgeInsets.only(right:20),
                  //               child: new Card(
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(10.0),
                  //                 ),
                  //                 child: Center(child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                   children: [
                  //                     Text('${priceList[1].month}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 18,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Text('${priceList[1].package}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 21,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Text('${priceList[1].original}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 19,
                  //                       fontWeight: FontWeight.w500,
                  //                       decoration: TextDecoration.lineThrough,
                  //                     ),),
                  //                     Text('${priceList[1].main}', style:TextStyle(
                  //                         color: appThemeDark.buttonColor,
                  //                         fontSize: 28,
                  //                         fontWeight: FontWeight.w500
                  //                     ),),
                  //                     Text('${priceList[1].discount}% Off', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 21,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //
                  //                     Container(
                  //                       margin: const EdgeInsets.only(left: 10, right: 10),
                  //                       child: Column(
                  //                         crossAxisAlignment: CrossAxisAlignment.end,
                  //                         children: [
                  //                           Text(indexmore !=1
                  //                               ?'${priceList[1].description.substring(0,49)} ':
                  //                           '${priceList[1].description}', style:TextStyle(
                  //
                  //                             color: appThemeDark.buttonColor,
                  //                             fontSize: 15,
                  //                             fontWeight: FontWeight.w400,
                  //
                  //
                  //                           ),
                  //                             textAlign: TextAlign.center,
                  //                             softWrap: true,
                  //                           ),
                  //                           InkWell(
                  //                             child: Padding(
                  //                               padding: const EdgeInsets.only(left: 10, right: 10),
                  //                               child: Text(indexmore ==1 ?'less':'more', style:TextStyle(
                  //
                  //                                 color: appThemeDark.buttonColor,
                  //                                 fontSize: 15,
                  //                                 fontWeight: FontWeight.w400,
                  //
                  //
                  //                               ),
                  //                                 textAlign: TextAlign.center,
                  //                                 softWrap: true,
                  //                               ),
                  //                             ),
                  //                             onTap: (){
                  //                               if(indexmore == 1){
                  //                                 setState(() {
                  //                                   indexmore = -1;
                  //                                 });
                  //                               }else {
                  //                                 setState(() {
                  //                                   indexmore = 1;
                  //                                 });
                  //                               }
                  //                             },
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //
                  //                     Container(
                  //                       width: Config.xMargin(context, 100),
                  //                       margin: const EdgeInsets.only(left: 10, right: 10),
                  //                       decoration: BoxDecoration(
                  //                         borderRadius: BorderRadius.circular(10),
                  //                         color: appThemeDark.buttonColor,
                  //                       ),
                  //
                  //                       child: FlatButton(
                  //                         child: Text("Subscribe Now", style:TextStyle(
                  //                           color: Colors.white,
                  //                           fontSize: 16,
                  //                           fontWeight: FontWeight.w400,
                  //
                  //
                  //                         )),
                  //                         onPressed: (){
                  //                           setState(() {
                  //                             amount = int.parse('${priceList[1].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
                  //                           });
                  //                           _handleCheckout(context, amount*100);
                  //                         },
                  //                       ),
                  //                     )
                  //
                  //                   ],
                  //                 )),
                  //
                  //               ),
                  //             ),
                  //             Container(
                  //               height: Config.yMargin(context,60),
                  //               width: Config.xMargin(context, 25),
                  //               margin:const EdgeInsets.only(right:20),
                  //               //  padding: const EdgeInsets.only(left: 10, right: 10),
                  //               child: new Card(
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(10.0),
                  //                 ),
                  //                 child: Center(child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                   children: [
                  //                     Text('${priceList[2].month}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 18,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Text('${priceList[2].package}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 19,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Text('${priceList[2].original}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 21,
                  //                       fontWeight: FontWeight.w500,
                  //                       decoration: TextDecoration.lineThrough,
                  //                     ),),
                  //                     Text('${priceList[2].main}', style:TextStyle(
                  //                         color: appThemeDark.buttonColor,
                  //                         fontSize: 28,
                  //                         fontWeight: FontWeight.w500
                  //                     ),),
                  //                     Text('${priceList[2].discount}% Off', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 21,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Container(
                  //                       margin: const EdgeInsets.only(left: 10, right: 10),
                  //                       child: Column(
                  //                         crossAxisAlignment: CrossAxisAlignment.end,
                  //                         children: [
                  //                           Text(indexmore !=2
                  //                               ?'${priceList[2].description.substring(0,49)} ':
                  //                           '${priceList[2].description}', style:TextStyle(
                  //
                  //                             color: appThemeDark.buttonColor,
                  //                             fontSize: 15,
                  //                             fontWeight: FontWeight.w400,
                  //
                  //
                  //                           ),
                  //                             textAlign: TextAlign.center,
                  //                             softWrap: true,
                  //                           ),
                  //                           InkWell(
                  //                             hoverColor: Colors.transparent,
                  //                             splashColor: Colors.transparent,
                  //                             child: Padding(
                  //                               padding: const EdgeInsets.only(left: 10, right: 10),
                  //                               child: Text(indexmore ==2 ?'less':'more', style:TextStyle(
                  //
                  //                                 color: appThemeDark.buttonColor,
                  //                                 fontSize: 15,
                  //                                 fontWeight: FontWeight.w400,
                  //
                  //
                  //                               ),
                  //                                 textAlign: TextAlign.center,
                  //                                 softWrap: true,
                  //                               ),
                  //                             ),
                  //                             onTap: (){
                  //                               if(indexmore == 2){
                  //                                 setState(() {
                  //                                   indexmore = -1;
                  //                                 });
                  //                               }else {
                  //                                 setState(() {
                  //                                   indexmore = 2;
                  //                                 });
                  //                               }
                  //                             },
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //
                  //                     Container(
                  //                       width: Config.xMargin(context, 100),
                  //                       margin: const EdgeInsets.only(left: 10, right: 10),
                  //                       decoration: BoxDecoration(
                  //                         borderRadius: BorderRadius.circular(10),
                  //                         color: appThemeDark.buttonColor,
                  //                       ),
                  //
                  //                       child: FlatButton(
                  //                         child: Text("Subscribe Now", style:TextStyle(
                  //                           color: Colors.white,
                  //                           fontSize: 16,
                  //                           fontWeight: FontWeight.w400,
                  //
                  //
                  //                         )),
                  //                         onPressed: (){
                  //                           setState(() {
                  //                             amount = int.parse('${priceList[2].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
                  //                           });
                  //                           _handleCheckout(context, amount*100);
                  //                         },
                  //                       ),
                  //                     )
                  //
                  //                   ],
                  //                 )),
                  //
                  //               ),
                  //             ),
                  //             Container(
                  //               height: Config.yMargin(context,60),
                  //               width: Config.xMargin(context, 25),
                  //               child: new Card(
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(10.0),
                  //                 ),
                  //                 child: Center(child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                   children: [
                  //                     Text('${priceList[3].month}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 18,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Text('${priceList[3].package}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 19,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Text('${priceList[3].original}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 21,
                  //                       fontWeight: FontWeight.w500,
                  //                       decoration: TextDecoration.lineThrough,
                  //                     ),),
                  //                     Text('${priceList[3].main}', style:TextStyle(
                  //                         color: appThemeDark.buttonColor,
                  //                         fontSize: 28,
                  //                         fontWeight: FontWeight.w500
                  //                     ),),
                  //                     Text('${priceList[3].discount}% Off', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 18,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Container(
                  //                       margin: const EdgeInsets.only(left: 10, right: 10),
                  //                       child: Column(
                  //                         crossAxisAlignment: CrossAxisAlignment.end,
                  //                         children: [
                  //                           Text(indexmore !=3
                  //                               ?'${priceList[3].description.substring(0,49)} ':
                  //                           '${priceList[3].description}', style:TextStyle(
                  //
                  //                             color: appThemeDark.buttonColor,
                  //                             fontSize: 15,
                  //                             fontWeight: FontWeight.w400,
                  //
                  //
                  //                           ),
                  //                             textAlign: TextAlign.center,
                  //                             softWrap: true,
                  //                           ),
                  //                           InkWell(
                  //                             child: Padding(
                  //                               padding: const EdgeInsets.only(left: 10, right: 10),
                  //                               child: Text(indexmore ==3 ?'less':'more', style:TextStyle(
                  //
                  //                                 color: appThemeDark.buttonColor,
                  //                                 fontSize: 15,
                  //                                 fontWeight: FontWeight.w400,
                  //
                  //
                  //                               ),
                  //                                 textAlign: TextAlign.center,
                  //                                 softWrap: true,
                  //                               ),
                  //                             ),
                  //                             onTap: (){
                  //                               if(indexmore == 3){
                  //                                 setState(() {
                  //                                   indexmore = -1;
                  //                                 });
                  //                               }else {
                  //                                 setState(() {
                  //                                   indexmore = 3;
                  //                                 });
                  //                               }
                  //                             },
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //
                  //                     Container(
                  //                       width: Config.xMargin(context, 100),
                  //                       margin: const EdgeInsets.only(left: 10, right: 10),
                  //                       decoration: BoxDecoration(
                  //                         borderRadius: BorderRadius.circular(10),
                  //                         color: appThemeDark.buttonColor,
                  //                       ),
                  //
                  //                       child: FlatButton(
                  //                         child: Text("Subscribe Now", style:TextStyle(
                  //                           color: Colors.white,
                  //                           fontSize: 16,
                  //                           fontWeight: FontWeight.w400,
                  //
                  //
                  //                         )),
                  //                         onPressed: (){
                  //                           setState(() {
                  //                             amount = int.parse('${priceList[3].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
                  //                           });
                  //                           _handleCheckout(context, amount*100);
                  //                         },
                  //                       ),
                  //                     )
                  //
                  //                   ],
                  //                 )),
                  //
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: Config.yMargin(context, 1),),
                  Container(
                    alignment: Alignment.center,
                    color: appThemeDark.backgroundColor,
                    width: Config.xMargin(context, 100),
                    height: Config.yMargin(context, 64),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bumper Package', style: appThemeDark.textTheme.title,),
                        SizedBox(height: Config.yMargin(context, 1),),
                        Container(
                          height: Config.yMargin(context, 60),

                          child: ListView(
                            // shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              Container(
                                height: Config.yMargin(context,60),
                                width: Config.xMargin(context, 25),
                                margin:const EdgeInsets.only(right:20),
                                child: new Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('${priceList[4].month}', style:TextStyle(
                                        color: appThemeDark.buttonColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                      Text('${priceList[4].package}', style:TextStyle(
                                        color: appThemeDark.buttonColor,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                      Text('${priceList[4].original}', style:TextStyle(
                                        color: appThemeDark.buttonColor,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.lineThrough,
                                      ),),
                                      Text('${priceList[4].main}', style:TextStyle(
                                          color: appThemeDark.buttonColor,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500
                                      ),),
                                      Text('${priceList[4].discount}% Off', style:TextStyle(
                                        color: appThemeDark.buttonColor,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10, right: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(indexmore !=4
                                                ?'${priceList[4].description.substring(0,49)} ':
                                            '${priceList[4].description}', style:TextStyle(

                                              color: appThemeDark.buttonColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,


                                            ),
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                            ),
                                            InkWell(
                                              child: Text(indexmore ==4 ?'less':'more', style:TextStyle(

                                                color: appThemeDark.buttonColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,


                                              ),
                                                textAlign: TextAlign.center,
                                                softWrap: true,
                                              ),
                                              onTap: (){
                                                if(indexmore == 4){
                                                  setState(() {
                                                    indexmore = -1;
                                                  });
                                                }else {
                                                  setState(() {
                                                    indexmore = 4;
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        width: Config.xMargin(context, 100),
                                        margin: const EdgeInsets.only(left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: appThemeDark.buttonColor,
                                        ),

                                        child: FlatButton(
                                          child: Text("Subscribe Now", style:TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,


                                          )),
                                          onPressed: (){
                                            setState(() {
                                              amount = int.parse('${priceList[4].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
                                            });
                                            _handleCheckout(context,amount* 100,priceList[4].package,priceList[4].month );
                                          },
                                        ),
                                      )

                                    ],
                                  )),

                                ),
                              ),
                              Container(
                                height: Config.yMargin(context,60),
                                width: Config.xMargin(context, 25),
                                margin:const EdgeInsets.only(right:20),
                                child: new Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('${priceList[5].month}', style:TextStyle(
                                        color: appThemeDark.buttonColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                      Text('${priceList[5].package}', style:TextStyle(
                                        color: appThemeDark.buttonColor,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                      Text('${priceList[5].original}', style:TextStyle(
                                        color: appThemeDark.buttonColor,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.lineThrough,
                                      ),),
                                      Text('${priceList[5].main}', style:TextStyle(
                                          color: appThemeDark.buttonColor,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500
                                      ),),
                                      Text('${priceList[5].discount}% Off', style:TextStyle(
                                        color: appThemeDark.buttonColor,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10, right: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(indexmore !=5
                                                ?'${priceList[5].description.substring(0,49)} ':
                                            '${priceList[5].description}', style:TextStyle(

                                              color: appThemeDark.buttonColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,


                                            ),
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                            ),
                                            InkWell(
                                              child: Text(indexmore ==5 ?'less':'more', style:TextStyle(

                                                color: appThemeDark.buttonColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,


                                              ),
                                                textAlign: TextAlign.center,
                                                softWrap: true,
                                              ),
                                              onTap: (){
                                                if(indexmore == 5){
                                                  setState(() {
                                                    indexmore = -1;
                                                  });
                                                }else {
                                                  setState(() {
                                                    indexmore = 5;
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        width: Config.xMargin(context, 100),
                                        margin: const EdgeInsets.only(left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: appThemeDark.buttonColor,
                                        ),

                                        child: FlatButton(
                                          child: Text("Subscribe Now", style:TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,


                                          )),
                                          onPressed: (){
                                            setState(() {
                                              amount = int.parse('${priceList[5].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
                                            });
                                            _handleCheckout(context, amount*100,priceList[5].package,priceList[5].month );
                                          },
                                        ),
                                      )

                                    ],
                                  )),

                                ),
                              ),
                              Container(
                                height: Config.yMargin(context,60),
                                width: Config.xMargin(context, 25),
                                margin:const EdgeInsets.only(right:20),
                                child: new Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('${priceList[6].month}', style:TextStyle(
                                        color: appThemeDark.buttonColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                      Text('${priceList[6].package}', style:TextStyle(
                                        color: appThemeDark.buttonColor,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                      Text('${priceList[6].original}', style:TextStyle(
                                        color: appThemeDark.buttonColor,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.lineThrough,
                                      ),),
                                      Text('${priceList[6].main}', style:TextStyle(
                                          color: appThemeDark.buttonColor,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500
                                      ),),
                                      Text('${priceList[6].discount}% Off', style:TextStyle(
                                        color: appThemeDark.buttonColor,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10, right: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(indexmore !=6
                                                ?'${priceList[6].description.substring(0,49)} ':
                                            '${priceList[6].description}', style:TextStyle(

                                              color: appThemeDark.buttonColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,


                                            ),
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                            ),
                                            InkWell(
                                              child: Text(indexmore ==6 ?'less':'more', style:TextStyle(

                                                color: appThemeDark.buttonColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,


                                              ),
                                                textAlign: TextAlign.center,
                                                softWrap: true,
                                              ),
                                              onTap: (){
                                                if(indexmore == 6){
                                                  setState(() {
                                                    indexmore = -1;
                                                  });
                                                }else {
                                                  setState(() {
                                                    indexmore = 6;
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        width: Config.xMargin(context, 100),
                                        margin: const EdgeInsets.only(left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: appThemeDark.buttonColor,
                                        ),

                                        child: FlatButton(
                                          child: Text("Subscribe Now", style:TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,


                                          )),
                                          onPressed: (){
                                            setState(() {
                                              amount = int.parse('${priceList[6].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
                                            });
                                            _handleCheckout(context, amount*100,priceList[6].package,priceList[6].month );
                                          },
                                        ),
                                      )

                                    ],
                                  )),

                                ),
                              ),
                              Container(
                                height: Config.yMargin(context,60),
                                width: Config.xMargin(context, 25),
                                margin:const EdgeInsets.only(right:20),
                                child: new Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('${priceList[7].month}', style:TextStyle(
                                        color: appThemeDark.buttonColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                      Text('${priceList[7].package}', style:TextStyle(
                                        color: appThemeDark.buttonColor,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                      Text('${priceList[7].original}', style:TextStyle(
                                        color: appThemeDark.buttonColor,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.lineThrough,
                                      ),),
                                      Text('${priceList[7].main}', style:TextStyle(
                                          color: appThemeDark.buttonColor,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500
                                      ),),
                                      Text('${priceList[7].discount}% Off', style:TextStyle(
                                        color: appThemeDark.buttonColor,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10, right: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(indexmore !=7
                                                ?'${priceList[7].description.substring(0,49)} ':
                                            '${priceList[7].description}', style:TextStyle(

                                              color: appThemeDark.buttonColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,


                                            ),
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                            ),
                                            InkWell(
                                              child: Text(indexmore ==7 ?'less':'more', style:TextStyle(

                                                color: appThemeDark.buttonColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,


                                              ),
                                                textAlign: TextAlign.center,
                                                softWrap: true,
                                              ),
                                              onTap: (){
                                                if(indexmore == 7){
                                                  setState(() {
                                                    indexmore = -1;
                                                  });
                                                }else {
                                                  setState(() {
                                                    indexmore = 7;
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        width: Config.xMargin(context, 100),
                                        margin: const EdgeInsets.only(left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: appThemeDark.buttonColor,
                                        ),

                                        child: FlatButton(
                                          child: Text("Subscribe Now", style:TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,


                                          )),
                                          onPressed: (){
                                            setState(() {
                                              amount = int.parse('${priceList[7].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
                                            });
                                            _handleCheckout(context, amount*100,priceList[7].package,priceList[7].month );
                                          },
                                        ),
                                      )

                                    ],
                                  )),

                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: Config.yMargin(context, 1),),
                  // Container(
                  //   alignment: Alignment.center,
                  //   color: appThemeDark.backgroundColor,
                  //   width: Config.xMargin(context, 100),
                  //   height: Config.yMargin(context, 64),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text('Jumbo Package', style: appThemeDark.textTheme.title,),
                  //       SizedBox(height: Config.yMargin(context, 1),),
                  //       Container(
                  //         height: Config.yMargin(context,60),
                  //
                  //         child: ListView(
                  //           // shrinkWrap: true,
                  //           scrollDirection: Axis.horizontal,
                  //           children: [
                  //             Container(
                  //                 margin:const EdgeInsets.only(right:20),
                  //               height: Config.yMargin(context,60),
                  //               width: Config.xMargin(context, 25),
                  //               child: new Card(
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(10.0),
                  //                 ),
                  //                 child: Center(child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                   children: [
                  //                     Text('${priceList[8].month}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 18,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Text('${priceList[8].package}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 21,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Text('${priceList[8].original}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 19,
                  //                       fontWeight: FontWeight.w500,
                  //                       decoration: TextDecoration.lineThrough,
                  //                     ),),
                  //                     Text('${priceList[8].main}', style:TextStyle(
                  //                         color: appThemeDark.buttonColor,
                  //                         fontSize: 28,
                  //                         fontWeight: FontWeight.w500
                  //                     ),),
                  //                     Text('${priceList[8].discount}% Off', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 18,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Container(
                  //                       margin: const EdgeInsets.only(left: 10, right: 10),
                  //                       child: Column(
                  //                         crossAxisAlignment: CrossAxisAlignment.end,
                  //                         children: [
                  //                           Text(indexmore !=8
                  //                               ?'${priceList[8].description.substring(0,49)} ':
                  //                           '${priceList[8].description}', style:TextStyle(
                  //
                  //                             color: appThemeDark.buttonColor,
                  //                             fontSize: 15,
                  //                             fontWeight: FontWeight.w400,
                  //
                  //
                  //                           ),
                  //                             textAlign: TextAlign.center,
                  //                             softWrap: true,
                  //                           ),
                  //                           InkWell(
                  //                             child: Text(indexmore ==8 ?'less':'more', style:TextStyle(
                  //
                  //                               color: appThemeDark.buttonColor,
                  //                               fontSize: 15,
                  //                               fontWeight: FontWeight.w400,
                  //
                  //
                  //                             ),
                  //                               textAlign: TextAlign.center,
                  //                               softWrap: true,
                  //                             ),
                  //                             onTap: (){
                  //                               if(indexmore == 8){
                  //                                 setState(() {
                  //                                   indexmore = -1;
                  //                                 });
                  //                               }else {
                  //                                 setState(() {
                  //                                   indexmore = 8;
                  //                                 });
                  //                               }
                  //                             },
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //
                  //                     Container(
                  //                       width: Config.xMargin(context, 100),
                  //                       margin: const EdgeInsets.only(left: 10, right: 10),
                  //                       decoration: BoxDecoration(
                  //                         borderRadius: BorderRadius.circular(10),
                  //                         color: appThemeDark.buttonColor,
                  //                       ),
                  //
                  //                       child: FlatButton(
                  //                         child: Text("Subscribe Now", style:TextStyle(
                  //                           color: Colors.white,
                  //                           fontSize: 16,
                  //                           fontWeight: FontWeight.w400,
                  //
                  //
                  //                         )),
                  //                         onPressed: (){
                  //                           setState(() {
                  //                             amount = int.parse('${priceList[8].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
                  //                           });
                  //                           _handleCheckout(context, amount*100);
                  //                         },
                  //                       ),
                  //                     )
                  //
                  //                   ],
                  //                 )),
                  //
                  //               ),
                  //             ),
                  //             Container(
                  //                 margin:const EdgeInsets.only(right:20),
                  //               height: Config.yMargin(context,60),
                  //               width: Config.xMargin(context, 25),
                  //               child: new Card(
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(10.0),
                  //                 ),
                  //                 child: Center(child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                   children: [
                  //                     Text('${priceList[9].month}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 15,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Text('${priceList[9].package}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 18,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Text('${priceList[9].original}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 16,
                  //                       fontWeight: FontWeight.w500,
                  //                       decoration: TextDecoration.lineThrough,
                  //                     ),),
                  //                     Text('${priceList[9].main}', style:TextStyle(
                  //                         color: appThemeDark.buttonColor,
                  //                         fontSize: 25,
                  //                         fontWeight: FontWeight.w500
                  //                     ),),
                  //                     Text('${priceList[9].discount}% Off', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 18,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Container(
                  //                       margin: const EdgeInsets.only(left: 10, right: 10),
                  //                       child: Column(
                  //                         crossAxisAlignment: CrossAxisAlignment.end,
                  //                         children: [
                  //                           Text(indexmore !=9
                  //                               ?'${priceList[9].description.substring(0,49)} ':
                  //                           '${priceList[9].description}', style:TextStyle(
                  //
                  //                             color: appThemeDark.buttonColor,
                  //                             fontSize: 12,
                  //                             fontWeight: FontWeight.w400,
                  //
                  //
                  //                           ),
                  //                             textAlign: TextAlign.center,
                  //                             softWrap: true,
                  //                           ),
                  //                           InkWell(
                  //                             child: Text(indexmore ==9 ?'less':'more', style:TextStyle(
                  //
                  //                               color: appThemeDark.buttonColor,
                  //                               fontSize: 12,
                  //                               fontWeight: FontWeight.w400,
                  //
                  //
                  //                             ),
                  //                               textAlign: TextAlign.center,
                  //                               softWrap: true,
                  //                             ),
                  //                             onTap: (){
                  //                               if(indexmore == 9){
                  //                                 setState(() {
                  //                                   indexmore = -1;
                  //                                 });
                  //                               }else {
                  //                                 setState(() {
                  //                                   indexmore = 9;
                  //                                 });
                  //                               }
                  //                             },
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //
                  //                     Container(
                  //                       width: Config.xMargin(context, 100),
                  //                       margin: const EdgeInsets.only(left: 10, right: 10),
                  //                       decoration: BoxDecoration(
                  //                         borderRadius: BorderRadius.circular(10),
                  //                         color: appThemeDark.buttonColor,
                  //                       ),
                  //
                  //                       child: FlatButton(
                  //                         child: Text("Subscribe Now", style:TextStyle(
                  //                           color: Colors.white,
                  //                           fontSize: 16,
                  //                           fontWeight: FontWeight.w400,
                  //
                  //
                  //                         )),
                  //                         onPressed: (){
                  //                           setState(() {
                  //                             amount = int.parse('${priceList[9].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
                  //                           });
                  //                           _handleCheckout(context, amount*100);
                  //                         },
                  //                       ),
                  //                     )
                  //
                  //                   ],
                  //                 )),
                  //
                  //               ),
                  //             ),
                  //             Container(
                  //                 margin:const EdgeInsets.only(right:20),
                  //               height: Config.yMargin(context,60),
                  //               width: Config.xMargin(context, 25),
                  //               child: new Card(
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(10.0),
                  //                 ),
                  //                 child: Center(child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                   children: [
                  //                     Text('${priceList[10].month}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 18,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Text('${priceList[10].package}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 21,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Text('${priceList[10].original}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 19,
                  //                       fontWeight: FontWeight.w500,
                  //                       decoration: TextDecoration.lineThrough,
                  //                     ),),
                  //                     Text('${priceList[10].main}', style:TextStyle(
                  //                         color: appThemeDark.buttonColor,
                  //                         fontSize: 28,
                  //                         fontWeight: FontWeight.w500
                  //                     ),),
                  //                     Text('${priceList[10].discount}% Off', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 21,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Container(
                  //                       margin: const EdgeInsets.only(left: 10, right: 10),
                  //                       child: Column(
                  //                         crossAxisAlignment: CrossAxisAlignment.end,
                  //                         children: [
                  //                           Text(indexmore !=10
                  //                               ?'${priceList[10].description.substring(0,49)} ':
                  //                           '${priceList[10].description}', style:TextStyle(
                  //
                  //                             color: appThemeDark.buttonColor,
                  //                             fontSize: 15,
                  //                             fontWeight: FontWeight.w400,
                  //
                  //
                  //                           ),
                  //                             textAlign: TextAlign.center,
                  //                             softWrap: true,
                  //                           ),
                  //                           InkWell(
                  //                             child: Text(indexmore ==10 ?'less':'more', style:TextStyle(
                  //
                  //                               color: appThemeDark.buttonColor,
                  //                               fontSize: 15,
                  //                               fontWeight: FontWeight.w400,
                  //
                  //
                  //                             ),
                  //                               textAlign: TextAlign.center,
                  //                               softWrap: true,
                  //                             ),
                  //                             onTap: (){
                  //                               if(indexmore == 10){
                  //                                 setState(() {
                  //                                   indexmore = -1;
                  //                                 });
                  //                               }else {
                  //                                 setState(() {
                  //                                   indexmore = 10;
                  //                                 });
                  //                               }
                  //                             },
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //
                  //                     Container(
                  //                       width: Config.xMargin(context, 100),
                  //                       margin: const EdgeInsets.only(left: 10, right: 10),
                  //                       decoration: BoxDecoration(
                  //                         borderRadius: BorderRadius.circular(10),
                  //                         color: appThemeDark.buttonColor,
                  //                       ),
                  //
                  //                       child: FlatButton(
                  //                         child: Text("Subscribe Now", style:TextStyle(
                  //                           color: Colors.white,
                  //                           fontSize: 16,
                  //                           fontWeight: FontWeight.w400,
                  //
                  //
                  //                         )),
                  //                         onPressed: (){
                  //                           setState(() {
                  //                             amount = int.parse('${priceList[10].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
                  //                           });
                  //                           _handleCheckout(context, amount*100);
                  //                         },
                  //                       ),
                  //                     )
                  //
                  //                   ],
                  //                 )),
                  //
                  //               ),
                  //             ),
                  //             Container(
                  //                 margin:const EdgeInsets.only(right:20),
                  //               height: Config.yMargin(context,60),
                  //               width: Config.xMargin(context, 25),
                  //               child: new Card(
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(10.0),
                  //                 ),
                  //                 child: Center(child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                   children: [
                  //                     Text('${priceList[11].month}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 18,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Text('${priceList[11].package}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 21,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Text('${priceList[11].original}', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 19,
                  //                       fontWeight: FontWeight.w500,
                  //                       decoration: TextDecoration.lineThrough,
                  //                     ),),
                  //                     Text('${priceList[11].main}', style:TextStyle(
                  //                         color: appThemeDark.buttonColor,
                  //                         fontSize: 28,
                  //                         fontWeight: FontWeight.w500
                  //                     ),),
                  //                     Text('${priceList[11].discount}% Off', style:TextStyle(
                  //                       color: appThemeDark.buttonColor,
                  //                       fontSize: 21,
                  //                       fontWeight: FontWeight.w500,
                  //                     ),),
                  //                     Container(
                  //                       margin: const EdgeInsets.only(left: 10, right: 10),
                  //                       child: Column(
                  //                         crossAxisAlignment: CrossAxisAlignment.end,
                  //                         children: [
                  //                           Text(indexmore !=11
                  //                               ?'${priceList[11].description.substring(0,49)} ':
                  //                           '${priceList[11].description}', style:TextStyle(
                  //
                  //                             color: appThemeDark.buttonColor,
                  //                             fontSize: 15,
                  //                             fontWeight: FontWeight.w400,
                  //
                  //
                  //                           ),
                  //                             textAlign: TextAlign.center,
                  //                             softWrap: true,
                  //                           ),
                  //                           InkWell(
                  //                             child: Text(indexmore ==11 ?'less':'more', style:TextStyle(
                  //
                  //                               color: appThemeDark.buttonColor,
                  //                               fontSize: 15,
                  //                               fontWeight: FontWeight.w400,
                  //
                  //
                  //                             ),
                  //                               textAlign: TextAlign.center,
                  //                               softWrap: true,
                  //                             ),
                  //                             onTap: (){
                  //                               if(indexmore == 11){
                  //                                 setState(() {
                  //                                   indexmore = -1;
                  //                                 });
                  //                               }else {
                  //                                 setState(() {
                  //                                   indexmore = 11;
                  //                                 });
                  //                               }
                  //                             },
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //
                  //                     Container(
                  //                       width: Config.xMargin(context, 100),
                  //                       margin: const EdgeInsets.only(left: 10, right: 10),
                  //                       decoration: BoxDecoration(
                  //                         borderRadius: BorderRadius.circular(10),
                  //                         color: appThemeDark.buttonColor,
                  //                       ),
                  //
                  //                       child: FlatButton(
                  //                         child: Text("Subscribe Now", style:TextStyle(
                  //                           color: Colors.white,
                  //                           fontSize: 16,
                  //                           fontWeight: FontWeight.w400,
                  //
                  //
                  //                         )),
                  //                         onPressed: (){
                  //                           setState(() {
                  //                             amount = int.parse('${priceList[11].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
                  //                           });
                  //                           _handleCheckout(context, amount*100);
                  //                         },
                  //                       ),
                  //                     )
                  //
                  //                   ],
                  //                 )),
                  //
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: Config.yMargin(context, 8),),

                ],
              ),
            ),
          ):  Center(
          child: CircularProgressIndicator(

            valueColor: new AlwaysStoppedAnimation<Color>(Colors.black54),
          ),
        ),
      ) :
    priceList.length > 0 ?
    SafeArea(
        child: new Container(
          color:appThemeDark.backgroundColor,
        //      margin: const EdgeInsets.only(left: 10, right: 10),
          child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                      Text("Subscription", style: appThemeDark.textTheme.title,),

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
          //    SizedBox(height: Config.yMargin(context, 2),),
              Container(
                  margin: const EdgeInsets.only( top: 10),
                  child: Center(child: new Text('Our Great Deal Jump on them.',style: appThemeDark.textTheme.title,))),

              // SizedBox(height: Config.yMargin(context, 2),),
              //
              // Container(
              //   alignment: Alignment.center,
              //   color: appThemeDark.backgroundColor,
              //   width: Config.xMargin(context, 100),
              //   height: Config.yMargin(context, 49),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text('Starter Package', style: appThemeDark.textTheme.title,),
              //       SizedBox(height: Config.yMargin(context, 1),),
              //       Container(
              //         height: Config.yMargin(context, 45),
              //
              //         child: ListView(
              //           // shrinkWrap: true,
              //           scrollDirection: Axis.horizontal,
              //           children: [
              //             Container(
              //               height: Config.yMargin(context,45),
              //               width: Config.xMargin(context, 45),
              //
              //               child: new Card(
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(10.0),
              //                 ),
              //                 child: Center(child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                   children: [
              //                     Text('${priceList[0].month}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 15,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Text('${priceList[0].package}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Text('${priceList[0].original}', style:TextStyle(
              //                         color: appThemeDark.buttonColor,
              //                         fontSize: 16,
              //                         fontWeight: FontWeight.w500,
              //                       decoration: TextDecoration.lineThrough,
              //                     ),),
              //                     Text('${priceList[0].main}', style:TextStyle(
              //                         color: appThemeDark.buttonColor,
              //                       fontSize: 25,
              //                       fontWeight: FontWeight.w500
              //                     ),),
              //                     Text('${priceList[0].discount}% Off', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Container(
              //                       margin: const EdgeInsets.only(left: 10, right: 10),
              //                       child: Column(
              //                         crossAxisAlignment: CrossAxisAlignment.end,
              //                         children: [
              //                           Text(indexmore !=0
              //                               ?'${priceList[0].description.substring(0,49)} ':
              //                              '${priceList[0].description}', style:TextStyle(
              //
              //                             color: appThemeDark.buttonColor,
              //                             fontSize: 12,
              //                             fontWeight: FontWeight.w400,
              //
              //
              //                           ),
              //                           textAlign: TextAlign.center,
              //                           softWrap: true,
              //                           ),
              //                           InkWell(
              //                             child: Padding(
              //                               padding: const EdgeInsets.only(left: 10, right: 10),
              //                               child: Text(indexmore ==0 ?'less':'more', style:TextStyle(
              //
              //                                 color: appThemeDark.buttonColor,
              //                                 fontSize: 12,
              //                                 fontWeight: FontWeight.w400,
              //
              //
              //                               ),
              //                                 textAlign: TextAlign.center,
              //                                 softWrap: true,
              //                               ),
              //                             ),
              //                             onTap: (){
              //                               if(indexmore == 0){
              //                                 setState(() {
              //                                   indexmore = -1;
              //                                 });
              //                               }else {
              //                                 setState(() {
              //                                   indexmore = 0;
              //                                 });
              //                               }
              //                             },
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //
              //                     Container(
              //                       width: Config.xMargin(context, 100),
              //                     margin: const EdgeInsets.only(left: 10, right: 10),
              //                       decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.circular(10),
              //                         color: appThemeDark.buttonColor,
              //                       ),
              //
              //                       child: FlatButton(
              //                         child: Text("Subscribe Now", style:TextStyle(
              //                           color: Colors.white,
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w400,
              //
              //
              //                         )),
              //                         onPressed: (){
              //                           // setState(() {
              //                           //   amount = int.parse('${priceList[0].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
              //                           // });
              //
              //
              //
              //
              //                         _handleCheckout(context, amount);
              //                         },
              //                       ),
              //                     )
              //
              //                   ],
              //                 )),
              //
              //               ),
              //             ),
              //             Container(
              //               height: Config.yMargin(context,40),
              //               width: Config.xMargin(context, 45),
              //               child: new Card(
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(10.0),
              //                 ),
              //                 child: Center(child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                   children: [
              //                     Text('${priceList[1].month}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 15,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Text('${priceList[1].package}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Text('${priceList[1].original}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.w500,
              //                       decoration: TextDecoration.lineThrough,
              //                     ),),
              //                     Text('${priceList[1].main}', style:TextStyle(
              //                         color: appThemeDark.buttonColor,
              //                         fontSize: 25,
              //                         fontWeight: FontWeight.w500
              //                     ),),
              //                     Text('${priceList[1].discount}% Off', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //
              //                     Container(
              //                         margin: const EdgeInsets.only(left: 10, right: 10),
              //                       child: Column(
              //                         crossAxisAlignment: CrossAxisAlignment.end,
              //                         children: [
              //                           Text(indexmore !=1
              //                               ?'${priceList[1].description.substring(0,49)} ':
              //                           '${priceList[1].description}', style:TextStyle(
              //
              //                             color: appThemeDark.buttonColor,
              //                             fontSize: 12,
              //                             fontWeight: FontWeight.w400,
              //
              //
              //                           ),
              //                             textAlign: TextAlign.center,
              //                             softWrap: true,
              //                           ),
              //                           InkWell(
              //                             child: Padding(
              //                               padding: const EdgeInsets.only(left: 10, right: 10),
              //                               child: Text(indexmore ==1 ?'less':'more', style:TextStyle(
              //
              //                                 color: appThemeDark.buttonColor,
              //                                 fontSize: 12,
              //                                 fontWeight: FontWeight.w400,
              //
              //
              //                               ),
              //                                 textAlign: TextAlign.center,
              //                                 softWrap: true,
              //                               ),
              //                             ),
              //                             onTap: (){
              //                               if(indexmore == 1){
              //                                 setState(() {
              //                                   indexmore = -1;
              //                                 });
              //                               }else {
              //                                 setState(() {
              //                                   indexmore = 1;
              //                                 });
              //                               }
              //                             },
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //
              //                     Container(
              //                       width: Config.xMargin(context, 100),
              //                       margin: const EdgeInsets.only(left: 10, right: 10),
              //                       decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.circular(10),
              //                         color: appThemeDark.buttonColor,
              //                       ),
              //
              //                       child: FlatButton(
              //                         child: Text("Subscribe Now", style:TextStyle(
              //                           color: Colors.white,
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w400,
              //
              //
              //                         )),
              //                         onPressed: (){
              //                           setState(() {
              //                             amount = int.parse('${priceList[1].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
              //                           });
              //                           _handleCheckout(context, amount*100);
              //                         },
              //                       ),
              //                     )
              //
              //                   ],
              //                 )),
              //
              //               ),
              //             ),
              //             Container(
              //               height: Config.yMargin(context,40),
              //               width: Config.xMargin(context, 45),
              //             //  padding: const EdgeInsets.only(left: 10, right: 10),
              //               child: new Card(
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(10.0),
              //                 ),
              //                 child: Center(child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                   children: [
              //                     Text('${priceList[2].month}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 15,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Text('${priceList[2].package}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Text('${priceList[2].original}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                       decoration: TextDecoration.lineThrough,
              //                     ),),
              //                     Text('${priceList[2].main}', style:TextStyle(
              //                         color: appThemeDark.buttonColor,
              //                         fontSize: 25,
              //                         fontWeight: FontWeight.w500
              //                     ),),
              //                     Text('${priceList[2].discount}% Off', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Container(
              //                       margin: const EdgeInsets.only(left: 10, right: 10),
              //                       child: Column(
              //                         crossAxisAlignment: CrossAxisAlignment.end,
              //                         children: [
              //                           Text(indexmore !=2
              //                               ?'${priceList[2].description.substring(0,49)} ':
              //                           '${priceList[2].description}', style:TextStyle(
              //
              //                             color: appThemeDark.buttonColor,
              //                             fontSize: 12,
              //                             fontWeight: FontWeight.w400,
              //
              //
              //                           ),
              //                             textAlign: TextAlign.center,
              //                             softWrap: true,
              //                           ),
              //                           InkWell(
              //                               hoverColor: Colors.transparent,
              //                             splashColor: Colors.transparent,
              //                             child: Padding(
              //                               padding: const EdgeInsets.only(left: 10, right: 10),
              //                               child: Text(indexmore ==2 ?'less':'more', style:TextStyle(
              //
              //                                 color: appThemeDark.buttonColor,
              //                                 fontSize: 12,
              //                                 fontWeight: FontWeight.w400,
              //
              //
              //                               ),
              //                                 textAlign: TextAlign.center,
              //                                 softWrap: true,
              //                               ),
              //                             ),
              //                             onTap: (){
              //                               if(indexmore == 2){
              //                                 setState(() {
              //                                   indexmore = -1;
              //                                 });
              //                               }else {
              //                                 setState(() {
              //                                   indexmore = 2;
              //                                 });
              //                               }
              //                             },
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //
              //                     Container(
              //                       width: Config.xMargin(context, 100),
              //                       margin: const EdgeInsets.only(left: 10, right: 10),
              //                       decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.circular(10),
              //                         color: appThemeDark.buttonColor,
              //                       ),
              //
              //                       child: FlatButton(
              //                         child: Text("Subscribe Now", style:TextStyle(
              //                           color: Colors.white,
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w400,
              //
              //
              //                         )),
              //                         onPressed: (){
              //                           setState(() {
              //                             amount = int.parse('${priceList[2].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
              //                           });
              //                           _handleCheckout(context, amount*100);
              //                         },
              //                       ),
              //                     )
              //
              //                   ],
              //                 )),
              //
              //               ),
              //             ),
              //             Container(
              //               height: Config.yMargin(context,40),
              //               width: Config.xMargin(context, 45),
              //               child: new Card(
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(10.0),
              //                 ),
              //                 child: Center(child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                   children: [
              //                     Text('${priceList[3].month}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 15,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Text('${priceList[3].package}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Text('${priceList[3].original}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                       decoration: TextDecoration.lineThrough,
              //                     ),),
              //                     Text('${priceList[3].main}', style:TextStyle(
              //                         color: appThemeDark.buttonColor,
              //                         fontSize: 25,
              //                         fontWeight: FontWeight.w500
              //                     ),),
              //                     Text('${priceList[3].discount}% Off', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Container(
              //                       margin: const EdgeInsets.only(left: 10, right: 10),
              //                       child: Column(
              //                        crossAxisAlignment: CrossAxisAlignment.end,
              //                         children: [
              //                           Text(indexmore !=3
              //                               ?'${priceList[3].description.substring(0,49)} ':
              //                           '${priceList[3].description}', style:TextStyle(
              //
              //                             color: appThemeDark.buttonColor,
              //                             fontSize: 12,
              //                             fontWeight: FontWeight.w400,
              //
              //
              //                           ),
              //                             textAlign: TextAlign.center,
              //                             softWrap: true,
              //                           ),
              //                           InkWell(
              //                             child: Padding(
              //                               padding: const EdgeInsets.only(left: 10, right: 10),
              //                               child: Text(indexmore ==3 ?'less':'more', style:TextStyle(
              //
              //                                 color: appThemeDark.buttonColor,
              //                                 fontSize: 12,
              //                                 fontWeight: FontWeight.w400,
              //
              //
              //                               ),
              //                                 textAlign: TextAlign.center,
              //                                 softWrap: true,
              //                               ),
              //                             ),
              //                             onTap: (){
              //                               if(indexmore == 3){
              //                                 setState(() {
              //                                   indexmore = -1;
              //                                 });
              //                               }else {
              //                                 setState(() {
              //                                   indexmore = 3;
              //                                 });
              //                               }
              //                             },
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //
              //                     Container(
              //                       width: Config.xMargin(context, 100),
              //                       margin: const EdgeInsets.only(left: 10, right: 10),
              //                       decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.circular(10),
              //                         color: appThemeDark.buttonColor,
              //                       ),
              //
              //                       child: FlatButton(
              //                         child: Text("Subscribe Now", style:TextStyle(
              //                           color: Colors.white,
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w400,
              //
              //
              //                         )),
              //                         onPressed: (){
              //                           setState(() {
              //                             amount = int.parse('${priceList[3].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
              //                           });
              //                           _handleCheckout(context, amount*100);
              //                         },
              //                       ),
              //                     )
              //
              //                   ],
              //                 )),
              //
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: Config.yMargin(context, 5),),
              Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Text('Bumper Package', style: appThemeDark.textTheme.title,textAlign: TextAlign.left,)),
              SizedBox(height: Config.yMargin(context, 1),),
              Expanded(
                child: SingleChildScrollView(
                  // alignment: Alignment.center,
                  // color: appThemeDark.backgroundColor,
                  // width: Config.xMargin(context, 100),
                  // height: Config.yMargin(context, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: Config.yMargin(context,40),
                            width: Config.xMargin(context, 45),
                            child: new Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('${priceList[4].month}', style:TextStyle(
                                    color: appThemeDark.buttonColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  Text('${priceList[4].package}', style:TextStyle(
                                    color: appThemeDark.buttonColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  Text('${priceList[4].original}', style:TextStyle(
                                    color: appThemeDark.buttonColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough,
                                  ),),
                                  Text('${priceList[4].main}', style:TextStyle(
                                      color: appThemeDark.buttonColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500
                                  ),),
                                  Text('${priceList[4].discount}% Off', style:TextStyle(
                                    color: appThemeDark.buttonColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(indexmore !=4
                                            ?'${priceList[4].description.substring(0,49)} ':
                                        '${priceList[4].description}', style:TextStyle(

                                          color: appThemeDark.buttonColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,


                                        ),
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                        ),
                                        InkWell(
                                          child: Text(indexmore ==4 ?'less':'more', style:TextStyle(

                                            color: appThemeDark.buttonColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,


                                          ),
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                          ),
                                          onTap: (){
                                            if(indexmore == 4){
                                              setState(() {
                                                indexmore = -1;
                                              });
                                            }else {
                                              setState(() {
                                                indexmore = 4;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width: Config.xMargin(context, 100),
                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: appThemeDark.buttonColor,
                                    ),

                                    child: FlatButton(
                                      child: Text("Subscribe Now", style:TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,


                                      )),
                                      onPressed: (){
                                        setState(() {
                                          amount = int.parse('${priceList[4].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
                                        });
                                        _handleCheckout(context, amount*100,priceList[4].package,priceList[4].month );
                                      },
                                    ),
                                  )

                                ],
                              )),

                            ),
                          ),
                          Container(
                            height: Config.yMargin(context,40),
                            width: Config.xMargin(context, 45),
                            child: new Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('${priceList[5].month}', style:TextStyle(
                                    color: appThemeDark.buttonColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  Text('${priceList[5].package}', style:TextStyle(
                                    color: appThemeDark.buttonColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  Text('${priceList[5].original}', style:TextStyle(
                                    color: appThemeDark.buttonColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough,
                                  ),),
                                  Text('${priceList[5].main}', style:TextStyle(
                                      color: appThemeDark.buttonColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500
                                  ),),
                                  Text('${priceList[5].discount}% Off', style:TextStyle(
                                    color: appThemeDark.buttonColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(indexmore !=5
                                            ?'${priceList[5].description.substring(0,49)} ':
                                        '${priceList[5].description}', style:TextStyle(

                                          color: appThemeDark.buttonColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,


                                        ),
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                        ),
                                        InkWell(
                                          child: Text(indexmore ==5 ?'less':'more', style:TextStyle(

                                            color: appThemeDark.buttonColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,


                                          ),
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                          ),
                                          onTap: (){
                                            if(indexmore == 5){
                                              setState(() {
                                                indexmore = -1;
                                              });
                                            }else {
                                              setState(() {
                                                indexmore = 5;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width: Config.xMargin(context, 100),
                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: appThemeDark.buttonColor,
                                    ),

                                    child: FlatButton(
                                      child: Text("Subscribe Now", style:TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,


                                      )),
                                      onPressed: (){
                                        setState(() {
                                          amount = int.parse('${priceList[5].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
                                        });
                                        _handleCheckout(context, amount*100,priceList[5].package,priceList[5].month );
                                      },
                                    ),
                                  )

                                ],
                              )),

                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: Config.yMargin(context,40),
                            width: Config.xMargin(context, 45),
                            child: new Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('${priceList[6].month}', style:TextStyle(
                                    color: appThemeDark.buttonColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  Text('${priceList[6].package}', style:TextStyle(
                                    color: appThemeDark.buttonColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  Text('${priceList[6].original}', style:TextStyle(
                                    color: appThemeDark.buttonColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough,
                                  ),),
                                  Text('${priceList[6].main}', style:TextStyle(
                                      color: appThemeDark.buttonColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500
                                  ),),
                                  Text('${priceList[6].discount}% Off', style:TextStyle(
                                    color: appThemeDark.buttonColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(indexmore !=6
                                            ?'${priceList[6].description.substring(0,49)} ':
                                        '${priceList[6].description}', style:TextStyle(

                                          color: appThemeDark.buttonColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,


                                        ),
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                        ),
                                        InkWell(
                                          child: Text(indexmore ==6 ?'less':'more', style:TextStyle(

                                            color: appThemeDark.buttonColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,


                                          ),
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                          ),
                                          onTap: (){
                                            if(indexmore == 6){
                                              setState(() {
                                                indexmore = -1;
                                              });
                                            }else {
                                              setState(() {
                                                indexmore = 6;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width: Config.xMargin(context, 100),
                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: appThemeDark.buttonColor,
                                    ),

                                    child: FlatButton(
                                      child: Text("Subscribe Now", style:TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,


                                      )),
                                      onPressed: (){
                                        setState(() {
                                          amount = int.parse('${priceList[6].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
                                        });
                                        _handleCheckout(context, amount*100,priceList[6].package,priceList[6].month );
                                      },
                                    ),
                                  )

                                ],
                              )),

                            ),
                          ),
                          Container(
                            height: Config.yMargin(context,40),
                            width: Config.xMargin(context, 45),
                            child: new Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('${priceList[7].month}', style:TextStyle(
                                    color: appThemeDark.buttonColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  Text('${priceList[7].package}', style:TextStyle(
                                    color: appThemeDark.buttonColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  Text('${priceList[7].original}', style:TextStyle(
                                    color: appThemeDark.buttonColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough,
                                  ),),
                                  Text('${priceList[7].main}', style:TextStyle(
                                      color: appThemeDark.buttonColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500
                                  ),),
                                  Text('${priceList[7].discount}% Off', style:TextStyle(
                                    color: appThemeDark.buttonColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(indexmore !=7
                                            ?'${priceList[7].description.substring(0,49)} ':
                                        '${priceList[7].description}', style:TextStyle(

                                          color: appThemeDark.buttonColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,


                                        ),
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                        ),
                                        InkWell(
                                          child: Text(indexmore ==7 ?'less':'more', style:TextStyle(

                                            color: appThemeDark.buttonColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,


                                          ),
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                          ),
                                          onTap: (){
                                            if(indexmore == 7){
                                              setState(() {
                                                indexmore = -1;
                                              });
                                            }else {
                                              setState(() {
                                                indexmore = 7;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width: Config.xMargin(context, 100),
                                    margin: const EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: appThemeDark.buttonColor,
                                    ),

                                    child: FlatButton(
                                      child: Text("Subscribe Now", style:TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,


                                      )),
                                      onPressed: (){
                                        setState(() {
                                          amount = int.parse('${priceList[7].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
                                        });
                                        _handleCheckout(context, amount*100,priceList[7].package,priceList[7].month );
                                      },
                                    ),
                                  )

                                ],
                              )),

                            ),
                          ),
                        ],
                      )


                      // Container(
                      //   height: Config.yMargin(context, 40),
                      //
                      //   child: ListView(
                      //     // shrinkWrap: true,
                      //     scrollDirection: Axis.horizontal,
                      //     children: [
                      //
                      //
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: Config.yMargin(context, 1),),
              // Container(
              //   alignment: Alignment.center,
              //   color: appThemeDark.backgroundColor,
              //   width: Config.xMargin(context, 100),
              //   height: Config.yMargin(context, 44),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text('Jumbo Package', style: appThemeDark.textTheme.title,),
              //       SizedBox(height: Config.yMargin(context, 1),),
              //       Container(
              //         height: Config.yMargin(context, 40),
              //
              //         child: ListView(
              //           // shrinkWrap: true,
              //           scrollDirection: Axis.horizontal,
              //           children: [
              //             Container(
              //               height: Config.yMargin(context,40),
              //               width: Config.xMargin(context, 45),
              //               child: new Card(
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(10.0),
              //                 ),
              //                 child: Center(child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                   children: [
              //                     Text('${priceList[8].month}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 15,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Text('${priceList[8].package}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Text('${priceList[8].original}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.w500,
              //                       decoration: TextDecoration.lineThrough,
              //                     ),),
              //                     Text('${priceList[8].main}', style:TextStyle(
              //                         color: appThemeDark.buttonColor,
              //                         fontSize: 25,
              //                         fontWeight: FontWeight.w500
              //                     ),),
              //                     Text('${priceList[8].discount}% Off', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Container(
              //                       margin: const EdgeInsets.only(left: 10, right: 10),
              //                       child: Column(
              //                         crossAxisAlignment: CrossAxisAlignment.end,
              //                         children: [
              //                           Text(indexmore !=8
              //                               ?'${priceList[8].description.substring(0,49)} ':
              //                           '${priceList[8].description}', style:TextStyle(
              //
              //                             color: appThemeDark.buttonColor,
              //                             fontSize: 12,
              //                             fontWeight: FontWeight.w400,
              //
              //
              //                           ),
              //                             textAlign: TextAlign.center,
              //                             softWrap: true,
              //                           ),
              //                           InkWell(
              //                             child: Text(indexmore ==8 ?'less':'more', style:TextStyle(
              //
              //                               color: appThemeDark.buttonColor,
              //                               fontSize: 12,
              //                               fontWeight: FontWeight.w400,
              //
              //
              //                             ),
              //                               textAlign: TextAlign.center,
              //                               softWrap: true,
              //                             ),
              //                             onTap: (){
              //                               if(indexmore == 8){
              //                                 setState(() {
              //                                   indexmore = -1;
              //                                 });
              //                               }else {
              //                                 setState(() {
              //                                   indexmore = 8;
              //                                 });
              //                               }
              //                             },
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //
              //                     Container(
              //                       width: Config.xMargin(context, 100),
              //                       margin: const EdgeInsets.only(left: 10, right: 10),
              //                       decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.circular(10),
              //                         color: appThemeDark.buttonColor,
              //                       ),
              //
              //                       child: FlatButton(
              //                         child: Text("Subscribe Now", style:TextStyle(
              //                           color: Colors.white,
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w400,
              //
              //
              //                         )),
              //                         onPressed: (){
              //                           setState(() {
              //                             amount = int.parse('${priceList[8].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
              //                           });
              //                           _handleCheckout(context, amount*100);
              //                         },
              //                       ),
              //                     )
              //
              //                   ],
              //                 )),
              //
              //               ),
              //             ),
              //             Container(
              //               height: Config.yMargin(context,40),
              //               width: Config.xMargin(context, 45),
              //               child: new Card(
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(10.0),
              //                 ),
              //                 child: Center(child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                   children: [
              //                     Text('${priceList[9].month}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 15,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Text('${priceList[9].package}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Text('${priceList[9].original}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.w500,
              //                       decoration: TextDecoration.lineThrough,
              //                     ),),
              //                     Text('${priceList[9].main}', style:TextStyle(
              //                         color: appThemeDark.buttonColor,
              //                         fontSize: 25,
              //                         fontWeight: FontWeight.w500
              //                     ),),
              //                     Text('${priceList[9].discount}% Off', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Container(
              //                       margin: const EdgeInsets.only(left: 10, right: 10),
              //                       child: Column(
              //                         crossAxisAlignment: CrossAxisAlignment.end,
              //                         children: [
              //                           Text(indexmore !=9
              //                               ?'${priceList[9].description.substring(0,49)} ':
              //                           '${priceList[9].description}', style:TextStyle(
              //
              //                             color: appThemeDark.buttonColor,
              //                             fontSize: 12,
              //                             fontWeight: FontWeight.w400,
              //
              //
              //                           ),
              //                             textAlign: TextAlign.center,
              //                             softWrap: true,
              //                           ),
              //                           InkWell(
              //                             child: Text(indexmore ==9 ?'less':'more', style:TextStyle(
              //
              //                               color: appThemeDark.buttonColor,
              //                               fontSize: 12,
              //                               fontWeight: FontWeight.w400,
              //
              //
              //                             ),
              //                               textAlign: TextAlign.center,
              //                               softWrap: true,
              //                             ),
              //                             onTap: (){
              //                               if(indexmore == 9){
              //                                 setState(() {
              //                                   indexmore = -1;
              //                                 });
              //                               }else {
              //                                 setState(() {
              //                                   indexmore = 9;
              //                                 });
              //                               }
              //                             },
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //
              //                     Container(
              //                       width: Config.xMargin(context, 100),
              //                       margin: const EdgeInsets.only(left: 10, right: 10),
              //                       decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.circular(10),
              //                         color: appThemeDark.buttonColor,
              //                       ),
              //
              //                       child: FlatButton(
              //                         child: Text("Subscribe Now", style:TextStyle(
              //                           color: Colors.white,
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w400,
              //
              //
              //                         )),
              //                         onPressed: (){
              //                           setState(() {
              //                             amount = int.parse('${priceList[9].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
              //                           });
              //                           _handleCheckout(context, amount*100);
              //                         },
              //                       ),
              //                     )
              //
              //                   ],
              //                 )),
              //
              //               ),
              //             ),
              //             Container(
              //               height: Config.yMargin(context,40),
              //               width: Config.xMargin(context, 45),
              //               child: new Card(
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(10.0),
              //                 ),
              //                 child: Center(child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                   children: [
              //                     Text('${priceList[10].month}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 15,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Text('${priceList[10].package}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Text('${priceList[10].original}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.w500,
              //                       decoration: TextDecoration.lineThrough,
              //                     ),),
              //                     Text('${priceList[10].main}', style:TextStyle(
              //                         color: appThemeDark.buttonColor,
              //                         fontSize: 25,
              //                         fontWeight: FontWeight.w500
              //                     ),),
              //                     Text('${priceList[10].discount}% Off', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Container(
              //                         margin: const EdgeInsets.only(left: 10, right: 10),
              //                       child: Column(
              //                         crossAxisAlignment: CrossAxisAlignment.end,
              //                         children: [
              //                           Text(indexmore !=10
              //                               ?'${priceList[10].description.substring(0,49)} ':
              //                           '${priceList[10].description}', style:TextStyle(
              //
              //                             color: appThemeDark.buttonColor,
              //                             fontSize: 12,
              //                             fontWeight: FontWeight.w400,
              //
              //
              //                           ),
              //                             textAlign: TextAlign.center,
              //                             softWrap: true,
              //                           ),
              //                           InkWell(
              //                             child: Text(indexmore ==10 ?'less':'more', style:TextStyle(
              //
              //                               color: appThemeDark.buttonColor,
              //                               fontSize: 12,
              //                               fontWeight: FontWeight.w400,
              //
              //
              //                             ),
              //                               textAlign: TextAlign.center,
              //                               softWrap: true,
              //                             ),
              //                             onTap: (){
              //                               if(indexmore == 10){
              //                                 setState(() {
              //                                   indexmore = -1;
              //                                 });
              //                               }else {
              //                                 setState(() {
              //                                   indexmore = 10;
              //                                 });
              //                               }
              //                             },
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //
              //                     Container(
              //                       width: Config.xMargin(context, 100),
              //                       margin: const EdgeInsets.only(left: 10, right: 10),
              //                       decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.circular(10),
              //                         color: appThemeDark.buttonColor,
              //                       ),
              //
              //                       child: FlatButton(
              //                         child: Text("Subscribe Now", style:TextStyle(
              //                           color: Colors.white,
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w400,
              //
              //
              //                         )),
              //                         onPressed: (){
              //                           setState(() {
              //                             amount = int.parse('${priceList[10].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
              //                           });
              //                           _handleCheckout(context, amount*100);
              //                         },
              //                       ),
              //                     )
              //
              //                   ],
              //                 )),
              //
              //               ),
              //             ),
              //             Container(
              //               height: Config.yMargin(context,40),
              //               width: Config.xMargin(context, 45),
              //               child: new Card(
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(10.0),
              //                 ),
              //                 child: Center(child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                   children: [
              //                     Text('${priceList[11].month}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 15,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Text('${priceList[11].package}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Text('${priceList[11].original}', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.w500,
              //                       decoration: TextDecoration.lineThrough,
              //                     ),),
              //                     Text('${priceList[11].main}', style:TextStyle(
              //                         color: appThemeDark.buttonColor,
              //                         fontSize: 25,
              //                         fontWeight: FontWeight.w500
              //                     ),),
              //                     Text('${priceList[11].discount}% Off', style:TextStyle(
              //                       color: appThemeDark.buttonColor,
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                     ),),
              //                     Container(
              //                         margin: const EdgeInsets.only(left: 10, right: 10),
              //                       child: Column(
              //                         crossAxisAlignment: CrossAxisAlignment.end,
              //                         children: [
              //                           Text(indexmore !=11
              //                               ?'${priceList[11].description.substring(0,49)} ':
              //                           '${priceList[11].description}', style:TextStyle(
              //
              //                             color: appThemeDark.buttonColor,
              //                             fontSize: 12,
              //                             fontWeight: FontWeight.w400,
              //
              //
              //                           ),
              //                             textAlign: TextAlign.center,
              //                             softWrap: true,
              //                           ),
              //                           InkWell(
              //                             child: Text(indexmore ==11 ?'less':'more', style:TextStyle(
              //
              //                               color: appThemeDark.buttonColor,
              //                               fontSize: 12,
              //                               fontWeight: FontWeight.w400,
              //
              //
              //                             ),
              //                               textAlign: TextAlign.center,
              //                               softWrap: true,
              //                             ),
              //                             onTap: (){
              //                               if(indexmore == 11){
              //                                 setState(() {
              //                                   indexmore = -1;
              //                                 });
              //                               }else {
              //                                 setState(() {
              //                                   indexmore = 11;
              //                                 });
              //                               }
              //                             },
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //
              //                     Container(
              //                       width: Config.xMargin(context, 100),
              //                       margin: const EdgeInsets.only(left: 10, right: 10),
              //                       decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.circular(10),
              //                         color: appThemeDark.buttonColor,
              //                       ),
              //
              //                       child: FlatButton(
              //                         child: Text("Subscribe Now", style:TextStyle(
              //                           color: Colors.white,
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w400,
              //
              //
              //                         )),
              //                         onPressed: (){
              //                           setState(() {
              //                             amount = int.parse('${priceList[11].main.replaceAll(new RegExp(r'[^\w\s]+'),'')}');
              //                           });
              //                           _handleCheckout(context, amount*100);
              //                         },
              //                       ),
              //                     )
              //
              //                   ],
              //                 )),
              //
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: Config.yMargin(context, 1),),

            ],
          ),
        ),
      )
      :  Center(
        child: CircularProgressIndicator(

        valueColor: new AlwaysStoppedAnimation<Color>(Colors.black54),
    ),
      ) ,
    );
  }

  void _handleRadioValueChanged(int value) =>
      setState(() => _radioValue = value);

  _handleCheckout(BuildContext context, int price, String plan, String duration) async {
    setState(() => _inProgress = true);
    Charge charge = Charge()
      // ..amount = price // In base currency
      ..amount = 100
      ..email = "customer@email.com";
  //    ..card = _getCardFromUI();

    if (!_isLocal) {
      // var accessCode = await _fetchAccessCodeFrmServer(_getReference());
      // charge.accessCode = accessCode;
    } else {
      charge.reference = _getReference();
    }

    try {

      CheckoutResponse response = await PaystackPlugin.checkout(
        context,
        method: _method,
        charge: charge,
        fullscreen: false,
        logo: Container(
          height: Config.yMargin(context, 6),
            width: Config.xMargin(context, 10),
          child: Image.asset('images/biology.png', fit: BoxFit.cover,),

        )
      );
      print('Response = $response');
      setState(() => _inProgress = false);
      if (response.status) {

        var par = {'uname':'$uname', 'plan':'$plan',
          'duration':'$duration','status':'${response.status}','amt_paid':'$amount',
          'msg':'${response.message}','method':'${response.method}','verify':'${response.verify}',
          'cardType':'${response.card.type}','last4digits':'${response.card.last4Digits}',
          'expiryMonth':'${response.card.expiryMonth}',
          'expiryYear':'${response.card.expiryYear}','CVC':'${response.card.cvc}'};
        var url ='https://dreezetv.com/store.php';
        var resp = await http.post(url, body: par);
        if(resp.statusCode ==200){
          print(par.toString());
          print(resp.body);
        }
        // response.
        // _verifyOnServer(reference);
        return;
      }
      // var par = {'uname':'$uname', 'plan':'$plan',
      //   'duration':'$duration','status':'${response.status}','amt_paid':'$price',
      //   'msg':'${response.message}','method':'${response.method}','verify':'${response.verify}',
      //   'cardType':'${response.card.type}','last4digits':'${response.card.last4Digits}',
      //   'expiryMonth':'${response.card.expiryMonth}',
      //   'expiryYear':'${response.card.expiryYear}','CVC':'${response.card.cvc}'};
      // var url ='https://kindergaten.com/store.php';
      // var resp = await http.post(url, body: par);
      // if(resp.statusCode ==200){
      //   print(resp.body);
      // }
      _updateStatus(response.reference, '$response');
    } catch (e) {
      setState(() => _inProgress = false);
   //   _showMessage("Check console for error");
      rethrow;
    }
  }

  // _startAfreshCharge() async {
  //   _formKey.currentState.save();
  //
  //   Charge charge = Charge();
  //   charge.card = _getCardFromUI();
  //
  //   setState(() => _inProgress = true);
  //
  //   if (_isLocal) {
  //     // Set transaction params directly in app (note that these params
  //     // are only used if an access_code is not set. In debug mode,
  //     // setting them after setting an access code would throw an exception
  //
  //     charge
  //     ..locale='images/dreezecircle.png'
  //       ..amount = 10000 // In base currency
  //       ..email = 'customer@email.com'
  //       ..reference = _getReference()
  //       ..putCustomField('Charged From', 'Flutter SDK');
  //     _chargeCard(charge);
  //   } else {
  //     // Perform transaction/initialize on Paystack server to get an access code
  //     // documentation: https://developers.paystack.co/reference#initialize-a-transaction
  //     // charge.accessCode = await _fetchAccessCodeFrmServer(_getReference());
  //     // _chargeCard(charge);
  //   }
  // }

  // _chargeCard(Charge charge) async {
  //   final response = await PaystackPlugin.chargeCard(context, charge: charge);
  //
  //   final reference = response.reference;
  //
  //   // Checking if the transaction is successful
  //
  //
  //   // The transaction failed. Checking if we should verify the transaction
  //   if (response.verify) {
  //   //  _verifyOnServer(reference);
  //   } else {
  //     setState(() => _inProgress = false);
  //     _updateStatus(reference, response.message);
  //   }
  // }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }
  // Future<String> _fetchAccessCodeFrmServer(String reference) async {
  //   String url = '$backendUrl/new-access-code';
  //   String accessCode;
  //   try {
  //     print("Access code url = $url");
  //     http.Response response = await http.get(url);
  //     accessCode = response.body;
  //     print('Response for access code = $accessCode');
  //   } catch (e) {
  //     setState(() => _inProgress = false);
  //     _updateStatus(
  //         reference,
  //         'There was a problem getting a new access code form'
  //             ' the backend: $e');
  //   }
  //
  //   return accessCode;
  // }

  // void _verifyOnServer(String reference) async {
  //   _updateStatus(reference, 'Verifying...');
  //   String url = '$backendUrl/verify/$reference';
  //   try {
  //     http.Response response = await http.get(url);
  //     var body = response.body;
  //     _updateStatus(reference, body);
  //   } catch (e) {
  //     _updateStatus(
  //         reference,
  //         'There was a problem verifying %s on the backend: '
  //             '$reference $e');
  //   }
  //   setState(() => _inProgress = false);
  // }

  _updateStatus(String reference, String message) {
    _showMessage('Reference: $reference \n\ Response: $message',
        const Duration(seconds: 7));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
    ));
  }

  bool get _isLocal => _radioValue == 0;
}

var banks = ['Selectable', 'Bank', 'Card'];

CheckoutMethod _parseStringToMethod(String string) {
  CheckoutMethod method = CheckoutMethod.selectable;
  switch (string) {
    case 'Bank':
      method = CheckoutMethod.bank;
      break;
    case 'Card':
      method = CheckoutMethod.card;
      break;
  }
  return method;
}

class MyLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Text(
        "CO",
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

const Color green = const Color(0xFF3db76d);
const Color lightBlue = const Color(0xFF34a5db);
const Color navyBlue = const Color(0xFF031b33);



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