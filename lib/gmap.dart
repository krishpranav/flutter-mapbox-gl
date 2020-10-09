//location picker
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class Gmap extends StatefulWidget {
  Gmap({Key key}) : super(key: key);

  @override
  _GmapState createState() => _GmapState();
}

class _GmapState extends State<Gmap> {
  MapboxMapController mapController;

  LatLng center = LatLng(37.810575, -122.477174);
  String selectedStyle = MapboxStyles.MAPBOX_STREETS;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    // _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl("networkImage", "https://via.placeholder.com/50");
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  Future<void> addImageFromUrl(String name, String url) async {
    var response = await http.get(url);
    return mapController.addImage(name, response.bodyBytes);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.yellow, title: Text('Google Maps Tutorial')),
      body: crearMapa(),
      //floatingActionButton: botonesFlotantes(),
    );
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
            child: Icon(Icons.sentiment_very_dissatisfied),
            onPressed: () {
              mapController.addSymbol(SymbolOptions(
                  geometry: center,
                  iconImage: 'networkImage',
                  textField: 'Montaña creada aquí',
                  textOffset: Offset(0, 2)));
            }),
        SizedBox(height: 5),
        FloatingActionButton(
            child: Icon(Icons.zoom_in),
            onPressed: () {
              mapController.animateCamera(CameraUpdate.zoomIn());
            }),
        SizedBox(height: 5),
        FloatingActionButton(
            child: Icon(Icons.zoom_out),
            onPressed: () {
              mapController.animateCamera(CameraUpdate.zoomOut());
            }),
        SizedBox(height: 5),
        FloatingActionButton(
            child: Icon(Icons.add_to_home_screen),
            onPressed: () {
              _onStyleLoaded();
              setState(() {});
            })
      ],
    );
  }

  Widget crearMapa() {
    return MapboxMap(
      accessToken: , //put your access tokon here
      styleString: selectedStyle,
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      trackCameraPosition: true,
      myLocationTrackingMode: MyLocationTrackingMode.Tracking,
      initialCameraPosition: CameraPosition(
        target: LatLng(-33.852, 151.211),
      ),
    );
  }
}
