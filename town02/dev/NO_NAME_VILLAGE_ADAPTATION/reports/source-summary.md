# No Name Village — audit source GameMaker

- **État :** `SOURCE_OFFICIAL_MODEL_EXTRACTED_EXHAUSTIVELY`
- **Lecteur officiel :** UndertaleModLib 0.6.1.0 sous .NET 10.0.3/WASM
- **Rooms :** 98
- **Room principale :** `rmvillage`, 4992×4992 px, 18 layers, 886 instances
- **Objets :** 727
- **Sprites :** 2775, **9084 frames**, **653 masks**
- **Tilesets :** 30 ; **9134 texture-page items** ; 96 pages QOI+BZip2
- **Sons :** 388/388 extraits et reliés, 249 521 056 octets
- **Code :** 2188 entrées, **273 883 instructions VM** conservées
- **GML :** 2025 corps décompilés + 161 alias enfants ; 2 seuls échecs, tous deux dans les exemples Steam hors village et couverts par le VM brut
- **Colliders solides placés :** 10737
- **Transitions/portes placées :** 319

## Saisons

La logique printemps/été/automne/hiver n'est plus `UNVERIFIED`. Le décompilateur officiel prouve :

- la sélection par `global.season` et les seuils de `stage` ;
- les substitutions exactes de tilesets pour `grass0`, `grass1`, `ground`, `groundtex`, `water`, `cliff` et `undergrass` ;
- les substitutions exactes des sprites d'arbres, rochers, plantes et assets du layer `Below` ;
- les changements de visibilité (`vegetation`, `groundplot`, `endwater`, `watereffect`) ;
- le contrôleur `objwinter`, ses trois familles de particules, les traces et le son de pas neige.

Voir `season-vm-evidence.json`. Les anciens PNG de prévisualisation sont des contrôles structurels antérieurs et ne constituent pas une preuve saisonnière finale.

## Heure / jour-nuit

`global.timeofday` est une mécanique réelle avec les valeurs source 0, 1, 2 et 3, 39 références décompilées et des effets sur éclairage, surfaces, bloom, maisons, audio et un tileset intérieur. Aucun nom humain n'est inventé pour les quatre valeurs : voir `time-system.json`.

## Frontière PMDO

La source n'est plus bloquée. En revanche, aucun `.rsground` No Name Village n'est encore certifié. Le prochain gate est la reconstruction PMU/PMD structurée, puis le chargement et le rendu réels dans PMDO 0.8.12, sans toucher aux Grounds déjà certifiés.
