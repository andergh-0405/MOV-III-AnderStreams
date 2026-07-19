import 'package:flutter/material.dart';
import 'package:movies_taller/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatelessWidget {

  final cambiarTema;
  const Login(this.cambiarTema,{super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: ()=>cambiarTema(), icon: Icon(Icons.brightness_medium))
      ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            const Text(
              "Iniciar sesión",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 20),
            formulario(context),
            ElevatedButton(onPressed: ()=>Navigator.pushNamed(context, "/movies"), child: Text("Iniciar sesión"),)
          ],
        ),
      ),
    );
  }
}

TextEditingController usuarioC = TextEditingController();
TextEditingController contrasenia = TextEditingController();

Widget usuario() {
  return TextField(
     controller: usuarioC,
    style: const TextStyle(fontSize: 18, color: Colors.white),
    decoration: InputDecoration(
      filled: true,
     fillColor: Colors.grey[800],
      prefixIcon: const Icon(Icons.person_outline, color: Colors.white), 
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10), 
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white, width: 2), 
      ),
      labelText: "Ingrese su correo",
      labelStyle: const TextStyle(color: Colors.white, fontSize: 15),
    ),
  );
}

Widget password() {
  return TextField(
    obscureText: true,
    controller: contrasenia,
    style: const TextStyle(fontSize: 18, color: Colors.white),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey[800],
      prefixIcon: const Icon(Icons.lock_outline, color: Colors.white), 
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      labelText: "Ingrese su contraseña",
      labelStyle: TextStyle(color: Colors.white,fontSize: 15),
    ),
  );
}

Widget btnIniciar(context) {
  return SizedBox(
    width: double.infinity, 
    height: 55, 
    child: FilledButton.icon(
      onPressed: ()=>login(context, usuarioC, contrasenia), 
      style: FilledButton.styleFrom(
        backgroundColor: Colors.red[700], 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), 
        ),
      ),
      label: const Text(
        "Iniciar sesión",
        style: TextStyle(
          fontSize: 20, 
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      icon: const Icon(Icons.account_box, size: 30, color: Colors.white),
    ),
  );
}

Widget formulario(context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      usuario(),
      SizedBox(height: 20),
      password(),
      SizedBox(height: 20),
      btnIniciar(context),
      SizedBox(height: 20),
      TextButton(onPressed: ()=>Navigator.pushNamed(context, "/register"), child:Text("¿No tienes una cuenta? Haz click para crear")),

    ],
  );
}



Future<void> login(context, correo, contrasenia) async {
  if (correo.text.isEmpty || contrasenia.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Por favor ingrese sus credenciales")),
    );
    return;
  }

  try {
    final AuthResponse res = await supabase.auth.signInWithPassword(
      email: correo.text,
      password: contrasenia.text,
    );
    final Session? session = res.session;
    final User? user = res.user;

    if (user != null) {
      final response = await supabase
          .from('usuarios')
          .select()
          .eq('auth_id', user.id)   
          .maybeSingle();

      if (response == null) {
        Navigator.pushReplacementNamed(context, "/datosUsuario");
        (Route<dynamic> route) => false;
      } else {
        Navigator.pushReplacementNamed(context, "/movies");
        (Route<dynamic> route) => false;
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Correo o contraseña incorrecto")),
    );
  }
}
