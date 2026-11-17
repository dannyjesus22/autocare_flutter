
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/vehiculo.dart';
import '../providers/vehiculo_provider.dart';

class PantallaRegistrarVehiculo extends StatefulWidget {
  final Vehiculo? vehiculo;

  const PantallaRegistrarVehiculo({
    super.key,
    this.vehiculo,
  });

  @override
  State<PantallaRegistrarVehiculo> createState() =>
      _PantallaRegistrarVehiculoState();
}

class _PantallaRegistrarVehiculoState
    extends State<PantallaRegistrarVehiculo> {
  final _formulario = GlobalKey<FormState>();

  final _marcaControlador = TextEditingController();
  final _modeloControlador = TextEditingController();
  final _anioControlador = TextEditingController();
  final _placaControlador = TextEditingController();
  final _kilometrajeControlador = TextEditingController();

  bool _guardando = false;

  bool get _estaEditando => widget.vehiculo != null;

  @override
  void initState() {
    super.initState();

    final vehiculo = widget.vehiculo;

    if (vehiculo != null) {
      _marcaControlador.text = vehiculo.marca;
      _modeloControlador.text = vehiculo.modelo;
      _anioControlador.text = vehiculo.anio.toString();
      _placaControlador.text = vehiculo.placa;
      _kilometrajeControlador.text =
          vehiculo.kilometraje?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _marcaControlador.dispose();
    _modeloControlador.dispose();
    _anioControlador.dispose();
    _placaControlador.dispose();
    _kilometrajeControlador.dispose();
    super.dispose();
  }

  Future<void> _guardarVehiculo() async {
    if (!_formulario.currentState!.validate()) {
      return;
    }

    setState(() {
      _guardando = true;
    });

    final vehiculoOriginal = widget.vehiculo;

    final vehiculo = Vehiculo(
      id: vehiculoOriginal?.id ?? '',
      usuarioId: vehiculoOriginal?.usuarioId ?? '',
      marca: _marcaControlador.text.trim(),
      modelo: _modeloControlador.text.trim(),
      anio: int.parse(_anioControlador.text.trim()),
      placa: _placaControlador.text.trim().toUpperCase(),
      kilometraje: _kilometrajeControlador.text.trim().isEmpty
          ? null
          : int.parse(_kilometrajeControlador.text.trim()),
    );

    try {
      final proveedor = context.read<VehiculoProvider>();

      if (_estaEditando) {
        await proveedor.actualizarVehiculo(vehiculo);
      } else {
        await proveedor.registrarVehiculo(vehiculo);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _estaEditando
                ? 'Vehículo actualizado correctamente.'
                : 'Vehículo registrado correctamente.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar el vehículo: $e'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _estaEditando ? 'Editar vehículo' : 'Registrar vehículo',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formulario,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                _estaEditando
                    ? Icons.edit
                    : Icons.directions_car,
                size: 75,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              Text(
                _estaEditando
                    ? 'Actualizar información'
                    : 'Información del vehículo',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _marcaControlador,
                decoration: const InputDecoration(
                  labelText: 'Marca',
                  hintText: 'Ejemplo: Chevrolet',
                  prefixIcon: Icon(Icons.car_repair),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Ingresa la marca del vehículo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _modeloControlador,
                decoration: const InputDecoration(
                  labelText: 'Modelo',
                  hintText: 'Ejemplo: Sail',
                  prefixIcon: Icon(Icons.directions_car),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Ingresa el modelo del vehículo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _anioControlador,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Año',
                  hintText: 'Ejemplo: 2019',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  final anio = int.tryParse(valor ?? '');
                  if (anio == null || anio < 1900 || anio > 2100) {
                    return 'Ingresa un año válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _placaControlador,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Placa',
                  hintText: 'Ejemplo: GBA1234',
                  prefixIcon: Icon(Icons.confirmation_number),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Ingresa la placa del vehículo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kilometrajeControlador,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Kilometraje (opcional)',
                  hintText: 'Ejemplo: 113000',
                  prefixIcon: Icon(Icons.speed),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return null;
                  }

                  final kilometraje = int.tryParse(valor);

                  if (kilometraje == null || kilometraje < 0) {
                    return 'Ingresa un kilometraje válido';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _guardando ? null : _guardarVehiculo,
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
                      ? 'Actualizar vehículo'
                      : 'Guardar vehículo',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
