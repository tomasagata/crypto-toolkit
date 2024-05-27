import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class KyberKeyField extends FormBuilderTextField {

  KyberKeyField.publicKey({
    super.key,
    super.controller,
    required super.name,
    super.validator,
    super.initialValue,
    required void Function() onIconPress
  }) : super (
    minLines: null,
    maxLines: null,
    autocorrect: false,
    enableSuggestions: false,
    expands: true,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      label: const Text("Public key (base64)"),
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

  KyberKeyField.privateKey({
    super.key,
    super.controller,
    required super.name,
    super.validator,
    super.initialValue,
    required void Function() onIconPress
  }) : super (
    minLines: null,
    maxLines: null,
    autocorrect: false,
    enableSuggestions: false,
    expands: true,
    decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: const Text("Private key (base64)"),
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





class DilithiumKeyField extends FormBuilderTextField {

  DilithiumKeyField.publicKey({
    super.key,
    super.controller,
    required super.name,
    super.validator,
    super.initialValue,
    required void Function() onIconPress
  }) : super (
    autocorrect: false,
    enableSuggestions: false,
    minLines: null,
    maxLines: null,
    expands: true,
    decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: const Text("Public key (base64)"),
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

  DilithiumKeyField.privateKey({
    super.key,
    super.controller,
    required super.name,
    super.validator,
    super.initialValue,
    required void Function() onIconPress
  }) : super (
    autocorrect: false,
    enableSuggestions: false,
    minLines: null,
    maxLines: null,
    expands: true,
    decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: const Text("Private key (base64)"),
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
