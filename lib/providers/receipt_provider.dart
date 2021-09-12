import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rezeptverwaltung/util/app_url.dart';
import 'package:rezeptverwaltung/util/message_convert.dart';
import 'package:rezeptverwaltung/util/user_preferences.dart';


enum GetReceiptsLoadingStatus {
  NotLoading,
  Loading
}

class ReceiptProvider with ChangeNotifier {

  GetReceiptsLoadingStatus _state = GetReceiptsLoadingStatus.NotLoading;

  GetReceiptsLoadingStatus get state => _state;

  Future<Map<String,dynamic>> getReceipts(int groupId) async {
    _state = GetReceiptsLoadingStatus.Loading;
    Map<String, dynamic> result;

    String token = await UserPreferences().getToken();

    if(token != null){
      final queryParameters = {
        'G_ID': groupId.toString()
      };

      Response response = await get(
          Uri.https(AppUrl.baseURL, AppUrl.getReceipts, queryParameters),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + token
          }
      );

      if (response.statusCode == 200){
        _state = GetReceiptsLoadingStatus.NotLoading;
        notifyListeners();
        result = {'status': true, 'message': 'Successful', 'data': json.decode(response.body)};
      }else{
        _state = GetReceiptsLoadingStatus.NotLoading;
        notifyListeners();
        result = {
          'status': false,
          'message': convertErrorMessage(json.decode(response.body))
        };
      }
    }else{
      _state = GetReceiptsLoadingStatus.NotLoading;
      notifyListeners();
      result = {
        'status': false,
        'message': 'Kein Token verfügbar!'
      };
    }

    return result;
  }
}