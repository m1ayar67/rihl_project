import 'package:flutter/material.dart';
import 'package:rihl/core/constants.dart';
import 'package:rihl/widgets/option_dropdown.dart';

/// Dropdown of Saudi cities. Reports the city code, for example `jeddah`.
///
/// For a destination field use `validators.destination(value, originCode)`.
class CityDropdown extends StatelessWidget {
  const CityDropdown({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
    this.validator,
  });

  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return OptionDropdown(
      label: label,
      options: AppConstants.cities,
      value: value,
      onChanged: onChanged,
      validator: validator,
      prefixIcon: Icons.location_on_outlined,
    );
  }
}
