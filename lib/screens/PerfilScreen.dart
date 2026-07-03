import 'package:flutter/material.dart';
import 'package:movies_taller/main.dart';

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

  @override
  void initState() {
    super.initState();
    nombre = TextEditingController();
    nick = TextEditingController();
    edad = TextEditingController();
    foto = TextEditingController();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from('usuarios')
        .select()
        .eq('auth_id', user.id)
        .single();

    setState(() {
      nombre.text = response['nombre'] ?? '';
      nick.text = response['nick'] ?? '';
      edad.text = response['edad'] ?? '';
      foto.text = response['foto'] ?? '';
    });
  }

  Future<void> actualizarDatos() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase
        .from('usuarios')
        .update({
          'nombre': nombre.text.trim(),
          'nick': nick.text.trim(),
          'edad': edad.text.trim(),
          'foto': foto.text.trim(),
        })
        .eq('auth_id', user.id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Datos actualizados correctamente")),
    );
  }

  Future<void> cerrarSesion() async {
    await supabase.auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context,"/",(Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.red.withOpacity(0.15),
              backgroundImage: foto.text.isNotEmpty ? NetworkImage(foto.text) : null,
              child: foto.text.isEmpty
                  ? const Icon(Icons.person, size: 60, color: Colors.red)
                  : null,
            ),
            const SizedBox(height: 15),
            Text(
              nombre.text.isNotEmpty ? nombre.text : "Usuario",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              nick.text.isNotEmpty ? "@${nick.text}" : "@nick",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 25),

            // Campos en tarjetas
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: TextField(
                  controller: nombre,
                  decoration: const InputDecoration(border: InputBorder.none, labelText: "Nombre"),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.badge),
                title: TextField(
                  controller: nick,
                  decoration: const InputDecoration(border: InputBorder.none, labelText: "Nick"),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: TextField(
                  controller: edad,
                  decoration: const InputDecoration(border: InputBorder.none, labelText: "Fecha Nacimiento"),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.camera_alt),
                title: TextField(
                  controller: foto,
                  decoration: const InputDecoration(border: InputBorder.none, labelText: "Foto (URL)"),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: actualizarDatos,
                      icon: const Icon(Icons.published_with_changes_sharp),
                      label: const Text("Actualizar"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: cerrarSesion,
                      icon: const Icon(Icons.logout),
                      label: const Text("Cerrar Sesión"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
