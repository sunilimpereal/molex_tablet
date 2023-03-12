import 'dart:async';

import 'package:flutter/material.dart';
import 'package:molex_tab/screens/auto%20cut%20crimp/data/autocut_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model_api/schedular_model.dart';
import '../../../utils/bloc.dart';

class AutoCutBloc extends Bloc {
  BuildContext context;
  final AutoCutRepository _autoCutRepository = AutoCutRepository();
  AutoCutBloc(this.context) {}

  final _scheduleListController = BehaviorSubject<List<Schedule>>();
  Stream<List<Schedule>> get bundleStream => _scheduleListController.stream.asBroadcastStream();

  Future<bool> getSchedule({required String machineId, required String type, required String sameMachine}) async {
    final result = await _autoCutRepository.getSchedularData(machId: machineId, type: type, sameMachine: sameMachine);
    result != null ? _scheduleListController.sink.add(result) : null;
    return true;
  }

  @override
  void dispose() {
    _scheduleListController.close();
  }
}

class AutoCutProvider extends InheritedWidget {
  late AutoCutBloc bloc;
  BuildContext context;
  AutoCutProvider({Key? key, required Widget child, required this.context}) : super(key: key, child: child) {
    bloc = AutoCutBloc(context);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static AutoCutBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<AutoCutProvider>() as AutoCutProvider).bloc;
  }
}
