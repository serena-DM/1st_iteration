# 💳 Etoanko-Pay Mobile (Flutter)

Application mobile financière de la plateforme **Etoanko-Pay** (`https://etoanko-pay.arited.org`).  
Développée en **Flutter / Dart**, cette première version (v1.0) est un prototype fonctionnel complet fonctionnant en **mode simulation locale avec persistance SQLite**.

---

## 📸 Aperçu des Écrans

| Écran de Connexion | Écran d'Inscription | Tableau de Bord |
| :---: | :---: | :---: |
| Connexion sécurisée | Validation téléphone (+237) & PIN | Solde réactif & actions rapides |

| Recharger (Dépôt) | Retrait (Payout) | Transférer |
| :---: | :---: | :---: |
| Choix Orange / MTN | Vérification solde insuffisant | Validation par Code PIN |

---

## 🛠️ Stack Technique & Dépendances

- **Framework** : Flutter (SDK ^3.x)
- **Langage** : Dart
- **Gestion d'état (State Management)** : `flutter_riverpod` (v2.x) — Réactivité en temps réel
- **Base de données locale** : `sqflite` + `path` — Persistance SQLite locale
- **Sécurité** : `crypto` (Hachage SHA-256 des mots de passe et PINs) + `flutter_secure_storage`
- **Design & UI** : `google_fonts` (Poppins), `flutter_svg`, `cupertino_icons`

---

## 📂 Architecture du Projet

Le projet suit une architecture **Clean Architecture par Fonctionnalité (Feature-First)** :

lib/
├── core/ # Code partagé et réutilisable
│ ├── api/
│ │ └── api_config.dart # Configuration des URLs et constantes API
│ ├── db/
│ │ └── database_helper.dart # Gestionnaire SQLite Singleton (Tables & CRUD)
│ └── security/
│ └── password_hasher.dart # Utilitaire de hachage SHA-256
│
├── features/ # Fonctionnalités découpées par domaine
│ ├── auth/ # Authentification & Inscription
│ │ ├── data/
│ │ ├── domain/
│ │ └── presentation/
│ │ └── screens/
│ │ ├── login_screen.dart # Écran de connexion
│ │ └── register_screen.dart# Inscription avec CGU et validation
│ │
│ ├── dashboard/ # Tableau de bord principal
│ │ └── presentation/
│ │ ├── providers/
│ │ │ └── dashboard_providers.dart # Providers Riverpod pour solde & profil
│ │ └── screens/
│ │ └── dashboard_screen.dart # Écran principal avec solde dynamique
│ │
│ └── transactions/ # Opérations financières
│ └── presentation/
│ └── screens/
│ ├── charge_screen.dart # Dépôt / Recharge (Orange / MTN)
│ ├── payout_screen.dart # Retrait avec contrôle du solde
│ ├── transfer_screen.dart# Transfert d'argent entre comptes
│ └── history_screen.dart # Historique des transactions
│
└── main.dart # Point d'entrée de l'application & Thème

text


---

## 🗄️ Schéma de la Base de Données Locale (SQLite)

La base de données SQLite s'appelle `EtoankoPay.db` et comporte deux tables principales :

### Table `users`
| Champ | Type | Description |
| :--- | :--- | :--- |
| `id` | `INTEGER` | Clé primaire (Auto-incrément) |
| `name` | `TEXT` | Nom complet de l'utilisateur |
| `email` | `TEXT` | Adresse email (Unique) |
| `phone` | `TEXT` | Numéro au format `+2376XXXXXXXX` (Unique) |
| `password_hash` | `TEXT` | Mot de passe haché en SHA-256 |
| `pin_hash` | `TEXT` | Code PIN à 4 chiffres haché en SHA-256 |
| `balance` | `REAL` | Solde du compte (par défaut `0.0`) |
| `created_at` | `TIMESTAMP` | Date de création |

### Table `transactions`
| Champ | Type | Description |
| :--- | :--- | :--- |
| `id` | `INTEGER` | Clé primaire |
| `user_id` | `INTEGER` | Clé étrangère vers `users(id)` |
| `type` | `TEXT` | Type : `'charge'`, `'payout'`, `'transfer'` |
| `amount` | `REAL` | Montant de la transaction en FCFA |
| `recipient_phone`| `TEXT` | Numéro du destinataire (si transfert/retrait) |
| `description` | `TEXT` | Description lisible |
| `status` | `TEXT` | Statut (`'completed'`, `'pending'`, `'failed'`) |
| `created_at` | `TIMESTAMP` | Horodatage de l'opération |

---

## 🚀 Guide de Démarrage Rapide

### Prérequis
1. **Flutter SDK** (v3.10 ou supérieure) installé.
2. Un émulateur Android/iOS ou un appareil physique connecté.
3. VS Code ou Android Studio.

### Installation

1. **Cloner le dépôt** :
   ```bash
   git clone <URL_DU_DEPOT_GIT>
   cd etoanko_pay

    Installer les dépendances :

    Bash

    flutter pub get

    Lancer le projet :

    Bash

    flutter run

