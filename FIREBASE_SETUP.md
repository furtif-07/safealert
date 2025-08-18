# Guide d'intégration de Firebase dans le projet SafeAlert

Ce document explique comment configurer Firebase pour le projet SafeAlert sur toutes les plateformes (Android, iOS, Web).

## Prérequis

- Compte Google
- Projet Firebase créé sur la [console Firebase](https://console.firebase.google.com/)
- Flutter SDK installé (version 3.0.0 ou supérieure)
- Firebase CLI installé

## Étape 1: Créer un projet Firebase

1. Accédez à la [console Firebase](https://console.firebase.google.com/)
2. Cliquez sur "Ajouter un projet"
3. Nommez votre projet "SafeAlert" (ou un autre nom de votre choix)
4. Activez Google Analytics si vous le souhaitez
5. Suivez les étapes pour créer le projet

## Étape 2: Installer la CLI Firebase

```bash
npm install -g firebase-tools
```

## Étape 3: Configurer Flutter avec Firebase

### Méthode recommandée (FlutterFire CLI)

1. Installez la CLI FlutterFire:
```bash
dart pub global activate flutterfire_cli
```

2. Connectez-vous à Firebase:
```bash
firebase login
```

3. Configurez Firebase pour votre projet Flutter:
```bash
cd /chemin/vers/safealert_firebase
flutterfire configure --project=safealert-xxxx
```

Cette commande va:
- Vous demander de sélectionner votre projet Firebase
- Vous demander quelles plateformes configurer
- Générer automatiquement le fichier `firebase_options.dart`
- Configurer les fichiers nécessaires pour chaque plateforme

### Configuration manuelle (alternative)

Si vous ne pouvez pas utiliser la CLI FlutterFire, suivez ces étapes pour chaque plateforme:

#### Android

1. Dans la console Firebase, ajoutez une application Android:
   - Nom du package: `com.example.safealert` (à adapter selon votre configuration)
   - Surnom de l'application: "SafeAlert"
   - Certificat de signature de débogage SHA-1 (facultatif)

2. Téléchargez le fichier `google-services.json`

3. Placez le fichier dans `android/app/`

4. Modifiez `android/build.gradle`:
```gradle
buildscript {
  dependencies {
    // Ajouter cette ligne
    classpath 'com.google.gms:google-services:4.3.15'
  }
}
```

5. Modifiez `android/app/build.gradle`:
```gradle
apply plugin: 'com.android.application'
// Ajouter cette ligne
apply plugin: 'com.google.gms.google-services'
```

#### iOS

1. Dans la console Firebase, ajoutez une application iOS:
   - Bundle ID: `com.example.safealert` (à adapter selon votre configuration)
   - Surnom de l'application: "SafeAlert"

2. Téléchargez le fichier `GoogleService-Info.plist`

3. Placez le fichier dans `ios/Runner/` (via Xcode, pour préserver les références)

4. Modifiez `ios/Podfile` pour définir la version minimale:
```ruby
platform :ios, '12.0'
```

#### Web

1. Dans la console Firebase, ajoutez une application Web:
   - Surnom de l'application: "SafeAlert Web"

2. Notez les informations de configuration (apiKey, authDomain, etc.)

3. Créez ou modifiez le fichier `web/index.html` pour ajouter:
```html
<script src="https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js"></script>
<script>
  var firebaseConfig = {
    apiKey: "...",
    authDomain: "...",
    projectId: "...",
    storageBucket: "...",
    messagingSenderId: "...",
    appId: "..."
  };
  firebase.initializeApp(firebaseConfig);
</script>
```

## Étape 4: Activer les services Firebase nécessaires

Dans la console Firebase, activez les services suivants:

### Authentication
1. Accédez à "Authentication" > "Sign-in method"
2. Activez les méthodes d'authentification:
   - Email/Mot de passe
   - Numéro de téléphone
   - Google (facultatif)

### Firestore
1. Accédez à "Firestore Database"
2. Cliquez sur "Créer une base de données"
3. Choisissez le mode (production ou test)
4. Sélectionnez l'emplacement (europe-west1 recommandé pour le Sénégal)
5. Configurez les règles de sécurité:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Authentification requise pour toutes les opérations
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
    
    // Règles spécifiques pour les collections
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /alerts/{alertId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && (
        resource.data.reporter == request.auth.uid || 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'police', 'emergency']
      );
    }
    
    match /notifications/{notificationId} {
      allow read: if request.auth != null && 
        resource.data.recipients[request.auth.uid] != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'police', 'authority'];
    }
  }
}
```

### Storage
1. Accédez à "Storage"
2. Cliquez sur "Commencer"
3. Choisissez le mode (production ou test)
4. Sélectionnez l'emplacement (europe-west1 recommandé pour le Sénégal)
5. Configurez les règles de sécurité:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    match /users/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /alerts/{alertId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

### Cloud Functions (facultatif pour la première phase)
1. Accédez à "Functions"
2. Cliquez sur "Commencer"
3. Suivez les instructions pour configurer les fonctions Cloud

### Cloud Messaging
1. Accédez à "Messaging"
2. Configurez les notifications push pour Android et iOS

## Étape 5: Vérifier l'intégration

1. Assurez-vous que le fichier `firebase_options.dart` est correctement généré
2. Vérifiez que Firebase est initialisé dans `main.dart`
3. Testez la connexion à Firebase avec un simple test:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Test de connexion à Firestore
  try {
    await FirebaseFirestore.instance.collection('test').doc('test').set({
      'timestamp': FieldValue.serverTimestamp(),
    });
    print('Connexion à Firebase réussie!');
  } catch (e) {
    print('Erreur de connexion à Firebase: $e');
  }
  
  runApp(const SafeAlertApp());
}
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
- [Groupe Flutter Firebase sur Discord](https://discord.gg/flutter)
