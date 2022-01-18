import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/blocs/blocs.dart';

class BtnFollowUser extends StatelessWidget {
  const BtnFollowUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Container(
        margin: const EdgeInsets.only(left: 40.0),
        child: CircleAvatar(
          maxRadius: 25,
          backgroundColor: Colors.white,
          child: BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.isfollowingUser
                      ? Icons.directions_run_rounded
                      : Icons.hail_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  mapBloc.add(OnStartFollowingUserEvent());
                },
              );
            },
          ),
        ));
  }
}
