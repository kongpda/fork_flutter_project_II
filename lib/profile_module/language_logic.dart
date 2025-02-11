import 'package:flutter/material.dart';
import 'package:flutter_project_ii/profile_module/language_data.dart';

class LanguageLogic extends ChangeNotifier{
  Language _language = Language();
  Language get language => _language;

  int _langIndex = 0;
  int get langIndex => _langIndex;

  void changeLanguage(){
    _langIndex = 0;
    _language = Language();
    notifyListeners();
  }
  void changeToKh(){
    _langIndex = 1;
    _language = LanguageKh();
    notifyListeners();
  }
}