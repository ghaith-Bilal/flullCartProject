import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:full_cart_project/localization/localization_constants.dart';
import 'package:full_cart_project/screens/HomePage.dart';
import 'package:full_cart_project/screens/loginFacebook.dart';
import 'package:full_cart_project/screens/registerPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:full_cart_project/userSharedPreferences.dart';
import 'package:full_cart_project/model/userModel.dart';
import '../constant/constants.dart';
class LoginPage extends StatefulWidget {
  static String id = 'HomePage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String apiURL = 'http://parachute-group.com/api/auth/login';
  final String apiURL2 = 'http://parachute-group.com/api/auth/user';
  final _formKey = GlobalKey<FormState>();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  bool isLoading;
  Future<User> logIn(String userEmail, String password, BuildContext context) async {
    print('here');
    setState(() {
      isLoading=true;
    });
    final response = await http.post(Uri.parse(apiURL), body: {
      'password': password,
      'email': userEmail,
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map token = json.decode(response.body);
      String mapToken = token['success']['token'];
      final response2 = await http.get(
          Uri.parse(apiURL2),
          headers: {'Authorization': 'Bearer $mapToken'});
      final data = json.decode(response2.body);
      print('this is data${data['success']['first_name']}');
      User user = User.fromJson({
        "first_name": data['success']['first_name'],
        "last_name": data['success']['last_name'],
        "email": data['success']['email'],
        "phone": data['success']['phone'],
        "token": mapToken,
      });
      await UserPreferences.setUser(user);
      await UserPreferences.setLoggedIn(true);
      print('success');
      print(UserPreferences.thisUser.firstName);
      // print(UserPreferences.loggedIn);
      setState(() {
        isLoading=false;
      });
      Navigator.pushReplacementNamed(context, HomePage.id);
      return user;
    } else {
      AlertDialog alert2 = AlertDialog(
        title: Text(
          'Wrong',
          style: TextStyle(color: Colors.black),
        ),
        content: Text('invalid information,please check it and try again'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Got it!', style: TextStyle(color: Colors.red)))
        ],
      );
      showDialog(context: context, builder: (BuildContext context) => alert2);
      return null;
    }
  }


  @override
  void initState() {
    super.initState();
    isLoading=false;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: true,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [mainColor, secondColor])
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey,
            child: (isLoading)?Center(
              child: CircularProgressIndicator(),
            ):SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: size.height * 0.05),
                    introLabel(),
                    SizedBox(height: size.height * 0.03),
                    userImage(),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    userName('Email:', context),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    passwordInput('Password', context),
                    SizedBox(height: size.height * 0.03),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: submitButton(context),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: createLabel(),
                    ),
                    SizedBox(height: size.height * 0.03),
                    _divider(),
                    SizedBox(height: size.height * 0.03),
                    facebookWidget(context,size),
                    SizedBox(height: size.height * 0.03),
                    googleWidget(context,size),
                    SizedBox(height: size.height * 0.03),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget userName(String title, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextFormField(
            controller: userEmailController,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintStyle: TextStyle
                (height: 1.4,color:Colors.black54,fontFamily: 'Newsreader'),
                enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.grey)),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CircleAvatar(
                    backgroundColor: mainColor,
                    child: Icon(Icons.email, color: Colors.white70),
                  ),
                ),
                fillColor: Colors.white70,
                filled: true,
                hintText: getTranslatedValues(context, 'email_placeHolder')),
            textInputAction: TextInputAction.next,
            validator: (email) =>
                EmailValidator.validate(email) ? null : "Invalid email address",
          ),
        )
      ],
    );
  }

  Widget passwordInput(String title, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: loginPasswordController,
              decoration: InputDecoration(
                hintStyle: TextStyle
                  (height: 1.4,color:Colors.black54,fontFamily: 'Newsreader'),
                enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.grey)),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CircleAvatar(
                    backgroundColor: mainColor,
                    child: Icon(Icons.lock, color: Colors.white70),
                  ),
                ),
                fillColor: Colors.white70,
                hintText: getTranslatedValues(context, 'password_placeHolder'),
                filled: true,
              ),
              textInputAction: TextInputAction.done,
              onChanged: (_) {
                setState(() {});
              },
              validator: (password) {
                Pattern pattern = r'^([a-zA-Z0-9*.!@$%^&():;<>,?~_+-=]{8,})$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(password)) {
                  AlertDialog alert1 = AlertDialog(
                    title: Text(
                      'Warning!',
                      style: TextStyle(color: placeHolder),
                    ),
                    content: Text('Please change your password\n'
                        'password must have at least 8 characters'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Got it!',
                          ))
                    ],
                  );
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert1;
                      });
                  return 'invalid password';
                } else
                  return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return GestureDetector(
        onTap: (userEmailController.text != '' &&
                loginPasswordController.text != '')
            ? () async{
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  await logIn(userEmailController.text,
                    loginPasswordController.text, context);

          print('hey');

                }
              }
            : null,
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: (userEmailController.text != '' &&
                    loginPasswordController.text != '')
                ? mainColor
                : mainColor.withOpacity(0.6),
          ),
          child: Text(
              getTranslatedValues(context, 'login_button'),
            style: TextStyle(
                color: Colors.white70, fontSize: 20, fontFamily: 'Newsreader'),
          ),
        )
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text(
            getTranslatedValues(context, 'or_label'),
            style: TextStyle(fontFamily: 'Newsreader', fontSize: 18),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget createLabel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(getTranslatedValues(context, 'forgot_password_label'),
            style: TextStyle(
                color: mainColor,
                fontFamily: 'Newsreader',
                fontSize: 15,
                fontWeight: FontWeight.bold)),
        _createAccountLabel(),
      ],
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RegisterPage.id);
      },
      child: Container(
          alignment: Alignment.bottomCenter,
          child: Text(
            getTranslatedValues(context, 'create_account_label'),
            style: TextStyle(
                color: mainColor,
                fontSize: 15,
                fontFamily: 'Newsreader',
                fontWeight: FontWeight.bold),
          )),
    );
  }

  Widget userImage() {
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.indigo,
      child: ClipOval(
        child: Image.asset('images/person.jpg'),
      ),
    );
  }

  Widget introLabel() {
    return Text(getTranslatedValues(context, 'login_title'),
        style: TextStyle(
            fontSize: 35,
            fontFamily: 'Newsreader',
            color: Colors.white70));
  }

  Widget facebookWidget(BuildContext context ,Size size) {
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacementNamed(context, LoginToFaceBook.id);
      },
      child:Container(
        width: size.width * 0.8,
        height: 40,
       decoration: BoxDecoration(
         color: Colors.white,
       borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
        child: Row(
          children: [
            Image.asset('images/facebook.png',width: 60,height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(getTranslatedValues(context,'sign_in_faceBook_label')
                  ,style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontFamily: 'Newsreader'
                ),),
              ],
            )
          ],
        ),
    ));
  }

  Widget googleWidget(BuildContext context, Size size) {
    return GestureDetector(
        onTap: (){
        },
        child:Container(
          width: size.width * 0.8,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            children: [
              Image.asset('images/google.png',width: 60,height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child:Text(getTranslatedValues(context,
                      'sign_in_google_label'),style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontFamily: 'Newsreader'
                    ),
                    )
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
// Container(
// width: size.width * 0.8,
// child: GoogleAuthButton(
// style: AuthButtonStyle(
// elevation: 0,
// iconType: AuthIconType.outlined,
// padding: EdgeInsets.symmetric(vertical: 2),
// separator: 20,
// borderRadius: 5,
// textStyle: TextStyle(

// )
// ),
// onPressed: () {}),
// ),