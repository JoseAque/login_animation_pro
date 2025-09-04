import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Cerebro de la lógica de animaciones
  StateMachineController? controller;
  //State Machine Input
  SMIBool? isChecking; //Activa la animacion
  SMIBool? isHandsUp; //Ojos tapados
  SMITrigger? trigSuccess; //Exito
  SMITrigger? trigFail; //Fallo
  SMINumber? numLook; //Mover ojos

  // Estado para mostrar/ocultar contraseña
  bool obscurePassword = true;

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
                child: RiveAnimation.asset(
                  'animated_login_character.riv',
                  stateMachines: ["Login Machine"],
                  //Configuracion Inicial
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine",
                    );
                    //Verifica si hay un controlador
                    if (controller == null) return;
                    //Enalazar animaciones con la APP
                    artboard.addController(controller!);
                    isChecking = controller!.findSMI('isChecking');
                    isHandsUp = controller!.findSMI('isHandsUp');
                    trigSuccess = controller!.findSMI('trigSuccess');
                    trigFail = controller!.findSMI('isChectrigFailking');
                    numLook = controller!.findSMI('numLook');
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  if (isHandsUp != null) {
                    //No subir las manos al escribir email
                    isHandsUp!.change(false);
                  }
                  //Verifica que este SMI no sea nulo
                  if (isChecking == null) return;
                  isChecking!.change(true);

                  // Actualiza numLook con la longitud del texto
                  if (numLook == null) return;
                  numLook!.change(
                    value.length.toDouble() * 1.5,
                  ); // x 1.5 para alinear
                },
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
                onChanged: (value) {
                  if (isChecking != null) {
                    //No mover los ojos al escribir
                    isChecking!.change(false);
                  }
                  //Verifica que este SMI no sea nulo
                  if (isHandsUp == null) return;
                  isHandsUp!.change(true);
                },
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot your password?",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Botón de login
              const SizedBox(height: 10),
              MaterialButton(
                minWidth: size.width,
                height: 50,
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onPressed: () {},
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.black,
                          //Negritas
                          fontWeight: FontWeight.bold,
                          //Subrayado
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
