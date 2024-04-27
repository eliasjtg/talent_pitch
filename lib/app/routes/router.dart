import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talent_pitch/app/views/home/home.dart';
import 'package:talent_pitch/app/views/home/viewer.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: '/',
      builder: (BuildContext context, GoRouterState state) => const HomeView(),
    ),
    GoRoute(
      path: '/viewer',
      name: '/viewer',
      builder: (BuildContext context, GoRouterState state) =>
          const PlaylistViewer(),
    ),
  ],
);
