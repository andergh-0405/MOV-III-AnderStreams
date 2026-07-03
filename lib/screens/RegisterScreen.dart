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


Widget formulario(context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      correo(),
      SizedBox(height: 20),
      password(),
      SizedBox(height: 20),
      btnRegistrar(context, correoController, contraseniaController)
    ],
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

  if(correo.text.isEmpty || contrasenia.text.isEmpty){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Por favor llena todos los campos"))
    );
    return;
  }

  final AuthResponse res = await supabase.auth.signUp(
    email: correo.text,
    password: contrasenia.text,
  );
  Navigator.pushNamed(context, "/login");
  final Session? session = res.session;
  final User? user = res.user;
}
