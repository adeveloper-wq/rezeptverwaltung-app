import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rezeptverwaltung/domains/user.dart';
import 'package:rezeptverwaltung/util/app_url.dart';
import 'package:rezeptverwaltung/util/user_preferences.dart';


enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {

  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;


  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final queryParameters = {
      'email': email,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      Uri.https(AppUrl.baseURL, AppUrl.login, queryParameters),
      //body: json.encode(loginData),
      //headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      User authUser = User.fromJson(responseData);

      Response responseUser = await getUser(authUser);

      if(responseUser.statusCode == 200){
        final Map<String, dynamic> responseUserData = json.decode(responseUser.body);

        authUser.userId = responseUserData['P_ID'];
        authUser.email = responseUserData['email'];
        authUser.name = responseUserData['name'];

        UserPreferences().saveUser(authUser);

        _loggedInStatus = Status.LoggedIn;
        notifyListeners();

        result = {'status': true, 'message': 'Successful', 'user': authUser};
      }else{
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {
          'status': false,
          'message': json.decode(responseUser.body)['error']
        };
      }
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> register(String email, String name, String password) async {

    final queryParameters = {
      'email': email,
      'name': name,
      'password': password
    };


    _registeredInStatus = Status.Registering;
    notifyListeners();

    return await post(Uri.https(AppUrl.baseURL, AppUrl.register, queryParameters))
        .then(onValue)
        .catchError(onError);
  }

  Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {

      final Map<String, dynamic> responseData = json.decode(response.body);

      User authUser = User.fromJson(responseData);

      Response responseUser = await getUser(authUser);

      if(responseUser.statusCode == 200){
        final Map<String, dynamic> responseUserData = json.decode(responseUser.body);

        authUser.userId = responseUserData['P_ID'];
        authUser.email = responseUserData['email'];
        authUser.name = responseUserData['name'];

        UserPreferences().saveUser(authUser);

        _loggedInStatus = Status.LoggedIn;
        notifyListeners();

        result = {
          'status': true,
          'message': 'Successfully registered',
          'data': authUser
        };
      }else{
        result = {
          'status': false,
          'message': 'Registration failed',
          'data': json.decode(responseUser.body)
        };
      }
    } else {
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }

  Future<Response> getUser(User authUser) async{
    return await get(
        Uri.https(AppUrl.baseURL, AppUrl.user, {}),
        headers: {
        HttpHeaders.authorizationHeader: 'Bearer ' + authUser.accessToken
        }
    );
  }
}