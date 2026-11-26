import 'package:flutter/material.dart';
import 'package:rihl/core/app_colors.dart';
import 'package:rihl/core/app_theme.dart';
import 'package:rihl/core/constants.dart';
import 'package:rihl/models/localized_option.dart';

/// Dropdown that shows [LocalizedOption] labels in the current language and
/// reports the stable `code` of the chosen option.
///
/// City, cargo and temperature dropdowns are thin wrappers over this widget.
class OptionDropdown extends StatelessWidget {
  const OptionDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.onChanged,
    this.value,
    this.validator,
    this.prefixIcon,
    this.hint,
    this.autovalidateMode,
  });

  final String label;
  final List<LocalizedOption> options;

  /// Currently selected option code, or null.
  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  final IconData? prefixIcon;
  final String? hint;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final selected = LocalizedOption.find(options, value)?.code;

    return FormField<String>(
      // A new key when the value is changed from outside keeps the field in sync.
      key: ValueKey('option-dropdown-$label-$selected'),
      initialValue: selected,
      validator: validator,
      autovalidateMode: autovalidateMode,
      builder: (state) {
        return InputDecorator(
          decoration: AppTheme.inputDecoration(
            label: label,
            hint: hint,
            prefixIcon: prefixIcon,
            errorText: state.errorText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
          ),
          isEmpty: state.value == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: state.value,
              isExpanded: true,
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              dropdownColor: AppColors.surface,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.secondary,
              ),
              style: const TextStyle(
                color: AppColors.text,
                fontSize: AppSizes.bodyLarge,
              ),
              items: [
                for (final option in options)
                  DropdownMenuItem<String>(
                    value: option.code,
                    child: Text(
                      option.label(languageCode),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (code) {
                state.didChange(code);
                onChanged(code);
              },
            ),
          ),
        );
      },
    );
  }
}