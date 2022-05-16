import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../onboardingSignup/onboarding_signup_screen.dart';
import 'onboarding_button.dart';
import 'onboarding_content.dart';

class MobileOnboarding extends StatefulWidget {
  int currentPage;
  final List<Map<String, String>> onboardingData;
  MobileOnboarding({Key? key, required this.onboardingData, required this.currentPage}) : super(key: key);

  @override
  State<MobileOnboarding> createState() => _MobileOnboardingState();
}

class _MobileOnboardingState extends State<MobileOnboarding> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
                // flex: 6,
                child: PageView.builder(
                    onPageChanged: (value) => setState(() {
                          // _currentPage = value;
                          widget.currentPage = value;
                        }),
                    itemCount: widget.onboardingData.length,
                    itemBuilder: (content, index) => OnboardingContent(
                          image: widget.onboardingData[index]["image"] ?? '',
                          red: widget.onboardingData[index]["red"] ?? '',
                          bold: widget.onboardingData[index]["bold"] ?? '',
                          text: widget.onboardingData[index]["text"] ?? '',
                          bold2: widget.onboardingData[index]["bold2"] ?? '',
                          text2: widget.onboardingData[index]["text2"] ?? '',
                        ))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.onboardingData.length,
                  (index) => buildDot(index: index)),
            ),
            // SizedBox(height: getProportionateScreenHeight(10)),
            OnboardingButton(
              text: widget.currentPage != 4 ? "Skip" : "Next",
              press: () {
                Navigator.pushNamed(context, OnboardingSignupScreen.routeName);
              },
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
          ],
        ),
      ),
    );
  }
  
  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: getProportionateScreenHeight(13),
      width: getProportionateScreenWidth(13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: widget.currentPage == index
              ? const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[
                    kPrimaryColor,
                    kSecondaryColor,
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