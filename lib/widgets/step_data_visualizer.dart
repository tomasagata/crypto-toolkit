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
    } else if (selected!.value is PKEPrivateKey) {
      return PKEPrivateKeyVisualizer(
          title: selected!.key,
          data: selected!.value as PKEPrivateKey
      );
    } else if (selected!.value is PKEPublicKey) {
      return PKEPublicKeyVisualizer(
          title: selected!.key,
          data: selected!.value as PKEPublicKey
      );
    } else if (selected!.value is KemPublicKey) {
      KemPublicKey kemPublicKey = selected!.value as KemPublicKey;
      return PKEPublicKeyVisualizer(
          title: selected!.key,
          data: kemPublicKey.publicKey
      );
    } else if (selected!.value is PKECypher) {
      return PKECipherVisualizer(
          title: selected!.key,
          data: selected!.value as PKECypher
      );
    } else if (selected!.value is Uint8List) {
      return BytesVisualizer(
          title: selected!.key,
          data: selected!.value as Uint8List
      );
    } else {
      throw UnimplementedError("Visualization for object of type"
          " ${ selected!.value.runtimeType } not implemented.");
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
                Text("Polynomial Ring \"$title\"")
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(data.toString())),
                ),
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
            child: Row(
              children: [
                Text("Polynomial Matrix \"${widget.title}\"")
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
            child: Row(
              children: [
                Text("Bytes \"$title\"")
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: SingleChildScrollView(
                    child: Text("Bytes(${data.length}){${data.toString()}}")),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class PKEPublicKeyVisualizer extends StatelessWidget {
  final String title;
  final PKEPublicKey data;

  const PKEPublicKeyVisualizer({
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
            child: Row(
              children: [
                Text("Kyber PKE Public Key \"$title\"")
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: SingleChildScrollView(
                      child: Text("PKEPublicKey{${data.base64}}")),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class PKEPrivateKeyVisualizer extends StatelessWidget {
  final String title;
  final PKEPrivateKey data;

  const PKEPrivateKeyVisualizer({
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
            child: Row(
              children: [
                Text("Kyber PKE Private Key \"$title\"")
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: SingleChildScrollView(
                      child: Text("PKEPrivateKey{${data.base64}}")),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}


class PKECipherVisualizer extends StatelessWidget {
  final String title;
  final PKECypher data;

  const PKECipherVisualizer({
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
            child: Row(
              children: [
                Text("Cipher \"$title\"")
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: SingleChildScrollView(
                      child: Text("Cipher{${data.base64}}")),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}