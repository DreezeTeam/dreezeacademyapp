

import 'package:flutter/widgets.dart';

class HomeNotifier with ChangeNotifier{
  int x =0;

  void changeview(int position){
    x=position;

    notifyListeners();

  }

}