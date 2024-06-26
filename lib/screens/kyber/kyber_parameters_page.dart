import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:post_quantum/post_quantum.dart';
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
      KemPrivateKey.deserialize(
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
      KemPublicKey.deserialize(
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

    var (pk, sk) = kyberInstance.generateKeys(paddedSeed);

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
                      "Kyber is a post-quantum cryptographic algorithm that relies on the Learning with Errors (LWE) problem to ensure security. It's designed to be resistant to attacks from both classical and quantum computers. Let's break down how Kyber leverages the LWE problem to provide secure communication.",
                      style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 10),

                    Text("Overview of Kyber",
                      style: Theme.of(context).textTheme.displaySmall),
                    Text(
                      "Kyber is a key encapsulation mechanism (KEM). A KEM is used to securely establish a shared secret between two parties, which can then be used for encrypted communication. The main operations in Kyber involve:\n"
                        "\u2022 Key Generation: Generating a public and private key pair.\n"
                        "\u2022 Encapsulation: Using the public key to generate a shared secret and a ciphertext.\n"
                        "\u2022 Decapsulation: Using the private key to recover the shared secret from the ciphertext.\n",
                      style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 10),

                    Text("How LWE is Applied in Kyber",
                      style: Theme.of(context).textTheme.displaySmall),
                    Text(
                      "Kyber is based on a variant of the LWE problem known as Module-LWE (MLWE). Here's a step-by-step explanation of how Kyber uses this problem:",
                      style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 5),

                    Text("1. Key Generation",
                      style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      "\u2022 Generate Matrices and Vectors: Kyber starts by generating a random matrix \"A\" and secret vectors \"s\" and \"e\". These vectors contain small random errors.\n"
                      "\u2022 Compute Public Key: The public key is computed as:\n"
                        "b = A * s + e\n"
                      "Where:\n"
                        "\u2022 \"b\" is the public key,\n"
                        "\u2022 \"A\" is a public matrix,\n"
                        "\u2022 \"s\" is the secret key,\n"
                        "\u2022 and \"e\" is the error vector.\n",
                      style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 5),

                    Text("2. Encapsulation",
                      style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      "\u2022 Generate Random Vector: A random vector \"r\" is generated.\n"
                      "\u2022 Compute Ciphertext Components:\n"
                        "    The first part of the ciphertext \"u\" is computed as:\n"
                        "         u = A * r + e1\n"
                        "    where \"e1\" is a small error vector.\n"
                        "    The second part of the ciphertext \"v\" is computed as:\n"
                        "         v = b^T * r + e2 + m\n"
                        "    Here, \"b^T\" is the transpose of the public key \"b\", \"e2\" is another small error vector, and \"m\" is the message (usually represented as a polynomial).\n"
                      "\u2022 Form the Ciphertext: The ciphertext is composed of \"u\" and \"v\".",
                      style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 10),

                    Text("3. Decapsulation",
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      "\u2022 Recovering the Shared Secret:\n"
                        "    Using the private key \"s\", compute:\n"
                        "        v' = u^T * s\n"
                        "    Here, \"u^T\" is the transpose of \"u\".\n"

                        "    Subtract \"v'\" from \"v\" to obtain:\n"
                        "        m' = v - v'\n"
                        "    Due to the small errors, \"m'\" is a noisy version of the original message \"m\", but it can be corrected to recover the original message.\n",
                      style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 10),

                    Text("Why This Works",
                        style: Theme.of(context).textTheme.displaySmall),
                    Text(
                      "The security of Kyber relies on the hardness of the MLWE problem. The errors introduced in the process ensure that an attacker cannot easily reverse the operations to recover the secret key or the shared secret. Even with a quantum computer, solving the MLWE problem is computationally infeasible with current techniques.",
                      style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 10),

                    Text("Applications of Kyber",
                        style: Theme.of(context).textTheme.displaySmall),
                    Text(
                      "Kyber is used in scenarios where secure communication is crucial, such as:\n"
                        "\u2022 Secure Messaging: Establishing a shared secret for encrypting messages between parties.\n"
                        "\u2022 Secure Key Exchange: Safely exchanging cryptographic keys over an insecure channel.\n"
                        "\u2022 Post-Quantum Security: Ensuring long-term security against potential future quantum attacks.\n",
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
                          var pk = KemPublicKey.deserialize(pkBytes, secLevel.value);

                          var skBytes = base64Decode(_formKey.currentState!.value["privateKey"]);
                          var sk = KemPrivateKey.deserialize(skBytes, secLevel.value);


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