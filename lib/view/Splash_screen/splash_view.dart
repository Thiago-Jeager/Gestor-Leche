import 'package:flutter/material.dart';
import 'package:flutter_milk_app/const/colors.dart';
import 'package:flutter_milk_app/const/images.dart';
import 'package:flutter_milk_app/view/Home_screen/home.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  // Creando método para cambiar de vista
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.to(() => const Home());
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ashGray2,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Milky App"),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: Image.asset(icLogo),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Version 1.0.0",
                style: TextStyle(
                  fontSize: 20,
                  color: textblack,
                )),
            const SizedBox(
              height: 20,
            ),
            const Text("Desarrollado por: Yo"),
          ],
        ),
      ),
    );
  }
}
