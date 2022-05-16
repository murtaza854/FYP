import 'dart:async';
import 'dart:convert';

import 'package:app/components/outlined_button_custom.dart';
import 'package:app/constants.dart';
import 'package:app/screens/home/home_screen.dart';
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
// import 'package:url_launcher/url_launcher.dart';

class Tracking extends StatefulWidget {
  Tracking({
    Key? key,
    required this.pointsMarker,
    required this.name,
    required this.contactNumber,
    required this.medicalCard,
    required this.updateDetails,
    required this.patientLocation,
    // required this.currentLocationString,
    // required this.ambulanceType,
    // required this.ambulances,
    // required this.changeActiveIndex,
    // required this.chosenHospital,
    // required this.loading,
    // required this.updateLoading,
  }) : super(key: key);

  final List<LatLng> pointsMarker;
  final String name;
  final String contactNumber;
  final Map medicalCard;
  final Function updateDetails;
  final LatLng patientLocation;
  // final String currentLocationString;
  // final int ambulanceType;
  // final List<dynamic> ambulances;
  // final Function changeActiveIndex;
  // bool loading;
  // ignore: prefer_typing_uninitialized_variables
  // var chosenHospital;
  // final Function updateLoading;

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  late Timer timer;
  CollectionReference ridesCollection =
      FirebaseFirestore.instance.collection('inProgressRides');
  String timeLeft = 'Loading...';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callMehtod();
    ridesCollection
        .where('driverEmail', isEqualTo: globals.inProgressRide['driverEmail'])
        .where('patientEmail',
            isEqualTo: globals.inProgressRide['patientEmail'])
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        print(value.docs[0].id);
        ridesCollection.doc(value.docs[0].id).snapshots().listen((value) {
          setState(() {
            globals.inProgressRide = value.data();
            widget.updateDetails();
          });
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> callMehtod() async {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      //place you code for calling after,every 60 seconds.
      // print("timer");
      try {
        String latlngStart =
            '${widget.pointsMarker[0].latitude},${widget.pointsMarker[0].longitude}';
        String latlngEnd =
            '${widget.pointsMarker[1].latitude},${widget.pointsMarker[1].longitude}';
        String urlDistance =
            'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$latlngEnd&mode=driving&origins=$latlngStart&key=${dotenv.env['GOOGLE_CLOUD_API_KEY'] as String}';
        var distanceMatrixResponse = await http.get(Uri.parse(urlDistance));
        var distanceMatrixJsonResponse =
            json.decode(distanceMatrixResponse.body);
        var distanceMatrixRows = distanceMatrixJsonResponse['rows'];
        for (var i = 0; i < distanceMatrixRows[0]['elements'].length; i++) {
          var row = distanceMatrixRows[0]['elements'][i];
          // var duration = row['duration']['text'];
          int durationInSeconds = row['duration']['value'];
          // format to X min X sec
          int minutes = durationInSeconds ~/ 60;
          int seconds = durationInSeconds % 60;
          String duration = '$minutes min $seconds sec';
          setState(() {
            // timeMinutes = durationInMinutes.toString();
            // timeSeconds = (durationInMinutes * 60).toString();
            timeLeft = duration;
          });
        }
      } catch (e) {
        timer.cancel();
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (BuildContext context, ScrollController scrollController) {
          return globals.inProgressRide != null
              ? Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      )),
                  child: SingleChildScrollView(
                    child: Column(
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
                                  globals.inProgressRide['part'] == 'part1'
                                      ? Icons.account_circle_outlined
                                      : Icons.local_hospital,
                                  color: kPrimaryColor,
                                  size: getProportionateScreenWidth(40),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                Flexible(
                                  child: Text(
                                    widget.name,
                                    style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontSize:
                                            getProportionateScreenWidth(18),
                                        color: kPrimaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        globals.inProgressRide['part'] == 'part1'
                            ? Padding(
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
                                        Icons.phone,
                                        color: kErrorColor,
                                        size: getProportionateScreenWidth(40),
                                      ),
                                      SizedBox(
                                        width: getProportionateScreenWidth(10),
                                      ),
                                      Flexible(
                                        child: Text(
                                          widget.contactNumber,
                                          style: TextStyle(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      18),
                                              color: kPrimaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
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
                                  // FontAwesome5.clock,
                                  Icons.access_time,
                                  color: kPrimaryColor,
                                  size: getProportionateScreenWidth(40),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                Flexible(
                                  child: Text(
                                    timeLeft,
                                    style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontSize:
                                            getProportionateScreenWidth(18),
                                        color: kPrimaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        globals.user?.role == 'Driver'
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(50),
                                  vertical: getProportionateScreenWidth(0),
                                ),
                                child: DefaultButton(
                                  text: "Medical Card",
                                  press: () {
                                    AlertDialog alert = AlertDialog(
                                      title: Text("Medical Card"),
                                      content: Text(
                                          widget.medicalCard['bloodGroup']),
                                      actions: [
                                        TextButton(
                                          child: Text("Close"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      },
                                    );
                                  },
                                ),
                              )
                            : Container(),
                        globals.user?.role == 'Driver'
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(50),
                                  vertical: getProportionateScreenWidth(0),
                                ),
                                child: OutlinedButtonCustom(
                                  text: "Google Maps",
                                  press: () {
                                    AlertDialog alert = AlertDialog(
                                      title: Text("Open Google Maps"),
                                      content: Text(
                                          "Do you want to open Google Maps?"),
                                      actions: [
                                        TextButton(
                                          child: Text("Yes"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _launchURLBrowser(Uri.parse(
                                                "https://www.google.com/maps/dir/?api=1&destination=${widget.patientLocation}"));
                                          },
                                        ),
                                        TextButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      },
                                    );
                                    // required this.idleLocation,
                                    // required this.currentLocationString,
                                    // required this.ambulanceType,
                                    // required this.ambulances,
                                    // required this.changeActiveIndex,
                                    // required this.chosenHospital,
                                    // print(widget.idleLocation);
                                    // print(widget.currentLocationString);
                                    // print(widget.chosenHospital);
                                    // callMehtod();
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
                            : Container(),
                        globals.user?.role == 'Driver' &&
                                globals.inProgressRide['part'] == 'part1'
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(50),
                                  vertical: getProportionateScreenWidth(0),
                                ),
                                child: OutlinedButtonCustom(
                                  text: "Reached",
                                  press: () {
                                    AlertDialog alert = AlertDialog(
                                      title: const Text("Reached Destination"),
                                      content: const Text(
                                          "Have you reached your destination?"),
                                      actions: [
                                        TextButton(
                                          child: const Text("Yes"),
                                          onPressed: () {
                                            ridesCollection
                                                .where('driverEmail',
                                                    isEqualTo:
                                                        globals.user?.email)
                                                .where('patientEmail',
                                                    isEqualTo:
                                                        globals.inProgressRide[
                                                            'patientEmail'])
                                                .get()
                                                .then((value) {
                                                  updateDriverStatus(globals.user?.email);
                                              for (var element in value.docs) {
                                                element.reference
                                                    .update({'part': 'part2'});
                                              }
                                              // for (var element in value.docs) {
                                              //   element.reference
                                              //       .delete()
                                              //       .then((value) {
                                              //     globals.inProgressRide[
                                              //         'part'] = 'part2';
                                              //     ridesCollection.add(
                                              //         globals.inProgressRide);
                                              //   });
                                              // }
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      },
                                    );
                                    // required this.idleLocation,
                                    // required this.currentLocationString,
                                    // required this.ambulanceType,
                                    // required this.ambulances,
                                    // required this.changeActiveIndex,
                                    // required this.chosenHospital,
                                    // print(widget.idleLocation);
                                    // print(widget.currentLocationString);
                                    // print(widget.chosenHospital);
                                    // callMehtod();
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
                            : Container(),
                        globals.inProgressRide['part'] == 'part1'
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(50),
                                  vertical: getProportionateScreenWidth(0),
                                ),
                                child: OutlinedButtonCustom(
                                  text: "Cancel",
                                  press: () {
                                    AlertDialog alert = AlertDialog(
                                      title: const Text("Cancel Booking"),
                                      content: const Text(
                                          "Are you sure you want to cancel this booking?"),
                                      actions: [
                                        TextButton(
                                          child: const Text("Yes"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            updateDriverStatus(globals
                                                .inProgressRide['driverEmail']);
                                            ridesCollection
                                                .where('driverEmail',
                                                    isEqualTo:
                                                        globals.inProgressRide[
                                                            'driverEmail'])
                                                .where('patientEmail',
                                                    isEqualTo:
                                                        globals.inProgressRide[
                                                            'patientEmail'])
                                                .get()
                                                .then((value) {
                                              for (var element in value.docs) {
                                                element.reference
                                                    .delete()
                                                    .then((value) {
                                                  if (globals.inProgressRide !=
                                                      null) {
                                                    globals.inProgressRide[
                                                        'part'] = 'cancled';
                                                    ridesCollection.add(
                                                        globals.inProgressRide);
                                                  }
                                                });
                                              }
                                            });
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("No"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      },
                                    );
                                    // required this.idleLocation,
                                    // required this.currentLocationString,
                                    // required this.ambulanceType,
                                    // required this.ambulances,
                                    // required this.changeActiveIndex,
                                    // required this.chosenHospital,
                                    // print(widget.idleLocation);
                                    // print(widget.currentLocationString);
                                    // print(widget.chosenHospital);
                                    // callMehtod();
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
                            : Container(),
                        globals.inProgressRide['part'] == 'part2' &&
                                globals.user?.role == 'Driver'
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(50),
                                  vertical: getProportionateScreenWidth(0),
                                ),
                                child: OutlinedButtonCustom(
                                  text: "Ride End",
                                  press: () {
                                    AlertDialog alert = AlertDialog(
                                      title: const Text("End Ride"),
                                      content: const Text(
                                          "Are you sure you want to end the ride?"),
                                      actions: [
                                        TextButton(
                                          child: const Text("Yes"),
                                          onPressed: () {
                                            ridesCollection
                                                .where('driverEmail',
                                                    isEqualTo:
                                                        globals.inProgressRide[
                                                            'driverEmail'])
                                                .where('patientEmail',
                                                    isEqualTo:
                                                        globals.inProgressRide[
                                                            'patientEmail'])
                                                .get()
                                                .then((value) {
                                              for (var element in value.docs) {
                                                element.reference.update({
                                                  'status': 'completed',
                                                }).then((value) {
                                                  AlertDialog alert = const AlertDialog(
                                                      title: Text("Ride Ended"),
                                                      content: Text(
                                                          "Your ride has ended"),
                                                      actions: []);
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return alert;
                                                    },
                                                  );
                                                  Navigator.pushNamed(context,
                                                      HomeScreen.routeName);
                                                });
                                                // .delete()
                                                //     .then((value) {
                                                //   // globals.inProgressRide[
                                                //   //     'status'] = 'completed';
                                                //   // ridesCollection.add(
                                                //   //     globals.inProgressRide);
                                                //   Navigator.pushNamed(context,
                                                //       HomeScreen.routeName);
                                                // });
                                              }
                                            });
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("No"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      },
                                    );
                                    // required this.idleLocation,
                                    // required this.currentLocationString,
                                    // required this.ambulanceType,
                                    // required this.ambulances,
                                    // required this.changeActiveIndex,
                                    // required this.chosenHospital,
                                    // print(widget.idleLocation);
                                    // print(widget.currentLocationString);
                                    // print(widget.chosenHospital);
                                    // callMehtod();
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
                            : Container(),
                      ],
                    ),
                  ),
                  // ),
                )
              : Container();
        });
  }

  _launchURLBrowser(Uri url) async {
    // launch(url.toString());
    // if (await canLaunchUrl(url)) {
    //   await launchUrl(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  updateDriverStatus(email) {
    print(email);
    http.post(
      Uri.parse(
        "${dotenv.env['API_URL1']}/user/set-ride-in-progress",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${dotenv.env['API_KEY_BEARER']}",
      },
      body: jsonEncode(
        {
          "email": email,
        },
      ),
    );
  }

  // void getAvailableDrivers() async {
  //   final response = await http.post(
  //       Uri.parse("${dotenv.env['API_URL1']}/user/get-available-drivers"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': "Bearer ${dotenv.env['API_KEY_BEARER']}",
  //       },
  //       body: jsonEncode({"ambulanceType": widget.ambulanceType}));
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     String latlng = "";
  //     for (var i = 0; i < data.length; i++) {
  //       var driver = data[i];
  //       if (sentRequests.contains(driver['email']) ||
  //           rejectedRequests.contains(driver['email'])) {
  //       } else {
  //         double lat = driver['currentLocation']['latitude'];
  //         double lng = driver['currentLocation']['longitude'];
  //         if (i == data.length - 1) {
  //           latlng += '$lat,$lng';
  //         } else {
  //           latlng += '$lat,$lng|';
  //         }
  //       }
  //     }
  //     setState(() {
  //       startingRadius += 1000;
  //     });
  //     if (latlng != '') {
  //       String urlDistance =
  //           'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$latlng&mode=driving&origins=${widget.idleLocation.latitude},${widget.idleLocation.longitude}&key=${dotenv.env['GOOGLE_CLOUD_API_KEY'] as String}';
  //       var distanceMatrixResponse = await http.get(Uri.parse(urlDistance));
  //       var distanceMatrixJsonResponse =
  //           json.decode(distanceMatrixResponse.body);
  //       var distanceMatrixRows = distanceMatrixJsonResponse['rows'];
  //       var drivers = [];
  //       for (var i = 0; i < distanceMatrixRows[0]['elements'].length; i++) {
  //         var row = distanceMatrixRows[0]['elements'][i];
  //         var distance = row['distance']['text'];
  //         int distanceInMeters = row['distance']['value'];
  //         var duration = row['duration']['text'];
  //         int durationInSeconds = row['duration']['value'];
  //         if (distanceInMeters < startingRadius) {
  //           double distanceInKm = distanceInMeters / 1000;
  //           double durationInMinutes = durationInSeconds / 60;
  //           distanceInKm = double.parse(distanceInKm.toStringAsFixed(2));
  //           durationInMinutes =
  //               double.parse(durationInMinutes.toStringAsFixed(1));
  //           data[i]['distance'] = distance;
  //           data[i]['distanceInKM'] = distanceInKm;
  //           data[i]['duration'] = duration;
  //           data[i]['durationInMinutes'] = durationInMinutes;
  //           drivers.add(data[i]);
  //         }
  //       }
  //       drivers.sort((a, b) => (a['durationInMinutes'] as double)
  //           .compareTo(b['durationInMinutes'] as double));
  //       // print(drivers);
  //       for (var driver in drivers) {
  //         print(driver);
  //         if (sentRequests.contains(driver['email']) ||
  //             rejectedRequests.contains(driver['email'])) {
  //         } else {
  //           // print(widget.chosenHospital);
  //           await ridesCollection.add({
  //             'patientEmail': globals.user?.email,
  //             'driverEmail': driver['email'],
  //             'ambulanceType': widget.ambulanceType,
  //             'patientLocation': {
  //               'latitude': widget.idleLocation.latitude,
  //               'longitude': widget.idleLocation.longitude
  //             },
  //             'patientName': globals.user?.getName(),
  //             'patientPhone': globals.user?.contactNumber,
  //             'driverName': driver['firstName'] + ' ' + driver['lastName'],
  //             'driverPhone': driver['contactNumber'],
  //             'driverLocation': {
  //               'latitude': driver['currentLocation']['latitude'],
  //               'longitude': driver['currentLocation']['longitude']
  //             },
  //             'chosenHospital': widget.chosenHospital,
  //             'medicalCard': globals.user?.medicalCard,
  //             'createdAt': FieldValue.serverTimestamp(),
  //           });
  //           sentRequests.add(driver['email']);
  //           var _id = driver['_id'];
  //           sendNotification(
  //               [_id],
  //               "Alert! An ambulance is needed! Please respond.",
  //               "Ambulance Request");
  //         }
  //       }
  //       setState(() {
  //         this.drivers = drivers;
  //       });
  //     } else {}
  //   }
  // }

  // Future<http.Response?> sendNotification(
  //     List<String> tokenIdList, String contents, String heading) async {
  //   try {
  //     http.Response response = await http.post(
  //       Uri.parse(
  //         'https://onesignal.com/api/v1/notifications',
  //       ),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         "Authorization": "Basic ${dotenv.env['ONESIGNAL_REST_API_KEY']}"
  //       },
  //       body: jsonEncode(<String, dynamic>{
  //         "app_id": "${dotenv.env['ONESIGNAL_APP_ID']}",

  //         "include_external_user_ids": tokenIdList,

  //         // android_accent_color reprsent the color of the heading text in the notifiction
  //         // "android_accent_color": "FF9976D2",

  //         "small_icon": "ic_stat_onesignal_default",

  //         "headings": {"en": heading},

  //         "contents": {"en": contents},
  //         'channel_for_external_user_ids': "push"
  //       }),
  //     );
  //     return response;
  //   } catch (e) {
  //     return null;
  //   }
  // }
}
