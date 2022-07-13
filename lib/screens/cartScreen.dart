import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_cart_project/Provider/providerController.dart';
import 'package:full_cart_project/constant/constants.dart';
import 'package:full_cart_project/localization/localization_constants.dart';
import 'package:full_cart_project/model/productModel.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static String id = 'CartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  TextEditingController textNumberController=TextEditingController();
  @override
  void initState() {
    super.initState();
    ProviderController cartItemProvider = ProviderController();
  }

  @override
  Widget build(BuildContext context) {
    textNumberController.text='1';
    List<Product> listForCartProducts =
        Provider.of<ProviderController>(context).cartItemsFromProvider;
    ProviderController cartItem = Provider.of<ProviderController>(context);
    final double heightSize = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslatedValues(context, 'cart_title')),
          centerTitle: true,
        ),
        body: (listForCartProducts.isNotEmpty)
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: listForCartProducts.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black54),
                                color: secondColor,
                              ),
                              // height: heightSize * 0.1,
                              child: Row(
                                children: [
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Brand',
                                            style: TextStyle(
                                                fontFamily: 'Newsreader',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          SizedBox(width: 10,),
                                          Text(
                                            'Price',
                                            style: TextStyle(fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Newsreader'),
                                          ),
                                          SizedBox(width: 10,),
                                          Text(
                                            'Quantity',
                                            style: TextStyle(fontSize: 16,
                                                fontFamily: 'Newsreader',
                                              fontWeight: FontWeight.bold,),
                                          ),
                                          SizedBox(width: 10,),
                                          Text(
                                            'Subtotal',
                                            style: TextStyle(fontSize: 16,
                                                fontFamily: 'Newsreader',
                                              fontWeight: FontWeight.bold,),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            listForCartProducts[index].pName,
                                            style: TextStyle(
                                                fontFamily: 'Newsreader',
                                                fontSize: 16),
                                          ),
                                          SizedBox(width: 10,),
                                          Text(
                                            '\$ ${listForCartProducts[index].pPrice}',
                                            style: TextStyle(fontSize: 16,
                                              fontFamily: 'Newsreader',
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Container(
                                            width:50,
                                            height:40,
                                            child: TextFormField(
                                              controller: textNumberController,
                                              keyboardType: TextInputType.number,
                                              onChanged: (_){
                                                //save the value
                                                setState(() {

                                                });
                                              },
                                              decoration: InputDecoration(
                                                // hintStyle: TextStyle
                                                //   (height: 1.4,color:Colors.black54,fontFamily: 'Newsreader'),
                                                  enabledBorder: UnderlineInputBorder(
                                                      borderRadius: BorderRadius.circular(2),
                                                      borderSide: BorderSide(color: Colors.grey)),
                                                  focusedBorder: UnderlineInputBorder(
                                                      borderRadius: BorderRadius.circular(2),
                                                      borderSide: BorderSide(color: Colors.grey)),
                                                  fillColor: Colors.white70,
                                                  filled: true,
                                                  hintText:
                                                  listForCartProducts[index].pQuantity.toString()),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Text(
                                            '\$ ${listForCartProducts[index].pPrice}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        cartItem.removeItem(
                                            listForCartProducts[index]);
                                      },
                                      child: ClipOval(
                                        child: Container(
                                            color: Colors.white,
                                            child: Icon(
                                              Icons.delete,
                                              size: 30,
                                              color: Colors.red,
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                  ],
                ),
              )
            : Center(
           child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    getTranslatedValues(context, 'cart_label'),
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 6,),
                  Icon(FontAwesomeIcons.sadTear)
                ],
              ),
            ));
  }
}
