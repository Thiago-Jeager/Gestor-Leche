import 'package:flutter/material.dart';
import 'package:flutter_milk_app/const/colors.dart';

class ReportButton extends StatefulWidget {
  final String label;
  final Function()? onTap;
  const ReportButton({super.key, required this.label, this.onTap});

  @override
  State<ReportButton> createState() => _ReportButtonState();
}

class _ReportButtonState extends State<ReportButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: hunterGreen,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        widget.label,
        style: const TextStyle(color: backgroundWhite),
      ),
    );
  }
}
