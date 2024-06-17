import 'package:flutter/material.dart';

class ResultDialog extends StatefulWidget {
  final Widget? headerWidget;
  final String result;
  final String resultLabel;

  const ResultDialog({
    super.key,
    this.headerWidget,
    required this.result,
    required this.resultLabel
  });

  @override
  State<ResultDialog> createState() => _ResultDialogState();
}

class _ResultDialogState extends State<ResultDialog> {
  var controller = TextEditingController();


  @override
  void didUpdateWidget(ResultDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.text = widget.result;
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.result;
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      backgroundColor: const Color(0xFFEDEDED),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close)),
                      const SizedBox(width: 10),
                      const Text("Result")
                    ],
                  ),
                ),
                if (widget.headerWidget != null)
                  widget.headerWidget!
                // FilledButton(
                //     onPressed: () {
                //       Navigator.pop(context);
                //       context.push("/kyber-pke/encrypt/steps",
                //           extra: widget.steps);
                //     },
                //     child: const Text("View steps"))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 8,
                  top: 8
              ),
              child: TextField(
                controller: controller,
                autocorrect: false,
                minLines: null,
                maxLines: null,
                expands: true,
                enableSuggestions: false,
                readOnly: true,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: Text(widget.resultLabel),
                    constraints: const BoxConstraints(
                      maxHeight: 200,
                    ),
                    alignLabelWithHint: true
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}