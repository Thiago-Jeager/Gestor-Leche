import 'package:flutter/material.dart';
import 'package:flutter_milk_app/const/colors.dart';
import 'package:flutter_milk_app/const/images.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('Información de la App'),
          backgroundColor: cambridgeBlue,
        ),
        body: Container(
          color: backgroundWhite,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // App Logo
              const Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      AssetImage(icLogo), // Replace with your logo path
                ),
              ),
              const SizedBox(height: 20),
              // App Name
              const Text(
                'Flutter Milk App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textblack,
                ),
              ),
              const SizedBox(height: 10),
              // App Version
              Text(
                'Versión: 1.0.0',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),
              // Developer Name
              const Text(
                'Desarrollado por: Santiago',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              // Description
              Text(
                'Flutter Milk App es una aplicación diseñada para gestionar y '
                'monitorear la producción de leche de manera eficiente y sencilla. '
                'Con una interfaz amigable y herramientas útiles',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
              const Spacer(),
              // Footer
              Text(
                '© 2025 Flutter Milk App',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
