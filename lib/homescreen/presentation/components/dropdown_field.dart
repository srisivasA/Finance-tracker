import 'package:flutter/material.dart';

class DropdownField extends StatelessWidget {
  final String value;
  final String label;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownField({
    Key? key,
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
