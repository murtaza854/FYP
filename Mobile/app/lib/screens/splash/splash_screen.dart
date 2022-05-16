import 'package:app/screens/splash/components/body.dart';
// import 'package:app/size_config.dart';
import 'package:flutter/material.dart';

// import '../../size_config.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    return const Scaffold(
      body: Body(),
    );
  }
}
