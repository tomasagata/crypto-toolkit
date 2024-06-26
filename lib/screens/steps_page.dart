import 'package:crypto_toolkit/widgets/step_item.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:go_router/go_router.dart';
import 'package:post_quantum/post_quantum.dart';

class StepsPage extends StatelessWidget {
  final List<Step> steps;

  const StepsPage({
    super.key,
    required this.steps
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text("Steps"),
      ),
      body: Column(
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
      ),
    );
  }
}