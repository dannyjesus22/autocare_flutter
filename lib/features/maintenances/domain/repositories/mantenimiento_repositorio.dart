
import '../entities/mantenimiento.dart';

abstract class MantenimientoRepositorio {
  Future<List<Mantenimiento>> obtenerMantenimientos();

  Future<void> registrarMantenimiento(
      Mantenimiento mantenimiento,
      );

  Future<void> actualizarMantenimiento(
      Mantenimiento mantenimiento,
      );

  Future<void> eliminarMantenimiento(String id);
}
