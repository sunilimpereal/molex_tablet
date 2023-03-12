import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:molex_tab/authentication/data/auth_bloc.dart';
import 'screens/utils/Colors.dart';
import 'screens/utils/Fonts.dart';
import 'screens/utils/SharePref.dart';
import 'authentication/changeIp.dart';

SharedPref sharedPref = new SharedPref();
Fonts fonts = new Fonts();
AppColors colors = new AppColors();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPref.init();
  runApp(AppProvider());
}

class AppProvider extends StatefulWidget {
  const AppProvider({super.key});

  @override
  State<AppProvider> createState() => _AppProviderState();
}

class _AppProviderState extends State<AppProvider> {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      context: context,
      child: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  final String? logged;
  MyApp({this.logged});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    sharedPref.setStartandEndDate(
        startDate: DateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 5))),
        endDate: DateUtils.dateOnly(DateTime.now().add(const Duration(days: 5))));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Molex',
        theme: ThemeData(
          // fontFamily: 'OpenSans',
          primarySwatch: Colors.blue,
        ),
        home: ChangeIp());
  }
}
