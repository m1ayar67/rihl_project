import 'package:flutter/material.dart';
import 'package:rihl/core/app_colors.dart';
import 'package:rihl/core/app_routes.dart';
import 'package:rihl/core/constants.dart';
import 'package:rihl/l10n/app_strings.dart';
import 'package:rihl/widgets/language_toggle_button.dart';

/// First screen: the user picks who they are (shipper, carrier or driver).
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  static const String _backgroundImage = 'assets/images/role_background.png';
  static const String _logoImage = 'assets/images/rihl_logo.png';

  Widget _roleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final enabled = onTap != null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    size: 30,
                    color: enabled ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: enabled
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  enabled ? Icons.chevron_right : Icons.lock_outline,
                  color: enabled ? AppColors.primary : AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Decorative background (waves and route lines).
          Positioned.fill(
            child: Image.asset(
              _backgroundImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: LanguageToggleButton(),
                  ),
                  const SizedBox(height: AppSizes.sectionSpacing),

                  Text(
                    strings.welcomeTo,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.fieldSpacing),

                  // RIHL name/logo.
                  Center(
                    child: Image.asset(
                      _logoImage,
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Text(
                        'RIHL',
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.sectionSpacing),

                  Text(
                    strings.selectRole,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sectionSpacing),

                  // Shipper - Elaf
                  _roleCard(
                    context,
                    title: strings.shipperRole,
                    subtitle: strings.shipperDescription,
                    icon: Icons.inventory_2_outlined,
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.shipmentDetails);
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

                  // Driver - future sprint
                  _roleCard(
                    context,
                    title: strings.driverRole,
                    subtitle: strings.driverDescription,
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: AppSizes.sectionSpacing),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}