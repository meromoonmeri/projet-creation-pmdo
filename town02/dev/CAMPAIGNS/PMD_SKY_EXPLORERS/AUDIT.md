# Audit automatique — PMD_SKY_EXPLORERS

**Verdict : AUDIT_PASS** — 0 anomalie(s) bloquante(s)

Sévérités : {'MEDIUM': 1, 'ACCEPTED': 3, 'LOW': 30}

Couvertures (séparées) : {"grounds_total": 466, "render_pct": 99.8, "frames_full_pct": null, "cinematic_linked_pct": 73.4, "human_identity_pct": 98.7, "note": "pourcentages séparés — ne JAMAIS fusionner en un '100%'"}

| Sévérité | Catégorie | Sujet | Détail |
|---|---|---|---|
| MEDIUM | REFERENCE | `PMD_SKY_EXPLORERS` | sources .rsground/.tile absentes du cache: audit frames/assets NOT_TESTED sur cette exécution (restaurer .runtime-cache) |
| LOW | MAPPING | `s13p01a` | nom humain == identifiant technique et aucune identité de donjon/groupe/série rattachée |
| LOW | MAPPING | `s13p01b` | nom humain == identifiant technique et aucune identité de donjon/groupe/série rattachée |
| LOW | MAPPING | `s13p01b2` | nom humain == identifiant technique et aucune identité de donjon/groupe/série rattachée |
| LOW | MAPPING | `s13p01b3` | nom humain == identifiant technique et aucune identité de donjon/groupe/série rattachée |
| LOW | MAPPING | `s13p01b4` | nom humain == identifiant technique et aucune identité de donjon/groupe/série rattachée |
| LOW | MAPPING | `s13p01b5` | nom humain == identifiant technique et aucune identité de donjon/groupe/série rattachée |
| LOW | DUPLICATE | `aegis_cave_entrance+aegis_cave_floor_01+aegis_cave_floor_02` | 3 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:aegis_cave_entrance) |
| LOW | DUPLICATE | `aegis_cave_floor_07+aegis_cave_floor_08+aegis_cave_floor_09+d33p41a` | 14 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:aegis_cave_floor_07) |
| LOW | DUPLICATE | `d00p02+d10p21a+d12p21a+d15p21a` | 20 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:d00p02) |
| LOW | DUPLICATE | `d46p31a+d46p41a` | 2 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:d46p31a) |
| LOW | DUPLICATE | `d53p41a+d53p41b` | 2 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:d53p41a) |
| LOW | DUPLICATE | `d58p41a+d59p41a+d60p41a+d61p41a` | 7 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:d58p41a) |
| LOW | DUPLICATE | `d73p21a+d73p22a+d73p23a+d73p24a` | 5 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:d73p21a) |
| LOW | DUPLICATE | `d91p41a+d92p41a+d93p41a+d94p41a` | 5 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:d91p41a) |
| LOW | DUPLICATE | `p03p01a+p03p02a` | 2 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:p03p01a) |
| LOW | DUPLICATE | `p28p01a+v03p07a` | 2 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:p28p01a) |
| LOW | DUPLICATE | `s00p01a+s04p01a+s06p01a+s07p01a` | 5 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:s00p01a) |
| LOW | DUPLICATE | `s01p01b+s15p05b` | 2 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:s01p01b) |
| LOW | DUPLICATE | `s05p02c3+s05p02c4` | 2 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:s05p02c3) |
| LOW | DUPLICATE | `s13p01a3+s13p01a4` | 2 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:s13p01a3) |
| LOW | DUPLICATE | `s13p01b3+s13p01b4` | 2 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:s13p01b3) |
| LOW | DUPLICATE | `s15p02a+s15p03a` | 2 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:s15p02a) |
| LOW | DUPLICATE | `t00p03+t01p02a` | 2 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:t00p03) |
| LOW | DUPLICATE | `v00p01+v01p07b` | 2 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:v00p01) |
| LOW | DUPLICATE | `v00p03+v05p03a` | 2 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:v00p03) |
| LOW | DUPLICATE | `v15p02a+v15p03a` | 2 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:v15p02a) |
| LOW | DUPLICATE | `v26p11a2+v26p11a5` | 2 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:v26p11a2) |
| LOW | DUPLICATE | `w00+w01a+w01b` | 3 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:w00) |
| LOW | DUPLICATE | `w02a+w02b` | 2 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:w02a) |
| LOW | DUPLICATE | `w03a+w03b+w04a+w04b` | 6 renders bit-identiques (frame_000) — source incomplète pour trancher (SOURCE_MISSING:w03a) |
| ACCEPTED | PLACEHOLDER | `Renders/s05p04a/frame_000.png` | render suspect (298 octets) |
| ACCEPTED | DUPLICATE | `d06p11a+waterfall_cave_1` | 2 renders bit-identiques — CONFIRMÉ canonique : Layers normalisés ET contenu pixel des planches .tile identiques dans la source (variantes d |
| ACCEPTED | DUPLICATE | `t00p02+t01p01a` | 2 renders bit-identiques — CONFIRMÉ canonique : Layers normalisés ET contenu pixel des planches .tile identiques dans la source (variantes d |
