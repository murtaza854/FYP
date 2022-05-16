import 'package:app/screens/otp/components/mobile_otp.dart';
import 'package:app/screens/otp/components/tablet_otp.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../size_config.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";
  const OtpScreen({Key? key}) : super(key: key);

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
          mobile: MobileOtp(
            // phone: phone,
          ),
          tablet: TabletOtp(
            // phone: phone,
          ),
        ),
      ),
    );
  }
}