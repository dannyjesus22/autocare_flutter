
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/vehiculo.dart';
import '../../domain/repositories/vehiculo_repositorio.dart';
import '../models/vehiculo_modelo.dart';

class VehiculoRepositorioImpl implements VehiculoRepositorio {
  final SupabaseClient supabase;

  VehiculoRepositorioImpl(this.supabase);

  @override
  Future<List<Vehiculo>> obtenerVehiculos() async {
    final usuario = supabase.auth.currentUser;

    if (usuario == null) {
      throw Exception('No hay un usuario autenticado.');
    }

    final respuesta = await supabase
        .from('vehicles')
        .select()
        .eq('user_id', usuario.id)
        .order('brand', ascending: true);

    return (respuesta as List)
        .map(
          (item) => VehiculoModelo.fromMap(
        item as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  @override
  Future<void> registrarVehiculo(Vehiculo vehiculo) async {
    final usuario = supabase.auth.currentUser;

    if (usuario == null) {
      throw Exception('No hay un usuario autenticado.');
    }

    await supabase.from('vehicles').insert({
      'user_id': usuario.id,
      'brand': vehiculo.marca,
      'model': vehiculo.modelo,
      'year': vehiculo.anio,
      'plate': vehiculo.placa,
      'mileage': vehiculo.kilometraje,
    });
  }

  @override
  Future<void> actualizarVehiculo(Vehiculo vehiculo) async {
    final usuario = supabase.auth.currentUser;

    if (usuario == null) {
      throw Exception('No hay un usuario autenticado.');
    }

    await supabase
        .from('vehicles')
        .update({
      'brand': vehiculo.marca,
      'model': vehiculo.modelo,
      'year': vehiculo.anio,
      'plate': vehiculo.placa,
      'mileage': vehiculo.kilometraje,
    })
        .eq('id', vehiculo.id)
        .eq('user_id', usuario.id);
  }

  @override
  Future<void> eliminarVehiculo(String id) async {
    final usuario = supabase.auth.currentUser;

    if (usuario == null) {
      throw Exception('No hay un usuario autenticado.');
    }

    await supabase
        .from('vehicles')
        .delete()
        .eq('id', id)
        .eq('user_id', usuario.id);
  }
}
