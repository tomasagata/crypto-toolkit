import 'package:crypto_toolkit/widgets/step_dialog.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:post_quantum/post_quantum.dart';

class StepItem extends StatelessWidget {
  final Step step;

  const StepItem({
    super.key,
    required this.step
  });

  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading: const Icon(Icons.calculate),
      title: Text(step.title,
          style: Theme.of(context).textTheme.headlineSmall),
      subtitle: Text(step.description,
          style: Theme.of(context).textTheme.bodyLarge),
      isThreeLine: true,
      trailing: OutlinedButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => StepDialog(step: step)
        ),
        child: const Text("View Step")),
      visualDensity: VisualDensity.standard,

    );
  }

}