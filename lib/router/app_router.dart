import 'package:crypto_toolkit/dto/kyber_flow_details.dart';
import 'package:crypto_toolkit/screens/app_layout.dart';
import 'package:crypto_toolkit/screens/dilithium/dilithium_selection_page.dart';
import 'package:crypto_toolkit/screens/dilithium/dilithium_sign_page.dart';
import 'package:crypto_toolkit/screens/dilithium/dilithium_verify_page.dart';
import 'package:crypto_toolkit/screens/kyber/kyber_parameters_page.dart';
import 'package:crypto_toolkit/screens/kyber/kyber_results_page.dart';
import 'package:crypto_toolkit/screens/kyber_pke/kyber_pke_decryption_page.dart';
import 'package:crypto_toolkit/screens/kyber_pke/kyber_pke_encryption_page.dart';
import 'package:crypto_toolkit/screens/kyber_pke/kyber_pke_selection_page.dart';
import 'package:crypto_toolkit/screens/lwe/lwe_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _kyberSectionNavigatorKey = GlobalKey<NavigatorState>();
final _kyberPKESectionNavigatorKey = GlobalKey<NavigatorState>();
final _dilithiumSectionNavigatorKey = GlobalKey<NavigatorState>();

// GoRouter configuration
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/lwe',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Return the widget that implements the custom shell (e.g a BottomNavigationBar).
          // The [StatefulNavigationShell] is passed to be able to navigate to other branches in a stateful way.
          return AppLayout(navigationShell);
        },
        branches: [
          // The route branch for 1st Tab
          StatefulShellBranch(routes: <RouteBase>[
            // Add this branch routes
            // each routes with its sub routes if available e.g shope/uuid/details
            GoRoute(
              path: '/lwe',
              builder: (context, state) => const LearningWithErrorsPage(),
            ),
          ]),

          // The route branch for the 2nd Tab
          StatefulShellBranch(
            navigatorKey: _kyberSectionNavigatorKey,
            // Add this branch routes
            // each routes with its sub routes if available e.g feed/uuid/details
            routes: <RouteBase>[
              GoRoute(
                path: '/kyber',
                builder: (context, state) => const KyberParametersPage(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'results',
                    builder: (context, state) => KyberResultsPage(state.extra as KyberFlowDetails),
                  )
                ],
              ),
            ],
          ),

          // The route branch for the 2nd Tab
          StatefulShellBranch(
            navigatorKey: _kyberPKESectionNavigatorKey,
            // Add this branch routes
            // each routes with its sub routes if available e.g feed/uuid/details
            routes: <RouteBase>[
              GoRoute(
                path: '/kyber-pke',
                builder: (context, state) => const KyberPKESelectionPage(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'encrypt',
                    builder: (context, state) => const KyberPKEEncryptionPage(),
                  ),
                  GoRoute(
                    path: 'decrypt',
                    builder: (context, state) => const KyberPKEDecryptionPage(),
                  ),
                ],
              ),
            ],
          ),

          // The route branch for the 2nd Tab
          StatefulShellBranch(
            navigatorKey: _dilithiumSectionNavigatorKey,
            // Add this branch routes
            // each routes with its sub routes if available e.g feed/uuid/details
            routes: <RouteBase>[
              GoRoute(
                path: '/dilithium',
                builder: (context, state) => const DilithiumSelectionPage(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'sign',
                    builder: (context, state) => const DilithiumSignPage(),
                  ),
                  GoRoute(
                    path: 'verify',
                    builder: (context, state) => const DilithiumVerifyPage(),
                  )
                ],
              ),
            ],
          ),

        ]
    )
  ],
);