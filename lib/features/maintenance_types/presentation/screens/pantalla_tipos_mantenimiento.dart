
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tipo_mantenimiento_provider.dart';

class PantallaTiposMantenimiento extends StatefulWidget {
  const PantallaTiposMantenimiento({super.key});

  @override
  State<PantallaTiposMantenimiento> createState() =>
      _PantallaTiposMantenimientoState();
}

class _PantallaTiposMantenimientoState
    extends State<PantallaTiposMantenimiento> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<TipoMantenimientoProvider>()
          .cargarTiposMantenimiento();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de mantenimiento'),
        centerTitle: true,
      ),
      body: Consumer<TipoMantenimientoProvider>(
        builder: (context, provider, child) {
          if (provider.cargando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
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
                      onPressed: provider.cargarTiposMantenimiento,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.tiposMantenimiento.isEmpty) {
            return const Center(
              child: Text('No hay tipos de mantenimiento registrados.'),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.cargarTiposMantenimiento,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.tiposMantenimiento.length,
              itemBuilder: (context, index) {
                final tipo = provider.tiposMantenimiento[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.build),
                    ),
                    title: Text(
                      tipo.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (tipo.descripcion != null)
                          Text(tipo.descripcion!),
                        const SizedBox(height: 6),
                        Text(
                          tipo.intervaloRecomendadoKm != null
                              ? 'Intervalo recomendado: '
                              '${tipo.intervaloRecomendadoKm} km'
                              : 'Sin intervalo definido',
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
