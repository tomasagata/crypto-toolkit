import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatelessWidget {
  const AppLayout(this.navigationShell, {super.key});

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              elevation: 1,
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: _onTap,
              selectedIndex: navigationShell.currentIndex,
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.functions),
                  label: SizedBox(
                    width: 70,
                    child: Text("Learning with Errors",
                      style: Theme.of(context).textTheme.labelSmall,
                      textAlign: TextAlign.center),
                  )),
                NavigationRailDestination(
                    icon: const Icon(Icons.key),
                    label: Text("Kyber",
                        style: Theme.of(context).textTheme.labelSmall)),
                NavigationRailDestination(
                    icon: const Icon(Icons.https),
                    label: Text("Kyber PKE",
                        style: Theme.of(context).textTheme.labelSmall)),
                NavigationRailDestination(
                    icon: const Icon(Icons.verified_user),
                    label: Text("Dilithium",
                        style: Theme.of(context).textTheme.labelSmall)),
            ]),
            Container(
              color: Colors.blueGrey,
              height: double.infinity,
              width: 0.25,
            ),
            Expanded(
                child: Container(
                    color: Colors.white70,
                    child: navigationShell
                )
            )
          ],
        ),
      ),
    );
  }

  void _onTap(index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

}
