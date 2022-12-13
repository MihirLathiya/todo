import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// created controller for displaying Google Maps
  Completer<GoogleMapController> _controller = Completer();

// given camera position
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(19.0759837, 72.8776559),
    zoom: 15,
  );

  List<String> images = [
    'assets/hulk.jpeg',
    'assets/thor.jpeg',
    'assets/ironman.jpeg',
  ];

// created empty list of markers
  final List<Marker> _markers = <Marker>[];

  List<LatLng> _latLen1 = <LatLng>[];
// declared method to get Images
  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  late PermissionStatus _permissionGranted;
  late bool serviceEnabled;
  Future<void> getUserLocation() async {
    Location location = Location();

    // Check if location service is enable
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        _permissionGranted = await location.requestPermission();
      }
    }
  }

  @override
  void initState() {
    getUserLocation();
    // TODO: implement initState
    super.initState();
    // initialize loadData method
    loadData();
  }

  loadData() async {
    for (int i = 0; i < images.length; i++) {
      final Uint8List markIcons = await getImages(images[i], 50);
      // makers added according to index
      _markers.add(Marker(
        // given marker id
        markerId: MarkerId(i.toString()),
        // given marker icon
        icon: BitmapDescriptor.fromBytes(markIcons, size: Size(50, 50)),
        // given position
        position: _latLen1[i],
        infoWindow: InfoWindow(
          // given title for marker
          title: 'Location: ' + i.toString(),
        ),
      ));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('location').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                if (snapshot.data!.docs[i]['status'] == 'on') {
                  _latLen1.insert(
                    i,
                    LatLng(double.parse(snapshot.data!.docs[i]['lat']),
                        double.parse(snapshot.data!.docs[i]['long'])),
                  );
                }
              }
              log('Hello User Location :- ${_latLen1}');
              return GoogleMap(
                // given camera position
                initialCameraPosition: _kGoogle,
                // set markers on google map
                markers: Set<Marker>.of(_markers),
                // on below line we have given map type
                mapType: MapType.normal,
                // on below line we have enabled location
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                // on below line we have enabled compass
                compassEnabled: true,
                // below line displays google map in our app
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
