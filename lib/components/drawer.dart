import 'package:coleccion_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:coleccion_app/features/profile/profile_page.dart';
import 'package:coleccion_app/features/settings/presentation/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  // logout
  void logout(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    authCubit.logout();
  }

  // confirm logout
  void confirmLogout(BuildContext context) {
    // pop drawer first
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar Sesión?"),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),

          // yes button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              logout(context);
            },
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // DRAWER
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // header icon
            Container(
              height: 80,
              color: Theme.of(context).colorScheme.primary,
              child: Image.asset('lib/assets/icon.png'),
            ),

            Divider(
              color: Theme.of(context).colorScheme.tertiary,
              indent: 25,
              endIndent: 25,
            ),

            const SizedBox(height: 25),

            // home tile
            MyDrawerTile(
              text: "Inicio",
              icon: Icons.home,
              onTap: () => Navigator.pop(context),
            ),

            // profile tile
            MyDrawerTile(
              text: "Mi Perfil",
              icon: Icons.person,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
            ),

            // settings tile
            MyDrawerTile(
              text: "Configuración",
              icon: Icons.settings,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),

            const Spacer(),

            // logout tile
            MyDrawerTile(
              text: "Cerrar Sesión",
              icon: Icons.logout,
              onTap: () => confirmLogout(context),
            ),
          ],
        ),
      ),
    );
  }
}