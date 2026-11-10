
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/usuario.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/usuario_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient supabase;

  AuthRepositoryImpl(this.supabase);

  @override
  Future<Usuario> registrar({
    required String email,
    required String password,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      throw Exception('No se pudo registrar el usuario.');
    }

    return UsuarioModel.fromSupabase(user);
  }

  @override
  Future<Usuario> iniciarSesion({
    required String email,
    required String password,
  }) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      throw Exception('No se pudo iniciar sesión.');
    }

    return UsuarioModel.fromSupabase(user);
  }

  @override
  Future<void> cerrarSesion() async {
    await supabase.auth.signOut();
  }
}
