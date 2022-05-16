import 'package:app/constants.dart';
import 'package:app/screens/formPage/components/address_drawer.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import '../../../globals.dart' as globals;
// import 'ambulance_type_drawer.dart';
// import 'nearby_hospital_drawer.dart';
// import 'pickup_location_drawer.dart';
// import 'tezz_drawer.dart';

class AddressAdd extends StatefulWidget {
  const AddressAdd({Key? key}) : super(key: key);

  @override
  State<AddressAdd> createState() => _AddressAddState();
}

class _AddressAddState extends State<AddressAdd> {
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

  setLocation() async {
    Location currentLocation = Location();
    var location = await currentLocation.getLocation();
    double? lat = location.latitude;
    double? lng = location.longitude;
    setState(() {
      idleLocation = LatLng(lat!, lng!);
    });
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              'Pick a Location',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
            backgroundColor: kPrimaryColor,
        ),
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
                    onCameraMove: (CameraPosition cameraPosition) async {
                      setState(() {
                        idleLocation = cameraPosition.target;
                      });
                    },
                    onTap: (LatLng location) {
                    },
                  ),
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
            AddressAddDrawer(
              idleLocation: idleLocation,
              currentLocationString: currentLocationString,
              changeCameraPositionIndex: changeCameraPositionIndex,
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
