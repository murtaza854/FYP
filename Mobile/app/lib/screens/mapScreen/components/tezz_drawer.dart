import 'dart:async';
import 'dart:convert';

import 'package:app/components/outlined_button_custom.dart';
import 'package:app/constants.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../components/default_button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../globals.dart' as globals;
import '../../mapsTracking/maps_tracking.dart';

class TezzDrawer extends StatefulWidget {
  TezzDrawer({
    Key? key,
    required this.idleLocation,
    required this.currentLocationString,
    required this.ambulanceType,
    required this.ambulances,
    required this.changeActiveIndex,
    required this.chosenHospital,
    required this.loading,
    required this.updateLoading,
  }) : super(key: key);

  final LatLng idleLocation;
  final String currentLocationString;
  final int ambulanceType;
  final List<dynamic> ambulances;
  final Function changeActiveIndex;
  bool loading;
  // ignore: prefer_typing_uninitialized_variables
  var chosenHospital;
  final Function updateLoading;

  @override
  State<TezzDrawer> createState() => _TezzDrawerState();
}

class _TezzDrawerState extends State<TezzDrawer> {
  List<dynamic> drivers = [];
  late Timer timer;
  late Timer timer1;
  int startingRadius = 4000;
  List<dynamic> sentRequests = [];
  List<dynamic> rejectedRequests = [];
  CollectionReference ridesCollection =
      FirebaseFirestore.instance.collection('rides');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      startingRadius = 4000;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    timer1.cancel();
    super.dispose();
  }

  Future<void> callMehtod() async {
    getAvailableDrivers();
    Timer.periodic(const Duration(seconds: 10), (timer) {
      //place you code for calling after,every 60 seconds.
      print("timer");
      if (widget.loading == false) {
        timer.cancel();
      } else {
        getAvailableDrivers();
      }
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      //place you code for calling after,every 60 seconds.
      if (globals.inProgressRide != null) {
        widget.updateLoading(false);
        setState(() {
          drivers = [];
        });
        timer.cancel();
        Navigator.pushNamed(context, MapsTracking.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.5,
        maxChildSize: 0.5,
        builder: (BuildContext context, ScrollController scrollController) {
          return globals.inProgressRide == null
              ? Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      )),
                  child: widget.loading == false
                      ? Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(140),
                                vertical: getProportionateScreenHeight(20),
                              ),
                              child: Container(
                                  height: getProportionateScreenHeight(5),
                                  decoration: BoxDecoration(
                                    color: kTextColor,
                                    borderRadius: BorderRadius.circular(50),
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: getProportionateScreenWidth(10),
                                bottom: getProportionateScreenWidth(0),
                                left: getProportionateScreenWidth(20),
                                right: getProportionateScreenWidth(20),
                                // vertical: getProportionateScreenWidth(5),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.near_me_outlined,
                                      color: kPrimaryColor,
                                      size: getProportionateScreenWidth(40),
                                    ),
                                    SizedBox(
                                      width: getProportionateScreenWidth(10),
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.currentLocationString,
                                        style: TextStyle(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                            fontSize:
                                                getProportionateScreenWidth(18),
                                            color: kPrimaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: getProportionateScreenWidth(0),
                                bottom: getProportionateScreenWidth(0),
                                left: getProportionateScreenWidth(20),
                                right: getProportionateScreenWidth(20),
                                // vertical: getProportionateScreenWidth(5),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.local_hospital_outlined,
                                      color: kErrorColor,
                                      size: getProportionateScreenWidth(40),
                                    ),
                                    SizedBox(
                                      width: getProportionateScreenWidth(10),
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.ambulances[widget.ambulanceType]
                                            ['name'],
                                        style: TextStyle(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                            fontSize:
                                                getProportionateScreenWidth(18),
                                            color: kPrimaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: getProportionateScreenWidth(0),
                                bottom: getProportionateScreenWidth(20),
                                left: getProportionateScreenWidth(20),
                                right: getProportionateScreenWidth(20),
                                // vertical: getProportionateScreenWidth(5),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Icon(
                                      // FontAwesome5.hospital,
                                      Icons.local_hospital_outlined,
                                      color: kPrimaryColor,
                                      size: getProportionateScreenWidth(40),
                                    ),
                                    SizedBox(
                                      width: getProportionateScreenWidth(10),
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.chosenHospital['name'],
                                        style: TextStyle(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                            fontSize:
                                                getProportionateScreenWidth(18),
                                            color: kPrimaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(50),
                                vertical: getProportionateScreenWidth(20),
                              ),
                              child: DefaultButton(
                                text: "Tezz",
                                press: () async {
                                  setState(() {
                                    widget.updateLoading(true);
                                  });
                                  // required this.idleLocation,
                                  // required this.currentLocationString,
                                  // required this.ambulanceType,
                                  // required this.ambulances,
                                  // required this.changeActiveIndex,
                                  // required this.chosenHospital,
                                  // print(widget.idleLocation);
                                  // print(widget.currentLocationString);
                                  // print(widget.chosenHospital);
                                  callMehtod();
                                  // print(drivers);
                                  // final response = await http.post(
                                  //     Uri.parse(
                                  //         "${dotenv.env['API_URL1']}/user/getID"),
                                  //     // Uri.parse("${dotenv.env['API_URL2']}/user/getPatientList"),
                                  //     // Uri.parse("${dotenv.env['API_URL3']}/user/getID"),
                                  //     // "${dotenv.env['API_URL3']}/user/getPatientList"),
                                  //     headers: {
                                  //       'Content-Type': 'application/json',
                                  //       'Authorization':
                                  //           "Bearer ${dotenv.env['API_KEY_BEARER']}",
                                  //     },
                                  //     body: jsonEncode(
                                  //         {"email": chosenUsers[0].email}));
                                  // if (response.statusCode == 200) {
                                  //   var data = json.decode(response.body);
                                  //   var _id = data['_id'];
                                  //   sendNotification([
                                  //     _id
                                  //   ], "${globals.user?.firstName} wants to add you as a $selectedRelationship",
                                  //       "New Emergency Contact Request");
                                  // } else {
                                  //   print(response.statusCode);
                                  // }
                                  // setState(() {
                                  //   // widget.changeActiveIndex(3);
                                  // });
                                },
                              ),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            const Spacer(),
                            SizedBox(
                              height: getProportionateScreenHeight(100),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      kPrimaryColor),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            Text(
                              "Please wait...",
                              style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: getProportionateScreenWidth(18),
                                color: kPrimaryColor,
                              ),
                            ),
                            Text(
                              "Looking for an ambulance",
                              style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: getProportionateScreenWidth(18),
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            OutlinedButtonCustom(
                              mobileWidth: getProportionateScreenWidth(100),
                              text: "Cancel",
                              press: () {
                                // delete from ridesCollection where patientEmail = driverEmail
                                // var rides = [...globals.rides];
                                // rides.removeWhere((element) =>
                                //     element.patientEmail == globals.user?.email);
                                ridesCollection
                                    .where("patientEmail",
                                        isEqualTo: globals.user?.email)
                                    .get()
                                    .then((value) {
                                  for (var element in value.docs) {
                                    element.reference.delete();
                                  }
                                });
                                setState(() {
                                  widget.updateLoading(false);
                                  drivers = [];
                                  // globals.rides = rides;
                                });
                              },
                            ),
                            // ),
                            const Spacer(),
                          ],
                        ),
                  // ),
                )
              : Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      )),
                  child: Center(
                    child: Text(
                      "You cancelled the ride",
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: getProportionateScreenWidth(18),
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                );
        });
  }

  void getAvailableDrivers() async {
    final response = await http.post(
        Uri.parse("${dotenv.env['API_URL1']}/user/get-available-drivers"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${dotenv.env['API_KEY_BEARER']}",
        },
        body: jsonEncode({"ambulanceType": widget.ambulanceType}));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String latlng = "";
      for (var i = 0; i < data.length; i++) {
        var driver = data[i];
        if (sentRequests.contains(driver['email']) ||
            rejectedRequests.contains(driver['email'])) {
        } else {
          double lat = driver['currentLocation']['latitude'];
          double lng = driver['currentLocation']['longitude'];
          if (i == data.length - 1) {
            latlng += '$lat,$lng';
          } else {
            latlng += '$lat,$lng|';
          }
        }
      }
      setState(() {
        startingRadius += 1000;
      });
      if (latlng != '') {
        String urlDistance =
            'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$latlng&mode=driving&origins=${widget.idleLocation.latitude},${widget.idleLocation.longitude}&key=${dotenv.env['GOOGLE_CLOUD_API_KEY'] as String}';
        var distanceMatrixResponse = await http.get(Uri.parse(urlDistance));
        var distanceMatrixJsonResponse =
            json.decode(distanceMatrixResponse.body);
        var distanceMatrixRows = distanceMatrixJsonResponse['rows'];
        var drivers = [];
        for (var i = 0; i < distanceMatrixRows[0]['elements'].length; i++) {
          var row = distanceMatrixRows[0]['elements'][i];
          var distance = row['distance']['text'];
          int distanceInMeters = row['distance']['value'];
          var duration = row['duration']['text'];
          int durationInSeconds = row['duration']['value'];
          if (distanceInMeters < startingRadius) {
            double distanceInKm = distanceInMeters / 1000;
            double durationInMinutes = durationInSeconds / 60;
            distanceInKm = double.parse(distanceInKm.toStringAsFixed(2));
            durationInMinutes =
                double.parse(durationInMinutes.toStringAsFixed(1));
            data[i]['distance'] = distance;
            data[i]['distanceInKM'] = distanceInKm;
            data[i]['duration'] = duration;
            data[i]['durationInMinutes'] = durationInMinutes;
            drivers.add(data[i]);
          }
        }
        drivers.sort((a, b) => (a['durationInMinutes'] as double)
            .compareTo(b['durationInMinutes'] as double));
        // print(drivers);
        for (var driver in drivers) {
          print(driver);
          if (sentRequests.contains(driver['email']) ||
              rejectedRequests.contains(driver['email'])) {
          } else {
            // print(widget.chosenHospital);
            await ridesCollection.add({
              'patientEmail': globals.user?.email,
              'driverEmail': driver['email'],
              'ambulanceType': widget.ambulanceType,
              'patientLocation': {
                'latitude': widget.idleLocation.latitude,
                'longitude': widget.idleLocation.longitude
              },
              'patientName': globals.user?.getName(),
              'patientPhone': globals.user?.contactNumber,
              'driverName': driver['firstName'] + ' ' + driver['lastName'],
              'driverPhone': driver['contactNumber'],
              'driverLocation': {
                'latitude': driver['currentLocation']['latitude'],
                'longitude': driver['currentLocation']['longitude']
              },
              'chosenHospital': widget.chosenHospital,
              'medicalCard': globals.user?.medicalCard,
              'createdAt': FieldValue.serverTimestamp(),
            });
            sentRequests.add(driver['email']);
            var _id = driver['_id'];
            sendNotification(
                [_id],
                "Alert! An ambulance is needed! Please respond.",
                "Ambulance Request");
          }
        }
        setState(() {
          this.drivers = drivers;
        });
      } else {}
    }
  }

  Future<http.Response?> sendNotification(
      List<String> tokenIdList, String contents, String heading) async {
    try {
      http.Response response = await http.post(
        Uri.parse(
          'https://onesignal.com/api/v1/notifications',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Basic ${dotenv.env['ONESIGNAL_REST_API_KEY']}"
        },
        body: jsonEncode(<String, dynamic>{
          "app_id": "${dotenv.env['ONESIGNAL_APP_ID']}",

          "include_external_user_ids": tokenIdList,

          // android_accent_color reprsent the color of the heading text in the notifiction
          // "android_accent_color": "FF9976D2",

          "small_icon": "ic_stat_onesignal_default",

          "headings": {"en": heading},

          "contents": {"en": contents},
          'channel_for_external_user_ids': "push"
        }),
      );
      return response;
    } catch (e) {
      return null;
    }
  }
}
