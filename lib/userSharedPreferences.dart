import 'dart:convert';
import 'package:full_cart_project/model/productModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/userModel.dart';

class UserPreferences{
  static SharedPreferences _preferences;
  static User thisUser;
  static String imagePath ;
  static bool loggedIn;
  static bool differenceTime;
  static bool isActive;
  static int _quantityBasket;
  static List <String>cartItems=List.empty(growable: true);
  static String addToCartTime;
  static Future <void> setUser(User user)async{
    _preferences=await SharedPreferences.getInstance();
    thisUser=user;
    await _preferences.setString('User', json.encode(thisUser.toJson()));
  }
  static void storeImage(String path)async{
    _preferences=await SharedPreferences.getInstance();
    imagePath=path;
    await _preferences.setString('Image',imagePath);
  }
  static void setQuantityOfBasket(int quantity) async{
    _preferences=await SharedPreferences.getInstance();
    _quantityBasket=quantity;
    _preferences.setInt('quantity', _quantityBasket);
  }
  static Future <void> setLoggedIn(bool logged)async{
    _preferences=await SharedPreferences.getInstance();
    loggedIn=logged;
    await _preferences.setBool('logged', logged);
}
  static Future <void> setTimeOfAddingProduct(String cartTime)async{
    _preferences=await SharedPreferences.getInstance();
    addToCartTime=cartTime;
    await _preferences.setString('cartTime', cartTime);
  }
  //Function to Check if there is a difference in the time
  static Future<void> checkAddToCartTime()async{
    _preferences=await SharedPreferences.getInstance();
    loggedIn=_preferences.getBool('logged')??false;
    addToCartTime=_preferences.getString('cartTime')??'noItemsAdded';
    if(loggedIn==false){
      print('1 condition');
    if(addToCartTime=='noItemsAdded'){
     _preferences.setBool('difference', false);
    }else {
      print('3 condition');
      DateTime timeNow = DateTime.now();
      DateTime previousTime = DateTime.parse(addToCartTime);
      print('differenceIs'+timeNow.difference(previousTime).inMinutes.toString());
      if (timeNow.difference(previousTime).inMinutes > 1) {
        _preferences.setBool('difference', true);
        print('4 condition');
      }else{
        print('5 condition');
        _preferences.setBool('difference', false);
        // print(_preferences.getBool('difference').toString());
      }
    }
  }else {
      _preferences.setBool('difference', false);
    }
  }
  static Future<void> checkedLoggedIn() async{
    _preferences=await SharedPreferences.getInstance();
    loggedIn=_preferences.getBool('logged')??false;
    print('this is $loggedIn');
    if(loggedIn)
      {
          String user=_preferences.getString('User');
          var userMap=json.decode(user);
          thisUser=User.fromJson(userMap);
      }else{
      _preferences.setBool('logged', false);
    }
     }
  static void addToStoredCart(Product product,{bool productIsExist,int
  positionOfProduct,List<Product> providerCarts})async{
    _preferences=await SharedPreferences.getInstance();
    cartItems=_preferences.getStringList('cartOfItems')??[];
    if(productIsExist==true){
      print('rightCondition1');
      List<Product> listForChecking=List.empty(growable: true);
      for(String value in cartItems){
        var item =json.decode(value);
        listForChecking.add(Product.fromJson(item));
      }
      for(int i=0;i<listForChecking.length;i++)
        {
          if(listForChecking[i].pName==providerCarts[positionOfProduct].pName) {
          listForChecking[i].pQuantity = providerCarts[positionOfProduct].pQuantity;
         cartItems=listForChecking.map((e) => json.encode(e.toJson())).toList();
         print(cartItems.length);
         _preferences.setStringList('cartOfItems', cartItems);
        }
      }
    }
    else if(productIsExist==false){
      print('flaseCondition1');
      cartItems.add(json.encode(product.toJson()));
      print(cartItems.length);
      _preferences.setStringList('cartOfItems', cartItems);
      print(cartItems);
    }
  }
  static void removeFromStoredCart(Product product)async {
    _preferences=await SharedPreferences.getInstance();
    cartItems=_preferences.getStringList('cartOfItems')??[];
    cartItems.removeWhere((element) => element==json.encode(product.toJson()));
    _preferences.setStringList('cartOfItems', cartItems);
    print(cartItems);
  }
  //Function to check the value of Basket quantity
 static void checkBasketQuantity()async{
    _preferences=await SharedPreferences.getInstance();
    bool checkedBoolValue=_preferences.getBool('difference')??false;
    if(checkedBoolValue){
      _preferences.setInt('quantity', 0);
    }
 }
 //Function to get the value of Basket quantity
 static Future<int> getBasketQuantity()async{
    _preferences=await SharedPreferences.getInstance();
    int quantity=_preferences.getInt('quantity')??0;
    print('getBasketValue');
    print(quantity);
    return quantity;
 }
}