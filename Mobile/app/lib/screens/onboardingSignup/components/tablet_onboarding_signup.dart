import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../signin/signin_screen.dart';
import '../../signup/signup_screen.dart';

class TabletOnboardingSignup extends StatefulWidget {
  const TabletOnboardingSignup({Key? key}) : super(key: key);

  @override
  State<TabletOnboardingSignup> createState() => _TabletOnboardingSignupState();
}

class _TabletOnboardingSignupState extends State<TabletOnboardingSignup> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    Orientation _orientation = MediaQuery.of(context).orientation;
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/images/tezz_logo-urdu.png",
                width: _orientation == Orientation.portrait
                    ? _size.width * 0.45
                    : _size.width * 0.3,
              ),
            ),
            SizedBox(
              width: _orientation == Orientation.portrait
                  ? getProportionateScreenWidth(250)
                  : null,
              child: RichText(
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
                    fontSize: _orientation == Orientation.portrait
                        ? _size.width * 0.09
                        : _size.width * 0.05,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    color: Colors.black,
                  ),
                  children: const <TextSpan>[
                    TextSpan(
                        text: "Save ",
                        style: TextStyle(fontWeight: FontWeight.w900)),
                    TextSpan(text: "Lives\nWith "),
                    TextSpan(
                        text: "Tezz",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: kPrimaryColor)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(height: getProportionateScreenHeight(30)),
            DefaultButton(
              text: "Sign Up",
              press: () {
                Navigator.pushNamed(context, SignupScreen.routeName);
              },
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            SizedBox(
              child: RichText(
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
                    fontSize: _orientation == Orientation.portrait
                        ? getProportionateScreenWidth(kTabletPortraitFontSizeDefaultText)
                        : getProportionateScreenWidth(kTabletLandscapeFontSizeDefaultText),
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w500,
                    // height: 1.2,
                    color: kTextColor,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: "Have an account? ",
                    ),
                    TextSpan(
                        text: 'Sign In',
                        style: const TextStyle(color: kPrimaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(
                                context, SigninScreen.routeName);
                          }),
                  ],
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(40)),
            // const Spacer(),
          ],
        ),
      ),
    );
  }
}
