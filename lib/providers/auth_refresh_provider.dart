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


enum StatusRefresh {
  LoggedIn,
  LoggedOut,
  Loading
}

class AuthRefreshProvider with ChangeNotifier {

  StatusRefresh _state = StatusRefresh.Loading;

  StatusRefresh get state => _state;

  Future<Map<String,dynamic>> refresh(BuildContext context) async {
    Map<String, dynamic> result;

    String oldToken = await UserPreferences().getToken();

    if(oldToken != null){
      Response response = await post(
          Uri.https(AppUrl.baseURL, AppUrl.refresh, {}),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + oldToken
          }
      );

      result = await getUser(response, context);
    }else{
      _state = StatusRefresh.LoggedOut;
      notifyListeners();
      result = {
        'status': false,
        'message': 'No previous token/user data stored!'
      };
    }

    return result;
  }

  Future<Map<String, dynamic>> getUser(Response response, BuildContext context) async{
    Map<String, dynamic> result;
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      User authUser = User.fromJson(responseData);

      Response responseUser = await get(
          Uri.https(AppUrl.baseURL, AppUrl.user, {}),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + authUser.accessToken
          }
      );

      if(responseUser.statusCode == 200){
        final Map<String, dynamic> responseUserData = json.decode(responseUser.body);

        authUser.userId = responseUserData['P_ID'];
        authUser.email = responseUserData['email'];
        authUser.name = responseUserData['name'];

        UserPreferences().saveUser(authUser);
        context.read<UserProvider>().setUser(authUser);

        _state = StatusRefresh.LoggedIn;
        notifyListeners();

        result = {'status': true, 'message': 'Successful', 'data': authUser};
      }else{
        _state = StatusRefresh.LoggedOut;
        notifyListeners();
        result = {
          'status': false,
          'message': json.decode(responseUser.body)['error']
        };
      }
    } else {
      _state = StatusRefresh.LoggedOut;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }
}