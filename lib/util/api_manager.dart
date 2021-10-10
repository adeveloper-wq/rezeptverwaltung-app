import 'package:http/http.dart';
import 'package:rezeptverwaltung/domains/response_data.dart';
import 'package:rezeptverwaltung/util/user_preferences.dart';

import 'app_url.dart';
import 'custom_exception.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ApiManager {

  /*Future<dynamic> postAPICall(String url, Map param) async {
    print("Calling API: $url");
    print("Calling parameters: $param");

    var responseJson;
    try {
      final response =  await http.post(url,
          body: param);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }*/

  static Future<ResponseData> getApiCall(String url, final param) async {
    print("Calling API: $url");
    print("Calling parameters: $param");

    String token = await UserPreferences().getToken();

    ResponseData responseData;

    if(token != null){
      try {
        Response response =  await get(
            Uri.https(AppUrl.baseURL, url, param),
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer ' + token
            });
        responseData = _response(response);
      } on SocketException {
        throw FetchDataException('No Internet connection');
      }
    }else{
      responseData = new ResponseData(false, 401, 'Kein Token verfügbar!', null);
    }

    return responseData;
  }

  static ResponseData _response(Response response) {
    switch (response.statusCode) {
      case 200:
        ResponseData responseData = new ResponseData(true, 200, 'Erfolgreich!', json.decode(response.body.toString()));
        return responseData;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}