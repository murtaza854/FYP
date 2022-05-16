import 'package:app/screens/otp/otp_screen.dart';
import 'package:app/screens/signin/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/default_button.dart';
import '../../../components/title_custom.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../globals.dart' as globals;

class OtpPhoneForm extends StatefulWidget {
  const OtpPhoneForm({Key? key}) : super(key: key);

  @override
  State<OtpPhoneForm> createState() => _OtpPhoneFormState();
}

class _OtpPhoneFormState extends State<OtpPhoneForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneController.text = globals.user?.contactNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: kPhoneBreakpoint > _size.width
              ? const Radius.circular(60)
              : _orientation == Orientation.portrait
                  ? const Radius.circular(90)
                  : const Radius.circular(70),
          topRight: kPhoneBreakpoint > _size.width
              ? const Radius.circular(60)
              : _orientation == Orientation.portrait
                  ? const Radius.circular(90)
                  : const Radius.circular(70),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(30),
          vertical: getProportionateScreenHeight(40)),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const TitleCustom(
              text: 'OTP Verification',
              color: Colors.black,
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            SizedBox(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w500,
                    fontSize: kPhoneBreakpoint > _size.width
                        ? getProportionateScreenWidth(kPhoneFontSizeDefaultText)
                        : _orientation == Orientation.portrait
                            ? getProportionateScreenWidth(
                                kTabletPortraitFontSizeDefaultText)
                            : getProportionateScreenWidth(
                                kTabletLandscapeFontSizeDefaultText),
                    color: kTextColor,
                  ),
                  children: const <TextSpan>[
                    TextSpan(
                      text:
                          "A One Time Password (OTP)\nwill be sent to your Mobile Number",
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(100)),
            Text(
              'Enter Mobile Number',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w500,
                fontSize: kPhoneBreakpoint > _size.width
                    ? getProportionateScreenWidth(kPhoneFontSizeDefaultText)
                    : _orientation == Orientation.portrait
                        ? getProportionateScreenWidth(
                            kTabletPortraitFontSizeDefaultText)
                        : getProportionateScreenWidth(
                            kTabletLandscapeFontSizeDefaultText),
                color: Colors.black,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            phoneNumberTextFormField(),
            SizedBox(height: getProportionateScreenHeight(100)),
            DefaultButton(
              text: "Get OTP",
              press: () {
                // Navigator.pushNamed(context, SigninScreen.routeName);
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  String phoneNumber = _phoneController.text.toString();
                  if (phoneNumber.replaceAll(' ', '')[0] == '0') {
                    phoneNumber =
                        '+92' + phoneNumber.replaceAll(' ', '').substring(1);
                  } else if (phoneNumber.replaceAll(' ', '')[0] != '0') {
                    phoneNumber = '+92' + phoneNumber.replaceAll(' ', '');
                  }
                  Navigator.pushNamed(context, OtpScreen.routeName, arguments: {
                    'phone': phoneNumber,
                  });
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text('Processing Data'),
                  //   ),
                  // );
                }
              },
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            SizedBox(
              child: RichText(
                text: TextSpan(
                    text: 'Go back?',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: kPhoneBreakpoint > _size.width
                          ? getProportionateScreenWidth(
                              kPhoneFontSizeDefaultText)
                          : _orientation == Orientation.portrait
                              ? getProportionateScreenWidth(
                                  kTabletPortraitFontSizeDefaultText)
                              : getProportionateScreenWidth(
                                  kTabletLandscapeFontSizeDefaultText),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushNamed(context, SigninScreen.routeName);
                      }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField phoneNumberTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      textCapitalization: TextCapitalization.words,
      controller: _phoneController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is required!';
        } else if (value.replaceAll(' ', '')[0] == '0' &&
            value.replaceAll(' ', '').length != 11) {
          return 'Phone number must be 11 digits!';
        } else if (value.replaceAll(' ', '')[0] != '0' &&
            value.replaceAll(' ', '').length != 10) {
          return 'Phone number must be 10 digits!';
        }
        return null;
      },
      style: TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w300,
        color: Colors.black,
        fontSize: kPhoneBreakpoint > _size.width
            ? getProportionateScreenWidth(kPhoneFontSizeFieldValue)
            : _orientation == Orientation.portrait
                ? getProportionateScreenWidth(kTabletPortraitFontSizeFieldValue)
                : getProportionateScreenWidth(
                    kTabletLandscapeFontSizeFieldValue),
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kLightColor),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kTextColor),
            gapPadding: 10),
        errorStyle: const TextStyle(color: kErrorColor),
        errorBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kErrorColor),
            gapPadding: 10),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kErrorColor),
            gapPadding: 10),
        contentPadding: EdgeInsets.symmetric(
          horizontal: kPhoneBreakpoint > _size.width
              ? getProportionateScreenWidth(20)
              : _orientation == Orientation.portrait
                  ? getProportionateScreenWidth(20)
                  : getProportionateScreenWidth(15),
          vertical: kPhoneBreakpoint > _size.width
              ? getProportionateScreenHeight(20)
              : _orientation == Orientation.portrait
                  ? getProportionateScreenHeight(20)
                  : getProportionateScreenHeight(20),
        ),
        prefixIcon:
            const Padding(padding: EdgeInsets.all(15), child: Text('(+92) ')),
        labelStyle: TextStyle(
            color: kTextColor,
            fontWeight: FontWeight.w400,
            fontSize: kPhoneBreakpoint > _size.width
                ? getProportionateScreenWidth(kPhoneFontSizeFieldLabel)
                : _orientation == Orientation.portrait
                    ? getProportionateScreenWidth(
                        kTabletPortraitFontSizeFieldLabel)
                    : getProportionateScreenWidth(
                        kTabletLandscapeFontSizeFieldLabel)),
      ),
    );
  }
}
