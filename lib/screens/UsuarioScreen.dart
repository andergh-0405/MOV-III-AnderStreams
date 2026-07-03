import 'package:flutter/material.dart';
import 'package:movies_taller/main.dart';

class Usuarioscreen extends StatelessWidget {
  final VoidCallback cambiarTema;
  const Usuarioscreen({required this.cambiarTema, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Información Personal",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: cambiarTema,
            icon: const Icon(Icons.brightness_medium),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.red.withOpacity(0.2),
              child: const Icon(Icons.person, size: 40, color: Colors.red),
            ),
            const SizedBox(height: 20),
            formulario(context),
          ],
        ),
      ),
    );
  }
}

TextEditingController nickController = TextEditingController();
TextEditingController edadController = TextEditingController();
TextEditingController fotocontroller = TextEditingController();
TextEditingController nombrecontroller = TextEditingController();

Widget formulario(BuildContext context) {
  return Column(
    children: [
      nik(),
      const SizedBox(height: 20),
      nombre(),
      const SizedBox(height: 20),
      edad(context),
      const SizedBox(height: 20),
      foto(),
      const SizedBox(height: 30),
      btnRegistrar(context, nombrecontroller, nickController, edadController, fotocontroller),
    ],
  );
}

Widget nombre() => TextField(
  controller: nombrecontroller,
  style: const TextStyle(fontSize: 18, color: Colors.white),
  decoration: _inputDecoration("Ingrese su nombre", Icons.person),
);

Widget foto() => TextField(
  controller: fotocontroller,
  style: const TextStyle(fontSize: 18, color: Colors.white),
  decoration: _inputDecoration("Foto de Perfil", Icons.camera_alt_outlined),
);

Widget nik() => TextField(
  controller: nickController,
  style: const TextStyle(fontSize: 18, color: Colors.white),
  decoration: _inputDecoration("Ingrese su Nick", Icons.badge_outlined),
);

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
    decoration: _inputDecoration("Fecha de nacimiento", Icons.calendar_today_outlined),
  );
}

InputDecoration _inputDecoration(String label, IconData icon) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.grey[850],
    prefixIcon: Icon(icon, color: Colors.white54),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white54),
  );
}

Widget btnRegistrar(context, nombre, nick, edad, foto) {
  return SizedBox(
    width: double.infinity,
    height: 55,
    child: FilledButton.icon(
      onPressed: () => guardarUsuario(context, nombre, nick, edad, foto),
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
      icon: const Icon(Icons.save, size: 28, color: Colors.white),
    ),
  );
}

Future<void> guardarUsuario(context, nombre, nick, edad, foto) async {
  if (nombre.text.isEmpty || nick.text.isEmpty || edad.text.isEmpty || foto.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Por favor llena todos los campos")),
    );
    return;
  }

  final authUser = supabase.auth.currentUser;
  if (authUser == null) return;

  await supabase.from('usuarios').insert({
    'auth_id': authUser.id, 
    'nombre': nombre.text,
    'nick': nick.text,
    'edad': edad.text,
    'foto': foto.text,
  });

  Navigator.pushNamed(context, "/movies");
}
