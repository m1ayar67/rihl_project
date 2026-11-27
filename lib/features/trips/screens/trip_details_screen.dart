import 'package:flutter/material.dart';
import 'package:rihl/core/app_routes.dart';
import 'package:rihl/core/app_theme.dart';
import 'package:rihl/core/constants.dart';
import 'package:rihl/core/validators.dart';
import 'package:rihl/l10n/app_strings.dart';
import 'package:rihl/widgets/city_dropdown.dart';
import 'package:rihl/widgets/custom_button.dart';
import 'package:rihl/widgets/custom_date_picker.dart';
import 'package:rihl/widgets/language_toggle_button.dart';
import 'package:rihl/widgets/step_indicator.dart';

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({super.key});

  @override
  State<TripDetailsScreen> createState() =>
      _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _origin;
  String? _destination;
  DateTime? _departureDate;
  TimeOfDay? _departureTime;

  bool _submitted = false;

  String? _validateTime(TimeOfDay? value) {
    final strings = AppStrings.of(context);

    if (value == null) {
      return strings.chooseTime;
    }

    if (_departureDate != null) {
      final departure = DateTime(
        _departureDate!.year,
        _departureDate!.month,
        _departureDate!.day,
        value.hour,
        value.minute,
      );

      if (departure.isBefore(DateTime.now())) {
        return strings.timePast;
      }
    }

    return null;
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  void _next() {
    setState(() => _submitted = true);

    if (!_formKey.currentState!.validate()) return;

    if (!AppRoutes.routes.containsKey(AppRoutes.cargoDetails)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.of(context).formValid),
        ),
      );
      return;
    }

    Navigator.of(context).pushNamed(
      AppRoutes.cargoDetails,
      arguments: {
        'origin': _origin!,
        'destination': _destination!,
        'departureDate': _departureDate!,
        'departureTime': _formatTime(_departureTime!),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final validators = Validators.of(context);

    final mode = _submitted
        ? AutovalidateMode.always
        : AutovalidateMode.disabled;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.tripDetails),
        actions: const [LanguageToggleButton()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StepIndicator(
                  currentStep: 1,
                  totalSteps: 3,
                  label: strings.tripDetails,
                ),

                const SizedBox(
                  height: AppSizes.sectionSpacing,
                ),

                CityDropdown(
                  label: strings.originCity,
                  value: _origin,
                  autovalidateMode: mode,
                  validator: validators.requiredSelection,
                  onChanged: (value) {
                    setState(() => _origin = value);
                  },
                ),

                const SizedBox(
                  height: AppSizes.fieldSpacing,
                ),

                CityDropdown(
                  label: strings.destinationCity,
                  value: _destination,
                  autovalidateMode: mode,
                  validator: (value) =>
                      validators.destination(value, _origin),
                  onChanged: (value) {
                    setState(() => _destination = value);
                  },
                ),

                const SizedBox(
                  height: AppSizes.fieldSpacing,
                ),

                CustomDatePicker(
                  label: strings.departureDate,
                  value: _departureDate,
                  autovalidateMode: mode,
                  validator: validators.date,
                  onChanged: (value) {
                    setState(() => _departureDate = value);
                  },
                ),

                const SizedBox(
                  height: AppSizes.fieldSpacing,
                ),

                FormField<TimeOfDay>(
                  initialValue: _departureTime,
                  autovalidateMode: mode,
                  validator: _validateTime,
                  builder: (state) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadius,
                      ),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime:
                              _departureTime ?? TimeOfDay.now(),
                        );

                        if (!mounted || picked == null) return;

                        state.didChange(picked);

                        setState(() {
                          _departureTime = picked;
                        });
                      },
                      child: InputDecorator(
                        decoration: AppTheme.inputDecoration(
                          label: strings.departureTime,
                          prefixIcon: Icons.access_time,
                          errorText: state.errorText,
                        ),
                        isEmpty: _departureTime == null,
                        child: Text(
                          _departureTime == null
                              ? ''
                              : _formatTime(_departureTime!),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(
                  height: AppSizes.sectionSpacing,
                ),

                CustomButton(
                  label: strings.next,
                  onPressed: _next,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}