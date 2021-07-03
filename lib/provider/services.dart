import 'dart:convert';
import 'package:kindergaten/Model/attributeModel.dart';
import 'package:kindergaten/Model/model.dart';
import '../Model/pricemodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class FetchServices {
 static List<ListModel> classes = [];


  static Future<List<dynamic>> fetchclass() async {
    List<ListModel> list = [];
    print("fetch class");

    var uri = Uri.https('www.dreezetv.com', '/movies.php');
    var res =
    await http.get(uri, headers: {'Content-Type': 'application/json'});

    if (res.statusCode == 200) {

      String stringre = res.body.toString();
      print(stringre);
      var parsedJson = jsonDecode(stringre) as Map<String, dynamic>;

      parsedJson.forEach((key, value) {


        var second = value['1'] as Map<String, dynamic>;

        List<AttributeModel>  subhead = [];
        second.forEach((key, value) {

        AttributeModel json =  AttributeModel.fromJson(value);
        subhead.add(json);
        });




        list.add(ListModel(Headname: value['0'], lenght: subhead.length, subhead: subhead));


      });

      classes = list;

      return list;
    } else {
      return list;
    }
  }


  static Future<List<dynamic>> fetchprices() async {
    List<PriceModel> list = [];


    var uri = Uri.https('www.dreezetv.com', '/store.php');
    var res =
    await http.get(uri, headers: {'Content-Type': 'application/json'});

    if (res.statusCode == 200) {

      String stringre = res.body.toString();
      print(stringre);
      var parsedJson = jsonDecode(stringre) as Map<String, dynamic>;

      parsedJson.forEach((key, value) {

        var map = PriceModel.fromJson(value);


       list.add(map);

      });



      return list;
    } else {
      return list;
    }
  }

  static List<ListModel>  returnfetch(){

    if(classes != null){
      return classes;
    }
    fetchclass().then((value) {
      classes = value;
      return classes;
    });


  }
}