import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

enum KeyAction {
  generate,
  useExisting
}

class KeyActionField extends FormBuilderField<KeyAction> {
  KeyActionField({
    super.key,
    required super.name,
    super.autovalidateMode,
    super.enabled,
    super.validator,
    super.restorationId,
    super.valueTransformer,
    super.onChanged,
    super.onReset,
    super.focusNode,
  }) : super (
    initialValue: KeyAction.generate,
    builder: (FormFieldState<KeyAction> state) {

      return SegmentedButton<KeyAction>(
          selected: <KeyAction>{state.value!},
          onSelectionChanged: (newSelection) {
            state.didChange(newSelection.first);
          },
          segments: const [
            ButtonSegment(value: KeyAction.generate, label: Text("Generate")),
            ButtonSegment(value: KeyAction.useExisting, label: Text("Use existing")),
          ]
      );
    }
  );
}