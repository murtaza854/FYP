import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NameChange extends StatefulWidget {
  NameChange({Key? key}) : super(key: key);

  @override
  State<NameChange> createState() => _NameChangeState();
}

class _NameChangeState extends State<NameChange> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  String buttonText = 'Confirm';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameController.text = globals.user?.firstName ?? '';
    _lastNameController.text = globals.user?.lastName ?? '';
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
            firstNameTextFormField(),
            SizedBox(height: getProportionateScreenHeight(15)),
            // const Spacer(),
            lastNameTextFormField(),
            SizedBox(height: getProportionateScreenHeight(15)),
            DefaultButton(
              text: buttonText,
              press: () async {
                if (buttonText == "Loading...") {
                  return;
                }
                try {
                  setState(() {
                    buttonText = "Loading...";
                  });
                  final response = await http.post(
                      Uri.parse(
                          "${dotenv.env['API_URL1']}/user/update-user-name"),
                      // Uri.parse("${dotenv.env['API_URL2']}/user/signup"),
                      // Uri.parse("${dotenv.env['API_URL3']}/user/signup"),
                      // "${dotenv.env['API_URL3']}/user/get-logged-in-user"),
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization':
                            "Bearer ${dotenv.env['API_KEY_BEARER']}"
                      },
                      body: jsonEncode({
                        'email': globals.user?.email,
                        'firstName': _firstNameController.text,
                        'lastName': _lastNameController.text
                      }));
                  if (response.statusCode == 200) {
                    // print(data);
                    setState(() {
                      globals.user?.setFirstName(_firstNameController.text);
                      globals.user?.setLastName(_lastNameController.text);
                    });
                    Navigator.pop(context);
                  }
                } catch (e) {
                  setState(() {
                    buttonText = "Confirm";
                  });
                }
              },
            ),
            // const Spacer(),
          ],
        ),
      ),
    );
  }

  TextFormField firstNameTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      textCapitalization: TextCapitalization.words,
      controller: _firstNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'First name is required!';
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
        labelText: "First Name",
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

  TextFormField lastNameTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      textCapitalization: TextCapitalization.words,
      controller: _lastNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Last name is required!';
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
        labelText: "Last Name",
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
