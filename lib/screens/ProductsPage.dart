import'package:flutter/material.dart';
import 'package:full_cart_project/Provider/providerController.dart';
import 'package:full_cart_project/constant/constants.dart';
import 'package:full_cart_project/constant/listOfData.dart';
import 'package:full_cart_project/localization/localization_constants.dart';
import 'package:full_cart_project/model/productModel.dart';
import 'package:full_cart_project/screens/detailsPage.dart';
import 'package:full_cart_project/screens/filterPage.dart';
import 'package:full_cart_project/screens/HomePage.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget{
  static String id='Home Page';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductsPage();
  }

}
class _ProductsPage extends State<ProductsPage>{
  List<Product> localList;
  List <String> sortingList=['Name:A-Z','Name:Z-A',
    'Price:lowest to high','Price:highest to low',
    'Default'];
  List <String> sortingArabicList=['الاسم:حسب الترتيب الأبجدي',
    'الاسم:عكس الترتيب الأبجدي',
    'السعر:من الأخفض إلى الأعلى',
    'السعر:من الأعلى إلى الأخفض',
    'افتراضي'];
  String currentValue;
  String currentArabicValue;
  @override
  void initState() {
      super.initState();
      currentValue='Default';
      currentArabicValue='افتراضي';
  }
  @override
  Widget build(BuildContext context) {
    //Variable to get the language of the app
    final Locale appLocale = Localizations.localeOf(context);
    ProviderController filterProviderController
    =Provider.of<ProviderController>(context);
    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
        title: Text(getTranslatedValues(context, 'products_page_label'),
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'Newsreader'
        ),),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
    Navigator.pushReplacementNamed(context, HomePage.id);})
      ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      Row(
                        children: [
                          IconButton(icon:Icon(Icons.filter_alt_sharp,size: 20,),
                              onPressed: (){
                                Navigator.pushNamed(context, FilterPage.id);
                              },
                              iconSize: 20,
                              color: Colors.black),
                          Text(getTranslatedValues(context, 'filter_label'),style: TextStyle(
                              fontFamily: 'Newsreader',
                              fontSize: 18,
                              color:Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                          )
                        ],
                      ),
                        (appLocale.languageCode=='ar')?
                        PopupMenuButton<String>(
                          itemBuilder: (context){
                            return sortingArabicList.map((item) {
                              return PopupMenuItem(
                                  value: item,
                                  child:Row(
                                    children: [
                                      Text(item),
                                      SizedBox(width: 6),
                                      (item==currentArabicValue)?Icon(Icons.check):Container()
                                      ,
                                    ],
                                  ));
                            }).toList();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                             Text(getTranslatedValues(context, 'sort_by'),
                                 style: TextStyle(
                                    fontFamily: 'Newsreader',
                                    fontSize: 18,
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold
                                )
                                ),
                                Icon(Icons.sort)
                              ],
                            ),
                          ),
                          onSelected: (value){
                            setState(() {
                              currentArabicValue=value;
                              sortingListArabicPopUp(currentArabicValue,localList);
                            });
                          },
                        )
                            :PopupMenuButton<String>(
                         itemBuilder: (context){
                           return sortingList.map((item) {
                             return PopupMenuItem(
                                 value: item,
                             child:Row(
                               children: [
                                 Text(item),
                                 SizedBox(width: 6),
                                 (item==currentValue)?Icon(Icons.check):Container()
                                 ,
                               ],
                             ));
                           }).toList();
                         },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(getTranslatedValues(context, 'sort_by'),
                                    style: TextStyle(
                                fontFamily: 'Newsreader',
                                fontSize: 18,
                                color:Colors.black,
                                fontWeight: FontWeight.bold
                                )
                                ),
                                Icon(Icons.sort)
                              ],
                            ),
                          ),
                          onSelected: (value){
                           setState(() {
                             currentValue=value;
                             sortingListEnglishPopUp(currentValue,localList);
                           });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
           listViewWidget(filterProviderController)
        ],
      ),
    )
    );
  }

  Widget listViewWidget(ProviderController providerController) {
    localList=providerController.filteredListFromProvider;
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
        itemCount: localList.length,
        itemBuilder: (context,index){
          return GestureDetector(
            onTap: (){
              //Navigate to detailsPage
              Navigator.pushNamed(context, DetailsPage.id,
                  arguments: localList[index]);
            },
            child:  Container(
              height: 100,
              decoration: BoxDecoration(
                color: secondColor,
                border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5)
                ),
                margin: EdgeInsets.symmetric( horizontal:1,vertical: 2),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${getTranslatedValues(context,'brand_title')}: '
                                  '${localList[index].pName}',
                              style: TextStyle
                                (
                                  fontSize: 18,
                              color: Colors.white70,fontFamily: 'Newsreader'),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${getTranslatedValues(context,'price_title')}:'
                                  ' ${localList[index].pPrice}\$',
                              style: TextStyle(
                                  fontSize: 18,
                              color:Colors.white70,
                              fontFamily: 'Newsreader'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: 100,
                          width:100 ,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image:DecorationImage(
                              image:AssetImage(
                                  localList[index].pImage,),
                              fit: BoxFit.cover
                            ),
                            border: Border.all(
                                color: Colors.black, width: 1),
                          ),
                      )
                    ],
                  ),
                )),
          );
        }
    );
  }
}
// Function to sorting data according to the arabic pop up menu
void sortingListArabicPopUp(String currentArabicValue, List<Product> localList) {
  switch(currentArabicValue){
    case 'الاسم:حسب الترتيب الأبجدي':
      localList.sort((a,b)=>a.pName.compareTo(b.pName));
      break;
    case 'الاسم:عكس الترتيب الأبجدي':
      localList.sort((a,b)=>b.pName.compareTo(a.pName));
      break;
    case 'السعر:من الأخفض إلى الأعلى':
      localList.sort((a,b)=>a.pPrice.compareTo(b.pPrice));
      break;
    case 'السعر:من الأعلى إلى الأخفض':
      localList.sort((a,b)=>b.pPrice.compareTo(a.pPrice));
      break;
    default:
      localList.shuffle();
      break;
  }
}
// Function to sorting data according to the english popUp menu
void sortingListEnglishPopUp(String currentValue, List<Product> localList) {
  switch(currentValue){
    case 'Name:A-Z':
      localList.sort((a,b)=>a.pName.compareTo(b.pName));
      break;
    case 'Name:Z-A':
      localList.sort((a,b)=>b.pName.compareTo(a.pName));
      break;
    case 'Price:lowest to high':
      localList.sort((a,b)=>a.pPrice.compareTo(b.pPrice));
     break;
    case 'Price:highest to low':
      localList.sort((a,b)=>b.pPrice.compareTo(a.pPrice));
    break;
    default:
      localList.shuffle();
      break;
  }
}