import 'dart:convert';

import 'package:app/components/social_button.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/screens/otpPhone/otp_phone_screen.dart';
import 'package:app/screens/signup/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../models/user_model.dart';
import '../../../size_config.dart';
import '../../../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../createPassword/create_password_screen.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({Key? key}) : super(key: key);

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  String buttonText = 'Sign In';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
        child: Column(
          children: [
            emailTextFormField(),
            SizedBox(height: getProportionateScreenHeight(15)),
            // const Spacer(),
            passwordTextFormField(),
            SizedBox(height: getProportionateScreenHeight(15)),
            DefaultButton(
              text: buttonText,
              press: () async {
                if (buttonText == "Loading...") {
                  return;
                }
                try {
                  setState(() {
                    buttonText = "Loading...";
                  });
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text);
                  final response = await http.post(
                      Uri.parse(
                          "${dotenv.env['API_URL1']}/user/get-logged-in-user"),
                      // Uri.parse("${dotenv.env['API_URL2']}/user/signup"),
                      // Uri.parse("${dotenv.env['API_URL3']}/user/signup"),
                      // "${dotenv.env['API_URL3']}/user/get-logged-in-user"),
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization':
                            "Bearer ${dotenv.env['API_KEY_BEARER']}"
                      },
                      body: jsonEncode({'uid': userCredential.user?.uid}));
                  if (response.statusCode == 200) {
                    var data = json.decode(response.body);
                    if (userCredential.user?.phoneNumber == null) {
                      data['phoneNumberFlag'] = false;
                    } else {
                      data['phoneNumberFlag'] = true;
                    }
                    // Setting External User Id with Callback Available in SDK Version 3.9.3+
                    print('------------');
                    // print(data);
                    OneSignal.shared
                        .setExternalUserId(data['data']['_id'])
                        .then((results) {
                      print(results.toString());
                    }).catchError((error) {
                      print(error.toString());
                    });
                    setState(() {
                      globals.user = UserModel.fromJson(data['data']);
                    });
                    UserModel user = UserModel.fromJson(data['data']);
                    if (user.role == 'Driver' &&
                        user.passwordCreated == false) {
                      Navigator.pushNamed(
                          context, CreatePasswordScreen.routeName);
                    } else if (user.hasPhoneNumber() != false) {
                      Navigator.pushNamed(context, OtpPhoneScreen.routeName);
                    } else {
                      Navigator.pushNamed(context, HomeScreen.routeName);
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) =>
                      //           const HomeScreen()), // this mainpage is your page to refresh
                      //   (Route<dynamic> route) => false,
                      // );
                    }
                    // Navigator.pushNamed(context, HomeScreen.routeName);
                  } else {
                    throw FirebaseAuthException(code: '');
                  }
                } on FirebaseAuthException catch (e) {
                  print(e.code);
                  setState(() {
                    buttonText = "Sign In";
                  });
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
                    title: Text("Invalid Credentials",
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: Colors.black,
                          fontSize: kPhoneBreakpoint >
                                  MediaQuery.of(context).size.width * 0.035
                              ? MediaQuery.of(context).size.width * 0.035
                              : MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? MediaQuery.of(context).size.width * 0.035
                                  : MediaQuery.of(context).size.width * 0.025,
                        )),
                    content: Text(
                        "Please enter the correct Credentials to log into your account",
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          // color: Colors.black,
                        )),
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                  // if (e.code == 'user-not-found') {
                  //   print('No user found for that email.');
                  // } else if (e.code == 'wrong-password') {
                  //   print('Wrong password provided for that user.');
                  // }
                }
              },
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            SizedBox(
              child: RichText(
                text: TextSpan(
                    text: 'Forgot Password?',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: kPhoneBreakpoint > _size.width
                          ? getProportionateScreenWidth(
                              kPhoneFontSizeDefaultText)
                          : _orientation == Orientation.portrait
                              ? getProportionateScreenWidth(
                                  kTabletPortraitFontSizeDefaultText)
                              : getProportionateScreenWidth(
                                  kTabletLandscapeFontSizeDefaultText),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navigator.pushNamed(context,
                        //     SigninScreen.routeName);
                      }),
              ),
            ),
            // SizedBox(height: getProportionateScreenHeight(2)),
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
                    color: kTextColor,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: "Don't have an account? ",
                    ),
                    TextSpan(
                        text: 'Sign Up',
                        style: const TextStyle(color: kPrimaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(
                                context, SignupScreen.routeName);
                          }),
                  ],
                ),
              ),
            ),
            // const Spacer(),
            SizedBox(
              height: kPhoneBreakpoint > _size.width
                  ? getProportionateScreenHeight(60)
                  : _orientation == Orientation.portrait
                      ? getProportionateScreenHeight(30)
                      : getProportionateScreenHeight(30),
            ),
            SocialButton(
              svg: "assets/icons/google-icon.svg",
              press: () {},
              text: "Continue with Google",
            ),
            SizedBox(
              height: kPhoneBreakpoint > _size.width
                  ? getProportionateScreenHeight(60)
                  : _orientation == Orientation.portrait
                      ? getProportionateScreenHeight(30)
                      : getProportionateScreenHeight(30),
            ),
            // const Spacer(),
          ],
        ),
      ),
    );
  }

  TextFormField passwordTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      obscureText: _isObscure,
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
                        kTabletLandscapeFontSizeFieldLabel),
          ),
          suffixIcon: IconButton(
            splashRadius: 1,
            padding: EdgeInsets.only(
                right: kPhoneBreakpoint > _size.width
                    ? getProportionateScreenWidth(17)
                    : _orientation == Orientation.portrait
                        ? getProportionateScreenWidth(20)
                        : getProportionateScreenWidth(17)),
            icon: Icon(
              _isObscure ? Icons.visibility_off : Icons.visibility,
              color: kTextColor,
              size: kPhoneBreakpoint > _size.width
                  ? _size.width * 0.07
                  : _orientation == Orientation.portrait
                      ? getProportionateScreenWidth(
                          kTabletPortraitIconWidthSize)
                      : getProportionateScreenWidth(
                          kTabletLandscapeIconWidthSize),
            ),
            // color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          )),
    );
  }

  TextFormField emailTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      controller: _emailController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your email";
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
                      kTabletLandscapeFontSizeFieldLabel),
        ),
      ),
    );
  }
}
