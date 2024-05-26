import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SeedField extends FormBuilderTextField {

  SeedField.dilithium({
    super.key,
    required super.name
  }) : super (
      initialValue: "",
      autocorrect: false,
      maxLines: 1,
      enableSuggestions: false,
      maxLength: 64,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text("Seed (hexadecimal)"),
          constraints: BoxConstraints(
            minWidth: 0.0,
            maxWidth: 400,
            minHeight: 0.0,
            maxHeight: 200,
          ),
          alignLabelWithHint: true
      ),
      validator: (seed) {
        if (seed!.isEmpty) {
          return null;
        }

        String? errorMsg;
        try {
          hex.decode(seed);
        } on Exception {
          errorMsg = "Invalid seed.";
        }
        return errorMsg;
      }
  );

  SeedField.kyber({
    super.key,
    required super.name
  }) : super (
    initialValue: "",
    autocorrect: false,
    maxLines: 1,
    enableSuggestions: false,
    maxLength: 128,
    maxLengthEnforcement: MaxLengthEnforcement.enforced,
    decoration: const InputDecoration(
        border: OutlineInputBorder(),
        label: Text("Seed (hexadecimal)"),
        constraints: BoxConstraints(
          minWidth: 0.0,
          maxWidth: 400,
          minHeight: 0.0,
          maxHeight: 200,
        ),
        alignLabelWithHint: true
    ),
    validator: (seed) {
      if (seed!.isEmpty) {
        return null;
      }

      String? errorMsg;
      try {
        hex.decode(seed);
      } on Exception {
        errorMsg = "Invalid seed.";
      }
      return errorMsg;
    }
  );

}