import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rezeptverwaltung/domains/user.dart';
import 'package:rezeptverwaltung/providers/user_provider.dart';
import 'package:rezeptverwaltung/util/app_url.dart';
import 'package:rezeptverwaltung/util/user_preferences.dart';


enum GroupLoadingStatus {
  NotLoading,
  Loading
}

class GroupProvider with ChangeNotifier {

  GroupLoadingStatus _state = GroupLoadingStatus.NotLoading;

  GroupLoadingStatus get state => _state;

  Future<Map<String,dynamic>> getGroup(String name) async {
    _state = GroupLoadingStatus.Loading;
    Map<String, dynamic> result;

    String token = await UserPreferences().getToken();

    if(token != null){
      Response response = await get(
          Uri.https(AppUrl.baseURL, AppUrl.getGroup + name.replaceAll(" ", "+"), {}),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + token
          }
      );
      if (response.statusCode == 200){
        _state = GroupLoadingStatus.NotLoading;
        notifyListeners();
        result = {'status': true, 'message': 'Successful', 'data': json.decode(response.body)};
      }else if(response.statusCode == 401){
        _state = GroupLoadingStatus.NotLoading;
        notifyListeners();
        result = {
          'status': false,
          'message': 'Nicht authorisiert!'
        };
      }else if(response.statusCode == 404){
        _state = GroupLoadingStatus.NotLoading;
        notifyListeners();
        result = {
          'status': false,
          'message': 'Gruppe existiert nicht!'
        };
      }else{
        _state = GroupLoadingStatus.NotLoading;
        notifyListeners();
        result = {
          'status': false,
          'message': 'Serverfehler'
        };
      }
    }else{
      _state = GroupLoadingStatus.NotLoading;
      notifyListeners();
      result = {
        'status': false,
        'message': 'Kein Token verfügbar!'
      };
    }

    return result;
  }
}