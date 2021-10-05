import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rezeptverwaltung/domains/receipt.dart';
import 'package:rezeptverwaltung/util/app_url.dart';
import 'package:rezeptverwaltung/util/message_convert.dart';
import 'package:rezeptverwaltung/util/user_preferences.dart';


enum GetReceiptsLoadingStatus {
  NotLoading,
  Loading
}

enum GetStepsLoadingStatus {
  NotLoading,
  Loading
}

enum GetIngredientsLoadingStatus {
  NotLoading,
  Loading
}

enum GetIngredientNamesLoadingStatus {
  NotLoading,
  Loading
}

enum GetUnitNamesLoadingStatus {
  NotLoading,
  Loading
}

enum GetAllUnitsLoadingStatus {
  NotLoading,
  Loading
}

enum GetAllTagsLoadingStatus {
  NotLoading,
  Loading
}

enum CreateReceiptLoadingStatus {
  NotLoading,
  Loading
}

class ReceiptProvider with ChangeNotifier {

  GetReceiptsLoadingStatus _state = GetReceiptsLoadingStatus.NotLoading;
  GetStepsLoadingStatus _stateSteps = GetStepsLoadingStatus.NotLoading;
  GetIngredientsLoadingStatus _stateIngredients = GetIngredientsLoadingStatus.NotLoading;
  GetIngredientNamesLoadingStatus _stateIngredientNames = GetIngredientNamesLoadingStatus.NotLoading;
  GetUnitNamesLoadingStatus _stateUnitNames = GetUnitNamesLoadingStatus.NotLoading;
  GetAllUnitsLoadingStatus _stateGetAllUnits = GetAllUnitsLoadingStatus.NotLoading;
  GetAllTagsLoadingStatus _stateGetAllTags = GetAllTagsLoadingStatus.NotLoading;
  CreateReceiptLoadingStatus _stateCreateReceipt = CreateReceiptLoadingStatus.NotLoading;

  GetReceiptsLoadingStatus get state => _state;
  GetStepsLoadingStatus get stateSteps => _stateSteps;
  GetIngredientsLoadingStatus get stateIngredients => _stateIngredients;
  GetIngredientNamesLoadingStatus get stateIngredientNames => _stateIngredientNames;
  GetUnitNamesLoadingStatus get stateUnitNames => _stateUnitNames;
  GetAllUnitsLoadingStatus get stateGetAllUnits => _stateGetAllUnits;
  GetAllTagsLoadingStatus get stateGetAllTags => _stateGetAllTags;
  CreateReceiptLoadingStatus get stateCreateReceipt => _stateCreateReceipt;

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

  Future<Map<String,dynamic>> getSteps(int receiptId) async {
    _stateSteps = GetStepsLoadingStatus.Loading;
    Map<String, dynamic> result;

    String token = await UserPreferences().getToken();

    if(token != null){
      final queryParameters = {
        'R_ID': receiptId.toString()
      };

      Response response = await get(
          Uri.https(AppUrl.baseURL, AppUrl.getSteps, queryParameters),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + token
          }
      );

      if (response.statusCode == 200){
        _stateSteps = GetStepsLoadingStatus.NotLoading;
        notifyListeners();
        result = {'status': true, 'message': 'Successful', 'data': json.decode(response.body)};
      }else{
        _stateSteps = GetStepsLoadingStatus.NotLoading;
        notifyListeners();
        result = {
          'status': false,
          'message': convertErrorMessage(json.decode(response.body))
        };
      }
    }else{
      _stateSteps = GetStepsLoadingStatus.NotLoading;
      notifyListeners();
      result = {
        'status': false,
        'message': 'Kein Token verfügbar!'
      };
    }

    return result;
  }

  Future<Map<String,dynamic>> getIngredients(int receiptId) async {
    _stateIngredients = GetIngredientsLoadingStatus.Loading;
    Map<String, dynamic> result;

    String token = await UserPreferences().getToken();

    if(token != null){
      final queryParameters = {
        'R_ID': receiptId.toString()
      };

      Response response = await get(
          Uri.https(AppUrl.baseURL, AppUrl.getIngredients, queryParameters),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + token
          }
      );

      if (response.statusCode == 200){
        _stateIngredients = GetIngredientsLoadingStatus.NotLoading;
        notifyListeners();
        result = {'status': true, 'message': 'Successful', 'data': json.decode(response.body)};
      }else{
        _stateIngredients = GetIngredientsLoadingStatus.NotLoading;
        notifyListeners();
        result = {
          'status': false,
          'message': convertErrorMessage(json.decode(response.body))
        };
      }
    }else{
        _stateIngredients = GetIngredientsLoadingStatus.NotLoading;
      notifyListeners();
      result = {
        'status': false,
        'message': 'Kein Token verfügbar!'
      };
    }

    return result;
  }

  Future<Map<String,dynamic>> getUnitNames(List<String> unitIds) async {
    _stateUnitNames = GetUnitNamesLoadingStatus.Loading;
    Map<String, dynamic> result;

    String token = await UserPreferences().getToken();

    if(token != null){
      final queryParameters = {
        'E_IDs[]': unitIds
      };

      Response response = await get(
          Uri.https(AppUrl.baseURL, AppUrl.getUnits, queryParameters),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + token
          }
      );

      if (response.statusCode == 200){
        _stateUnitNames = GetUnitNamesLoadingStatus.NotLoading;
        notifyListeners();
        result = {'status': true, 'message': 'Successful', 'data': json.decode(response.body)};
      }else{
        _stateUnitNames = GetUnitNamesLoadingStatus.NotLoading;
        notifyListeners();
        result = {
          'status': false,
          'message': convertErrorMessage(json.decode(response.body))
        };
      }
    }else{
      _stateUnitNames = GetUnitNamesLoadingStatus.NotLoading;
      notifyListeners();
      result = {
        'status': false,
        'message': 'Kein Token verfügbar!'
      };
    }

    return result;
  }

  Future<Map<String,dynamic>> getAllUnits() async {
    _stateGetAllUnits = GetAllUnitsLoadingStatus.Loading;
    Map<String, dynamic> result;

    String token = await UserPreferences().getToken();

    if(token != null){


      Response response = await get(
          Uri.https(AppUrl.baseURL, AppUrl.getAllUnits, {}),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + token
          }
      );

      if (response.statusCode == 200){
        _stateGetAllUnits = GetAllUnitsLoadingStatus.NotLoading;
        notifyListeners();
        result = {'status': true, 'message': 'Successful', 'data': json.decode(response.body)};
      }else{
        _stateGetAllUnits = GetAllUnitsLoadingStatus.NotLoading;
        notifyListeners();
        result = {
          'status': false,
          'message': convertErrorMessage(json.decode(response.body))
        };
      }
    }else{
      _stateGetAllUnits = GetAllUnitsLoadingStatus.NotLoading;
      notifyListeners();
      result = {
        'status': false,
        'message': 'Kein Token verfügbar!'
      };
    }

    return result;
  }

  Future<Map<String,dynamic>> getAllTags() async {
    _stateGetAllTags = GetAllTagsLoadingStatus.Loading;
    Map<String, dynamic> result;

    String token = await UserPreferences().getToken();

    if(token != null){


      Response response = await get(
          Uri.https(AppUrl.baseURL, AppUrl.getAllTags, {}),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + token
          }
      );

      if (response.statusCode == 200){
        _stateGetAllTags = GetAllTagsLoadingStatus.NotLoading;
        notifyListeners();
        result = {'status': true, 'message': 'Successful', 'data': json.decode(response.body)};
      }else{
        _stateGetAllTags = GetAllTagsLoadingStatus.NotLoading;
        notifyListeners();
        result = {
          'status': false,
          'message': convertErrorMessage(json.decode(response.body))
        };
      }
    }else{
      _stateGetAllTags = GetAllTagsLoadingStatus.NotLoading;
      notifyListeners();
      result = {
        'status': false,
        'message': 'Kein Token verfügbar!'
      };
    }

    return result;
  }

  Future<Map<String,dynamic>> createReceipt(Receipt receipt) async {
    _stateCreateReceipt = CreateReceiptLoadingStatus.Loading;
    Map<String, dynamic> result;

    String token = await UserPreferences().getToken();

    if(token != null){
      final queryParameters = {
        'groupId': receipt.groupId.toString(),
        'name': receipt.name,
        'portions': receipt.portions.toString(),
        'workingTime': receipt.workingTime.toString(),
        'cookingTime': receipt.cookingTime.toString(),
        'restTime': receipt.restTime.toString(),
        'tagIds[]': receipt.getTagIdStrings(),
        'ingredients': json.encode(receipt.ingredients),
        'steps': json.encode(receipt.steps)
      };

      Response response = await post(
          Uri.https(AppUrl.baseURL, AppUrl.createReceipt, queryParameters),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + token
          }
      );

      if (response.statusCode == 200){
        _stateCreateReceipt = CreateReceiptLoadingStatus.NotLoading;
        notifyListeners();
        result = {'status': true, 'message': 'Erfolgreich'};
      }else{
        _stateCreateReceipt = CreateReceiptLoadingStatus.NotLoading;
        notifyListeners();
        result = {
          'status': false,
          'message': convertErrorMessage(json.decode(response.body))
        };
      }
    }else{
      _stateCreateReceipt = CreateReceiptLoadingStatus.NotLoading;
      notifyListeners();
      result = {
        'status': false,
        'message': 'Kein Token verfügbar!'
      };
    }

    return result;
  }

  Future<Map<String,dynamic>> uploadReceiptImages(List<String> filepaths) async {
    _stateCreateReceipt = CreateReceiptLoadingStatus.Loading;
    Map<String, dynamic> result;

    String token = await UserPreferences().getToken();

    if(token != null){
      dio.Dio dioInstance = dio.Dio();

      var formData = dio.FormData();
      for (var file in filepaths) {
        formData.files.addAll([
          MapEntry("assignment", await dio.MultipartFile.fromFile(file)),
        ]);
      }

      final queryParameters = {

      };
      // https://stackoverflow.com/questions/63263840/how-to-upload-multiple-images-files-in-flutter-using-dio
      dio.Response response = await dioInstance.post("https://" + AppUrl.baseURL + AppUrl.uploadReceiptImages,
          data: formData,
          options: dio.Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + token
          }));

      if (response.statusCode == 200){
        _stateCreateReceipt = CreateReceiptLoadingStatus.NotLoading;
        notifyListeners();
        result = {'status': true, 'message': 'Erfolgreicher Bilderupload'};
      }else{
        _stateCreateReceipt = CreateReceiptLoadingStatus.NotLoading;
        notifyListeners();
        result = {
          'status': false,
          'message': convertErrorMessage(json.decode(response.data))
        };
      }
    }else{
      _stateCreateReceipt = CreateReceiptLoadingStatus.NotLoading;
      notifyListeners();
      result = {
        'status': false,
        'message': 'Kein Token verfügbar!'
      };
    }

    return result;
  }
}