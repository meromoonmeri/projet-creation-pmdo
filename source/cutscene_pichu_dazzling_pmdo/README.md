# Pichu × Team Dazzling — vraie cinématique PMDO

Ce paquet est une **Quest PMDO 0.8.12**, pas une vidéo : la scène est jouée par les scripts Halcyon sur le Ground `cliffdaytest`. À la première entrée sur la carte, dialogues, caméra, déplacements et animations s’exécutent dans le jeu.

## Pour la voir en temps réel dans PMDO

1. Fermer PMDO et extraire `MOD_CUTSCENE_PICHU_DAZZLING_PMDO.zip`.
2. Copier le dossier `mod_pmdo` dans `<PMDO>/MODS/PichuDazzling/` en gardant `Mod.xml` à la racine du dossier.
3. Double-cliquer `LANCER_CINEMATIQUE_WINDOWS.bat` (Windows), ou exécuter `./LANCER_CINEMATIQUE_LINUX.sh` (Linux). Le lanceur passe `-dev -quest` à PMDO depuis le bon dossier. À défaut, démarrer manuellement PMDO en mode développement et charger la Quest.
4. Dans le Dev Warp ou l’éditeur Ground, ouvrir `cliffdaytest` et entrer au marqueur `Pichu_Home_Door`. La cinématique démarre sur l’événement `Enter`.
5. Pour la variante nocturne, ouvrir `cliffdaytest_nuit`. Pour rejouer le premier passage, effacer `SV.PichuDazzling.Seen` de la sauvegarde ou utiliser une sauvegarde neuve.

Le paquet comprend ses atlas `.tile`, l’`index.idx` propre à cette Quest et ses arrière-plans `.dir`; il n’a pas besoin des atlas de Cliffdaytest provenant d’autres mods. Il s’appuie sur les sprites Pokémon natifs de l’installation PMDO. **Ne pas fusionner cet `index.idx` avec celui d’une autre Quest** : installer le dossier comme mod indépendant.

## Contenu

- `mod_pmdo/Data/Ground/` : cartes Jour/Nuit, 4 calques visuels au Jour et 3 à la Nuit.
- `mod_pmdo/Content/Tile/` : atlas autonomes 8×8 qui reproduisent les couches du décor; mer en 8 phases et terrain en 4 phases.
- `mod_pmdo/Content/BG/` : fonds nocturnes et trois plans de nuages diurnes RogueEssence, avec parallaxe.
- `mod_pmdo/Data/Script/halcyon/ground/` : cinématique française, déclenchée à l’entrée de chaque carte.
- `apercu_cine_pichu_team_dazzling.html` : aperçu de revue 320×240, non substitut au rendu PMDO.

Pichu apparaît maintenant sur la case walkable du seuil `(608,476)`. Le `.rsground` canonique à la racine n’est pas modifié.

## Vérifications et limite

`python3 source/cutscene_pichu_dazzling_pmdo/test_build.py` — 6 tests structurels réussis : carte canonique, position walkable, routes, frames/tilesets, animations natives, aperçu et archive.

Le binaire PMDO et une session graphique fonctionnelle ne sont pas disponibles dans l’environnement de fabrication. L’archive est préparée pour être lancée sur une installation PMDO réelle, mais **son premier rendu graphique en jeu reste à confirmer**; ne pas considérer les tests structurels comme une lecture moteur.
