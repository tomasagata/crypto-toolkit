import 'package:flutter/material.dart' hide Step;
import 'package:post_quantum/post_quantum.dart';

class StepDataList extends StatelessWidget {
  final Step step;
  final MapEntry<String, Object>? selected;
  final void Function(MapEntry<String, Object>) onSelect;
  
  const StepDataList({
    super.key,
    required this.step,
    required this.selected,
    required this.onSelect
  });
  
  
  @override
  Widget build(BuildContext context) {
    
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 203),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: step.parameters.length + step.results.length,
              separatorBuilder: (context, index) => const SizedBox(
                  height: 4),
              itemBuilder: (context, index) {
                Map<String, Object> map = step.parameters;
                String label = "Parameter";
                if (index >= step.parameters.length) {
                  map = step.results;
                  label = "Result";
                  index = index - step.parameters.length;
                }

                MapEntry<String, Object> element = map.entries
                    .elementAt(index);
                bool isSelected = selected?.key == element.key;

                return GestureDetector(
                  onTap: () => onSelect(element),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                          Radius.circular(6)),
                      color: isSelected? Colors.lightGreenAccent: Colors.white
                    ),
                    child: Column(
                      children: [
                        Text(label),
                        Text(element.key),
                      ],
                    )
                  )
                );
              }
            ),
          ),
        ],
      ),
    );
  }
  
}