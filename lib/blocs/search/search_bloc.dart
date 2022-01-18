import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/models/models.dart';
import 'package:maps_app/services/services.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  TrafficService trafficService;

  SearchBloc({required this.trafficService}) : super(const SearchState()) {
    on<OnActivatreManualMarketEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarket: true)));

    on<OnDeactivateManualMarketEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarket: false)));

    on<OnNewPlacesFoundEvent>(
        (event, emit) => emit(state.copyWith(places: event.places)));

    on<AddToHistoryEvent>((event, emit) => emit(
        state.copyWith(historyPlaces: [event.place, ...state.historyPlaces])));
  }

  Future<RouteDestination> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final trafficResponse = await trafficService.getCoorsStartToEnd(start, end);

    final endPlace = await trafficService.getInformationByCoors(end);

    final distance = trafficResponse.routes[0].distance;
    final duration = trafficResponse.routes[0].duration;

    final geometry = trafficResponse.routes[0].geometry;

    //Decodificar
    final points = decodePolyline(geometry, accuracyExponent: 6);

    final latLngList = points
        .map((coor) => LatLng(coor[0].toDouble(), coor[1].toDouble()))
        .toList();

    return RouteDestination(
        points: latLngList,
        duration: duration,
        distance: distance,
        endPlaces: endPlace);
  }

  Future getPlacesByQuery(LatLng proximity, String query) async {
    final newPlaces = await trafficService.getResultByQuery(proximity, query);

    add(OnNewPlacesFoundEvent(newPlaces));
  }
}
