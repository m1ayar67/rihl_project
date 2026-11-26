import 'package:flutter/material.dart';
import 'package:rihl/core/constants.dart';
import 'package:rihl/widgets/option_dropdown.dart';

/// Dropdown of cargo types. Reports the cargo code, for example `food`.
class CargoDropdown extends StatelessWidget {
  const CargoDropdown({
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
      options: AppConstants.cargoTypes,
      value: value,
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: autovalidateMode,
      prefixIcon: Icons.inventory_2_outlined,
    );
  }
}
