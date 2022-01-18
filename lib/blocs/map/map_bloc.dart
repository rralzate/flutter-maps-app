import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/helpers/helpers.dart';
import 'package:maps_app/models/models.dart';
import 'package:maps_app/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  LatLng? mapCenter;

  GoogleMapController? _mapController;
  StreamSubscription<LocationState>? streamSubscriptionLocationState;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);

    on<OnStartFollowingUserEvent>(_onStartFollowingUser);

    on<OnStopFollowingUserEvent>(
        (event, emit) => emit(state.copyWith(isfollowingUser: false)));

    on<UpdateUserPolylineEvent>(_onPolylineNewPoint);
    on<OnToggleUserEvent>(
        (event, emit) => emit(state.copyWith(showMyRoute: !state.showMyRoute)));

    on<DisplayPolylineEvent>((event, emit) => emit(
        state.copyWith(polylines: event.polylines, markers: event.markers)));

    streamSubscriptionLocationState =
        locationBloc.stream.listen((locationState) {
      if (locationState.lastKnowLocation != null) {
        add(UpdateUserPolylineEvent(locationState.myLocationHIstory));
      }

      if (!state.isfollowingUser) return;

      if (locationState.lastKnowLocation == null) return;

      moveCamera(locationState.lastKnowLocation!);
    });
  }

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(uberMapTheme));

    emit(state.copyWith(isMapInitialized: true));
  }

  void _onStartFollowingUser(
      OnStartFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isfollowingUser: true));

    if (locationBloc.state.lastKnowLocation == null) return;

    moveCamera(locationBloc.state.lastKnowLocation!);
  }

  void _onPolylineNewPoint(
      UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
        polylineId: const PolylineId('myRoute'),
        color: Colors.black,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: event.userHistoryLocations);

    final currentPolylines = Map<String, Polyline>.from(state.polylines);

    currentPolylines['myRoute'] = myRoute;

    emit(state.copyWith(polylines: currentPolylines));
  }

  Future drawRoutePolyline(RouteDestination destination) async {
    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.black,
      width: 5,
      points: destination.points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms /= 100;

    int tripDuration = (destination.duration / 60).floorToDouble().toInt();

    // final starMarker = await getAssetImageMarker();
    // final endMarker = await getNetworkImageMarker();

    final starMarker = await getStartCustomMarker(tripDuration, 'Mi ubicacion');
    final endMarker =
        await getEndCustomMarker(kms.toInt(), destination.endPlaces.text);

    final startMarker = Marker(
        anchor: const Offset(0.1, 1),
        markerId: const MarkerId('start'),
        icon: starMarker,
        position: destination.points.first
        // infoWindow: InfoWindow(
        //     title: 'inicio', snippet: 'Kms: $kms, Duracion: $tripDuration ')

        );

    final lastMarker = Marker(
      markerId: const MarkerId('end'),
      position: destination.points.last,
      icon: endMarker,
      // infoWindow: InfoWindow(
      //     title: destination.endPlaces.text,
      //     snippet: destination.endPlaces.placeName)
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['route'] = myRoute;

    final currentMarkers = Map<String, Marker>.from(state.markers);

    currentMarkers['start'] = startMarker;

    currentMarkers['end'] = lastMarker;

    add(DisplayPolylineEvent(currentPolylines, currentMarkers));

    await Future.delayed(const Duration(milliseconds: 300));
    //_mapController?.showMarkerInfoWindow(const MarkerId('start'));
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  @override
  Future<void> close() {
    streamSubscriptionLocationState?.cancel();
    return super.close();
  }
}
