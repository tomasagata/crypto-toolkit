import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto_toolkit/algorithms/dilithium/abstractions/dilithium_private_key.dart';
import 'package:crypto_toolkit/algorithms/dilithium/abstractions/dilithium_public_key.dart';
import 'package:crypto_toolkit/algorithms/dilithium/dilithium.dart';
import 'package:crypto_toolkit/widgets/fields/key_field.dart';
import 'package:crypto_toolkit/widgets/fields/message_field.dart';
import 'package:crypto_toolkit/widgets/fields/security_level_field.dart';
import 'package:crypto_toolkit/widgets/fields/seed_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class DilithiumSignPage extends StatefulWidget {
  const DilithiumSignPage({super.key});

  @override
  State<DilithiumSignPage> createState() => _DilithiumSignPageState();
}

class _DilithiumSignPageState extends State<DilithiumSignPage> {
  final _skController = TextEditingController();
  final _messageController = TextEditingController();
  final _signatureController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  final _seedFormKey = GlobalKey<FormBuilderState>();

  String? validatePrivateKey(String? sk) {
    DilithiumSecurityLevel securityLevel = _seedFormKey.currentState!.value["securityLevel"];
    String? errorMsg;
    try {
      DilithiumPrivateKey.deserialize(
          base64Decode(sk!),
          securityLevel.value
      );
    } catch (e) {
      errorMsg = "Invalid private key.";
    }
    return errorMsg;
  }

  String? validatePublicKey(String? pk) {
    DilithiumSecurityLevel securityLevel = _seedFormKey.currentState!.value["securityLevel"];
    String? errorMsg;
    try {
      DilithiumPublicKey.deserialize(
          base64Decode(pk!),
          securityLevel.value
      );
    } catch (e) {
      errorMsg = "Invalid public key.";
    }
    return errorMsg;
  }

  void generateKeys(Uint8List seed, DilithiumSecurityLevel securityLevel) {
    var paddedSeed = Uint8List(32);
    for (int i=0; i<seed.length; i++) {
      paddedSeed[i] = seed[i];
    }

    Dilithium dilithiumInstance;
    if(securityLevel == DilithiumSecurityLevel.level2) {
      dilithiumInstance = Dilithium.level2();
    } else if (securityLevel == DilithiumSecurityLevel.level3) {
      dilithiumInstance = Dilithium.level3();
    } else if (securityLevel == DilithiumSecurityLevel.level5) {
      dilithiumInstance = Dilithium.level5();
    } else {
      throw UnimplementedError("Security level not implemented");
    }

    var (_, sk) = dilithiumInstance.generateKeys(paddedSeed);

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
            padding: const EdgeInsets.fromLTRB(40, 25, 40, 25),
            children: [
              Text("Dilithium Sign", style: Theme
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
                          child: DilithiumSecurityLevelFormField(name: "securityLevel")
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
                          SeedField.dilithium(name: "seed"),
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

              DilithiumKeyField.privateKey(
                  name: "privateKey",
                  controller: _skController,
                  validator: validatePrivateKey,
                  onIconPress: () {
                    Clipboard.setData(ClipboardData(text: _skController.text));
                  }
              ),


              const SizedBox(height: 35),

              Text("Message", style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge),
              const SizedBox(height: 14),
              MessageField.dilithium(
                  name: "message",
                  controller: _messageController,
                  onIconPress: () {
                    Clipboard.setData(ClipboardData(text: _messageController.text));
                  }
              ),

              const SizedBox(height: 60),

              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton(
                    child: const Text("Sign"),
                    onPressed: () {
                      if (!_seedFormKey.currentState!.saveAndValidate()){
                        return;
                      }

                      if (!_formKey.currentState!.saveAndValidate()){
                        return;
                      }

                      DilithiumSecurityLevel securityLevel = _seedFormKey
                          .currentState!.value["securityLevel"];

                      var skBytes = base64Decode(_formKey.currentState!.value["privateKey"]);
                      var sk = DilithiumPrivateKey
                          .deserialize(skBytes, securityLevel.value);

                      var message = _formKey.currentState!.value["message"];


                      Dilithium dilithiumInstance;
                      if(securityLevel == DilithiumSecurityLevel.level2) {
                        dilithiumInstance = Dilithium.level2();
                      } else if (securityLevel == DilithiumSecurityLevel.level3) {
                        dilithiumInstance = Dilithium.level3();
                      } else if (securityLevel == DilithiumSecurityLevel.level5) {
                        dilithiumInstance = Dilithium.level5();
                      } else {
                        throw UnimplementedError("Security level not implemented");
                      }

                      var signature = dilithiumInstance.sign(sk, message);

                      setState(() {
                        _signatureController.text = signature.base64;
                      });

                    }
                ),
              ),
              const SizedBox(height: 80),

              Text("Result", style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge),
              const SizedBox(height: 14),
              TextField(
                autocorrect: false,
                minLines: null,
                maxLines: null,
                expands: true,
                controller: _signatureController,
                enableSuggestions: false,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Signature"),
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