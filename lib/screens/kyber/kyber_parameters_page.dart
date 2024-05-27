import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto_toolkit/algorithms/kyber/abstractions/pke_private_key.dart';
import 'package:crypto_toolkit/algorithms/kyber/abstractions/pke_public_key.dart';
import 'package:crypto_toolkit/algorithms/kyber/kyber.dart';
import 'package:crypto_toolkit/dto/kyber_flow_details.dart';
import 'package:crypto_toolkit/widgets/fields/key_field.dart';
import 'package:crypto_toolkit/widgets/fields/nonce_field.dart';
import 'package:crypto_toolkit/widgets/fields/security_level_field.dart';
import 'package:crypto_toolkit/widgets/fields/seed_field.dart';
import 'package:crypto_toolkit/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

class KyberParametersPage extends StatefulWidget {
  const KyberParametersPage({super.key});

  @override
  State<KyberParametersPage> createState() => _KyberParametersPageState();
}

class _KyberParametersPageState extends State<KyberParametersPage> {
  final _skController = TextEditingController();
  final _pkController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  final _seedFormKey = GlobalKey<FormBuilderState>();

  final Map<String, dynamic> initValues = {
    "securityLevel": KyberSecurityLevel.level2
  };

  String? validatePrivateKey(String? sk) {
    KyberSecurityLevel securityLevel = _seedFormKey.currentState!.value["securityLevel"];
    String? errorMsg;
    try {
      PKEPrivateKey.deserialize(
          base64Decode(sk!),
          securityLevel.value
      );
    } catch (e) {
      errorMsg = "Invalid private key.";
    }
    return errorMsg;
  }

  String? validatePublicKey(String? pk) {
    KyberSecurityLevel securityLevel = _seedFormKey.currentState!.value["securityLevel"];
    String? errorMsg;
    try {
      PKEPublicKey.deserialize(
          base64Decode(pk!),
          securityLevel.value
      );
    } catch (e) {
      errorMsg = "Invalid public key.";
    }
    return errorMsg;
  }

  void generateKeys(Uint8List seed, KyberSecurityLevel securityLevel) {
    var paddedSeed = Uint8List(64);
    for (int i=0; i<seed.length; i++) {
      paddedSeed[i] = seed[i];
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
      _pkController.text = base64Encode(pk.serialize());
      _skController.text = base64Encode(sk.serialize());
    });
  }


  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TitleSection(title: "Kyber", backgroundImage: "assets/images/black-lattice-background.jpg"),
            const SizedBox(height: 16),

            FormBuilder(
              key: _formKey,
              initialValue: initValues,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                    FormBuilder(
                      key: _seedFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Security level", style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 14),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: KyberSecurityLevelFormField(name: "securityLevel")
                          ),
                          const SizedBox(height: 35),

                          Text("Server keys", style: Theme.of(context).textTheme.titleLarge),

                          const SizedBox(height: 25),

                          Text(
                              "Generate keys from a seed...",
                              style: Theme.of(context).textTheme.bodyLarge),

                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            runSpacing: 5,
                            children: [
                              SeedField.kyber(name: "seed"),
                              FilledButton(
                                  onPressed: () {
                                    if (!_seedFormKey.currentState!.saveAndValidate()) {
                                      return;
                                    }

                                    if (_seedFormKey.currentState!.value["seed"].isEmpty){
                                      _seedFormKey
                                          .currentState!
                                          .fields["seed"]
                                          ?.invalidate("Seed cannot be empty");
                                      return;
                                    }

                                    var seed = hex.decode(_seedFormKey.currentState!.value["seed"]);
                                    var securityLevel = _seedFormKey.currentState!.value["securityLevel"];
                                    generateKeys(Uint8List.fromList(seed), securityLevel);
                                  },
                                  child: const Text("Generate"),
                              )
                            ],
                          ),
                        ],
                      )
                    ),
                    const SizedBox(height: 20),

                    Text(
                        "or paste them here",
                        style: Theme.of(context).textTheme.bodyLarge),


                    Wrap(
                      spacing: 70,
                      runSpacing: 30,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        KyberKeyField.privateKey(
                          name: "privateKey",
                          controller: _skController,
                          validator: validatePrivateKey,
                          onIconPress: () {
                            Clipboard.setData(ClipboardData(text: _skController.text));
                          }
                        ),
                        KyberKeyField.publicKey(
                          name: "publicKey",
                          controller: _pkController,
                          validator: validatePublicKey,
                          onIconPress: () {
                            Clipboard.setData(ClipboardData(text: _pkController.text));
                          }
                        )
                      ]
                    ),
                    const SizedBox(height: 35),

                    Text("Nonce", style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: NonceField(name: "nonce",)
                    ),

                    const SizedBox(height: 60),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton(
                        onPressed: () {
                          if (!_seedFormKey.currentState!.saveAndValidate()){
                            return;
                          }

                          if (!_formKey.currentState!.saveAndValidate()){
                            return;
                          }

                          KyberSecurityLevel secLevel = _seedFormKey
                              .currentState!.value["securityLevel"];

                          var pkBytes = base64Decode(
                              _formKey.currentState!.value["publicKey"]
                          );
                          var pk = PKEPublicKey.deserialize(pkBytes, secLevel.value);

                          var skBytes = base64Decode(_formKey.currentState!.value["privateKey"]);
                          var sk = PKEPrivateKey.deserialize(skBytes, secLevel.value);


                          context.go(
                            "/kyber/results",
                            extra: KyberFlowDetails(
                              publicKey: pk,
                              privateKey: sk,
                              nonce: _formKey.currentState!.value["nonce"],
                              securityLevel: secLevel,
                            )
                          );
                        },
                          child: const Text("Start flow")
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}