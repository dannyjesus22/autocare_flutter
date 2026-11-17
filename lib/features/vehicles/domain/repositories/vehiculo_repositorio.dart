
import '../entities/vehiculo.dart';

abstract class VehiculoRepositorio {
  Future<List<Vehiculo>> obtenerVehiculos();

  Future<void> registrarVehiculo(Vehiculo vehiculo);

  Future<void> actualizarVehiculo(Vehiculo vehiculo);

  Future<void> eliminarVehiculo(String id);
}
