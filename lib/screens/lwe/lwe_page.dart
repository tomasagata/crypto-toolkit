import 'package:flutter/material.dart';

class LearningWithErrorsPage extends StatelessWidget {
  const LearningWithErrorsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(40, 25, 40, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Learning with Errors (LWE)",
                style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 16),

            Text(
              "Welcome, everyone! Today, we're going to dive into a fascinating concept in modern cryptography called the Learning with Errors (LWE) problem. This problem forms the backbone of many advanced cryptographic systems, including some post-quantum cryptographic algorithms.",
              style: Theme.of(context).textTheme.bodyLarge
            ),
            const SizedBox(height: 10),

            Text(
              "Basic Idea",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
                "The core idea of the Learning with Errors problem is to create a hard mathematical problem that even powerful computers, including quantum computers, find difficult to solve. This problem involves working with linear algebra over finite fields and introduces small, random errors to the calculations.",
                style: Theme.of(context).textTheme.bodyLarge
            ),
            const SizedBox(height: 10),

            Text(
              "The Setting",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              "Let's start with a simple system of linear equations. Imagine you have a secret vector \"s\" and a matrix \"A\". The goal is to find \"s\" given the equation: ",
              style: Theme.of(context).textTheme.bodyLarge
            ),

            Center(child: Image.asset("assets/images/as.png")),

            Text(
              "However, instead of being given \"b\" directly, you're given a slightly \"noisy\" version of it, which we'll call \"b'\". This noise is what makes the problem hard. So, the equation looks like this:",
              style: Theme.of(context).textTheme.bodyLarge
            ),

            Center(child: Image.asset("assets/images/ase.png")),

            Text(
              "where \"e\" is a small error vector. Your task is to recover the secret vector \"s\" from \"A\" and \"b'\".",
              style: Theme.of(context).textTheme.bodyLarge
            ),

            const SizedBox(height: 10),

            Text(
              "Why is LWE Hard?",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
                "The presence of the error vector \"e\" makes solving for \"s\" extremely difficult. Without the errors, you could use straightforward linear algebra techniques to find \"s\". However, the errors \"smudge\" the data just enough to make it infeasible to reverse the process without additional information. \n{Picture of a matrix with highlighted small errors added to its entries}",
                style: Theme.of(context).textTheme.bodyLarge
            ),
            const SizedBox(height: 10),

            Text(
              "Practical Example",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              "Let's break it down with a simple example. Assume your matrix \"A\" and vector \"s\" are small integers. Take for instance:",
              style: Theme.of(context).textTheme.bodyLarge
            ),
            Center(child: Image.asset("assets/images/lwe-pre-noise.png")),

            Text(
              "But if we add some small errors:",
              style: Theme.of(context).textTheme.bodyLarge
            ),
            Center(child: Image.asset("assets/images/lwe-post-noise.png")),

            Text(
              "Now, you are given \"A\" and \"b'\" and asked to find \"s\". The noise makes it challenging to determine the exact solution.",
              style: Theme.of(context).textTheme.bodyLarge
            ),

            const SizedBox(height: 10),

            Text(
              "Applications of LWE",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
                "LWE is not just an academic curiosity; it has real-world applications. Here are a few key areas:\n"
                  "\tPost-Quantum Cryptography: LWE is resistant to attacks by quantum computers, making it a cornerstone for future-proof cryptographic systems.\n"
                  "\tHomomorphic Encryption: LWE allows computations on encrypted data without decrypting it first. This is vital for privacy-preserving cloud computing.\n"
                  "\tSecure Multi-Party Computation: LWE helps in creating protocols where parties can jointly compute a function over their inputs while keeping those inputs private.\n",
                style: Theme.of(context).textTheme.bodyLarge
            ),
            // const SizedBox(height: 10),
            //
            // Row(
            //   children: [
            //     Expanded(child: Image.asset("assets/images/lwe-pre-noise.png")),
            //     Expanded(child: Image.asset("assets/images/lwe-post-noise.png")),
            //   ],
            // ),
            const SizedBox(height: 40),


            // Text("  As shown above, a simple problem consists of reversing "
            //     "A*s to retrieve s. However, if a random noise vector e is "
            //     "added, then it will be much more difficult to retrieve s. "
            //     "While purely numerical matrices are fine for a LWE problem"
            //     ", we can also treat these numbers as coefficients from a "
            //     "polynomial. Polynomials include a variable X which won’t "
            //     "alter the equation so we can put anything in there and the"
            //     " solution will remain the same: for example, messages.",
            //     style: Theme.of(context).textTheme.bodyLarge),
        ]),
      ),
    );
  }

}