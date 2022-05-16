import 'package:app/constants.dart';
import 'package:app/screens/otp/components/otp_form.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';

class TabletOtp extends StatefulWidget {
  const TabletOtp({Key? key}) : super(key: key);

  @override
  State<TabletOtp> createState() => _TabletOtpState();
}

class _TabletOtpState extends State<TabletOtp> {
  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final phone = arguments["phone"];
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
              OtpForm(
                phone: phone,
              ),
              // const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
