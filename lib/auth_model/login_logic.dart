
import 'package:flutter/material.dart';
import 'package:flutter_project_ii/auth_model/login_model.dart';
import 'package:flutter_project_ii/auth_model/login_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginLogic extends ChangeNotifier{
  bool _loading = false;
  bool get loading => _loading;

  LoginResponseModel _responseModel = LoginResponseModel();
  LoginResponseModel get getResponseModel => _responseModel;

  final _cache = const FlutterSecureStorage();
  final _key = "LoginLogic";

  Object? _error;
  Object? get getError => _error;

  void setLoading(){
    _loading = true;
    notifyListeners();
  }

  Future read() async {
    String? token = await _cache.read(key: _key);
    debugPrint("Token: $token");
    _responseModel = LoginResponseModel(token: token);
    notifyListeners();
  }

  Future clear() async {
    _cache.delete(key: _key);
    _responseModel = LoginResponseModel(token: null);
    notifyListeners();
  }

  Future<LoginResponseModel> login(String email, String password) async {
    LoginRequestModel requestModel = LoginRequestModel(
      email: email.trim(),
      password: password.trim(),
      device_name: "String",
    );
    //LoginResponseModel _responseModel = LoginResponseModel();

    await LoginService.login(
      request: requestModel,
      onRes: (value) async {
        _responseModel = await value;
        debugPrint("Token: ${_responseModel.token}, saving: $_key");
        _cache.write(key: _key, value: _responseModel.token);
        _error = null;
        _loading = false;
        notifyListeners();
      },
      onError: (error) async {
        _error = error;
        _loading = false;
        notifyListeners();
      }
    );
    return _responseModel;
  }
}