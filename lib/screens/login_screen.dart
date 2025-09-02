import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true; // Estado para mostrar/ocultar

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(
      context,
    ).size; //Para obtener el tamaño de pantalla del dispositivo
    return Scaffold(
      //La base de la aplicacion
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            //Ordenar en 1 columna
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Filas de la columna
              SizedBox(
                // Ancho de la pantalla por Media Q
                width: size.width,
                height: 200,
                child: const RiveAnimation.asset(
                  'animated_login_character.riv',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility
                          : Icons
                                .visibility_off, // ? es el alternador True - Off
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword; // Cambia el valor
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: const Text(
                  "Forgot your password?",
                  textAlign: TextAlign.right,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
