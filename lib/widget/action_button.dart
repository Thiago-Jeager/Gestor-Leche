import 'package:flutter/material.dart';
import 'package:flutter_milk_app/const/colors.dart';

class ActionButton extends StatelessWidget {
  final Icon icon;
  final Function()? onTap;
  const ActionButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: icon,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(hunterGreen),
        foregroundColor: WidgetStateProperty.all(backgroundWhite),
      ),
    );
  }
}
