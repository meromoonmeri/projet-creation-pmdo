# Bitter Blade / Lame en Peine — PMDO 0.8.12

## Livrables

- Donnée de capacité : `Data/Skill/bitter_blade.json`.
- Particules PMDO personnalisées (vrais `.dir`, bandes PNG transparentes de 8 frames), dessinées en **flammes noires** :
  - `Content/Particle/Bitter_Blade_Aura.dir` — aura circulaire noire de départ, noir charbon et indigo sombre, 8 × 72 × 72 px.
  - `Content/Particle/Bitter_Blade_Wisp.dir` — flamme noire animée laissée sur les cases traversées, 8 × 32 × 32 px.
  - `Content/Particle/Bitter_Blade_Slash.dir` — balayage de lame en flamme noire, révélé progressivement puis dissipé, 8 × 72 × 72 px.
- Sources générées et recadrées des flammes : `assets/bitter_blade_blade_source.png`, `assets/bitter_blade_wisp_source.png`; bandes PNG éditables et manifeste : `assets/pmdo_animation/`.
- Planche de contrôle des strips d’effets et des huit directions natives de Ceruledge : `assets/bitter_blade_animation_sheet.png`.
- Aperçu animé du dash sur fond turquoise, sans ligne ni repères de trajectoire : `exports/illustrations/bitter_blade/bitter_blade_dash_preview.gif`.

Les `.dir` suivent le format utilisé par les ressources de particules PMDO : longueur PNG sur 8 octets little-endian, puis PNG horizontal transparent. Le `AnimIndex` dans les données correspond au nom de fichier sans extension.

## Mouvement et données de la capacité

`HitboxAction` est un `RogueEssence.Dungeon.DashAction` de **5 cases** avec `CharAnim: 5`, la même animation de rush que Vive-Attaque (`quick_attack.json`). L’`AfterImageEmitter` reprend aussi exactement les paramètres de Vive-Attaque (`AnimTime: 8`, `BurstTime: 1`, alpha 128). `AppearanceMod: 2` sélectionne le dash invisible — le sprite principal disparaît pendant la traversée puis réapparaît à l’impact; les afterimages et les feux follets noirs restent visibles. Cette variante est aussi présente sur Ombre Portée (`shadow_sneak.json`). L’aura noire est émise au départ, les wisps sont laissés sur les cases traversées, et le balayage de lame se joue à l’arrivée.

Le découpage en bandes et le rythme des frames ont été vérifiés sur les particules PMDO natives `Will_O_Wisp`, `Night_Slash` et `Shadow_Claw` (commit épinglé `3e767571f9dd94270b848b3a73de9bec2553a2eb`). Ces ressources sont consignées comme références de style/format uniquement; la capacité utilise ses propres VFX générés, pas ces animations recopiées.

Les autres propriétés préparées sont conservées : type Feu, physique, puissance 90, précision 100 %, 10 PP, une frappe et récupération de 50 % des dégâts via `HPDrainEvent` (`DrainFraction:2`) et l’effet natif `Absorb`. Ceruledge apprend toujours `bitter_blade` au niveau 48 selon sa donnée amont.

Les références PMDO 0.8.12 — Vive-Attaque, Ombre Portée, Boutefeu, Vampipoing, Feu Follet, Tranche-Nuit, Griffe Ombre, Force Spectrale, données de Ceruledge et ressources sonores — sont archivées sous `references/upstream/` avec commit et hashes.

## Ceruledge natif et provenance

L’aperçu reprend les huit lignes d’animation Walk natives de la planche Ceruledge #0937 de [PMD Sprite Collab](https://sprites.pmdcollab.org/#/0937?form=0), sans rotation de pose. Les fichiers `Walk-Anim.png`, `Walk-Offsets.png`, `AnimData.xml` et `credits.txt` de référence sont dans `references/upstream/ceruledge_sprite/`. Crédit indiqué par Sprite Collab : **BaronessFaron / PMDCollab_1**, licence [**CC BY-NC 4.0**](https://creativecommons.org/licenses/by-nc/4.0/); le crédit original et le commit épinglé `448d3af85e2cfa85a8c5ead076eddb145251b473` sont conservés dans ce dossier. Dans le GIF de contrôle, les frames sont recadrées, agrandies et composées avec les VFX; les poses sources ne sont pas retouchées ni pivotées. Ces références ne remplacent pas et ne patchent pas le sprite du jeu : le `DashAction` demande au runtime PMDO d’animer le Pokémon présent dans le donjon.

## Génération et vérification

Avec ImageMagick (`convert`/`identify`) installé :

```sh
python3 source/bitter_blade_v1/build_pmdo_assets.py
python3 source/bitter_blade_v1/build_preview.py
python3 source/bitter_blade_v1/validate.py
```

`validate.py` contrôle le JSON, le rush invisible (`AppearanceMod:2`), `CharAnim:5`, les paramètres d’afterimage copiés de Vive-Attaque, le dash 5 cases, les trois `AnimIndex`, les en-têtes `.dir`, les dimensions et les 8 frames distinctes de chaque strip, l’absence de pixels rouges/orange dans les VFX, l’apprentissage de Ceruledge et l’aperçu 8 directions. Le GIF et la planche restent des aperçus de contrôle; le runtime PMDO exécute l’animation de dash native et ne remplace pas Ceruledge par ces sprites de référence.

**Limite de test :** le runtime PMDO 0.8.12 n’est pas présent dans cet espace de travail. La structure des données et des ressources est validée localement, mais le chargement, le rendu réel, le comportement de collision et la durée exacte des émetteurs restent à confirmer en jeu.
