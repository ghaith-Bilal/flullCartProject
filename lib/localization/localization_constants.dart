import 'package:flutter/material.dart';
import 'package:full_cart_project/localization/demo_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getTranslatedValues(BuildContext context,String key){
  return  DemoLocalizations.of(context).getTranslatedValues(key);
}
// Setting and storing the selected language
Future<Locale> setLanguage (String languageCode) async{
  SharedPreferences _setLang=await SharedPreferences.getInstance();
  _setLang.setString('lang', languageCode);
  print('${_setLang.getString('lang')} my lang');
  return _locale(languageCode);
}
//This Function set the language in the app
Locale _locale(String languageCode){
  Locale _tempLocale;
  switch (languageCode) {
    case 'en':
      _tempLocale = Locale('en', 'US');
      break;
    case 'ar':
      _tempLocale = Locale('ar', 'AE');
      break;
    default:
      _tempLocale = Locale('en', 'US');
  }
  return _tempLocale;
}
//This func will be called during lunching the app
Future<Locale> getLocale() async{
  SharedPreferences _getLang=await SharedPreferences.getInstance();
  String languageCode=_getLang.getString('lang')??'la';
  print('language is+$languageCode');
  return _locale(languageCode);
}