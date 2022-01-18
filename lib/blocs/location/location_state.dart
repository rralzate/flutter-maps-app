part of 'location_bloc.dart';

class LocationState extends Equatable {
  final bool followingUser;
  final LatLng? lastKnowLocation;
  final List<LatLng> myLocationHIstory;
  // Ultima geolocalizacion
  //historia

  const LocationState(
      {this.followingUser = false, this.lastKnowLocation, myLocationHIstory})
      : myLocationHIstory = myLocationHIstory ?? const [];

  LocationState copyWith({
    bool? followingUser,
    LatLng? lastKnowLocation,
    List<LatLng>? myLocationHIstory,
  }) =>
      LocationState(
        followingUser: followingUser ?? this.followingUser,
        lastKnowLocation: lastKnowLocation ?? this.lastKnowLocation,
        myLocationHIstory: myLocationHIstory ?? this.myLocationHIstory,
      );

  @override
  List<Object?> get props =>
      [followingUser, lastKnowLocation, myLocationHIstory];
}
