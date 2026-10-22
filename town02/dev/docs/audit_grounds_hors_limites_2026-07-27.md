# Audit — grounds dont les entités sont HORS des limites de la carte

> Session `arena/019fa547`, 2026-07-27. Découvert en généralisant le fix
> « écran noir après victoire » (guide maître §4.2 : *un problème rapporté =
> chercher TOUTE la classe du problème*).
> **Statut : DIAGNOSTIC SEUL — aucune correction appliquée.** Lire §4 avant d'agir.

---

## 1. Comment c'est apparu

En corrigeant le cadrage caméra du mini-boss de la Grande Steppe, j'ai voulu
vérifier que les scènes symétriques avaient bien la même géométrie. J'ai donc
comparé, pour chaque ground de boss, la **taille réelle de la carte** (déduite
de `Layers[0].Tiles`, en tuiles de 8 px) avec les **coordonnées utilisées par
les scripts** (`TeleportTo`, `MoveCamera`) et par les **entités du .rsground**
(`Markers`, `Spawners`).

Résultat inattendu : `mount_windswept_guardian` fait **176x208 px**, alors que
son script téléporte le duo en **(240, 440)** — soit très largement hors carte.

J'ai alors scanné les 244 grounds : **40 d'entre eux ont au moins une entité
hors limites**.

## 2. Script de détection (rejouable)

```python
import json, glob, os
for p in sorted(glob.glob('Data/Ground/*.rsground')):
    o = json.load(open(p, encoding='utf-8-sig'))['Object']
    L = o.get('Layers') or []
    if not L:
        print('NO LAYERS', p); continue
    t = L[0]['Tiles']
    W, H = len(t) * 8, len(t[0]) * 8          # colonnes x lignes, tuiles 8px
    for e in o.get('Entities', []):
        for key in ('Markers', 'Spawners', 'Characters', 'Objects'):
            for s in e.get(key, []) or []:
                c = (s or {}).get('Collider') or {}
                x, y = c.get('X'), c.get('Y')
                if x is None: continue
                if not (0 <= x < W and 0 <= y < H):
                    print(os.path.basename(p), W, H, key, s.get('EntName'), x, y)
```

## 3. Les deux familles de cas

### 3.1 Grounds de boss « maquettes » (1 seule couche) — SUSPECTS

Ceux-ci n'ont **qu'une seule couche** (souvent nommée `New Layer` ou `Terrain`),
là où les grounds sains en ont 4 à 6 (`Base` / `Shadows` / `Objects Under` /
`Objects` / `Fringe`). Ils ressemblent à des cartes générées en placeholder puis
jamais finies, tandis que le script de cinématique, lui, a été écrit pour une
carte de taille « normale ».

| Ground | Taille réelle | Couches | Le script attend | Écart |
|---|---|---|---|---|
| `mount_windswept_guardian` | 176x208 | 1 (`New Layer`) | duo (240,440), boss (224,192) | duo **hors carte** |
| `searing_crucible` | 168x168 | 1 (`Terrain`) | duo (240,472) puis (244,240) | duo **hors carte** en scène 1 |
| `cloven_ruins_boss` | 240x320 | 4 | duo (152,224), boss (144,128) | **dans les limites** — OK |
| `vast_steppe_guardian` | 368x528 | 4 | duo (200,400), boss (184,200) | **dans les limites** — OK |
| `vast_steppe_miniboss` | 368x528 | 4 | duo (200,400), boss (184,200-232) | **dans les limites** — OK |
| `mount_windswept_miniboss` | 384x528 | 5 | duo (240,440), boss (180-268,192-240) | **dans les limites** — OK |
| `searing_tunnel_miniboss` | 416x544 | 5 | duo (240,440), boss (220-292,208-232) | **dans les limites** — OK |

→ Les **mini-boss sont tous sains**. Ce sont deux **arènes de gardien/creuset**
qui sont sous-dimensionnées : `mount_windswept_guardian` et `searing_crucible`.

### 3.2 Arènes d'Ancrage + relais générés — motif systématique

Les 38 autres suivent des motifs très réguliers, signature d'un générateur :

- **Arènes d'Ancrage** (`arene_*`, `lac_*`, `nef_prisme_est`, `escalier_origine`,
  `couloir_legendes`, `gue_poulain_autel`, `terres_tues_porte`,
  `creux_ombres_scelle`, `vallon_malsain_fond`, `bois_antan_verger`,
  `fleche_reliques_courroux`, `porte_plaines_foudre`…) : `Boss_Marker` et
  `Main_Entrance_Marker` sont placés à des coordonnées calculées pour une carte
  bien plus grande que celle réellement générée.
- **Relais générés** (`new_era_zone_{05,09,11,13,15,17}_relais`,
  `searing_tunnel_midpoint`, `cloven_ruins_midpoint`, `crooked_cavern_midpoint`,
  `celestial_peak_relay`, `crystal_sanctuary_relay`, `forgotten_marsh_relay`,
  `gloomy_forest_midpoint`, `vast_steppe_midpoint`) : mêmes offsets suspects
  (ex. `Main_Entrance_Marker` à X=220 sur une carte de 152 px de large).
- Quelques cartes héritées de Halcyon (`plage_crepuscule`, `plage_lucioles`,
  `shady_shop`, `post_office`, `guild_heros_room`, `guilde_parvis_soir`,
  `grotte_plage_fond`, `luminous_spring`) ont aussi des marqueurs très hors
  cadre, dont des **coordonnées négatives** (`TEAMMATE_2` à X=-167).

## 4. ⚠️ Pourquoi je n'ai RIEN corrigé ici

Trois raisons, dans l'ordre d'importance :

1. **Ce n'est pas prouvé nuisible.** `vast_steppe_midpoint` est dans la liste
   des 40, or l'utilisateur **y joue sans problème** : le relais fonctionne, la
   sortie nord route correctement. Donc le moteur tolère au moins une partie de
   ces dépassements (probablement en clampant la caméra et en plaçant quand même
   les personnages, la carte de collision n'étant pas la carte de tuiles).
   Corriger « au jugé » risquerait de casser du contenu qui marche.
2. **Le périmètre demandé était le mini-boss de la Steppe.** Le guide maître §3.8
   est explicite : petits diffs vérifiables, ne pas mélanger un fix attendu avec
   une refonte massive.
3. **La bonne correction dépend de l'intention**, et elle n'est pas déductible du
   code : soit la carte doit être agrandie (le script fait foi), soit le script
   doit être recadré (la carte fait foi). Pour `mount_windswept_guardian`, la
   carte 176x208 avec une seule couche `New Layer` ressemble fort à un
   placeholder → c'est probablement **la carte** qu'il faut refaire, comme l'a
   été `mount_windswept_miniboss` (384x528, 5 couches).

## 5. Ce qu'il faut vérifier EN JEU (priorité de test)

À faire remonter à l'utilisateur quand il testera la suite de l'expédition ch5 :

1. **Creuset (`searing_crucible`, boss Magcargo)** — la scène 1 téléporte le duo
   en (240,472) sur une carte de 168x168. Si le duo est invisible ou si la scène
   se fige : c'est cette anomalie. **Prochain point de test après le Tunnel.**
2. **Gardien du Mont (`mount_windswept_guardian`, Aerodactyl)** — duo en (240,340)
   sur une carte de 176x208. C'est le **dernier boss de l'expédition ch5**, celui
   qui bascule `Chapter = 6` : un blocage ici bloque la progression narrative.
   (La sortie est désormais garantie hors `pcall` — voir §6 — donc même si la
   mise en scène est ratée, le chapitre passera.)

## 6. Ce qui a été fait dans cette session (et qui protège ces cas)

Les 7 fonctions `DefeatedBoss()` de boss ont été durcies sur le même modèle :
corps de cinématique isolé dans un `local function DefeatedBossBody()` appelé
sous `pcall`, puis **sortie + flags de progression exécutés HORS du pcall**.

| Fichier | Sortie garantie |
|---|---|
| `vast_steppe_miniboss_ch_5` | `vast_steppe_midpoint` |
| `mount_windswept_miniboss_ch_5` | `mount_windswept_midpoint` |
| `searing_tunnel_miniboss_ch_5` | `ContinueDungeon('searing_tunnel', 2)` |
| `vast_steppe_guardian_ch_5` | `searing_tunnel_entrance` |
| `searing_crucible_ch_5` | `mount_windswept_entrance` |
| `mount_windswept_guardian_ch_5` | `EndDungeonRun` + `Chapter = 6` |
| `cloven_ruins_boss_ch_7` | `guild_third_floor_lobby` + flag ch7 |

Conséquence directe : **même si une de ces arènes sous-dimensionnées fait planter
la mise en scène, le joueur n'est plus bloqué sur un écran noir** — il est
transporté à l'étape suivante et l'erreur exacte est écrite dans le log sous
`[BossSeq] DefeatedBoss ERREUR: ...`. C'est ce message qu'il faudra récupérer
pour trancher le §4.

## 7. Reste à traiter (hors périmètre de cette session)

- 2 appels `GetAnimIndex("Faint")` subsistent dans
  `ground/crooked_den/crooked_den_ch_3.lua` (lignes ~621 et ~652, Glameow et
  Luxio, chapitre 3). Contenu déjà joué et validé par l'utilisateur, donc non
  touché ici ; à sécuriser de la même façon si un écran noir est rapporté au ch3.
- Décider carte-vs-script pour les 40 grounds listés (voir §4).
