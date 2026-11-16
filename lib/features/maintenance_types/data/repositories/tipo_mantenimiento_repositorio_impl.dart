
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/tipo_mantenimiento.dart';
import '../../domain/repositories/tipo_mantenimiento_repositorio.dart';
import '../models/tipo_mantenimiento_modelo.dart';

class TipoMantenimientoRepositorioImpl
    implements TipoMantenimientoRepositorio {
  final SupabaseClient supabase;

  TipoMantenimientoRepositorioImpl(this.supabase);

  @override
  Future<List<TipoMantenimiento>> obtenerTiposMantenimiento() async {
    final respuesta = await supabase
        .from('maintenance_types')
        .select()
        .order('name', ascending: true);

    return (respuesta as List)
        .map(
          (item) => TipoMantenimientoModelo.fromMap(
        item as Map<String, dynamic>,
      ),
    )
        .toList();
  }
}
