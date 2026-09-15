
## Pour commencer

Instructions pour configurer et lancer le projet sur votre machine locale.

### Prérequis

-   [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.x ou supérieure)
-   Un éditeur de code comme [VS Code](https://code.visualstudio.com/) ou [Android Studio](https://developer.android.com/studio).
-   Un émulateur Android ou un appareil physique.

### Installation et Lancement

1.  **Clonez le dépôt** :
    ```sh
    git clone <URL_DU_DEPOT>
    cd etoanko_pay
    ```

2.  **Installez les dépendances** :
    Cette commande télécharge tous les paquets nécessaires au projet.
    ```sh
    flutter pub get
    ```

3.  **Générez l'icône et le splash screen** (si vous modifiez le logo) :
    ```sh
    flutter pub run flutter_launcher_icons:main
    flutter pub run flutter_native_splash:create
    ```

4.  **Lancez l'application** :
    ```sh
    flutter run
    ```

### Workflow de Développement Rapide

Une fois l'application lancée avec `flutter run`, ne quittez pas le processus. Utilisez les commandes suivantes dans le terminal pour des mises à jour quasi-instantanées :

-   Appuyez sur **`r`** (minuscule) pour effectuer un **Hot Reload** (recharge l'UI en moins d'une seconde).
-   Appuyez sur **`R`** (majuscule) pour effectuer un **Hot Restart** (redémarre l'application en quelques secondes).

## Dépendances Clés

-   `google_fonts`: Pour utiliser des polices personnalisées depuis Google Fonts.
-   `flutter_svg`: Pour afficher des images au format SVG.
-   `sqflite` & `path`: Pour la gestion de la base de données locale SQLite.
-   `flutter_secure_storage`: Pour stocker de manière sécurisée les jetons de session.
-   `crypto`: Pour le hachage des mots de passe et des PINs.
-   `flutter_launcher_icons`: Pour générer l'icône de l'application.
-   `flutter_native_splash`: Pour générer l'écran de démarrage.

## Feuille de Route (Prochaines Étapes)

1.  **Logique d'Authentification** : Connecter l'UI aux fonctions de la base de données pour l'inscription et la connexion.
2.  **Gestion de Session** : Utiliser `flutter_secure_storage` pour maintenir l'utilisateur connecté.
3.  **Implémentation des Transactions** : Coder la logique pour les dépôts, retraits et transferts (simulation locale).
4.  **Affichage des Données** : Lier le tableau de bord et l'historique aux données de la base de données.

---