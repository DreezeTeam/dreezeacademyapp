import 'package:flutter/cupertino.dart';

class TopicModel{
  String level;
  String topic;


  TopicModel({this.level, this.topic});

  //TakeTestProvider({this.question, this.chA,this.chB, this.chC,this.chD, this.choice, this.hint});
  factory  TopicModel.fromJson(Map<String, dynamic> json){
    var topic =  TopicModel(
     level: json['0'] as String,
      topic: json['1'] as String,

    );
    return topic;
  }
}