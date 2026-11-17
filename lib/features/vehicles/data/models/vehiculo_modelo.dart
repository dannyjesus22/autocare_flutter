
import '../../domain/entities/vehiculo.dart';

class VehiculoModelo extends Vehiculo {
  const VehiculoModelo({
    required super.id,
    required super.usuarioId,
    required super.marca,
    required super.modelo,
    required super.anio,
    required super.placa,
    super.kilometraje,
  });

  factory VehiculoModelo.fromMap(Map<String, dynamic> mapa) {
    return VehiculoModelo(
      id: mapa['id'] as String,
      usuarioId: mapa['user_id'] as String,
      marca: mapa['brand'] as String,
      modelo: mapa['model'] as String,
      anio: mapa['year'] as int,
      placa: mapa['plate'] as String,
      kilometraje: mapa['mileage'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': usuarioId,
      'brand': marca,
      'model': modelo,
      'year': anio,
      'plate': placa,
      'mileage': kilometraje,
    };
  }
}
