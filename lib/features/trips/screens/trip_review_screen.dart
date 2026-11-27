import 'package:flutter/material.dart';
import 'package:rihl/core/app_formatters.dart';
import 'package:rihl/core/constants.dart';
import 'package:rihl/features/trips/models/trip_details.dart';
import 'package:rihl/l10n/app_strings.dart';
import 'package:rihl/models/localized_option.dart';
import 'package:rihl/widgets/custom_button.dart';
import 'package:rihl/widgets/language_toggle_button.dart';
import 'package:rihl/widgets/step_indicator.dart';
import 'package:rihl/core/app_routes.dart';

class TripReviewScreen extends StatelessWidget {
  const TripReviewScreen({super.key});

  String _optionLabel(
    BuildContext context,
    List<LocalizedOption> options,
    String code,
  ) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return LocalizedOption.find(options, code)?.label(languageCode) ?? code;
  }

  Widget _reviewItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
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
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: AppSizes.bodyLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: AppSizes.bodyLarge,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    final details = ModalRoute.of(context)?.settings.arguments as TripDetails?;

    if (details == null) {
      return Scaffold(
        appBar: AppBar(title: Text(strings.reviewTrip)),
        body: Center(
          child: TextButton(
            onPressed: () => Navigator.of(context).maybePop(),
            child: Text(strings.back),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.reviewTrip),
        actions: const [LanguageToggleButton()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StepIndicator(
                currentStep: 3,
                totalSteps: 3,
                label: strings.reviewTrip,
              ),

              const SizedBox(height: AppSizes.sectionSpacing),

              _section(context, strings.tripDetails, [
                _reviewItem(
                  context,
                  strings.originCity,
                  _optionLabel(context, AppConstants.cities, details.origin),
                  Icons.location_on_outlined,
                ),
                _reviewItem(
                  context,
                  strings.destinationCity,
                  _optionLabel(
                    context,
                    AppConstants.cities,
                    details.destination,
                  ),
                  Icons.flag_outlined,
                ),
                _reviewItem(
                  context,
                  strings.departureDate,
                  AppFormatters.date(details.departureDate),
                  Icons.calendar_today_outlined,
                ),
                _reviewItem(
                  context,
                  strings.departureTime,
                  details.departureTime,
                  Icons.access_time,
                ),
              ]),

              const SizedBox(height: AppSizes.fieldSpacing),

              _section(context, strings.cargoDetails, [
                _reviewItem(
                  context,
                  strings.capacityKg,
                  details.capacityKg.toString(),
                  Icons.scale_outlined,
                ),
                _reviewItem(
                  context,
                  strings.supportedCargoType,
                  _optionLabel(
                    context,
                    AppConstants.cargoTypes,
                    details.cargoType,
                  ),
                  Icons.inventory_2_outlined,
                ),
                _reviewItem(
                  context,
                  strings.supportedTemperature,
                  _optionLabel(
                    context,
                    AppConstants.temperatureOptions,
                    details.temperature,
                  ),
                  Icons.thermostat_outlined,
                ),
              ]),

              const SizedBox(height: AppSizes.sectionSpacing),

              CustomButton(
                label: strings.publishTrip,
                icon: Icons.check_circle_outline,
                onPressed: () {
                  // Temporary simulation for UI testing only.
                  Navigator.of(context)
                      .pushNamed(AppRoutes.tripSuccess, arguments: details);
                },
              ),

              const SizedBox(height: AppSizes.fieldSpacing),

              CustomButton(
                label: strings.back,
                variant: CustomButtonVariant.secondary,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
