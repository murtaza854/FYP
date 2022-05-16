import 'package:app/screens/addresses/addressess.dart';
import 'package:app/screens/comingSoon/coming_soon.dart';
import 'package:app/screens/createPassword/create_password_screen.dart';
import 'package:app/screens/emergencyContacts/components/mobile_emergency_contacts.dart';
import 'package:app/screens/firstAidTips/first_aid_tips_screen.dart';
import 'package:app/screens/formPage/form_page_screen.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/screens/medicalCard/medical_card_screen.dart';
import 'package:app/screens/medicalCardSetup/medical_card_setup_screen.dart';
import 'package:app/screens/otp/otp_screen.dart';
import 'package:app/screens/personalInformation/personal_information_screen.dart';
import 'package:app/screens/ridesScreen/rides_screen.dart';
import 'package:app/screens/search/search_screen.dart';
import 'package:app/screens/signin/signin_screen.dart';
import 'package:app/screens/signup/signup_screen.dart';
import 'package:app/screens/splash/splash_screen.dart';
import 'package:flutter/widgets.dart';
import 'screens/mapScreen/map_screen.dart';
import 'package:app/screens/mapsTracking/maps_tracking.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/onboardingSignup/onboarding_signup_screen.dart';
import 'screens/otpPhone/otp_phone_screen.dart';
import 'screens/requestsScreen/requests_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  OnboardingScreen.routeName: (context) => OnboardingScreen(),
  OnboardingSignupScreen.routeName: (context) => const OnboardingSignupScreen(),
  SigninScreen.routeName: (context) => const SigninScreen(),
  SignupScreen.routeName: (context) => const SignupScreen(),
  OtpScreen.routeName: (context) => const OtpScreen(),
  OtpPhoneScreen.routeName: (context) => const OtpPhoneScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  MapScreen.routeName: (context) => const MapScreen(),
  MedicalCardSetup.routeName: (context) => const MedicalCardSetup(),
  SearchScreen.routeName: (context) => const SearchScreen(),
  MobileEmergencyContactsScreen.routeName: (context) =>
      const MobileEmergencyContactsScreen(),
  RequestsScreen.routeName: (context) => const RequestsScreen(),
  CreatePasswordScreen.routeName: (context) => const CreatePasswordScreen(),
  RidesScreen.routeName: (context) => const RidesScreen(),
  MapsTracking.routeName: (context) => const MapsTracking(),
  MedicalCardScreen.routeName: (context) => MedicalCardScreen(),
  PersonalInformationScreen.routeName: (context) =>
      const PersonalInformationScreen(),
  FormPageScreen.routeName: (context) => const FormPageScreen(),
  ComingSoonScreen.routeName: (context) => const ComingSoonScreen(),
  AddressessScreen.routeName: (context) => const AddressessScreen(),
  FirstAidTipsScreen.routeName: (context) => const FirstAidTipsScreen(),
};
