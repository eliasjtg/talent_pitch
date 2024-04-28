import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talent_pitch/app/views/home/home.dart';
import 'package:talent_pitch/app/views/home/viewer.dart';

/// App router config
final GoRouter router = GoRouter(
  routes: [
    /// Home route
    GoRoute(
      path: '/',
      name: '/',
      builder: (BuildContext context, GoRouterState state) => const HomeView(),
    ),

    /// Viewer route
    GoRoute(
      path: '/viewer',
      name: '/viewer',
      builder: (BuildContext context, GoRouterState state) =>
          const PlaylistViewer(),
    ),
  ],
);
