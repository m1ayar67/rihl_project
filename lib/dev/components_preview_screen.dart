import 'package:flutter/material.dart';
import 'package:rihl/core/app_formatters.dart';
import 'package:rihl/core/app_routes.dart';
import 'package:rihl/core/constants.dart';
import 'package:rihl/core/validators.dart';
import 'package:rihl/l10n/app_strings.dart';
import 'package:rihl/widgets/cargo_dropdown.dart';
import 'package:rihl/widgets/city_dropdown.dart';
import 'package:rihl/widgets/custom_button.dart';
import 'package:rihl/widgets/custom_date_picker.dart';
import 'package:rihl/widgets/custom_text_field.dart';
import 'package:rihl/widgets/language_toggle_button.dart';
import 'package:rihl/widgets/step_indicator.dart';
import 'package:rihl/widgets/temperature_dropdown.dart';

/// TEMPORARY screen that shows every shared widget in one form.
/// Delete this file (and the home route) once the real screens exist.
class ComponentsPreviewScreen extends StatefulWidget {
  const ComponentsPreviewScreen({super.key});

  @override
  State<ComponentsPreviewScreen> createState() =>
      _ComponentsPreviewScreenState();
}

class _ComponentsPreviewScreenState extends State<ComponentsPreviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weight = TextEditingController();
  String? _origin;
  String? _destination;
  String? _cargo;
  String? _temperature;
  DateTime? _date;
  String? _message;

  @override
  void dispose() {
    _weight.dispose();
    super.dispose();
  }

  void _submit(AppStrings strings) {
    final ok = _formKey.currentState!.validate();
    setState(() => _message = ok ? strings.formValid : null);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final validators = Validators.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.appName),
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
                const StepIndicator(currentStep: 1, totalSteps: 3),
                const SizedBox(height: AppSizes.sectionSpacing),
                CityDropdown(
                  label: strings.originCity,
                  value: _origin,
                  validator: validators.requiredSelection,
                  onChanged: (v) => setState(() => _origin = v),
                ),
                const SizedBox(height: AppSizes.fieldSpacing),
                CityDropdown(
                  label: strings.destinationCity,
                  value: _destination,
                  validator: (v) => validators.destination(v, _origin),
                  onChanged: (v) => setState(() => _destination = v),
                ),
                const SizedBox(height: AppSizes.fieldSpacing),
                CargoDropdown(
                  label: strings.cargoType,
                  value: _cargo,
                  validator: validators.requiredSelection,
                  onChanged: (v) => setState(() => _cargo = v),
                ),
                const SizedBox(height: AppSizes.fieldSpacing),
                TemperatureDropdown(
                  label: strings.temperature,
                  value: _temperature,
                  validator: validators.requiredSelection,
                  onChanged: (v) => setState(() => _temperature = v),
                ),
                const SizedBox(height: AppSizes.fieldSpacing),
                CustomTextField(
                  label: strings.weightKg,
                  controller: _weight,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: AppFormatters.decimalInput,
                  prefixIcon: Icons.scale_outlined,
                  validator: validators.weightKg,
                ),
                const SizedBox(height: AppSizes.fieldSpacing),
                CustomDatePicker(
                  label: strings.deliveryDate,
                  value: _date,
                  validator: validators.date,
                  onChanged: (v) => setState(() => _date = v),
                ),
                const SizedBox(height: AppSizes.sectionSpacing),
                CustomButton(
                  label: strings.next,
                  onPressed: () => _submit(strings),
                ),
                const SizedBox(height: AppSizes.fieldSpacing),
                CustomButton(
                  label: strings.reset,
                  variant: CustomButtonVariant.secondary,
                  onPressed: () {
                    _formKey.currentState!.reset();
                    _weight.clear();
                    setState(() {
                      _origin = _destination = _cargo = _temperature = null;
                      _date = null;
                      _message = null;
                    });
                  },
                ),
                const SizedBox(height: AppSizes.fieldSpacing),
                CustomButton(
                  label: strings.shipmentDetails,
                  variant: CustomButtonVariant.secondary,
                  icon: Icons.local_shipping_outlined,
                  onPressed: () =>
                      Navigator.of(context)
                          .pushNamed(AppRoutes.shipmentDetails),
                ),
                if (_message != null) ...[
                  const SizedBox(height: AppSizes.fieldSpacing),
                  Text(_message!, textAlign: TextAlign.center),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
