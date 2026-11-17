
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/services/supabase_service.dart';
import 'core/router/app_router.dart';

// AUTENTICACIÓN
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

// TIPOS DE MANTENIMIENTO
import 'features/maintenance_types/presentation/providers/tipo_mantenimiento_provider.dart';
import 'features/maintenance_types/data/repositories/tipo_mantenimiento_repositorio_impl.dart';

// VEHÍCULOS
import 'features/vehicles/presentation/providers/vehiculo_provider.dart';
import 'features/vehicles/data/repositories/vehiculo_repositorio_impl.dart';

// MANTENIMIENTOS
import 'features/maintenances/presentation/providers/mantenimiento_provider.dart';
import 'features/maintenances/data/repositories/mantenimiento_repositorio_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // AUTENTICACIÓN
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            AuthRepositoryImpl(Supabase.instance.client),
          ),
        ),

        // TIPOS DE MANTENIMIENTO
        ChangeNotifierProvider(
          create: (_) => TipoMantenimientoProvider(
            TipoMantenimientoRepositorioImpl(
              Supabase.instance.client,
            ),
          ),
        ),

        // VEHÍCULOS
        ChangeNotifierProvider(
          create: (_) => VehiculoProvider(
            VehiculoRepositorioImpl(
              Supabase.instance.client,
            ),
          ),
        ),

        // MANTENIMIENTOS
        ChangeNotifierProvider(
          create: (_) => MantenimientoProvider(
            MantenimientoRepositorioImpl(
              Supabase.instance.client,
            ),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          final authProvider = context.read<AuthProvider>();
          final router = crearRouter(authProvider);

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'AutoCare',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
              ),
              useMaterial3: true,
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
