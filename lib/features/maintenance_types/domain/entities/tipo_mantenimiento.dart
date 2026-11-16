
class TipoMantenimiento {
  final String id;
  final String nombre;
  final String? descripcion;
  final int? intervaloRecomendadoKm;
  final DateTime fechaCreacion;

  const TipoMantenimiento({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.intervaloRecomendadoKm,
    required this.fechaCreacion,
  });
}
