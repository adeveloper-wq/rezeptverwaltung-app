import 'dart:core';

String convertErrorMessage(var value) {
  String _msg = "";
  if(value.runtimeType is String){
    _msg = value;
  }else if (value is Map){
    var _temp = value.values.toList().first;
    if(_temp is List){
      _msg = _temp[0];
    }else{
      _msg = _temp;
    }
  }else{
    _msg = value.toString();
  }

  return _msg;
}