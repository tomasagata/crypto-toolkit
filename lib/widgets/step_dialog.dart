import 'package:crypto_toolkit/widgets/step_data_list.dart';
import 'package:crypto_toolkit/widgets/step_data_visualizer.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:post_quantum/post_quantum.dart';


class StepDialog extends StatefulWidget {
  final Step step;

  const StepDialog({
    super.key,
    required this.step
  });

  @override
  State<StepDialog> createState() => _StepDialogState();
}

class _StepDialogState extends State<StepDialog> {
  MapEntry<String, Object>? selected;

  void onSelect(MapEntry<String, Object> newSelection) {
    setState(() {
      selected = (newSelection == selected) ? null : newSelection;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(5)),
      backgroundColor: const Color(0xFFEDEDED),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_outlined)),
                const SizedBox(width: 10),
                const Text("Back")
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 8,
                  top: 8
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.step.title,
                        style: Theme.of(context).textTheme.displayMedium),
                    const SizedBox(height: 4),
                    Text(widget.step.description,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Row(
                        children: [
                          StepDataList(
                            step: widget.step,
                            selected: selected,
                            onSelect: onSelect),
                          const SizedBox(width: 10),
                          Expanded(
                            child: StepDataVisualizer(
                              selected: selected)
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}