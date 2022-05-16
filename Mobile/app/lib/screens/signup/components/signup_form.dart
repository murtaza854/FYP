import 'dart:convert';

import 'package:app/screens/otpPhone/otp_phone_screen.dart';
import 'package:app/screens/signin/signin_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../models/user_model.dart';
import '../../../size_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../globals.dart' as globals;

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure_1 = true;
  bool _isObscure_2 = true;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: kPhoneBreakpoint > _size.width
              ? const Radius.circular(60)
              : _orientation == Orientation.portrait
                  ? const Radius.circular(90)
                  : const Radius.circular(70),
          topRight: kPhoneBreakpoint > _size.width
              ? const Radius.circular(60)
              : _orientation == Orientation.portrait
                  ? const Radius.circular(90)
                  : const Radius.circular(70),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(30),
          vertical: getProportionateScreenHeight(40)),
      child: Form(
        key: _formKey,
        child: Column(children: [
          firstNameTextFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          lastNameTextFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          emailTextFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          passwordTextFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          confirmPasswordTextFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          SizedBox(
            child: RichText(
              text: TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w500,
                  color: kTextColor,
                  fontSize: kPhoneBreakpoint > _size.width
                      ? getProportionateScreenWidth(kPhoneFontSizeDefaultText)
                      : _orientation == Orientation.portrait
                          ? getProportionateScreenWidth(
                              kTabletPortraitFontSizeDefaultText)
                          : getProportionateScreenWidth(
                              kTabletLandscapeFontSizeDefaultText),
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Password Instructons?',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          passwordDialog(context);
                        }),
                ],
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DefaultButton(
            text: "Sign Up",
            press: () async {
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Processing Data'),
                  ),
                );
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text);
                  final response = await http.post(
                      Uri.parse("${dotenv.env['API_URL1']}/user/signup"),
                      // Uri.parse("${dotenv.env['API_URL2']}/user/signup"),
                      // Uri.parse("${dotenv.env['API_URL3']}/user/signup"),
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization':
                            "Bearer ${dotenv.env['API_KEY_BEARER']}"
                      },
                      body: jsonEncode({
                        'firstName': _firstNameController.text,
                        'lastName': _lastNameController.text,
                        'email': _emailController.text,
                        'uid': userCredential.user?.uid
                      }));
                  // await FirebaseAuth.instance.signOut();
                  var data = json.decode(response.body)['data'];
                  print(data['_id']);
                  // Setting External User Id with Callback Available in SDK Version 3.9.3+
                  OneSignal.shared
                      .setExternalUserId(data['_id'])
                      .then((results) {
                    print(results.toString());
                  }).catchError((error) {
                    print(error.toString());
                  });
                  setState(() {
                    globals.user = UserModel.fromJson(data);
                  });
                  Navigator.pushNamed(context, OtpPhoneScreen.routeName);
                } on FirebaseAuthException catch (e) {
                  print(e);
                  if (e.code == 'weak-password') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('The password provided is too weak.'),
                      ),
                    );
                    _firstNameController.clear();
                    _lastNameController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                  } else if (e.code == 'email-already-in-use') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('The account already exists for that email.'),
                      ),
                    );
                    _firstNameController.clear();
                    _lastNameController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                  }
                } catch (e) {
                  print(e);
                }
              }
              // Navigator.pushNamed(context, SigninScreen.routeName);
            },
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          SizedBox(
            child: RichText(
              text: TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: TextStyle(
                  // fontSize: MediaQuery.of(context).size.width * 0.1,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: kPhoneBreakpoint > _size.width
                      ? getProportionateScreenWidth(kPhoneFontSizeDefaultText)
                      : _orientation == Orientation.portrait
                          ? getProportionateScreenWidth(
                              kTabletPortraitFontSizeDefaultText)
                          : getProportionateScreenWidth(
                              kTabletLandscapeFontSizeDefaultText),
                  height: 1.2,
                  color: kTextColor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "Have an account? ",
                    style: TextStyle(
                      color: kTextColor,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                  TextSpan(
                      text: 'Sign in',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, SigninScreen.routeName);
                        }),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  passwordDialog(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: kPhoneBreakpoint > _size.width
            ? BorderRadius.circular(15)
            : _orientation == Orientation.portrait
                ? BorderRadius.circular(20)
                : BorderRadius.circular(25),
      ),
      insetPadding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(50)),
      title: Text("Password Instructons",
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: Colors.black,
            fontSize:
                kPhoneBreakpoint > MediaQuery.of(context).size.width * 0.035
                    ? MediaQuery.of(context).size.width * 0.035
                    : MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.width * 0.035
                        : MediaQuery.of(context).size.width * 0.025,
          )),
      content: Text(
          "Must be between 8 and 16 characters.\nMust contain at least one uppercase letter.\nMust contain at least one lowercase letter.\nMust contain at least one number.",
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            // color: Colors.black,
          )),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  TextFormField firstNameTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      textCapitalization: TextCapitalization.words,
      controller: _firstNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'First name is required!';
        }
        return null;
      },
      style: TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w300,
        color: Colors.black,
        fontSize: kPhoneBreakpoint > _size.width
            ? getProportionateScreenWidth(kPhoneFontSizeFieldValue)
            : _orientation == Orientation.portrait
                ? getProportionateScreenWidth(kTabletPortraitFontSizeFieldValue)
                : getProportionateScreenWidth(
                    kTabletLandscapeFontSizeFieldValue),
      ),
      decoration: InputDecoration(
        labelText: "First Name",
        enabledBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kLightColor),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kTextColor),
            gapPadding: 10),
        errorStyle: const TextStyle(color: kErrorColor),
        errorBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kErrorColor),
            gapPadding: 10),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kErrorColor),
            gapPadding: 10),
        contentPadding: EdgeInsets.symmetric(
          horizontal: kPhoneBreakpoint > _size.width
              ? getProportionateScreenWidth(20)
              : _orientation == Orientation.portrait
                  ? getProportionateScreenWidth(20)
                  : getProportionateScreenWidth(15),
          vertical: kPhoneBreakpoint > _size.width
              ? getProportionateScreenHeight(20)
              : _orientation == Orientation.portrait
                  ? getProportionateScreenHeight(20)
                  : getProportionateScreenHeight(20),
        ),
        labelStyle: TextStyle(
            color: kTextColor,
            fontWeight: FontWeight.w400,
            fontSize: kPhoneBreakpoint > _size.width
                ? getProportionateScreenWidth(kPhoneFontSizeFieldLabel)
                : _orientation == Orientation.portrait
                    ? getProportionateScreenWidth(
                        kTabletPortraitFontSizeFieldLabel)
                    : getProportionateScreenWidth(
                        kTabletLandscapeFontSizeFieldLabel)),
      ),
    );
  }

  TextFormField lastNameTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      textCapitalization: TextCapitalization.words,
      controller: _lastNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Last name is required!';
        }
        return null;
      },
      style: TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w300,
        color: Colors.black,
        fontSize: kPhoneBreakpoint > _size.width
            ? getProportionateScreenWidth(kPhoneFontSizeFieldValue)
            : _orientation == Orientation.portrait
                ? getProportionateScreenWidth(kTabletPortraitFontSizeFieldValue)
                : getProportionateScreenWidth(
                    kTabletLandscapeFontSizeFieldValue),
      ),
      decoration: InputDecoration(
        labelText: "Last Name",
        enabledBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kLightColor),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kTextColor),
            gapPadding: 10),
        errorStyle: const TextStyle(color: kErrorColor),
        errorBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kErrorColor),
            gapPadding: 10),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kErrorColor),
            gapPadding: 10),
        contentPadding: EdgeInsets.symmetric(
          horizontal: kPhoneBreakpoint > _size.width
              ? getProportionateScreenWidth(20)
              : _orientation == Orientation.portrait
                  ? getProportionateScreenWidth(20)
                  : getProportionateScreenWidth(15),
          vertical: kPhoneBreakpoint > _size.width
              ? getProportionateScreenHeight(20)
              : _orientation == Orientation.portrait
                  ? getProportionateScreenHeight(20)
                  : getProportionateScreenHeight(20),
        ),
        labelStyle: TextStyle(
            color: kTextColor,
            fontWeight: FontWeight.w400,
            fontSize: kPhoneBreakpoint > _size.width
                ? getProportionateScreenWidth(kPhoneFontSizeFieldLabel)
                : _orientation == Orientation.portrait
                    ? getProportionateScreenWidth(
                        kTabletPortraitFontSizeFieldLabel)
                    : getProportionateScreenWidth(
                        kTabletLandscapeFontSizeFieldLabel)),
      ),
    );
  }

  TextFormField emailTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      validator: (value) {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern);
        if (value == null || value.isEmpty) {
          return 'Email is required!';
        } else if (!regex.hasMatch(value)) {
          return 'Enter a valid email!';
        }
        return null;
      },
      style: TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w300,
        color: Colors.black,
        fontSize: kPhoneBreakpoint > _size.width
            ? getProportionateScreenWidth(kPhoneFontSizeFieldValue)
            : _orientation == Orientation.portrait
                ? getProportionateScreenWidth(kTabletPortraitFontSizeFieldValue)
                : getProportionateScreenWidth(
                    kTabletLandscapeFontSizeFieldValue),
      ),
      decoration: InputDecoration(
        labelText: "Email",
        enabledBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kLightColor),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kTextColor),
            gapPadding: 10),
        errorStyle: const TextStyle(color: kErrorColor),
        errorBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kErrorColor),
            gapPadding: 10),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kErrorColor),
            gapPadding: 10),
        contentPadding: EdgeInsets.symmetric(
          horizontal: kPhoneBreakpoint > _size.width
              ? getProportionateScreenWidth(20)
              : _orientation == Orientation.portrait
                  ? getProportionateScreenWidth(20)
                  : getProportionateScreenWidth(15),
          vertical: kPhoneBreakpoint > _size.width
              ? getProportionateScreenHeight(20)
              : _orientation == Orientation.portrait
                  ? getProportionateScreenHeight(20)
                  : getProportionateScreenHeight(20),
        ),
        labelStyle: TextStyle(
            color: kTextColor,
            fontWeight: FontWeight.w400,
            fontSize: kPhoneBreakpoint > _size.width
                ? getProportionateScreenWidth(kPhoneFontSizeFieldLabel)
                : _orientation == Orientation.portrait
                    ? getProportionateScreenWidth(
                        kTabletPortraitFontSizeFieldLabel)
                    : getProportionateScreenWidth(
                        kTabletLandscapeFontSizeFieldLabel)),
      ),
    );
  }

  TextFormField passwordTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      obscureText: _isObscure_1,
      cursorColor: kTextColor,
      controller: _passwordController,
      style: TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w300,
        color: Colors.black,
        fontSize: kPhoneBreakpoint > _size.width
            ? getProportionateScreenWidth(kPhoneFontSizeFieldValue)
            : _orientation == Orientation.portrait
                ? getProportionateScreenWidth(kTabletPortraitFontSizeFieldValue)
                : getProportionateScreenWidth(
                    kTabletLandscapeFontSizeFieldValue),
      ),
      validator: (value) {
        String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,16}$';
        RegExp regex = RegExp(pattern);
        if (value == null || value.isEmpty) {
          return 'Password is required!';
        } else if (!regex.hasMatch(value)) {
          return 'Enter a valid password!';
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Password",
          enabledBorder: OutlineInputBorder(
              borderRadius: kPhoneBreakpoint > _size.width
                  ? BorderRadius.circular(15)
                  : _orientation == Orientation.portrait
                      ? BorderRadius.circular(20)
                      : BorderRadius.circular(25),
              borderSide: const BorderSide(color: kLightColor),
              gapPadding: 10),
          focusedBorder: OutlineInputBorder(
              borderRadius: kPhoneBreakpoint > _size.width
                  ? BorderRadius.circular(15)
                  : _orientation == Orientation.portrait
                      ? BorderRadius.circular(20)
                      : BorderRadius.circular(25),
              borderSide: const BorderSide(color: kTextColor),
              gapPadding: 10),
          errorStyle: const TextStyle(color: kErrorColor),
          errorBorder: OutlineInputBorder(
              borderRadius: kPhoneBreakpoint > _size.width
                  ? BorderRadius.circular(15)
                  : _orientation == Orientation.portrait
                      ? BorderRadius.circular(20)
                      : BorderRadius.circular(25),
              borderSide: const BorderSide(color: kErrorColor),
              gapPadding: 10),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: kPhoneBreakpoint > _size.width
                  ? BorderRadius.circular(15)
                  : _orientation == Orientation.portrait
                      ? BorderRadius.circular(20)
                      : BorderRadius.circular(25),
              borderSide: const BorderSide(color: kErrorColor),
              gapPadding: 10),
          contentPadding: EdgeInsets.symmetric(
            horizontal: kPhoneBreakpoint > _size.width
                ? getProportionateScreenWidth(20)
                : _orientation == Orientation.portrait
                    ? getProportionateScreenWidth(20)
                    : getProportionateScreenWidth(15),
            vertical: kPhoneBreakpoint > _size.width
                ? getProportionateScreenHeight(20)
                : _orientation == Orientation.portrait
                    ? getProportionateScreenHeight(20)
                    : getProportionateScreenHeight(20),
          ),
          labelStyle: TextStyle(
              color: kTextColor,
              fontWeight: FontWeight.w400,
              fontSize: kPhoneBreakpoint > _size.width
                  ? getProportionateScreenWidth(kPhoneFontSizeFieldLabel)
                  : _orientation == Orientation.portrait
                      ? getProportionateScreenWidth(
                          kTabletPortraitFontSizeFieldLabel)
                      : getProportionateScreenWidth(
                          kTabletLandscapeFontSizeFieldLabel)),
          suffixIcon: IconButton(
            splashRadius: 1,
            padding: EdgeInsets.only(
                right: kPhoneBreakpoint > _size.width
                    ? getProportionateScreenWidth(17)
                    : _orientation == Orientation.portrait
                        ? getProportionateScreenWidth(20)
                        : getProportionateScreenWidth(17)),
            icon: Icon(
              _isObscure_1 ? Icons.visibility_off : Icons.visibility,
              color: kTextColor,
              size: kPhoneBreakpoint > _size.width
                  ? getProportionateScreenWidth(kPhoneIconWidthSize)
                  : _orientation == Orientation.portrait
                      ? getProportionateScreenWidth(
                          kTabletPortraitIconWidthSize)
                      : getProportionateScreenWidth(
                          kTabletLandscapeIconWidthSize),
            ),
            // color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                _isObscure_1 = !_isObscure_1;
              });
            },
          )),
    );
  }

  TextFormField confirmPasswordTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      obscureText: _isObscure_2,
      cursorColor: kTextColor,
      controller: _confirmPasswordController,
      style: TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w300,
        color: Colors.black,
        fontSize: kPhoneBreakpoint > _size.width
            ? getProportionateScreenWidth(kPhoneFontSizeFieldValue)
            : _orientation == Orientation.portrait
                ? getProportionateScreenWidth(kTabletPortraitFontSizeFieldValue)
                : getProportionateScreenWidth(
                    kTabletLandscapeFontSizeFieldValue),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Confirm Password is required!';
        } else if (value != _passwordController.text) {
          return 'Password does not match!';
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Confirm Password",
          enabledBorder: OutlineInputBorder(
              borderRadius: kPhoneBreakpoint > _size.width
                  ? BorderRadius.circular(15)
                  : _orientation == Orientation.portrait
                      ? BorderRadius.circular(20)
                      : BorderRadius.circular(25),
              borderSide: const BorderSide(color: kLightColor),
              gapPadding: 10),
          focusedBorder: OutlineInputBorder(
              borderRadius: kPhoneBreakpoint > _size.width
                  ? BorderRadius.circular(15)
                  : _orientation == Orientation.portrait
                      ? BorderRadius.circular(20)
                      : BorderRadius.circular(25),
              borderSide: const BorderSide(color: kTextColor),
              gapPadding: 10),
          errorStyle: const TextStyle(color: kErrorColor),
          errorBorder: OutlineInputBorder(
              borderRadius: kPhoneBreakpoint > _size.width
                  ? BorderRadius.circular(15)
                  : _orientation == Orientation.portrait
                      ? BorderRadius.circular(20)
                      : BorderRadius.circular(25),
              borderSide: const BorderSide(color: kErrorColor),
              gapPadding: 10),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: kPhoneBreakpoint > _size.width
                  ? BorderRadius.circular(15)
                  : _orientation == Orientation.portrait
                      ? BorderRadius.circular(20)
                      : BorderRadius.circular(25),
              borderSide: const BorderSide(color: kErrorColor),
              gapPadding: 10),
          contentPadding: EdgeInsets.symmetric(
            horizontal: kPhoneBreakpoint > _size.width
                ? getProportionateScreenWidth(20)
                : _orientation == Orientation.portrait
                    ? getProportionateScreenWidth(20)
                    : getProportionateScreenWidth(15),
            vertical: kPhoneBreakpoint > _size.width
                ? getProportionateScreenHeight(20)
                : _orientation == Orientation.portrait
                    ? getProportionateScreenHeight(20)
                    : getProportionateScreenHeight(20),
          ),
          labelStyle: TextStyle(
              color: kTextColor,
              fontWeight: FontWeight.w400,
              fontSize: kPhoneBreakpoint > _size.width
                  ? getProportionateScreenWidth(kPhoneFontSizeFieldLabel)
                  : _orientation == Orientation.portrait
                      ? getProportionateScreenWidth(
                          kTabletPortraitFontSizeFieldLabel)
                      : getProportionateScreenWidth(
                          kTabletLandscapeFontSizeFieldLabel)),
          suffixIcon: IconButton(
            splashRadius: 1,
            padding: EdgeInsets.only(
                right: kPhoneBreakpoint > _size.width
                    ? getProportionateScreenWidth(17)
                    : _orientation == Orientation.portrait
                        ? getProportionateScreenWidth(20)
                        : getProportionateScreenWidth(17)),
            icon: Icon(
              _isObscure_2 ? Icons.visibility_off : Icons.visibility,
              color: kTextColor,
              size: kPhoneBreakpoint > _size.width
                  ? getProportionateScreenWidth(kPhoneIconWidthSize)
                  : _orientation == Orientation.portrait
                      ? getProportionateScreenWidth(
                          kTabletPortraitIconWidthSize)
                      : getProportionateScreenWidth(
                          kTabletLandscapeIconWidthSize),
            ),
            // color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                _isObscure_2 = !_isObscure_2;
              });
            },
          )),
    );
  }
}
