
import 'package:flutter/material.dart';

import '../../domain/entities/tipo_mantenimiento.dart';
import '../../domain/repositories/tipo_mantenimiento_repositorio.dart';

class TipoMantenimientoProvider extends ChangeNotifier {
  final TipoMantenimientoRepositorio repositorio;

  TipoMantenimientoProvider(this.repositorio);

  List<TipoMantenimiento> _tiposMantenimiento = [];

  bool _cargando = false;

  String? _error;

  List<TipoMantenimiento> get tiposMantenimiento =>
      _tiposMantenimiento;

  bool get cargando => _cargando;

  String? get error => _error;

  Future<void> cargarTiposMantenimiento() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _tiposMantenimiento =
      await repositorio.obtenerTiposMantenimiento();
    } catch (e) {
      _error = 'Error al cargar los tipos de mantenimiento: $e';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
