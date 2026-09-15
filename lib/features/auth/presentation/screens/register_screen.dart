// Fichier : lib/features/auth/presentation/screens/register_screen.dart

import 'package:etoanko_pay/core/db/database_helper.dart';
import 'package:etoanko_pay/core/security/password_hasher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _termsAccepted = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Veuillez accepter les conditions générales.')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Les mots de passe ne correspondent pas.')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (_pinController.text != _confirmPinController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Les codes PIN ne correspondent pas.')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      try {
        final String passwordHash = hashPassword(_passwordController.text);
        final String pinHash = hashPassword(_pinController.text);

        final user = {
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': '+237' + _phoneController.text,
          'password_hash': passwordHash,
          'pin_hash': pinHash,
        };

        final dbHelper = DatabaseHelper.instance;
        await dbHelper.insertUser(user);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Compte créé avec succès ! Vous pouvez vous connecter.')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création du compte: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Conditions Générales d'Utilisation"),
          content: const SingleChildScrollView(
            child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                "Pellentesque et euismod magna. Mauris viverra, felis id "
                "ultrices fringilla, elit ex finibus erat, non varius est "
                "risus et est. Sed vitae est et nibh maximus semper. "
                "Vivamus et arcu ante. In hac habitasse platea dictumst. "
                "Integer vitae dolor quis elit pulvinar pellentesque. "
                "Curabitur sit amet est enim. Donec vel magna at turpis "
                "placerat commodo. Ut sed dolor id sem ultricies consequat. "
                "Donec nec justo eu arcu tincidunt sodales. Fusce eget "
                "tincidunt nisl. Sed vel dolor et nisi auctor viverra eu "
                "nec quam. Praesent id lorem eu urna tincidunt dapibus. \n\n"
                "Aliquam erat volutpat. Nulla facilisi. Proin feugiat "
                "diam eu nisl congue, sit amet aliquam sapien bibendum. "
                "Nam auctor, quam non lacinia consequat, elit magna "
                "aliquam nunc, vel bibendum est leo sit amet quam. "
                "Sed quis nisl nec enim venenatis laoreet. Integer non "
                "neque nec dui aliquam consectetur. Duis ac turpis "
                "vitae nulla posuere tincidunt. Maecenas sed elit eu "
                "nibh tristique aliquam. Nam nec felis at nunc "
                "consequat tristique. Vivamus vel libero et nisl "
                "ultricies tincidunt. Sed nec elit ut eros "
                "consectetur tristique. Phasellus at elit nec "
                "libero tincidunt aliquam."),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Fermer"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un compte'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom complet'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer votre nom' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer votre email' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                    labelText: 'Téléphone', prefixText: '+237 '),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer votre téléphone' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) => value!.length < 8
                    ? 'Le mot de passe doit faire 8 caractères min.'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                    labelText: 'Confirmer le mot de passe'),
                obscureText: true,
                validator: (value) => value!.isEmpty
                    ? 'Veuillez confirmer le mot de passe'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _pinController,
                decoration:
                    const InputDecoration(labelText: 'Code PIN (4 chiffres)'),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                validator: (value) =>
                    value!.length < 4 ? 'Le PIN doit faire 4 chiffres' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPinController,
                decoration:
                    const InputDecoration(labelText: 'Confirmer le PIN'),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez confirmer le PIN' : null,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "J'accepte les ",
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Conditions Générales',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _showTermsDialog,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _registerUser,
                      child: const Text('CRÉER MON COMPTE'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
