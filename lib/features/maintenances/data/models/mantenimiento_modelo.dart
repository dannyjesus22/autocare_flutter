
import '../../domain/entities/mantenimiento.dart';

class MantenimientoModelo extends Mantenimiento {
  const MantenimientoModelo({
    required super.id,
    required super.vehiculoId,
    required super.tipoMantenimientoId,
    required super.usuarioId,
    required super.fechaMantenimiento,
    required super.kilometraje,
    required super.costo,
    super.observaciones,
    required super.fechaCreacion,
  });

  factory MantenimientoModelo.fromMap(Map<String, dynamic> mapa) {
    return MantenimientoModelo(
      id: mapa['id'] as String,
      vehiculoId: mapa['vehicle_id'] as String,
      tipoMantenimientoId: mapa['maintenance_type_id'] as String,
      usuarioId: mapa['user_id'] as String,
      fechaMantenimiento:
      DateTime.parse(mapa['maintenance_date'] as String),
      kilometraje: (mapa['mileage'] as num).toInt(),
      costo: (mapa['cost'] as num).toDouble(),
      observaciones: mapa['notes'] as String?,
      fechaCreacion: DateTime.parse(mapa['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicle_id': vehiculoId,
      'maintenance_type_id': tipoMantenimientoId,
      'user_id': usuarioId,
      'maintenance_date':
      fechaMantenimiento.toIso8601String().split('T').first,
      'mileage': kilometraje,
      'cost': costo,
      'notes': observaciones,
    };
  }
}
