import 'package:etoanko_pay/core/db/database_helper.dart';
import 'package:etoanko_pay/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PayoutScreen extends ConsumerStatefulWidget {
  const PayoutScreen({super.key});

  @override
  ConsumerState<PayoutScreen> createState() => _PayoutScreenState();
}

class _PayoutScreenState extends ConsumerState<PayoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedOperator = 'Orange';
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _performPayout() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final amount = double.tryParse(_amountController.text);
      if (amount == null || amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez entrer un montant valide.')),
        );
        setState(() => _isLoading = false);
        return;
      }

      try {
        final db = DatabaseHelper.instance;
        final user = await db.getUserById(1);
        final currentBalance = user?['balance'] ?? 0.0;

        if (currentBalance < amount) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Solde insuffisant pour effectuer ce retrait.'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isLoading = false);
          return;
        }

        // Débiter le solde (montant négatif)
        await db.updateUserBalance(1, -amount);

        // Enregistrer la transaction
        await db.insertTransaction({
          'user_id': 1,
          'type': 'payout',
          'amount': amount,
          'recipient_phone': '+237${_phoneController.text}',
          'description': 'Retrait via $_selectedOperator Money',
          'status': 'completed',
        });

        ref.invalidate(balanceProvider);
        ref.invalidate(currentUserProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Retrait de $amount FCFA effectué avec succès !'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Retrait')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Retirez de l\'argent vers votre compte mobile.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text('Opérateur :', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildOperatorChip(
                        'Orange', Icons.phone_android, Colors.orange),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildOperatorChip(
                        'MTN', Icons.phone_android, Colors.yellow.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Numéro de téléphone',
                  prefixText: '+237 ',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Veuillez entrer un numéro';
                  if (value.length != 9)
                    return 'Le numéro doit faire 9 chiffres';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Montant (FCFA)',
                  prefixIcon: Icon(Icons.money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Veuillez entrer un montant';
                  if (double.tryParse(value) == null) return 'Montant invalide';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _performPayout,
                      child: const Text('CONFIRMER LE RETRAIT'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOperatorChip(String label, IconData icon, Color color) {
    final isSelected = _selectedOperator == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedOperator = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
