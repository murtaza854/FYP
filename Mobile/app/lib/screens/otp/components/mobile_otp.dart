import 'package:app/screens/otp/components/otp_form.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class MobileOtp extends StatefulWidget {
  const MobileOtp({Key? key}) : super(key: key);

  @override
  State<MobileOtp> createState() => _MobileOtpState();
}

class _MobileOtpState extends State<MobileOtp> {
  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
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
                      ? getProportionateScreenWidth(kPhoneLogoSize)
                      : _size.width * 0.3,
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
