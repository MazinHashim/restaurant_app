import 'package:flutter/material.dart';
import 'package:resturant_app/models/closing_days.dart';

class ClosingDaysSelector extends StatelessWidget {
  const ClosingDaysSelector(
      {Key? key, required this.values, required this.onChange})
      : super(key: key);

  final Map<ClDays, bool> values;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: values.keys
          .map((ClDays key) => CheckboxListTile(
              value: values[key],
              title: Text(key.name),
              onChanged: (value) => onChange(value, key)))
          .toList(),
    );
  }
}
