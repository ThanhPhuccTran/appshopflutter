
import 'package:flutter/material.dart';
class KeyboardUtil{

  //kiểm tra và ẩn bàn phím nếu có bất kì đối tượng nào hiện đang focus
  static void hideKeyboard(BuildContext context){
    FocusScopeNode currentFocus = FocusScope.of(context);

    if(!currentFocus.hasPrimaryFocus){
      currentFocus.unfocus();
    }
  }
}