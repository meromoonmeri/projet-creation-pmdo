# Bitter Blade / Lame en Peine — PMDO 0.8.12

## Livrables

- Donnée de capacité : `Data/Skill/bitter_blade.json`.
- Particules PMDO personnalisées (vrais `.dir`, bandeaux PNG transparents de 8 frames) :
  - `Content/Particle/Bitter_Blade_Aura.dir` — aura circulaire de feux follets, 8 × 72 × 72 px.
  - `Content/Particle/Bitter_Blade_Wisp.dir` — feu follet animé laissé sur les cases traversées, 8 × 32 × 32 px.
  - `Content/Particle/Bitter_Blade_Slash.dir` — impact de lame animé, 8 × 72 × 72 px.
- Bandes PNG sources éditables et manifeste : `assets/pmdo_animation/`.
- Planche de contrôle des effets et des huit directions natives de Ceruledge : `assets/bitter_blade_animation_sheet.png`.
- Aperçu animé du dash : `exports/illustrations/bitter_blade/bitter_blade_dash_preview.gif`.

Les `.dir` suivent le format utilisé par les ressources de particules PMDO : longueur PNG sur 8 octets little-endian, puis PNG horizontal transparent. Le `AnimIndex` dans les données correspond au nom de fichier sans extension.

## Mouvement et données de la capacité

`HitboxAction` est maintenant un `RogueEssence.Dungeon.DashAction`, basé sur l’action de Vive-Attaque (`quick_attack.json`) : `CharAnim: 5`, déplacement directionnel natif et portée étendue à **5 cases**; la frappe touche les ennemis sur la trajectoire et s’arrête sur la cible ou un mur. Le moteur garde le sprite et les frames directionnelles propres au Pokémon actif; Ceruledge n’est ni redessiné ni obtenu en tournant une pose unique. L’aura utilise le motif d’`AttachAreaEmitter` d’Ombre Portée (`shadow_sneak.json`), puis les feux follets sont émis sur le trajet et la lame frappe à l’arrivée.

Les autres propriétés préparées sont conservées : type Feu, physique, puissance 90, précision 100 %, 10 PP, une frappe et récupération de 50 % des dégâts via `HPDrainEvent` (`DrainFraction:2`) et l’effet natif `Absorb`. Ceruledge apprend toujours `bitter_blade` au niveau 48 selon sa donnée amont.

Les références PMDO 0.8.12 — Vive-Attaque, Ombre Portée, Boutefeu, Vampipoing, données de Ceruledge et ressources sonores — sont archivées sous `references/upstream/` avec commit et hashes.

## Ceruledge natif et provenance

L’aperçu reprend les huit lignes d’animation Walk natives de la planche Ceruledge #0937 de [PMD Sprite Collab](https://sprites.pmdcollab.org/#/0937?form=0), sans rotation de pose. Les fichiers `Walk-Anim.png`, `Walk-Offsets.png`, `AnimData.xml` et `credits.txt` de référence sont dans `references/upstream/ceruledge_sprite/`. Crédit indiqué par Sprite Collab : **BaronessFaron / PMDCollab_1**, licence [**CC BY-NC 4.0**](https://creativecommons.org/licenses/by-nc/4.0/); le crédit original et le commit épinglé `448d3af85e2cfa85a8c5ead076eddb145251b473` sont conservés dans ce dossier. Dans le GIF de contrôle, les frames sont recadrées, agrandies et composées avec les VFX; les poses sources ne sont pas retouchées ni pivotées. Ces références ne remplacent pas et ne patchent pas le sprite du jeu : le `DashAction` demande au runtime PMDO d’animer le Pokémon présent dans le donjon.

## Génération et vérification

Avec ImageMagick (`convert`/`identify`) installé :

```sh
python3 source/bitter_blade_v1/build_pmdo_assets.py
python3 source/bitter_blade_v1/build_preview.py
python3 source/bitter_blade_v1/validate.py
```

`validate.py` contrôle le JSON, le dash 5 cases, les trois `AnimIndex`, les en-têtes `.dir`, les dimensions et nombres de frames, l’apprentissage de Ceruledge et l’aperçu 8 directions. Le GIF et la planche sont des aperçus de contrôle utilisant les frames natives référencées; ils ne remplacent pas les fichiers `.dir` dans `Content/Particle`.

**Limite de test :** le runtime PMDO 0.8.12 n’est pas présent dans cet espace de travail. La structure des données et des ressources est validée localement, mais le chargement, le rendu réel, le comportement de collision et la durée exacte des émetteurs restent à confirmer en jeu.
