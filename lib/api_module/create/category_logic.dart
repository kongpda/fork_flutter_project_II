import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/create/category_model.dart';
import 'package:flutter_project_ii/auth/auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CategoryLogic with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;
  String _error = '';

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchCategories(BuildContext context) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final token = context.read<AuthProvider>().token;
      debugPrint('token: $token');
      final response = await http.get(
        Uri.parse('https://events.iink.dev/api/categories'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('data: $data');
        if (data != null) {
          _categories = eventCategoryFromJson(response.body).data;
          notifyListeners();
        }
      } else {
        _error = 'Failed to load categories';
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error fetching categories: $e';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
