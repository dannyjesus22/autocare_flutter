
import 'package:flutter/material.dart';

import '../../domain/entities/vehiculo.dart';
import '../../domain/repositories/vehiculo_repositorio.dart';

class VehiculoProvider extends ChangeNotifier {
  final VehiculoRepositorio repositorio;

  VehiculoProvider(this.repositorio);

  List<Vehiculo> _vehiculos = [];

  bool _cargando = false;

  String? _error;

  List<Vehiculo> get vehiculos => _vehiculos;

  bool get cargando => _cargando;

  String? get error => _error;

  Future<void> cargarVehiculos() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _vehiculos = await repositorio.obtenerVehiculos();
    } catch (e) {
      _error = 'Error al cargar los vehículos: $e';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> registrarVehiculo(Vehiculo vehiculo) async {
    try {
      await repositorio.registrarVehiculo(vehiculo);
      await cargarVehiculos();
    } catch (e) {
      _error = 'Error al registrar el vehículo: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> actualizarVehiculo(Vehiculo vehiculo) async {
    try {
      await repositorio.actualizarVehiculo(vehiculo);
      await cargarVehiculos();
    } catch (e) {
      _error = 'Error al actualizar el vehículo: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> eliminarVehiculo(String id) async {
    try {
      await repositorio.eliminarVehiculo(id);
      await cargarVehiculos();
    } catch (e) {
      _error = 'Error al eliminar el vehículo: $e';
      notifyListeners();
      rethrow;
    }
  }
}
