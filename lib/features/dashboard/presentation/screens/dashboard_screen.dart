import 'package:etoanko_pay/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:etoanko_pay/features/transactions/presentation/screens/charge_screen.dart';
import 'package:etoanko_pay/features/transactions/presentation/screens/history_screen.dart';
import 'package:etoanko_pay/features/transactions/presentation/screens/payout_screen.dart';
import 'package:etoanko_pay/features/transactions/presentation/screens/transfer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Tableau de Bord',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Theme.of(context).primaryColor),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, ref),
            const SizedBox(height: 24),
            _buildBalanceCard(context, ref),
            const SizedBox(height: 24),
            _buildActions(context),
            const SizedBox(height: 32),
            _buildRecentTransactions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    return userAsync.when(
      data: (user) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bonjour,', style: Theme.of(context).textTheme.titleLarge),
          Text(
            user?['name'] ?? 'Utilisateur',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const Text('Erreur de chargement'),
    );
  }

  Widget _buildBalanceCard(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(balanceProvider);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Solde Actuel',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
            ),
            const SizedBox(height: 8),
            balanceAsync.when(
              data: (balance) => Text(
                '${balance.toStringAsFixed(0)} FCFA',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
              loading: () => const SizedBox(
                height: 48,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
              error: (err, stack) => Text(
                'Erreur',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.red,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionItem(
          context,
          icon: Icons.account_balance_wallet_outlined,
          label: 'Recharger',
          onTap: () => _navigateTo(context, const ChargeScreen()),
        ),
        _buildActionItem(
          context,
          icon: Icons.arrow_downward_outlined,
          label: 'Retrait',
          onTap: () => _navigateTo(context, const PayoutScreen()),
        ),
        _buildActionItem(
          context,
          icon: Icons.swap_horiz_outlined,
          label: 'Transférer',
          onTap: () => _navigateTo(context, const TransferScreen()),
        ),
      ],
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child:
                  Icon(icon, size: 30, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  // CORRECTION DE L'OVERFLOW ICI
  Widget _buildRecentTransactions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Remplacement du Row par un Column pour éviter l'overflow
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Transactions Récentes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _navigateTo(context, const HistoryScreen()),
              child: const Text('Voir tout'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTransactionTile(
          context,
          Icons.arrow_upward,
          'Transfert à Jane Doe',
          '15 Juin 2023',
          '- 5,000 FCFA',
          Colors.red,
        ),
        const Divider(),
        _buildTransactionTile(
          context,
          Icons.arrow_downward,
          'Dépôt Orange Money',
          '14 Juin 2023',
          '+ 50,000 FCFA',
          Colors.green,
        ),
        const Divider(),
        _buildTransactionTile(
          context,
          Icons.arrow_upward,
          'Paiement ENEO',
          '12 Juin 2023',
          '- 12,500 FCFA',
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildTransactionTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String amount,
    Color amountColor,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: amountColor, size: 28),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: amountColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
