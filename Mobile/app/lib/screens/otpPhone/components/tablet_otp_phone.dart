import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'otp_phone_form.dart';

class TabletOtpPhone extends StatefulWidget {
  const TabletOtpPhone({Key? key}) : super(key: key);

  @override
  State<TabletOtpPhone> createState() => _TabletOtpPhoneState();
}

class _TabletOtpPhoneState extends State<TabletOtpPhone> {
  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
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
                      ? getProportionateScreenWidth(kTabletPortraitLogoSize)
                      : getProportionateScreenWidth(kTabletLandscapeLogoSize),
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
