import 'package:flutter/material.dart';
import 'package:movies_taller/screens/login.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Cuerpo2(),
    );
  }
}

class Cuerpo2 extends StatelessWidget {
  const Cuerpo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              
              nik(),
               SizedBox(height: 20), 
              
              correo(),
              SizedBox(height: 20),
              
              edad(context),
              SizedBox(height: 20),
              
              password(),
              SizedBox(height: 15), 
              TextButton(onPressed: ()=>Navigator.push(context,MaterialPageRoute(builder:(context) =>Login())), child:Text("¿No tienes una cuenta? Haz click para crear")),
              btnRegistrar(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

Widget nik() {
  return TextField(
    style: const TextStyle(fontSize: 18, color: Colors.white),
    keyboardType: TextInputType.text,
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
    style: const TextStyle(fontSize: 18, color: Colors.white),
    keyboardType: TextInputType.emailAddress, // Muestra el teclado con el "@"
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
TextEditingController anioController = TextEditingController();
Widget edad(BuildContext context) {
  return TextField(
    controller: anioController, 
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

        anioController.text = "$dia/$mes/$anio";
      }
    },
    style: const TextStyle(fontSize: 18, color: Colors.white),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey[800],
      prefixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      // Actualizamos el texto para reflejar lo que se va a mostrar
      labelText: "Año de nacimiento", 
      labelStyle: const TextStyle(color: Colors.white, fontSize: 15),
    ),
  );
}

Widget password() {
  return TextField(
    obscureText: true, // Oculta los caracteres
    style: const TextStyle(fontSize: 18, color: Colors.white),
    keyboardType: TextInputType.text,
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
      labelText: "Cree una contraseña",
      labelStyle: const TextStyle(color: Colors.white54),
    ),
  );
}

Widget btnRegistrar() {
  return SizedBox(
    width: double.infinity,
    height: 55,
    child: FilledButton.icon(
      onPressed: () {
        // Aquí irá la lógica para guardar el usuario
      },
      style: FilledButton.styleFrom(
        backgroundColor: Colors.red[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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