import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:post_quantum/post_quantum.dart';
import 'package:crypto_toolkit/widgets/fields/cipher_field.dart';
import 'package:crypto_toolkit/widgets/fields/key_field.dart';
import 'package:crypto_toolkit/widgets/fields/security_level_field.dart';
import 'package:crypto_toolkit/widgets/fields/seed_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class KyberPKEDecryptionPage extends StatefulWidget {
  const KyberPKEDecryptionPage({super.key});

  @override
  State<KyberPKEDecryptionPage> createState() => _KyberPKEDecryptionPageState();
}

class _KyberPKEDecryptionPageState extends State<KyberPKEDecryptionPage> {
  final _skController = TextEditingController();
  final _msgController = TextEditingController();
  final _encryptedMsgController = TextEditingController();
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

  void generateKeys(Uint8List seed, KyberSecurityLevel securityLevel) {
    var paddedSeed = Uint8List(32);
    for (int i=0; i<seed.length; i++) {
      paddedSeed[i] = seed[i];
    }

    KyberPKE kyberInstance;
    if(securityLevel == KyberSecurityLevel.level2) {
      kyberInstance = KyberPKE.pke512();
    } else if (securityLevel == KyberSecurityLevel.level3) {
      kyberInstance = KyberPKE.pke768();
    } else if (securityLevel == KyberSecurityLevel.level4) {
      kyberInstance = KyberPKE.pke1024();
    } else {
      throw UnimplementedError("Security level not implemented");
    }

    var (_, sk) = kyberInstance.generateKeys(paddedSeed);

    setState(() {
      _skController.text = base64Encode(sk.serialize());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: FormBuilder(
        key: _formKey,
        child: ListView(
            cacheExtent: double.maxFinite,
            padding: const EdgeInsets.fromLTRB(40, 25, 40, 25),
            children: [
              Text("Kyber Decryption", style: Theme
                  .of(context)
                  .textTheme
                  .displayLarge),
              const SizedBox(height: 16),

              Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
                      "sed do eiusmod tempor incididunt ut labore et dolore magna"
                      " aliqua. Ut enim ad minim veniam, quis nostrud exercitation "
                      "ullamco laboris nisi ut aliquip ex ea commodo consequat. "
                      "Duis aute irure dolor in reprehenderit in voluptate velit "
                      "esse cillum dolore eu fugiat nulla pariatur. Excepteur sint "
                      "occaecat cupidatat non proident, sunt in culpa qui officia "
                      "deserunt mollit anim id est laborum. Lorem ipsum dolor sit "
                      "amet, consectetur adipiscing elit, sed do eiusmod tempor "
                      "incididunt ut labore et dolore magna aliqua. Ut enim ad minim"
                      " veniam, quis nostrud exercitation ullamco laboris nisi ut "
                      "aliquip ex ea commodo consequat.Duis aute irure dolor in "
                      "reprehenderit in voluptate velit esse cillum dolore eu "
                      "fugiat nulla pariatur. Excepteur sint occaecat cupidatat "
                      "non proident, sunt in culpa qui officia deserunt mollit anim"
                      " id est laborum. Lorem ipsum dolor sit amet, consectetur "
                      "adipiscing elit, sed do eiusmod tempor incididunt ut labore"
                      " et dolore magna aliqua. Ut enim ad minim veniam, quis nostr"
                      "ud exercitation ullamco laboris nisi ut aliquip ex ea commod"
                      "o consequat. Duis aute irure dolor in reprehenderit in volup"
                      "tate velit esse cillum dolore eu fugiat nulla pariatur. "
                      "Excepteur sint occaecat cupidatat non proident, sunt in "
                      "culpa qui officia deserunt mollit anim id est laborum",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge),
              const SizedBox(height: 78),

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

              const SizedBox(height: 25),

              Align(
                  alignment: Alignment.topLeft,
                  child: KyberKeyField.privateKey(
                      name: "privateKey",
                      controller: _skController,
                      validator: validatePrivateKey,
                      onIconPress: () {
                        Clipboard.setData(ClipboardData(text: _skController.text));
                      }
                  )
              ),


              const SizedBox(height: 35),

              Text("Encrypted message", style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge),

              const SizedBox(height: 14),
              CipherField(
                name: "encryptedMsg",
                controller: _encryptedMsgController,
                onIconPress: () {
                  Clipboard.setData(ClipboardData(text: _encryptedMsgController.text));
                }
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

                      KyberSecurityLevel securityLevel = _seedFormKey
                          .currentState!.value["securityLevel"];

                      var skBytes = base64Decode(
                          _formKey.currentState!.value["privateKey"]
                      );
                      var sk = PKEPrivateKey.deserialize(skBytes, securityLevel.value);

                      PKECypher encryptedMsg;
                      try {
                        var encryptedMsgBytes = base64Decode(
                            _formKey.currentState!.value["encryptedMsg"]
                        );
                        encryptedMsg = PKECypher.deserialize(encryptedMsgBytes, securityLevel.value);
                      } catch (err) {
                        print(err);
                        _formKey
                            .currentState!
                            .fields["encryptedMsg"]
                            ?.invalidate("Please enter a valid encrypted message.");
                        return;
                      }

                      KyberPKE kyberInstance;
                      if(securityLevel == KyberSecurityLevel.level2) {
                        kyberInstance = KyberPKE.pke512();
                      } else if (securityLevel == KyberSecurityLevel.level3) {
                        kyberInstance = KyberPKE.pke768();
                      } else if (securityLevel == KyberSecurityLevel.level4) {
                        kyberInstance = KyberPKE.pke1024();
                      } else {
                        throw UnimplementedError("Security level not implemented");
                      }

                      var originalMsg = kyberInstance.decrypt(sk, encryptedMsg);

                      setState(() {
                        _msgController.text = hex.encode(originalMsg);
                      });
                    },
                    child: const Text("Decrypt")
                ),
              ),
              const SizedBox(height: 80),

              Text("Result", style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge),
              const SizedBox(height: 14),
              TextField(
                controller: _msgController,
                autocorrect: false,
                maxLines: 5,
                enableSuggestions: false,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Original message"),
                    constraints: BoxConstraints(
                      maxHeight: 200,
                    ),
                    alignLabelWithHint: true
                ),
              ),
              const SizedBox(height: 80),

            ]),
      ),
    );
  }
}