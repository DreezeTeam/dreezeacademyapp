

import '../Model/attributeModel.dart';
import '../Model/subheadmodel.dart';
// import 'package:m3u/m3u.dart';

class ListModel {
  String Headname;
  int lenght;
  List<AttributeModel> subhead;
  

  ListModel({this.Headname,this.lenght, this.subhead});

  // factory   ListModel.fromJson(Map<String, dynamic> json){
  //   var member =  ListModel(
  //      Headname: json['0'] as String,
  //      lenght: json['1'] as int,
  //      subhead: json['2'] as List,
  //
  //
  //   );
  //   return member;
  // }
}