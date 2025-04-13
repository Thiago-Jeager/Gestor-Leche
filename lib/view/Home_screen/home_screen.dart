import 'package:flutter/material.dart';
import 'package:flutter_milk_app/const/colors.dart';
import 'package:flutter_milk_app/const/images.dart';
import 'package:flutter_milk_app/controller/home_controller.dart';
import 'package:flutter_milk_app/view/Register_screen/register_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_milk_app/view/Report_screen/report_screen.dart';
import 'package:flutter_milk_app/widget/button.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';
import '../../model/user_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final homeController = Get.put(HomeController());
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
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
                top: 320,
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
                      const Text(
                        'Selecciona un usuario:',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Obx(() {
                        if (userController.usuarios.isEmpty) {
                          return const Text('No hay usuarios disponibles.');
                        }
                        return DropdownButton<UserModel>(
                          value: userController.usuarioSeleccionado.value,
                          items: userController.usuarios.map((usuario) {
                            return DropdownMenuItem(
                              value: usuario,
                              child:
                                  Text('${usuario.nombre} ${usuario.apellido}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              userController.seleccionarUsuario(value);
                              homeController.cargarLitrosDelDia(value.id!);
                            }
                          },
                        );
                      }),
                      const SizedBox(height: 10),
                      Obx(() {
                        final usuario =
                            userController.usuarioSeleccionado.value;
                        return Text(
                          usuario != null
                              ? 'Usuario seleccionado: ${usuario.nombre} ${usuario.apellido}'
                              : 'No se ha seleccionado ningún usuario.',
                          style: const TextStyle(fontSize: 14),
                        );
                      }),
                      const SizedBox(height: 20),
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
                        child: GetBuilder<HomeController>(
                          init: homeController, // Inicializa el controlador
                          builder: (controller) {
                            return Text(
                              "Litros de hoy: ${controller.litrosHoy.value}",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 20,
                                color: textwhite,
                              ),
                            );
                          },
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
                              onTap: () {
                                final userId = userController
                                    .usuarioSeleccionado.value?.id;
                                if (userId != null) {
                                  Get.to(() => RegisterScreen(userId: userId))!
                                      .then((_) {
                                    // Recargar los litros después de regresar
                                    homeController.cargarLitrosDelDia(userId);
                                  });
                                }
                              }),
                          Button(
                            label: "Ver Reporte",
                            onTap: () {
                              final userId =
                                  userController.usuarioSeleccionado.value?.id;
                              if (userId != null) {
                                Get.to(() => ReportScreen(userId: userId))!
                                    .then((_) {
                                  // Recargar los litros después de regresar
                                  homeController.cargarLitrosDelDia(userId);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
