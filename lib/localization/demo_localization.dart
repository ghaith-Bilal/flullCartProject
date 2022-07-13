import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class DemoLocalizations{
  final Locale locale;

  DemoLocalizations(this.locale);
// localize your strings throughout your widget tree using this helper method
  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }
   //Loading json files into this private map
  Map<String,String> _localizedValues;
  //the previous process of saving json files is done inside this method
   Future load() async{
     //load the language json file from the 'lang' folder through rootBundle.
     //load string and storing it tn jsonStringValue variable
     String jsonStringValues=
         await rootBundle.loadString('lib/lang/${locale.languageCode}.json');
     Map<String,dynamic> mappedJson=json.decode(jsonStringValues);
     _localizedValues=
         mappedJson.map((key, value) => MapEntry(key, value.toString()));
   }
   //This method will be called from every widget which needs a localized text
String getTranslatedValues(String key){
     return _localizedValues[key];
}
// static member to have a simple access to the delegate from the Material App
static const LocalizationsDelegate<DemoLocalizations> delegate=
_DemoLocalizationDelegate();
}
// LocalizationsDelegate is a factory for a set of localized resources in this
// case,the localized strings will be gotten in an DemoLocalizations object
class _DemoLocalizationDelegate extends LocalizationsDelegate<DemoLocalizations>{
  const _DemoLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    // include all of your supported language codes here
   return ['en','ar'].contains(locale.languageCode);
  }

  @override
  Future<DemoLocalizations> load(Locale locale) async{
    DemoLocalizations localizations=new DemoLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_DemoLocalizationDelegate old) => false;

}
