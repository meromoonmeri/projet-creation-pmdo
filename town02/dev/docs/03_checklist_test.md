# Checklist de test — chargement sur PMDO 0.8.12

La sandbox de développement ne peut pas exécuter PMDO (application graphique C#).
Les vérifications statiques suivantes ont été faites ici ; les tests dynamiques
sont à exécuter sur votre installation locale.

## Vérifications statiques déjà passées (dans ce dépôt)

- [x] 178 fichiers Lua : syntaxe validée avec `luac5.4 -p` — 0 erreur.
- [x] 279 fichiers JSON de `Data/` : parsés — 0 invalide.
- [x] 526 fichiers `.resx` : XML parsé — 0 invalide.
- [x] Chaque map de `Data/Ground/` a son dossier de script dans `Data/Script/halcyon/ground/` (seul orphelin : `test_grounds`, dossier script sans map — sans impact).
- [x] `Mod.xml` : `GameVersion` fixé à `0.8.12` (balise vérifiée contre `PathMod.cs` de RogueEssence : le moteur compare `Versioning.GetVersion() < header.GameVersion` et refuse un mod plus récent que le jeu — donc 0.8.12 exact, pas plus).
- [x] Espèces prévues pour la trame (Necrozma, Eternatus, Luxray/Luxio/Shinx, Banette/Shuppet, Gengar/Haunter/Gastly, Zubat/Golbat/Crobat) : données `Data/Monster/*.json` + sprites `Content/Chara/<dex>.chara` + portraits présents dans DumpAsset master (vérifié par HTTP 200 sur les fichiers réels, convention numérique constatée dans le mod : `405.chara`, etc.).

## Tests dynamiques à faire sur votre machine (dans l'ordre)

1. **Installation** : copier le dossier du mod dans `PMDO/MODS/`. Lancer PMDO 0.8.12.
2. **Menu Mods** : le mod apparaît sous le nom « New Era : Abyss to Ascension », sans avertissement de version.
3. **Nouvelle partie** (Special Episodes) : cinématique d'ouverture de Relic Forest se joue ; **passer le jeu en français d'abord** (Options → Langue) pour vérifier que les 16 clés FR pilotes s'affichent (texte d'ouverture + quiz).
4. **Chapitre 1 complet** en accéléré : quiz, Relic Forest, arrivée à la guilde, première mission. Surveiller la console de log (F1 ou fichier LOG) — zéro erreur script attendue.
5. **Job board** : accepter et compléter une mission générée (mission_gen.lua est le plus gros script custom, 1er suspect en cas de changement d'API).
6. **Sauvegarde/chargement** : sauvegarder, quitter, recharger.
7. **Donjons d'entraînement (mazes)** : en lancer un — teste les zones custom + spawn tables.
8. **Chapitres 2-4** : au minimum charger chaque cinématique de début/fin de chapitre (les scripts `*_ch_2..4.lua` sont les plus denses).
9. **Chapitre 5 (working-copy, inachevé)** : tester jusqu'au contenu marqué en cours dans `todo.txt` ; noter le point d'arrêt propre pour décider où « New Era » reprend la main narrativement.

## En cas d'erreur au chargement

Consigner le message exact du log + le fichier/ligne Lua : la correction se fera ici,
commit dédié « compat ». Suspects prioritaires si erreur : `mission_gen.lua`,
`event_mapgen.lua` (steps de génération custom), `menu/character_menu.lua` (API menus).
