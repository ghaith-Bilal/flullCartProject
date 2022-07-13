import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:full_cart_project/Provider/providerController.dart';
import 'package:full_cart_project/Provider/savedFiltersProvider.dart';
import 'package:full_cart_project/constant/constants.dart';
import 'package:full_cart_project/localization/demo_localization.dart';
import 'package:full_cart_project/localization/localization_constants.dart';
import 'package:full_cart_project/screens/cartScreen.dart';
import 'package:full_cart_project/screens/detailsPage.dart';
import 'package:full_cart_project/screens/filterPage.dart';
import 'package:full_cart_project/screens/HomePage.dart';
import 'package:full_cart_project/screens/ProductsPage.dart';
import 'package:full_cart_project/screens/languagePage.dart';
import 'package:full_cart_project/screens/loginFacebook.dart';
import 'package:full_cart_project/screens/loginPage.dart';
import 'package:full_cart_project/screens/registerPage.dart';
import 'package:full_cart_project/userSharedPreferences.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // UserPreferences.reverseActiveStatus();
   await UserPreferences.checkedLoggedIn();
  UserPreferences.checkAddToCartTime();
  UserPreferences.checkBasketQuantity();

  // cartItemProvider.checkSharedPreferencesForItems();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  static void setLocale(BuildContext context,Locale locale){
    //Find the state of MyApp
    _MyAppState state=context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  void setLocale(Locale locale){
    setState(() {
      _locale=locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale){
      setState(() {
        this._locale=locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //supports multiProviders
    return MultiProvider(providers: [
      ChangeNotifierProvider<ProviderController>(create: (_)=>ProviderController()),
      ChangeNotifierProvider<SavedFiltersProvider>(create: (_)=>SavedFiltersProvider(),)
    ],
     child: (_locale==null)?Container(
      color: Colors.white,
      child: Center(child:CircularProgressIndicator()),
    ):MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.id,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        HomePage.id: (context) => HomePage(),
        DetailsPage.id: (context) => DetailsPage(),
        CartScreen.id: (context) => CartScreen(),
        RegisterPage.id: (context) => RegisterPage(),
        FilterPage.id:(context)=> FilterPage(),
        ProductsPage.id:(context)=>ProductsPage(),
        LanguagePage.id:(context)=>LanguagePage(),
        LoginToFaceBook.id:(context)=>LoginToFaceBook()
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: secondColor,
      ),
      locale: _locale,
      supportedLocales: [
        Locale('en','US'),
        Locale('ar','AE')
      ],
      //factories that produce collections of localized values
      localizationsDelegates: [
        //A class which loads the translations from Json files
        // delegate :bridge between flutter and our AppLocalizations
        //so the languages are loaded at the proper time and with the proper
        //locale
        DemoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Returns a locale which will be used through by the app
      localeResolutionCallback: (deviceLocale,supportedLocales){
        //check if the current device locale is supported
        for(var locale in supportedLocales){
          if(locale.languageCode==deviceLocale.languageCode
              &&locale.countryCode==deviceLocale.countryCode){
            return deviceLocale;
          }
        }
        //if the locale of the device is not supported, use the first one
        // from the list (English in this case)
        return supportedLocales.first;
      },
    ),
    );
  }
}
