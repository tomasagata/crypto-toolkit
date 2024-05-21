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

            Row(
              children: [
                Expanded(child: Image.asset("assets/images/lwe-pre-noise.png")),
                Expanded(child: Image.asset("assets/images/lwe-post-noise.png")),
              ],
            ),
            const SizedBox(height: 40),


            Text("  As shown above, a simple problem consists of reversing "
                "A*s to retrieve s. However, if a random noise vector e is "
                "added, then it will be much more difficult to retrieve s. "
                "While purely numerical matrices are fine for a LWE problem"
                ", we can also treat these numbers as coefficients from a "
                "polynomial. Polynomials include a variable X which won’t "
                "alter the equation so we can put anything in there and the"
                " solution will remain the same: for example, messages.",
                style: Theme.of(context).textTheme.bodyLarge),
        ]),
      ),
    );
  }

}