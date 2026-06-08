import 'package:flutter/material.dart';
import 'package:movies_taller/screens/movies.dart';
import 'package:movies_taller/screens/register.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Cuerpo(),
    );
  }
}

class Cuerpo extends StatelessWidget {
  const Cuerpo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0), 
                child: Image.network(
                  "https://media.istockphoto.com/id/1944783914/es/vector/pel%C3%ADcula-de-cine.jpg?s=612x612&w=0&k=20&c=JikdXkmQlGBwhC0Fqfs7MbxRLhdNglMp0Ub3MtRpobQ=",
                  height: 180, 
                  fit: BoxFit.cover,
                ),
              ),
            ),
          
            const Text(
              "Iniciar sesión",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 20),
            usuario(),
            SizedBox(height: 20),
            password(),
            SizedBox(height: 5), 
            TextButton(onPressed: ()=>Navigator.push(context,MaterialPageRoute(builder:(context) =>Register())), child:Text("¿No tienes una cuenta? Haz click para crear")),
            SizedBox(height: 10), 
            btnIniciar(),
            SizedBox(height: 10), 
            ElevatedButton(onPressed: ()=>Navigator.push(context,MaterialPageRoute(builder:(context) => Movies(),)), child:Text("Ver peliculas"))
          ],
        ),
      ),
    );
  }
}

Widget usuario() {
  return TextField(
    style: const TextStyle(fontSize: 18, color: Colors.white),
    keyboardType: TextInputType.text,
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
    style: const TextStyle(fontSize: 18, color: Colors.white),
    keyboardType: TextInputType.text,
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

Widget btnIniciar() {
  return SizedBox(
    width: double.infinity, 
    height: 55, 
    child: FilledButton.icon(
      onPressed: () {}, 
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