import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rezeptverwaltung/domains/user.dart';
import 'package:rezeptverwaltung/providers/user_provider.dart';
import 'package:rezeptverwaltung/util/app_url.dart';
import 'package:rezeptverwaltung/util/message_convert.dart';
import 'package:rezeptverwaltung/util/user_preferences.dart';


enum GroupLoadingStatus {
  NotLoading,
  Loading
}

enum GroupJoiningLoadingStatus{
  NotLoading,
  Loading
}

enum GroupsLoadingStatus{
  NotLoading,
  Loading
}

class GroupProvider with ChangeNotifier {

  GroupLoadingStatus _state = GroupLoadingStatus.NotLoading;
  GroupJoiningLoadingStatus _stateJoining = GroupJoiningLoadingStatus.NotLoading;
  GroupsLoadingStatus _stateGroupsLoading = GroupsLoadingStatus.NotLoading;

  GroupLoadingStatus get state => _state;
  GroupJoiningLoadingStatus get stateJoining => _stateJoining;

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
      }else{
        _state = GroupLoadingStatus.NotLoading;
        notifyListeners();
        result = {
          'status': false,
          'message': convertErrorMessage(json.decode(response.body))
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

  Future<Map<String,dynamic>> joinGroup(String password, int gId) async {
    _stateJoining = GroupJoiningLoadingStatus.Loading;
    Map<String, dynamic> result;
    print("------------------------------------------------------------------------------------------------");
    print(password);
    final queryParameters = {
      'password': password,
      'G_ID': gId.toString()
    };

    String token = await UserPreferences().getToken();

    if(token != null){
      Response response = await post(
          Uri.https(AppUrl.baseURL, AppUrl.joinGroup, queryParameters),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + token
          }
      );
      if (response.statusCode == 200){
        _stateJoining = GroupJoiningLoadingStatus.NotLoading;
        notifyListeners();
        result = {'status': true, 'message': 'Erfolgreich beigetreten!'};
      }else{
        _stateJoining = GroupJoiningLoadingStatus.NotLoading;
        notifyListeners();
        result = {
          'status': false,
          'message': convertErrorMessage(json.decode(response.body))
        };
      }
    }else{
      _stateJoining = GroupJoiningLoadingStatus.NotLoading;
      notifyListeners();
      result = {
        'status': false,
        'message': 'Kein Token verfügbar!'
      };
    }

    return result;
  }

  Future<Map<String,dynamic>> getGroups() async {
    _stateGroupsLoading = GroupsLoadingStatus.Loading;
    Map<String, dynamic> result;

    String token = await UserPreferences().getToken();

    if(token != null){
      Response response = await get(
          Uri.https(AppUrl.baseURL, AppUrl.getGroups, {}),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + token
          }
      );
      if (response.statusCode == 200){
        _stateGroupsLoading = GroupsLoadingStatus.NotLoading;
        notifyListeners();
        result = {'status': true, 'message': 'Successful', 'data': json.decode(response.body)};
      }else{
        _stateGroupsLoading = GroupsLoadingStatus.NotLoading;
        notifyListeners();
        result = {
          'status': false,
          'message': convertErrorMessage(json.decode(response.body))
        };
      }
    }else{
      _stateJoining = GroupJoiningLoadingStatus.NotLoading;
      notifyListeners();
      result = {
        'status': false,
        'message': 'Kein Token verfügbar!'
      };
    }

    return result;
  }
}