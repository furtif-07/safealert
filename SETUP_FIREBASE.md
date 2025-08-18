# SafeAlert - Instructions de Configuration

## Configuration Firebase

### 1. Créer un projet Firebase
1. Allez sur [Firebase Console](https://console.firebase.google.com/)
2. Créez un nouveau projet nommé "safealert"
3. Activez Google Analytics (optionnel)

### 2. Configurer l'authentification
1. Dans Firebase Console, allez dans "Authentication"
2. Activez les méthodes de connexion :
   - Email/Mot de passe
   - Téléphone (optionnel)

### 3. Configurer Firestore
1. Allez dans "Firestore Database"
2. Créez une base de données en mode test
3. Configurez les règles de sécurité :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Règles pour les utilisateurs
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Règles pour les alertes
    match /alerts/{alertId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && request.auth.uid == resource.data.reporterId;
      allow update: if request.auth != null && 
        (request.auth.uid == resource.data.reporterId || 
         request.auth.uid in resource.data.assignedToIds);
    }
    
    // Règles pour les notifications
    match /notifications/{notificationId} {
      allow read: if request.auth != null && 
        request.auth.uid in resource.data.recipients[].userId;
      allow write: if request.auth != null;
    }
  }
}
```

### 4. Configurer Storage
1. Allez dans "Storage"
2. Configurez les règles de sécurité :

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /alerts/{alertId}/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 5. Configurer Cloud Messaging
1. Allez dans "Cloud Messaging"
2. Générez une clé de serveur pour les notifications push

### 6. Configurer les applications
1. Ajoutez une application Android avec le package `com.example.safealert`
2. Ajoutez une application iOS avec le bundle ID `com.example.safealert`
3. Téléchargez les fichiers de configuration :
   - `google-services.json` pour Android (placez dans `android/app/`)
   - `GoogleService-Info.plist` pour iOS (placez dans `ios/Runner/`)

### 7. Mettre à jour firebase_options.dart
Remplacez le contenu de `lib/firebase_options/firebase_options.dart` avec la configuration générée par FlutterFire CLI :

```bash
flutter pub global activate flutterfire_cli
flutterfire configure
```

## Installation des dépendances

```bash
flutter pub get
```

## Configuration des permissions

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Cette application a besoin d'accéder à votre localisation pour créer des alertes géolocalisées.</string>
<key>NSCameraUsageDescription</key>
<string>Cette application a besoin d'accéder à la caméra pour prendre des photos d'alertes.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Cette application a besoin d'accéder au microphone pour enregistrer des messages audio.</string>
```

## Lancement de l'application

```bash
flutter run
```

## Fonctionnalités implémentées

### ✅ Complètement implémentées
- Architecture Clean Architecture avec BLoC
- Authentification (email/mot de passe)
- Interface utilisateur responsive
- Navigation entre les pages
- Thème clair/sombre
- Splash screen avec animations
- Onboarding
- Formulaires de connexion/inscription
- Page d'accueil avec navigation par onglets
- Création d'alertes avec géolocalisation
- Gestion des types d'alertes
- Services Firebase (Auth, Firestore, Storage)

### 🚧 Partiellement implémentées
- Notifications push (structure créée, nécessite configuration FCM)
- Géolocalisation (intégrée dans création d'alertes)
- Gestion des médias (structure créée)

### ❌ À implémenter
- Cloud Functions pour la logique backend
- Recherche géospatiale avancée
- Tableau de bord administrateur
- Chat en temps réel
- Notifications en temps réel
- Tests unitaires et d'intégration

## Structure du projet

```
lib/
├── core/                 # Configuration et utilitaires
│   ├── config/          # Configuration de l'app
│   ├── constants/       # Constantes et thèmes
│   └── utils/           # Utilitaires
├── data/                # Implémentations des repositories
├── domain/              # Entités et interfaces
├── presentation/        # UI et logique de présentation
│   ├── bloc/           # BLoC pour la gestion d'état
│   ├── pages/          # Pages de l'application
│   └── widgets/        # Widgets réutilisables
├── services/           # Services Firebase
└── main.dart           # Point d'entrée
```

## Prochaines étapes

1. **Configuration Firebase complète** : Remplacer les clés de démonstration par vos vraies clés Firebase
2. **Cloud Functions** : Implémenter les fonctions serverless pour la logique métier
3. **Tests** : Ajouter des tests unitaires et d'intégration
4. **Optimisations** : Améliorer les performances et l'UX
5. **Déploiement** : Préparer pour la production

## Support

Pour toute question ou problème, consultez la documentation Firebase et Flutter officielle.