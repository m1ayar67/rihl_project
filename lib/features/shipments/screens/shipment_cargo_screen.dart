import 'package:flutter/material.dart';
import 'package:rihl/core/app_formatters.dart';
import 'package:rihl/core/app_routes.dart';
import 'package:rihl/core/constants.dart';
import 'package:rihl/core/validators.dart';
import 'package:rihl/features/shipments/models/shipment_details.dart';
import 'package:rihl/features/shipments/models/shipment_route_draft.dart';
import 'package:rihl/l10n/app_strings.dart';
import 'package:rihl/widgets/cargo_dropdown.dart';
import 'package:rihl/widgets/custom_button.dart';
import 'package:rihl/widgets/custom_text_field.dart';
import 'package:rihl/widgets/language_toggle_button.dart';
import 'package:rihl/widgets/step_indicator.dart';
import 'package:rihl/widgets/temperature_dropdown.dart';

/// Step 2 of 3 of the shipment flow: what is being sent.
///
/// Receives a [ShipmentRouteDraft] from step 1 and, on "Next", sends the
/// complete [ShipmentDetails] to the review screen.
class ShipmentCargoScreen extends StatefulWidget {
  const ShipmentCargoScreen({super.key});

  @override
  State<ShipmentCargoScreen> createState() => _ShipmentCargoScreenState();
}

class _ShipmentCargoScreenState extends State<ShipmentCargoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();

  String? _cargoType;
  String? _temperature;
  bool _submitted = false;

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _next(ShipmentRouteDraft draft) {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;

    if (!AppRoutes.routes.containsKey(AppRoutes.shipmentReview)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.of(context).formValid)));
      return;
    }

    Navigator.of(context).pushNamed(
      AppRoutes.shipmentReview,
      arguments: ShipmentDetails(
        origin: draft.origin,
        destination: draft.destination,
        cargoType: _cargoType!,
        weightKg: AppFormatters.parseNumber(_weightController.text)!,
        temperature: _temperature!,
        deliveryDate: draft.deliveryDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final validators = Validators.of(context);
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is! ShipmentRouteDraft) {
      return Scaffold(
        appBar: AppBar(title: Text(strings.cargoDetails)),
        body: Padding(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: Center(
            child: CustomButton(
              label: strings.back,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
      );
    }

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
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StepIndicator(
                  currentStep: 2,
                  totalSteps: 3,
                  label: strings.cargoDetails,
                ),
                const SizedBox(height: AppSizes.sectionSpacing),
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
                const SizedBox(height: AppSizes.sectionSpacing),
                CustomButton(
                  label: strings.next,
                  onPressed: () => _next(arguments),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
