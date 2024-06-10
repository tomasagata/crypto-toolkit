import 'package:crypto_toolkit/widgets/step_item.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:post_quantum/post_quantum.dart';

class KyberStepsPage extends StatelessWidget {
  final List<Step> steps;

  const KyberStepsPage({
    super.key,
    required this.steps
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: steps.length,
            separatorBuilder: (context, index) {
              return const Divider(color: Colors.black);
            },
            itemBuilder: (context, index) {
              return StepItem(step: steps[index]);
            }
          ),
        ),
      ],
    );
  }

}