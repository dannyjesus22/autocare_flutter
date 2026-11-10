import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/home_screen.dart';

GoRouter crearRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/login',

    refreshListenable: authProvider,

    redirect: (context, state) {
      final tieneSesion =
          Supabase.instance.client.auth.currentSession != null;

      final estaEnLogin = state.matchedLocation == '/login';
      final estaEnRegistro = state.matchedLocation == '/register';

      if (!tieneSesion && !estaEnLogin && !estaEnRegistro) {
        return '/login';
      }

      if (tieneSesion && (estaEnLogin || estaEnRegistro)) {
        return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
