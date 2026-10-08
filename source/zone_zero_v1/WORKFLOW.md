# WORKFLOW — `zone_zero_v1` (réseau cristallin)

Quatre lots sous ce dossier, chacun avec son `build` via `source/zone_zero_v1/build.py <lot>`
et les lois partagées de `commun.py`. Procédure : [../../WORKFLOW.md](../../WORKFLOW.md).

| Lot | Préfixe | Rôle |
|---|---|---|
| `raz1/` | RAZ1 | Route 1, lèvre du cratère (P03P01A) |
| `raz2/` | RAZ2 | Route 2, terrasses aux cascades |
| `raz3/` | RAZ3 | Route 3, fond cristallin (D17P34A + P03P01A) |
| `eaz1/` | EAZ1 | Entrée grotte de cristal (D17P11A) |

Le réseau **fleuri** (RAF1–3, EAF1) est `source/zone_zero_v2/` — RAZ/EAZ **gardés**.

```sh
.venv/bin/python source/zone_zero_v1/build.py raz1   # raz2, raz3, eaz1
```

Bruts et rips absents de cette extraction. Warps **non scriptés**. `art_approved: false`.
