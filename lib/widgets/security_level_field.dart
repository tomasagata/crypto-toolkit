import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

enum KyberSecurityLevel {
  level2(2),
  level3(3),
  level4(4);

  const KyberSecurityLevel(this.value);
  final int value;
}

class KyberSecurityLevelFormField extends FormBuilderField<KyberSecurityLevel> {
  KyberSecurityLevelFormField({
    super.key,
    required super.name
  }) : super (
    initialValue: KyberSecurityLevel.level2,
    builder: (FormFieldState<KyberSecurityLevel> field) {

      return SegmentedButton<KyberSecurityLevel>(
          selected: <KyberSecurityLevel>{field.value!},
          onSelectionChanged: (newSelection) {
            field.didChange(newSelection.first);
          },
          segments: const [
            ButtonSegment(value: KyberSecurityLevel.level2, label: Text("Level 2")),
            ButtonSegment(value: KyberSecurityLevel.level3, label: Text("Level 3")),
            ButtonSegment(value: KyberSecurityLevel.level4, label: Text("Level 4")),
          ]
      );
    }
  );


}

enum DilithiumSecurityLevel {
  level2(2),
  level3(3),
  level5(5);

  const DilithiumSecurityLevel(this.value);
  final int value;
}

class DilithiumSecurityLevelFormField extends FormBuilderField<DilithiumSecurityLevel> {
  DilithiumSecurityLevelFormField({
    super.key,
    required super.name
  }) : super (
    initialValue: DilithiumSecurityLevel.level2,
    builder: (FormFieldState<DilithiumSecurityLevel> state) {
      return SegmentedButton<DilithiumSecurityLevel>(
        selected: <DilithiumSecurityLevel>{state.value!},
        onSelectionChanged: (newSelection) {
          state.didChange(newSelection.first);
        },
        segments: const [
          ButtonSegment(value: DilithiumSecurityLevel.level2, label: Text("Level 2")),
          ButtonSegment(value: DilithiumSecurityLevel.level3, label: Text("Level 3")),
          ButtonSegment(value: DilithiumSecurityLevel.level5, label: Text("Level 5")),
        ]
      );
    }
  );
}