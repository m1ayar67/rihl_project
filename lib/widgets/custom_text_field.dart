import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rihl/core/app_colors.dart';

/// Text field with the app's look. Supports a show/hide password toggle.
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixText,
    this.isPassword = false,
    this.forceLtr = false,
    this.onChanged,
    this.textInputAction,
    this.autovalidateMode,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final String? suffixText;

  /// Hides the text and shows an eye button to reveal it.
  final bool isPassword;

  /// Keep text left-to-right even in Arabic (emails, numbers).
  final bool forceLtr;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      autovalidateMode: widget.autovalidateMode,
      obscureText: widget.isPassword && _obscured,
      textDirection: widget.forceLtr ? TextDirection.ltr : null,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        suffixText: widget.suffixText,
        prefixIcon: widget.prefixIcon == null
            ? null
            : Icon(widget.prefixIcon, color: AppColors.secondary),
        suffixIcon: widget.isPassword
            ? IconButton(
                tooltip: _obscured ? 'Show' : 'Hide',
                icon: Icon(
                  _obscured ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.secondary,
                ),
                onPressed: () => setState(() => _obscured = !_obscured),
              )
            : null,
      ),
    );
  }
}
