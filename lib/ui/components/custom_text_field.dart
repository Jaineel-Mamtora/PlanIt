import 'package:flutter/material.dart';

import 'package:plan_it/ui/utils/size_config.dart';

class CustomTextField extends StatelessWidget {
  final Function customOnTap;
  final FocusNode focusNode;
  final bool obscureText;
  final String labelText;
  final bool customAutoFocus;
  final TextInputType customKeyboardType;
  final int customMaxLines;
  final TextEditingController controller;
  final dynamic customOnFieldSubmitted;
  final TextCapitalization customTextCapitalization;

  const CustomTextField({
    Key key,
    this.controller,
    this.customAutoFocus,
    this.obscureText,
    this.labelText,
    this.customOnTap,
    this.customKeyboardType,
    this.customMaxLines,
    this.focusNode,
    this.customOnFieldSubmitted,
    this.customTextCapitalization,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        fontSize: 2.4 * SizeConfig.heightMultiplier,
        color: Colors.black,
      ),
      autofocus: customAutoFocus ?? false,
      controller: controller ?? null,
      focusNode: focusNode ?? null,
      obscureText: obscureText ?? false,
      onTap: customOnTap ?? null,
      maxLines: customMaxLines ?? 1,
      textCapitalization: customTextCapitalization ?? TextCapitalization.none,
      keyboardType: customKeyboardType ?? TextInputType.text,
      onFieldSubmitted: customOnFieldSubmitted ?? null,
      decoration: InputDecoration(
        focusColor: Theme.of(context).primaryColor,
        hintText: labelText ?? null,
        contentPadding: EdgeInsets.symmetric(
          vertical: 0.75 * SizeConfig.heightMultiplier,
          horizontal: 2.5 * SizeConfig.widthMultiplier,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(1.25 * SizeConfig.widthMultiplier),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(1.25 * SizeConfig.widthMultiplier),
          ),
        ),
      ),
    );
  }
}
