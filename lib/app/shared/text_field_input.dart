import 'package:flutter/material.dart';
import 'package:lesson/app/config/app_colors.dart';

class TextFieldInput extends StatefulWidget {
  const TextFieldInput({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.onPressedSuffixIcon,
    required this.isPassword,
    this.obscureText,
    required this.controller,
  });

  final String hintText;
  final void Function(String?)? onChanged;
  final void Function()? onPressedSuffixIcon;
  final bool isPassword;
  final bool? obscureText;
  final TextEditingController controller;

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _isFocused = hasFocus;
          });
        },
        child: TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          onChanged: widget.onChanged,
          keyboardType: widget.isPassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
          cursorColor: AppColors.primary,
          style: const TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 16,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 16,
              color: Colors.black38,
            ),
            prefixIcon: Icon(
              widget.isPassword
                  ? Icons.lock_outline_rounded
                  : Icons.email_outlined,
              color: _isFocused ? AppColors.primary : Colors.black38,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: _isFocused ? AppColors.primary : Colors.black38,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                      widget.onPressedSuffixIcon?.call();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
