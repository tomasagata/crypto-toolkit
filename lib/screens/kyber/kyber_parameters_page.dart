import 'package:crypto_toolkit/dto/kyber_flow_details.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KyberParametersPage extends StatefulWidget {
  const KyberParametersPage({super.key});

  @override
  State<KyberParametersPage> createState() => _KyberParametersPageState();
}

enum _KyberSecurityLevel {
  level2,
  level3,
  level4
}

enum _ServerKeysAction {
  generate,
  useExisting
}

class _KyberParametersPageState extends State<KyberParametersPage> {
  var _securityLevel = _KyberSecurityLevel.level2;
  var _keysAction = _ServerKeysAction.useExisting;

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.topLeft,
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
            child: SegmentedButton<_KyberSecurityLevel>(
              selected: <_KyberSecurityLevel>{_securityLevel},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _securityLevel = newSelection.first;
                });
              },
              segments: const [
                ButtonSegment(value: _KyberSecurityLevel.level2, label: Text("Level 2")),
                ButtonSegment(value: _KyberSecurityLevel.level3, label: Text("Level 3")),
                ButtonSegment(value: _KyberSecurityLevel.level4, label: Text("Level 4")),
            ]),
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

          _keysAction == _ServerKeysAction.useExisting ? (
            const Wrap(
              spacing: 70,
              runSpacing: 30,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                TextField(
                  autocorrect: false,
                  maxLines: 5,
                  enableSuggestions: false,
                  decoration: InputDecoration(
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
                  autocorrect: false,
                  maxLines: 5,
                  enableSuggestions: false,
                  decoration: InputDecoration(
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
          ) : (
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 5,
                  children: [
                    const TextField(
                      autocorrect: false,
                      maxLines: 1,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Seed (hexadecimal)"),
                          constraints: BoxConstraints(
                            minWidth: 0.0,
                            maxWidth: 400,
                            minHeight: 0.0,
                            maxHeight: 200,
                          ),
                          alignLabelWithHint: true
                      ),
                    ),
                    FilledButton(
                        onPressed: () {},
                        child: const Text("Generate")
                    )
                  ],
                ),

                const SizedBox(height: 20),

                const Wrap(
                    spacing: 70,
                    runSpacing: 30,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      TextField(
                        autocorrect: false,
                        maxLines: 5,
                        enableSuggestions: false,
                        decoration: InputDecoration(
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
                        autocorrect: false,
                        maxLines: 5,
                        enableSuggestions: false,
                        decoration: InputDecoration(
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

          const SizedBox(height: 60),

          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
                onPressed: () {
                  context.go(
                      "/kyber/results",
                      extra: const KyberFlowDetails(
                          cipher: "I'm a cipher!",
                          clientSharedKey: "I'm a client shared key!",
                          serverSharedKey: "I'm a server shared key!")
                  );
                },
                child: const Text("Start flow")
            ),
          ),
          const SizedBox(height: 80),
      ]),
    );
  }
}