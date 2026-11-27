import 'package:flutter/material.dart';
import 'package:rihl/core/app_formatters.dart';
import 'package:rihl/core/app_routes.dart';
import 'package:rihl/core/constants.dart';
import 'package:rihl/features/shipments/models/shipment_details.dart';
import 'package:rihl/l10n/app_strings.dart';
import 'package:rihl/models/localized_option.dart';
import 'package:rihl/widgets/custom_button.dart';
import 'package:rihl/widgets/language_toggle_button.dart';

/// Confirmation shown after the shipment is submitted.
class ShipmentSuccessScreen extends StatelessWidget {
  const ShipmentSuccessScreen({super.key});

  String _optionLabel(
    BuildContext context,
    List<LocalizedOption> options,
    String code,
  ) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return LocalizedOption.find(options, code)?.label(languageCode) ?? code;
  }

  Widget _summaryItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.fieldSpacing / 2),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppSizes.fieldSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final theme = Theme.of(context);
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is! ShipmentDetails) {
      return Scaffold(
        appBar: AppBar(title: Text(strings.shipmentDetails)),
        body: Padding(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: Center(
            child: CustomButton(
              label: strings.sendAnotherShipment,
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.shipmentDetails,
                  (route) => false,
                );
              },
            ),
          ),
        ),
      );
    }

    final details = arguments;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: const [LanguageToggleButton()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSizes.sectionSpacing),
              Center(
                child: Icon(
                  Icons.check_circle_outline,
                  size: AppSizes.sectionSpacing * 3,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSizes.sectionSpacing),
              Text(
                strings.shipmentSubmitted,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.fieldSpacing),
              Text(
                strings.shipmentSubmittedMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSizes.sectionSpacing),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  child: Column(
                    children: [
                      _summaryItem(
                        context,
                        Icons.location_on_outlined,
                        strings.originCity,
                        _optionLabel(
                          context,
                          AppConstants.cities,
                          details.origin,
                        ),
                      ),
                      _summaryItem(
                        context,
                        Icons.flag_outlined,
                        strings.destinationCity,
                        _optionLabel(
                          context,
                          AppConstants.cities,
                          details.destination,
                        ),
                      ),
                      const Divider(),
                      _summaryItem(
                        context,
                        Icons.calendar_today_outlined,
                        strings.deliveryDate,
                        AppFormatters.date(details.deliveryDate),
                      ),
                      _summaryItem(
                        context,
                        Icons.inventory_2_outlined,
                        strings.cargoType,
                        _optionLabel(
                          context,
                          AppConstants.cargoTypes,
                          details.cargoType,
                        ),
                      ),
                      _summaryItem(
                        context,
                        Icons.scale_outlined,
                        strings.weightKg,
                        details.weightText,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.sectionSpacing),
              CustomButton(
                label: strings.sendAnotherShipment,
                icon: Icons.add,
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.shipmentDetails,
                    ModalRoute.withName(AppRoutes.roleSelection),
                  );
                },
              ),
              const SizedBox(height: AppSizes.fieldSpacing),
              CustomButton(
                label: strings.backToHome,
                icon: Icons.home_outlined,
                variant: CustomButtonVariant.secondary,
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.roleSelection,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
