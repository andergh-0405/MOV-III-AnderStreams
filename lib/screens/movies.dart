import 'dart:convert';
import 'package:flutter/material.dart';

class Movies extends StatelessWidget {
  const Movies({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF141414),
        colorScheme: const ColorScheme.dark(primary: Colors.red),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home:  Peliculas(),
    );
  }
}

class Peliculas extends StatelessWidget {
  const Peliculas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ANDERSTREAM",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [IconButton(onPressed: ()=>perfil(context), icon: Icon(Icons.account_box),iconSize: 40,)],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, bottom: 10.0, top: 10.0),
            child: Text(
              "Películas en Tendencia",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: listaPeliculas(context))
        ],
      ),
    );
  }
}

void perfil(context){
  showDialog(context: context, builder:(context) =>
  AlertDialog(
    title: Text("Perfil"),
    content: Text("Datos del usuario para actualizar"),
  )
   ,);
}

Future<List> leerPeliculas(context) async {
  String jsonString = await DefaultAssetBundle.of(context).loadString("assets/data/movies.json");
  return json.decode(jsonString);
}

Widget listaPeliculas(BuildContext context) {
  return FutureBuilder(
    future: leerPeliculas(context),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final data = snapshot.data!;
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetallePelicula(pelicula: item),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B2B2B),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ]
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15), 
                        bottomLeft: Radius.circular(15)
                      ),
                      child: Image.network(
                        item['thumbnail'],
                        width: 110,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    // Textos de la tarjeta
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['synopsis'],
                            maxLines: 3, 
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 5),
                              Text("${item['rating'] ?? 'N/A'}"),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        return const Center(child: Text("No se pudieron cargar las películas"));
      }
    },
  );
}

class DetallePelicula extends StatelessWidget {
  
  final Map pelicula;

  const DetallePelicula({super.key, required this.pelicula});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pelicula['title']),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              pelicula['thumbnail_horinzontal'], 
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pelicula['title'],
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(pelicula['release_date'].toString().substring(0,4), style: const TextStyle(color: Colors.white70)),
                      const SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(4)
                        ),
                        child: Text( '+'+ pelicula['age_rating'] ?? 'TP', style: const TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 15),
                      Text("${pelicula['duration_mins']} min", style: const TextStyle(color: Colors.white70)),
                      const SizedBox(width: 15),
                      Text("${pelicula['country']}", style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: () {
                        print("Reproduciendo: ${pelicula['trailer_url']}");
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                      ),
                      icon: const Icon(Icons.play_arrow, size: 30),
                      label: const Text("Ver Tráiler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 25),

                  const Text("Sinopsis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    pelicula['synopsis'],
                    style: const TextStyle(fontSize: 15, color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(height: 25),

                  const Text("Director", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  Text(
                    pelicula['director'],
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 25),

                  const Text("Reparto", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List<Widget>.generate(
                      (pelicula['actors'] as List).length,
                      (int index) {
                        return Chip(
                          label: Text(pelicula['actors'][index]),
                          backgroundColor: Colors.grey[900],
                          side: BorderSide.none,
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
