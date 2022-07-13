import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_cart_project/constant/constants.dart';
import 'package:full_cart_project/localization/localization_constants.dart';
import 'package:full_cart_project/model/userModel.dart';
import 'package:full_cart_project/screens/HomePage.dart';
import 'package:full_cart_project/screens/loginPage.dart';
import 'package:full_cart_project/userSharedPreferences.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  static String id='RegisterPage';
  @override
  State<StatefulWidget> createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController checkPasswordController = TextEditingController();
  bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  Future createUser(String firstName, String lastName, String phone,
      String email, String password, String checkPassword) async {
    setState(() {
      _isLoading = true;
    });
    final String apiURL = 'http://parachute-group.com/api/auth/create-account';
    final response = await http.post(Uri.parse(apiURL), body: {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password,
      "c_password": checkPassword,
      "phone": phone,
      "location_id": '1',
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      User user=User(firstName: firstName,lastName:lastName ,email: email,phone:
      phone);
      await UserPreferences.setUser(user);
      await UserPreferences.setLoggedIn(true);
      setState(() {
        _isLoading = false;
        Navigator.pushReplacementNamed(context, HomePage.id);
      });

    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
          body: (_isLoading)
              ? Center(child: CircularProgressIndicator())
              : Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        introLabel(context),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    firstNameInput(context),
                    lastNameInput(context),
                    phoneInput(context),
                    emailInput(context),
                    passwordInput(context),
                    checkPasswordInput(context),
                    SizedBox(
                      height: 14,
                    ),
                    submitButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget firstNameInput(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: firstNameController,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.name,
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
                    child: Icon(Icons.person, color: Colors.white70),
                  ),
                ),
                fillColor: Colors.white70,
                filled: true,
                hintText: getTranslatedValues(context, 'name_label')),
            textInputAction: TextInputAction.next,
            validator: (name) {
              Pattern pattern = r'^[A-Za-z0-9ء-ي]+(?:[ _-][A-Za-z0-9ء-ي]+)*$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(name))
                return getTranslatedValues(context, 'invalid_first_name');
              else
                return null;
            },
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  Widget lastNameInput(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: lastNameController,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.name,
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
                    child: Icon(Icons.person, color: Colors.white70),
                  ),
                ),
                fillColor: Colors.white70,
                filled: true,
                hintText: getTranslatedValues(context, 'last_name_label')),
            textInputAction: TextInputAction.next,
            validator: (name) {
              Pattern pattern = r'^[A-Za-z0-9ء-ي]+(?:[ _-][A-Za-z0-9ء-ي]+)*$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(name))
                return getTranslatedValues(context, 'invalid_last_name');
              else
                return null;
            },
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  Widget phoneInput(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: phoneNumberController,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.phone,
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
                    child: Icon(Icons.phone, color: Colors.white70),
                  ),
                ),
                fillColor: Colors.white70,
                filled: true,
                hintText: getTranslatedValues(context,'phone_number_label')),
            textInputAction: TextInputAction.next,
            validator: (name) {
              Pattern pattern = r'^(?:[+0]9)?[0-9]{7,20}$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(name))
                return getTranslatedValues(context, 'Invalid_Phone_Number');
              else
                return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget emailInput(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) {
              setState(() {});
            },
            controller: emailController,
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
                hintText:  getTranslatedValues(context,'email_placeHolder')),
            textInputAction: TextInputAction.next,
            validator: (email) =>
            EmailValidator.validate(email) ? null :
            getTranslatedValues(context, 'invalid_email_address'),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  Widget passwordInput(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: passwordController,
            decoration:InputDecoration(
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
                filled: true,
                hintText: getTranslatedValues(context,'password_placeHolder')),
            textInputAction: TextInputAction.next,
            onChanged: (_) {
              setState(() {});
            },
            validator: (password) {
              Pattern pattern = r'^([a-zA-Z0-9*.!@$%^&():;<>,?~_+-=]{8,})$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(password)) {
                AlertDialog alert = AlertDialog(
                  title: Text(
                    getTranslatedValues(context, 'warning'),
                    style: TextStyle(color: Colors.red),
                  ),
                  content: Text(getTranslatedValues(context,
                      'content_of_warning_label')),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          getTranslatedValues(context, 'got_it_label'),
                        ))
                  ],
                );
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    });
                return getTranslatedValues(context, 'invalid_password');
              } else
                return null;
            },
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  Widget checkPasswordInput(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: checkPasswordController,
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
                filled: true,
                hintText:  getTranslatedValues(context,'confirm_pass_label')),
            textInputAction: TextInputAction.done,
            onChanged: (_) {
              setState(() {});
            },
            validator: (password) {
              if (checkPasswordController.text.toString() ==
                  passwordController.text.toString()) {
                return null;
              } else {
                return getTranslatedValues(context, 'match_password');
              }
            },
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return GestureDetector(
        onTap: (firstNameController.text != '' &&
            lastNameController.text != '' &&
            phoneNumberController.text != '' &&
            emailController.text != '' &&
            passwordController.text != '' &&
            checkPasswordController.text != '')
            ? () async {
          if (_formKey.currentState.validate()) {
            if (passwordController.text.toString() ==
                checkPasswordController.text.toString()) {
              _formKey.currentState.save();
              await createUser(
                  firstNameController.text,
                  firstNameController.text,
                  phoneNumberController.text,
                  emailController.text,
                  passwordController.text,
                  checkPasswordController.text);
            }
          }
        }
            : null,
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: (firstNameController.text != '' &&
                  lastNameController.text != '' &&
                  phoneNumberController.text != '' &&
                  emailController.text != '' &&
                  passwordController.text != '' &&
                  checkPasswordController.text != '')
                  ? mainColor
                  : mainColor.withOpacity(0.6)),
          child: Text(
            getTranslatedValues(context,'create_new_account'),
            style: TextStyle(
                color: Colors.white70, fontSize: 20, fontFamily: 'Newsreader'),
          ),
        ));
  }
}

Widget introLabel(BuildContext context) {
  return Text(getTranslatedValues(context, 'register_label'),
      style: TextStyle(
          fontSize: 35,
          fontFamily: 'Newsreader',
          color: Colors.white70));
}
