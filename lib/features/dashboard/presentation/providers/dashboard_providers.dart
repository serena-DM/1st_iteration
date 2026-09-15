// Fichier: lib/features/dashboard/presentation/providers/dashboard_providers.dart

import 'package:etoanko_pay/core/db/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider pour l'utilisateur actuellement connecté (SIMULATION)
// Pour l'instant, on prend le premier utilisateur de la base de données.
final currentUserProvider = FutureProvider.autoDispose((ref) async {
  final db = DatabaseHelper.instance;
  // NOTE: Dans une vraie application, on lirait l'ID de l'utilisateur stocké
  // dans flutter_secure_storage après la connexion.
  return await db
      .getUserById(1); // On suppose que l'ID de notre utilisateur est 1.
});

// Provider pour le solde, qui dépend de l'utilisateur actuel
final balanceProvider = FutureProvider.autoDispose<double>((ref) async {
  // On "surveille" le provider de l'utilisateur. Si l'utilisateur change, ce provider se mettra à jour.
  final userAsyncValue = ref.watch(currentUserProvider);

  // Le .when est une manière propre de gérer les états (chargement, erreur, données)
  return userAsyncValue.when(
    data: (user) => user?['balance'] ?? 0.0,
    loading: () => 0.0, // Solde affiché pendant le chargement
    error: (_, __) => -1.0, // Valeur en cas d'erreur
  );
});
