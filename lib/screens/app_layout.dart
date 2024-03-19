import 'package:flutter/material.dart';

import 'home_page.dart';
import 'settings_page.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const SettingsPage();
        break;
      default:
        throw UnimplementedError("No page for destination index $_selectedIndex");
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              elevation: 1,
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: (destinationIndex) {
                setState(() {
                  _selectedIndex = destinationIndex;
                });
              },
              selectedIndex: _selectedIndex,
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.home),
                  label: Text("Inicio",
                    style: Theme.of(context).textTheme.labelSmall)),
                const NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text("Configuración"))
            ]),
            Expanded(child: page)
          ],
        ),
      ),
    );
  }
}
