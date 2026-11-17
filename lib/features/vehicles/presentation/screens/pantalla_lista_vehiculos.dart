
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/vehiculo.dart';
import '../providers/vehiculo_provider.dart';
import 'pantalla_registrar_vehiculo.dart';

class PantallaListaVehiculos extends StatefulWidget {
  const PantallaListaVehiculos({super.key});

  @override
  State<PantallaListaVehiculos> createState() =>
      _PantallaListaVehiculosState();
}

class _PantallaListaVehiculosState
    extends State<PantallaListaVehiculos> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehiculoProvider>().cargarVehiculos();
    });
  }

  // Abrir formulario para editar un vehículo.
  Future<void> _editarVehiculo(Vehiculo vehiculo) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaRegistrarVehiculo(
          vehiculo: vehiculo,
        ),
      ),
    );
  }

  // Confirmar antes de eliminar.
  Future<void> _confirmarEliminacion(Vehiculo vehiculo) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar vehículo'),
          content: Text(
            '¿Estás seguro de eliminar '
                '${vehiculo.marca} ${vehiculo.modelo}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
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
          .read<VehiculoProvider>()
          .eliminarVehiculo(vehiculo.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vehículo eliminado correctamente.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo eliminar el vehículo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis vehículos'),
        centerTitle: true,
      ),
      body: Consumer<VehiculoProvider>(
        builder: (context, provider, child) {
          if (provider.cargando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: provider.cargarVehiculos,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.vehiculos.isEmpty) {
            return RefreshIndicator(
              onRefresh: provider.cargarVehiculos,
              child: ListView(
                children: const [
                  SizedBox(height: 150),
                  Icon(
                    Icons.directions_car_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Todavía no tienes vehículos registrados.',
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.cargarVehiculos,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.vehiculos.length,
              itemBuilder: (context, index) {
                final vehiculo = provider.vehiculos[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const CircleAvatar(
                      child: Icon(Icons.directions_car),
                    ),
                    title: Text(
                      '${vehiculo.marca} ${vehiculo.modelo}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Año: ${vehiculo.anio}\n'
                          'Placa: ${vehiculo.placa}\n'
                          'Kilometraje: '
                          '${vehiculo.kilometraje ?? 'No registrado'} km',
                    ),
                    isThreeLine: true,
                    trailing: Wrap(
                      spacing: 0,
                      children: [
                        IconButton(
                          tooltip: 'Editar vehículo',
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            _editarVehiculo(vehiculo);
                          },
                        ),
                        IconButton(
                          tooltip: 'Eliminar vehículo',
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _confirmarEliminacion(vehiculo);
                          },
                        ),
                      ],
                    ),
                  ),
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
              const PantallaRegistrarVehiculo(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar vehículo'),
      ),
    );
  }
}
