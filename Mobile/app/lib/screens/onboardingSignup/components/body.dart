import 'package:app/components/default_button.dart';
import 'package:app/screens/signin/signin_screen.dart';
import 'package:app/screens/signup/signup_screen.dart';
import 'package:app/size_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
// import 'onboarding_button.dart';
// import 'onboarding_content.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    "assets/images/tezz_logo-urdu.png",
                    width: MediaQuery.of(context).size.width * 0.45,
                    // height: MediaQuery.of(context).size.height * 0.5,
                  ),
                )),
            Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: getProportionateScreenHeight(30)),
                    SizedBox(
                      width: getProportionateScreenWidth(250),
                      child: RichText(
                        text: TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.1,
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
                                    color: kSecondaryColor)),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    DefaultButton(
                      text: "Sign Up",
                      press: () {
                        Navigator.pushNamed(context, SignupScreen.routeName);
                      },
                    ),
                    SizedBox(height: getProportionateScreenHeight(15)),
                    SizedBox(
                      child: RichText(
                        text: TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: TextStyle(
                            // fontSize: MediaQuery.of(context).size.width * 0.1,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Have an account? ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.046),
                            ),
                            TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                    color: kSecondaryColor,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.046),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context,
                                        SigninScreen.routeName);
                                  }),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: getProportionateScreenHeight(10)),
                  // SocialButton(
                  //   svg: "assets/icons/google-icon.svg",
                  //   press: () {},
                  //   text: "Continue with Google",
                  // ),
                    SizedBox(height: getProportionateScreenHeight(60)),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
