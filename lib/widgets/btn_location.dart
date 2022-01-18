import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/ui/ui.dart';

class BtnCurrentLocation extends StatelessWidget {
  const BtnCurrentLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Container(
        margin: const EdgeInsets.only(left: 40.0),
        child: CircleAvatar(
          maxRadius: 25,
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(
              Icons.my_location_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              final userLocation = locationBloc.state.lastKnowLocation;

              if (userLocation == null) {
                final snackBar = CustomSnackBar(message: 'No hay ubicacion');
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              }

              mapBloc.moveCamera(userLocation);
            },
          ),
        ));
  }
}
