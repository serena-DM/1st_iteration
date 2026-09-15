import 'package:etoanko_pay/core/db/database_helper.dart';
import 'package:etoanko_pay/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _performTransfer() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final amount = double.tryParse(_amountController.text);
      if (amount == null || amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Montant invalide.')),
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
              content: Text('Solde insuffisant.'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isLoading = false);
          return;
        }

        // Débiter le solde
        await db.updateUserBalance(1, -amount);

        // Enregistrer la transaction
        await db.insertTransaction({
          'user_id': 1,
          'type': 'transfer',
          'amount': amount,
          'recipient_phone': '+237${_phoneController.text}',
          'description': 'Transfert vers +237${_phoneController.text}',
          'status': 'completed',
        });

        ref.invalidate(balanceProvider);
        ref.invalidate(currentUserProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Transfert de $amount FCFA effectué !'),
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
      appBar: AppBar(title: const Text('Transférer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Envoyez de l\'argent à un autre utilisateur.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Numéro du destinataire',
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
              const SizedBox(height: 20),
              TextFormField(
                controller: _pinController,
                decoration: const InputDecoration(
                  labelText: 'Votre Code PIN',
                  prefixIcon: Icon(Icons.lock),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Veuillez entrer votre PIN';
                  if (value.length != 4) return 'Le PIN doit faire 4 chiffres';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _performTransfer,
                      child: const Text('CONFIRMER LE TRANSFERT'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
