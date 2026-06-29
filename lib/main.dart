import 'package:flutter/material.dart';
import 'package:movies_taller/screens/LoginScreen.dart';
import 'package:movies_taller/screens/MoviesScreen.dart';
import 'package:movies_taller/screens/RegisterScreen.dart';
import 'package:movies_taller/screens/welcomeScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://qwitxojbwmwglgvbrmkx.supabase.co',
    publishableKey: 'sb_publishable_3L9JUpnzmESSpHh9irCscw_icM_tcTj',
  );
  runApp(const MainApp());
}
final supabase = Supabase.instance.client;

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  
   bool modoOscuro=false;

    void cambiarTema(){
      setState(() {
        modoOscuro=!modoOscuro;
      });
    }

  @override
  Widget build(BuildContext context) {
   
    return  MaterialApp(
    debugShowCheckedModeBanner: false,
     theme: modoOscuro ? ThemeData.dark(): ThemeData.light(),
     initialRoute: "/movies",
     routes: {
      "/": (context) => Welcomescreen(),
      "/login": (context) =>Login(cambiarTema: cambiarTema),
      "/register": (context)=> Register(),
      "/movies": (context)=> Movies(cambiarTema: cambiarTema),
     },
    );
  }
}


