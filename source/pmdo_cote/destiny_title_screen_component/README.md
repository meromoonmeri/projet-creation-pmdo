# Composant d’écran-titre PMD Destiny (PMDO 0.8.12)

Ce dossier contient les ressources de l’écran-titre Destiny, pas une quête autonome. Le constructeur de la quête copie ces fichiers dans son package final en conservant son `Mod.xml`, son UUID stable `1da28568-6363-5c51-8caa-9430b42862f0` et son namespace `destiny`.

## Contenu

- `Content/ContentParams.xml` : configuration PMDO, avec `TitleBG=Destiny_Title_Screen_Background`.
- `Content/BG/Destiny_Title_Screen_Background*.dir` : fonds animés Jour et Nuit (24 poses chacun); l’alias par défaut est identique octet pour octet au fond Jour.
- `Content/Obj/Destiny_Logo_Anime_Opening.dir` : apparition du blason en 24 poses.
- `Content/UI/Title.png` et `Enter.png` : logo et invite d’entrée aux dimensions PMDO.
- `Data/Script/destiny/services/destiny_title_anim/init.lua` : sélection Jour/Nuit et lancement unique de l’animation du blason sur le `TopMenu`.
- `manifest.json` : provenance Git, SHA-256, tailles et contrôles statiques.

## Provenance et renommage

Les rendus proviennent du commit `0e691d647a661f3c2a79984eda2d39686d4f0dfc` de `meromoonmeri/projet-creation-pmdo`; les entrées exactes et leurs OID Git figurent dans le manifeste. Les sorties `.dir` ont été produites par le constructeur Destiny et relues avec son décodeur PMDO. Le fichier de configuration source n’a subi qu’un changement ciblé de l’identifiant `TitleBG`.

Pour prévenir une collision avec un fond homonyme d’un autre mod, les trois noms de fond ont reçu le préfixe `Destiny_`; les deux références du service Jour/Nuit ont été mises à jour par identifiant exact. Le service est placé sous `Data/Script/destiny/services`, pas sous le namespace Halcyon. Aucun `Mod.xml` source n’est inclus : il portait une autre identité. Aucun Ground-menu, carte, collision, sortie, warp ou transition n’est fourni dans ce composant.

## Limites des tests

Le contrôle des formats, dimensions, hashes et références internes est statique. L’écran n’a pas encore été rendu dans PMDO; le chargement du service et le comportement du menu restent à confirmer dans le moteur. Les noms de musique et de sons pointent vers les ressources de base de PMDO et ne sont pas redistribués ici.
