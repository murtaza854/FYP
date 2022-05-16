import 'package:app/screens/onboardingSignup/onboarding_signup_screen.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'onboarding_button.dart';
import 'onboarding_content.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int _currentPage = 0;
  List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/SOS.png",
      "red": "SOS ",
      "bold": "",
      "text":"an Ambulance for ",
      "bold2": "Urgent ",
      "text2": "Dispatch",
    },
    {
      "image": "assets/images/Ambulance.png",
      "red": "",
      "bold": "Choose ",
      "text":"Your Ambulance & ",
      "bold2": "Nearby ",
      "text2": "Hospital",
    },
    {
      // "text": "Track the Ambulance in Real Time",
      "image": "assets/images/Tracking.png",
      "red": "",
      "bold": "Track ",
      "text":"the Ambulance in ",
      "bold2": "Real Time",
      "text2": "",
    },
    {
      // "text": "Chat with the Driver in Real Time",
      "image": "assets/images/Chat.png",
      "red": "",
      "bold": "Chat ",
      "text":"with the Driver in ",
      "bold2": "Real Time",
      "text2": "",
    },
    {
      // "text": "Save Your Medical Records",
      "image": "assets/images/Medical-Card.png",
      "red": "",
      "bold": "Save ",
      "text":"Your ",
      "bold2": "Medical ",
      "text2": "Records",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 6,
                child: PageView.builder(
                    onPageChanged: (value) => setState(() {
                          _currentPage = value;
                        }),
                    itemCount: onboardingData.length,
                    itemBuilder: (content, index) => OnboardingContent(
                          image: onboardingData[index]["image"] ?? '',
                          red: onboardingData[index]["red"] ?? '',
                          bold: onboardingData[index]["bold"] ?? '',
                          text: onboardingData[index]["text"] ?? '',
                          bold2: onboardingData[index]["bold2"] ?? '',
                          text2: onboardingData[index]["text2"] ?? '',
                        ))),
            Expanded(
              child: Column(
                children: <Widget>[
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(onboardingData.length,
                        (index) => buildDot(index: index)),
                  ),
                  OnboardingButton(
                    text: "Skip",
                    press: () {
                      Navigator.pushNamed(context, OnboardingSignupScreen.routeName);
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(35)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: getProportionateScreenHeight(19),
      width: getProportionateScreenWidth(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: _currentPage == index
              ? const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[
                    Color(0xFF39B54A),
                    Color(0xFF00A99D),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[
                    Color(0xFFD8D8D8),
                    Color(0xFFD8D8D8),
                  ],
                )),
    );
  }
}
