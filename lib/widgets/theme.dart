import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData tema1(){
  return ThemeData(
    //Fondo Color
    scaffoldBackgroundColor: Color.fromARGB(255, 30, 211, 94),
    //Barra de app
    appBarTheme: AppBarTheme(
      backgroundColor: Color.fromARGB(255, 110, 210, 252),
      titleTextStyle: GoogleFonts.roboto(
        color: Colors.white,
        fontSize: 24,
      ),
    ),
    //Estilos de texto
    // Estilos de texto
    textTheme: TextTheme(
      // Títulos
      headlineMedium: GoogleFonts.langar(
        color: Colors.teal[800],
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}