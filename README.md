# TaskGest

Une application CLI Dart pour gérer des tâches avec :

- ajout de tâches (titre, priorité, date limite optionnelle)
- affichage trié des tâches par priorité ou par date
- marquage d'une tâche comme terminée
- suppression d'une tâche
- persistance locale dans un fichier JSON

## Lancer l'application

Depuis le dossier `task_gest` :

```bash
dart run bin/task_gest.dart
```

## Utiliser l'application

Le menu propose :

1. Ajouter une nouvelle tâche
2. Lister toutes les tâches
3. Marquer une tâche comme terminée
4. Supprimer une tâche
5. Quitter

## Exécuter les tests

Depuis le dossier `task_gest` :

```bash
dart test
```

## Structure du projet

- `bin/task_gest.dart` : point d'entrée CLI
- `lib/src/models/` : définition des tâches et priorités
- `lib/src/repositories/` : persistance JSON
- `lib/src/services/` : logique métier
- `test/` : tests unitaires
