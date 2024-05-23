import 'package:flutter/material.dart';

enum KeyAction {
  generate,
  useExisting
}

class KeyActionField extends StatelessWidget {
  const KeyActionField({
    super.key,
    required this.selected,
    required this.onSelectionChanged
  });

  final KeyAction selected;
  final void Function(KeyAction) onSelectionChanged;


  @override
  Widget build(BuildContext context){
    return SegmentedButton<KeyAction>(
        selected: <KeyAction>{selected},
        onSelectionChanged: (newSelection) {
          onSelectionChanged(newSelection.first);
        },
        segments: const [
          ButtonSegment(value: KeyAction.generate, label: Text("Generate")),
          ButtonSegment(value: KeyAction.useExisting, label: Text("Use existing")),
        ]
    );
  }
}