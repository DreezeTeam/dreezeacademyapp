import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class VideosModelProvider with ChangeNotifier {
  String id;
  String theme;
  String videoTitle;
  String videoSource;
  String videoName;
  String videoAbout;
  String videoNote;
  var percentage;
  int likes;
  int unlikes;
  bool bookMark;

  VideosModelProvider({this.id,this.theme, this.videoTitle, this.videoSource, this.videoName, this.videoAbout,this.videoNote, this.percentage, this.likes,
  this.unlikes,this.bookMark});

  //TakeTestProvider({this.question, this.chA,this.chB, this.chC,this.chD, this.choice, this.hint});
  factory  VideosModelProvider.fromJson(Map<String, dynamic> json){
    var classvideo =  VideosModelProvider(
      theme: json['question'] as String,
      videoTitle: json['videoTitle'] as String,
      videoSource: json['videoSource'] as String,
      videoName: json['videoName'] as String,
      videoAbout: json['videoAbout'] as String,
      videoNote: json['videoNote'] as String,
      likes: json['likes']??0,
      unlikes: json['unlikes']??0,
      bookMark: json['bookmark']??false,
      percentage: json['percentage']??0,

    );
    return classvideo;
  }


  void likeMethod(){
   likes =likes+1;
    notifyListeners();
  }
  void unlikeMethod(){
    unlikes = unlikes+1;
    notifyListeners();


  }

  void bookMarkMethod(){
    print("boo");
    bookMark = !bookMark;
    notifyListeners();
  }

  Future<List<VideosModelProvider>> getData(String topic) async {
    List<VideosModelProvider> list = [];
    var map = {"videoT": "fractions"};
    var uri = Uri.https('www.dreezeacademy.com', '/videos_app.php', map);


    var response = await http.get(uri);
    if (response.statusCode == 200) {
      try {
        var parsedJson = jsonDecode(response.body) as Map<String, dynamic>;

        parsedJson.forEach((key, value) {
          var second = value as Map<String, dynamic>;
          VideosModelProvider _json = VideosModelProvider.fromJson(second);
          list.add(_json);
        });

       //  setState(() {
       //    topics = list;
       // //   _currentPlaying = list[0];
       //  });
    //    _initializeAndPlay(list);
        // print("${_currentPlaying.videoSource.replaceAll(' ', "%20")}");
        // player.setDataSource("https://www.dreezeacademy.com${_currentPlaying.videoSource.replaceAll(' ', "%20")}", autoPlay: true,);
        return list;
      } catch (Exception) {
        print(Exception.toString());
        return list;
      }
    } else {
      return list;
    }
  }

  void updatePercentage(String u, var position , var duration) async{
     // percentage = position;
     print(position);
     print(duration);
      percentage = (position/duration)*100;

     notifyListeners();
     print("...........................position..........................");
     print("...........................duration..........................");
     print(".................$percentage........................");
     var map = {"u":"$u", "topic":"$videoTitle", "class":"nursery",
       "percent":"$percentage", "position":"$position", "duration":"$duration"};
     print(map['u']);
     print(map['topic']);
     print(map['class']);
     print(map['percent']);
     print(map['position']);
     print(map['duration']);
     var uri = Uri.https('www.dreezeacademy.com', '/sessions.php');


     var response = await http.post(uri,body: map);
     if (response.statusCode == 200) {
       print("................response...........");
       print(response.body);

     } else {
      print(response.statusCode);
     }


  }


}