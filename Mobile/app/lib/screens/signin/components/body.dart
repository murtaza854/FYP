import 'package:app/constants.dart';
import 'package:app/screens/signup/signup_screen.dart';
import 'package:app/size_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/social_button.dart';
import 'signin_form.dart';

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
        children: [
          const Spacer(),
          Image.asset(
            "assets/images/tezz_logo-urdu.png",
            width: MediaQuery.of(context).size.width * 0.45,
          ),
          const SigninForm(),
        ],
      ),
    ));
  }
}
