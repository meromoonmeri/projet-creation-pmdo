# KTR1 — Kiosques / Comptoirs de café Spinda, Qulbutoké et Sucreine (`sans fond`, style `Metano_Town_Cafe_Objects`)

## Nature du livrable

- **Objet** : trio complet d'objets de comptoir / bar d'intérieur pour **Spinda (`#0327`)**, **Qulbutoké (`#0202`)** et **Sucreine (`#0763`)**, conçus directement sur la grammaire d'objet de **`Metano_Town_Cafe_Objects`** + **`Metano_Town_Cafe_Objects_Over`** (*Halcyon* — meuble de bar d'intérieur en perspective 3/4, étagère arrière garnie de bocaux/baies, plantes en pot, tonneaux/caisses, distributeurs en verre et comptoir en chêne miel).
- **100 % sans fond (`alpha = 0`) & zéro frange magenta** :
  - Détourage par croissance de régions depuis toutes les plages `#FF00FF` (contour extérieur **et** ajours internes entre feuillages, bocaux et espace barman) tout en préservant à 100 % les bocaux et jus de raisin/baies violettes internes ;
  - Triple passe de suppression de frange magenta/pourpre au contact de `alpha = 0` (**`0 px` de `#FF00FF` et `0 px` de frange pourpre mesurés** sur tous les exports HD et `1×`).
- **Échelles et variantes livrées (sans aucun personnage incrusté)** :
  - **Masters HD `sans fond` (`alpha ∈ {0, 255}`)** :
    - `hd/Spinda_Comptoir_HD_sans_fond.png` (recadré juste) & `hd/Spinda_Comptoir_HD_1024_sans_fond.png`
    - `hd/Qulbutoke_Comptoir_HD_sans_fond.png` (recadré juste) & `hd/Qulbutoke_Comptoir_HD_1254_sans_fond.png`
    - `hd/Sucreine_Comptoir_HD_sans_fond.png` (recadré juste) & `hd/Sucreine_Comptoir_HD_1024_sans_fond.png`
  - **Échelle Ground `1×` alignée `8 px` (largeur canonique `144 px` = `18` tuiles comme le bar Halcyon)** :
    - **Spinda (`KSP1`, `144 × 104 px`)** : `complet`, `arriere`, `avant` + variantes `nuit` V8
    - **Qulbutoké (`KQB1`, `144 × 120 px`)** : `complet`, `arriere`, `avant` + variantes `nuit` V8
    - **Sucreine (`KSC1`, `144 × 136 px`)** : `complet`, `arriere`, `avant` + variantes `nuit` V8
  - **Planches `8 px` & pack mod PMDO `0.8.12` (`KTR1`)** : banques `.tile` `KSP1_*`, `KQB1_*`, `KSC1_*` + `index.idx` + `Mod.xml` + `INSTALLER.py`.
- **Statut honnête** : créations générées référencées sur `Metano_Town_Cafe_Objects` (pas des tuiles natives certifiées), `art_approved = false`, `runtime_tested = false` (non exécuté dans le moteur PMDO).
