import 'package:flutter/material.dart' hide Step;
import 'package:post_quantum/post_quantum.dart';

enum _DataType {
  parameter("Parameter", Color(0xFFFFE88E), Color(0xFFFFD034)),
  result("Result", Color(0xFFBEFF8C), Color(0xFF76FF03));

  const _DataType(this.label, this.baseColor, this.selectedColor);
  final Color baseColor;
  final Color selectedColor;
  final String label;
}

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
                var type = _DataType.parameter;
                if (index >= step.parameters.length) {
                  map = step.results;
                  type = _DataType.result;
                  index = index - step.parameters.length;
                }

                MapEntry<String, Object> element = map.entries
                    .elementAt(index);
                bool isSelected = selected?.key == element.key;

                return _StepDataListItem(
                  type: type,
                  onTap: () => onSelect(element),
                  isSelected: isSelected,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2),
                          decoration: const BoxDecoration(
                            // borderRadius: BorderRadius.only(
                            //     topLeft: Radius.circular(6)),
                            border: Border(
                              right: BorderSide(color: Color(0xFF868686)),
                              bottom: BorderSide(color: Color(0xFF868686)),
                              left: BorderSide.none,
                              top: BorderSide.none
                            )
                          ),
                          child: Text(type.label,
                            style: const TextStyle(color: Color(0xFF5B5B5B))),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(element.key)),
                        )),
                    ],
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

class _StepDataListItem extends StatelessWidget {
  final bool isSelected;
  final Widget? child;
  final void Function()? onTap;
  final _DataType type;

  const _StepDataListItem({
    required this.isSelected,
    required this.type,
    this.child,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      borderRadius: const BorderRadius.all(
            Radius.circular(6)),
      onTap: onTap,
      child: Ink(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
              Radius.circular(6)),
          color: isSelected? type.selectedColor: type.baseColor
        ),
        child: child
      )
    );
  }

}