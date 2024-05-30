// ToggleButton.dart
import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  final void Function(int) onToggle;
  final int selectedIndex;

  ToggleButton({required this.onToggle, required this.selectedIndex});

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(30.0),
        selectedColor: Colors.white,
        fillColor: Colors.red[300],
        color: Colors.black,
        constraints: BoxConstraints(minHeight: 50.0, minWidth: 150.0),
        isSelected: [widget.selectedIndex == 0, widget.selectedIndex == 1],
        onPressed: (index) {
          widget.onToggle(index);
        },
        children: [
          Text('Delivery', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('Carrier', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
