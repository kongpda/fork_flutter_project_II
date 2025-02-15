import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/event_model.dart';
import 'package:flutter_project_ii/auth/auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';



class EventService {

  static Future read(
    {required Function(Future<EventModel>) onRes,
      required Function(Object?) onError,
      BuildContext? context,

    }
  ) async{
    final token = context?.read<AuthProvider>().token;
    debugPrint('token: '+token.toString());
    String url = "https://events.iink.dev/api/events";
    try{
      http.Response response = await http.get(Uri.parse(url),
      headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final data = compute(eventModelFromJson, response.body);
      onRes(data);
      onError(null);
    } catch(e){
      onError(e);
    }
  }
  
}