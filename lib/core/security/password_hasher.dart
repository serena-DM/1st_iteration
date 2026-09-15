// core/security/password_hasher.dart

import 'dart:convert';

import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  final bytes = utf8.encode(password); // Convertir le mot de passe en bytes
  final digest = sha256.convert(bytes); // Appliquer l'algorithme SHA-256
  return digest.toString(); // Retourner le hash sous forme de chaîne
}
