import 'package:etoanko_pay/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF0D47A1);
  static const Color accent = Color(0xFF4CAF50);
  static const Color background = Color(0xFFF5F5F5);
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);
  static const Color white = Colors.white;
}

void main() {
  // Garantit que le moteur Flutter est prêt avant de lancer l'application
  WidgetsFlutterBinding.ensureInitialized();

  // LE PROVIDERSCOPE EST OBLIGATOIREMENT ICI, AU SOMMET ABSOLU
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Etoanko-Pay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.copyWith(
                displayLarge: const TextStyle(
                    color: AppColors.textDark, fontWeight: FontWeight.bold),
                displayMedium: const TextStyle(
                    color: AppColors.textDark, fontWeight: FontWeight.bold),
                headlineMedium: const TextStyle(
                    color: AppColors.textDark, fontWeight: FontWeight.bold),
                titleLarge: const TextStyle(
                    color: AppColors.textDark, fontWeight: FontWeight.w600),
                bodyLarge: const TextStyle(color: AppColors.textLight),
                bodyMedium: const TextStyle(color: AppColors.textLight),
              ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          labelStyle: const TextStyle(color: AppColors.textLight),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.white,
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
