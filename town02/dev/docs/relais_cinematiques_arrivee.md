# Cinématiques d'arrivée aux relais — audit et implémentation (2026-07-27)

## Demande

Vérifier que, à l'arrivée à **chaque point relais** (relais mi-donjon et
Stations-Relais du Réseau), le joueur **entre en marchant avec son équipe**,
qu'un **dialogue** se joue, et que chaque scène est **originale et
contextuelle** (dans le cadre de l'histoire, ou en visite libre).

## État constaté avant intervention

| Relais | Chapitre | Marche d'entrée | Dialogue | Verdict |
|---|---|---|---|---|
| `crooked_cavern_midpoint` | ch3 | ✅ MoveToPosition duo | ✅ CCM3_001-004 (variantes) | conforme |
| `searing_tunnel_midpoint` | ch5 | ✅ marche à 4 (duo + Hyko + Almotz) | ✅ STM5_* (3 états) | conforme |
| `vast_steppe_midpoint` | ch5 | ✅ carton-titre + marche duo | ✅ scène complète + variantes | conforme |
| `mount_windswept_midpoint` | ch5 | ✅ carton-titre + marche duo | ✅ scène complète | conforme |
| `gloomy_forest_midpoint` | ch6 | ✅ marche duo | ✅ GFM6_001-004 | conforme |
| `cloven_ruins_midpoint` | ch7 | ❌ simple fondu | ⚠️ 2 lignes de narrateur centré | **non conforme** |
| `crystal_sanctuary_relay` | ch8 | ❌ simple fondu | ⚠️ 2 lignes narrateur (rejouées à CHAQUE visite) | **non conforme** |
| `forgotten_marsh_relay` | ch9 | ❌ simple fondu | ⚠️ idem | **non conforme** |
| `celestial_peak_relay` | ch10 | ❌ simple fondu | ⚠️ idem | **non conforme** |
| `new_era_zone_05/09/11/13/15/17_relais` (6 Stations) | Réseau (ch11+) | ❌ aucun | ❌ aucun | **non conforme** |

Les cinématiques de **réveil après défaite** (`WipedCutscene`, vague 8)
étaient déjà en place partout et ne sont pas touchées.

## Implémentation

### Nouveau module : `Data/Script/halcyon/RelayScenes.lua`

`RelayScenes.DuoArrival(cfg)` — grammaire commune d'arrivée :
1. carton-titre du lieu (optionnel), fondu d'ouverture, musique du camp ;
2. le partenaire ouvre la voie d'un demi-pas, le héros suit (coroutines
   désynchronisées de 6 frames, comme les scènes ch5) ;
3. le duo se fait face, puis le dialogue se déroule (partenaire / héros
   en aparté / narrateur centré) ;
4. rendu de la main + IA `ground_partner` réactivée.

Chaque scène ne se joue qu'**une seule fois** (flag SV), les visites
suivantes restent un simple fondu (pas de friction en farm).

### Scènes écrites (10 nouvelles, toutes distinctes)

**Relais d'histoire ch7→10** — deux variantes chacun : *pendant le chapitre*
(tension du récit) et *visite libre* (contemplative, si découverte hors
chapitre) :
- **Relais Aegis Cave (ch7)** : l'esplanade nivelée par les bâtisseurs,
  les veines dorées qui convergent vers le Cœur — écho direct à
  `SawAnimaCoreCorruption` et à la WipedCutscene existante.
- **Relais du Sanctuaire de Cristal (ch8)** : les cristaux **cessent de
  chanter** (signature reprise de la WipedCutscene « ils chantaient encore
  quand tout est devenu noir ») ; silence « respectueux » avant Diancie.
- **Relais du Marais de l'Oubli (ch9)** : la brume qui s'écarte, les
  silhouettes du **Cercle du Suaire** qui ne laissent pas d'empreintes
  (préfigure `SawCercleDuSuaire`).
- **Relais du Pic Céleste (ch10)** : mer de nuages au-dessus de Metano,
  l'**Escouade Fulgur** qui grimpe « trop vite » (préfigure
  `ReachedFulgurEncounter`), l'air qui se raréfie.

**6 Stations-Relais du Réseau des Anciens Chemins** — ton techno-mystique
de l'add-on, une scène par station, jouée à la première venue :
- **Foudre Basse** (zone 05) : le paratonnerre des anciens relayeurs
  fonctionne toujours ; la statique s'éteint dans l'enceinte.
- **Manteau Ardent** (zone 09) : conduits de refroidissement dans la
  cheminée du volcan ; le Terminal « encore tiède ».
- **Point de Rosée** (zone 11) : les flocons suspendus, les aiguilles de
  cuivre des mesures d'antan.
- **Grand Blanc** (zone 13) : le blizzard qui efface le monde à dix pas,
  dernier abri avant l'Aiguille du Zéro Absolu.
- **Contrôle du Noyau** (zone 15) : les relayeurs restés à leur poste,
  cadrans fondus ; le battement « comme un cœur » sous le sol
  (préfigure le Veilleur et la Fosse Ardente).
- **Dernier Palier** (zone 17) : la passerelle sur les nuages, le chant
  ancien du sommet — « le bout du Réseau, et peut-être le bout du ciel ».

### Flags & rétroactivité

- `SV.Chapter8.PlayedSanctuaryRelayIntro`, `SV.Chapter9.PlayedMarshRelayIntro`,
  `SV.Chapter10.PlayedPeakRelayIntro` (déclarés dans `scriptvars.lua`) ;
  ch7 réutilise `SV.Chapter7.RuinsMidpointState` (déjà existant).
- `SV.Reseau.StationIntros[zone]` pour les 6 Stations.
- `services/debug_tools/init.lua` (OnUpgrade) : parties existantes → si le
  relais avait déjà été atteint (`Reached*Relay`), l'intro est marquée comme
  jouée (pas de rejeu incongru en milieu de partie).

### Vérifications spatiales et techniques

- Colonnes de marche **flood-checkées contre `obstacles`** des `.rsground` :
  cloven (x180/212, y384→456), crystal (x276/308, y556→628), marsh
  (x180/212, y344→408), peak (x180/212, y240→304), stations (x204/236,
  y312→368) — **toutes 100 % walkables** ; pas de collision avec les
  spawners TEAMMATE.
- Musiques toutes présentes dans `Content/Music` (In the Depths of the Pit,
  Snow Camp, Cave Camp, Summit, Rising Fear, Deep Dark Crater, Sky Tower).
- 13 fichiers Lua validés par `lupa` (loadfile sans erreur).

## Hors périmètre (inchangé)

- Les relais ch3/5/6 conservent leurs scènes existantes (déjà conformes).
- Les `WipedCutscene` (vague 8) sont inchangées.
- Test en jeu toujours non réalisé (validation statique uniquement).
