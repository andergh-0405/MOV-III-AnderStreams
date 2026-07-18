import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movies_taller/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Usuarioscreen extends StatefulWidget {
  final  cambiarTema;
  const Usuarioscreen(this.cambiarTema,{super.key});

  @override
  State<Usuarioscreen> createState() => _UsuarioscreenState();
}

class _UsuarioscreenState extends State<Usuarioscreen> {

  final nombreController = TextEditingController();
  final nickController = TextEditingController();
  final edadController = TextEditingController();
  XFile? imagenSeleccionada;
  String? fotoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Información Personal",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        actions: [
          IconButton(
            onPressed: widget.cambiarTema,
            icon: const Icon(Icons.brightness_medium),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: imagenSeleccionada != null
                  ? FileImage(File(imagenSeleccionada!.path))
                  : null,
              child: imagenSeleccionada == null
                  ? const Icon(Icons.person, size: 50, color: Colors.red)
                  : null,
            ),
            const SizedBox(height: 20),
            _campoTexto(
              "Ingrese su Nick",
              Icons.badge_outlined,
              nickController,
            ),
            const SizedBox(height: 20),
            _campoTexto("Ingrese su nombre", Icons.person, nombreController),
            const SizedBox(height: 20),
            _campoFecha(context),
            const SizedBox(height: 20),
            _campoFoto(),
            const SizedBox(height: 30),
            _btnRegistrar(),
          ],
        ),
      ),
    );
  }

  Widget _campoTexto(String label, IconData icon, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(fontSize: 18, color: Colors.white),
      decoration: _inputDecoration(label, icon),
    );
  }

  Widget _campoFecha(BuildContext context) {
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
      decoration: _inputDecoration(
        "Fecha de nacimiento",
        Icons.calendar_today_outlined,
      ),
    );
  }

  Widget _campoFoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Foto de Perfil", style: TextStyle(color: Colors.white54)),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: seleccionarImagenGaleria,
              icon: const Icon(Icons.photo),
              label: const Text("Galería"),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: tomarFoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Cámara"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _btnRegistrar() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: FilledButton.icon(
        onPressed: guardarUsuario,
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
        icon: const Icon(Icons.save, size: 28, color: Colors.white),
      ),
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

 Future<void> seleccionarImagenGaleria() async {
    final picker = ImagePicker();
    final imagen = await picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() => imagenSeleccionada = imagen);
    }
  }

  Future<void> tomarFoto() async {
    final picker = ImagePicker();
    final imagen = await picker.pickImage(source: ImageSource.camera);
    if (imagen != null) {
      setState(() => imagenSeleccionada = imagen);
    }
  }

  Future<void> guardarUsuario() async {
    if (nombreController.text.isEmpty ||
        nickController.text.isEmpty ||
        edadController.text.isEmpty ||
        imagenSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor llena todos los campos")),
      );
      return;
    }

    final authUser = supabase.auth.currentUser;
    if (authUser == null) return;

    // 🔥 Subir imagen a Supabase Storage
    final file = File(imagenSeleccionada!.path);
    final path = "fotos/${authUser.id}.png";
    await supabase.storage
        .from('FotoUsuarios')
        .upload(path, file, fileOptions: const FileOptions(upsert: true));

    // Obtener URL pública
    fotoUrl = supabase.storage.from('FotoUsuarios').getPublicUrl(path);

    // Guardar datos en tabla usuarios
    await supabase.from('usuarios').insert({
      'auth_id': authUser.id,
      'nombre': nombreController.text,
      'nick': nickController.text,
      'edad': edadController.text,
      'foto': fotoUrl,
    });

    Navigator.pushNamed(context, "/movies");
  }

}
