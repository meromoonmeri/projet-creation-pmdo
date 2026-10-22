# Régression Nouvelle Partie — diagnostic et restauration prioritaire

**Verdict : `PASS_NORMAL_NEW_ERA_STARTUP_RESTORED`**

Cette correction est prioritaire sur le port de Sinister Woods. Aucun fichier des chapitres 1 à 5, aucun Ground/tile certifié, aucune route FugitiveArc et aucune intégration historique protégée n’a été modifié.

## Cause exacte

### 1. Fuite visible de MissingNo — `NEW_ERA_NATIVE`

`Data/StartParams.xml` possède historiquement une liste `StartChars` vide et utilise `DefaultMonster=missingno` comme **sentinelle interne de création**. Le menu Nouvelle Partie crée cette sentinelle avant d’appeler les scripts New Era. Ce n’est pas un Pokémon à remplacer : le flux normal doit la consommer avant tout état Ground observable.

Or le `StartMap` suivi indiquait `master_zone / -1 / ID 40 / entrée 0`. Dans l’index actuel, l’ID 40 résout vers **`searing_crucible`**, et non vers le sélecteur New Era. La sentinelle initiale arrivait donc dans un Ground qui ne lançait pas `CharacterSelect()` : MissingNo devenait visible.

La correction change uniquement l’ID de démarrage de **40 à 31**. L’ID 31 résout vers le Ground New Era existant **`personality_test`**, dont le flux normal efface la sentinelle et crée le héros et le partenaire avant le premier état Ground observable.

### 2. Quiz PMD Red branché prématurément — `NEW_ERA_ADAPTATION` incorrecte retirée

Le commit `524e379` avait également ajouté un `require` direct de `pmdred_quiz_flow` dans `personality_test/init.lua`, puis appelé le prélude et le quiz PMD Red depuis `CharacterSelect()`. Ce branchement détournait la Nouvelle Partie avant l’existence d’un gate narratif New Era validé.

`personality_test/init.lua` a été restauré **octet pour octet** depuis `56d30131`, dernier état précédant ce routage :

- hash régressé : `20eda4cffdf57d3a03641aa92036ef64d10c682882e86a2fd504af08db9858b8` ;
- hash restauré : `e417364941cc7c5e53002f72633b7050b610601eaaa538e903556f1fbd766bac`.

Les modules PMD Red restent présents comme chantier isolé, mais aucun n’est requis ni exécuté par le démarrage normal. Ils sont inactifs jusqu’à la conception d’un futur gate narratif explicite.

## Éléments vérifiés comme non responsables

- `SV.General.Starter = missingno` dans `scriptvars.lua` : sentinelle préexistante, fichier inchangé, SHA-256 `f3b59e7e36201f0c981c877babb3c3d2c88fb350780580144c9c85604c9e8d01`.
- Le spawner `Teammate1` de `personality_test.rsground` possède un `BaseForm=missingno` dormant : Ground certifié inchangé, SHA-256 `76b3abc6953e9da4840c094494585c9a79057791ef66f81027e1541858eaeb8d`.
- Le namespace `halcyon.pmdred_eu` n’est pas requis par le flux Nouvelle Partie.
- `ground_gameplay_validator` ne s’active qu’avec sa variable d’environnement de validation ; il n’a pas déclenché le runtime normal.

Il n’a donc été nécessaire ni de remplacer MissingNo par un autre Pokémon, ni de modifier le Ground, ni de toucher aux chapitres.

## Preuve PMDO réelle

Le gate part d’un appdata vide et pilote **le vrai menu titre → Nouvelle Partie** avec des objets `FrameInput`. Il n’appelle pas directement `NewGamePlus` et n’effectue aucun `EnterZone` de redirection.

Timeline validée :

1. menu de langue et menu titre réels ;
2. événement `NewGame` avec la sentinelle interne, jamais montrée dans un Ground ;
3. cinq pages d’introduction New Era originales ;
4. premier Ground attendu : `personality_test` ;
5. menus héros, genre, capacité, partenaire et surnom réels ;
6. héros créé : **Bulbizarre** ;
7. partenaire créé : **Héricendre** ;
8. destination narrative normale : **`relic_forest`**, chapitre 1 ;
9. acteurs Ground et membres d’équipe concordants ;
10. aucun MissingNo dans l’équipe ou les acteurs observables ;
11. aucun `SV.PersonalityTest`, texte, événement ou harness PMD Red ;
12. capture complète du Ground final ;
13. sortie PMDO native, code 0, sans watchdog ni processus résiduel.

Preuve : [`runtime/validation.json`](runtime/validation.json), [`runtime/events.jsonl`](runtime/events.jsonl) et [`runtime/captures/relic_forest_normal_start.png`](runtime/captures/relic_forest_normal_start.png).

## Non-régression protégée

Le guard autoritatif passe avec :

- 219 IDs Ground certifiés ;
- 438 fichiers Ground/tile immuables ;
- 99 fichiers protégés des chapitres 1 à 5 ;
- 27 routes FugitiveArc ;
- 48 fichiers d’intégration historique.

Le travail Gloomy Forest / Sinister Woods ne reprendra qu’après livraison de cette correction et restera séparé du démarrage New Era.
