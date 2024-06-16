import 'package:crypto_toolkit/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KyberPKESelectionPage extends StatefulWidget {
  const KyberPKESelectionPage({super.key});

  @override
  State<KyberPKESelectionPage> createState() => _KyberPKESelectionPageState();
}

class _KyberPKESelectionPageState extends State<KyberPKESelectionPage> {

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TitleSection(
                title: "Kyber Encryption",
                backgroundImage: "assets/images/black-lattice-background.jpg"
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.fromLTRB(40, 25, 40, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Kyber's internal Public Key Encryption (PKE) system is built on the hardness of the Learning with Errors (LWE) problem, specifically a variant called Module-LWE (MLWE). Here's a detailed look at how this encryption system works, leveraging the LWE problem to ensure security.",
                    style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 10),

                  Text("Key Components",
                    style: Theme.of(context).textTheme.displaySmall),
                  Text(
                    "\u2022 Key Generation: Creating a pair of public and private keys.\n"
                    "\u2022 Encryption: Encrypting a message using the public key.\n"
                    "\u2022 Decryption: Decrypting the ciphertext using the private key.\n",
                    style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 10),

                  Text("Key Generation",
                      style: Theme.of(context).textTheme.displaySmall),
                  Text(
                    "Generate Matrices and Vectors: The key generation process starts with the creation of a random matrix \"A\" and small error vectors \"s\" (secret key) and \"e\".\n"
                    "Compute Public Key: The public key \"pk\" is computed as:\n"
                    "    pk = (A, b)\n"
                    "    where b = A * s + e.\n"
                    "Here:\n"
                    "    \u2022 \"A\" is a public matrix.\n"
                    "    \u2022 \"s\" is the secret key vector.\n"
                    "    \u2022 \"e\" is a small error vector.\n"
                    "    \u2022 \"b\" is the result of the matrix multiplication of \"A\" and \"s\" with added noise \"e\".\n",
                    style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 10),

                  Text("Encryption",
                      style: Theme.of(context).textTheme.displaySmall),
                  Text(
                    "Generate Random Vector: A random vector "r" is generated.\n"
                    "Compute Ciphertext Components:\n"
                    "    The first part of the ciphertext \"u\" is calculated as:\n"
                    "        u = A * r + e1\n"
                    "    where \"e1\" is a small error vector.\n"
                    "    The second part of the ciphertext \"v\" is calculated as:\n"
                    "        v = b^T * r + e2 + m\n"
                    "    Here:\n"
                    "    \u2022 \"b^T\" is the transpose of the public key vector \"b\".\n"
                    "    \u2022 \"e2\" is another small error vector.\n"
                    "    \u2022 \"m\" is the message being encrypted.\n"
                    "Form the Ciphertext: The ciphertext \"c\" consists of the pair (u, v).\n",
                    style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 10),

                  Text("Decryption",
                      style: Theme.of(context).textTheme.displaySmall),
                  Text(
                    "Recovering the Encrypted Message:\n"
                    "    Compute the approximation of b^T * r using the private key \"s\":\n"
                    "        v' = u^T * s\n"
                    "    where \"u^T\" is the transpose of \"u\".\n"

                    "    Subtract \"v'\" from \"v\" to isolate the message:\n"
                    "        m' = v - v'\n"
                    "    Given the properties of the error vectors, the original message \"m\" can be recovered from the noisy version \"m'\" through error correction.\n",
                    style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 78),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                          onPressed: () {
                            context.go("/kyber-pke/encrypt");
                          },
                          child: const Text("Encrypt")),
                      const SizedBox(width: 12),
                      FilledButton(
                          onPressed: () {
                            context.go("/kyber-pke/decrypt");
                          },
                          child: const Text("Decrypt"))
                    ],
                  ),

                  const SizedBox(height: 80),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}