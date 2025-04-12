import 'package:flutter/material.dart';
import 'package:flutter_milk_app/const/strings.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_milk_app/view/Splash_screen/splash_view.dart';

void main() async {
  await initializeDateFormatting('es_ES', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: appname,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
          useMaterial3: true,
        ),
        home: const SplashView());
  }
}
