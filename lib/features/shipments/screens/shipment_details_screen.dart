import 'package:flutter/material.dart';
import 'package:rihl/core/app_routes.dart';
import 'package:rihl/core/constants.dart';
import 'package:rihl/core/validators.dart';
import 'package:rihl/features/shipments/models/shipment_route_draft.dart';
import 'package:rihl/l10n/app_strings.dart';
import 'package:rihl/widgets/city_dropdown.dart';
import 'package:rihl/widgets/custom_button.dart';
import 'package:rihl/widgets/custom_date_picker.dart';
import 'package:rihl/widgets/language_toggle_button.dart';
import 'package:rihl/widgets/step_indicator.dart';

/// Step 1 of 3 of the shipment flow: where from, where to, and by when.
///
/// On "Next" the form is validated and a [ShipmentRouteDraft] is sent to the
/// cargo details screen.
class ShipmentDetailsScreen extends StatefulWidget {
  const ShipmentDetailsScreen({super.key});

  @override
  State<ShipmentDetailsScreen> createState() => _ShipmentDetailsScreenState();
}

class _ShipmentDetailsScreenState extends State<ShipmentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _origin;
  String? _destination;
  DateTime? _deliveryDate;

  /// Errors are hidden until the first "Next" press, then they follow the
  /// user's changes live.
  bool _submitted = false;

  void _next() {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;

    if (!AppRoutes.routes.containsKey(AppRoutes.shipmentCargo)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.of(context).formValid)));
      return;
    }

    Navigator.of(context).pushNamed(
      AppRoutes.shipmentCargo,
      arguments: ShipmentRouteDraft(
        origin: _origin!,
        destination: _destination!,
        deliveryDate: _deliveryDate!,
      ),
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
