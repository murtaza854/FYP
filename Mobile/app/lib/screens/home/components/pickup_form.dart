import 'package:app/screens/mapScreen/map_screen.dart';
import 'package:app/screens/mapsTracking/maps_tracking.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../globals.dart' as globals;

class PickupForm extends StatefulWidget {
  const PickupForm({Key? key}) : super(key: key);

  @override
  State<PickupForm> createState() => _PickupFormState();
}

class _PickupFormState extends State<PickupForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pickupLocation = TextEditingController();
  // late LatLng _pickupLocationLatLng;

  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          kPhoneBreakpoint > _size.width
              ? const Radius.circular(30)
              : _orientation == Orientation.portrait
                  ? const Radius.circular(90)
                  : const Radius.circular(70),
        ),
        color: kLightColor,
      ),
      padding: EdgeInsets.only(
        top: getProportionateScreenHeight(20),
        left: getProportionateScreenWidth(30),
        right: getProportionateScreenWidth(30),
        bottom: getProportionateScreenHeight(30),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' Book an Ambulance',
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
                color: kPrimaryColor,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            pickupLocationTextFormField(),
            SizedBox(height: getProportionateScreenHeight(20)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(40),
              ),
              child: DefaultButton(
                text: "Book Now",
                press: () {
                  if (globals.inProgressRide != null) {
                    Navigator.pushNamed(context, MapsTracking.routeName);
                  } else {
                    Navigator.pushNamed(context, MapScreen.routeName);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField pickupLocationTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      onTap: () {
        if (globals.inProgressRide != null) {
          Navigator.pushNamed(context, MapsTracking.routeName);
        } else {
          Navigator.pushNamed(context, MapScreen.routeName);
        }
      },
      cursorColor: kTextColor,
      textCapitalization: TextCapitalization.words,
      controller: _pickupLocation,
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is required!';
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
        fillColor: Colors.white,
        hintText: "Pick-Up Location",
        hintStyle: TextStyle(
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w300,
          color: kTextColor,
          fontSize: kPhoneBreakpoint > _size.width
              ? getProportionateScreenWidth(kPhoneFontSizeFieldValue)
              : _orientation == Orientation.portrait
                  ? getProportionateScreenWidth(
                      kTabletPortraitFontSizeFieldValue)
                  : getProportionateScreenWidth(
                      kTabletLandscapeFontSizeFieldValue),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.white),
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
        suffixIcon: IconButton(
          icon: Icon(
            _pickupLocation.text.isNotEmpty ? Icons.cancel : Icons.location_on,
            color: kTextColor,
            size: kPhoneBreakpoint > _size.width
                ? getProportionateScreenWidth(kPhoneIconWidthSize)
                : _orientation == Orientation.portrait
                    ? getProportionateScreenWidth(kTabletPortraitIconWidthSize)
                    : getProportionateScreenWidth(
                        kTabletLandscapeIconWidthSize),
          ),
          onPressed: () {
            // _pickupLocation.clear();
            // setState(() {
            //   _pickupLocationLatLng = null as LatLng;
            // });
          },
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
