import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto_toolkit/algorithms/kyber/abstractions/pke_private_key.dart';
import 'package:crypto_toolkit/algorithms/kyber/abstractions/pke_public_key.dart';
import 'package:crypto_toolkit/algorithms/kyber/kyber.dart';
import 'package:crypto_toolkit/dto/kyber_flow_details.dart';
import 'package:crypto_toolkit/widgets/key_action_field.dart';
import 'package:crypto_toolkit/widgets/security_level_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

class KyberParametersPage extends StatefulWidget {
  const KyberParametersPage({super.key});

  @override
  State<KyberParametersPage> createState() => _KyberParametersPageState();
}

enum _KyberSecurityLevel {
  level2(2),
  level3(3),
  level4(4);

  const _KyberSecurityLevel(this.value);
  final int value;
}

enum _ServerKeysAction {
  generate,
  useExisting
}

class _KyberParametersPageState extends State<KyberParametersPage> {
  var _securityLevel = _KyberSecurityLevel.level2;
  var _keysAction = _ServerKeysAction.useExisting;
  Uint8List? _nonce;
  Uint8List? _seed;
  PKEPrivateKey? _privateKey;
  PKEPublicKey? _publicKey;
  var _nonceError = false;
  var _seedError = false;
  var _skError = false;
  var _pkError = false;
  final _skController = TextEditingController();
  final _pkController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  void generateKeys() {
    if (_seed == null){
      throw ArgumentError("Nonce must be non-null");
    }

    var paddedSeed = Uint8List(64);
    for (int i=0; i<_seed!.length; i++) {
      paddedSeed[i] = _seed![i];
    }

    Kyber kyberInstance;
    if(_formKey.currentState == _KyberSecurityLevel.level2) {
      kyberInstance = Kyber.kem512();
    } else if (_securityLevel == _KyberSecurityLevel.level3) {
      kyberInstance = Kyber.kem768();
    } else if (_securityLevel == _KyberSecurityLevel.level4) {
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

  KyberFlowDetails generateFlow() {
    if (_nonce == null || _privateKey == null || _publicKey == null) {
      throw ArgumentError("nonce, private key and public key must be non-null");
    }

    Kyber kyberInstance;
    if(_securityLevel == _KyberSecurityLevel.level2) {
      kyberInstance = Kyber.kem512();
    } else if (_securityLevel == _KyberSecurityLevel.level3) {
      kyberInstance = Kyber.kem768();
    } else if (_securityLevel == _KyberSecurityLevel.level4) {
      kyberInstance = Kyber.kem1024();
    } else {
      throw UnimplementedError("Security level not implemented");
    }

    var (pkeCipher, clientSharedSecret) = kyberInstance.encapsulate(_publicKey!, _nonce!);
    var serverSharedKey = kyberInstance.decapsulate(_publicKey!, _privateKey!, pkeCipher, _nonce!);

    return KyberFlowDetails(
        cipher: base64Encode(pkeCipher.serialize()),
        clientSharedKey: base64Encode(clientSharedSecret),
        serverSharedKey: base64Encode(serverSharedKey)
    );
  }


  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.topLeft,
      child: FormBuilder(
        key: _formKey,
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
            children: [
            Text("Kyber", style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 16),

            Text(
                "Kyber is a quantum-resistant key encapsulation mechanism or KEM. "
                "It uses the learning with errors problem as a mathematical "
                "basis to provide its cryptographic strength. A KEM is a "
                "mechanism that allows two parties to safely obtain a shared "
                "secret over a possibly unsafe medium.",
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 78),

            Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth:  805,
                  maxHeight: 498,
                ),
                color: Colors.red,
                child: const Image(
                  image: AssetImage("assets/images/kyber_kem_flow.jpg"),
                ),
              ),
            ),
            const SizedBox(height: 75),

            Text("Security level", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: KyberSecurityLevelFormField(name: "kyberSecurityLevel")
            ),
            const SizedBox(height: 35),

            Text("Server keys", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints.tightFor(width: 310),
                child: SegmentedButton<_ServerKeysAction>(
                  selected: <_ServerKeysAction>{_keysAction},
                  onSelectionChanged: (newSelection) {
                    setState(() {
                      _keysAction = newSelection.first;
                    });
                  },
                  segments: const [
                    ButtonSegment(value: _ServerKeysAction.generate, label: Text("Generate")),
                    ButtonSegment(value: _ServerKeysAction.useExisting, label: Text("Use existing")),
                ]),
              ),
            ),

            const SizedBox(height: 25),

            _formKey.currentState!.value["keysAction"] == KeyAction.useExisting ? (
              Wrap(
                spacing: 70,
                runSpacing: 30,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  TextField(
                    autocorrect: false,
                    maxLines: 5,
                    enableSuggestions: false,
                    onChanged: (skString) {
                      try {
                        Uint8List skBytes = base64.decode(skString);
                        PKEPrivateKey sk = PKEPrivateKey.deserialize(
                            skBytes, 256, _securityLevel.value, 3329);
                        setState(() {
                          _privateKey = sk;
                          _skError = false;
                        });
                      } catch (error) {
                        setState(() {
                          _privateKey = null;
                          _skError = true;
                        });
                      }
                    },
                    decoration: InputDecoration(
                        error: _skError ? const Text("Error reading private key") : null,
                        border: const OutlineInputBorder(),
                        label: const Text("Private key"),
                        constraints: const BoxConstraints(
                          minWidth: 0.0,
                          maxWidth: 400,
                          minHeight: 0.0,
                          maxHeight: 200,
                        ),
                        alignLabelWithHint: true
                    ),
                  ),
                  TextField(
                    autocorrect: false,
                    maxLines: 5,
                    enableSuggestions: false,
                    onChanged: (pkString) {
                      try {
                        Uint8List pkBytes = base64.decode(pkString);
                        PKEPublicKey pk = PKEPublicKey.deserialize(
                            pkBytes, 256, _securityLevel.value, 3329);
                        setState(() {
                          _publicKey = pk;
                          _pkError = false;
                        });
                      } catch (error) {
                        setState(() {
                          _publicKey = null;
                          _pkError = true;
                        });
                      }
                    },
                    decoration: InputDecoration(
                        errorText: _pkError ? "Error reading public key" : null,
                        border: const OutlineInputBorder(),
                        label: const Text("Public key"),
                        constraints: const BoxConstraints(
                          minWidth: 0.0,
                          maxWidth: 400,
                          minHeight: 0.0,
                          maxHeight: 200,
                        ),
                        alignLabelWithHint: true
                    ),
                  ),
                ]
              )
            ) : (
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 5,
                    children: [
                      TextField(
                        autocorrect: false,
                        maxLines: 1,
                        enableSuggestions: false,
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
                        decoration: InputDecoration(
                            error: _seedError? Text("Please enter a valid seed") : null,
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
                      ),
                      FilledButton(
                          onPressed: generateKeys,
                          child: const Text("Generate")
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  Wrap(
                      spacing: 70,
                      runSpacing: 30,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        TextField(
                          controller: _skController,
                          autocorrect: false,
                          maxLines: 5,
                          enableSuggestions: false,
                          readOnly: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Private key"),
                              constraints: BoxConstraints(
                                minWidth: 0.0,
                                maxWidth: 400,
                                minHeight: 0.0,
                                maxHeight: 200,
                              ),
                              alignLabelWithHint: true
                          ),
                        ),
                        TextField(
                          controller: _pkController,
                          autocorrect: false,
                          maxLines: 5,
                          enableSuggestions: false,
                          readOnly: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Public key"),
                              constraints: BoxConstraints(
                                minWidth: 0.0,
                                maxWidth: 400,
                                minHeight: 0.0,
                                maxHeight: 200,
                              ),
                              alignLabelWithHint: true
                          ),
                        ),
                      ]
                    )
                  ],
                )
              ),
              const SizedBox(height: 35),

              Text("Nonce", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerLeft,
                child: TextField(
                  autocorrect: false,
                  maxLines: 1,
                  enableSuggestions: false,
                  onChanged: (nonce) {
                    print(nonce);
                    try {
                      Uint8List nonceBytes = base64Decode(nonce);
                      print(utf8.decode(nonceBytes));
                      setState(() {
                        _nonce = nonceBytes;
                        _nonceError = false;
                      });
                    } catch (error) {
                      print(error);
                      setState(() {
                        _nonce = null;
                        _nonceError = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                      error: _nonceError ? Text("Nonce must be in base64") : null,
                      border: const OutlineInputBorder(),
                      label: const Text("nonce (hexadecimal)"),
                      constraints: const BoxConstraints(
                        minWidth: 0.0,
                        maxWidth: 400,
                        minHeight: 0.0,
                        maxHeight: 200,
                      ),
                      alignLabelWithHint: true
                  ),
                ),
              ),

            const SizedBox(height: 60),

            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton(
                  onPressed: () {
                    var flow = generateFlow();

                    context.go(
                        "/kyber/results",
                        extra: flow
                    );
                  },
                  child: const Text("Start flow")
              ),
            ),
            const SizedBox(height: 80),
        ]),
      ),
    );
  }
}