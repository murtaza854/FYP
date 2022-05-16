import 'package:app/constants.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import '../../../globals.dart' as globals;
import 'ambulance_type_drawer.dart';
import 'nearby_hospital_drawer.dart';
import 'pickup_location_drawer.dart';
import 'tezz_drawer.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late GoogleMapController mapController;
  CameraPosition? cameraPosition;
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};
  LatLng startLocation = const LatLng(24.9049269, 67.1380395);
  LatLng idleLocation = const LatLng(24.9049269, 67.1380395);
  String currentLocationString = "Loading...";
  List<LatLng> polylineCoordinates = [];
  int activeIndex = 0;
  int ambulanceType = 0;
  int selectedIndexAddresses = -1;
  int selectedNearbyHospital = 0;
  // ignore: prefer_typing_uninitialized_variables
  var chosenHospital;
  bool loading = false;
  bool flag = false;
  bool flagZoom = false;

  updateLoading(loading) {
    setState(() {
      this.loading = loading;
    });
  }

  // late final LatLng _lastMapPosition;

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(
            idleLocation.latitude, idleLocation.longitude);
    geocoding.Placemark placemark = placemarks[0];
    String text =
        '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}';
    setState(() {
      globals.scrollGesturesEnabled = true;
      globals.zoomGesturesEnabled = true;
      currentLocationString = text;
    });
    setLocation();
    _changeCameraPosition();
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
    if (globals.inProgressRide != null) {
      setState(() {
        activeIndex = 3;
      });
    }
  }

  setLocation() async {
    Location currentLocation = Location();
    var location = await currentLocation.getLocation();
    double? lat = location.latitude;
    double? lng = location.longitude;
    setState(() {
      idleLocation = LatLng(lat!, lng!);
    });
  }

  void changeActiveIndex(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  void chosenAmbulanceType(int i) {
    setState(() {
      ambulanceType = i;
    });
  }

  void chosenAddress(int i) {
    if (i == selectedIndexAddresses) {
      setState(() {
        selectedIndexAddresses = -1;
      });
    } else {
      setState(() {
        selectedIndexAddresses = i;
      });
    }
  }

  void chosenNearbyHospital(int i, var hospital) {
    setState(() {
      selectedNearbyHospital = i;
      chosenHospital = hospital;
    });
  }

  bool checkIfAddressIsChosen(int i) {
    return selectedIndexAddresses == i;
  }

  bool checkIfAmbulanceTypeChosen(int index) {
    if (ambulanceType == index) {
      return true;
    } else {
      return false;
    }
  }

  bool checkIfNearbyHospitalIsChosen(int i) {
    return selectedNearbyHospital == i;
  }

  bool checkIfActiveIndex() {
    return activeIndex == 2;
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _changeCameraPosition() async {
    Location currentLocation = Location();
    var location = await currentLocation.getLocation();
    double? lat = location.latitude;
    double? lng = location.longitude;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat!, lng!),
          zoom: flagZoom ? 19.0 : 14.0,
          bearing: 45.0,
          tilt: 45.0,
        ),
      ),
    );
    if (!flagZoom) {
      setState(() {
        flagZoom = true;
      });
    }
  }

  void changeCameraPositionIndex(newPos) {
    var addresses = globals.user?.addresses;
    if (addresses != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
                addresses[newPos]['latitude'], addresses[newPos]['longitude']),
            zoom: 14.0,
            bearing: 45.0,
            tilt: 45.0,
          ),
        ),
      );
    }
  }

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
    var ambulances = [
      {
        'name': 'Ambulance',
      },
      {
        'name': 'Ambulance + Paramedic',
      },
      {
        'name': 'Ambulance + 2 Paramedics',
      },
    ];
    // final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    // var hospital = arguments["hospital"];
    // var currentLocation = arguments["currentLocation"];
    // if (hospital != null && currentLocation != null) {
    //   setState(() {
    //     startLocation =
    //         LatLng(currentLocation['latitude'], currentLocation['longitude']);
    //     idleLocation = LatLng(hospital['latitude'], hospital['longitude']);
    //     polylineCoordinates = [
    //       LatLng(currentLocation['latitude'], currentLocation['longitude']),
    //       LatLng(hospital['latitude'], hospital['longitude'])
    //     ];
    //     loading = true;
    //   });
    // }
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
                      target: startLocation,
                      zoom: 16.0,
                    ),
                    mapType: _currentMapType,
                    markers: _markers,
                    // onCameraMove: _onCameraMove,
                    onCameraMove: (CameraPosition cameraPosition) async {
                      setState(() {
                        idleLocation = cameraPosition.target;
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
                      chosenAddress(-1);
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
                              if (globals.inProgressRide != null) {
                                Navigator.pushNamed(
                                    context, HomeScreen.routeName);
                              } else {
                                if (activeIndex - 1 == 2) {
                                  setState(() {
                                    activeIndex = 2;
                                  });
                                } else if (activeIndex - 1 == 1) {
                                  setState(() {
                                    activeIndex = 1;
                                  });
                                } else if (activeIndex - 1 == 0) {
                                  setState(() {
                                    activeIndex = 0;
                                    globals.scrollGesturesEnabled = true;
                                    globals.zoomGesturesEnabled = true;
                                  });
                                } else if (activeIndex - 1 == -1) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            backgroundColor: Colors.white,
                            child: Icon(
                              activeIndex == 0 ? Icons.map : Icons.arrow_back,
                              // ? Entypo.cross
                              // : MaterialIcons.keyboard_arrow_left,
                              size: 30,
                              color: kErrorColor,
                            ),
                          ),
                        )
                      : Container(),
                  const Center(
                    child: Icon(
                      Icons.location_on,
                      size: 40,
                      color: kPrimaryColor,
                    ),
                  ),
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
                    activeIndex == 0
                        ? FloatingActionButton(
                            heroTag: 'btn2',
                            onPressed: _changeCameraPosition,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            backgroundColor: kPrimaryColor,
                            child: const Icon(Icons.location_pin, size: 31.0),
                          )
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          ),
                  ],
                ),
              ),
            ),
            activeIndex == 0
                ? PickupLocationDrawer(
                    changeCameraPositionIndex: changeCameraPositionIndex,
                    idleLocation: idleLocation,
                    currentLocationString: currentLocationString,
                    changeActiveIndex: changeActiveIndex,
                    chosenAddress: chosenAddress,
                    checkIfAddressIsChosen: checkIfAddressIsChosen,
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
            activeIndex == 1
                ? AmbulanceTypeDrawer(
                    changeActiveIndex: changeActiveIndex,
                    currentLocationString: currentLocationString,
                    chosenAmbulanceType: chosenAmbulanceType,
                    checkIfAmbulanceTypeChosen: checkIfAmbulanceTypeChosen,
                    ambulances: ambulances,
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
            activeIndex == 2
                ? NearbyHospitalDrawer(
                    idleLocation: idleLocation,
                    currentLocationString: currentLocationString,
                    ambulanceType: ambulanceType,
                    ambulances: ambulances,
                    changeActiveIndex: changeActiveIndex,
                    chosenNearbyHospital: chosenNearbyHospital,
                    checkIfNearbyHospitalIsChosen:
                        checkIfNearbyHospitalIsChosen,
                    checkIfActiveIndex: checkIfActiveIndex,
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
            activeIndex == 3
                ? TezzDrawer(
                    idleLocation: idleLocation,
                    changeActiveIndex: changeActiveIndex,
                    currentLocationString: currentLocationString,
                    ambulanceType: ambulanceType,
                    ambulances: ambulances,
                    chosenHospital: chosenHospital,
                    loading: loading,
                    updateLoading: updateLoading,
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
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
