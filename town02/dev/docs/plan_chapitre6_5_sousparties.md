# Chapitre 6 — plan structurel en 5 sous-parties

> **Structure avant rédaction.** Aucun script n'est modifié par ce document.
> **Rien n'est testé en jeu.** Tout constat est vérifié fichier + ligne.

---

## 1. Correction de cadrage (retour utilisateur)

Le ch5 est une **expédition** : on dort au bivouac, loin de la ville. Le ch6 est
un **retour à Metano** : on redort sur sa paillasse à la guilde, avec les
rassemblements matinaux des ch1-4.

**Le schéma à appliquer n'est donc pas celui du ch5, mais celui des ch1-4** —
avec la densité de mise en scène du Mont Windsep.

### Boucle de guilde relevée dans les ch1-4 (modèle à reprendre)

| Étape | Fonction attestée | Fichier |
|---|---|---|
| Carton de chapitre | `ShowTitleCard()` | `guild_heros_room_ch_4:10` |
| Réveil | `guild_heros_room_helper.Morning(true)` | helper:53 |
| Rassemblement matinal | `FirstMorningAddress()` / `ExpeditionAnnouncementAddress()` | `guild_third_floor_lobby_ch_3/4` |
| Vie de guilde | `SetupGround()` + N × `X_Action()` | `guild_second_floor_ch_*` |
| Donjon | entrance → midpoint → miniboss → boss | — |
| Coucher | `PostGroveBedtalk()` + `helper.Bedtime(false)` | `guild_heros_room_ch_4:29` |

---

## 2. État réel du chapitre 6 (audit)

### 2.1 Ce qui existe

| Fichier | Lignes | Contenu |
|---|---|---|
| `metano_town_ch_6.lua` | 1309 | intro Team Dazzling, post-mission, PNJ ville |
| `gloomy_forest_midpoint_ch_6.lua` | 332 | relais + Épreuve des Trois |
| `gloomy_forest_miniboss_ch_6.lua` | 317 | Tengalice + Cornèbre |
| `guild_guildmasters_room_ch_6.lua` | 255 | audience de retour |
| `gloomy_forest_boss_ch_6.lua` | 147 | Zarude |
| `gloomy_forest_entrance_ch_6.lua` | 127 | arrivée |
| `guild_heros_room_ch_6.lua` | 39 | carton de chapitre **seul** |

### 2.2 Écarts mesurés face au Mont Windsep

| Marqueur | Mont Windsep (ch5) | Forêt Lugubre (ch6) |
|---|---|---|
| `WaitShowDialogue` | 224 | 58 |
| `BranchCoroutine` | **235** | **16** |
| `CharTurnToCharAnimated` | **125** | **0** |
| `EightWayMove` | **88** | **0** |
| `EmoteAndPause` | 40 | 4 |
| `MoveCamera` | 42 | 15 |

**Diagnostic** : zéro `CharTurnToCharAnimated` et zéro `EightWayMove` signifient
que dans tout le ch6, **personne ne se tourne vers son interlocuteur et personne
ne marche**. Les personnages parlent en restant figés — exactement ce que la
directive §2.2 interdit.

Exemple concret (`gloomy_forest_entrance_ch_6:42-60`) : Butterfree enchaîne 6
répliques d'affilée ; ni le héros ni le partenaire ne se tournent vers lui.

### 2.3 Manques structurels

1. **Un seul donjon** (Forêt Lugubre) au lieu de 3 à 5.
2. **Boss sans conséquence** : `gloomy_forest_boss_ch_6` n'a que
   `FirstBossScene()` — pas de `DefeatedBoss()` ni `DiedToBoss()`, alors que
   tous les boss du ch5 ont les quatre.
3. **Aucun `Bedtalk`** : le ch6 ne se couche jamais. Les ch2/3/4 en ont tous.
4. **Aucun rassemblement matinal** au 3ᵉ étage (les ch2/3/4 en ont).
5. **Carton de chapitre réutilise `Chapter_4`** (`guild_heros_room_ch_6:27`) —
   il n'existe que 4 fonds, or la règle impose une image dédiée par chapitre.
6. **Ni examen d'explorateur ni tournoi** : `SideQuests.lua` n'en contient
   aucune trace, `Wobbuffet`/`Wynaut` absents de `CharacterEssentials`.

> Les espèces manquantes ne sont pas un obstacle : Zarude, Diancie et Lugia sont
> déjà employés **sans surcharge locale** (`Data/Monster/` n'a que 21 fiches) —
> `PathMod` retombe sur le jeu de base. Wobbuffet/Wynaut seront disponibles.

---

## 3. Les 5 sous-parties du chapitre 6

Titre proposé : **« Ceux qui brillent »** (conforme à `04_trame_arc1.md`).

### 6.1 — Le Réveil de Metano

*Retour à la vie de guilde après l'expédition.*

| Élément | Détail |
|---|---|
| Lieu | `guild_heros_room` → `guild_second_floor` → `guild_third_floor_lobby` |
| Ouverture | `ShowTitleCard()` avec **fond `Chapter_6` dédié** (à produire) |
| Boucle | `helper.Morning(true)` → rassemblement matinal → vie de guilde |
| Cinématiques | 4 : carton, réveil, adresse de Penticus, retrouvailles |
| Enjeu | La ville bruisse du phénomène du sommet (payé depuis le ch5) |
| Donjon | aucun — sous-partie de respiration |

**Contenu narratif** : la guilde décompresse. Hyko revient changé (canon posé
par « Ce que le vent a emporté » : il sait pour son père). Penticus annonce
l'inspection du Cœur régional. Rumeur semée : *« une équipe aux yeux d'or qui
pose trop de questions sur les Cœurs »* — amorce Fulgur, exigée par la trame.

### 6.2 — L'Examen d'Explorateur

*Quête annexe majeure, au café.*

| Élément | Détail |
|---|---|
| Lieu | `metano_cafe` (Shuckle déjà présent) |
| Nouveaux PNJ | **Qulbutoké** (Wobbuffet), **Okéoké** (Wynaut) — duo canonique |
| Déclencheur | Nombre de badges atteint → un PNJ oriente vers le café |
| Cinématiques | 3 : convocation, épreuve, remise du rang |
| Récompense | Déblocage d'un donjon + montée de rang |
| Donjon | 1 (donjon d'examen, parmi les 77 zones libres) |

**Point à trancher** : Qulbutoké ne parle canoniquement qu'en répétant son nom.
Décision à prendre **une fois pour tout le projet** (règle du prompt) — je
recommande qu'Okéoké **traduise** ses interventions : on garde le gag canonique
sans perdre l'information.

### 6.3 — Le Tournoi des Équipes

*L'arc tournoi demandé, amorcé ici.*

| Élément | Détail |
|---|---|
| Lieu | Metano (place) + arène dédiée |
| Équipes | **Team Style** (Luxio/Glameow/Cacnea), **Team Round** (Spheal/Marill/Jigglypuff), **Team Starlight** (Cleffa…), **Team Dazzling** |
| Cinématiques | 5 : annonce, tirage, 2 duels, finale |
| Donjon | 1 (parcours qualificatif) |

**Toutes ces équipes existent déjà** dans `CharacterEssentials.lua` — Team Style,
Team Round, Team Starlight sont déclarées et inutilisées depuis le ch3. Le
tournoi les réactive au lieu d'inventer des rivaux.

**Lien à l'intrigue** : Team Dazzling s'inscrit et gagne son quart — c'est ainsi
qu'elle s'impose comme rivale crédible avant la Forêt.

### 6.4 — La Forêt Lugubre

*Le donjon existant, remis au niveau du Mont Windsep.*

| Élément | Détail |
|---|---|
| Lieu | `gloomy_forest_entrance` → `midpoint` → `miniboss` → `boss` |
| Cinématiques | 6 : arrivée, relais, Épreuve des Trois, mini-boss, Zarude, victoire |
| Donjon | 1 (existant, 11 segments) |

**Reprises nécessaires** (pas une réécriture — un enrichissement) :
- Ajouter `CharTurnToCharAnimated` sur chaque prise de parole (0 actuellement).
- Ajouter `EightWayMove` pour les arrivées et départs (0 actuellement).
- Ajouter `DefeatedBoss()` / `DiedToBoss()` au boss Zarude (absents).
- Escorte du mini-boss : Shiftry **+ 2 Nuzleaf + 2 Seedot** (règle « évolué +
  pré-évolutions », aujourd'hui non respectée).

### 6.5 — Ce que la Forêt a réveillé

*Conclusion et bascule vers le ch7.*

| Élément | Détail |
|---|---|
| Lieu | `guild_guildmasters_room` → `guild_heros_room` |
| Cinématiques | 4 : rapport, audience, **Bedtalk**, rêve n°2 |
| Donjon | aucun |

**Contenu** : l'audience chez Penticus existe déjà (`GuildmasterAudience`, 255
lignes) — à chaîner proprement. Puis le **coucher manquant** : `Bedtalk` avec le
partenaire, sur le patron de `PostGroveBedtalk` (ch4).

Enfin le **rêve n°2** exigé par la trame : *« première image — une silhouette
prismatique enchaînée dans le noir »*. La carte `hero_dream` existe déjà et son
patron est éprouvé : parallax + sprite centré + apparition par clignotement.

---

## 4. Bilan de volumétrie

| Sous-partie | Donjons | Cinématiques |
|---|---|---|
| 6.1 Réveil de Metano | 0 | 4 |
| 6.2 Examen d'Explorateur | 1 | 3 |
| 6.3 Tournoi des Équipes | 1 | 5 |
| 6.4 Forêt Lugubre | 1 | 6 |
| 6.5 Ce que la Forêt a réveillé | 0 | 4 |
| **Total** | **3** | **22** |

✅ 3 donjons (règle : 3 à 5) · ✅ 22 cinématiques (règle : 10 à 30) · ✅ 3-4 h.

---

## 5. Standard de qualité cinématique — cible chiffrée

Toute cinématique du ch6 et des suivants doit atteindre la densité du Mont
Windsep. Cible mesurable, vérifiable par outil :

| Règle | Seuil |
|---|---|
| Un personnage qui parle est **regardé** | ≥ 1 `CharTurnToCharAnimated` par changement de locuteur |
| Une arrivée/un départ est **marché** | `EightWayMove`, jamais `TeleportTo` à vue |
| Les acteurs bougent **ensemble** | `BranchCoroutine` + `JoinCoroutines` sur toute action simultanée |
| Le corps parle avant la bouche | `EmoteAndPause` avant les répliques fortes |
| Reprise de main | `GeneralFunctions.RendreLaMain()` — jamais une coupe sèche |
| Émotions | via `GeneralFunctions.SetEmotion` (garde-fou anti-crash) |

Un outil `tools/audit_densite_cinematique.py` sera ajouté pour mesurer ces
ratios par chapitre et refuser toute scène sous le seuil.

---

## 6. Arbitrages avant rédaction

1. **Fond `Chapter_6`** : je le génère (image + filtre + titre FR), ou tu le
   fournis ? Le ch5 n'en a pas non plus — je peux traiter les deux.
2. **Qulbutoké** : Okéoké traduit ses répliques (recommandé), ou dialogue
   articulé classique ?
3. **Ordre de production** : je commence par 6.1 (le réveil, qui pose la boucle
   de guilde), ou par 6.4 (la remise à niveau de la Forêt existante) ?
4. **Donjons de 6.2 et 6.3** : je pioche dans les 77 zones libres, ou tu as des
   lieux précis en tête ?
