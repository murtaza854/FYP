import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'signin_form.dart';

class MobileSignin extends StatefulWidget {
  const MobileSignin({Key? key}) : super(key: key);

  @override
  State<MobileSignin> createState() => _MobileSigninState();
}

class _MobileSigninState extends State<MobileSignin> {
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
                      ? _size.width * 0.45
                      : _size.width * 0.3,
                ),
              ),
              const SigninForm(),
              // const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}