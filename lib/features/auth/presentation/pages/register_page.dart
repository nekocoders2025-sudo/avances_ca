import 'package:coleccion_app/features/auth/presentation/components/my_button.dart';
import 'package:coleccion_app/features/auth/presentation/components/my_textfield.dart';
import 'package:coleccion_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;

  const RegisterPage({super.key, required this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final confirmPwController = TextEditingController();

  // register button pressed
  void register() async {
    // prepare info
    final String name = nameController.text;
    final String email = emailController.text;
    final String pw = pwController.text;
    final String confirmPw = confirmPwController.text;

    // auth cubit
    final authCubit = context.read<AuthCubit>();

    // ensure fields aren't empty
    if (email.isNotEmpty &&
        name.isNotEmpty &&
        pw.isNotEmpty &&
        confirmPw.isNotEmpty) {
      // ensure pw match
      if (pw == confirmPw) {
        authCubit.register(name, email, pw);
      }

      // pw doesn't match
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Las contraseñas no coinciden!")));
      }
    }
    // fields are empty -> display error
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor llena todos los campos!")));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    pwController.dispose();
    confirmPwController.dispose();
    super.dispose();
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      // BODY
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Container(
                  height: 80,
                  color: Theme.of(context).colorScheme.primary,
                  child: Image.asset('lib/assets/icon.png'),
                ),

                const SizedBox(height: 25),

                // name of app
                Text(
                  "Crea una cuenta nueva",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),

                const SizedBox(height: 25),

                // name textfield
                MyTextfield(
                  controller: nameController,
                  hintText: "Nombre",
                  obscureText: false,
                ),

                const SizedBox(height: 10),

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

                // confirm pw textfield
                MyTextfield(
                  controller: confirmPwController,
                  hintText: "Confirmar Contraseña",
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // register button
                MyButton(
                  onTap: register,
                  text: "REGISTRARSE",
                ),

                const SizedBox(height: 25),

                // oath sign in later.. (google + apple)

                // already have an account? login now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ya tienes una cuenta?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        " Inicia sesión ahora",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}