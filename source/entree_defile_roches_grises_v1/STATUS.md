# EDR1 — état du 16 octobre 2026

## Réalisé

- Référence ROM D46P11A rendue au commit épinglé ; BMA/BPC/BPL, blobs Git, SHA-256 conservés.
- Deux bruts générés avec le rip fourni en référence, prompts exacts et fichiers conservés.
- Terrain 768×576, réduction par classe, sept calques + Top vide au format Ground.
- Profondeur séparée et poussière au vent 24×5 ticks, couleurs du rip, effets recalculés.
- Arrivée sud, seuil nord, passage libre de 16×16 vérifié, aucun warp ni destination liée.
- 16 tests Python PASS, dont cinq mutations rejetées dans des copies temporaires.
- Vérificateur indépendant : 30 images reconstruites exactement depuis le Ground et les banques .tile.
- Index vérifié ; installateur testé en dry-run, fusion, sauvegarde, réinstallation et conflit.
- Deux builds comparés : **65 fichiers ou membres ORA identiques** par SHA-256, hors horodatages ZIP
  et caches Python. Rapport dans `renders/entree_defile_roches_grises_v1/reproducibilite.json`.
- ZIP projet 13 fichiers (aucun cache Python), ZIP calques + ORA, aperçu HTML autonome.
- Page et téléchargements HTTP 200 ; syntaxe JavaScript contrôlée avec `node --check`.
- Inspection visuelle du PNG normalisé et du contrôle collisions/marqueurs.
- Tests de l'outil PMD Sky : 4 PASS, 1 ignoré car rendus globaux absents. Index global non modifié.

## Restant à valider

- Approbation artistique utilisateur : **non**.
- Chargement du lot dans le vrai moteur PMDO : **non testé**.
- Ouverture graphique, animations et déplacement en jeu : **non testés**.
- Interactions navigateur automatisées : **non testées** (contrôles HTTP et syntaxe seulement).

## Limites

Terrain généré référencé, pas extraction de pixels ROM. Le nom du biome n'est pas officiel.
La fidélité mesure les couleurs, pas les raccords ni les volumes. La découpe de collision est
conservatrice et doit être vérifiée en jeu. Les racines restent avec les parois.
Aucune modification des anciens lots, aucune fusion d'une branche sœur.

## Reprise

Relancer `build.py`, puis `package.py` avec les dépendances de `requirements.txt`.
Les sorties lourdes et le staging sont ignorés par Git. La référence, les bruts et le gabarit
nécessaire sont déjà dans le dépôt ; le build ne requiert pas d'accès réseau.
Lancer le serveur persistant dans le seul dossier `renders/entree_defile_roches_grises_v1/`.
Prochaine étape : retour utilisateur sur l'aperçu, puis test réel dans PMDO 0.8.12.
