
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../vehicles/presentation/providers/vehiculo_provider.dart';
import '../../../maintenance_types/presentation/providers/tipo_mantenimiento_provider.dart';

import '../../domain/entities/mantenimiento.dart';
import '../providers/mantenimiento_provider.dart';
import 'pantalla_registrar_mantenimiento.dart';

class PantallaListaMantenimientos extends StatefulWidget {
  const PantallaListaMantenimientos({super.key});

  @override
  State<PantallaListaMantenimientos> createState() =>
      _PantallaListaMantenimientosState();
}

class _PantallaListaMantenimientosState
    extends State<PantallaListaMantenimientos> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MantenimientoProvider>().cargarMantenimientos();
      context.read<VehiculoProvider>().cargarVehiculos();
      context.read<TipoMantenimientoProvider>().cargarTiposMantenimiento();
    });
  }

  String _obtenerNombreVehiculo(
      String vehiculoId,
      VehiculoProvider proveedor,
      ) {
    for (final vehiculo in proveedor.vehiculos) {
      if (vehiculo.id == vehiculoId) {
        return '${vehiculo.marca} ${vehiculo.modelo}';
      }
    }
    return 'Vehículo no encontrado';
  }

  String _obtenerNombreTipo(
      String tipoId,
      TipoMantenimientoProvider proveedor,
      ) {
    for (final tipo in proveedor.tiposMantenimiento) {
      if (tipo.id == tipoId) {
        return tipo.nombre;
      }
    }
    return 'Tipo no encontrado';
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }

  Future<void> _confirmarEliminacion(
      Mantenimiento mantenimiento,
      ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar mantenimiento'),
          content: const Text(
            '¿Estás seguro de eliminar este registro del historial?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    try {
      await context
          .read<MantenimientoProvider>()
          .eliminarMantenimiento(mantenimiento.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mantenimiento eliminado correctamente.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo eliminar el mantenimiento: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _construirTarjeta(
      Mantenimiento mantenimiento,
      VehiculoProvider vehiculos,
      TipoMantenimientoProvider tipos,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.build),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _obtenerNombreTipo(
                      mantenimiento.tipoMantenimientoId,
                      tipos,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Eliminar mantenimiento',
                  onPressed: () {
                    _confirmarEliminacion(mantenimiento);
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(
              'Vehículo: ${_obtenerNombreVehiculo(mantenimiento.vehiculoId, vehiculos)}',
            ),
            const SizedBox(height: 6),
            Text(
              'Fecha: ${_formatearFecha(mantenimiento.fechaMantenimiento)}',
            ),
            const SizedBox(height: 6),
            Text(
              'Kilometraje: ${mantenimiento.kilometraje} km',
            ),
            const SizedBox(height: 6),
            Text(
              'Costo: \$${mantenimiento.costo.toStringAsFixed(2)}',
            ),
            if (mantenimiento.observaciones != null &&
                mantenimiento.observaciones!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text('Observaciones: ${mantenimiento.observaciones}'),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehiculos = context.watch<VehiculoProvider>();
    final tipos = context.watch<TipoMantenimientoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de mantenimientos'),
        centerTitle: true,
      ),
      body: Consumer<MantenimientoProvider>(
        builder: (context, proveedor, child) {
          if (proveedor.cargando ||
              vehiculos.cargando ||
              tipos.cargando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (proveedor.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      proveedor.error!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        proveedor.cargarMantenimientos();
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (proveedor.mantenimientos.isEmpty) {
            return RefreshIndicator(
              onRefresh: proveedor.cargarMantenimientos,
              child: ListView(
                children: const [
                  SizedBox(height: 140),
                  Icon(
                    Icons.history,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Todavía no tienes mantenimientos registrados.',
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: proveedor.cargarMantenimientos,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: proveedor.mantenimientos.length,
              itemBuilder: (context, index) {
                final mantenimiento =
                proveedor.mantenimientos[index];

                return _construirTarjeta(
                  mantenimiento,
                  vehiculos,
                  tipos,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
              const PantallaRegistrarMantenimiento(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Registrar mantenimiento'),
      ),
    );
  }
}
