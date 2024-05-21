import 'package:flutter/material.dart';

class KeyFieldSwitch extends StatefulWidget {
  const KeyFieldSwitch({
    super.key,
    required this.selected,
    this.onSelectionChanged
  });

  final KeyFieldAction selected;
  final void Function(KeyFieldAction)? onSelectionChanged;

  @override
  State<KeyFieldSwitch> createState() => _KeyFieldSwitchState();
}

enum KeyFieldAction {
  generate,
  useExisting
}

class _KeyFieldSwitchState extends State<KeyFieldSwitch> {


  @override
  Widget build(BuildContext context) {

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 310),
      child: SegmentedButton<KeyFieldAction>(
          selected: <KeyFieldAction>{widget.selected},
          onSelectionChanged: (newSelection) {
            if (widget.onSelectionChanged != null) {
              widget.onSelectionChanged!(newSelection.first);
            }
          },
          segments: const [
            ButtonSegment(value: KeyFieldAction.generate, label: Text("Generate")),
            ButtonSegment(value: KeyFieldAction.useExisting, label: Text("Use existing")),
          ]),
    );
  }
}

class KeyFieldInput extends StatelessWidget {
  const KeyFieldInput({super.key, required this.action});

  final KeyFieldAction action;

  @override
  Widget build(BuildContext context) {

    if (action == KeyFieldAction.generate) {
      return buildKeyGenerationField(context);
    } else if (action == KeyFieldAction.useExisting) {
      return buildExistingKeysField(context);
    } else {
      throw UnimplementedError();
    }
  }

  Widget buildKeyGenerationField(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            const TextField(
              autocorrect: false,
              maxLines: 1,
              enableSuggestions: false,
              decoration: InputDecoration(
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
            ),
            // FilledButton(
            //     onPressed: onPressed,
            //     child: const Text("Generate")
            // )
          ],
        ),

        const Wrap(
          spacing: 70,
          runSpacing: 30,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            TextField(
              autocorrect: false,
              maxLines: 5,
              enableSuggestions: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Private key"),
                  constraints: BoxConstraints(
                    minWidth: 0.0,
                    maxWidth: 400,
                    minHeight: 0.0,
                    maxHeight: 200,
                  ),
                  alignLabelWithHint: true
              ),
            ),
            TextField(
              autocorrect: false,
              maxLines: 5,
              enableSuggestions: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Public key"),
                  constraints: BoxConstraints(
                    minWidth: 0.0,
                    maxWidth: 400,
                    minHeight: 0.0,
                    maxHeight: 200,
                  ),
                  alignLabelWithHint: true
              ),
            ),
          ]
        )
      ],
    );
  }

  Widget buildExistingKeysField(BuildContext context) {

    return const Wrap(
      spacing: 70,
      runSpacing: 30,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        TextField(
          autocorrect: false,
          maxLines: 5,
          enableSuggestions: false,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Private key"),
              constraints: BoxConstraints(
                minWidth: 0.0,
                maxWidth: 400,
                minHeight: 0.0,
                maxHeight: 200,
              ),
              alignLabelWithHint: true
          ),
        ),
        TextField(
          autocorrect: false,
          maxLines: 5,
          enableSuggestions: false,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Public key"),
              constraints: BoxConstraints(
                minWidth: 0.0,
                maxWidth: 400,
                minHeight: 0.0,
                maxHeight: 200,
              ),
              alignLabelWithHint: true
          ),
        ),
      ]
    );
  }

}


