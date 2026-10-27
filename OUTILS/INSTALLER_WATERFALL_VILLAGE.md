# Installer WaterfallVillageCapital (« Reverie Town ») — procédure complète

La map `WaterfallVillageCapital.rsground` (~330 Mo) est **trop grosse pour un
fichier git normal** (limite GitHub 100 Mo) et **trop grosse pour le workspace
Arena** (limite 100 Mo/fichier). Elle doit être poussée **en entier, sans
découpage**, via **Git LFS**, depuis **ton ordinateur**.

## 1. Récupère le fichier

- Depès Drive : https://drive.google.com/file/d/1BoA5oLJNoy0qkS1pzWRXPltzdptCbSwJ/view
  (`WaterfallVillageCapital.rsground`, ~330 Mo), ou depuis ta copie locale.

## 2. Pousse-le en Git LFS (depuis un clone du dépôt)

```bash
git lfs install
cp /ton/chemin/WaterfallVillageCapital.rsground \
   bibliotheque_ground/lots/town02_waterfallvillage/Data/Ground/
git add .gitattributes
git add -f bibliotheque_ground/lots/town02_waterfallvillage/Data/Ground/WaterfallVillageCapital.rsground
git commit -m "WaterfallVillageCapital (Reverie Town) — map complète 330 Mo (LFS)"
git push
```

`.gitattributes` est **déjà configuré** dans le dépôt pour ce chemin : le fichier
sera automatiquement stocké en LFS, **entier**, sans aucun découpage.

> Alternative sans LFS : créer une **Release GitHub** (asset jusqu'à 2 Go) et y
> attacher le fichier — la quest le documentera alors par son URL.

## 3. Ce que la quest en fait (déjà prêt)

- Zone `town02_waterfallvillage` déclarée (GroundMaps `WaterfallVillageCapital` + `waterfall_cave_1`).
- Lot `bibliotheque_ground/lots/town02_waterfallvillage/` (script `WaterfallVillageCapital/init.lua` inclus).
- `OUTILS/integrer_waterfall_town02.py --fichiers .../WaterfallVillageCapital.rsground`
  valide le fichier (sha256 vs objet LFS `afc5081f…`), le **clampe** (positions
  hors-carte ramenées dans les limites) et finalise la zone + le lot.

## 4. Vérification (n'importe où, même ici)

```bash
git lfs ls-files          # doit lister WaterfallVillageCapital.rsground
python3 OUTILS/integrer_waterfall_town02.py --fichiers <chemin local du .rsground>
```

- `runtime_tested : false` (aucune exécution moteur) — cf. `quest_pmd_destiny/RAPPORT_MAPS_DESTINY.md`.
- Crédit : « Reverie Town », création de l'utilisateur — `quest_pmd_destiny/CREDITS.md`.
