import 'package:flutter/material.dart';
import 'package:full_cart_project/model/productModel.dart';
class SavedFiltersProvider extends ChangeNotifier{
  List<String> filtersList=[];
  RangeValues selectedValues=RangeValues(1, 1000);
  setFilterList(String product){
    filtersList.add(product);
    notifyListeners();
  }
  removeFromFilterList(String product){
    filtersList.remove(product);
    notifyListeners();
  }
  setPriceRange(RangeValues priceRange){
    selectedValues=priceRange;
    notifyListeners();
  }
  setRangeOfPrice(RangeValues rangePrices){
    selectedValues=rangePrices;
    notifyListeners();
  }
  resetValues(){
    filtersList.clear();
    selectedValues=RangeValues(1, 1000);
    notifyListeners();
  }
}