
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/usuario.dart';

class UsuarioModel extends Usuario {
  const UsuarioModel({
    required super.id,
    required super.email,
  });

  factory UsuarioModel.fromSupabase(User user) {
    return UsuarioModel(
      id: user.id,
      email: user.email ?? '',
    );
  }
}
