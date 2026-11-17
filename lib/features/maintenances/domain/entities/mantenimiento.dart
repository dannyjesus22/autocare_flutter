
class Mantenimiento {
  final String id;
  final String vehiculoId;
  final String tipoMantenimientoId;
  final String usuarioId;
  final DateTime fechaMantenimiento;
  final int kilometraje;
  final double costo;
  final String? observaciones;
  final DateTime fechaCreacion;

  const Mantenimiento({
    required this.id,
    required this.vehiculoId,
    required this.tipoMantenimientoId,
    required this.usuarioId,
    required this.fechaMantenimiento,
    required this.kilometraje,
    required this.costo,
    this.observaciones,
    required this.fechaCreacion,
  });
}
