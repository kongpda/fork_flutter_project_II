import 'package:flutter/foundation.dart';
import 'package:flutter_project_ii/auth_model/login_model.dart';
import 'package:http/http.dart' as http;


class LoginService {
  static Future login({
    required LoginRequestModel request,
    required Function(Future<LoginResponseModel>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "https://events.iink.dev/api/auth/token";
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: request.toJson(),
      );
      final data = compute(loginResponseModelFromJson, response.body);
      onRes(data);
      onError(null);
    } catch (e) {
      onError(e);
    }
  }
}