import 'package:covid19/data/source/data_source_repository.dart';
import 'package:covid19/screens/base/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

import 'map_bloc.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends BaseState<MapScreen, MapBloc> {
  MapController _mapController;
  List<CircleMarker> _dangerZonesCircles;
  LatLng _myLocation = null;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void setupBloc() async {
    bloc = MapBloc(DataSourceRepository());
    bloc.zoneListObservable.listen((dangerZones) {
      setState(() {
        isLoading = false;
        _dangerZonesCircles = dangerZones
            .map(
              (zone) => CircleMarker(
                  point: LatLng(zone.latitude, zone.longitude),
                  color: Colors.amber.withAlpha(70),
                  borderStrokeWidth: 0,
                  useRadiusInMeter: true,
                  radius: 100),
            )
            .toList();
      });
    });

    bloc.listZones();
    _showCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Zonas Infectadas",
            textAlign: TextAlign.center,
            style:
                Theme.of(context).textTheme.title.copyWith(color: Colors.white),
          )),
      body: SafeArea(
        child: Stack(
          children: [
            _buildMap(context),
            _buildFloatingSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: LatLng(-12.046374, -77.042793),
        zoom: 15.0,
        maxZoom: 17,
        minZoom: 13,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
          additionalOptions: {
            'id': 'mapbox/light-v10',
            'accessToken':
                'pk.eyJ1IjoiYXNjdDk0IiwiYSI6ImNrOGt3d295eTAyNDYzc3Bzd2V0NDNnNDUifQ.GPmU-9qfK9xx0VtfPDTvHA',
          },
        ),
        CircleLayerOptions(circles: _dangerZonesCircles ?? []),
        MarkerLayerOptions(markers: _buildMyLocationMarker(context))
      ],
    );
  }

  List<Marker> _buildMyLocationMarker(BuildContext context) {
    if (_myLocation == null) return [];
    return [
      Marker(
        width: 40.0,
        height: 40.0,
        point: _myLocation,
        anchorPos: AnchorPos.align(AnchorAlign.top),
        builder: (ctx) => Container(
          child: Image.asset(
            'assets/ic_marker.png',
            color: Theme.of(context).primaryColor,
          ),
        ),
        // anchorPos: anchorPos,
      )
    ];
  }

  Widget _buildFloatingSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "btn1",
            child: Icon(
              Icons.my_location,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              _showCurrentLocation();
            },
          ),
        ],
      ),
    );
  }

  void _showCurrentLocation() async {
    var result = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);
    var status = result[PermissionGroup.location];
    if (status == PermissionStatus.granted) {
      var position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _myLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_myLocation, 17);
      print("ASCT: " + position.toString());
    } else if (status == PermissionStatus.denied) {
      PermissionHandler().openAppSettings();
    }
  }
}
