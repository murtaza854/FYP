import 'dart:async';
import 'dart:convert';

import 'package:app/components/default_button.dart';
import 'package:app/components/title_custom.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/screens/medicalCardSetup/medical_card_setup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class OtpForm extends StatefulWidget {
  final String phone;
  const OtpForm({Key? key, required this.phone}) : super(key: key);

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final _formKey = GlobalKey<FormState>();
  FocusNode pin2FocusNode = FocusNode();
  FocusNode pin3FocusNode = FocusNode();
  FocusNode pin4FocusNode = FocusNode();
  FocusNode pin5FocusNode = FocusNode();
  FocusNode pin6FocusNode = FocusNode();
  bool resentOtp = false;
  bool otpSent = false;
  Timer _timer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  int _start = 120;

  final TextEditingController _code1Controller = TextEditingController();
  final TextEditingController _code2Controller = TextEditingController();
  final TextEditingController _code3Controller = TextEditingController();
  final TextEditingController _code4Controller = TextEditingController();
  final TextEditingController _code5Controller = TextEditingController();
  final TextEditingController _code6Controller = TextEditingController();

  String verificationID = "";

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
    startTimer();
  }

  @override
  void dispose() {
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
    _timer.cancel();
    super.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    // print('Verification code resent');
    verifyPhoneNumber();
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            resentOtp = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phone,
      verificationCompleted: (PhoneAuthCredential credential) {
        verificationCompleted(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        verificationFailed(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        codeSent(verificationId, resendToken);
      },
      timeout: const Duration(minutes: 2),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    // ANDROID ONLY!

    // Sign the user in (or link) with the auto-generated credential
    await auth.currentUser?.linkWithCredential(credential);
    if (globals.user?.accountSetup == false) {
      // home = const MedicalCardSetup();
      Navigator.pushNamed(context, MedicalCardSetup.routeName);
    } else {
      Navigator.pushNamed(context, HomeScreen.routeName);
    }
  }

  void verificationFailed(FirebaseAuthException e) {
    if (e.code == 'invalid-phone-number') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid phone number.'),
        ),
      );
    }
    // Handle other errors
  }

  void codeSent(String verificationId, int? resendToken) {
    // Update the UI - wait for the user to enter the SMS code

    setState(() {
      verificationID = verificationId;
    });
  }

  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    String _minutes = minutes.toString().padLeft(2, '0');
    String _seconds = seconds.toString().padLeft(2, '0');
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
            const TitleCustom(
              text: 'OTP Verification',
              color: Colors.black,
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            SizedBox(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
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
                    TextSpan(text: "Enter the OTP sent to\n${widget.phone}"),
                  ],
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(80)),
            Padding(
              padding: kPhoneBreakpoint > _size.width
                  ? EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(0))
                  : _orientation == Orientation.portrait
                      ? EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(40))
                      : EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(70)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: kPhoneBreakpoint > _size.width
                        ? getProportionateScreenWidth(50)
                        : _orientation == Orientation.portrait
                            ? getProportionateScreenWidth(40)
                            : getProportionateScreenWidth(35),
                    child: otpField(
                      onChanged: (value) {
                        nextField(value, pin2FocusNode);
                      },
                      autoFocus: true,
                      controller: _code1Controller,
                    ),
                  ),
                  SizedBox(
                    width: kPhoneBreakpoint > _size.width
                        ? getProportionateScreenWidth(50)
                        : _orientation == Orientation.portrait
                            ? getProportionateScreenWidth(40)
                            : getProportionateScreenWidth(35),
                    child: otpField(
                      onChanged: (value) {
                        nextField(value, pin3FocusNode);
                      },
                      focusNode: pin2FocusNode,
                      controller: _code2Controller,
                    ),
                  ),
                  SizedBox(
                    width: kPhoneBreakpoint > _size.width
                        ? getProportionateScreenWidth(50)
                        : _orientation == Orientation.portrait
                            ? getProportionateScreenWidth(40)
                            : getProportionateScreenWidth(35),
                    child: otpField(
                      onChanged: (value) {
                        nextField(value, pin4FocusNode);
                      },
                      focusNode: pin3FocusNode,
                      controller: _code3Controller,
                    ),
                  ),
                  SizedBox(
                    width: kPhoneBreakpoint > _size.width
                        ? getProportionateScreenWidth(50)
                        : _orientation == Orientation.portrait
                            ? getProportionateScreenWidth(40)
                            : getProportionateScreenWidth(35),
                    child: otpField(
                      onChanged: (value) {
                        nextField(value, pin5FocusNode);
                      },
                      focusNode: pin4FocusNode,
                      controller: _code4Controller,
                    ),
                  ),
                  SizedBox(
                    width: kPhoneBreakpoint > _size.width
                        ? getProportionateScreenWidth(50)
                        : _orientation == Orientation.portrait
                            ? getProportionateScreenWidth(40)
                            : getProportionateScreenWidth(35),
                    child: otpField(
                      onChanged: (value) {
                        nextField(value, pin6FocusNode);
                      },
                      focusNode: pin5FocusNode,
                      controller: _code5Controller,
                    ),
                  ),
                  SizedBox(
                    width: kPhoneBreakpoint > _size.width
                        ? getProportionateScreenWidth(50)
                        : _orientation == Orientation.portrait
                            ? getProportionateScreenWidth(40)
                            : getProportionateScreenWidth(35),
                    child: otpField(
                      onChanged: (value) {
                        pin6FocusNode.unfocus();
                      },
                      focusNode: pin6FocusNode,
                      controller: _code6Controller,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            SizedBox(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
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
                      text: "Resend OTP in ",
                    ),
                    TextSpan(
                      text: "$_minutes:$_seconds",
                      style: const TextStyle(color: kErrorColor),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              child: RichText(
                text: TextSpan(
                    text: 'RESEND',
                    style: TextStyle(
                      color: resentOtp ? kSecondaryColor : kTextColor,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: kPhoneBreakpoint > _size.width
                          ? getProportionateScreenWidth(kPhoneFontSizeTitle)
                          : _orientation == Orientation.portrait
                              ? getProportionateScreenWidth(
                                  kTabletPortraitFontSizeDefaultText)
                              : getProportionateScreenWidth(
                                  kTabletLandscapeFontSizeDefaultText),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() {
                          if (resentOtp) {
                            resentOtp = false;
                            _start = 10;
                            startTimer();
                          }
                        });
                      }),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(80)),
            DefaultButton(
              text: "Verify",
              press: () async {
                // Navigator.pushNamed(context,
                //     SigninScreen.routeName);
                try {
                  String smsCode = _code1Controller.text +
                      _code2Controller.text +
                      _code3Controller.text +
                      _code4Controller.text +
                      _code5Controller.text +
                      _code6Controller.text;

                  // Create a PhoneAuthCredential with the code
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationID, smsCode: smsCode);

                  // Sign the user in (or link) with the credential
                  await auth.currentUser?.linkWithCredential(credential);

                  if (globals.user?.accountSetup == false) {
                    // home = const MedicalCardSetup();
                    assignPhoneNumber();
                    Navigator.pushNamed(context, MedicalCardSetup.routeName);
                  } else {
                    assignPhoneNumber();
                    Navigator.pushNamed(context, HomeScreen.routeName);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid OTP'),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            SizedBox(
              child: RichText(
                text: TextSpan(
                    text: 'Go back?',
                    style: TextStyle(
                      color: kSecondaryColor,
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
                    recognizer: TapGestureRecognizer()..onTap = () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void assignPhoneNumber() {
    globals.user?.setPhoneNumber(widget.phone);
    http.post(Uri.parse("${dotenv.env['API_URL1']}/user/set-phone-number"),
        // Uri.parse("${dotenv.env['API_URL2']}/user/get-logged-in-user"),
        // Uri.parse("${dotenv.env['API_URL3']}/user/get-logged-in-user"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${dotenv.env['API_KEY_BEARER']}"
        },
        body: jsonEncode(
            {"email": globals.user?.email, "contactNumber": widget.phone}));
  }

  Row buildTimer(
      Size _size, Orientation _orientation, Null Function() setResent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Resend OTP in ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: kPhoneBreakpoint > _size.width
                  ? getProportionateScreenWidth(kPhoneFontSizeDefaultText)
                  : _orientation == Orientation.portrait
                      ? getProportionateScreenWidth(
                          kTabletPortraitFontSizeDefaultText)
                      : getProportionateScreenWidth(
                          kTabletLandscapeFontSizeDefaultText),
              fontWeight: FontWeight.w500,
              color: kTextColor,
            )),
        TweenAnimationBuilder(
          tween: Tween(begin: 10.0, end: 0.0),
          curve: Curves.easeIn,
          duration: const Duration(minutes: 0, seconds: 10),
          builder: (context, value, child) {
            value as double;
            int minutes = value ~/ 60;
            double seconds = value % 60;
            // int timeLeft = value.toInt();
            // String timeLeftString = timeLeft.toString();
            String minutesString = minutes.toString();
            String secondsString = seconds.toInt().toString();
            if (minutesString.length == 1) {
              minutesString = "0" + minutesString;
            }
            if (secondsString.length == 1) {
              secondsString = "0" + secondsString;
            }
            return Text(
              "$minutesString:$secondsString",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: kPhoneBreakpoint > _size.width
                    ? getProportionateScreenWidth(kPhoneFontSizeDefaultText)
                    : _orientation == Orientation.portrait
                        ? getProportionateScreenWidth(
                            kTabletPortraitFontSizeDefaultText)
                        : getProportionateScreenWidth(
                            kTabletLandscapeFontSizeDefaultText),
                fontWeight: FontWeight.w500,
                color: kErrorColor,
              ),
            );
          },
          onEnd: setResent,
        )
      ],
    );
  }

  TextFormField otpField(
      {required Null Function(dynamic value) onChanged,
      FocusNode? focusNode,
      bool? autoFocus,
      required TextEditingController controller}) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      focusNode: focusNode,
      maxLength: 1,
      autofocus: autoFocus ?? false,
      controller: controller,
      onChanged: onChanged,
      cursorColor: kTextColor,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      obscureText: true,
      style: TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w300,
        color: Colors.black,
        fontSize: kPhoneBreakpoint > _size.width
            ? getProportionateScreenWidth(kPhoneFontSizeOTP)
            : _orientation == Orientation.portrait
                ? getProportionateScreenWidth(kTabletPortraitFontSizeOTP)
                : getProportionateScreenWidth(kTabletLandscapeFontSizeOTP),
      ),
      decoration: InputDecoration(
        counterText: "",
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
      ),
    );
  }
}
