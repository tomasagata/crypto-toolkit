import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
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
      child: const Center(child: Text("Null")),
    );
  }
}

class PolynomialRingVisualizer extends StatelessWidget {
  final String title;
  final PolynomialRing data;

  const PolynomialRingVisualizer({
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
      child: const Center(child: Text("PolynomialRing")),
    );
  }
}

class PolynomialMatrixVisualizer extends StatelessWidget {
  final String title;
  final PolynomialMatrix data;

  const PolynomialMatrixVisualizer({
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
      child: const Center(child: Text("PolynomialMatrix")),
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
      child: const Center(
          child: Text("Bytes")),
    );
  }

}