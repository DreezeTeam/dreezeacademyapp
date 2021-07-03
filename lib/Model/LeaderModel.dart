import 'package:flutter/cupertino.dart';

class LeaderBoardModel with ChangeNotifier {
  String id;
  String name;
  String percentage;
  String state;
  String grouptitle;
  String link;
  LeaderBoardModel(
      {this.id,
      this.name,
      this.percentage,
      this.state,
      this.grouptitle,
      this.link});
  factory LeaderBoardModel.fromJson(Map<String, dynamic> json) {
    var attrr = LeaderBoardModel(
      id: json['id'] as String,
      name: json['name'] as String,
      percentage: json['percentage'] as String,
      state: json['logo'] as String,
      grouptitle: json['group_title'] as String,
      link: json['link'] as String,

    );
    return attrr;
  }
}
