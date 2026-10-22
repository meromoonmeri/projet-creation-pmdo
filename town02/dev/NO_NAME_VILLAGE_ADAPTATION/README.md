# No Name Village → PMDO/PMU

Pipeline séparée pour auditer `No.Name.Village.zip`, conserver son système réel
(layout, intérieurs, événements, saisons et états temporels), puis reconstruire
une adaptation native PMDO. L’archive est une entrée en lecture seule ; aucun
PNG de capture ne peut devenir une map ou un layer.

L’archive publique est stockée par Git LFS. Le lecteur vérifie obligatoirement
son SHA-256 LFS avant audit. Les sources brutes et l’archive restent hors Git ;
seuls les rapports structurés compacts et les futurs candidats PMDO sont suivis.

## État source actuel

`data.win` a été réassemblé et vérifié (`2f33b595…`, 301 037 316 octets).
L’extraction structurale identifie 98 rooms, 727 objets, 2 775 sprites,
30 tilesets, 96 pages de texture et 388 sons. `rmvillage` mesure exactement
4 992×4 992 px et conserve 18 layers, quatre portes, quatre transitions de
bord, six spawn points, quatre maisons et 259 colliders solides.

Le système printemps/été/automne/hiver est source-prouvé par la variable
`season`, les scripts saisonniers, 131 objets, 37 sprites et les contrôleurs de
neige/hiver. Les rapports et rendus de contrôle sont sous `reports/`.

## Extraction officielle exhaustive

Le second audit exécute désormais UndertaleModLib lui-même sous .NET/WASM. Les
inventaires complets, le VM brut, les 2188 entrées GML, les bytes de masks et de
textures sont sous `extracted/official/`. Les 388 fichiers audio restent hors
Git à cause de leur volume, mais leur manifeste SHA-256 exhaustif est suivi et
le runner les régénère depuis le `data.win` vérifié.

Les outils `build_utmt_wasm_bundle.py`, `NoNameVillageExtractor.cs`,
`decode_official_textures.py` et `extract_all_frames.py` rendent le pipeline
reproductible sans modifier la source. `season-vm-evidence.json` et
`time-system.json` remplacent les anciennes conclusions `UNVERIFIED` sur la VM.

## Frontière environnementale PMDO

Avant toute composition, l'inventaire PMDO-scopé est régénéré depuis le modèle
officiel suivi :

```bash
python3 NO_NAME_VILLAGE_ADAPTATION/tools/build_environment_inventory.py
python3 NO_NAME_VILLAGE_ADAPTATION/tests.py
python3 NO_NAME_VILLAGE_ADAPTATION/test_environment_inventory.py
```

Il couvre les 98 rooms, conserve les hashes et placements environnementaux,
et sépare décor, fonctions spatiales, rôles sociaux, faune et ambiguïtés. Les
536 `objmob*` placés dans 38 rooms sauvages ne sont pas des rôles sociaux ni du
décor : ils restent `WILD_POKEMON_ADAPTATION_REQUIRED`, avec densité, position
et classe comportementale à transposer vers des Pokémon sauvages natifs. Les
fonctions sociales restent `ROLE_ADAPTATION_REQUIRED` et réutiliseront
`LivingWorld`, `TownLife`, `TownPlace` et l'AI PMDO. La sortie compressée est
`reports/environment-inventory.json.gz`. Ce gate n'émet aucun Ground et ne peut
attribuer `CONVERTED`, `CERTIFIED` ou `PROMOTED`.

## Conversion PMDO effective

La conversion démarre dans `generated/`, jamais directement dans `Data/` :

```bash
python3 -m pip install --target .runtime-cache/nnv-python \
  -r NO_NAME_VILLAGE_ADAPTATION/requirements-conversion.lock
for season in spring summer autumn winter; do
  PYTHONPATH=.runtime-cache/nnv-python \
    python3 NO_NAME_VILLAGE_ADAPTATION/tools/convert_environment_room.py \
      --room rmvillage --season "$season"
done
```

Le convertisseur réutilise le writer natif `.tile`/`.rsground` de
`PMU_ADAPTATION` et reconstruit les couches depuis le modèle officiel, jamais
le PNG de preview. La règle finale est une correspondance spatiale **1:1** :
4 992×4 992 px source donnent 4 992×4 992 px PMDO, cellules visuelles 64 px,
`TexSize=8`, grille de collision 624×624 en cases de 8 px, sans resampling.
Il matérialise markers et transitions prouvées puis rend le Ground pour une
comparaison pixel-perfect compatible avec la prémultiplication alpha PMDO. Le script candidat require explicitement
`LivingWorld`, `TownLife`, `TownPlace`, `Seasons`, `Weather` et `TownNight`.

`Seasons` ne sert que d'horloge de progression. Le convertisseur interdit
explicitement `Seasons.Apply()`/les particules génériques comme substitut : les
substitutions `objstage`, les quatre familles visuelles, les trois familles de
particules `objwinter`, les traces, le son de neige et les états spéciaux 4/5/6
doivent être portés depuis `season-vm-evidence.json` et le GML canonique. La
source GitHub est verrouillée au commit
`d1245878861fc76dc5455dbad68bcb45c83f7e1f` de
`meromoonmeri/nonamevillage`.

Le premier candidat 1:1 est `rmvillage`. Les anciens candidats 1/4 `rm78`,
`rm81` et `rm82` ont été supprimés comme bases impropres. L'analyse canonique
des 89 nids sauvages de `rm82` reste conservée séparément dans
`reports/rm82-wildlife-source.json` pour sa future conversion 1:1. Aucun
candidat n'est promu ni déclaré `CONVERTED`. Pour `rmvillage`, les quatre
variantes source `spring/summer/autumn/winter` sont maintenant générées en 1:1,
avec substitutions `objstage`, visibilités et cycles de sprites compilés. L'été
reste le Ground PMDO complet de référence ; les trois autres variantes sont des
bundles de layers déterministes afin de ne pas dupliquer la grille de collision
624×624. Restent obligatoires : sélection runtime des bundles, particules
`objwinter`, populations Pokémon sauvages, casting social et validation runtime.
Les sprites source exacts `ssnow1`, `ssnow2` et `spttrail01` sont déjà compilés
1:1 en trois assets Particle PMDO sous `winter/particles/`; l'émetteur à trois
familles, la surface de traces et l'audio restent explicitement bloqués. Tous
les manifests restent `UNIMPLEMENTED`. Le runtime PMDO 0.8.12 réel charge
l'été et valide mouvement, collision bloquée et 12 captures animées. Le harness
corrigé demande explicitement `LoadPhase.Unload` après son événement terminal :
la terminaison est désormais native, code 0, sans watchdog ni processus résiduel.
Ce PASS reste un composant `RUNTIME_TESTED_PASS`, pas une certification globale :
le switch des quatre saisons, les particules et les Pokémon restent ouverts.
