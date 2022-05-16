import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'signup_form.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/images/tezz_logo-urdu.png",
                width: MediaQuery.of(context).size.width * 0.45,
                // alignment: Alignment.center,
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              const SignupForm(),
            ],
          ),
        ),
      ),
    );
  }
}
