// lib/features/auth/presentation/screens/terms_conditions_screen.dart

import 'package:flutter/material.dart';
// IMPORT IMPORTANT: On importe notre nouvel écran
import 'package:etoanko_pay/features/auth/presentation/screens/register_screen.dart';

class TermsConditionsScreen extends StatefulWidget {
  // On retire le "const" ici car le widget n'est plus constant
  TermsConditionsScreen({Key? key}) : super(key: key);

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  bool _hasAgreed = false;

  void _navigateToRegisterScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const RegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conditions Générales d'Utilisation"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              child: Card(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Bienvenue sur Etoanko-Pay.\n\n"
                      "En utilisant nos services, vous acceptez ces conditions. Veuillez les lire attentivement.\n\n"
                      "1. Votre Compte Etoanko-Pay\n"
                      "Vous pourriez avoir besoin d'un compte Etoanko-Pay pour utiliser certains de nos services. Vous êtes responsable de l'activité qui se déroule sur votre compte et de la protection de votre mot de passe.\n\n"
                      "2. Transactions\n"
                      "Toutes les transactions - recharges, retraits, transferts - sont soumises aux frais et délais indiqués dans l'application. Etoanko-Pay agit comme un intermédiaire et n'est pas responsable des échecs de transaction dus à des informations incorrectes ou à des problèmes avec les opérateurs de téléphonie mobile (MTN, Orange).\n\n"
                      "3. Confidentialité\n"
                      "Nous nous engageons à protéger vos données personnelles. Votre mot de passe est chiffré et nous ne le stockons jamais en clair. Vos informations de transaction sont utilisées uniquement pour fournir et améliorer le service.\n\n"
                      "En cochant cette case, vous confirmez avoir lu, compris et accepté l'ensemble de ces conditions générales d'utilisation."),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _hasAgreed,
                  onChanged: (value) {
                    setState(() {
                      _hasAgreed = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child:
                      Text("Je confirme avoir lu et j'accepte les conditions."),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _hasAgreed
                  // MISE À JOUR ICI : on appelle la fonction de navigation
                  ? _navigateToRegisterScreen
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Continuer"),
            ),
          ],
        ),
      ),
    );
  }
}
