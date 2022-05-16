import 'package:app/responsive.dart';
import 'package:app/screens/signin/components/mobile_signin.dart';
import 'package:app/screens/signin/components/tablet_signin.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';

class SigninScreen extends StatelessWidget {
  static String routeName = "/signin";
  const SigninScreen({Key? key}) : super(key: key);

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
          mobile: MobileSignin(),
          tablet: TabletSignin(),
        ),
      ),
    );
  }
}
