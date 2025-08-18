# Guide d'Installation et de Déploiement de SafeAlert

Ce document fournit les instructions détaillées pour installer, configurer et déployer l'application SafeAlert sur différentes plateformes.

## Table des matières

1. [Prérequis](#prérequis)
2. [Installation de l'environnement de développement](#installation-de-lenvironnement-de-développement)
3. [Configuration de Firebase](#configuration-de-firebase)
4. [Configuration du projet Flutter](#configuration-du-projet-flutter)
5. [Déploiement sur Android](#déploiement-sur-android)
6. [Déploiement sur iOS](#déploiement-sur-ios)
7. [Déploiement sur le Web](#déploiement-sur-le-web)
8. [Configuration des services spécifiques](#configuration-des-services-spécifiques)
9. [Dépannage](#dépannage)

## Prérequis

- Compte Google pour la console Firebase
- Flutter SDK (version 3.0.0 ou supérieure)
- Dart SDK (version 2.17.0 ou supérieure)
- Android Studio (pour le développement Android)
- Xcode (pour le développement iOS, macOS uniquement)
- Visual Studio Code ou autre IDE (recommandé)
- Git
- Node.js et npm (pour les fonctions Firebase)

## Installation de l'environnement de développement

### 1. Installation de Flutter

```bash
# Télécharger Flutter SDK depuis https://flutter.dev/docs/get-started/install
# Extraire l'archive dans un dossier (par exemple ~/development)
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable
```

Ajoutez Flutter à votre PATH :

```bash
# Pour bash
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Pour zsh
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

Vérifiez l'installation :

```bash
flutter doctor
```

Suivez les instructions pour résoudre les problèmes identifiés par `flutter doctor`.

### 2. Installation des outils supplémentaires

```bash
# Installation de Firebase CLI
npm install -g firebase-tools

# Installation de FlutterFire CLI
dart pub global activate flutterfire_cli
```

## Configuration de Firebase

### 1. Création d'un projet Firebase

1. Accédez à la [console Firebase](https://console.firebase.google.com/)
2. Cliquez sur "Ajouter un projet"
3. Nommez votre projet "SafeAlert" (ou un autre nom de votre choix)
4. Activez Google Analytics si vous le souhaitez
5. Suivez les étapes pour créer le projet

### 2. Activation des services Firebase requis

Dans la console Firebase, activez les services suivants :

#### Authentication
1. Accédez à "Authentication" > "Sign-in method"
2. Activez les méthodes d'authentification :
   - Email/Mot de passe
   - Numéro de téléphone
   - Google (facultatif)

#### Firestore
1. Accédez à "Firestore Database"
2. Cliquez sur "Créer une base de données"
3. Choisissez le mode (production ou test)
4. Sélectionnez l'emplacement (europe-west1 recommandé pour le Sénégal)
5. Configurez les règles de sécurité comme indiqué dans le fichier `FIREBASE_SETUP.md`

#### Storage
1. Accédez à "Storage"
2. Cliquez sur "Commencer"
3. Choisissez le mode (production ou test)
4. Sélectionnez l'emplacement (europe-west1 recommandé pour le Sénégal)
5. Configurez les règles de sécurité comme indiqué dans le fichier `FIREBASE_SETUP.md`

#### Cloud Messaging
1. Accédez à "Messaging"
2. Configurez les notifications push pour Android et iOS

## Configuration du projet Flutter

### 1. Cloner le projet

```bash
git clone https://github.com/votre-organisation/safealert.git
cd safealert
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Configurer Firebase pour Flutter

```bash
# Connectez-vous à Firebase
firebase login

# Configurez Firebase pour votre projet Flutter
flutterfire configure --project=safealert-xxxx
```

Cette commande va :
- Vous demander de sélectionner votre projet Firebase
- Vous demander quelles plateformes configurer
- Générer automatiquement le fichier `firebase_options.dart`
- Configurer les fichiers nécessaires pour chaque plateforme

### 4. Vérifier la configuration

Assurez-vous que le fichier `lib/firebase_options.dart` a été correctement généré.

## Déploiement sur Android

### 1. Préparation du projet Android

```bash
# Ouvrir le projet dans Android Studio
cd android
```

### 2. Configuration du fichier build.gradle

Modifiez le fichier `android/app/build.gradle` pour définir :
- `applicationId` (doit correspondre à celui configuré dans Firebase)
- `minSdkVersion` (au moins 21 pour Firebase)
- `targetSdkVersion` et `compileSdkVersion` (33 ou supérieur recommandé)

### 3. Génération d'une clé de signature

```bash
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 4. Configuration de la signature

Créez un fichier `android/key.properties` :

```
storePassword=<mot de passe du keystore>
keyPassword=<mot de passe de la clé>
keyAlias=upload
storeFile=<chemin vers le fichier key.jks>
```

Modifiez `android/app/build.gradle` pour utiliser cette clé (voir la documentation Flutter pour les détails).

### 5. Construction de l'APK ou du bundle App

```bash
# Pour un APK de débogage
flutter build apk

# Pour un APK de production
flutter build apk --release

# Pour un bundle App (recommandé pour Google Play)
flutter build appbundle
```

## Déploiement sur iOS

### 1. Préparation du projet iOS (macOS uniquement)

```bash
# Ouvrir le projet dans Xcode
cd ios
open Runner.xcworkspace
```

### 2. Configuration du Bundle Identifier

Dans Xcode :
1. Sélectionnez le projet Runner
2. Onglet "General"
3. Assurez-vous que le "Bundle Identifier" correspond à celui configuré dans Firebase

### 3. Configuration des capacités

Dans Xcode :
1. Onglet "Signing & Capabilities"
2. Ajoutez les capacités :
   - Push Notifications
   - Background Modes (pour les notifications en arrière-plan)

### 4. Construction de l'application

```bash
# Pour un build de débogage
flutter build ios

# Pour un build de production
flutter build ios --release
```

Pour publier sur l'App Store, utilisez Xcode pour créer une archive et la soumettre.

## Déploiement sur le Web

### 1. Activation du support Web

```bash
flutter config --enable-web
```

### 2. Construction de l'application Web

```bash
flutter build web
```

### 3. Déploiement sur Firebase Hosting

```bash
# Initialiser Firebase Hosting
firebase init hosting

# Déployer l'application
firebase deploy --only hosting
```

## Configuration des services spécifiques

### Géolocalisation

1. Pour Android, ajoutez les permissions dans `android/app/src/main/AndroidManifest.xml` :
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

2. Pour iOS, ajoutez dans `ios/Runner/Info.plist` :
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Cette application a besoin d'accéder à votre position pour signaler des urgences à proximité.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Cette application a besoin d'accéder à votre position en arrière-plan pour vous alerter des urgences à proximité.</string>
```

### Notifications Push

1. Pour Android, configurez le fichier `android/app/src/main/AndroidManifest.xml` :
```xml
<meta-data
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="high_importance_channel" />
```

2. Pour iOS, générez un certificat APNs et configurez-le dans Firebase.

### Caméra et Galerie

1. Pour Android, ajoutez les permissions dans `android/app/src/main/AndroidManifest.xml` :
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

2. Pour iOS, ajoutez dans `ios/Runner/Info.plist` :
```xml
<key>NSCameraUsageDescription</key>
<string>Cette application a besoin d'accéder à votre caméra pour prendre des photos lors du signalement d'urgences.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Cette application a besoin d'accéder à votre galerie pour joindre des photos aux signalements d'urgences.</string>
```

## Dépannage

### Problèmes courants

1. **Erreur de compilation Android**: Vérifiez que le fichier `google-services.json` est au bon endroit et que les plugins sont correctement appliqués.

2. **Erreur de compilation iOS**: Vérifiez que le fichier `GoogleService-Info.plist` est correctement ajouté via Xcode.

3. **Erreur d'initialisation Firebase**: Vérifiez que le fichier `firebase_options.dart` est correctement généré et importé.

4. **Erreur d'authentification**: Vérifiez que les méthodes d'authentification sont activées dans la console Firebase.

5. **Erreur de règles Firestore/Storage**: Vérifiez les règles de sécurité dans la console Firebase.

### Ressources utiles

- [Documentation FlutterFire](https://firebase.flutter.dev/docs/overview)
- [Documentation Firebase](https://firebase.google.com/docs)
- [Documentation Flutter](https://flutter.dev/docs)
- [Groupe Flutter Firebase sur Discord](https://discord.gg/flutter)

Pour toute assistance supplémentaire, veuillez contacter l'équipe de support technique.
