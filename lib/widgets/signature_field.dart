import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SignatureField extends FormBuilderTextField {

  SignatureField({
    super.key,
    super.controller,
    required super.name,
    super.validator,
    super.initialValue,
    required void Function() onIconPress,
    super.readOnly
  }) : super (
      minLines: null,
      maxLines: null,
      autocorrect: false,
      enableSuggestions: false,
      expands: true,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: const Text("Signature (base64)"),
          constraints: const BoxConstraints(
            minWidth: 0.0,
            maxWidth: 400,
            minHeight: 0.0,
            maxHeight: 200,
          ),
          alignLabelWithHint: true,
          suffixIcon: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: onIconPress
          )
      )
  );

}