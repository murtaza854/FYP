import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../responsive.dart';
import '../../size_config.dart';
import 'components/mobile_otp_phone.dart';
import 'components/tablet_otp_phone.dart';

class OtpPhoneScreen extends StatelessWidget {
  static String routeName = "/otp-phone";
  const OtpPhoneScreen({Key? key}) : super(key: key);

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
          mobile: MobileOtpPhone(),
          tablet: TabletOtpPhone(),
        ),
      ),
    );
  }
}