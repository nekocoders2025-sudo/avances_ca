import 'package:coleccion_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:coleccion_app/features/collections/presentation/collections_tile.dart';
import 'package:coleccion_app/features/moderation/presentation/pages/blocked_users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


/*
PÁGINA MIS COLECCIONES
--------------------------------------------------------------------------------
*/

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  // confirm with user account deletion
  void confirmAccountDeletion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Borrar Cuenta?"),
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
              handleAccountDeletion();
            },
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  // handle account deletion
  void handleAccountDeletion() async {
    try {
      // show loading..
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // delete account
      final authCubit = context.read<AuthCubit>();
      await authCubit.deleteAccount();

      // done loading -> after deletion -> navigated to auth page
      if (mounted) {
        Navigator.pop(context); // remove loading circle
        Navigator.pop(context); // remove settings page
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Colecciones"),

        //Botón Nueva Colección
        actions: [
          IconButton(
            onPressed: handleAddPost,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      
      body: Column(
        children: [
          // delete account
          MyCollectionsTile(
            title: "Borrar Cuenta",
            action: IconButton(
              onPressed: confirmAccountDeletion,
              icon: const Icon(Icons.delete_forever),
            ),
          ),

          // blocked users
          MyCollectionsTile(
            title: "Usuarios Bloqueados",
            action: IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BlockedUsersPage(),
                  )),
              icon: const Icon(Icons.block),
            ),
          ),
        ],
      ),
    );
  }
}