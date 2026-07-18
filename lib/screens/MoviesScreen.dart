import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movies_taller/main.dart';
import 'package:movies_taller/screens/DetallePeliculaScreen.dart';
import 'package:movies_taller/screens/PerfilScreen.dart';

class Movies extends StatefulWidget {
  final cambiarTema;
  const Movies(this.cambiarTema,{super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  List peliculasCompletas = [];
  List peliculasFiltradas = [];
  bool cargando = true;

  String filtroGeneroSeleccionado = "Todas";
  final TextEditingController searchController = TextEditingController();

  final List<String> generos = [
    "Todas",
    "Sci-Fi",
    "Action",
    "Drama",
    "Mystery",
    "Horror",
  ];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    String jsonString = await DefaultAssetBundle.of(
      context,
    ).loadString("assets/data/movies.json");
    final List datos = json.decode(jsonString);
    setState(() {
      peliculasCompletas = datos;
      peliculasFiltradas = datos;
      cargando = false;
    });
  }

  void _aplicarFiltros(String query) {
    setState(() {
      peliculasFiltradas = peliculasCompletas.where((pelicula) {
        final titulo = pelicula['title'].toString().toLowerCase();
        final coincideTexto = titulo.contains(query.toLowerCase());
        final listaGeneros = pelicula['genres'] as List;
        final coincideGenero =
            filtroGeneroSeleccionado == "Todas" ||
            listaGeneros.contains(filtroGeneroSeleccionado);
        return coincideTexto && coincideGenero;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CineMax",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        leading: IconButton(
          onPressed: () => widget.cambiarTema(),
          icon: const Icon(Icons.bedtime_rounded),
        ),
        actions: [
          fotoUsuario(context)
        ],
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) => _aplicarFiltros(value),
                    decoration: InputDecoration(
                      hintText: "Buscar por título...",
                      prefixIcon: Icon(
                        Icons.search,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),

                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: generos.length,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemBuilder: (context, index) {
                      final genero = generos[index];
                      final esSeleccionado = filtroGeneroSeleccionado == genero;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 8.0,
                        ),
                        child: FilterChip(
                          label: Text(genero),
                          selected: esSeleccionado,
                          showCheckmark: false,
                          selectedColor: Colors.red,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          labelStyle: TextStyle(
                            color: esSeleccionado
                                ? Colors.white
                                : colorScheme.onSurface,
                            fontWeight: esSeleccionado
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                filtroGeneroSeleccionado = genero;
                              });
                              _aplicarFiltros(searchController.text);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    bottom: 5.0,
                    top: 10.0,
                  ),
                  child: Text(
                    "Peliculas",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),

                Expanded(
                  child: peliculasFiltradas.isEmpty
                      ? Center(
                          child: Text(
                            "No se encontraron películas",
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: peliculasFiltradas.length,
                          itemBuilder: (context, index) {
                            final item = peliculasFiltradas[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Detallepeliculascreen(pelicula: item),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainer,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.shadow.withOpacity(
                                        0.15,
                                      ),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                      child: Image.network(
                                        item['thumbnail'],
                                        width: 110,
                                        height: 150,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (_, child, progress) {
                                          if (progress == null) return child;
                                          return Container(
                                            width: 110,
                                            height: 150,
                                            color: colorScheme
                                                .surfaceContainerHighest,
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.red,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['title'],
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            item['synopsis'],
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: colorScheme.onSurface
                                                  .withOpacity(0.7),
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                item['rating'] != null
                                                    ? "${item['rating']}"
                                                    : "N/A",
                                                style: TextStyle(
                                                  color: item['rating'] != null
                                                      ? colorScheme.onSurface
                                                      : colorScheme.onSurface
                                                            .withOpacity(0.4),
                                                  fontStyle:
                                                      item['rating'] != null
                                                      ? FontStyle.normal
                                                      : FontStyle.italic,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

Widget fotoUsuario(BuildContext context) {
  Key avatarKey = UniqueKey();

  return StatefulBuilder(
    builder: (context, setState) {
      return FutureBuilder(
        future: supabase
            .from('usuarios')
            .select('foto')
            .eq('auth_id', supabase.auth.currentUser!.id)
            .maybeSingle(),
        builder: (context, snapshot) {
          final fotoUrl = snapshot.data?['foto'] ?? '';

          return Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon: CircleAvatar(
                key: avatarKey,
                radius: 18,
                backgroundColor: Colors.red,
                backgroundImage: fotoUrl.isNotEmpty ? NetworkImage(fotoUrl) : null,
                child: fotoUrl.isEmpty ? const Icon(Icons.person, color: Colors.white, size: 20) : null,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20, right: 5),
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("MI PERFIL", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                            CloseButton(color: Colors.red), 
                          ],
                        ),
                      ),
                      const Flexible(
                        child: Padding(padding: EdgeInsets.all(20.0), child: Perfilscreen()),
                      ),
                    ],
                  ),
                ),
              ).then((_) => setState(() => avatarKey = UniqueKey())),
            ),
          );
        },
      );
    },
  );
}