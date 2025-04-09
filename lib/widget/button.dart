import 'package:flutter/material.dart';
import 'package:flutter_milk_app/const/colors.dart';

class Button extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const Button({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 150,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: hunterGreen, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'lato',
              fontSize: 16,
              color: textblack,
            ),
          ),
        ),
      ),
    );
  }
}
