part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool displayManualMarket;
  final List<Feature> places;
  final List<Feature> historyPlaces;

  const SearchState(
      {this.displayManualMarket = false,
      this.places = const [],
      this.historyPlaces = const []});

  SearchState copyWith(
          {bool? displayManualMarket,
          List<Feature>? places,
          List<Feature>? historyPlaces}) =>
      SearchState(
        displayManualMarket: displayManualMarket ?? this.displayManualMarket,
        places: places ?? this.places,
        historyPlaces: historyPlaces ?? this.historyPlaces,
      );

  @override
  List<Object> get props => [displayManualMarket, places, historyPlaces];
}
