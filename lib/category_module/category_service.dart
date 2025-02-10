import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_project_ii/category_module/category_model.dart';
import 'package:http/http.dart' as http;

class CategoryLogic with ChangeNotifier {
  List<Categories> _category = [];
  bool _isLoading = false;
  String _error = '';

  List<Categories> get category => _category;
  bool get isLoading => _isLoading;
  String get error => _error;


  void setLoading(){
    _isLoading = true;
    notifyListeners();
  }

  Future<void> fetchCategory() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://events.iink.dev/api/categories'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          _category = (data['data'] as List)
              .map((event) => Categories.fromJson(event))
              .toList();
        debugPrint(data['data']);
        }
      } else {
        _error = 'Failed to load category';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}