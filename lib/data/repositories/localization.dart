import 'package:flutter/material.dart';

class LocalizationRepo extends ChangeNotifier {
  String _languageCode = 'en';

  String get languageCode => _languageCode;

  static const List<String> languages = ['en', 'fr'];

  void setLanguage(String languageCode) {
    if (languages.contains(languageCode)) {
      _languageCode = languageCode;
      notifyListeners();
    }
  }

  String getText(String key) => _translationsMap[key]?[_languageCode] ?? '';

  static const Map<String, Map<String, String>> _translationsMap = {
    'a0s9d8f7': {'en': 'Welcome', 'fr': 'Bienvenue'},
    'vgy7r5x2': {'en': 'No contact', 'fr': 'Aucun contact'},
    'creat001': {'en': 'Create Contact', 'fr': 'Créer un contact'},
    'edit0001': {'en': 'Edit Contact', 'fr': 'Modifier le contact'},
    'required': {'en': 'Required', 'fr': 'Obligatoire'},
    'invalidemail': {'en': 'Invalid Email', 'fr': 'Email non valide'},
    'save': {'en': 'Save', 'fr': 'Sauvegarder'},
    'firstname': {'en': 'First Name', 'fr': 'Prénom'},
    'lastname': {'en': 'Last Name', 'fr': 'Nom'},
    'phone': {'en': 'Phone Number', 'fr': 'Numéro de téléphone'},
    'email': {'en': 'Email', 'fr': 'E-mail'},
    'address': {'en': 'Address', 'fr': 'Adresse'},
    'delconta': {'en': 'Delete Contact', 'fr': 'Supprimer le contact'},
    'confdelc': {
      'en': 'Are you sure to delete?',
      'fr': 'Êtes-vous sûr de vouloir supprimer ?',
    },
    'cancel': {'en': 'Cancel', 'fr': 'Annuler'},
    'delete': {'en': 'Delete', 'fr': 'Supprimer'},
    'detacont': {'en': 'Contact Details', 'fr': 'Détails du contact'},
    'convsms': {'en': 'SMS with', 'fr': 'SMS avec'},
    'entermsg': {'en': 'Enter your message', 'fr': 'Entrez votre message'},
    'nosmsfound': {'en': 'No SMS found', 'fr': 'Aucun SMS trouvé'},
    'chooseclr': {'en': 'Choose color', 'fr': 'Choisir la couleur'},
    'lastbg': {
      'en': 'Last time in background',
      'fr': 'Dernier passage en arrière-plan',
    },
    'call': {'en': 'Call', 'fr': 'Appeler'},
    'call_error': {
      'en': 'Cannot make a call',
      'fr': 'Impossible de passer l\'appel',
    },
  };
}
