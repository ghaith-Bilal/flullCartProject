import 'package:shared_preferences/shared_preferences.dart';

class CategorySharedPreferences {
  //Store selected category in the memory
 static Future<void> setCategoryFilter(List<String> filterList) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setStringList('savedCategory', filterList);
  }
 //Get selected category from the memory
  static Future<List<String>> getCategoryFilter() async {
    SharedPreferences _pref=await SharedPreferences.getInstance();
    return _pref.getStringList('savedCategory');
  }
  //Store selected range in the memory
  static Future<void> setRangeOfPrice(String startPoint,String endPoint)async{
   SharedPreferences _pref=await SharedPreferences.getInstance();
   _pref.setString('startPoint', startPoint);
   _pref.setString('endPoint', endPoint);
  }
 //Get start selected range from the memory
  static Future<String> getStartPoint() async{
   SharedPreferences _pref=await SharedPreferences.getInstance();
   return _pref.getString('startPoint');
  }
 //Get endPoint selected range from the memory
 static Future<String> getEndPoint() async{
   SharedPreferences _pref=await SharedPreferences.getInstance();
   return _pref.getString('endPoint');
 }
}