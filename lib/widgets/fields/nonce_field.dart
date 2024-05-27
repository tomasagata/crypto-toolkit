import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class NonceField extends FormBuilderTextField {
  NonceField({
    super.key,
    required super.name,
  }) : super (
    valueTransformer: (String? nonceString) {
      if (nonceString == null || nonceString.isEmpty) {
        return null;
      }
      Uint8List paddedNonce = Uint8List(32);
      var actualNonce = Uint8List.fromList(hex.decode(nonceString));

      for (int i=0; i<actualNonce.length; i++) {
        paddedNonce[i] = actualNonce[i];
      }

      return paddedNonce;
    },
    autocorrect: false,
    maxLines: 1,
    enableSuggestions: false,
    maxLength: 64,
    initialValue: "",
    maxLengthEnforcement: MaxLengthEnforcement.enforced,
    decoration: const InputDecoration(
        border: OutlineInputBorder(),
        label: Text("nonce (hex)"),
        constraints: BoxConstraints(
          minWidth: 0.0,
          maxWidth: 400,
          minHeight: 0.0,
          maxHeight: 200,
        ),
        alignLabelWithHint: true
    ),
    validator: (nonce) {
      if (nonce == null || nonce == "") {
        return "Invalid Nonce.";
      }

      String? errorMsg;
      try {
        hex.decode(nonce);
      } on Exception {
        errorMsg = "Invalid nonce";
      }
      return errorMsg;
    }
  );
}
