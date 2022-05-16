import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'otp_phone_form.dart';

class MobileOtpPhone extends StatefulWidget {
  const MobileOtpPhone({Key? key}) : super(key: key);

  @override
  State<MobileOtpPhone> createState() => _MobileOtpPhoneState();
}

class _MobileOtpPhoneState extends State<MobileOtpPhone> {
  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // const Spacer(),
              SizedBox(height: getProportionateScreenHeight(25)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  "assets/images/tezz_logo-urdu.png",
                  width: _orientation == Orientation.portrait
                      ? getProportionateScreenWidth(kPhoneLogoSize)
                      : _size.width * 0.3,
                ),
              ),
              const OtpPhoneForm(),
              // const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}