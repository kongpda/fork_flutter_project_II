import 'dart:convert';

LoginRequestModel loginRequestModelFromJson(String str) =>
    LoginRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(LoginRequestModel data) =>
    json.encode(data.toJson());

class LoginRequestModel {
  String email;
  String password;
  String device_name;

  LoginRequestModel({
    required this.email,
    required this.password,
    required this.device_name,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      LoginRequestModel(
        email: json["email"],
        password: json["password"],
        device_name: json["device_name"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "device_name": device_name,
      };
}

LoginResponseModel loginResponseModelFromJson(String str) {
  LoginResponseModel model;
  try {
    model = LoginResponseModel.fromJson(json.decode(str));
  } on FormatException catch (e) {
    model = LoginResponseModel.fromErrorText(str);
  }
  return model;
}

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  String? token;
  String? errorText;

  LoginResponseModel({this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        token: json["token"],
      );

  LoginResponseModel.fromErrorText(String text) {
    errorText = text;
  }

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}