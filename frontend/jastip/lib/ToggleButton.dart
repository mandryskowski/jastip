// ToggleButton.dart
import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  final void Function(int) onToggle;
  final int selectedIndex;
  final List<String> titles;

  ToggleButton({
    required this.onToggle,
    required this.selectedIndex,
    required this.titles,
  });

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
        constraints: BoxConstraints(minHeight: 50.0, minWidth: 100.0),
        isSelected: List.generate(widget.titles.length, (index) => widget.selectedIndex == index),
        onPressed: (index) {
          widget.onToggle(index);
        },
        children: widget.titles.map((title) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }
}
