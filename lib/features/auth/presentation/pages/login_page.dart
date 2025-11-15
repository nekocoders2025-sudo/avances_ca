/*

LOGIN PAGE UI

On this page, a user acn login with their:
- email
- pw

--------------------------------------------------------------------------------

Once the user successfully logs in, they will be directed to homepage

If user doesn't have an account, they can go to register page to create one.

*/

import 'package:coleccion_app/features/auth/presentation/components/apple_sign_in_button.dart';
import 'package:coleccion_app/features/auth/presentation/components/google_sign_in_button.dart';
import 'package:coleccion_app/features/auth/presentation/components/my_button.dart';
import 'package:coleccion_app/features/auth/presentation/components/my_textfield.dart';
import 'package:coleccion_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;

  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  // auth cubit
  late final authCubit = context.read<AuthCubit>();

  // login button pressed
  void login() {
    // prepare email & pw
    final String email = emailController.text;
    final String pw = pwController.text;

    // ensure that the fields are filled
    if (email.isNotEmpty && pw.isNotEmpty) {
      // login!
      authCubit.login(email, pw);
    }

    // fields are empty
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor ingresa Email & Contraseña.")));
    }
  }

  // forgot password box
  void openForgotPasswordBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reiniciar tu Contraseña?"),
        content: MyTextfield(
          controller: emailController,
          hintText: "Ingresa Email..",
          obscureText: false,
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),

          // reset button
          TextButton(
            onPressed: () async {
              String message =
                  await authCubit.forgotPassword(emailController.text);

              if (message == "Correo de reinicio de contraseña enviado! Revisa tu inbox") {
                Navigator.pop(context);
                emailController.clear();
              }

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
            },
            child: const Text("Reiniciar"),
          ),
        ],
      ),
    );
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      // BODY
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*// logo
                  Icon(
                    Icons.lock_open,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),*/

                  Container(
                    height: 80,
                    color: Theme.of(context).colorScheme.primary,
                    child: Image.asset('lib/assets/icon.png'),
                  ),

                  const SizedBox(height: 25),

                  // name of app
                  Text(
                    "COLECCION APP",
                    style: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // email textfield
                  MyTextfield(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // pw textfield
                  MyTextfield(
                    controller: pwController,
                    hintText: "Contraseña",
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // forgot pw
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => openForgotPasswordBox(),
                        child: Text(
                          "Olvidaste tu Contraseña?",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // login button
                  MyButton(
                    onTap: login,
                    text: "INICIAR SESIÓN",
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "O inicia sesión con",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // oath sign (apple + google)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // apple button
                      MyAppleSignInButton(
                        onTap: () async {
                          authCubit.signInWithApple();
                        },
                      ),

                      const SizedBox(width: 10),

                      // google button
                      MyGoogleSignInButton(
                        onTap: () async {
                          //authCubit.signInWithGoogle();
                        },
                      )
                    ],
                  ),

                  const SizedBox(height: 25),

                  // don't have an account? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No tienes una cuenta?",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      GestureDetector(
                        onTap: widget.togglePages,
                        child: Text(
                          " Registrate ahora",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}