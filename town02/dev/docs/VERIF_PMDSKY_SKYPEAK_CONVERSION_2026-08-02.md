# pmd-sky : Sky Peak et Shaymin Village sont-ils convertibles ?

Date : 2026-08-02 — dépôt `pret/pmd-sky`, branche `main`, 22 530 fichiers
Demande : vérifier si les grounds du sommet du Sky Peak et de Shaymin Village
s'y trouvent, et les convertir au format strict RogueEssence/PMDO.

---

## Verdict : les données existent, la conversion automatique n'est pas réaliste dans cet environnement.

Je détaille, parce que la nuance compte : **ce n'est pas « ça n'existe pas »**,
c'est « ça existe sous une forme qui demande une chaîne d'outils que le dépôt
ne fournit pas ».

---

## 1. Ce que pmd-sky contient réellement

### La structure canonique du Sky Peak — trouvée et complète

`include/enums.h` donne l'architecture exacte :

```c
DUNGEON_1ST_STATION_PASS       = 111,
DUNGEON_2ND_STATION_PASS       = 112,
DUNGEON_3RD_STATION_PASS       = 113,
DUNGEON_4TH_STATION_PASS       = 114,
DUNGEON_5TH_STATION_PASS       = 115,
DUNGEON_6TH_STATION_PASS       = 116,
DUNGEON_7TH_STATION_PASS       = 117,
DUNGEON_8TH_STATION_PASS       = 118,
DUNGEON_9TH_STATION_PASS       = 119,
DUNGEON_SKY_PEAK_SUMMIT_PASS   = 120,
DUNGEON_5TH_STATION_CLEARING   = 121,
DUNGEON_SKY_PEAK_SUMMIT        = 122,
DUNGEON_SHAYMIN_VILLAGE        = 175,
DGROUP_SKY_PEAK                = 72,
FIXED_SKY_PEAK_5TH_STATION_CLEARING = 28,
FIXED_SKY_PEAK_SUMMIT               = 29,
```

C'est **neuf passes numérotées + une passe du sommet + une clairière au 5e +
le sommet lui-même**, plus le village comme lieu distinct. Deux salles à
disposition fixe (`FIXED_*`) : la clairière et le sommet — ce sont précisément
les deux cartes de cinématique qui vous intéressent.

Les identifiants musicaux confirment le découpage par biome :
`MUSIC_SKY_PEAK_CAVE`, `COAST`, `FOREST`, `PRAIRIE`, `SNOWFIELD`,
`FINAL_PASS`, et `MUSIC_SHAYMIN_VILLAGE`.

Shaymin y figure sous ses deux formes : `SHAYMIN_LAND` (534) et
`SHAYMIN_SKY` (535).

### Les fichiers de carte — présents mais en binaire NDS

| Répertoire | Contenu | Format |
|---|---:|---|
| `files/MAP_BG/` | 1 482 fichiers, **557 cartes** | `.bma`, `.bpc`, `.bpl`, `.bpa` |
| `files/GROUND/` | 555 fichiers | `.wan`, `.wte`, `.wtu`, `.wat` |
| `files/…/SCRIPT/` | 17 923 fichiers, **325 répertoires** | `.ssa`, `.ssb`, `.lsd` |

Les 32 cartes préfixées `g01` correspondent au groupe des grounds de guilde et
de sommet.

## 2. Pourquoi la conversion automatique bute

Trois obstacles, dans l'ordre de gravité :

**a. Les formats sont des binaires propriétaires NDS.**
`.bma` (agencement de tuiles), `.bpc` (chunks graphiques), `.bpl` (palettes),
`.bpa` (animations) — quatre fichiers à recombiner pour produire une seule
image de carte. `.ssa`/`.ssb` sont du bytecode de script compilé, pas du texte.

**b. Le dépôt ne fournit aucun outil de conversion vers un format image.**
`tools/` contient `asm_processor`, `csv2bin`, `nitrogfx`, `msgenc`… tous
orientés reconstruction de la ROM, aucun export de carte. Extraire une carte
demanderait un outil tiers du type SkyTemple, hors périmètre de ce dépôt.

**c. Le volume.** Le dépôt fait 310 Mo, et la contrainte de sandbox est de
128 Mo. Même un checkout partiel de `MAP_BG` et `GROUND` dépasserait la limite.

**Il ne s'agit donc pas de « je n'ai pas trouvé »** : les données sont là,
localisées, et je peux vous donner leurs chemins exacts. C'est la chaîne
`.bma+.bpc+.bpl` → PNG → tileset RogueEssence qui manque, et l'écrire de zéro
serait un projet en soi, pas une étape de cette tâche.

## 3. Ce qui est immédiatement exploitable, en revanche

Trouvé lors de la vérification précédente, et qui reste valable :

| Asset | Source | État |
|---|---|---|
| `SkyPeak4thPass.tile`, `SkyPeak7thPass.tile`, `SkyPeakSummitPass.tile` | **DumpAsset** | 3 tilesets prêts au format PMDO |
| 9 autotiles `sky_peak_{4th,7th,summit}_pass_{wall,floor,secondary}` | **DumpAsset** | complets |
| `Sky Peak Cave/Coast/Forest/Prairie.ogg` | **New Era** | déjà présents |
| `Sky Peak Final Pass.ogg`, `Snowfield.ogg`, `Shaymin Village.ogg` | **EoSO** | à importer, format `.ogg` |

**Le décor du Sky Peak est donc disponible au bon format**, via DumpAsset qui
a déjà fait le travail de conversion. Ce qui manque, ce sont les `.rsground`
eux-mêmes — c'est-à-dire l'agencement des tuiles et les collisions, à peindre.

## 4. Recommandation

Trois voies, par coût croissant :

**(a) Construire les cartes avec les tilesets DumpAsset.** Les 3 tilesets et 9
autotiles permettent de peindre une entrée, une clairière et un sommet
cohérents avec le canon, sans dépendre de pmd-sky. C'est la voie que je
recommande : le rendu sera fidèle puisque les tilesets *sont* ceux du jeu.

**(b) Passer par SkyTemple hors sandbox.** Vous exportez les cartes depuis
pmd-sky avec l'outil dédié, vous me fournissez les PNG, et je les convertis en
`.rsground` avec `tools/png2tileset.py` — qui existe déjà dans le projet et
que j'ai corrigé lors d'un lot précédent.

**(c) Écrire un convertisseur `.bma`/`.bpc`/`.bpl`.** Techniquement faisable,
mais c'est plusieurs jours de travail et le résultat serait moins fiable que
(b), qui utilise un outil éprouvé.

## 5. Ce que j'ai vérifié précisément

- `include/enums.h` : structure des 12 donjons Sky Peak + Shaymin Village
- `files/MAP_BG/` : 557 cartes, formats `.bma/.bpc/.bpl/.bpa`
- `files/GROUND/` : 555 fichiers `.wan/.wte/.wtu/.wat`
- `tools/` : 147 fichiers, aucun exporteur de carte
- Recherche `sky_peak`, `shaymin`, `SKY_PEAK`, `SHAYMIN` sur les 22 530
  chemins : 0 correspondance de nom de fichier (les cartes sont nommées par
  code, `g01p01a` et non `sky_peak_summit`)

## Réserve

Je n'ai pas téléchargé les binaires : l'identification repose sur l'arbre Git
et sur `enums.h`. Si vous voulez que je tente une extraction, dites-le — mais
je préfère vous annoncer d'emblée que sans outil de décodage `.bma`, je ne
pourrai pas produire un `.rsground` valide, et je refuse de livrer une carte
approximative en prétendant qu'elle est canonique.
