import 'package:flutter/material.dart';
import 'package:rihl/core/constants.dart';
import 'package:rihl/widgets/option_dropdown.dart';

/// Dropdown of temperature requirements: `ambient`, `chilled` or `frozen`.
class TemperatureDropdown extends StatelessWidget {
  const TemperatureDropdown({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
    this.validator,
    this.autovalidateMode,
  });

  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return OptionDropdown(
      label: label,
      options: AppConstants.temperatureOptions,
      value: value,
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: autovalidateMode,
      prefixIcon: Icons.thermostat_outlined,
    );
  }
}
