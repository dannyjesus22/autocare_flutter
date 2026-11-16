
import '../../domain/entities/tipo_mantenimiento.dart';

class TipoMantenimientoModelo extends TipoMantenimiento {
  const TipoMantenimientoModelo({
    required super.id,
    required super.nombre,
    super.descripcion,
    super.intervaloRecomendadoKm,
    required super.fechaCreacion,
  });

  factory TipoMantenimientoModelo.fromMap(
      Map<String, dynamic> map,
      ) {
    return TipoMantenimientoModelo(
      id: map['id'] as String,
      nombre: map['name'] as String,
      descripcion: map['description'] as String?,
      intervaloRecomendadoKm:
      map['recommended_interval_km'] as int?,
      fechaCreacion:
      DateTime.parse(map['created_at'] as String),
    );
  }
}
