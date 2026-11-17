
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/mantenimiento.dart';
import '../../domain/repositories/mantenimiento_repositorio.dart';
import '../models/mantenimiento_modelo.dart';

class MantenimientoRepositorioImpl
    implements MantenimientoRepositorio {
  final SupabaseClient supabase;

  MantenimientoRepositorioImpl(this.supabase);

  @override
  Future<List<Mantenimiento>> obtenerMantenimientos() async {
    final usuario = supabase.auth.currentUser;

    if (usuario == null) {
      throw Exception('No hay un usuario autenticado.');
    }

    final respuesta = await supabase
        .from('maintenances')
        .select()
        .eq('user_id', usuario.id)
        .order('maintenance_date', ascending: false);

    return (respuesta as List)
        .map(
          (item) => MantenimientoModelo.fromMap(
        item as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  @override
  Future<void> registrarMantenimiento(
      Mantenimiento mantenimiento,
      ) async {
    final usuario = supabase.auth.currentUser;

    if (usuario == null) {
      throw Exception('No hay un usuario autenticado.');
    }

    final modelo = MantenimientoModelo(
      id: mantenimiento.id,
      vehiculoId: mantenimiento.vehiculoId,
      tipoMantenimientoId: mantenimiento.tipoMantenimientoId,
      usuarioId: usuario.id,
      fechaMantenimiento: mantenimiento.fechaMantenimiento,
      kilometraje: mantenimiento.kilometraje,
      costo: mantenimiento.costo,
      observaciones: mantenimiento.observaciones,
      fechaCreacion: mantenimiento.fechaCreacion,
    );

    await supabase
        .from('maintenances')
        .insert(modelo.toMap());
  }

  @override
  Future<void> actualizarMantenimiento(
      Mantenimiento mantenimiento,
      ) async {
    final usuario = supabase.auth.currentUser;

    if (usuario == null) {
      throw Exception('No hay un usuario autenticado.');
    }

    final modelo = MantenimientoModelo(
      id: mantenimiento.id,
      vehiculoId: mantenimiento.vehiculoId,
      tipoMantenimientoId: mantenimiento.tipoMantenimientoId,
      usuarioId: usuario.id,
      fechaMantenimiento: mantenimiento.fechaMantenimiento,
      kilometraje: mantenimiento.kilometraje,
      costo: mantenimiento.costo,
      observaciones: mantenimiento.observaciones,
      fechaCreacion: mantenimiento.fechaCreacion,
    );

    await supabase
        .from('maintenances')
        .update(modelo.toMap())
        .eq('id', mantenimiento.id)
        .eq('user_id', usuario.id);
  }

  @override
  Future<void> eliminarMantenimiento(String id) async {
    final usuario = supabase.auth.currentUser;

    if (usuario == null) {
      throw Exception('No hay un usuario autenticado.');
    }

    await supabase
        .from('maintenances')
        .delete()
        .eq('id', id)
        .eq('user_id', usuario.id);
  }
}
