# Title screen animé PMD Destiny — « Ray of Hope MIX »

Intégré à la quest le 27 octobre 2026. **Provenance : création de l'utilisateur**
(Pokémon Mystery Dungeon : Destiny), attestée — aucun pixel tiers.

## Contenu dans `quest_pmd_destiny/`

| Fichier | Rôle |
|---|---|
| `Content/BG/Title_Screen_Background_Jour.dir` | fond animé jour (24 poses, 6×10 ticks) |
| `Content/BG/Title_Screen_Background_Nuit.dir` | fond animé nuit (24 poses) |
| `Content/BG/Title_Screen_Background.dir` | alias par défaut (= Jour) |
| `Content/Obj/Destiny_Logo_Anime_Opening.dir` | opening unique du blason Œuf Ailé |
| `Content/UI/Title.png` | logo 320×240 centré |
| `Content/UI/Enter.png` | invite « Enter » 74×11 |
| `Data/Script/halcyon/services/destiny_title_anim/init.lua` | service : sélection auto Jour/Nuit (06h–19h), animation 24 poses sous `TopMenu`, helper `PlayAnimeOpening` |
| `Data/Script/halcyon/ground/pmd_destiny_opening/init.lua` | scène d'ouverture |
| `Data/Script/halcyon/ground/pmd_destiny_intro/init.lua` | intro |
| `Data/Ground/pmd_destiny_menu_jour.rsground` | map-menu du title screen |
| `Content/Tile/DSTJ_*.tile` (10) | tilesets animés du fond (ciel, mer pixelart, reflets, nuages, brise céleste, logo) + `index.idx` |

## Régénération (identique à l'original)

```sh
PYTHONPATH=/tmp/destiny-src:/tmp/destiny-src/source .venv/bin/python \
  source/pmd_destiny_fangame_v1/build.py
```

Sources : branche `arena/e39626d2` — `source/pmd_destiny_fangame_v1/`
(bruts `logo_pmd_destiny_oeuf_ailes_magenta.png`, `mer_pixelart_jour/nuits_magenta.png`,
`nuages_cathedrale_magenta.png`) + modules `moteur_pmd_destiny_fangame`,
`tour_celeste_moteur_nuages`, `moteur_cyclones_cylindriques_unova`,
`moteur_gba_pmd_red_natif`, `pmdo_cote/{build.py,INSTALLER.py}`, gabarit
`cliffdaytest.rsground`.

## Provenance des tuiles

`Title_Screen_Background.dir` (homonyme d'un fichier Halcyon dans town02) est
passé en **« propre »** dans `OUTILS/surcharge_provenance_tiles.json` sur
attestation : c'est le title screen de PMD Destiny, création de la quest.
Aucun élément Palikadude/Halcyon n'est redistribué ici.

Honnêteté : `art_approved: false`, `runtime_tested: false` (aucun lancement
PMDO depuis le sandbox) — à tester en jeu.
