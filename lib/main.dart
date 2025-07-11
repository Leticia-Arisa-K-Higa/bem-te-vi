// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bem_te_vi/core/constants/app_strings.dart';
import 'package:bem_te_vi/core/providers/patient_form_provider.dart';
import 'package:bem_te_vi/core/providers/asia_form_provider.dart';
import 'package:bem_te_vi/presentation/screens/home_screen.dart';
import 'package:bem_te_vi/presentation/screens/asia_form_screen.dart'; // Certifique-se de importar se AsiaFormScreen não for a home

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PatientFormProvider()),
        ChangeNotifierProvider(create: (context) => AsiaFormProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue, // Primary color para a app bar
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue, // Cor de fundo da AppBar
            foregroundColor: Colors.white, // Cor dos ícones e texto na AppBar
          ),
          // Adicione mais estilos de tema aqui para consistência
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/asia_form': (context) => const AsiaFormScreen(),
        },
      ),
    );
  }
}
