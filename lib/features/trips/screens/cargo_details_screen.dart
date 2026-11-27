import 'package:flutter/material.dart';
import 'package:rihl/core/app_formatters.dart';
import 'package:rihl/core/app_routes.dart';
import 'package:rihl/core/constants.dart';
import 'package:rihl/core/validators.dart';
import 'package:rihl/features/trips/models/trip_details.dart';
import 'package:rihl/l10n/app_strings.dart';
import 'package:rihl/widgets/cargo_dropdown.dart';
import 'package:rihl/widgets/custom_button.dart';
import 'package:rihl/widgets/custom_text_field.dart';
import 'package:rihl/widgets/language_toggle_button.dart';
import 'package:rihl/widgets/step_indicator.dart';
import 'package:rihl/widgets/temperature_dropdown.dart';

class CargoDetailsScreen extends StatefulWidget {
  const CargoDetailsScreen({super.key});

  @override
  State<CargoDetailsScreen> createState() =>
      _CargoDetailsScreenState();
}

class _CargoDetailsScreenState
    extends State<CargoDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _capacityController = TextEditingController();

  String? _cargoType;
  String? _temperature;

  bool _submitted = false;

  @override
  void dispose() {
    _capacityController.dispose();
    super.dispose();
  }

  void _next() {
    setState(() => _submitted = true);

    if (!_formKey.currentState!.validate()) return;

    final arguments =
        ModalRoute.of(context)!.settings.arguments
            as Map<String, dynamic>;

    final details = TripDetails(
      origin: arguments['origin'] as String,
      destination: arguments['destination'] as String,
      departureDate:
          arguments['departureDate'] as DateTime,
      departureTime:
          arguments['departureTime'] as String,
      capacityKg: AppFormatters.parseNumber(
        _capacityController.text,
      )!,
      cargoType: _cargoType!,
      temperature: _temperature!,
    );

    if (!AppRoutes.routes.containsKey(
      AppRoutes.tripReview,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.of(context).formValid,
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pushNamed(
      AppRoutes.tripReview,
      arguments: details,
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
        title: Text(strings.cargoDetails),
        actions: const [LanguageToggleButton()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
            AppSizes.screenPadding,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                StepIndicator(
                  currentStep: 2,
                  totalSteps: 3,
                  label: strings.cargoDetails,
                ),

                const SizedBox(
                  height: AppSizes.sectionSpacing,
                ),

                CustomTextField(
                  label: strings.capacityKg,
                  controller: _capacityController,
                  prefixIcon: Icons.scale_outlined,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters:
                      AppFormatters.decimalInput,
                  autovalidateMode: mode,
                  validator: validators.weightKg,
                ),

                const SizedBox(
                  height: AppSizes.fieldSpacing,
                ),

                CargoDropdown(
                  label: strings.supportedCargoType,
                  value: _cargoType,
                  autovalidateMode: mode,
                  validator:
                      validators.requiredSelection,
                  onChanged: (value) {
                    setState(() => _cargoType = value);
                  },
                ),

                const SizedBox(
                  height: AppSizes.fieldSpacing,
                ),

                TemperatureDropdown(
                  label: strings.supportedTemperature,
                  value: _temperature,
                  autovalidateMode: mode,
                  validator:
                      validators.requiredSelection,
                  onChanged: (value) {
                    setState(() => _temperature = value);
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