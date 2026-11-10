
import '../entities/usuario.dart';

abstract class AuthRepository {
  Future<Usuario> registrar({
    required String email,
    required String password,
  });

  Future<Usuario> iniciarSesion({
    required String email,
    required String password,
  });

  Future<void> cerrarSesion();
}
