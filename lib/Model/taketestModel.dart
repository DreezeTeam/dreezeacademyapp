import 'package:flutter/cupertino.dart';

class TakeTestProvider{
  String question;
  String chA;
  String chB;
  String chC;
  String chD;
  String choice;
  String hint;
  String selected;

  TakeTestProvider({this.question, this.chA, this.chB, this.chC, this.chD,this.choice, this.hint,this.selected});

  //TakeTestProvider({this.question, this.chA,this.chB, this.chC,this.chD, this.choice, this.hint});
  factory  TakeTestProvider.fromJson(Map<String, dynamic> json){
    var testp =  TakeTestProvider(
      question: json['question'] as String,
      chA: json['chA'] as String,
      chB: json['chB'] as String,
      chC: json['chC'] as String,
      chD: json['chD'] as String,
      choice: json['choice'] as String,
      hint: json['hint'] as String,
    );
    return testp;
  }
}