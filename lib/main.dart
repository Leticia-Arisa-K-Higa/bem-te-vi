import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bem_te_vi/core/constants/app_strings.dart';
import 'package:bem_te_vi/core/providers/patient_form_provider.dart';
import 'package:bem_te_vi/core/providers/asia_form_provider.dart';
import 'package:bem_te_vi/presentation/screens/home_screen.dart';
import 'package:bem_te_vi/presentation/screens/asia_form_screen.dart';
import 'package:bem_te_vi/core/database/app_database.dart';

void main() {
  final AppDatabase database = AppDatabase();

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),

        ChangeNotifierProvider(create: (context) => PatientFormProvider()),
        ChangeNotifierProvider(create: (context) => AsiaFormProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: ThemeData(
          fontFamily: 'Inter',
          primaryColor: AppStrings.emeraldGreen,
          scaffoldBackgroundColor: AppStrings.lightBackground,

          appBarTheme: const AppBarTheme(
            backgroundColor: AppStrings.emeraldGreen,
            foregroundColor: Colors.white,
            elevation: 1,
          ),

          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.grey.shade600),
            filled: false,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppStrings.emeraldGreen,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 4.0,
            ),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStrings.emeraldGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 2,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ),

          datePickerTheme: DatePickerThemeData(
            headerBackgroundColor: AppStrings.emeraldGreen,
            headerForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          colorScheme: ColorScheme.fromSeed(
            seedColor: AppStrings.emeraldGreen,
            primary: AppStrings.emeraldGreen,
            background: AppStrings.lightBackground,
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/asia_form': (context) => const AsiaFormScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
