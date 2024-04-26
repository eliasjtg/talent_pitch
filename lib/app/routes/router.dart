import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talent_pitch/app/views/home/home.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const HomeView(),
    ),
  ],
);
