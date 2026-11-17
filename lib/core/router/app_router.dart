
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/home_screen.dart';

import '../../features/maintenance_types/presentation/screens/pantalla_tipos_mantenimiento.dart';

import '../../features/vehicles/presentation/screens/pantalla_lista_vehiculos.dart';
import '../../features/vehicles/presentation/screens/pantalla_registrar_vehiculo.dart';

import '../../features/maintenances/presentation/screens/pantalla_lista_mantenimientos.dart';

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
      GoRoute(
        path: '/tipos-mantenimiento',
        builder: (context, state) =>
        const PantallaTiposMantenimiento(),
      ),
      GoRoute(
        path: '/vehiculos',
        builder: (context, state) =>
        const PantallaListaVehiculos(),
      ),
      GoRoute(
        path: '/registrar-vehiculo',
        builder: (context, state) =>
        const PantallaRegistrarVehiculo(),
      ),
      GoRoute(
        path: '/mantenimientos',
        builder: (context, state) =>
        const PantallaListaMantenimientos(),
      ),
    ],
  );
}
