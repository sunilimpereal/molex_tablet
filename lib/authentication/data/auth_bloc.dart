import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:molex_tab/authentication/data/auth_repository.dart';
import 'package:molex_tab/authentication/data/models/login_model.dart';
import 'package:molex_tab/screens/auto%20cut%20crimp/data/autocut_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model_api/schedular_model.dart';
import '../../../utils/bloc.dart';

class AuthBloc extends Bloc {
  BuildContext context;
  final AuthRepository _authRepository = AuthRepository();
  AuthBloc(this.context) {
    getEmployee(empId: "123456");
  }
  late Employee employee;
  final _employeeController = BehaviorSubject<Employee>();
  Stream<Employee> get employeeStream => _employeeController.stream.asBroadcastStream();

  Future<Employee> getEmployee({required String empId}) async {
    final result = await _authRepository.empIdlogin(empId);
    employee = result!;
    log(employee.employeeName.toString());
    result != null ? _employeeController.sink.add(result) : null;
    return employee;
  }

  @override
  void dispose() {
    _employeeController.close();
  }
}

class AuthProvider extends InheritedWidget {
  late AuthBloc bloc;
  BuildContext context;
  AuthProvider({Key? key, required Widget child, required this.context}) : super(key: key, child: child) {
    bloc = AuthBloc(context);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static AuthBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<AuthProvider>() as AuthProvider).bloc;
  }
}
