import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:post_quantum/post_quantum.dart';
import 'package:crypto_toolkit/dto/kyber_flow_details.dart';
import 'package:crypto_toolkit/widgets/fields/security_level_field.dart';
import 'package:flutter/material.dart';

class KyberResultsPage extends StatefulWidget {
  const KyberResultsPage(this.flowDetails, {super.key});

  final KyberFlowDetails flowDetails;

  (String cipher, String clientKey, String serverKey) generateFlow(
      StepObserver observer
  ) {

    Kyber kyberInstance;
    if(flowDetails.securityLevel == KyberSecurityLevel.level2) {
      kyberInstance = Kyber.kem512();
    } else if (flowDetails.securityLevel == KyberSecurityLevel.level3) {
      kyberInstance = Kyber.kem768();
    } else if (flowDetails.securityLevel == KyberSecurityLevel.level4) {
      kyberInstance = Kyber.kem1024();
    } else {
      throw UnimplementedError("Security level not implemented");
    }

    var (pkeCipher, clientSharedSecret) = kyberInstance.encapsulate(
      flowDetails.publicKey,
      flowDetails.nonce,
      observer: observer
    );
    var serverSharedKey = kyberInstance.decapsulate(
      pkeCipher,
      flowDetails.privateKey,
      observer: observer
    );

    return (
      pkeCipher.base64,
      base64Encode(clientSharedSecret),
      base64Encode(serverSharedKey)
    );
  }

  @override
  State<KyberResultsPage> createState() => _KyberResultsPageState();
}

class _KyberResultsPageState extends State<KyberResultsPage> {
  final cipherFieldController = TextEditingController();
  final clientKeyFieldController = TextEditingController();
  final serverKeyFieldController = TextEditingController();
  StepObserver observer = StepObserver();


  @override
  void initState() {
    super.initState();

    var (cipher, clientSharedKey, serverSharedKey) = widget.generateFlow(
      observer
    );

    // Set textFields to their values
    cipherFieldController.text = cipher;
    clientKeyFieldController.text = clientSharedKey;
    serverKeyFieldController.text = serverSharedKey;
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is removed from the
    // widget tree.
    cipherFieldController.dispose();
    clientKeyFieldController.dispose();
    serverKeyFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.topLeft,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(40, 25, 40, 25),
        children: [
          Text("Kyber", style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 16),

          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(
                const Size(805, 498)
              ),
              child: const Image(
                image: AssetImage("assets/images/kyber_kem_flow.jpg"),
              ),
            ),
          ),
          const SizedBox(height: 36),

          Text("Phase 1: Encapsulation", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),


          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "In the encapsulation step, the client generates a random "
                        "number (called ‘nonce’) and encapsulates it with the public "
                        "key of the server. The result will be a preliminary shared "
                        "secret, and a cipher. This cypher will be sent to the server "
                        "to start phase 2.",
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 36),

                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        readOnly: true,
                        controller: cipherFieldController,
                        autocorrect: false,
                        enableSuggestions: false,
                        maxLines: 5,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () => print("pressed"),
                                icon: const Icon(Icons.copy)),
                            border: const OutlineInputBorder(),
                            label: const Text("Cipher"),
                            constraints: const BoxConstraints(
                              maxHeight: 200,
                              maxWidth: 800
                            ),
                            alignLabelWithHint: true
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        readOnly: true,
                        controller: clientKeyFieldController,
                        autocorrect: false,
                        enableSuggestions: false,
                        maxLines: 5,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () => print("pressed"),
                                icon: const Icon(Icons.copy)),
                            border: const OutlineInputBorder(),
                            label: const Text("Client's shared key"),
                            constraints: const BoxConstraints(
                                maxHeight: 200,
                                maxWidth: 800
                            ),
                            alignLabelWithHint: true
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 50),



          Text("Phase 2: Decapsulation", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),

          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "In the decapsulation step, the server takes the client’s "
                        "cipher and decapsulates it with its private key in order "
                        "to get back the original nonce. Once the server recovers "
                        "the nonce, it regenerates the cipher and the shared key. "
                        "If a decryption error ocurrs, an invalid shared key is used "
                        "in order to avoid timing attacks.",
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 36),

                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        readOnly: true,
                        controller: serverKeyFieldController,
                        autocorrect: false,
                        enableSuggestions: false,
                        maxLines: 5,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () => print("pressed"),
                                icon: const Icon(Icons.copy)),
                            border: const OutlineInputBorder(),
                            label: const Text("Server's shared key"),
                            constraints: const BoxConstraints(
                                maxHeight: 200,
                                maxWidth: 800
                            ),
                            alignLabelWithHint: true
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),

          Text("Phase 3: Secure communication", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                    "Both parties use this shared key to start a secure encrypted "
                    "communication with AES-256",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ]
          ),
          const SizedBox(height: 50),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackButton(
                onPressed: () {
                  context.pop();
                },
              ),

              FilledButton(
                  onPressed: () {
                    context.push("/kyber-pke/decrypt/steps",
                        extra: observer.steps);
                  },
                  child: const Text("View Steps")
              ),
            ],
          ),

          const SizedBox(height: 78)
        ]
      )
    );
  }
}