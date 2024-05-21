import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DilithiumSelectionPage extends StatelessWidget {
  const DilithiumSelectionPage({super.key});

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
                "Dilithium",
                style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 16),

            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
                "sed do eiusmod tempor incididunt ut labore et dolore magna "
                "aliqua. Ut enim ad minim veniam, quis nostrud exercitation "
                "ullamco laboris nisi ut aliquip ex ea commodo consequat. "
                "Duis aute irure dolor in reprehenderit in voluptate velit "
                "esse cillum dolore eu fugiat nulla pariatur. Excepteur sint "
                "occaecat cupidatat non proident, sunt in culpa qui officia "
                "deserunt mollit anim id est laborum. Lorem ipsum dolor sit "
                "amet, consectetur adipiscing elit, sed do eiusmod tempor "
                "incididunt ut labore et dolore magna aliqua. Ut enim ad minim "
                "veniam, quis nostrud exercitation ullamco laboris nisi ut "
                "aliquip ex ea commodo consequat.Duis aute irure dolor in "
                "reprehenderit in voluptate velit esse cillum dolore eu fugiat "
                "nulla pariatur. Excepteur sint occaecat cupidatat non proident,"
                " sunt in culpa qui officia deserunt mollit anim id est laborum. "
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed "
                "do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                "Ut enim ad minim veniam, quis nostrud exercitation ullamco "
                "laboris nisi ut aliquip ex ea commodo consequat. Duis aute "
                "irure dolor in reprehenderit in voluptate velit esse cillum "
                "dolore eu fugiat nulla pariatur. Excepteur sint occaecat "
                "cupidatat non proident, sunt in culpa qui officia deserunt "
                "mollit anim id est laborum",
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
    );
  }

}