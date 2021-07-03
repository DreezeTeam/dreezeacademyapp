import 'package:kindergaten/Model/LeaderModel.dart';
import 'package:kindergaten/Size_Config/Config.dart';
import 'package:kindergaten/apptheme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Model/LeaderModel.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  String dropdownValue = 'SS1';
  int _selection = 1;
  List<LeaderBoardModel> _leaderlist = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemeDark.backgroundColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          height: Config.yMargin(context, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: Config.yMargin(context, 8),
                // padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Statistics",
                      style: appThemeDark.textTheme.title,
                    ),
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {

                            }
                            ),

                        Container(
                          padding: const EdgeInsets.all(3.0),
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
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  height: Config.yMargin(context, 18),
                  width: Config.xMargin(context, 60),
                  child: Center(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 110,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "1",
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blue, width: 2),
                                    borderRadius: BorderRadius.circular(90),
                                  ),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        AssetImage('images/biology.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 35,
                          child: Row(
                            children: [
                              Text(
                                "2",
                                style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    AssetImage('images/chemistry.png'),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 25,
                          right: 25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    AssetImage('images/physics.png'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "3",
                                style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //    height: Config.yMargin(context, 90),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: Config.yMargin(context, 4),
                              child: FlatButton(
                                child: Text(
                                  "Local",
                                  style: appThemeDark.textTheme.title,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selection = 1;
                                  });
                                },
                              ),
                            ),
                            Container(
                              height: 4,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: _selection == 1
                                      ? Colors.lightBlue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(15)),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: Config.yMargin(context, 4),
                              child: FlatButton(
                                child: Text(
                                  "International",
                                  style: appThemeDark.textTheme.title,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selection = 2;
                                  });
                                },
                              ),
                            ),
                            Container(
                              height: 4,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: _selection == 2
                                      ? Colors.lightBlue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(15)),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: Config.yMargin(context, 4),
                              child: FlatButton(
                                child: Text(
                                  "State",
                                  style: appThemeDark.textTheme.title,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selection = 3;
                                  });
                                },
                              ),
                            ),
                            Container(
                              height: 4,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: _selection == 3
                                      ? Colors.lightBlue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(15)),
                            )
                          ],
                        )
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: 10,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (ctx, index) {
                            return Container(
                              //  height: Config.yMargin(context, 3.5),
                              child: ListTile(
                                leading: Text(
                                  (index + 1).toString(),
                                  style: appThemeDark.textTheme.title,
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Name",
                                      style: appThemeDark.textTheme.title,
                                    ),
                                    Text("84%",
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54)),
                                  ],
                                ),
                                trailing: Text(
                                  "24 Attempted",
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

