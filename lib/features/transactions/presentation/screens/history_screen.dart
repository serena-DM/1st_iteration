// Fichier : lib/features/transactions/presentation/screens/history_screen.dart
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Transactions'),
      ),
      body: const Center(
        child: Text('Écran de l\'historique complet'),
      ),
    );
  }
}
