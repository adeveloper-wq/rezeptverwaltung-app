import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rezeptverwaltung/domains/user.dart';
import 'package:rezeptverwaltung/util/app_url.dart';
import 'package:rezeptverwaltung/util/user_preferences.dart';
import 'package:rezeptverwaltung/util/message_convert.dart';


enum Status {
  LoggedIn,
  LoggedOut,
  Loading
}

class AuthProvider with ChangeNotifier {

  Status _state = Status.LoggedOut;

  Status get state => _state;

  Future<Map<String, dynamic>> login(String email, String password) async {
    Map<String, dynamic> result;

    final queryParameters = {
      'email': email,
      'password': password
    };

    _state = Status.Loading;
    notifyListeners();

    return await post(
      Uri.https(AppUrl.baseURL, AppUrl.login, queryParameters),
      //body: json.encode(loginData),
      //headers: {'Content-Type': 'application/json'},
    ) .then(onValue)
      .catchError(onError);
  }

  Future<Map<String, dynamic>> register(String email, String name, String password) async {

    final queryParameters = {
      'email': email,
      'name': name,
      'password': password
    };


    _state = Status.Loading;
    notifyListeners();

    return await post(Uri.https(AppUrl.baseURL, AppUrl.register, queryParameters))
        .then(onValue)
        .catchError(onError);
  }

  Future<FutureOr> onValue(Response response) async {
    Map<String, dynamic> result;

    result = await getUser(response);

    return result;
  }

  static onError(error) {
    print("the error is: $error");
    return {'status': false, 'message': 'Fehler: $error', 'data': error};
  }

  Future<Map<String, dynamic>> getUser(Response response) async{
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

        _state = Status.LoggedIn;
        notifyListeners();

        result = {'status': true, 'message': 'Successful', 'data': authUser};
      }else{
        _state = Status.LoggedOut;
        notifyListeners();
        result = {
          'status': false,
          'message': 'Serverfehler'
        };
      }
    }else{
      _state = Status.LoggedOut;
      notifyListeners();
      result = {
        'status': false,
        'message': convertErrorMessage(json.decode(response.body))
      };
    }
    return result;
  }
}