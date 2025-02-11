import 'package:flutter/foundation.dart';
import 'package:flutter_project_ii/api_module/event_model.dart';
import 'package:http/http.dart' as http;



class EventService {

  static Future read(
    {required Function(Future<EventModel>) onRes,
      required Function(Object?) onError,
    }
  ) async{
    String url = "https://events.iink.dev/api/events";
    try{
      http.Response response = await http.get(Uri.parse(url));
      final data = compute(eventModelFromJson, response.body);
      onRes(data);
      onError(null);
    } catch(e){
      onError(e);
    }
  }

  static Future search(
    {
      required String movieTitle,
      required Function(Future<EventModel>) onRes,
      required Function(Object?) onError,
    }
  ) async{
    String url = "https://www.omdbapi.com/?apikey=4a1e0f25&s=$movieTitle&page=1";
    try{
      http.Response response = await http.get(Uri.parse(url));
      final data = compute(eventModelFromJson, response.body);
      onRes(data);
      onError(null);
    } catch(e){
      onError(e);
    }
  }
  static Future readByPage({
    int page = 1,
    required Function(Future<EventModel>) onRes,
    required Function(Object?) onError,
  }) async {
    String url =
        "https://www.omdbapi.com/?apikey=f9aa78ee&s=true+crime&page=$page";
    try {
      http.Response response = await http.get(Uri.parse(url));
      final data = compute(eventModelFromJson, response.body);
      onRes(data);
      onError(null);
    } catch (e) {
      onError(e);
    }
  }
  
}