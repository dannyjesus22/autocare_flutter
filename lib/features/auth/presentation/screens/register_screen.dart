
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _mostrarPassword = false;
  bool _mostrarConfirmacion = false;

  static const Color _fondo = Color(0xFF0B1220);
  static const Color _tarjeta = Color(0xFF151F30);
  static const Color _azul = Color(0xFF2589FF);
  static const Color _texto = Color(0xFFF5F7FA);
  static const Color _textoSecundario = Color(0xFF94A3B8);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registrarUsuario() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final resultado = await authProvider.registrar(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (resultado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cuenta creada. Revisa tu correo si necesitas confirmarla.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ?? 'No se pudo crear la cuenta.',
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
              vertical: 25,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),

                  // LOGO
                  Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: _azul.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(27),
                        border: Border.all(
                          color: _azul.withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 48,
                        color: _azul,
                      ),
                    ),
                  ),

                  const SizedBox(height: 17),

                  const Text(
                    'AutoCare',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _texto,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 7),

                  const Text(
                    'Comienza a cuidar tu vehículo con nosotros.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: _textoSecundario,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // TARJETA DEL FORMULARIO
                  Container(
                    padding: const EdgeInsets.all(22),
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
                          'Crear cuenta',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _texto,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Regístrate para comenzar tu experiencia.',
                          style: TextStyle(
                            fontSize: 13,
                            color: _textoSecundario,
                          ),
                        ),

                        const SizedBox(height: 25),

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

                        const SizedBox(height: 18),

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
                            if (value == null || value.length < 6) {
                              return 'Usa al menos 6 caracteres';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        // CONFIRMAR CONTRASEÑA
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_mostrarConfirmacion,
                          style: const TextStyle(color: _texto),
                          decoration: _decoracionCampo(
                            etiqueta: 'Confirmar contraseña',
                            icono: Icons.lock_reset_outlined,
                            sufijo: IconButton(
                              icon: Icon(
                                _mostrarConfirmacion
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: _textoSecundario,
                              ),
                              onPressed: () {
                                setState(() {
                                  _mostrarConfirmacion =
                                  !_mostrarConfirmacion;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirma tu contraseña';
                            }

                            if (value != _passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 27),

                        // BOTÓN CREAR CUENTA
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : _registrarUsuario,
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
                                  'Crear cuenta',
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

                  const SizedBox(height: 22),

                  // VOLVER AL LOGIN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Flexible(
                        child: Text(
                          '¿Ya tienes una cuenta?',
                          style: TextStyle(
                            color: _textoSecundario,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        child: const Text(
                          'Inicia sesión',
                          style: TextStyle(
                            color: _azul,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

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
