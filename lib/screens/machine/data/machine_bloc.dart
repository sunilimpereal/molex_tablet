import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:molex_tab/model_api/machinedetails_model.dart';
import 'package:molex_tab/screens/machine/data/machine_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../../utils/bloc.dart';

class MachineBloc extends Bloc {
  BuildContext context;
  final MachineRepository _machineRepository = MachineRepository();
  MachineBloc(this.context) {
    getMachineDetails(machineID: "Emu-m/c-004v");
  }
  late MachineDetails machineDetails;
  final _machineController = BehaviorSubject<MachineDetails>();
  Stream<MachineDetails> get machineStream => _machineController.stream.asBroadcastStream();

  Future<MachineDetails> getMachineDetails({required String machineID}) async {
    final result = await _machineRepository.getmachineDetail(machineId: machineID);
    machineDetails = result![0];
    result != null ? _machineController.sink.add(result[0]) : null;
    return result[0];
  }

  @override
  void dispose() {
    _machineController.close();
  }
}

class MachineProvider extends InheritedWidget {
  late MachineBloc bloc;
  BuildContext context;
  MachineProvider({Key? key, required Widget child, required this.context}) : super(key: key, child: child) {
    bloc = MachineBloc(context);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static MachineBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<MachineProvider>() as MachineProvider).bloc;
  }
}
