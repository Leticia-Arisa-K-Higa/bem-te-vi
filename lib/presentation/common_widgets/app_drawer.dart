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
            // Cor adaptada para o tema verde esmeralda
            decoration: BoxDecoration(color: AppStrings.emeraldGreen),
            child: Text(
              AppStrings.drawerHeader,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text(AppStrings.homeDrawerItem),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/') {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text(AppStrings.asiaFormDrawerItem),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer

              // Verifica se estamos na tela inicial. Se não estivermos, não sabemos
              // qual paciente usar, então não devemos ir para o formulário ASIA.
              if (ModalRoute.of(context)?.settings.name == '/') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Por favor, preencha os dados do paciente primeiro e clique em "Salvar e Continuar".',
                    ),
                  ),
                );
              } else {
                // Se o usuário já passou da tela inicial, é mais seguro voltar
                // para ela do que tentar ir para o formulário ASIA sem um ID.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Navegue a partir da tela de informações iniciais.',
                    ),
                  ),
                );
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.more_horiz),
            title: const Text(AppStrings.otherFormsDrawerItem),
            onTap: () {
              Navigator.pop(context);
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
