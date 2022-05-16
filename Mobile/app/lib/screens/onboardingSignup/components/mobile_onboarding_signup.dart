import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../signin/signin_screen.dart';
import '../../signup/signup_screen.dart';

class MobileOnboardingSignup extends StatefulWidget {
  const MobileOnboardingSignup({Key? key}) : super(key: key);

  @override
  State<MobileOnboardingSignup> createState() => _MobileOnboardingSignupState();
}

class _MobileOnboardingSignupState extends State<MobileOnboardingSignup> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            const Spacer(),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      "assets/images/tezz_logo-urdu.png",
                      width: _size.width * 0.45,
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(250),
                    child: RichText(
                      text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: TextStyle(
                          fontSize: _size.width * 0.11,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          color: Colors.black,
                        ),
                        children: const <TextSpan>[
                          TextSpan(
                              text: "Save ",
                              style: TextStyle(fontWeight: FontWeight.w900)),
                          TextSpan(text: "Lives With "),
                          TextSpan(
                              text: "Tezz",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: kPrimaryColor)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            Expanded(
              child: Column(
                children: [
                  DefaultButton(
                    text: "Sign Up",
                    press: () {
                      Navigator.pushNamed(context, SignupScreen.routeName);
                    },
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  SizedBox(
                    child: RichText(
                      text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: TextStyle(
                          fontSize: _size.width * 0.046,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
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
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
          ],
        ),
      ),
    );
  }
}
