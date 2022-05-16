import 'package:app/responsive.dart';
import 'package:app/screens/onboarding/components/mobile_onboarding.dart';
import 'package:app/screens/onboarding/components/tablet_onboarding.dart';
// import 'package:app/screens/onboarding/components/body.dart';
import 'package:flutter/material.dart';
import '../../size_config.dart';

class OnboardingScreen extends StatelessWidget {
  static String routeName = "/onboarding";
  OnboardingScreen({Key? key}) : super(key: key);
  final int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/SOS.png",
      "red": "SOS ",
      "bold": "",
      "text": "an Ambulance for ",
      "bold2": "Urgent ",
      "text2": "Dispatch",
    },
    {
      "image": "assets/images/Ambulance.png",
      "red": "",
      "bold": "Choose ",
      "text": "Your Ambulance & ",
      "bold2": "Nearby ",
      "text2": "Hospital",
    },
    {
      // "text": "Track the Ambulance in Real Time",
      "image": "assets/images/Tracking.png",
      "red": "",
      "bold": "Track ",
      "text": "the Ambulance in ",
      "bold2": "Real Time",
      "text2": "",
    },
    {
      // "text": "Chat with the Driver in Real Time",
      "image": "assets/images/Chat.png",
      "red": "",
      "bold": "Chat ",
      "text": "with the Driver in ",
      "bold2": "Real Time",
      "text2": "",
    },
    {
      // "text": "Save Your Medical Records",
      "image": "assets/images/Medical-Card.png",
      "red": "",
      "bold": "Save ",
      "text": "Your ",
      "bold2": "Medical ",
      "text2": "Records",
    },
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Responsive(
        mobile: MobileOnboarding(
          currentPage: _currentPage,
          onboardingData: onboardingData,
        ),
        tablet: TabletOnboarding(
          currentPage: _currentPage,
          onboardingData: onboardingData,
        ),
      ),
    );
  }
}
