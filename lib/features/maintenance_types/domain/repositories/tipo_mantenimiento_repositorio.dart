
import '../entities/tipo_mantenimiento.dart';

abstract class TipoMantenimientoRepositorio {
  Future<List<TipoMantenimiento>> obtenerTiposMantenimiento();
}
