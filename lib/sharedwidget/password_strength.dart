import 'package:flutter/material.dart';

class ReusablePasswordStrength extends StatelessWidget {
  final String password;

  const ReusablePasswordStrength({Key? key, required this.password}) : super(key: key);

  double _calculateStrength() {
    double strength = 0;
    if (password.length >= 6) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) strength += 0.25;
    return strength;
  }

  @override
  Widget build(BuildContext context) {
    double strength = _calculateStrength();
    Color color = Colors.red;
    String label = "Weak";

    if (strength >= 0.75) {
      color = Colors.green;
      label = "Strong";
    } else if (strength >= 0.5) {
      color = Colors.orange;
      label = "Medium";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(value: strength, color: color, minHeight: 6),
        SizedBox(height: 6),
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
