# Inventaire des entrées de boss — à produire AVANT toute implémentation

> Le prompt l'impose : *« Ne pas implémenter avant d'avoir cet inventaire
> complet. »* Ce document est cet inventaire. **Aucune ligne de scène n'a été
> modifiée** à ce stade.
>
> **Rien n'est testé en jeu.** Tout est établi par lecture du moteur
> (fichier + ligne), mesure sur les cartes réelles et audit outillé.

---

## 0. Gabarits — exclus de toute modification

Décision joueur, appliquée strictement :

| Gabarit | Rôle |
|---|---|
| `searing_tunnel_miniboss` (Chartor/Torkoal + Magmar) | modèle mini-boss |
| `crooked_den` (Sandile & co, ch3) | modèle boss |

Ils sont **mesurés pour en extraire la structure**, jamais corrigés.
`tools/audit_boss_entree.py` les marque `GABARIT — exclu`.

### Structure réellement employée par le gabarit du Tunnel

Relevée ligne à ligne (`searing_tunnel_miniboss_ch_5.lua`) :

| # | Beat | Implémentation |
|---|---|---|
| 1 | Montée de tension **avant** toute apparition | `FadeOutBGM(40)` + `LoopSE("Light Earthquake")` (l.94-95) |
| 2 | Caméra qui resserre | `MoveCamera(256,258,40)` (l.140) |
| 3 | **La Voix, une seule fois** | `BossFX.Voice('STM_006')` (l.158) |
| 4 | Cadre commun avant révélation | `MoveCamera(256,240,60)` (l.166) |
| 5 | Boss 1 : créé → **caché** → SE → **Flash** → dévoilé → impact | l.170-178 |
| 6 | Boss 2 : même patron, SE différent (`DUN_Fire_Spin`) | l.201-211 |
| 7 | Escorte : 5 Limagma, particules + `Unhide` en cascade | l.272-286 |
| 8 | Le boss **parle** | l.304-310 |

**Le point clé du gabarit** : `MakeCharactersFromList` → `GROUND:Hide` → `SE` →
`BossFX.Flash` → `GROUND:Unhide` → `BossFX.Impact`. Le personnage existe avant
d'être vu ; le flash *couvre* sa révélation. C'est ce qui rend l'apparition nette
plutôt que « pop ».

### Le gabarit n'emploie La Voix qu'**une seule fois**

C'est la mesure de référence pour la règle « élément rare ».

---

## 1. Correction d'un contresens de mon audit initial

`\uE040` a **deux usages distincts**, que j'avais d'abord confondus :

| Forme | Appel | Sens | Légitimité |
|---|---|---|---|
| **A — désincarnée** | `SetSpeaker(uE040, true, "", -1, "", Unknown)` ou `BossFX.Voice` | **La Voix** de l'Abîme, sans portrait | rare, exceptionnelle |
| **B — incarnée** | `SetSpeaker(uE040, true, x.CurrentForm.Species, ...)` | portrait d'un personnage **présent** dont le nom n'est pas encore révélé | légitime, sans lien avec l'Abîme |

Preuve moteur : `ScriptUI.cs:428-434` — `SetSpeaker(name, keysound, specie, form,
skin, gender)` construit `MonsterID(specie,...)`. Avec `specie=""` l'ID est vide
(aucun portrait) ; avec une espèce réelle, le portrait s'affiche sous un nom masqué.

Le gabarit `crooked_den` utilise la **forme B** (l.44, l.87) : c'est Sandile qui
parle, visage visible, nom caché. Ce n'est pas La Voix.

Répartition mesurée : **42 formes A** + **52 formes B** dans le dépôt.

---

## 2. État de conformité (hors gabarits)

`python3 tools/audit_boss_entree.py .`

| Arène | Flashs | La Voix | État |
|---|---|---|---|
| `gloomy_forest_miniboss` | 3 | 1 | ✅ conforme |
| `cloven_ruins_miniboss` | 3 | 1 | ✅ conforme |
| `crystal_sanctuary_miniboss` | 3 | 1 | ✅ conforme |
| `forgotten_marsh_miniboss` | 3 | 1 | ✅ conforme |
| `vast_steppe_miniboss` | 4 | 3 | La Voix ×3 |
| `cloven_ruins_boss` | 6 | 4 | La Voix ×4 |
| `mount_windswept_miniboss` | 2 | 3 | <3 flashs + Voix ×3 |
| `vast_steppe_guardian` | 2 | 5 | <3 flashs + Voix ×5 |
| `mount_windswept_guardian` | 1 | 3 | <3 flashs + Voix ×3 |
| `gloomy_forest_boss` | 1 | 2 | <3 flashs + Voix ×2 |
| `searing_crucible` | 1 | 5 | <3 flashs + Voix ×5 |
| `crystal_sanctuary_boss` | 1 | 1 | <3 flashs |
| `forgotten_marsh_boss` | 1 | 1 | <3 flashs |
| `celestial_peak_boss` | 0 | 1 | <3 flashs |

**8 arènes** sans les 3 flashs · **7 arènes** sur-employant La Voix.

---

## 3. Point déjà conforme — aucune entité hors champ

Exigence du prompt vérifiée par simulation du cadrage **au moment exact de
l'apparition** (la caméra bouge pendant la scène ; un contrôle sur la première
position seule donnait un faux positif).

Fenêtre PMDO = 320×240, donc demi-cadre 160×120.

| Arène | Apparition | Écart caméra | Verdict |
|---|---|---|---|
| Tunnel (gabarit) | Torkoal, Magmar, 5 Limagma | max (56, 96) | dans le cadre |
| Grande Steppe | Mudbray, Stantler | max (32, 44) | dans le cadre |
| Mont Venteux | Gligar, Skarmory | max (44, 40) | dans le cadre |
| Mont — gardien | Aerodactyl | (0, 40) | dans le cadre |
| Ruines — boss | Regirock/Regice/Registeel/Regigigas | max (48, 56) | dans le cadre |

**Résultat : 0 apparition hors champ.** Rien à corriger sur ce point.

---

## 4. Assets réellement disponibles (vérifiés)

`Content/BG` et `Content/Particle` du mod sont **partiels** : `PathMod.cs:370-384`
fait retomber le moteur sur les assets du jeu de base. Les noms ci-dessous sont
attestés par leur usage effectif dans le dépôt.

**Fonds (`BGAnimData`)** — `Black`, `Cloudy_Sky`, `Fog`, `Ominous_Wind`,
`Pre_Battle`, `Sandstorm`, `Steam`, `White`

**Particules locales (`Content/Particle`)** — `Ash_Fall`, `Emote_Eating`,
`Leaf_Fall`, `Sakura_Fall`, `Slugma_Materialize(_Reverse)`, `Snow_Fall`
> ⚠️ `BossFX.Particle` échoue **en silence** sur un nom absent. Tout autre nom
> doit être vérifié avant emploi.

**SE de flash attestés** — `EVT_Battle_Flash` (38 usages), `_UNK_EVT_102` (23),
`EVT_Emote_Shock_2` (21), `EVT_Battle_Transition` (4), `DUN_Power_Gem` (6),
`DUN_Wind` (3), `EVT_CH03_Boss_Collapse` (3)

**Musique** — 133 morceaux dans `Content/Music`.

---

## 5. Le vrai problème musical : un thème unique pour tous

`Rising Fear.ogg` est le thème de combat de **9 arènes sur 9** — précisément la
« réutilisation d'un thème générique sans lien avec l'identité du Pokémon » que
le prompt interdit.

Proposition d'affectation par direction artistique, **à valider avant écriture** :

| Arène | Boss | DA | Thème proposé | Pourquoi |
|---|---|---|---|---|
| Grande Steppe (mini) | Stantler + Mudbray | animal, territorial | `Amp Plains` | plaine ouverte, nerveux sans être menaçant |
| Grande Steppe (gardien) | Stantler ancien | solennel | `Sacred Tower` | gardien, pas agresseur |
| Mont Venteux (mini) | Gligar + Skarmory | sentinelles aériennes | `Mt. Travail` | déjà l'ambiance du lieu, tendu |
| Mont Venteux (gardien) | Aerodactyl | fossile, brutal | `Treacherous Mountain` | lourd, ancestral |
| Forêt Lugubre (mini) | Tengalice + Cornèbre | rusé, hostile | `Ambush Forest` | embuscade, littéral |
| Forêt Lugubre (boss) | Zarude | protecteur farouche | `Deep Dusk Forest` | dense, pas gratuitement menaçant |
| Aegis Cave (mini) | Kaorine + Golemastoc | gardiens de pierre | `Sealed Ruin` | minéral, solennel |
| Aegis Cave (boss) | Regis + Regigigas | colosses ancestraux | `Aegis Cave` | thème canonique des Regi |
| Sanctuaire Cristal | — | lumineux, serein | `Crystal Crossing` | beau plutôt que menaçant |

> Le prompt insiste : un boss serein garde une musique **belle ou majestueuse**
> même en plein combat. D'où `Sacred Tower` / `Crystal Crossing` plutôt qu'un
> thème de peur.

---

## 6. Inventaire VFX de l'entrée type (à décliner par biome)

Structure **fixe** (les 5 temps), habillage **variable** — exactement la logique
déjà validée pour le point médian.

| Temps | Fixe | Variable selon biome |
|---|---|---|
| 1. Voix mystérieuse | boîte, source non identifiable | *texte* propre au boss ; **pas** `\uE040` sauf exception |
| 2. Flash 1 (discret) | `BossFX.Flash(x,y,3,4,18)` | SE : volcanique `_UNK_EVT_102` / aérien `DUN_Wind` / minéral `DUN_Power_Gem` |
| 3. Flash 2 (marqué) | `BossFX.Flash(x,y,2,6,22)` + léger `ShakeScreen` | idem, intensité supérieure |
| 4. Flash 3 (révélation) | `Hide` → `Flash(x,y,2,8,26)` → `Unhide` → `BossFX.Impact` | particule de biome si elle existe |
| 5. Musique | `PlayBGM(thème, false)` **sur** le 3ᵉ flash, pas après | thème du tableau §5 |

Réactions requises à chaque flash (règle « le corps parle avant la bouche ») :
héros `EmoteAndPause("Exclaim")`, partenaire `"Shock"`, équipiers `CharAnimateTurnTo`.

---

## 7. Ce qu'il reste à trancher avant implémentation

1. **Périmètre** : les 8 arènes sans 3 flashs, ou aussi les 7 qui sur-emploient
   La Voix (14 au total, certaines cumulent) ?
2. **La Voix** : je remplace les occurrences excédentaires par une voix
   *générique* (forme B, portrait du boss, nom masqué — patron `crooked_den`), en
   n'en gardant qu'**une** par entrée comme le gabarit du Tunnel ?
3. **Musique** : le tableau §5 est-il validé, ou veux-tu d'autres choix ?
4. **Dialogue précombat** : faut-il aussi réécrire les échanges, ou seulement la
   mécanique d'entrée pour ce lot ?

Aucune de ces questions n'est tranchée ici : le prompt interdit d'implémenter
avant que l'inventaire soit complet **et** validé.
