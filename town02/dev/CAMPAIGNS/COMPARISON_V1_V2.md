# Comparaison manifest initial (v1, commit 0b45b897) vs manifest audité (v2)

L'audit automatique exhaustif (`dev/tools/campaign_audit_exhaustive.py`,
détection placeholders / frames / assets / références / mappings /
cinématiques / doublons / faux PASS) a invalidé plusieurs affirmations du
manifest v1. Ce document liste ce qui était faux, ce qui a été corrigé, et
ce que le v2 mesure honnêtement.

## Ce que le v1 présentait — et ce que l'audit a trouvé

| Affirmation v1 | Réalité mesurée par l'audit | Correction v2 |
|---|---|---|
| RED « 428 grounds, 422 rendus » | 195 de ces grounds étaient des Grounds du **mod New Era** (metano_town, guild_*, luluby_*, arene_*…), dont 41 placeholders `debug_placeholder` de 292 octets présentés comme contenu de campagne | Campagne réduite aux **254 grounds canoniques ROM** (219 validés runtime + stations/arènes/friend areas de la table GBA) ; les grounds du mod sont exclus, les placeholders purgés |
| RED « frames d'animation incluses (cap 6) » | **108 grounds** avaient des frames manquantes : cap arbitraire 6 < besoin réel (jusqu'à 7980 frames pour a05p01 — séquence non périodique réelle de la ROM) | Rendu v2 : **période minimale réelle** par ground (réduction des séquences répétitives), cap 64 ; au-delà, `animation_frames.png` = planche exhaustive de **toutes** les frames de **chaque** séquence de tuile distincte → frames_full 100 % (Red) / 99,8 % (Sky, 1 accepté documenté) |
| RED mapping donjons D01–D25 | 17 grounds de donjon pointaient vers des **noms du mod absents de la source** (foret_tendre_oree…) → « ground déclaré sans rendu » | Donjons mappés par **IDs source GBA** (d01p01…d25p01) ; les 21 fins/arènes validées manquantes ont été importées du dépôt ; noms du mod exposés en `new_era_mod_alias` (traçabilité, pas contenu) |
| RED « with_canonical_cast: 19 » | Le cast ROM couvre 27 scènes ; 8 manquaient par défaut d'alias | v2 : **27/27** scènes avec casting canonique lié |
| SKY « 460 grounds, 459 rendus » | 83 grounds avec frames sous-rendues ; 2 anomalies non documentées (b01p01_beach sans layers, s05p04a frame 0 noire) | Frames complètes ou planche exhaustive ; les 2 anomalies **vérifiées contre la source** et classées ACCEPTED avec preuve (asset hérité du port ; fondu d'ouverture canonique de 344 frames) |
| Identité humaine | Red 25 %, Sky 2,8 % de noms humains | Red **97,2 %** (stations MAP_DATABASE + donjons + rôles de série a/b/h/s), Sky **100 %** (donjons pret enum + groupes + rôles de série t/g/p/s/v/h/w/m) |

## Couvertures finales (séparées — jamais fusionnées)

| Mesure | RED v1 | RED v2 | SKY v1 | SKY v2 |
|---|---|---|---|---|
| Grounds campagne | 428 (contaminée) | **254 canoniques** | 460 | 460 |
| render_pct | 98,6 | **100,0** | 99,8 | 99,8 |
| frames_full_pct | 73,4 | **100,0** | 81,5 | **99,8** |
| cinematic_linked_pct | 25,9 | **52,0** | 0,0 | 0,0 |
| human_identity_pct | 25,0 | **97,2** | 2,8 | **100,0** |
| Verdict audit | BLOCKED (143 HIGH) | **AUDIT_PASS** (0 HIGH, 34 LOW) | BLOCKED (85 HIGH) | **AUDIT_PASS** (0 HIGH, 2 ACCEPTED, 26 LOW) |

## Ce qui reste honnêtement incomplet (LOW / REVIEW_REQUIRED)

- **RED** : 34 LOW — principalement des groupes de renders bit-identiques
  (variantes b/j/n d'arènes réellement identiques dans la table GBA, à
  confirmer une à une) ; le TEXTE des dialogues des 133 cinématiques n'est
  pas dans les .cif.json (les boîtes sont comptées/séquencées ; texte 5
  langues régénérable via `audit_pmdred_eu_all_ground_scripts.py` + ROM).
- **SKY** : cinematic_linked 0 % — les scripts SSB de la NDS ne sont pas
  encore extraits scène par scène (2 squelettes portés seulement).
  REVIEW_REQUIRED assumé, aucun contenu inventé pour le masquer.
- Les APNG fusionnent les frames identiques consécutives en durées
  cumulées (sans perte) ; `apng_rendered_frames` consigne le compte rendu
  original.

## Leçon appliquée

Le manifest v1 aurait donné l'illusion d'une campagne complète (« 422/428
rendus », « frames incluses »). L'audit automatique a matérialisé chaque
écart en anomalie classée, et le v2 ne déclare plus rien qui ne soit
mesuré. Aucun des deux manifests ne prétend à un « 100 % » global.
