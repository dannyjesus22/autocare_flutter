
class Vehiculo {
  final String id;
  final String usuarioId;
  final String marca;
  final String modelo;
  final int anio;
  final String placa;
  final int? kilometraje;

  const Vehiculo({
    required this.id,
    required this.usuarioId,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.placa,
    this.kilometraje,
  });
}
