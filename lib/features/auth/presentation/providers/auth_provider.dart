
import 'package:flutter/foundation.dart';

import '../../domain/entities/usuario.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;

  AuthProvider(this.repository);

  Usuario? _usuario;
  bool _isLoading = false;
  String? _errorMessage;

  Usuario? get usuario => _usuario;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> registrar({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _usuario = await repository.registrar(
        email: email,
        password: password,
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> iniciarSesion({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _usuario = await repository.iniciarSesion(
        email: email,
        password: password,
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cerrarSesion() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await repository.cerrarSesion();
      _usuario = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void limpiarError() {
    _errorMessage = null;
    notifyListeners();
  }
}
