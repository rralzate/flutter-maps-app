import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/blocs/blocs.dart';

class GpsAccessPage extends StatelessWidget {
  const GpsAccessPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: BlocBuilder<GpsBloc, GpsState>(builder: (context, state) {
        return !state.isGpsEnabled
            ? const _EnableGpsMessage()
            : const _AccessBotton();
      })),
    );
  }
}

class _AccessBotton extends StatelessWidget {
  const _AccessBotton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Es necesario el acceso al GPS'),
        MaterialButton(
            child: const Text(
              'Solicitar acesso',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.black,
            splashColor: Colors.transparent,
            shape: const StadiumBorder(),
            elevation: 0,
            onPressed: () {
              final gpsBloc = BlocProvider.of<GpsBloc>(context);
              gpsBloc.askGpsAccess();
            })
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Debe Habilitar el GPS',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
    );
  }
}
