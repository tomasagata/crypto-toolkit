import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class MessageField extends FormBuilderTextField {

  MessageField.dilithium({
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
      valueTransformer: (String? message) {
        var actualMsg = hex.decode(message!);
        return actualMsg;
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        label: Text("Message"),
        constraints: BoxConstraints(
          minWidth: 0.0,
          maxWidth: 400,
          minHeight: 0.0,
          maxHeight: 200,
        ),
        alignLabelWithHint: true,
      )
  );

  MessageField.kyber({
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
      maxLength: 32,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      valueTransformer: (String? message) {
        var paddedMsg = Uint8List(32);
        var actualMsg = hex.decode(message!);
        for (int i=0; i<actualMsg.length && i<32; i++) {
          paddedMsg[i] = actualMsg[i];
        }
        return paddedMsg;
      },
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text("Message"),
          constraints: BoxConstraints(
            minWidth: 0.0,
            maxWidth: 400,
            minHeight: 0.0,
            maxHeight: 200,
          ),
          alignLabelWithHint: true,
      )
  );

}