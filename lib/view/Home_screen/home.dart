import 'package:flutter/material.dart';
import 'package:flutter_milk_app/const/colors.dart';
import 'package:flutter_milk_app/const/images.dart';
import 'package:flutter_milk_app/view/Home_screen/home_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_milk_app/controller/home_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var homeC = Get.put(HomeController());

    var navBarItem = [
      BottomNavigationBarItem(
          icon: Image.asset(icLogo, width: 26), label: "Inicio"),
      BottomNavigationBarItem(
          icon: Image.asset(icLogo, width: 26), label: "Info"),
    ];

    var navBody = [
      const HomeScreen(),
      const Text('home'),
    ];
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Obx(() => navBody.elementAt(homeC.currentNavIndex.value))),
        ],
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, -2), // Shadow only on top
                blurRadius: 4,
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: homeC.currentNavIndex.value,
            selectedItemColor: textblack,
            selectedLabelStyle: const TextStyle(color: textblack),
            type: BottomNavigationBarType.fixed,
            backgroundColor: backgroundWhite,
            items: navBarItem,
            onTap: (value) {
              homeC.currentNavIndex.value = value;
            },
          ),
        ),
      ),
    );
  }
}
