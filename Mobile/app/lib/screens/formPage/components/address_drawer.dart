import 'dart:convert';

import 'package:app/components/title_custom.dart';
import 'package:app/constants.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../components/default_button.dart';
import '../../../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddressAddDrawer extends StatefulWidget {
  const AddressAddDrawer({
    Key? key,
    required this.idleLocation,
    required this.currentLocationString,
    required this.changeCameraPositionIndex,
  }) : super(key: key);

  final LatLng idleLocation;
  final String currentLocationString;
  final void Function(dynamic newPos) changeCameraPositionIndex;

  @override
  State<AddressAddDrawer> createState() => _AddressAddDrawerState();
}

class _AddressAddDrawerState extends State<AddressAddDrawer> {
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                )),
            child: SingleChildScrollView(
                controller: scrollController,
                // make a form for address
                child: Column(
                  children: [
                    SizedBox(height: getProportionateScreenHeight(15)),
                    const TitleCustom(
                      text: 'Add Address',
                      color: kPrimaryColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20),
                        vertical: getProportionateScreenHeight(6),
                      ),
                      child: labelTextFormField(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20),
                        vertical: getProportionateScreenHeight(6),
                      ),
                      child: addressLine1TextFormField(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20),
                        vertical: getProportionateScreenHeight(6),
                      ),
                      child: addressLine2TextFormField(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20),
                        vertical: getProportionateScreenHeight(6),
                      ),
                      child: landmarkTextFormField(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(50),
                        vertical: getProportionateScreenHeight(6),
                      ),
                      child: DefaultButton(
                        text: 'Add Address',
                        press: () async {
                          final response = await http.post(
                              Uri.parse(
                                  "${dotenv.env['API_URL1']}/user/save-address"),
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
                                'label': _labelController.text,
                                'addressLine1': _addressLine1Controller.text,
                                'addressLine2': _addressLine2Controller.text,
                                'landmark': _landmarkController.text,
                                'latitude': widget.idleLocation.latitude,
                                'longitude': widget.idleLocation.longitude,
                              }));
                          if (response.statusCode == 200) {
                            var data = jsonDecode(response.body);
                            setState(() {
                              globals.user?.addresses.add(data);
                            });
                            Navigator.pop(context);
                          }
                          // )
                          // add address to user
                          // globals.user.addresses.add(Address(
                          //   label: _labelController.text,
                          //   addressLine1: _addressLine1Controller.text,
                          //   addressLine2: _addressLine2Controller.text,
                          //   landmark: _landmarkController.text,
                          // ));
                          // // update user in firestore
                          // globals.userRef.update(
                          //   {
                          //     'addresses': globals.user.addresses,
                          //   },
                          // );
                          // // close drawer
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  TextFormField labelTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      textCapitalization: TextCapitalization.words,
      controller: _labelController,
      validator: (value) {},
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
        labelText: "Label",
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

  TextFormField addressLine1TextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      textCapitalization: TextCapitalization.words,
      controller: _addressLine1Controller,
      validator: (value) {},
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
        labelText: "Address Line 1",
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

  TextFormField addressLine2TextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      textCapitalization: TextCapitalization.words,
      controller: _addressLine2Controller,
      validator: (value) {},
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
        labelText: "Address Line 2",
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

  TextFormField landmarkTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      textCapitalization: TextCapitalization.words,
      controller: _landmarkController,
      validator: (value) {},
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
        labelText: "Landmark",
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
