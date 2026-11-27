import 'package:flutter/material.dart';
import 'package:rihl/core/app_routes.dart';
import 'package:rihl/core/constants.dart';
import 'package:rihl/l10n/app_strings.dart';
import 'package:rihl/widgets/language_toggle_button.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Widget _roleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSizes.screenPadding),
        enabled: onTap != null,
        leading: Icon(
          icon,
          size: AppSizes.sectionSpacing * 1.5,
          color: onTap != null
              ? theme.colorScheme.primary
              : theme.disabledColor,
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(
          onTap != null ? Icons.chevron_right : Icons.lock_outline,
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(strings.selectRole),
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
                child: Image.asset(
                  'assets/images/photo_2026-11-27_04-06-04.jpg',
                  height: AppSizes.sectionSpacing * 6,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: AppSizes.sectionSpacing),

              Text(
                strings.selectRole,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: AppSizes.fieldSpacing),

              Text(
                strings.roleSubtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: AppSizes.sectionSpacing),

              // Shipper - Elaf
              _roleCard(
                context,
                title: strings.shipperRole,
                subtitle: strings.shipperDescription,
                icon: Icons.inventory_2_outlined,
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.shipmentDetails);
                },
              ),

              const SizedBox(height: AppSizes.fieldSpacing),

              // Carrier - Layan
              _roleCard(
                context,
                title: strings.carrierRole,
                subtitle: strings.carrierDescription,
                icon: Icons.local_shipping_outlined,
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.tripDetails);
                },
              ),

              const SizedBox(height: AppSizes.fieldSpacing),

              // Driver - Future sprint
              _roleCard(
                context,
                title: strings.driverRole,
                subtitle: strings.driverDescription,
                icon: Icons.person_outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
