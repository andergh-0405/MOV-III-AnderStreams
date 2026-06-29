import 'package:flutter/material.dart';
import 'package:movies_taller/main.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
             Text(
                "Crear cuenta",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 40),
            formulario(context),
          ],
        ),
      ),
    );
  }
}

TextEditingController correoController = TextEditingController();
TextEditingController contraseniaController = TextEditingController();
TextEditingController nickController = TextEditingController();
TextEditingController edadController = TextEditingController();

Widget formulario(context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      nik(),
      SizedBox(height: 20),
      correo(),
      SizedBox(height: 20),
      edad(context),
      SizedBox(height: 20),
      password(),
      SizedBox(height: 20),
      btnRegistrar(context, correoController, contraseniaController)
    ],
  );
}

Widget nik() {
  return TextField(
    controller: nickController,
    style: const TextStyle(fontSize: 18, color: Colors.white),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey[850],
      prefixIcon: const Icon(Icons.badge_outlined, color: Colors.white54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      labelText: "Ingrese su Nik",
      labelStyle: const TextStyle(color: Colors.white54),
    ),
  );
}

Widget correo() {
  return TextField(
    controller: correoController,
    style: const TextStyle(fontSize: 18, color: Colors.white),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey[850],
      prefixIcon: const Icon(Icons.email_outlined, color: Colors.white54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      labelText: "Ingrese su correo",
      labelStyle: const TextStyle(color: Colors.white54),
    ),
  );
}

Widget edad(BuildContext context) {
  return TextField(
    controller: edadController,
    readOnly: true,
    onTap: () async {
      DateTime? fechaSeleccionada = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.red,
                onPrimary: Colors.white,
                surface: Color(0xFF2B2B2B),
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );
      if (fechaSeleccionada != null) {
        String dia = fechaSeleccionada.day.toString().padLeft(2, '0');
        String mes = fechaSeleccionada.month.toString().padLeft(2, '0');
        String anio = fechaSeleccionada.year.toString();

        edadController.text = "$dia/$mes/$anio";
      }
    },
    style: const TextStyle(fontSize: 18, color: Colors.white),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey[800],
      prefixIcon: const Icon(
        Icons.calendar_today_outlined,
        color: Colors.white,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      labelText: "Año de nacimiento",
      labelStyle: const TextStyle(color: Colors.white, fontSize: 15),
    ),
  );
}

Widget password() {
  return TextField(
    controller: contraseniaController,
    obscureText: true,
    style: const TextStyle(fontSize: 18, color: Colors.white),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey[850],
      prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      labelText: "Crear una contraseña",
      labelStyle: const TextStyle(color: Colors.white54),
    ),
  );
}

Widget btnRegistrar(context, correo, contrasenia) {
  return SizedBox(
    width: double.infinity,
    height: 55,
    child: FilledButton.icon(
      onPressed: () =>
          registro(context, correo, contrasenia),
      style: FilledButton.styleFrom(
        backgroundColor: Colors.red[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      label: const Text(
        "Registrarse",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      icon: const Icon(Icons.person_add_alt_1, size: 28, color: Colors.white),
    ),
  );
}

Future<void> registro(context, correo, contrasenia) async {
  final AuthResponse res = await supabase.auth.signUp(
    email: correo.text,
    password: contrasenia.text,
  );
  Navigator.pushNamed(context, "/login");
  final Session? session = res.session;
  final User? user = res.user;
}
