import 'package:flutter/material.dart';
import 'package:flutter_milk_app/const/colors.dart';
import 'package:flutter_milk_app/const/images.dart';
import 'package:flutter_milk_app/view/Register_screen/register_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_milk_app/view/Report_screen/report_screen.dart';
import 'package:flutter_milk_app/widget/button.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: homeBackground,
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Image.asset(
                  gift,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 400, // Ajusta la altura según sea necesario
                ),
                const SizedBox(
                    height: 100), // Espacio para el contenido restante
              ],
            ),
            Positioned(
              top: 350,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: backgroundWhite,
                  borderRadius:
                      BorderRadius.circular(15), // Esquinas redondeadas
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(DateFormat.yMMMMd('es_ES').format(DateTime.now()),
                        style: const TextStyle(
                          fontSize: 20,
                          color: textblack,
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: textblack,
                        borderRadius: BorderRadius.circular(15),
                        // Esquinas redondeadas
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      height: 100,
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Litros de hoy",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          color: textwhite,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Button(
                            label: "Registrar",
                            onTap: () => Get.to(() => const RegisterScreen())),
                        Button(
                            label: "Ver Reporte",
                            onTap: () => Get.to(() => ReportScreen())),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
