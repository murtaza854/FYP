import 'dart:convert';

import 'package:app/components/color_icon_button.dart';
import 'package:app/screens/comingSoon/coming_soon.dart';
import 'package:app/screens/firstAidTips/first_aid_tips_screen.dart';
import 'package:app/screens/home/components/pickup_form.dart';
import 'package:app/screens/mapScreen/map_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../globals.dart' as globals;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MobileHomeScreen extends StatefulWidget {
  const MobileHomeScreen({Key? key}) : super(key: key);

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  CollectionReference userLocationsCollection =
      FirebaseFirestore.instance.collection('userLocations');
  @override
  Widget build(BuildContext context) {
    // Size _size = MediaQuery.of(context).size;
    // Orientation _orientation = MediaQuery.of(context).orientation;
    // String name = globals.user?.firstName ?? '';
    // print(name);
    String name = globals.user?.getFirstName();
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: getProportionateScreenHeight(60)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: getProportionateScreenWidth(5)),
                  SizedBox(
                    child: RichText(
                      text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: TextStyle(
                          fontSize:
                              getProportionateScreenWidth(kPhoneFontSizeTitle),
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                              text: "Hello, ",
                              style: TextStyle(fontWeight: FontWeight.w900)),
                          TextSpan(
                              text: name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w100)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Text(
                "Click the button below during emergencies",
                style: TextStyle(
                  fontSize: kPhoneFontSizeSubtitle,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              TextButton(
                onPressed: () {
                  Orientation _orientation = MediaQuery.of(context).orientation;
                  Size _size = MediaQuery.of(context).size;
                  AlertDialog alert = AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: kPhoneBreakpoint > _size.width
                          ? BorderRadius.circular(15)
                          : _orientation == Orientation.portrait
                              ? BorderRadius.circular(20)
                              : BorderRadius.circular(25),
                    ),
                    insetPadding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20),
                        vertical: getProportionateScreenHeight(50)),
                    content: Center(
                      child: Text(
                        'Coming Soon',
                        style: TextStyle(
                          fontSize: kPhoneFontSizeSubtitle,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  );
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      });
                  // // print("object");
                  // userLocationsCollection
                  //     .where('email', isEqualTo: globals.user?.email)
                  //     .get()
                  //     .then((value) async {
                  //   if (value.docs.isNotEmpty) {
                  //     final data =
                  //         value.docs.first.data() as Map<String, dynamic>;
                  //     LatLng latLng = LatLng(data['currentLocation']['lat'],
                  //         data['currentLocation']['lng']);
                  //     String url =
                  //         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${latLng.latitude},${latLng.longitude}&radius=10000&type=hospital&key=${dotenv.env['GOOGLE_CLOUD_API_KEY'] as String}';
                  //     var response = await http.get(Uri.parse(url));
                  //     var jsonResponse = json.decode(response.body);
                  //     var nearbyHospitalsList = jsonResponse['results'];
                  //     var newNearbyHospitals = [];
                  //     String latlng = "";
                  //     // print(nearbyHospitalsList);
                  //     for (var i = 0; i < nearbyHospitalsList.length; i++) {
                  //       var hospital = nearbyHospitalsList[i];
                  //       if (hospital['business_status'] == 'OPERATIONAL') {
                  //         double lat = hospital['geometry']['location']['lat'];
                  //         double lng = hospital['geometry']['location']['lng'];
                  //         if (i == nearbyHospitalsList.length - 1) {
                  //           latlng += '$lat,$lng';
                  //         } else {
                  //           latlng += '$lat,$lng|';
                  //         }
                  //         // String urlDistance =
                  //         //     'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$latlng&mode=driving&origins=${widget.idleLocation.latitude},${widget.idleLocation.longitude}&key=${dotenv.env['GOOGLE_CLOUD_API_KEY'] as String}';
                  //         // var response = await http.get(Uri.parse(urlDistance));
                  //         // var jsonResponse = json.decode(response.body);
                  //         // var distance =
                  //         //     jsonResponse['rows'][0]['elements'][0]['distance']['text'];
                  //         // int distanceInMeters =
                  //         //     jsonResponse['rows'][0]['elements'][0]['distance']['value'];
                  //         // var duration =
                  //         //     jsonResponse['rows'][0]['elements'][0]['duration']['text'];
                  //         // int durationInSeconds =
                  //         //     jsonResponse['rows'][0]['elements'][0]['duration']['value'];
                  //         // double distanceInKm = distanceInMeters / 1000;
                  //         // double durationInMinutes = durationInSeconds / 60;
                  //         // distanceInKm = double.parse(distanceInKm.toStringAsFixed(2));
                  //         // durationInMinutes = double.parse(durationInMinutes.toStringAsFixed(1));
                  //         var newHospital = {
                  //           'name': hospital['name'],
                  //           'vicinity': hospital['vicinity'],
                  //           'geometry': hospital['geometry'],
                  //           'place_id': hospital['place_id'],
                  //           'types': hospital['types'],
                  //           // 'distance': distance,
                  //           // 'distanceInKM': distanceInKm,
                  //           // 'duration': duration,
                  //           // 'durationInMinutes': durationInMinutes,
                  //         };
                  //         print(newHospital);
                  //         newNearbyHospitals.add(newHospital);
                  //       }
                  //     }
                  //     String urlDistance =
                  //         'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$latlng&mode=driving&origins=${latLng.latitude},${latLng.longitude}&key=${dotenv.env['GOOGLE_CLOUD_API_KEY'] as String}';
                  //     var distanceMatrixResponse =
                  //         await http.get(Uri.parse(urlDistance));
                  //     var distanceMatrixJsonResponse =
                  //         json.decode(distanceMatrixResponse.body);
                  //     var distanceMatrixRows =
                  //         distanceMatrixJsonResponse['rows'];
                  //     for (var i = 0;
                  //         i < distanceMatrixRows[0]['elements'].length;
                  //         i++) {
                  //       var row = distanceMatrixRows[0]['elements'][i];
                  //       var distance = row['distance']['text'];
                  //       int distanceInMeters = row['distance']['value'];
                  //       var duration = row['duration']['text'];
                  //       int durationInSeconds = row['duration']['value'];
                  //       double distanceInKm = distanceInMeters / 1000;
                  //       double durationInMinutes = durationInSeconds / 60;
                  //       distanceInKm =
                  //           double.parse(distanceInKm.toStringAsFixed(2));
                  //       durationInMinutes =
                  //           double.parse(durationInMinutes.toStringAsFixed(1));
                  //       newNearbyHospitals[i]['distance'] = distance;
                  //       newNearbyHospitals[i]['distanceInKM'] = distanceInKm;
                  //       newNearbyHospitals[i]['duration'] = duration;
                  //       newNearbyHospitals[i]['durationInMinutes'] =
                  //           durationInMinutes;
                  //       // print(newNearbyHospitals[i]);
                  //     }
                  //     newNearbyHospitals.sort((a, b) =>
                  //         a['distanceInKM'].compareTo(b['distanceInKM']));
                  //     var nearestHospital = newNearbyHospitals[0];
                  //     Navigator.pushNamed(context, MapScreen.routeName,
                  //         arguments: {
                  //           'hospital': nearestHospital,
                  //           'currentLocation': latLng,
                  //         });
                  //   } else {
                  //     print("No user location found");
                  //   }
                  // });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) {
                      return RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          getProportionateScreenWidth(100),
                        ),
                      );
                    },
                  ),
                  overlayColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.grey.withOpacity(0.5)),
                ),
                child: Image.asset(
                  'assets/images/SOS-Button.png',
                  width: getProportionateScreenWidth(190),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                ),
                child: Column(
                  children: const [
                    PickupForm(),
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorIconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, FirstAidTipsScreen.routeName);
                      },
                      iconFirst: true,
                      setIcon: Icons.medical_services_outlined,
                      color: kSecondaryColor,
                      topText: "       First-Aid",
                      bottomText: "      Tips"),
                  SizedBox(width: getProportionateScreenWidth(30)),
                  ColorIconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, ComingSoonScreen.routeName);
                      },
                      iconFirst: false,
                      setIcon: Icons.near_me_outlined,
                      color: kErrorColor,
                      topText: "SOS       ",
                      bottomText: "Message      "),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
