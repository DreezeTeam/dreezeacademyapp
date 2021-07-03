import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class JoinUsProvider {
// static const String _link = 'https://www.dreezeacademy.com/signup_app.php';
  //  var map = {"videoT": "fractions"};
  static var _link = Uri.https('www.dreezeacademy.com', '/signup_app.php');
  // static const String _login1 = 'https://www.dreezeacademy.com/login.php';

  // static const String _login1 = 'https://www.dreezeacademy.com/login_app.php';
  static var _login1 = Uri.https('www.dreezeacademy.com', '/login_app.php');
  // static const String _topic =
  //     'https://www.dreezeacademy.com/topics_app.php?theme=Secondary';
  //
  var map = {"theme": "Secondary"};

  static var _topic = Uri.https(
      'www.dreezeacademy.com', '/topics_app.php', {"theme": "Secondary"});

  static Future<String> signupmethod(
      String u, String s, String e, String p) async {
    try {
      var map = Map<String, dynamic>();
      map['u'] = u;
      map['e'] = e;
      map['p'] = p;
      map['s'] = s;

      var response = await http.post(_link, body: map);
      if (response.statusCode == 200) {
        print(".......respnse body .......");
        return response.body;
      } else {
        print(".......not responding........");
        return "not responding";
      }
    } catch (e) {
      return e;
    }
  }

  static Future<String> CompleteSetup(String u, String e, String p, String f,
      String l, String ph, String c, String g, DateTime d) async {
    try {
      var map = Map<String, dynamic>();

      map['f'] = f;
      map['l'] = l;
      map['g'] = g;
      map['ph'] = ph;
      map['b'] = "${d.toLocal()}".split(' ')[0];
      map['c'] = c;
      map['user'] = u;
      map['email'] = e;

      var completeresponse = await http.post(_link, body: map);

      if (completeresponse.statusCode == 200) {
        return completeresponse.body;
      } else {
        print(".....................no...............");
        return "nnn";
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> Login(String u, String p) async {
    try {
      var map = Map<String, dynamic>();
      map['e'] = u;
      map['p'] = p;
      var response = await http.post(_login1, body: map);

      if (response.statusCode == 200) {
        print("..........comunicating.............");
        return response.body;
      } else {
        print(response.body);
        //print(response.st);
        return 'No network';
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> fetchTopic() async {
    try {
      var map = Map<String, dynamic>();
      // map['e'] = subject;
      // map['p'] = p;
      var response = await http.get(_topic);

      if (response.statusCode == 200) {
        print(response.body);
        return response.body.toString();
      } else {
        print(response.body);
        //print(response.st);
        return 'No network';
      }
    } catch (e) {
      return e.toString();
    }
  }
}
