import 'package:crypto_toolkit/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DilithiumSelectionPage extends StatelessWidget {
  const DilithiumSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleSection(
                title: "Dilithium",
                backgroundImage: "assets/images/black-lattice-background.jpg"
            ),
            const SizedBox(height: 16),


            Padding(
              padding: const EdgeInsets.fromLTRB(40, 25, 40, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dilithium is a digital signature scheme that is part of the CRYSTALS (Cryptographic Suite for Algebraic Lattices) family of algorithms. Like Kyber, it is designed to be secure against attacks by both classical and quantum computers. The security of Dilithium relies on the hardness of the Learning with Errors (LWE) problem and its variant, the Short Integer Solution (SIS) problem.",
                    style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 10),

                  Text("Overview of Dilithium",
                      style: Theme.of(context).textTheme.displaySmall),
                  Text(
                    "Dilithium involves three main operations:\n"
                      "\u2022 Key Generation: Creating a public and private key pair.\n"
                      "\u2022 Signing: Generating a digital signature for a message.\n"
                      "\u2022 Verification: Verifying the authenticity of a signed message using the public key.\n",
                    style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 78),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                        onPressed: () {
                          context.go("/dilithium/sign");
                        },
                        child: const Text("Sign")),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: () {
                          context.go("/dilithium/verify");
                        },
                        child: const Text("Verify"))
                    ],
                  )
                ]
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

}