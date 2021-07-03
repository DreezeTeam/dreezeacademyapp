import 'package:kindergaten/Model/couresModel.dart';

import 'package:flutter/material.dart';
import 'package:kindergaten/Size_Config/Config.dart';
import 'package:kindergaten/apptheme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kindergaten/screen/playScreen.dart';

class MyCourses extends StatefulWidget {
  static final routeName = '/course';
  @override
  _MyCoursesState createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  String _courses = 'All Courses';
  String dropdownValue = 'SS1';
  String filterValue = "";
  Stream<List<TopicModel>> stream;

  Future<List<TopicModel>> getData() async {
    //print("Imhere");
    List<TopicModel> list = [];
    var map = {"theme": "Secondary"};
    // var url = 'https://www.dreezeacademy.com/topics_app.php?theme=Secondary';
    var uri = Uri.https('www.dreezeacademy.com', '/topics_app.php', map);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      try {
        var parsedJson = jsonDecode(response.body) as Map<String, dynamic>;
        parsedJson.forEach((key, value) {
          var second = value as Map<String, dynamic>;
          TopicModel _json = TopicModel.fromJson(second);
          list.add(_json);
        });
        return list;
      } catch (Exception) {
        print(Exception.toString());
        return list;
      }
    } else {
      return list;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    stream = new Stream.fromFuture(getData());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        height: Config.yMargin(context, 100),
         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: Config.yMargin(context, 8),
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(3.0),
                  child: DropdownButton<String>(
                    value: _courses,
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 20,
                    elevation: 16,
                    style: TextStyle(
                        //  color: Colors.deepPurple
                        ),
                    underline: Container(height: 2, color: Colors.transparent),
                    onChanged: (String newValue) {
                      setState(() {
                        _courses = newValue;
                      });
                    },
                    items: <String>[
                      'All Courses',
                      'Completed',
                      'Started',
                      'Favourite'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: appThemeDark.textTheme.title,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Row(
                  children: [
                    IconButton(icon: Icon(Icons.search), onPressed: () {}),
                    PopupMenuButton<String>(
                      itemBuilder: (context) => [
                        PopupMenuItem(value: "maths", child: Text("Maths")),
                        PopupMenuItem(value: "physics", child: Text("Physics")),
                        PopupMenuItem(
                            value: "chemistry", child: Text("Chemistry")),
                        PopupMenuItem(value: "gov", child: Text("Gov")),
                        PopupMenuItem(value: "econs", child: Text("Economics")),
                      ],
                      icon: Icon(Icons.filter_list),
                      initialValue: "maths",
                      onCanceled: () {},
                      onSelected: (value) {
                        setState(() {
                          filterValue = value;
                        });
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(3.0),
                      margin: const EdgeInsets.only(left: 4),
                      height: Config.yMargin(context, 4),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12)),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.keyboard_arrow_down),
                        iconSize: 20,
                        elevation: 16,
                        style: TextStyle(
                            //  color: Colors.deepPurple
                            ),
                        underline:
                            Container(height: 2, color: Colors.transparent),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['SS1', 'SS2', 'SS3']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
           StreamBuilder(
               stream: stream,
               builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                 if (!snapshot.hasData) {
                   return Expanded(
                     child: Center(
                         child: CircularProgressIndicator(
                           valueColor: new AlwaysStoppedAnimation<Color>(
                               appThemeDark.buttonColor),
                         )),
                   );
                 }
                 List<TopicModel> topics = snapshot.data;
                 return Expanded(
                   child: ListView.builder(
                       itemCount: topics.length,
                       shrinkWrap: true,
                       itemBuilder: (ctx, index) {
                         return InkWell(
                           child: Padding(
                             padding: const EdgeInsets.only(bottom: 30),
                             child: Container(
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(5)),
                               height: 50,
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Container(
                                     height: 36,
                                     child: Image.asset('images/biology.png')
                                   ),
                                   SizedBox(
                                     width: 10,
                                   ),
                                   Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     crossAxisAlignment:
                                     CrossAxisAlignment.start,
                                     children: [
                                       Text(
                                         "${topics[index].topic}",
                                         style: appThemeDark.textTheme.title,
                                       ),
                                       Text("Haruna"),
                                       Text("30%"),
                                     ],
                                   )
                                 ],
                               ),
                             ),
                           ),
                           onTap: () {
                             Navigator.of(context).pushNamed(
                                 PlayScreen.routeName,
                                 arguments: {"topic": topics[index].topic});
                           },
                         );
                       }),
                 );
               }),
        ]),
      )),
    );
  }

}
