import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_cart_project/Provider/providerController.dart';
import 'package:full_cart_project/Provider/savedFiltersProvider.dart';
import 'package:full_cart_project/categorySharedPreferences.dart';
import 'package:full_cart_project/constant/constants.dart';
import 'package:full_cart_project/constant/listOfData.dart';
import 'package:full_cart_project/localization/localization_constants.dart';
import 'package:full_cart_project/model/productModel.dart';
import 'package:full_cart_project/screens/ProductsPage.dart';
import 'package:provider/provider.dart';
class FilterPage extends StatefulWidget{
  static String id='FilterPage';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FilterPage();
  }
}
class _FilterPage extends State<FilterPage>{
  List<String> productCategory=['Laptop','Battery'];
  List<String> productArabicCategory=['لابتوب','بطارية'];
  RangeLabels labels=RangeLabels('1\$', '500\$');
  final double min=1;
  final double max=1000;
  @override
  Widget build(BuildContext context) {
    //Defining the providers
    ProviderController filterListProvider = Provider.of<ProviderController>(context);
    SavedFiltersProvider savedFiltersProvider=Provider.of<SavedFiltersProvider>(context);
    Size size=MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      backgroundColor: secondColor,
      appBar: AppBar(
        title: Text(getTranslatedValues(context, 'filter_label'),style:  TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Newsreader'
        ),),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height:size.height*0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(getTranslatedValues(context, 'category_label')
                      ,style: TextStyle(color:Colors.white70,fontSize: 18,
                  fontFamily: 'Newsreader')),
                ),
              ],
            ),
            SizedBox(height:30),
            //Widget which contains filter category
            Wrap(
              direction: Axis.vertical,
              spacing: 10,
              children: filterWidget.toList(),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(getTranslatedValues(context, 'price_label'),
                      style: TextStyle(color:Colors.white70,fontSize: 18,
                      fontFamily: 'Newsreader')),
                ),
              ],
            ),
            SizedBox(height: 30),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               SizedBox(width:10),
               sideLabels(min.toInt()),
               Expanded(
                 child: RangeSlider(
                   min:min,
                   max:max,
                   values:savedFiltersProvider.selectedValues,
                   labels: labels,
                   activeColor:mainColor,
                   inactiveColor:Colors.white70,
                   divisions: max.toInt(),
                   onChanged: (value){
                     setState(() {
                       //set the values of price rang in the provider
                   savedFiltersProvider.setRangeOfPrice(value);
                   labels=RangeLabels('\$ ${savedFiltersProvider.selectedValues.start.toInt()}',
                       '\$  ${savedFiltersProvider.selectedValues.end.toInt()}');
                      print(savedFiltersProvider.selectedValues);
                     });
                   },
                 ),
               ),
               sideLabels(max.toInt()),
               SizedBox(width:10),
             ],
           ),
            SizedBox(height: MediaQuery.of(context).size.height*0.2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                submitButton(getTranslatedValues(context, 'discard_label'),(){
                 filterListProvider.setFilteredList(totalList);
                 Navigator.pushNamed(context, ProductsPage.id);
                 savedFiltersProvider.resetValues();
                }),
                SizedBox(width: MediaQuery.of(context).size.width*0.1),
                submitButton(getTranslatedValues(context, 'apply_label'),(){
                  setFilterList(filterListProvider, savedFiltersProvider);
                  Navigator.pushNamed(context, ProductsPage.id);
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
// Widget to filter the data based on the checked box
  Iterable<Widget> get filterWidget sync*{
    //Defining the provider to save selected category
    SavedFiltersProvider savedFiltersProvider=Provider.of<SavedFiltersProvider>(context);
    //get the local language of our app
    final Locale appLocale = Localizations.localeOf(context);
    List<String> localProductList=List.empty(growable: true);
    //If the app language is English declare an English Filter List
    if(appLocale.languageCode=='en'){
      localProductList=productCategory;
      //If the app language is Arabic declare an Arabic Filter List
    }else if(appLocale.languageCode=='ar'){
      localProductList=productArabicCategory;
    }
        for(String category in localProductList){
          yield Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: FilterChip(
              labelPadding: EdgeInsets.all(5),
              elevation: 0,
              selectedColor: mainColor,
              checkmarkColor: secondColor,
              label: Text(category,style: TextStyle(fontFamily: 'Newsreader',
              fontSize: 15),),
              selected: savedFiltersProvider.filtersList.contains(category),
              onSelected: (bool selected){
                setState(() {
                  if(selected){
                    // CategorySharedPreferences.setCategoryFilter(filtersList);

                    //Using the FilterList in Provider to set the values
                    if(savedFiltersProvider.filtersList.contains(category)==false)
                    {
                  savedFiltersProvider.setFilterList(category);
                }
              }else{
                    // CategorySharedPreferences.setCategoryFilter(filtersList);
                    //Using the FilterList in Provider to set the values
                    if(savedFiltersProvider.filtersList.contains(category)) {
                  savedFiltersProvider.removeFromFilterList(category);
                }
              }
                });
              },
            ),
          );
        }

  }
  //Function to set labels for the slider range
  sideLabels(int label) {
    return Text(
      '\$ $label',
      style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold,
      fontFamily: 'Newsreader',fontSize: 18),
    );
  }

  // Function to set filter list for the main page
  setFilterList(ProviderController filterProvider,
      SavedFiltersProvider savedFiltersProvider) {
    List<Product> localListForProvider = List.empty(growable: true);
    //Get selectedValues from SavedFilterProvider
    RangeValues rangeLocalValues=savedFiltersProvider.selectedValues;
    //Get filterList from SavedFilterProvider
    List<String> localFilterListFromProvider=savedFiltersProvider.filtersList;
    int lengthOfList = localFilterListFromProvider.length;
    //Filter data based on the price
    if (rangeLocalValues.start.toInt() <rangeLocalValues.end.toInt()) {
        localListForProvider=totalList.where
          ((element) => element.pPrice>=rangeLocalValues.start.toInt()&&
            element.pPrice<=rangeLocalValues.end.toInt()).toList();
    } else if (rangeLocalValues.start.toInt() ==
        rangeLocalValues.end.toInt()) {
      // return data where the value is one value
      localListForProvider=totalList.where((element) =>
      element.pPrice==rangeLocalValues.start.toInt()).toList();
    }
    //filter data based on the category
    if (lengthOfList == 1) {
      if (localFilterListFromProvider.contains('Battery') ||
          localFilterListFromProvider.contains('بطارية'))
      {
        filterProvider.setFilteredList(localListForProvider
            .where((element) => element.pCategory == pCategoryBattery)
            .toList());
        //filter on the Laptop Category
      } else if (localFilterListFromProvider.contains('Laptop') ||
          localFilterListFromProvider.contains('لابتوب'))
      {
        filterProvider.setFilteredList(localListForProvider
            .where((element) => element.pCategory == pCategoryLaptop)
            .toList());
      }
    } else {
      filterProvider.setFilteredList(localListForProvider);
    }
  }
  Widget submitButton(String label,Function func) {
    return GestureDetector(
        onTap:(){
          func();
           },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: mainColor
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              label,
              style: TextStyle(
                  color: Colors.white70, fontSize: 15, fontFamily: 'Newsreader'),
            ),
          ),
        )
    );
  }
}
