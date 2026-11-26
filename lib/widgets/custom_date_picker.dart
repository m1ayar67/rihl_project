import 'package:flutter/material.dart';
import 'package:rihl/core/app_colors.dart';
import 'package:rihl/core/app_formatters.dart';
import 'package:rihl/core/app_theme.dart';
import 'package:rihl/core/constants.dart';

/// Field that opens the calendar. Shows the date as `YYYY-MM-DD`.
/// Allowed dates: today up to [AppConstants.maxBookingDaysAhead] days ahead.
class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
    this.validator,
    this.autovalidateMode,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final FormFieldValidator<DateTime>? validator;
  final AutovalidateMode? autovalidateMode;

  Future<void> _pick(
    BuildContext context,
    FormFieldState<DateTime> state,
  ) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initial = (state.value != null && !state.value!.isBefore(today))
        ? state.value!
        : today;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: today.add(
        const Duration(days: AppConstants.maxBookingDaysAhead),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme
                .copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      state.didChange(picked);
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      key: ValueKey('date-picker-$label-${value?.toIso8601String()}'),
      initialValue: value,
      validator: validator,
      autovalidateMode: autovalidateMode,
      builder: (state) {
        final text = state.value == null
            ? ''
            : AppFormatters.date(state.value!);
        return InkWell(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          onTap: () => _pick(context, state),
          child: InputDecorator(
            decoration: AppTheme.inputDecoration(
              label: label,
              prefixIcon: Icons.calendar_today_outlined,
              errorText: state.errorText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
            ),
            isEmpty: text.isEmpty,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  text,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: AppSizes.bodyLarge,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}