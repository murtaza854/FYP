import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'signup_form.dart';

class TabletSignup extends StatefulWidget {
  const TabletSignup({Key? key}) : super(key: key);

  @override
  State<TabletSignup> createState() => _TabletSignupState();
}

class _TabletSignupState extends State<TabletSignup> {
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
              SizedBox(height: getProportionateScreenHeight(30)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  "assets/images/tezz_logo-urdu.png",
                  width: _orientation == Orientation.portrait
                      ? _size.width * 0.45
                      : _size.width * 0.3,
                ),
              ),
              const SignupForm(),
              // const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
