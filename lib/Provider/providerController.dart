import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:full_cart_project/constant/listOfData.dart';
import 'package:full_cart_project/model/productModel.dart';
import 'package:full_cart_project/userSharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProviderController extends ChangeNotifier{
  List <Product> cartItemsFromProvider=[];
  List <Product> filteredListFromProvider=totalList;
  List<String> storedCartItems=[];
  bool isActive=false;
  ProviderController(){
    initialData();
      print('herFromConstructor');
  }
  //Function to use it in the construction function
  void initialData(){
    checkSharedPreferencesForItems();
  }
  //Add and store product in the memory
  addItem (Product product){
    cartItemsFromProvider.add(product);
    UserPreferences.addToStoredCart(product,productIsExist: false);
    notifyListeners();
  }
  removeItem (Product product){
    cartItemsFromProvider.remove(product);
    UserPreferences.removeFromStoredCart(product);
    notifyListeners();
  }
  checkUserLoggedIn(){
    UserPreferences.checkAddToCartTime();
    notifyListeners();
  }

  Future<void>checkSharedPreferencesForItems() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    UserPreferences.cartItems=preferences.getStringList('cartOfItems')??[];
    UserPreferences.differenceTime=preferences.getBool('difference')??false;
    print(UserPreferences.differenceTime);
      if(UserPreferences.differenceTime==false){
        for(String value in UserPreferences.cartItems){
          var item =json.decode(value);
          cartItemsFromProvider.add(Product.fromJson(item));
        }
        print(cartItemsFromProvider.toString());
        print('this is cartItems${cartItemsFromProvider.length}');
        print('heyFromHere');
      }else
        {
          print('we must deleteList');
          preferences.setStringList('cartOfItems',[]);
          cartItemsFromProvider.clear();
          print(cartItemsFromProvider);
          print(preferences.getStringList('cartOfItems'));
          preferences.setBool('difference', false);
        }
    notifyListeners();
  }
  setFilteredList(List <Product> list){
    filteredListFromProvider=list;
    notifyListeners();
  }
}