import 'dart:async';

import 'package:app/constants.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:geocoding/geocoding.dart' as geocoding;
import '../../../globals.dart' as globals;
import 'tracking.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late GoogleMapController mapController;
  CameraPosition? cameraPosition;
  MapType _currentMapType = MapType.normal;
  Set<Marker> _markers = {};
  // LatLng startLocation = const LatLng(24.9049269, 67.1380395);
  // LatLng idleLocation = const LatLng(24.9049269, 67.1380395);
  LatLng middleLocation = const LatLng(24.9049269, 67.1380395);
  // String currentLocationString = "Loading...";
  List<LatLng> polylineCoordinates = [];
  List<LatLng> pointsMarker = [];
  bool loading = false;
  CollectionReference userLocationsCollection =
      FirebaseFirestore.instance.collection('userLocations');
  // CollectionReference inProgressRidesCollection =
  //     FirebaseFirestore.instance.collection('inProgressRides');
  late Timer timer;
  String name = '';
  String contactNumber = '';
  Map medicalCard = {};
  LatLng patientLocation = const LatLng(0, 0);

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> callMehtod() async {
    try {
      setLocation(true, false);
    } catch (e) {
      Navigator.pushNamed(context, HomeScreen.routeName);
    }
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        setLocation(false, timer);
      } catch (e) {
        timer.cancel();
        Navigator.pushNamed(context, HomeScreen.routeName);
      }
      if (globals.inProgressRide == null) {
        timer.cancel();
        Navigator.pushNamed(context, HomeScreen.routeName);
      }
      //place you code for calling after,every 60 seconds.
      // print("timer");
      // update marker position
    });
  }

  updateDetails() {
    if (globals.inProgressRide != null && globals.user?.role == 'Patient') {
      setState(() {
        if (globals.inProgressRide['part'] == 'part1') {
          name = globals.inProgressRide['driverName'];
          contactNumber = globals.inProgressRide['driverPhone'];
        } else if (globals.inProgressRide['part'] == 'part2') {
          name = globals.inProgressRide['chosenHospital']['name'];
        } else {
          // AlertDialog alert = const AlertDialog(
          //     title: Text("Ride Ended"),
          //     content: Text("Your ride has ended"),
          //     actions: []);
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return alert;
          //   },
          // );
          // Navigator.pushNamed(context, HomeScreen.routeName);
        }
      });
    } else if (globals.inProgressRide != null &&
        globals.user?.role == 'Driver') {
      setState(() {
        if (globals.inProgressRide['part'] == 'part1') {
          name = globals.inProgressRide['patientName'];
          contactNumber = globals.inProgressRide['patientPhone'];
          medicalCard = globals.inProgressRide['medicalCard'];
          patientLocation = LatLng(
              globals.inProgressRide['patientLocation']['latitude'],
              globals.inProgressRide['patientLocation']['longitude']);
        } else if (globals.inProgressRide['part'] == 'part2') {
          name = globals.inProgressRide['chosenHospital']['name'];
          medicalCard = globals.inProgressRide['medicalCard'];
          patientLocation = LatLng(
              globals.inProgressRide['chosenHospital']['geometry']['location']
                  ['lat'],
              globals.inProgressRide['chosenHospital']['geometry']['location']
                  ['lng']);
        } else {
          print('------------------');
          print(1221421424);
          print('------------------');
          AlertDialog alert = const AlertDialog(
              title: Text("Ride Ended"),
              content: Text("Your ride has ended"),
              actions: []);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
          timer.cancel();
          // Navigator.pushNamed(context, HomeScreen.routeName);
        }
      });
    }
  }

  setLocation(flag, timer) async {
    List<LatLng> points = [];
    if (globals.inProgressRide != null &&
        globals.inProgressRide['part'] == 'part1') {
      var driverEmail = globals.inProgressRide['driverEmail'];
      Set<Marker> markers = {};
      DocumentSnapshot userLocation = await userLocationsCollection
          .where('email', isEqualTo: driverEmail)
          .get()
          .then((snapshot) => snapshot.docs[0]);
      if (userLocation.exists) {
        final data = userLocation.data() as Map<String, dynamic>;
        if (globals.user?.role == 'Driver') {
          markers.add(
            Marker(
              markerId: MarkerId(0.toString()),
              position: LatLng(data['currentLocation']['lat'],
                  data['currentLocation']['lng']),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
            ),
          );
          markers.add(
            Marker(
              markerId: MarkerId(1.toString()),
              position: LatLng(
                  globals.inProgressRide['patientLocation']['latitude'],
                  globals.inProgressRide['patientLocation']['longitude']),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            ),
          );
        } else {
          markers.add(
            Marker(
              markerId: MarkerId(0.toString()),
              position: LatLng(
                  globals.inProgressRide['patientLocation']['latitude'],
                  globals.inProgressRide['patientLocation']['longitude']),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
            ),
          );
          markers.add(
            Marker(
              markerId: MarkerId(1.toString()),
              position: LatLng(data['currentLocation']['lat'],
                  data['currentLocation']['lng']),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            ),
          );
        }
        points.add(LatLng(
            data['currentLocation']['lat'], data['currentLocation']['lng']));
        points.add(LatLng(globals.inProgressRide['patientLocation']['latitude'],
            globals.inProgressRide['patientLocation']['longitude']));
      }
      _markers.clear();
      setState(() {
        _markers = markers;
        pointsMarker = points;
        middleLocation = computeCentroid(points);
      });
      if (flag) {
        _changeCameraPosition();
      }
    } else {
      var driverEmail = globals.inProgressRide['driverEmail'];
      Set<Marker> markers = {};
      DocumentSnapshot userLocation = await userLocationsCollection
          .where('email', isEqualTo: driverEmail)
          .get()
          .then((snapshot) => snapshot.docs[0]);
      if (userLocation.exists) {
        final data = userLocation.data() as Map<String, dynamic>;
        if (globals.user?.role == 'Driver') {
        } else {}
        markers.add(
          Marker(
            markerId: MarkerId(0.toString()),
            position: LatLng(
                data['currentLocation']['lat'], data['currentLocation']['lng']),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        );
        markers.add(
          Marker(
            markerId: MarkerId(1.toString()),
            position: LatLng(
                globals.inProgressRide['chosenHospital']['geometry']['location']
                    ['lat'],
                globals.inProgressRide['chosenHospital']['geometry']['location']
                    ['lng']),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        );
        points.add(LatLng(
            data['currentLocation']['lat'], data['currentLocation']['lng']));
        points.add(LatLng(
            globals.inProgressRide['chosenHospital']['geometry']['location']
                ['lat'],
            globals.inProgressRide['chosenHospital']['geometry']['location']
                ['lng']));
      }
      _markers.clear();
      setState(() {
        _markers = markers;
        pointsMarker = points;
        middleLocation = computeCentroid(points);
      });
      if (flag) {
        _changeCameraPosition();
      }
      // var driverEmail = globals.inProgressRide['driverEmail'];
      // DocumentSnapshot userLocation = await userLocationsCollection
      //     .where('email', isEqualTo: driverEmail)
      //     .get()
      //     .then((snapshot) => snapshot.docs[0]);
      // // var i = 0;
      // Set<Marker> markers = {};
      // if (userLocation.exists) {
      //   final data = userLocation.data() as Map<String, dynamic>;
      //   // if (globals.user?.email == email) {
      //   markers.add(
      //     Marker(
      //       markerId: MarkerId(0.toString()),
      //       position: LatLng(data['currentLocation']['lat'],
      //           data['currentLocation']['lng']),
      //       icon: BitmapDescriptor.defaultMarkerWithHue(
      //         BitmapDescriptor.hueGreen,
      //       ),
      //     ),
      //   );
      //   // } else {
      //   markers.add(
      //     Marker(
      //       markerId: MarkerId(1.toString()),
      //       position: LatLng(
      //           globals.inProgressRide['chosenHospital']['geometry']
      //               ['location']['lat'],
      //           globals.inProgressRide['chosenHospital']['geometry']
      //               ['location']['lng']),
      //       icon: BitmapDescriptor.defaultMarkerWithHue(
      //         BitmapDescriptor.hueRed,
      //       ),
      //     ),
      //   );
      //   setState(() {
      //     _markers = markers;
      //   });
      //   // }
      //   // i++;
      //   // userLocation.get(
      //   // points.add(LatLng(
      //   //     userLocation.data()['currentLocation']['lat'],
      //   //     userLocation.data()['currentLocation']['lng']));
      // }
    }
  }

  updateLoading(loading) {
    setState(() {
      this.loading = loading;
    });
  }

  void _changeCameraPosition() async {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: middleLocation,
          zoom: 14.5,
          bearing: 45.0,
          tilt: 45.0,
        ),
      ),
    );
  }

  LatLng computeCentroid(List<LatLng> points) {
    double latitude = 0;
    double longitude = 0;
    int n = points.length;

    for (LatLng point in points) {
      latitude += point.latitude;
      longitude += point.longitude;
    }

    return LatLng(latitude / n, longitude / n);
  }

  // late final LatLng _lastMapPosition;

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    // List<geocoding.Placemark> placemarks =
    //     await geocoding.placemarkFromCoordinates(
    //         idleLocation.latitude, idleLocation.longitude);
    // geocoding.Placemark placemark = placemarks[0];
    // String text =
    //     '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}';
    // var inProgressRideUsers = globals.inProgressRide['users'];
    // List<LatLng> points = [];
    // var i = 0;
    // Set<Marker> markers = {};
    // if (globals.inProgressRide['part'] == 'part1') {
    //   for (var email in inProgressRideUsers) {
    //     DocumentSnapshot userLocation = await userLocationsCollection
    //         .where('email', isEqualTo: email)
    //         .get()
    //         .then((snapshot) => snapshot.docs[0]);
    //     if (userLocation.exists) {
    //       final data = userLocation.data() as Map<String, dynamic>;
    //       points.add(LatLng(
    //           data['currentLocation']['lat'], data['currentLocation']['lng']));
    //       if (globals.user?.email == email) {
    //         markers.add(
    //           Marker(
    //             markerId: MarkerId(i.toString()),
    //             position: LatLng(data['currentLocation']['lat'],
    //                 data['currentLocation']['lng']),
    //             icon: BitmapDescriptor.defaultMarkerWithHue(
    //               BitmapDescriptor.hueGreen,
    //             ),
    //           ),
    //         );
    //       } else {
    //         markers.add(
    //           Marker(
    //             markerId: MarkerId(i.toString()),
    //             position: LatLng(data['currentLocation']['lat'],
    //                 data['currentLocation']['lng']),
    //             icon: BitmapDescriptor.defaultMarkerWithHue(
    //               BitmapDescriptor.hueRed,
    //             ),
    //           ),
    //         );
    //       }
    //       i++;
    //       // userLocation.get(
    //       // points.add(LatLng(
    //       //     userLocation.data()['currentLocation']['lat'],
    //       //     userLocation.data()['currentLocation']['lng']));
    //     }
    //   }
    // } else {
    //   var driverEmail = globals.inProgressRide['driverEmail'];
    //   DocumentSnapshot userLocation = await userLocationsCollection
    //       .where('email', isEqualTo: driverEmail)
    //       .get()
    //       .then((snapshot) => snapshot.docs[0]);
    //   // var i = 0;
    //   if (userLocation.exists) {
    //     final data = userLocation.data() as Map<String, dynamic>;
    //     // if (globals.user?.email == email) {
    //     points.add(LatLng(
    //         data['currentLocation']['lat'], data['currentLocation']['lng']));
    //     markers.add(
    //       Marker(
    //         markerId: MarkerId(0.toString()),
    //         position: LatLng(
    //             data['currentLocation']['lat'], data['currentLocation']['lng']),
    //         icon: BitmapDescriptor.defaultMarkerWithHue(
    //           BitmapDescriptor.hueGreen,
    //         ),
    //       ),
    //     );
    //     points.add(LatLng(
    //         globals.inProgressRide['chosenHospital']['geometry']['location']
    //             ['lat'],
    //         globals.inProgressRide['chosenHospital']['geometry']['location']
    //             ['lng']));
    //     markers.add(
    //       Marker(
    //         markerId: MarkerId(1.toString()),
    //         position: LatLng(
    //             globals.inProgressRide['chosenHospital']['geometry']['location']
    //                 ['lat'],
    //             globals.inProgressRide['chosenHospital']['geometry']['location']
    //                 ['lng']),
    //         icon: BitmapDescriptor.defaultMarkerWithHue(
    //           BitmapDescriptor.hueRed,
    //         ),
    //       ),
    //     );
    //     setState(() {
    //       _markers = markers;
    //     });
    //     // }
    //     // i++;
    //     // userLocation.get(
    //     // points.add(LatLng(
    //     //     userLocation.data()['currentLocation']['lat'],
    //     //     userLocation.data()['currentLocation']['lng']));
    //   }
    // }
    // print(points);
    // print('------------------------------------');
    setState(() {
      globals.scrollGesturesEnabled = true;
      globals.zoomGesturesEnabled = true;
      // middleLocation = computeCentroid(points);
      // pointsMarker = points;
      // _markers = markers;
      // currentLocationString = text;
    });
    callMehtod();
    // set up markers at lat lng points
  }

  // @override
  // initState() {
  //   super.initState();
  //   // Location currentLocation = Location();
  //   // currentLocation.getLocation().then((loc) {
  //   //   double? lat = loc.latitude;
  //   //   double? lng = loc.longitude;
  //   //   print('$lat, $lng');
  //   //   setState(() {
  //   //     startLocation = LatLng(lat!, lng!);
  //   //   });
  //   // });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (globals.inProgressRide != null) {
    //   setState(() {
    //     activeIndex = 3;
    //   });
    // }
    updateDetails();
  }

  // void changeActiveIndex(int index) {
  //   setState(() {
  //     activeIndex = index;
  //   });
  // }

  // void chosenAmbulanceType(int i) {
  //   setState(() {
  //     ambulanceType = i;
  //   });
  // }

  // void chosenAddress(int i) {
  //   if (i == selectedIndexAddresses) {
  //     setState(() {
  //       selectedIndexAddresses = -1;
  //     });
  //   } else {
  //     setState(() {
  //       selectedIndexAddresses = i;
  //     });
  //   }
  // }

  // void chosenNearbyHospital(int i, var hospital) {
  //   setState(() {
  //     selectedNearbyHospital = i;
  //     chosenHospital = hospital;
  //   });
  // }

  // bool checkIfAddressIsChosen(int i) {
  //   return selectedIndexAddresses == i;
  // }

  // bool checkIfAmbulanceTypeChosen(int index) {
  //   if (ambulanceType == index) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // bool checkIfNearbyHospitalIsChosen(int i) {
  //   return selectedNearbyHospital == i;
  // }

  // bool checkIfActiveIndex() {
  //   return activeIndex == 2;
  // }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  // void _changeCameraPosition() async {
  //   Location currentLocation = Location();
  //   var location = await currentLocation.getLocation();
  //   double? lat = location.latitude;
  //   double? lng = location.longitude;
  //   mapController.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: LatLng(lat!, lng!),
  //         zoom: 14.0,
  //         bearing: 45.0,
  //         tilt: 45.0,
  //       ),
  //     ),
  //   );
  // }

  // void changeCameraPositionIndex(newPos) {
  //   var addresses = globals.user?.addresses;
  //   if (addresses != null) {
  //     mapController.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //           target: LatLng(
  //               addresses[newPos]['latitude'], addresses[newPos]['longitude']),
  //           zoom: 14.0,
  //           bearing: 45.0,
  //           tilt: 45.0,
  //         ),
  //       ),
  //     );
  //   }
  // }

  // void _onAddMarkerButtonPressed() {
  //   setState(() {
  //     _marker = Marker(
  //       // This marker id can be anything that uniquely identifies each marker.
  //       markerId: MarkerId(_lastMapPosition.toString()),
  //       position: _lastMapPosition,
  //       infoWindow: const InfoWindow(
  //         title: 'Really cool place',
  //         snippet: '5 Star Rating',
  //       ),
  //       icon: BitmapDescriptor.defaultMarker,
  //     );
  //   });
  // }

  // void _onCameraMove(CameraPosition position) {
  //   _lastMapPosition = position.target;
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //     title: Text(
        //       'Pick a Location',
        //       style: TextStyle(
        //         fontFamily: GoogleFonts.poppins().fontFamily,
        //       ),
        //     ),
        //     backgroundColor: kPrimaryColor,
        //     actions: [
        //       // Navigate to the Search Screen
        //       IconButton(
        //           padding: const EdgeInsets.only(right: 20),
        //           onPressed: () {},
        //           icon: const Icon(
        //             Icons.search,
        //             size: 31,
        //           ))
        //     ]),
        body: Stack(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(bottom: getProportionateScreenHeight(230)),
              child: Stack(
                children: [
                  GoogleMap(
                    zoomControlsEnabled: false,
                    tiltGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: globals.scrollGesturesEnabled,
                    zoomGesturesEnabled: globals.zoomGesturesEnabled,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: middleLocation,
                      zoom: 16.0,
                    ),
                    mapType: _currentMapType,
                    markers: _markers,
                    // onCameraMove: _onCameraMove,
                    onCameraMove: (CameraPosition cameraPosition) async {
                      setState(() {
                        // idleLocation = cameraPosition.target;
                      });
                      // List<geocoding.Placemark> placemarks =
                      //     await geocoding.placemarkFromCoordinates(
                      //         idleLocation.latitude, idleLocation.longitude);
                      // geocoding.Placemark placemark = placemarks[0];
                      // String text =
                      //     '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}';
                      // setState(() {
                      //   // globals.scrollGesturesEnabled = true;
                      //   // globals.zoomGesturesEnabled = true;
                      //   currentLocationString = text;
                      // });
                    },
                    onTap: (LatLng location) {
                      // setState(() {
                      //   globals.selectedIndexAddresses = -1;
                      // });
                      // chosenAddress(-1);
                    },
                  ),
                  loading == false
                      ? Positioned(
                          top: 10,
                          left: 10,
                          width: getProportionateScreenWidth(40),
                          height: getProportionateScreenHeight(40),
                          child: FloatingActionButton(
                            heroTag: 'mapType',
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, HomeScreen.routeName);
                            },
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            backgroundColor: Colors.white,
                            child: const Icon(
                              // Entypo.cross,
                              Icons.map,
                              size: 30,
                              color: kErrorColor,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: 'btn1',
                      onPressed: _onMapTypeButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: kPrimaryColor,
                      child: const Icon(Icons.map, size: 31.0),
                    ),
                    const SizedBox(height: 16.0),
                    FloatingActionButton(
                      heroTag: 'btn2',
                      onPressed: _changeCameraPosition,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: kPrimaryColor,
                      child: const Icon(Icons.location_pin, size: 31.0),
                    )
                  ],
                ),
              ),
            ),
            // activeIndex == 0
            //     ? PickupLocationDrawer(
            //         changeCameraPositionIndex: changeCameraPositionIndex,
            //         idleLocation: idleLocation,
            //         currentLocationString: currentLocationString,
            //         changeActiveIndex: changeActiveIndex,
            //         chosenAddress: chosenAddress,
            //         checkIfAddressIsChosen: checkIfAddressIsChosen,
            //       )
            //     : const SizedBox(
            //         width: 0,
            //         height: 0,
            //       ),
            // activeIndex == 1
            //     ? AmbulanceTypeDrawer(
            //         changeActiveIndex: changeActiveIndex,
            //         currentLocationString: currentLocationString,
            //         chosenAmbulanceType: chosenAmbulanceType,
            //         checkIfAmbulanceTypeChosen: checkIfAmbulanceTypeChosen,
            //         ambulances: ambulances,
            //       )
            //     : const SizedBox(
            //         width: 0,
            //         height: 0,
            //       ),
            // activeIndex == 2
            //     ? NearbyHospitalDrawer(
            //         idleLocation: idleLocation,
            //         currentLocationString: currentLocationString,
            //         ambulanceType: ambulanceType,
            //         ambulances: ambulances,
            //         changeActiveIndex: changeActiveIndex,
            //         chosenNearbyHospital: chosenNearbyHospital,
            //         checkIfNearbyHospitalIsChosen:
            //             checkIfNearbyHospitalIsChosen,
            //         checkIfActiveIndex: checkIfActiveIndex,
            //       )
            //     : const SizedBox(
            //         width: 0,
            //         height: 0,
            //       ),
            // activeIndex == 3
            Tracking(
              pointsMarker: pointsMarker,
              name: name,
              contactNumber: contactNumber,
              medicalCard: medicalCard,
              updateDetails: updateDetails,
              patientLocation: patientLocation,
            )
            //     : const SizedBox(
            //         width: 0,
            //         height: 0,
            //       ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.pop(context, idleLocation);
        //   },
        //   child: const Icon(
        //     Icons.check,
        //     size: 31,
        //   ),
        //   backgroundColor: kPrimaryColor,
        // ),
      ),
    );
  }
}
