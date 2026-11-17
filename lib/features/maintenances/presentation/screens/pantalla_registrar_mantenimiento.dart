
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../vehicles/domain/entities/vehiculo.dart';
import '../../../vehicles/presentation/providers/vehiculo_provider.dart';
import '../../../maintenance_types/domain/entities/tipo_mantenimiento.dart';
import '../../../maintenance_types/presentation/providers/tipo_mantenimiento_provider.dart';

import '../../domain/entities/mantenimiento.dart';
import '../providers/mantenimiento_provider.dart';

class PantallaRegistrarMantenimiento extends StatefulWidget {
  final Mantenimiento? mantenimiento;

  const PantallaRegistrarMantenimiento({
    super.key,
    this.mantenimiento,
  });

  @override
  State<PantallaRegistrarMantenimiento> createState() =>
      _PantallaRegistrarMantenimientoState();
}

class _PantallaRegistrarMantenimientoState
    extends State<PantallaRegistrarMantenimiento> {
  final _formulario = GlobalKey<FormState>();

  final _kilometrajeControlador = TextEditingController();
  final _costoControlador = TextEditingController();
  final _observacionesControlador = TextEditingController();

  String? _vehiculoSeleccionado;
  String? _tipoSeleccionado;

  late DateTime _fechaMantenimiento;

  bool _guardando = false;

  bool get _estaEditando => widget.mantenimiento != null;

  @override
  void initState() {
    super.initState();

    final mantenimiento = widget.mantenimiento;

    _fechaMantenimiento =
        mantenimiento?.fechaMantenimiento ?? DateTime.now();

    if (mantenimiento != null) {
      _vehiculoSeleccionado = mantenimiento.vehiculoId;
      _tipoSeleccionado = mantenimiento.tipoMantenimientoId;

      _kilometrajeControlador.text =
          mantenimiento.kilometraje.toString();

      _costoControlador.text =
          mantenimiento.costo.toStringAsFixed(2);

      _observacionesControlador.text =
          mantenimiento.observaciones ?? '';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehiculoProvider>().cargarVehiculos();
      context.read<TipoMantenimientoProvider>().cargarTiposMantenimiento();
    });
  }

  @override
  void dispose() {
    _kilometrajeControlador.dispose();
    _costoControlador.dispose();
    _observacionesControlador.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaMantenimiento,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (fecha != null && mounted) {
      setState(() {
        _fechaMantenimiento = fecha;
      });
    }
  }

  Future<void> _guardarMantenimiento() async {
    if (!_formulario.currentState!.validate()) {
      return;
    }

    if (_vehiculoSeleccionado == null || _tipoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecciona un vehículo y un tipo de mantenimiento.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _guardando = true;
    });

    final mantenimientoOriginal = widget.mantenimiento;

    final mantenimiento = Mantenimiento(
      id: mantenimientoOriginal?.id ?? '',
      vehiculoId: _vehiculoSeleccionado!,
      tipoMantenimientoId: _tipoSeleccionado!,
      usuarioId: mantenimientoOriginal?.usuarioId ?? '',
      fechaMantenimiento: _fechaMantenimiento,
      kilometraje: int.parse(
        _kilometrajeControlador.text.trim(),
      ),
      costo: double.parse(
        _costoControlador.text.trim(),
      ),
      observaciones:
      _observacionesControlador.text.trim().isEmpty
          ? null
          : _observacionesControlador.text.trim(),
      fechaCreacion:
      mantenimientoOriginal?.fechaCreacion ?? DateTime.now(),
    );

    try {
      final proveedor = context.read<MantenimientoProvider>();

      if (_estaEditando) {
        await proveedor.actualizarMantenimiento(mantenimiento);
      } else {
        await proveedor.registrarMantenimiento(mantenimiento);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _estaEditando
                ? 'Mantenimiento actualizado correctamente.'
                : 'Mantenimiento registrado correctamente.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo guardar el mantenimiento: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehiculoProvider = context.watch<VehiculoProvider>();
    final tipoProvider = context.watch<TipoMantenimientoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _estaEditando
              ? 'Editar mantenimiento'
              : 'Registrar mantenimiento',
        ),
        centerTitle: true,
      ),
      body: (vehiculoProvider.cargando || tipoProvider.cargando)
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : (vehiculoProvider.error != null ||
          tipoProvider.error != null)
          ? Center(
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
                vehiculoProvider.error ??
                    tipoProvider.error!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  vehiculoProvider.cargarVehiculos();
                  tipoProvider.cargarTiposMantenimiento();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      )
          : vehiculoProvider.vehiculos.isEmpty
          ? const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Primero debes registrar un vehículo.',
            textAlign: TextAlign.center,
          ),
        ),
      )
          : tipoProvider.tiposMantenimiento.isEmpty
          ? const Center(
        child: Text(
          'No hay tipos de mantenimiento disponibles.',
        ),
      )
          : _construirFormulario(
        vehiculoProvider.vehiculos,
        tipoProvider.tiposMantenimiento,
      ),
    );
  }

  Widget _construirFormulario(
      List<Vehiculo> vehiculos,
      List<TipoMantenimiento> tipos,
      ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formulario,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              _estaEditando ? Icons.edit : Icons.car_repair,
              size: 70,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              _estaEditando
                  ? 'Actualizar mantenimiento'
                  : 'Información del mantenimiento',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),

            DropdownButtonFormField<String>(
              initialValue: _vehiculoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Vehículo',
                prefixIcon: Icon(Icons.directions_car),
                border: OutlineInputBorder(),
              ),
              items: vehiculos.map((vehiculo) {
                return DropdownMenuItem(
                  value: vehiculo.id,
                  child: Text(
                    '${vehiculo.marca} ${vehiculo.modelo}',
                  ),
                );
              }).toList(),
              onChanged: (valor) {
                setState(() {
                  _vehiculoSeleccionado = valor;
                });
              },
              validator: (valor) =>
              valor == null ? 'Selecciona un vehículo' : null,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _tipoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Tipo de mantenimiento',
                prefixIcon: Icon(Icons.build),
                border: OutlineInputBorder(),
              ),
              items: tipos.map((tipo) {
                return DropdownMenuItem(
                  value: tipo.id,
                  child: Text(tipo.nombre),
                );
              }).toList(),
              onChanged: (valor) {
                setState(() {
                  _tipoSeleccionado = valor;
                });
              },
              validator: (valor) => valor == null
                  ? 'Selecciona un tipo de mantenimiento'
                  : null,
            ),
            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: _seleccionarFecha,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                'Fecha: '
                    '${_fechaMantenimiento.day.toString().padLeft(2, '0')}/'
                    '${_fechaMantenimiento.month.toString().padLeft(2, '0')}/'
                    '${_fechaMantenimiento.year}',
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _kilometrajeControlador,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Kilometraje',
                hintText: 'Ejemplo: 113000',
                prefixIcon: Icon(Icons.speed),
                border: OutlineInputBorder(),
              ),
              validator: (valor) {
                final kilometraje = int.tryParse(valor ?? '');

                if (kilometraje == null || kilometraje < 0) {
                  return 'Ingresa un kilometraje válido';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _costoControlador,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Costo',
                hintText: 'Ejemplo: 35.50',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              validator: (valor) {
                final costo = double.tryParse(valor ?? '');

                if (costo == null ||
                    !costo.isFinite ||
                    costo < 0) {
                  return 'Ingresa un costo válido';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _observacionesControlador,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Observaciones (opcional)',
                hintText: 'Detalles del mantenimiento realizado',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 28),

            ElevatedButton.icon(
              onPressed: _guardando
                  ? null
                  : _guardarMantenimiento,
              icon: _guardando
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : Icon(
                _estaEditando ? Icons.edit : Icons.save,
              ),
              label: Text(
                _guardando
                    ? 'Guardando...'
                    : _estaEditando
                    ? 'Actualizar mantenimiento'
                    : 'Guardar mantenimiento',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
