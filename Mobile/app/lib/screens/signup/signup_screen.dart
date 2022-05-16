import 'package:app/constants.dart';
import 'package:app/responsive.dart';
// import 'package:app/screens/signup/components/body.dart';
import 'package:app/screens/signup/components/mobile_signup.dart';
import 'package:app/screens/signup/components/tablet_signup.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';

class SignupScreen extends StatelessWidget {
  static String routeName = "/signup";
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kLightColor, kLightColor, kLightColor, Colors.white],
          ),
        ),
        child: const Responsive(
          mobile: MobileSignup(),
          tablet: TabletSignup(),
        ),
      ),
      // backgroundColor: kLightColor,
    );
  }
}
