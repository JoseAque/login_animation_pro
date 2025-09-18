import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Timer? debounce;

  // Cerebro de la lógica de animaciones
  StateMachineController? controller;
  SMIBool? isChecking; // Activa la animación
  SMIBool? isHandsUp; // Ojos tapados
  SMITrigger? trigSuccess; // Éxito
  SMITrigger? trigFail; // Fallo
  SMINumber? numLook; // Mover ojos

  bool obscurePassword = true;

  // Controladores de texto
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Focus nodes
  late FocusNode emailFocus;
  late FocusNode passwordFocus;

  @override
  void initState() {
    super.initState();

    emailFocus = FocusNode();
    passwordFocus = FocusNode();

    // Listener email
    emailFocus.addListener(() {
      if (emailFocus.hasFocus) {
        // Manos bajas al enfocar email
        if (isHandsUp != null) isHandsUp!.change(false);
        // Activar isChecking
        if (isChecking != null) isChecking!.change(true);
      }
    });

    // Listener password
    passwordFocus.addListener(() {
      if (passwordFocus.hasFocus) {
        // Al enfocar password → manos arriba
        isHandsUp?.change(true);
        isChecking?.change(false);
      } else {
        // Al perder foco → bajar las manos
        isHandsUp?.change(false);
      }
    });
  }

  @override
  void dispose() {
    debounce?.cancel();
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Cerrar teclado y perder foco
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FocusScope(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Rive animation...
                  SizedBox(
                    width: size.width,
                    height: 200,
                    child: RiveAnimation.asset(
                      'animated_login_character.riv',
                      stateMachines: ["Login Machine"],
                      onInit: (artboard) {
                        controller = StateMachineController.fromArtboard(
                          artboard,
                          "Login Machine",
                        );
                        if (controller == null) return;
                        artboard.addController(controller!);
                        isChecking = controller!.findSMI('isChecking');
                        isHandsUp = controller!.findSMI('isHandsUp');
                        trigSuccess = controller!.findSMI('trigSuccess');
                        trigFail = controller!.findSMI('trigFail');
                        numLook = controller!.findSMI('numLook');
                      },
                    ),
                  ),
                  // Email TextField
                  TextField(
                    controller: emailController,
                    focusNode: emailFocus,
                    onChanged: (value) {
                      if (isChecking != null) isChecking!.change(true);
                      debounce?.cancel();
                      debounce = Timer(const Duration(seconds: 1), () {
                        if (isChecking != null) isChecking!.change(false);
                      });
                      if (numLook != null)
                        numLook!.change(value.length.toDouble() * 1.5);
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

                  // Password TextField
                  TextField(
                    controller: passwordController,
                    focusNode: passwordFocus,
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
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
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

                  const SizedBox(height: 10),
                  MaterialButton(
                    minWidth: size.width,
                    height: 50,
                    color: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: () {
                      final email = emailController.text.trim();
                      final password = passwordController.text;

                      if (email == "alumno@merida.tecnm.mx" &&
                          password == "12345") {
                        // Login correcto → activar trigSuccess
                        trigSuccess?.fire();
                      } else {
                        // Login incorrecto → activar trigFail
                        trigFail?.fire();
                      }
                    },
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
                              fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }
}
