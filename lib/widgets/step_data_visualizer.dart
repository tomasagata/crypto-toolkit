import 'dart:typed_data';

import 'package:crypto_toolkit/widgets/fixed_size_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:post_quantum/post_quantum.dart';

class StepDataVisualizer extends StatelessWidget {
  final MapEntry<String, Object>? selected;

  const StepDataVisualizer({
    super.key,
    required this.selected
  });


  @override
  Widget build(BuildContext context) {
    if (selected == null) {
      return const EmptyVisualizer();
    } else if (selected!.value is PolynomialRing) {
      return PolynomialRingVisualizer(
          title: selected!.key,
          data: selected!.value as PolynomialRing
      );
    } else if (selected!.value is PolynomialMatrix) {
      return PolynomialMatrixVisualizer(
          title: selected!.key,
          data: selected!.value as PolynomialMatrix
      );
    } else if (selected!.value is Uint8List) {
      return BytesVisualizer(
          title: selected!.key,
          data: selected!.value as Uint8List
      );
    } else {
      throw UnimplementedError("Object type visualization not implemented");
    }
  }

}

class EmptyVisualizer extends StatelessWidget {

  const EmptyVisualizer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white
      ),
      child: const Center(
        child: Text(
          "Select one of the elements from the left to view it.")),
    );
  }
}

class PolynomialRingVisualizer extends StatelessWidget {
  final String title;
  final PolynomialRing data;
  final Widget? backButton;

  const PolynomialRingVisualizer({
    super.key,
    required this.title,
    required this.data,
    this.backButton
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(
                horizontal: 20
            ),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    topLeft: Radius.circular(5)
                ),
                color: Color(0xFFCDCDCD)
            ),
            child: Row(
              children: [
                if (backButton != null) backButton!,
                const Text("Polynomial Ring")
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: Text(data.toString())),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PolynomialMatrixVisualizer extends StatefulWidget {
  final String title;
  final PolynomialMatrix data;

  const PolynomialMatrixVisualizer({
    super.key,
    required this.title,
    required this.data
  });

  @override
  State<PolynomialMatrixVisualizer> createState() => _PolynomialMatrixVisualizerState();
}

class _PolynomialMatrixVisualizerState extends State<PolynomialMatrixVisualizer> {
  PolynomialRing? selected;

  @override
  void initState() {
    selected = null;
    super.initState();
  }


  @override
  void didUpdateWidget(PolynomialMatrixVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    selected = null;
  }

  @override
  Widget build(BuildContext context) {

    if (selected != null) {
      return PolynomialRingVisualizer(
        title: widget.title,
        data: selected!,
        backButton: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => setState(() { selected = null; })
        ),
      );
    }

    return Ink(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Ink(
            height: 40,
            padding: const EdgeInsets.symmetric(
                horizontal: 20
            ),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    topLeft: Radius.circular(5)
                ),
                color: Color(0xFFCDCDCD)
            ),
            child: const Row(
              children: [
                Text("Polynomial Matrix")
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Center(
                    child: Ink(
                      color: Colors.green,
                      child: FixedSizeGridView(
                        rows: widget.data.rows,
                        columns: widget.data.columns,
                        itemBuilder: (BuildContext context, int index) {
                          return Expanded(
                            child: InkWell(
                              child: Ink(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: const Color(0xFFCDCDCD),
                                ),
                                child: Center(
                                  child: Text("Poly ${index+1}"),
                                ),
                              ),
                              onTap: () => setState(() {
                                selected = widget.data.polynomials[index];
                              }),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}

class BytesVisualizer extends StatelessWidget {
  final String title;
  final Uint8List data;

  const BytesVisualizer({
    super.key,
    required this.title,
    required this.data
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(
              horizontal: 20
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                topLeft: Radius.circular(5)
              ),
              color: Color(0xFFCDCDCD)
            ),
            child: const Row(
              children: [
                Text("Bytes")
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(child: Text("Bytes(${data.length}){${data.toString()}}")),
              ),
            ),
          ),
        ],
      ),
    );
  }

}