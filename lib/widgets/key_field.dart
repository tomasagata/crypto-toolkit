import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto_toolkit/widgets/security_level_field.dart';
import 'package:flutter/material.dart';

import '../algorithms/kyber/kyber.dart';
import 'key_action_field.dart';

class KyberKeyField extends StatelessWidget {
  const KyberKeyField({
    super.key,
    required this.keyAction,
    required this.securityLevel
  });

  final KeyAction keyAction;
  final KyberSecurityLevel securityLevel;


  void generateKeys() {
    if (_seed == null){
      throw ArgumentError("Nonce must be non-null");
    }

    var paddedSeed = Uint8List(64);
    for (int i=0; i<_seed!.length; i++) {
      paddedSeed[i] = _seed![i];
    }

    Kyber kyberInstance;
    if(securityLevel == KyberSecurityLevel.level2) {
      kyberInstance = Kyber.kem512();
    } else if (securityLevel == KyberSecurityLevel.level3) {
      kyberInstance = Kyber.kem768();
    } else if (securityLevel == KyberSecurityLevel.level4) {
      kyberInstance = Kyber.kem1024();
    } else {
      throw UnimplementedError("Security level not implemented");
    }

    var (pk, sk, _) = kyberInstance.generateKeys(paddedSeed);

    setState(() {
      _publicKey = pk;
      _pkController.text = base64Encode(pk.serialize());
      _privateKey = sk;
      _skController.text = base64Encode(sk.serialize());
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 5,
          children: [
            SeedField(
              onChanged: (seed) {
                try {
                  var seedBytes = base64Decode(seed);

                  setState(() {
                    _seed = seedBytes;
                    _seedError = false;
                  });
                } catch (error) {
                  setState(() {
                    _seed = null;
                    _seedError = true;
                  });
                }
              },
            ),
            FilledButton(
                onPressed: generateKeys,
                child: const Text("Generate")
            )
          ],
        ),
      ],
    );
  }
}

class SeedField extends StatelessWidget {
  const SeedField({
    super.key,
    required this.onChanged,
    this.error = false
  });

  final void Function(String) onChanged;
  final bool error;

  @override
  Widget build(BuildContext context) {

    return TextField(
      autocorrect: false,
      maxLines: 1,
      enableSuggestions: false,
      onChanged: onChanged,
      decoration: InputDecoration(
          error: error? const Text("Please enter a valid seed") : null,
          border: const OutlineInputBorder(),
          label: const Text("Seed (hexadecimal)"),
          constraints: const BoxConstraints(
            minWidth: 0.0,
            maxWidth: 400,
            minHeight: 0.0,
            maxHeight: 200,
          ),
          alignLabelWithHint: true
      ),
    );
  }
}

