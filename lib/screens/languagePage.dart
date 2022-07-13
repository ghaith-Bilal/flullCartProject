import 'dart:io';

import 'package:flutter/material.dart';
import 'package:full_cart_project/constant/constants.dart';
import 'package:full_cart_project/localization/localization_constants.dart';
import 'package:full_cart_project/main.dart';
import 'package:full_cart_project/screens/HomePage.dart';
import 'package:full_cart_project/screens/ProductsPage.dart';

class LanguagePage extends StatefulWidget {
  static String id = 'Language Page';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LanguagePage();
  }
}

class _LanguagePage extends State<LanguagePage> {
  bool _arabicIsPressed;
  bool _englishIsPressed;
  String languageCode;
  final String defaultLocale = Platform.localeName;
  @override
  void initState() {
    super.initState();
    _arabicIsPressed = false;
    _englishIsPressed = false;
    print(defaultLocale);
  }

  void _changeLanguage(String language) async {
    Locale _tempLocale = await setLanguage(language);
    MyApp.setLocale(context, _tempLocale);
    Navigator.pushNamed(context, HomePage.id);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  getTranslatedValues(context, 'select_language_text'),
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Newsreader',
                      fontSize: 20),
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _arabicIsPressed = !_arabicIsPressed;
                  if (_arabicIsPressed) {
                    languageCode = 'ar';
                    _englishIsPressed = false;
                    _changeLanguage(languageCode);
                  }
                });
              },
              child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                    color: (_arabicIsPressed) ? secondColor : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black, width: 2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '🇦🇪',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      getTranslatedValues(context, 'arabic_button'),
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Newsreader',
                          color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  _englishIsPressed = !_englishIsPressed;
                  if (_englishIsPressed) {
                    languageCode = 'en';
                    _arabicIsPressed = false;
                    _changeLanguage(languageCode);
                  }
                });
              },
              child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                    color: (_englishIsPressed) ? secondColor : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black, width: 2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '🇬🇧',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      getTranslatedValues(context, 'english_button'),
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Newsreader',
                          color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
