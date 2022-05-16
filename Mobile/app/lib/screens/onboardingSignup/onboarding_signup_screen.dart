import 'package:app/responsive.dart';
import 'package:app/screens/onboardingSignup/components/tablet_onboarding_signup.dart';
import 'package:app/screens/onboardingSignup/components/mobile_onboarding_signup.dart';
// import 'package:app/size_config.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';

class OnboardingSignupScreen extends StatelessWidget {
  static String routeName = "/onboarding-signup";
  const OnboardingSignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
        // body: Body(),
        body:
            Responsive(mobile: MobileOnboardingSignup(), tablet: TabletOnboardingSignup()));
  }
}
