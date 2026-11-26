import 'package:flutter/material.dart';
import 'package:rihl/core/app_formatters.dart';
import 'package:rihl/core/app_routes.dart';
import 'package:rihl/core/constants.dart';
import 'package:rihl/core/validators.dart';
import 'package:rihl/features/shipments/models/shipment_details.dart';
import 'package:rihl/l10n/app_strings.dart';
import 'package:rihl/widgets/cargo_dropdown.dart';
import 'package:rihl/widgets/city_dropdown.dart';
import 'package:rihl/widgets/custom_button.dart';
import 'package:rihl/widgets/custom_date_picker.dart';
import 'package:rihl/widgets/custom_text_field.dart';
import 'package:rihl/widgets/language_toggle_button.dart';
import 'package:rihl/widgets/step_indicator.dart';
import 'package:rihl/widgets/temperature_dropdown.dart';

/// Step 1 of 3 of the shipment flow: where, what, how heavy and by when.
///
/// On "Next" the form is validated; if it is valid, a [ShipmentDetails] is
/// sent to the review screen as the route argument.
class ShipmentDetailsScreen extends StatefulWidget {
  const ShipmentDetailsScreen({super.key});

  @override
  State<ShipmentDetailsScreen> createState() => _ShipmentDetailsScreenState();
}

class _ShipmentDetailsScreenState extends State<ShipmentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();

  String? _origin;
  String? _destination;
  String? _cargoType;
  String? _temperature;
  DateTime? _deliveryDate;

  /// Errors are hidden until the first "Next" press, then they follow the
  /// user's changes live (so fixing a field clears its error at once).
  bool _submitted = false;

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _next() {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;

    final details = ShipmentDetails(
      origin: _origin!,
      destination: _destination!,
      cargoType: _cargoType!,
      weightKg: AppFormatters.parseNumber(_weightController.text)!,
      temperature: _temperature!,
      deliveryDate: _deliveryDate!,
    );

    // The review screen belongs to another teammate. Until she registers
    // AppRoutes.shipmentReview in app_routes.dart, just confirm the form.
    if (!AppRoutes.routes.containsKey(AppRoutes.shipmentReview)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.of(context).formValid)));
      return;
    }
    Navigator.of(context)
        .pushNamed(AppRoutes.shipmentReview, arguments: details);
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
        title: Text(strings.shipmentDetails),
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
                  label: strings.shipmentDetails,
                ),
                const SizedBox(height: AppSizes.sectionSpacing),
                CityDropdown(
                  label: strings.originCity,
                  value: _origin,
                  autovalidateMode: mode,
                  validator: validators.requiredSelection,
                  onChanged: (value) => setState(() => _origin = value),
                ),
                const SizedBox(height: AppSizes.fieldSpacing),
                CityDropdown(
                  label: strings.destinationCity,
                  value: _destination,
                  autovalidateMode: mode,
                  validator: (value) => validators.destination(value, _origin),
                  onChanged: (value) => setState(() => _destination = value),
                ),
                const SizedBox(height: AppSizes.fieldSpacing),
                CargoDropdown(
                  label: strings.cargoType,
                  value: _cargoType,
                  autovalidateMode: mode,
                  validator: validators.requiredSelection,
                  onChanged: (value) => setState(() => _cargoType = value),
                ),
                const SizedBox(height: AppSizes.fieldSpacing),
                TemperatureDropdown(
                  label: strings.temperature,
                  value: _temperature,
                  autovalidateMode: mode,
                  validator: validators.requiredSelection,
                  onChanged: (value) => setState(() => _temperature = value),
                ),
                const SizedBox(height: AppSizes.fieldSpacing),
                CustomTextField(
                  label: strings.weightKg,
                  controller: _weightController,
                  prefixIcon: Icons.scale_outlined,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: AppFormatters.decimalInput,
                  autovalidateMode: mode,
                  validator: validators.weightKg,
                ),
                const SizedBox(height: AppSizes.fieldSpacing),
                CustomDatePicker(
                  label: strings.deliveryDate,
                  value: _deliveryDate,
                  autovalidateMode: mode,
                  validator: validators.date,
                  onChanged: (value) => setState(() => _deliveryDate = value),
                ),
                const SizedBox(height: AppSizes.sectionSpacing),
                CustomButton(label: strings.next, onPressed: _next),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
