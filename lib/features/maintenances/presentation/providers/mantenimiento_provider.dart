
import 'package:flutter/material.dart';

import '../../domain/entities/mantenimiento.dart';
import '../../domain/repositories/mantenimiento_repositorio.dart';

class MantenimientoProvider extends ChangeNotifier {
  final MantenimientoRepositorio repositorio;

  MantenimientoProvider(this.repositorio);

  List<Mantenimiento> _mantenimientos = [];

  bool _cargando = false;

  String? _error;

  List<Mantenimiento> get mantenimientos => _mantenimientos;

  bool get cargando => _cargando;

  String? get error => _error;

  Future<void> cargarMantenimientos() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _mantenimientos = await repositorio.obtenerMantenimientos();
    } catch (e) {
      _error = 'Error al cargar los mantenimientos: $e';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> registrarMantenimiento(
      Mantenimiento mantenimiento,
      ) async {
    try {
      _error = null;

      await repositorio.registrarMantenimiento(mantenimiento);

      await cargarMantenimientos();
    } catch (e) {
      _error = 'Error al registrar el mantenimiento: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> actualizarMantenimiento(
      Mantenimiento mantenimiento,
      ) async {
    try {
      _error = null;

      await repositorio.actualizarMantenimiento(mantenimiento);

      await cargarMantenimientos();
    } catch (e) {
      _error = 'Error al actualizar el mantenimiento: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> eliminarMantenimiento(String id) async {
    try {
      _error = null;

      await repositorio.eliminarMantenimiento(id);

      await cargarMantenimientos();
    } catch (e) {
      _error = 'Error al eliminar el mantenimiento: $e';
      notifyListeners();
      rethrow;
    }
  }
}
