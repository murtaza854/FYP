import 'dart:convert';

import 'package:app/components/arrow_button.dart';
import 'package:app/components/outlined_button_custom.dart';
import 'package:app/components/title_custom.dart';
import 'package:app/screens/addresses/addressess.dart';
import 'package:app/screens/comingSoon/coming_soon.dart';
import 'package:app/screens/medicalCard/medical_card_screen.dart';
import 'package:app/screens/onboardingSignup/onboarding_signup_screen.dart';
import 'package:app/screens/personalInformation/personal_information_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../constants.dart';
import '../../../models/user_model.dart';
import '../../../size_config.dart';
import '../../../globals.dart' as globals;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MobileProfileScreen extends StatefulWidget {
  const MobileProfileScreen({Key? key}) : super(key: key);

  @override
  State<MobileProfileScreen> createState() => _MobileProfileScreenState();
}

class _MobileProfileScreenState extends State<MobileProfileScreen> {
  String buttonText = 'Sign Out';
  bool switchValue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      switchValue = globals.user?.availableForWork ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(30),
                    vertical: getProportionateScreenHeight(20),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: getProportionateScreenHeight(40)),
                      const Align(
                          alignment: Alignment.topLeft,
                          child: TitleCustom(
                              text: 'Profile', color: kPrimaryColor)),
                      SizedBox(height: getProportionateScreenHeight(50)),
                      ArrowButton(
                          press: () {
                            Navigator.pushNamed(context, PersonalInformationScreen.routeName);
                          },
                          text: 'Personal Information',
                          icon: Icons.keyboard_arrow_right),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      ArrowButton(
                          press: () {
                            Navigator.pushNamed(context, MedicalCardScreen.routeName);
                          },
                          text: 'Medical Card',
                          icon: Icons.keyboard_arrow_right),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      ArrowButton(
                          press: () {
                            Navigator.pushNamed(context, AddressessScreen.routeName);
                          },
                          text: 'Saved Addresses',
                          icon: Icons.keyboard_arrow_right),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      ArrowButton(
                          press: () {
                            Navigator.pushNamed(context, ComingSoonScreen.routeName);
                          },
                          text: 'Trip History',
                          icon: Icons.keyboard_arrow_right),
                      globals.user?.role == 'Driver'
                          ? SizedBox(height: getProportionateScreenHeight(10))
                          : Container(),
                      globals.user?.role == 'Driver'
                          ? ArrowButton(
                              press: () {
                            Navigator.pushNamed(context, ComingSoonScreen.routeName);
                            },
                              text: 'Ride History',
                              icon: Icons.keyboard_arrow_right)
                          : Container(),
                      globals.user?.role == 'Driver'
                          ? SizedBox(height: getProportionateScreenHeight(30))
                          : Container(),
                      globals.user?.role == 'Driver'
                          ? SizedBox(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  // Note: Styles for TextSpans must be explicitly defined.
                                  // Child text spans will inherit styles from parent
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: kPhoneBreakpoint > _size.width
                                        ? getProportionateScreenWidth(
                                            kPhoneFontSizeDefaultText)
                                        : _orientation == Orientation.portrait
                                            ? getProportionateScreenWidth(
                                                kTabletPortraitFontSizeDefaultText)
                                            : getProportionateScreenWidth(
                                                kTabletLandscapeFontSizeDefaultText),
                                    color: Colors.black,
                                  ),
                                  children: const <TextSpan>[
                                    TextSpan(text: "Available for work?"),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      globals.user?.role == 'Driver'
                          ? CupertinoSwitch(
                              activeColor: Colors.white,
                              thumbColor:
                                  !switchValue ? Colors.white : kPrimaryColor,
                              trackColor: Colors.grey.shade300,
                              value: !switchValue,
                              onChanged: (value) {
                                setWorkStatus(!switchValue);
                                setState(() {
                                  switchValue = !switchValue;
                                });
                              },
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
            OutlinedButtonCustom(
              mobileWidth: 100,
              text: buttonText,
              press: () async {
                if (buttonText == 'Sign Out') {
                  setState(() {
                    buttonText = 'Signing Out...';
                  });
                  await FirebaseAuth.instance.signOut();
                  OneSignal.shared.removeExternalUserId();
                  Future.delayed(const Duration(seconds: 3)).then((_) {
                    Navigator.pushNamed(
                        context, OnboardingSignupScreen.routeName);
                  });
                }
              },
            ),
            SizedBox(height: getProportionateScreenHeight(40)),
          ],
        ),
      ),
    );
  }

  void setWorkStatus(value) async {
    globals.user?.setAvailaleForWork(value);
    final response = await http.post(
        Uri.parse("${dotenv.env['API_URL1']}/user/set-availaleForWork"),
        // Uri.parse("${dotenv.env['API_URL2']}/user/get-logged-in-user"),
        // Uri.parse("${dotenv.env['API_URL3']}/user/get-logged-in-user"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${dotenv.env['API_KEY_BEARER']}"
        },
        body: jsonEncode(
            {"email": globals.user?.email, "availableForWork": value}));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        globals.user = UserModel.fromJson(data);
      });
    } else {
      print('Failed');
    }
  }
}
