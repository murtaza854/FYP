import 'dart:collection';

import 'models/user_model.dart';

UserModel? user;
bool loading = true;
bool selectedAddressLoading = false;
bool zoomGesturesEnabled = true;
bool scrollGesturesEnabled = true;
var requests = [];
var acceptedRequests = [];
var rides = [];
// ignore: prefer_typing_uninitialized_variables
var inProgressRide;
Map<String, dynamic> sentRequests = HashMap();
