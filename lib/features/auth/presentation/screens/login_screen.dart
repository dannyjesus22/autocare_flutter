
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _mostrarPassword = false;

  static const Color _fondo = Color(0xFF0B1220);
  static const Color _tarjeta = Color(0xFF151F30);
  static const Color _azul = Color(0xFF2589FF);
  static const Color _texto = Color(0xFFF5F7FA);
  static const Color _textoSecundario = Color(0xFF94A3B8);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final resultado = await authProvider.iniciarSesion(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (resultado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Inicio de sesión exitoso!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ?? 'No se pudo iniciar sesión.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  InputDecoration _decoracionCampo({
    required String etiqueta,
    required IconData icono,
    Widget? sufijo,
  }) {
    return InputDecoration(
      labelText: etiqueta,
      labelStyle: const TextStyle(color: _textoSecundario),
      prefixIcon: Icon(icono, color: _azul),
      suffixIcon: sufijo,
      filled: true,
      fillColor: const Color(0xFF0F1929),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 19,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF29374D)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: _azul, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: _fondo,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 30,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 15),

                  // LOGO
                  Center(
                    child: Container(
                      width: 105,
                      height: 105,
                      decoration: BoxDecoration(
                        color: _azul.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: _azul.withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Icon(
                        Icons.directions_car_filled_rounded,
                        size: 60,
                        color: _azul,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'AutoCare',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _texto,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Tu vehículo, siempre en buenas manos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: _textoSecundario,
                    ),
                  ),

                  const SizedBox(height: 42),

                  // TARJETA DEL FORMULARIO
                  Container(
                    padding: const EdgeInsets.all(23),
                    decoration: BoxDecoration(
                      color: _tarjeta,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF26364D),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Bienvenido de nuevo',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: _texto,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Inicia sesión para continuar.',
                          style: TextStyle(
                            fontSize: 14,
                            color: _textoSecundario,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // CORREO
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: _texto),
                          decoration: _decoracionCampo(
                            etiqueta: 'Correo electrónico',
                            icono: Icons.email_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa tu correo electrónico';
                            }

                            if (!value.contains('@') ||
                                !value.contains('.')) {
                              return 'Ingresa un correo válido';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // CONTRASEÑA
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_mostrarPassword,
                          style: const TextStyle(color: _texto),
                          decoration: _decoracionCampo(
                            etiqueta: 'Contraseña',
                            icono: Icons.lock_outline,
                            sufijo: IconButton(
                              icon: Icon(
                                _mostrarPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: _textoSecundario,
                              ),
                              onPressed: () {
                                setState(() {
                                  _mostrarPassword = !_mostrarPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa tu contraseña';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 30),

                        // BOTÓN INGRESAR
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : _iniciarSesion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _azul,
                              disabledBackgroundColor: _azul.withValues(
                                alpha: 0.5,
                              ),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: authProvider.isLoading
                                ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                                : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Iniciar sesión',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(Icons.arrow_forward_rounded),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 27),

                  // IR AL REGISTRO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Flexible(
                        child: Text(
                          '¿No tienes una cuenta?',
                          style: TextStyle(
                            color: _textoSecundario,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/register');
                        },
                        child: const Text(
                          'Regístrate',
                          style: TextStyle(
                            color: _azul,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'AUTOMOTIVE CARE EXPERIENCE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF53647C),
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
