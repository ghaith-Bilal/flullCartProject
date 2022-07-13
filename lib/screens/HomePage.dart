import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_cart_project/Provider/providerController.dart';
import 'package:full_cart_project/localization/demo_localization.dart';
import 'package:full_cart_project/localization/localization_constants.dart';
import 'package:full_cart_project/model/productModel.dart';
import 'package:full_cart_project/constant/constants.dart';
import 'package:full_cart_project/constant/listOfData.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:full_cart_project/model/userModel.dart';
import 'package:full_cart_project/screens/cartScreen.dart';
import 'package:full_cart_project/screens/detailsPage.dart';
import 'package:full_cart_project/screens/ProductsPage.dart';
import 'package:full_cart_project/screens/languagePage.dart';
import 'package:full_cart_project/screens/loginPage.dart';
import 'package:full_cart_project/userSharedPreferences.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static String id = 'GridViewPage';

  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  int _quantity;
  int _quantityOnBasket;
  int _tapBarIndex = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex;

  // CartItemProvider cartItemProvider=CartItemProvider();
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _quantity=1;
    _quantityOnBasket=0;
    getQuantity();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }
  //Function to get the quantity of basket from sharedPreferences
  void getQuantity()async{
   await UserPreferences.getBasketQuantity().then((value) {
      setState(() {
       _quantityOnBasket=value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ProviderController cartItemListFromProvider =
    Provider.of<ProviderController>(context);
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        top: true,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: secondColor,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      getTranslatedValues(context,"home_drawer"),
                      style: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'Newsreader',
                          fontSize: 18),
                    ),
                  ),
                ),
                CustomListTile(Icons.home,  getTranslatedValues(context,
                    "products_page_label"), () {
                  Navigator.pushNamed(context, ProductsPage.id);
                }),
                Divider(),
                CustomListTile(Icons.notifications_active,
                    getTranslatedValues(context,"notifications_drawer"),() {
                  // Navigation to notification page
                }),
                Divider(),
                CustomListTile(Icons.phone,
                    getTranslatedValues(context,"contact_us"), () {
                  // Navigation to contact us page
                }),
                Divider(),
                (UserPreferences.loggedIn)
                    ? CustomListTile(Icons.logout,
                    getTranslatedValues(context,"log_out"), () {
                        dialogWidget(context);
                      })
                    : Container(),
                Divider(),
                CustomListTile(Icons.language,
                    getTranslatedValues(context,"language"), () {
                  // Navigation to Language Page
                  Navigator.pushNamed(context, LanguagePage.id);
                }),
              ],
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: (UserPreferences.loggedIn)
                ? Text(
                    '${getTranslatedValues(context, 'welcome_title')}'
                        ' ${UserPreferences.thisUser.firstName.toUpperCase()}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Newsreader'),
                  )
                : Text(
                    getTranslatedValues(context, 'grid_title'),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Newsreader'),
                  ),
            actions: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, LoginPage.id);
                      },
                      child: Icon(Icons.person, color: Colors.white,size: 30,)),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, CartScreen.id);
                        },
                        child: Stack(
                          children: <Widget>[
                            Icon(Icons.shopping_cart, color: Colors.white,size: 30,),
                            Positioned(
                              bottom:0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:mainColor,
                                    ),

                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text('$_quantityOnBasket'
                                        ,style: TextStyle(
                                        fontSize:15
                                      ),),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                    ),
                  ),
                ],
              )
            ],
            backgroundColor: secondColor,
            bottom: TabBar(
              indicatorWeight: 3.0,
              indicatorColor: mainColor,
              onTap: (value) {
                setState(() {
                  _tapBarIndex = value;
                  print(_tapBarIndex);
                });
              },
              tabs: <Widget>[
                Text(
                  getTranslatedValues(context, 'tap1'),
                  style: TextStyle(
                      color: _tapBarIndex == 0
                          ? mainColor
                          : Colors.white.withOpacity(0.5),
                      fontSize: _tapBarIndex == 0 ? 16 : null,
                      fontFamily: 'Newsreader'),
                ),
                Text(getTranslatedValues(context, 'tap2'),
                    style: TextStyle(
                        color: _tapBarIndex == 1
                            ? mainColor
                            : Colors.white.withOpacity(0.5),
                        fontSize: _tapBarIndex == 1 ? 16 : null,
                        fontFamily: 'Newsreader')),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              listViewOfProducts(listOfLaptops,cartItemListFromProvider),
              listViewOfProducts(listOfBattery,cartItemListFromProvider)
            ],
          ),
        ),
      ),
    );
  }

  Widget listViewOfProducts(List<Product> listOfProducts,ProviderController cartList) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(getTranslatedValues(context, 'carousel_title'),
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Newsreader',
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          carouselWidget(context, imagesForLaptops, 4),
          SizedBox(
            height: 20,
          ),
          Text(getTranslatedValues(context, 'horizontal_list'),
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Newsreader',
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(
            height: MediaQuery.of(context).size.height * 0.22,

            //Horizontal listView

            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, DetailsPage.id,
                            arguments: listOfProducts[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Container(
                          width: 200,
                          height: 300,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: secondColor, width: 3)),
                          child: Column(
                            children: [
                              Image(
                                fit: BoxFit.fill,
                                width: 200,
                                height: 100,
                                image: AssetImage(listOfProducts[index].pImage),
                              ),
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: secondColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            child: Text(
                                                '${getTranslatedValues(context, 'brand_title')} : '
                                                '${listOfProducts[index].pName}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontFamily: 'Newsreader')),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            child: Text(
                                                '${getTranslatedValues(context,
                                                    'price_title')}'
                                                    ' : ${listOfProducts[index].pPrice}\$',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontFamily: 'Newsreader')),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        child: GestureDetector(
                                          onTap: () async{
                                            //Add To Cart
                                            DateTime cartTime=DateTime.now();
                                            addToItem(cartList,listOfProducts[index]);
                                            await UserPreferences.setTimeOfAddingProduct(
                                                cartTime.toString());
                                          },
                                          child: ClipOval(
                                            child: Container(
                                              color:mainColor,
                                                child: Icon(Icons.add, size: 30, color: Colors.white)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ));
                }),
          ),
          SizedBox(
            height: 20,
          ),
          Text(getTranslatedValues(context, 'carousel_title'),
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Newsreader',
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          carouselWidget(context, imagesForBatteries, 3),
          SizedBox(
            height: 20,
          ),
          Text(getTranslatedValues(context, 'grid_view_title'),
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Newsreader',
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          gridViewOfProducts(listOfProducts,cartList)
        ],
      ),
    );
  }

  Widget gridViewOfProducts(List<Product> productsMenu,ProviderController cartList) {
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 1,
          crossAxisSpacing: 4,
          crossAxisCount: 2,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, DetailsPage.id,
                  arguments: productsMenu[index]);
            },
            child:Container(
              decoration: BoxDecoration
                (borderRadius: BorderRadius.circular(5),
            border: Border.all(color: secondColor, width: 3)) ,
              child: Column(
                children: <Widget>[
                  Image(
                    fit: BoxFit.fill,
                    width: 200,
                    height: 100,
                    image: AssetImage(productsMenu[index].pImage),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: secondColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                    '${getTranslatedValues(context, 'brand_title')} : '
                                        '${productsMenu[index].pName}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Newsreader')),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                    '${getTranslatedValues(context,
                                        'price_title')}'
                                        ' : ${productsMenu[index].pPrice}\$',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Newsreader')),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: GestureDetector(
                              onTap: () async{
                                //Add To Cart
                                DateTime cartTime=DateTime.now();
                                addToItem(cartList,productsMenu[index]);
                                await UserPreferences.setTimeOfAddingProduct(cartTime.toString());
                              },
                              child: ClipOval(
                                child: Container(
                                    color:mainColor,
                                    child: Icon(Icons.add, size: 30, color: Colors.white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget carouselWidget(
      BuildContext context, List<String> offers, int duration) {
    return CarouselSlider(
        items: offers.map((imageContent) {
          return Builder(builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                imageContent,
                fit: BoxFit.fill,
              ),
            );
          });
        }).toList(),
        options: CarouselOptions(
            autoPlayInterval: Duration(seconds: duration),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
            height: MediaQuery.of(context).size.height * 0.3,
            autoPlay: true,
            initialPage: 0));
  }

  dialogWidget(context) {
    Widget confirmDialog() {
      return Container(
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: GestureDetector(
          onTap: () async {
            await UserPreferences.setLoggedIn(false);
            await UserPreferences.setUser(User());
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(getTranslatedValues(context, 'log_out'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white70,
                    fontFamily: 'Newsreader')),
          ),
        ),
      );
    }

    Widget cancelDialog() {
      return Container(
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(getTranslatedValues(context, 'cancel_dialog'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white70,
                    fontFamily: 'Newsreader')),
          ),
        ),
      );
    }

    AlertDialog alert = AlertDialog(
      title: Text(getTranslatedValues(context, 'warning'),
          style: TextStyle(color: Colors.red, fontFamily: 'Newsreader')),
      content: Text(
          getTranslatedValues(context, 'log_out_dialog_content'),
          style: TextStyle(
              color: Colors.black, fontFamily: 'Newsreader', fontSize: 16)),
      actions: [
        confirmDialog(),
        SizedBox(
          width: 10,
        ),
        cancelDialog()
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }
  //Function  to set quantity and call addToCart function
  addToItem(ProviderController cartList,Product product) {
    setState(() {
      // _quantity++;
     _quantityOnBasket=_quantityOnBasket+1;
     print(_quantityOnBasket);
     //saved the quantity of the adding items in the memory
      UserPreferences.setQuantityOfBasket(_quantityOnBasket);
      addToCart(context,cartList,product);
    });
  }
  //Function for adding Products to the cart
  addToCart(context,ProviderController cartItem,Product product){
    int valueOfQuantity = _quantity;
    //if the item is added
    if(checkedForProduct(cartItem,product)){
      for (int i = 0; i < cartItem.cartItemsFromProvider.length; i++){
        if (cartItem.cartItemsFromProvider[i].pName ==
            product.pName){
          cartItem.cartItemsFromProvider[i].pQuantity++;
          UserPreferences.addToStoredCart(product,productIsExist: true
              ,positionOfProduct: i
              ,providerCarts: cartItem.cartItemsFromProvider);
        }
      }
      //adding for the first time
    }else {
      product.pQuantity=valueOfQuantity;
      cartItem.addItem(product);
    }
    for(int i=0;i<cartItem.cartItemsFromProvider.length;i++)
      {
        print(cartItem.cartItemsFromProvider[i].pQuantity);
      }
  }
  //Function to check if the product has added before
  bool checkedForProduct(ProviderController itemList, Product product) {
    List<Product> productList = itemList.cartItemsFromProvider;
    int itemIsExist = 0;
    productList.forEach((element) {
      if (element.pName == product.pName) itemIsExist = itemIsExist + 1;
    });
    if (itemIsExist > 0) {
      return true;
    } else {
      return false;
    }
  }
}

//List Tile For Drawer
// ignore: must_be_immutable
class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: InkWell(
        onTap: onTap,
        splashColor: secondColor.withOpacity(0.5),
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(icon, color: Colors.black),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 16, fontFamily: 'Newsreader'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
