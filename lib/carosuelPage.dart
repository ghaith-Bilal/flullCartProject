// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:full_cart_project/carousel_pro/src/carousel_pro.dart';
// import 'package:full_cart_project/constant/constants.dart';
// class CarouselPage extends StatefulWidget {
//   static String id='CarouselPageId';
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _CarouselPage();
//   }
//
// }
// class _CarouselPage extends State<CarouselPage>{
//   int _currentIndex=0;
//
//   List<T> map<T>(List list, Function handler) {
//     List<T> result = [];
//     for (var i = 0; i < list.length; i++) {
//       result.add(handler(i, list[i]));
//     }
//     return result;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           CarouselSlider(
//               items: images.map((imageContent){
//                 return Builder(
//                     builder: (BuildContext context){
//                       return Container(
//                         width: MediaQuery.of(context).size.width,
//                         margin: EdgeInsets.symmetric(horizontal: 1),
//                         child:Image.asset(imageContent,fit: BoxFit.fill,),
//                       );
//                     });
//               }).toList()
//               , options:
//           CarouselOptions(
//             autoPlayInterval: Duration(seconds: 3),
//             autoPlayAnimationDuration: Duration(milliseconds: 2000),
//             enlargeCenterPage:true,
//             onPageChanged: (index,reason){
//            setState(() {
//              _currentIndex=index;
//            });
//           },
//             height: MediaQuery.of(context).size.height*0.3,
//             autoPlay: true,
//             initialPage: 0
//
//           )
//           ),
//           SizedBox(height: 20,),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: map<Widget>(images, (index, url) {
//               return Container(
//                 width: 10.0,
//                 height: 10.0,
//                 margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _currentIndex == index ? mainColor : Colors.grey,
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
//   // createAdsCarousel(BuildContext context) {
//   //   for (int i = 1; i <= 2; i++) {
//   //     images.add(Container(
//   //         width: MediaQuery.of(context).size.width,
//   //         margin: const EdgeInsets.symmetric(vertical: 5),
//   //         decoration: BoxDecoration(
//   //             borderRadius: BorderRadius.all(Radius.circular(14.0)),
//   //             color: Colors.white,
//   //             boxShadow: [
//   //               BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 10.0),
//   //             ]),
//   //         child: Padding(
//   //           padding: EdgeInsets.symmetric(vertical: 1),
//   //           child: Row(
//   //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //             children: <Widget>[
//   //               Expanded(
//   //                   child: Image.asset(
//   //                     "images/offers/offer$i.jpg",
//   //                     fit: BoxFit.fill,
//   //                   ))
//   //             ],
//   //           ),
//   //         )));
//   //   }
//   // }
//
//   // Widget advertisementSlider() {
//   //   return Container(
//   //     height: 182,
//   //     child: Carousel(
//   //       boxFit: BoxFit.cover,
//   //       dotColor: secondColor,
//   //       dotSize: 5.5,
//   //       dotSpacing: 16,
//   //       dotBgColor: Colors.transparent,
//   //       showIndicator: true,
//   //       overlayShadow: true,
//   //       overlayShadowColors: Colors.white.withOpacity(0.9),
//   //       overlayShadowSize: 0.9,
//   //       images: adsImages,
//   //     ),
//   //   );
//   // }
//   //
//
// }
//
//
//
