# Arbitrages — Zeraora, Rayquaza, Lugia et les chefs de guilde

Date : 2026-08-02 — branche `new-era-1-9`
Vérifications faites avant toute modification. Rien n'a encore été écrit dans
le code : ce document pose les faits et les décisions à valider.

---

## 1. Zarude → Zeraora (boss du ch6)

### État vérifié

| | |
|---|---|
| **Zarude** | **86 occurrences dans 18 fichiers** — `metano_town_ch_6.lua` (38), `DazzlingArc.lua` (8), `zone/gloomy_forest/init.lua` (8), `gloomy_forest_boss_ch_6.lua` (6), `gloomy_forest_boss/init.lua` (5)… |
| Fiche | `Zarude` = espèce `zarude`, nom affiché « Zarude » |
| **Zeraora** | déjà déclaré : espèce `zeraora`, nom « Zeraora » — et **déjà utilisé** dans `pre_tonnerre`, `piste_fulgurante_cime/pied`, `LegendArc.lua` |

### Le point qui coince

Zeraora **est déjà un légendaire d'ancrage** du Livre II : il occupe la Piste
Fulgurante (`piste_fulgurante`, ch25 selon `vague4_sloth_import_total.md`) et
son pré (`pre_tonnerre`), avec 6 occurrences dans `pre_tonnerre/init.lua`.

Le remplacer au ch6 crée une **double apparition** : le joueur affronterait
Zeraora comme boss de forêt au chapitre 6, puis le retrouverait comme légendaire
d'ancrage au chapitre 25. C'est exactement le type d'incohérence que la règle
« aucun légendaire/fabuleux en boss d'add-on générique » cherche à éviter.

**Trois options :**

- **(a)** Zeraora au ch6 **et** on retire son ancrage du Livre II
  (`LegendZones` perd une zone).
- **(b)** Zeraora au ch6 **en tant qu'apparition antérieure assumée** — il
  s'échappe, et l'ancrage du ch25 devient une revanche. Narrativement solide,
  cohérent avec le système de rematch déjà en place (`fosse_argentee` :
  « Rematch : intro raccourcie »).
- **(c)** Un autre Pokémon puissant non légendaire au ch6.

**Ma recommandation : (b).** Elle ne coûte aucun asset, réutilise un mécanisme
existant, et donne au ch6 un boss mémorable dont le retour est justifié.

### L'image que vous avez fournie

L'arène montre un plateau de terre ocre, en dôme, cerclé de roche sombre et de
végétation — un cirque naturel fermé. Cela correspond à une arène de boss de
forêt/montagne, pas à une salle de donjon. Je n'ai pas trouvé de ground du
projet correspondant à cette capture ; si c'est un asset à intégrer, il faudra
me dire son nom de fichier — je ne peux pas le déduire de l'image seule.

## 2. Climax ch10 = Rayquaza

### Ce que ça implique

Décision prise : **Rayquaza est le boss du ch10**. Cela résout le conflit que
j'avais documenté, mais suppose de réécrire trois blocs qui disent tous Lugia :

| Bloc | Contenu à changer | Volume |
|---|---|---|
| `zone/celestial_peak/init.lua` | en-tête « boss Lugia », flags `ReachedLugiaAltar`, `DefeatedLugia`, `DiedToLugia`, réplique de mort « Lugia... le Gardien des Cieux... nous a jugés » | 6 occurrences |
| `ChapterAftermath.PeakVictory()` | toute la scène met en scène Lugia | ~30 répliques |
| `guild_heros_room` `GHR10_*` | veillée : « On a parlé à **LUGIA** » | 10 clés × 2 langues |
| `scriptvars.lua` | flags `SV.Chapter10.*Lugia*` | 6 occurrences |

**Et surtout** : c'est l'occasion de lever le blocage. Aujourd'hui
`PeakVictory()` pose `PlayedVictoryScene = true` et neutralise définitivement la
scène Rayquaza d'`autel_celeste`, seule à poser `Chapter = 11`. En basculant
`PeakVictory` sur Rayquaza et en y déplaçant la bascule de chapitre, **l'arc
fugitif redevient atteignable**.

Total : 119 occurrences de « Lugia » dans 21 fichiers, dont **66 dans le seul
`metano_town_ch_7.lua`** (dialogues d'habitants). Toutes ne sont pas à changer —
celles du ch7 parlent de la légende, pas du boss.

## 3. Lugia au ch9 — remplace Laggron

### État vérifié

Le boss actuel du Marais de l'Oubli :

```lua
--[[ Forgotten Marsh Boss — Laggron, gardien du Cœur du Marais
local boss = CharacterEssentials.MakeCharactersFromList({{'Swampert', 156, 140, ...}})
```

Fiche : clé `Swampert`, espèce `swampert`, nom affiché **« Laggron »**.
13 occurrences dans 5 fichiers.

Note : `SV.Chapter9.DefeatedMegaBlastoise` existe aussi — le flag et le boss
réel ne concordent pas. Vestige d'une version antérieure, à nettoyer.

### Le donjon canonique de Lugia

Vérifié dans `pret/pmd-red` :

```c
DUNGEON_STORMY_SEA = 19,        [DUNGEON_STORMY_SEA] = 41,   // 41 étages
DUNGEON_SILVER_TRENCH = 20,     [DUNGEON_SILVER_TRENCH] = 100,
```

Lugia réside dans **Stormy Sea (Mer Déchaînée), 41 étages**.

### Et il existe déjà dans le projet

| | |
|---|---|
| Zone | **`new_era_zone_19` — « Stormy Sea »**, 2 segments, niveau 36 |
| Ground | **`abime_tempetes`** (Abîme des Tempêtes) |
| Cinématique Lugia | **`fosse_argentee/init.lua`** — « Lugia, le Chœur Englouti », cinématique d'Ancrage Livre II ch19, déjà écrite avec la grammaire Rescue Team : signal → irruption → recul → flash → reveal → titre |

**Donc tout est là.** Remplacer le Marais par Stormy Sea au ch9 suppose :

1. porter la zone de 2 segments à la structure canonique (41 étages) ;
2. rattacher `abime_tempetes` comme entrance/arène ;
3. réutiliser ou adapter la cinématique de `fosse_argentee` ;
4. décider du sort du Marais de l'Oubli — il porte **la scène pivot du Cercle
   du Suaire** (`MarshVictory` : « Nous sommes venus COMPTER »). Cette scène ne
   doit pas disparaître : soit elle migre vers Stormy Sea, soit le Marais reste
   comme donjon secondaire du ch9.

**C'est le point le plus délicat de vos demandes** : le Marais n'est pas qu'un
donjon, c'est le pivot narratif de toute la trame.

## 4. Chefs de guilde — 6 conflits d'identité sur 10

Vérification de chaque chef proposé contre `CharacterEssentials` :

| Guilde | Chef proposé | Conflit |
|---|---|---|
| Vents | Umbreon | libre |
| **Fournaise** | Camerupt | **déjà « Dotra »** |
| **Abysses** | Relicanth | **déjà « Erleuchtet »** (allié du ch11 !) |
| **Bosquet** | Tropius | **déjà « Penticus »**, doyen de la guilde |
| **Acier** | Bisharp | **déjà « Zhayn »** |
| **Éclair** | Luxray | **déjà « Voltra »**, Escouade Fulgur |
| Songes | Musharna | libre |
| Plume | Talonflame | libre |
| **Ombre** | Gengar | **déjà « Linceul »**, Cercle du Suaire ! |
| Glacier | Weavile | libre |

Deux cas sont particulièrement graves : **Relicanth** est l'ancien qui présente
Loaklass au ch11, et **Gengar** est Linceul, membre du Cercle du Suaire. Les
réutiliser comme chefs de guilde détruirait leur identité narrative.

### Remplacements proposés

J'ai vérifié la disponibilité sur les **1 011 espèces du jeu de base**
(`DumpAsset/Data/Monster`) — et non sur `mission_gen.lua`, qui n'est qu'une
sélection de 461 espèces pour les missions.

| Guilde | Chef | Espèce | Justification |
|---|---|---|---|
| Fournaise | **Typhlosion** | `typhlosion` | libre, stade final, thématique feu |
| Abysses | **Kingdra** | `kingdra` | libre, dragon marin, prestance de chef |
| Bosquet | **Meganium** | `meganium` | libre, stade final plante |
| Acier | **Metagross** | `metagross` | libre, pseudo-légendaire acier |
| Éclair | **Magnezone** | `magnezone` | libre, électrique/acier |
| Ombre | **Chandelure** | `chandelure` | libre, spectre, silhouette marquante |

Les quatre chefs sans conflit (Umbreon, Musharna, Talonflame, Weavile) sont
conservés tels quels.

Toutes ces espèces sont **présentes dans le jeu de base et libres** dans
`CharacterEssentials`.

---

## Ce que je propose de faire, dans l'ordre

1. **Rayquaza ch10** — c'est le plus rentable : cela lève le blocage qui rend
   le ch11 inatteignable. Réécriture de `PeakVictory`, des flags et des 10 clés
   de veillée.
2. **Les 6 chefs de guilde** — création de fiches, aucun risque.
3. **Zeraora ch6** — après votre choix entre (a), (b) et (c).
4. **Lugia ch9 / Stormy Sea** — en dernier, parce qu'il faut d'abord décider du
   sort de la scène du Cercle du Suaire.

## Questions ouvertes

- **Zeraora** : option (b), apparition antérieure avec revanche au ch25 ?
- **Le Marais de l'Oubli** : la scène du Suaire migre vers Stormy Sea, ou le
  Marais reste comme donjon secondaire ?
- **L'arène de l'image** : quel nom de fichier ? Je ne peux pas la relier à un
  ground existant sur la seule capture.

## Réserve

Rien n'est testé manette en main. Aucune modification n'a encore été écrite
pour ce lot — ce document est un préalable, pas un compte rendu.
