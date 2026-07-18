import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movies_taller/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Perfilscreen extends StatefulWidget {
  const Perfilscreen({super.key});

  @override
  State<Perfilscreen> createState() => _PerfilscreenState();
}

class _PerfilscreenState extends State<Perfilscreen> {
  late TextEditingController nombre;
  late TextEditingController nick;
  late TextEditingController edad;
  late TextEditingController foto;

  bool _cargando = true; 
  bool _actualizando = false; 

  XFile? imagenSeleccionada;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite, 
      child: _cargando
          ? const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator(color: Colors.red)),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  // Lógica visual para la foto: Local > Red > Icono por defecto
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.red.withOpacity(0.15),
                    backgroundImage: imagenSeleccionada != null
                        ? FileImage(File(imagenSeleccionada!.path))
                        : (foto.text.isNotEmpty ? NetworkImage(foto.text) as ImageProvider : null),
                    child: (imagenSeleccionada == null && foto.text.isEmpty)
                        ? const Icon(Icons.person, size: 55, color: Colors.red)
                        : null,
                  ),
                  const SizedBox(height: 5),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: tomarFoto,
                        icon: const Icon(Icons.camera_alt, color: Colors.red),
                        tooltip: "Tomar foto",
                      ),
                      IconButton(
                        onPressed: seleccionarImagenGaleria,
                        icon: const Icon(Icons.photo_library, color: Colors.red),
                        tooltip: "Elegir de galería",
                      ),
                    ],
                  ),

                  Text(
                    nombre.text.isNotEmpty ? nombre.text : "Usuario",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    nick.text.isNotEmpty ? "@${nick.text}" : "@nick",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 15),

                  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: TextField(
                        controller: nombre,
                        decoration: const InputDecoration(border: InputBorder.none, labelText: "Nombre"),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    child: ListTile(
                      leading: const Icon(Icons.badge),
                      title: TextField(
                        controller: nick,
                        decoration: const InputDecoration(border: InputBorder.none, labelText: "Nick"),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: TextField(
                        controller: edad,
                        readOnly: true, 
                        onTap: () async {
                          DateTime? fechaSeleccionada = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (fechaSeleccionada != null) {
                            String dia = fechaSeleccionada.day.toString().padLeft(2, '0');
                            String mes = fechaSeleccionada.month.toString().padLeft(2, '0');
                            String anio = fechaSeleccionada.year.toString();
                            edad.text = "$dia/$mes/$anio";
                          }
                        },
                        decoration: const InputDecoration(border: InputBorder.none, labelText: "Fecha Nacimiento"),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _actualizando ? null : actualizarDatos,
                        icon: _actualizando 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.published_with_changes_sharp),
                        label: Text(_actualizando ? "Actualizando..." : "Actualizar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: cerrarSesion,
                        icon: const Icon(Icons.logout),
                        label: const Text("Cerrar Sesión"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }


  @override
  void initState() {
    super.initState();
    nombre = TextEditingController();
    nick = TextEditingController();
    edad = TextEditingController();
    foto = TextEditingController();
    cargarDatos();
  }

  @override
  void dispose() {
    nombre.dispose();
    nick.dispose();
    edad.dispose();
    foto.dispose();
    super.dispose();
  }

  Future<void> cargarDatos() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final response = await supabase
          .from('usuarios')
          .select()
          .eq('auth_id', user.id)
          .single();

      if (mounted) {
        setState(() {
          nombre.text = response['nombre'] ?? '';
          nick.text = response['nick'] ?? '';
          edad.text = response['edad'] ?? '';
          foto.text = response['foto'] ?? '';
          _cargando = false; 
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _cargando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al cargar perfil: $e"), backgroundColor: Colors.red),
        );
      }
    }
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

  Future<void> actualizarDatos() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    setState(() => _actualizando = true);

    try {
      if (imagenSeleccionada != null) {
        final file = File(imagenSeleccionada!.path);
        
        if (foto.text.isNotEmpty && foto.text.contains('FotoUsuarios/')) {
          try {
            final rutaVieja = foto.text.split('FotoUsuarios/').last; 
            await supabase.storage.from('FotoUsuarios').remove([rutaVieja]);
          } catch (e) {
           
          }
        }

        final extension = imagenSeleccionada!.path.split('.').last;
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final path = "fotos/${user.id}_$timestamp.$extension";
        
        await supabase.storage
            .from('FotoUsuarios')
            .upload(path, file);

        final baseUrl = supabase.storage.from('FotoUsuarios').getPublicUrl(path);
        foto.text = baseUrl;
      }

      await supabase
          .from('usuarios')
          .update({
            'nombre': nombre.text.trim(),
            'nick': nick.text.trim(),
            'edad': edad.text.trim(),
            'foto': foto.text.trim(),
          })
          .eq('auth_id', user.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Datos actualizados correctamente"), backgroundColor: Colors.green),
        );
        Navigator.pop(context); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al actualizar: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _actualizando = false);
      }
    }
  }

  Future<void> cerrarSesion() async {
    await supabase.auth.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, "/", (Route<dynamic> route) => false);
    }
  }
}