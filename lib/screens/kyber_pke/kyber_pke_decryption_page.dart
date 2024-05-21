import 'package:flutter/material.dart';

class KyberPKEDecryptionPage extends StatefulWidget {
  const KyberPKEDecryptionPage({super.key});

  @override
  State<KyberPKEDecryptionPage> createState() => _KyberPKEDecryptionPageState();
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

class _KyberPKEDecryptionPageState extends State<KyberPKEDecryptionPage> {
  var _securityLevel = _KyberSecurityLevel.level2;
  var _keysAction = _ServerKeysAction.useExisting;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ListView(
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

            Text("Security level", style: Theme
                .of(context)
                .textTheme
                .titleLarge),
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
                    ButtonSegment(value: _KyberSecurityLevel.level2,
                        label: Text("Level 2")),
                    ButtonSegment(value: _KyberSecurityLevel.level3,
                        label: Text("Level 3")),
                    ButtonSegment(value: _KyberSecurityLevel.level4,
                        label: Text("Level 4")),
                  ]),
            ),
            const SizedBox(height: 35),

            Text("Keys", style: Theme
                .of(context)
                .textTheme
                .titleLarge),
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
                      ButtonSegment(value: _ServerKeysAction.generate,
                          label: Text("Generate")),
                      ButtonSegment(value: _ServerKeysAction.useExisting,
                          label: Text("Use existing")),
                    ]),
              ),
            ),

            const SizedBox(height: 25),

            const TextField(
              autocorrect: false,
              maxLines: 5,
              enableSuggestions: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Private key (base64)"),
                  constraints: BoxConstraints(
                    maxHeight: 200,
                  ),
                  alignLabelWithHint: true
              ),
            ),


            const SizedBox(height: 35),

            Text("Encrypted message", style: Theme
                .of(context)
                .textTheme
                .titleLarge),
            const SizedBox(height: 14),
            const TextField(
              autocorrect: false,
              maxLines: 5,
              enableSuggestions: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Cipher"),
                  constraints: BoxConstraints(
                    maxHeight: 200,
                  ),
                  alignLabelWithHint: true
              ),
            ),

            const SizedBox(height: 60),

            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton(
                  onPressed: () {},
                  child: const Text("Decrypt")
              ),
            ),
            const SizedBox(height: 80),

            Text("Result", style: Theme
                .of(context)
                .textTheme
                .titleLarge),
            const SizedBox(height: 14),
            const TextField(
              autocorrect: false,
              maxLines: 5,
              enableSuggestions: false,
              decoration: InputDecoration(
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
    );
  }
}