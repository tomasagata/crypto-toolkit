import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:go_router/go_router.dart';
import 'package:post_quantum/post_quantum.dart';
import 'package:crypto_toolkit/widgets/fields/key_field.dart';
import 'package:crypto_toolkit/widgets/fields/message_field.dart';
import 'package:crypto_toolkit/widgets/fields/nonce_field.dart';
import 'package:crypto_toolkit/widgets/fields/security_level_field.dart';
import 'package:crypto_toolkit/widgets/fields/seed_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class KyberPKEEncryptionPage extends StatefulWidget {
  const KyberPKEEncryptionPage({super.key});

  @override
  State<KyberPKEEncryptionPage> createState() => _KyberPKEEncryptionPageState();
}

class _KyberPKEEncryptionPageState extends State<KyberPKEEncryptionPage> {
  final _pkController = TextEditingController();
  final _msgController = TextEditingController();
  final _encryptedMsgController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  final _seedFormKey = GlobalKey<FormBuilderState>();
  StepObserver? observer;

  final Map<String, dynamic> initValues = {
    "securityLevel": KyberSecurityLevel.level2
  };

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

    var (pk, _) = kyberInstance.generateKeys(paddedSeed);

    setState(() {
      _pkController.text = base64Encode(pk.serialize());
    });
  }

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.topLeft,
      child: FormBuilder(
        key: _formKey,
        initialValue: initValues,
        child: ListView(
            cacheExtent: double.maxFinite,
            padding: const EdgeInsets.fromLTRB(40, 25, 40, 25),
            children: [
              Text("Kyber Encryption", style: Theme
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
                child: KyberKeyField.publicKey(
                    name: "publicKey",
                    controller: _pkController,
                    validator: validatePublicKey,
                    onIconPress: () {
                      Clipboard.setData(ClipboardData(text: _pkController.text));
                    }
                )
              ),
              const SizedBox(height: 35),

              Text("Nonce", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 14),
              Align(
                  alignment: Alignment.centerLeft,
                  child: NonceField(name: "nonce",)
              ),
              const SizedBox(height: 35),


              Text("Message", style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge),
              const SizedBox(height: 14),
              MessageField.kyber(
                name: "message",
                controller: _msgController,
                onIconPress: () {
                  Clipboard.setData(ClipboardData(text: _msgController.text));
                }
              ),

              const SizedBox(height: 60),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FilledButton(
                    onPressed: () {
                      if (!_seedFormKey.currentState!.saveAndValidate()){
                        return;
                      }

                      if (!_formKey.currentState!.saveAndValidate()){
                        return;
                      }

                      KyberSecurityLevel securityLevel = _seedFormKey
                          .currentState!.value["securityLevel"];

                      var pkBytes = base64Decode(
                          _formKey.currentState!.value["publicKey"]
                      );
                      var pk = PKEPublicKey.deserialize(pkBytes, securityLevel.value);

                      var nonce = _formKey.currentState!.value["nonce"];

                      var msg = _formKey.currentState!.value["message"];

                      KyberPKE kyberInstance;
                      if(securityLevel == KyberSecurityLevel.level2) {
                        kyberInstance = KyberPKE.pke512();
                      } else if (securityLevel == KyberSecurityLevel.level3) {
                        kyberInstance = KyberPKE.pke768();
                      } else if (securityLevel == KyberSecurityLevel.level4) {
                        kyberInstance = KyberPKE.pke1024();
                      } else {
                        observer = null;
                        throw UnimplementedError("Security level not implemented");
                      }

                      observer = StepObserver();
                      var cipher = kyberInstance.encrypt(
                          pk, msg, nonce, observer: observer!);

                      setState(() {
                        _encryptedMsgController.text = cipher.base64;
                      });
                    },
                    child: const Text("Encrypt")
                  ),
                  FilledButton(
                      onPressed: () {
                        if (observer == null) return;
                        context.go("/kyber-pke/encrypt/steps",
                          extra: observer?.steps);
                      },
                      child: const Text("View steps")
                  )
                ]
              ),
              const SizedBox(height: 80),

              Text("Result", style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge),
              const SizedBox(height: 14),
              TextField(
                controller: _encryptedMsgController,
                autocorrect: false,
                minLines: null,
                maxLines: null,
                expands: true,
                enableSuggestions: false,
                readOnly: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Encrypted message"),
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