import 'package:flutter/material.dart';
import 'package:rihl/core/app_colors.dart';
import 'package:rihl/l10n/app_strings.dart';

/// Shows progress in a multi-step flow: dots and "Step 1 of 3 · label".
/// [currentStep] starts at 1.
class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.label,
  });

  final int currentStep;
  final int totalSteps;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final text = label == null
        ? strings.stepOf(currentStep, totalSteps)
        : '${strings.stepOf(currentStep, totalSteps)} · $label';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var step = 1; step <= totalSteps; step++)
              Expanded(
                child: Container(
                  key: ValueKey('step-$step'),
                  height: 6,
                  margin: const EdgeInsetsDirectional.only(end: 6),
                  decoration: BoxDecoration(
                    color: step <= currentStep
                        ? AppColors.primary
                        : AppColors.accent,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
      ],
    );
  }
}
