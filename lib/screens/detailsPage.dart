import 'package:flutter/material.dart';
import 'package:full_cart_project/Provider/providerController.dart';
import 'package:full_cart_project/constant/constants.dart';
import 'package:full_cart_project/localization/localization_constants.dart';
import 'package:full_cart_project/model/productModel.dart';
import 'package:full_cart_project/screens/cartScreen.dart';
import 'package:full_cart_project/userSharedPreferences.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  static String id = 'DetailsPage';

  @override
  State<StatefulWidget> createState() {
    return _DetailsPage();
  }
}

class _DetailsPage extends State<DetailsPage> {
  int _quantity;
  int _quantityOnBasket;

  @override
  void initState() {
    super.initState();
    _quantity = 1;
    ProviderController cartItemProvider = ProviderController();
  }

  @override
  Widget build(BuildContext context) {
    ProviderController cartItemFromProvider =
        Provider.of<ProviderController>(context);
    Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text( getTranslatedValues(context,'details_title')),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .3,
                  child: Image(
                    fit: BoxFit.fill,
                    image: AssetImage(product.pImage),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' ${getTranslatedValues(context,'type_of_brand')}: '
                            '${getTranslatedValues(context,'tap1')}',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontFamily: 'Newsreader'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      (product.pCategory==pCategoryLaptop)? Text(
                        '${getTranslatedValues(context,'description')}: '
                            '${getTranslatedValues(context,'pLapDescription')}',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontFamily: 'Newsreader'),
                      ):
                      Text(
                        '${getTranslatedValues(context,'description')}:'
                            ' ${getTranslatedValues(context,'pBatDescription')}',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontFamily: 'Newsreader'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${getTranslatedValues(context,'price_title')}:'
                            ' ${product.pPrice}\$',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontFamily: 'Newsreader'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          add();
                        });
                      },
                      child: ClipOval(
                        child: Container(
                            color: secondColor,
                            child:
                                Icon(Icons.add, size: 30, color: Colors.white)),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        SizedBox(height: 5),
                        Text(
                          _quantity.toString(),
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Newsreader',
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          sub();
                        });
                      },
                      child: ClipOval(
                        child: Container(
                            color: secondColor,
                            child: Icon(Icons.remove,
                                size: 30, color: Colors.white)),
                      ),
                    )
                  ],
                )
              ],
            ),
            Positioned(
                bottom: 15,
                left: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: secondColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Builder(
                            builder: (context) => GestureDetector(
                              onTap: () async {
                                addToCart(
                                    context, cartItemFromProvider, product);
                                DateTime cartTime = DateTime.now();
                                await UserPreferences.setTimeOfAddingProduct(
                                    cartTime.toString());
                              },
                              child: Text(
                               getTranslatedValues(context, 'add_to_cart'),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, CartScreen.id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Icon(
                              Icons.shopping_cart_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ));
  }

  void add() {
    setState(() {
      _quantity++;
    });
  }

  void sub() {
    setState(() {
      if (_quantity > 0 && _quantity!=1) _quantity--;
    });
  }

  void addToCart(context, ProviderController cartItem, Product product) {
    int valueOfQuantity = _quantity;
    if (checkedForProduct(cartItem, product)) {
      print('addToProduct1');
      AlertDialog alert = AlertDialog(
        title: Text(
          'Warning!',
          style: TextStyle(color: Colors.red,fontFamily: 'Newsreader'),
        ),
        content: Text('This Product has added to the cart before!',
          style: TextStyle(color:Colors.white70,fontFamily: 'Newsreader',
              fontSize: 16),),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: secondColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    for (int i = 0; i < cartItem.cartItemsFromProvider.length;
                        i++) {
                      if (cartItem.cartItemsFromProvider[i].pName ==
                          product.pName) {
                        cartItem.cartItemsFromProvider[i].pQuantity =
                            valueOfQuantity;
                        UserPreferences.addToStoredCart(product,
                            positionOfProduct: i,
                            providerCarts: cartItem.cartItemsFromProvider,
                            productIsExist: true);
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    'save changes anyway',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,
                    color:Colors.white70,fontFamily: 'Newsreader'),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: secondColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'cancel',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,
                        color:Colors.white70,fontFamily: 'Newsreader'),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    } else {
      print('addToProduct2');
      print(cartItem.cartItemsFromProvider.contains(product));
      product.pQuantity = valueOfQuantity;
      cartItem.addItem(product);
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('Added To Cart ${cartItem.cartItemsFromProvider[0].pName}'),
      ));
    }
  }

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
