import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              AppStrings.drawerHeader,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text(AppStrings.homeDrawerItem),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              Navigator.pushReplacementNamed(
                context,
                '/',
              ); // Volta para a tela inicial
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text(AppStrings.asiaFormDrawerItem),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              Navigator.pushNamed(
                context,
                '/asia_form',
              ); // Navega para o formulário ASIA
            },
          ),
          ListTile(
            leading: const Icon(Icons.more_horiz),
            title: const Text(AppStrings.otherFormsDrawerItem),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Outros formulários em desenvolvimento!'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
