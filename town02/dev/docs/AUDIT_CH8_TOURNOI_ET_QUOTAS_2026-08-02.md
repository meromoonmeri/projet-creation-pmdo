# Chapitre 8 — Grand Tournoi : audit d'implémentation et quotas réels

Date : 2026-08-02 — branche `new-era-1-9`, build `2026-08-03-S`
Question posée : le tournoi a-t-il été introduit, et les chapitres
atteignent-ils 7 000 boîtes de dialogue ?

**Réponse courte : non aux deux.** Le tournoi n'existe pas dans le code, et
aucun chapitre n'atteint le quota — les plus fournis plafonnent à 43 %.

---

## 1. Quotas réels — mesurés par l'outil du projet

`tools/count_dialogue.py` lancé sur un checkout à jour de `new-era-1-9` :

| Chapitre | Boîtes | Quota | Atteint | Manque |
|---|---:|---:|---:|---:|
| ch1 | 644 | — | — | — |
| ch2 | 659 | — | — | — |
| ch3 | 659 | — | — | — |
| ch4 | 524 | — | — | — |
| **ch5** | **1 740** | 7 000 | 24,9 % | 5 260 |
| **ch6** | **3 033** | 7 000 | 43,3 % | 3 967 |
| **ch7** | **3 012** | 7 000 | 43,0 % | 3 988 |
| **ch8** | **412** | 7 000 | 5,9 % | 6 588 |
| **ch9** | **413** | 7 000 | 5,9 % | 6 587 |
| **ch10** | **379** | 7 000 | 5,4 % | 6 621 |
| **ch11** | **18** | 7 000 | 0,3 % | 6 982 |
| multi-chapitres | 169 | | | |
| commun | 2 222 | | | |

**Déficit total sur ch5 → ch11 : environ 40 000 boîtes.**

Note : le chiffre ch11 (18) ne compte pas encore `AccusationArc.lua`, poussé au
commit `0c84477` — le module ajoute 83 répliques, ce qui porterait le ch11 à
~101. L'ordre de grandeur ne change pas.

Sur l'objectif « 5 à 6 h de jeu par chapitre » : les ch6 et ch7, les plus
fournis, sont à moins de la moitié. Le ch7 est le mieux doté grâce à
`metano_town_ch_7.lua` — 6 844 lignes, 387 fonctions, 2 327 dialogues, dix
variantes de discussion pour une trentaine de PNJ. **C'est le modèle à suivre**,
et il montre ce que coûte réellement un chapitre au quota : un seul fichier de
ville pèse autant que tout le reste du chapitre.

## 2. Le tournoi n'est pas implémenté

Recherche sur les 692 fichiers Lua du dépôt :

| Élément | Occurrences | Où |
|---|---:|---|
| « Tournoi » / « Tournament » | 174 | **169 dans `metano_town_ch_7.lua`** — ce sont les `*_TournamentTalk` des PNJ, une simple rumeur de ville, pas le tournoi |
| Zorua / Zoroark | **1** | `personality_test/init.lua` — sans rapport |
| `QuizScore` | 1 | `scriptvars.lua` seulement — la variable est déclarée, jamais écrite |
| `kirlia_quiz` | 0 | le script du document n'a jamais été créé |
| Wobbuffet / Qulbutoké | **0** | — |
| Wynaut / Okéoké | **0** | — |
| Les 10 guildes inventées | **0** | aucun nom ne figure nulle part |

Le document `CHAPITRE8_GRAND_TOURNOI_INTER_GUILDE.md` est donc **un plan, pas
une livraison**. Les 169 mentions de « tournoi » sont des dialogues d'habitants
du ch7 qui en parlent comme d'une rumeur — ce qui est un bon terrain
d'amorçage, mais ne constitue pas l'événement.

## 3. Ce qui existe déjà et sert de socle

### Acteurs déclarés dans `CharacterEssentials`

`Spinda`, `Camerupt`, `Relicanth`, `Tropius`, `Bisharp`, `Luxray`, `Alakazam`,
`Tyranitar`, `Charizard`, `Adagio`, `Aria`, `Sonata`, `Murkrow`.

Les chefs de 5 des 10 guildes inventées sont donc **déjà en place** (Camerupt,
Relicanth, Tropius, Bisharp, Luxray). Mais attention : Tropius est **Penticus**,
le doyen de la guilde de Metano, et Bisharp est **Zhayn**. Les réutiliser comme
chefs de guildes étrangères créerait une collision d'identité — il faut des
fiches distinctes, comme pour les deux Xatu.

### Acteurs manquants — 15 fiches à créer

`Wobbuffet`, `Wynaut`, `Kirlia`, `Zorua`, `Zoroark`, `Raichu`, `Abomasnow`,
`Umbreon`, `Musharna`, `Talonflame`, `Gengar`, `Weavile`, `Mimikyu`, `Sableye`,
`Scizor`.

Cas particulier : **Kirlia n'est pas déclarée** alors qu'elle est déjà placée
au Café Spinda (8 occurrences dans `metano_cafe/init.lua`) avec 98 lignes de
quiz livrées par `ee06be8`. C'est le même schéma que Goinfrex et Xatu : entité
présente, fiche absente, scène qui plante en silence sous `pcall`.

### Donjons de la traque

| Donjon du plan | Zone | État |
|---|---|---|
| Mont Tonnerre | `mont_grondant` | **existe**, 6 segments, niveau 47 |
| Forêt Givrée | `foret_givree_oree` | **zone absente** (seul le ground existe) |
| Croisée de Cristal | `croisee_cristal` | **zone absente** (seul `croisee_cristal_porte` existe) |
| Forêt Embuscade | `foret_embuscade` | **existe**, 5 segments, niveau 16 |

Deux donjons sur quatre sont à créer.

### Un conflit à trancher

Le plan fixe le boss de la Croisée de Cristal à « la famille Évoli au complet ».
Or `croisee_cristal_porte` est documenté dans `vague4_sloth_import_total.md`
comme « ch20 Meloetta — entrée Amphithéâtre ». Il faut choisir : soit la
Croisée sert au tournoi du ch8, soit elle reste réservée au ch20.

## 4. Problème de structure : ch8 ou ch9 ?

Vous dites « le chapitre 8 ou 9 ». Le choix n'est pas neutre :

- **ch8 actuel** = Sanctuaire de Cristal, boss Diancie, dont la scène finale
  (`ChapterAftermath.CrystalVictory`) porte le **premier doute** de l'arc :
  « Elle n'est pas battue : elle s'arrête de se battre. »
- **ch9 actuel** = Marais de l'Oubli, où le **Cercle du Suaire se montre** pour
  la première fois — le pivot de toute la trame.

Insérer un tournoi de cinquante cinématiques dans l'un ou l'autre casserait la
montée dramatique. Trois options :

1. **Tournoi = nouveau chapitre intercalaire** entre le ch7 et le ch8 actuels.
   Renumérotation de tous les chapitres suivants. Le plus propre
   narrativement, le plus coûteux techniquement (flags `SV.ChapterN`, cartons,
   veillées, `ChapterProgression`).
2. **Tournoi = première moitié du ch8**, le Sanctuaire devenant la seconde.
   Cohérent avec votre « plusieurs chapitres ont des sous-parties », et règle
   le quota d'un coup : le tournoi apporterait facilement 3 000 à 4 000 boîtes.
3. **Tournoi = ch9**, avant l'apparition du Suaire au Marais. Mais le contraste
   entre une fête et la révélation du Suaire serait brutal.

**Ma recommandation : option 2.** Le tournoi est organisé par Spinda « pour
apaiser l'anxiété de la population face aux séismes » — c'est exactement le
climat du ch8, juste après les révélations du ch7 sur les Cœurs. Le divertissement
comme diversion collective, puis le Sanctuaire qui ramène au sérieux. Et cela
évite de renuméroter sept chapitres.

## 5. Volume à produire

Cinquante cinématiques, trois épreuves, onze guildes. Estimation à la maille
d'une scène de qualité (30 à 60 boîtes, ce qui est le calibre des scènes
existantes) :

| Bloc | Scènes | Boîtes estimées |
|---|---:|---:|
| Annonce du tournoi, arrivée des 11 guildes | 12 | 700 |
| Épreuve I — traque, 4 donjons + 4 boss + embuscade | 14 | 900 |
| Interlude 3 jours (ville, rumeurs, entraînement) | 6 | 500 |
| Épreuve II — quiz de Kirlia | 4 | 300 |
| Interlude 3 jours | 6 | 500 |
| Épreuve III — quarts, demie, finale | 10 | 800 |
| Cérémonie, retombées en ville | 6 | 400 |
| **Réactions PNJ après chaque épreuve** (modèle ch7) | — | **1 500** |
| **Total** | **~58** | **~5 600** |

Cela porterait le ch8 de 412 à environ 6 000 — proche du quota, sans compter le
Sanctuaire de Cristal qui resterait la seconde moitié.

## 6. Ordre de travail proposé

1. **Trancher ch8 vs ch9** et la structure en sous-parties.
2. **Créer les 15 fiches manquantes**, en évitant les collisions d'identité
   (Tropius/Penticus, Bisharp/Zhayn) — suffixe de guilde comme pour `Bourg_Xatu`.
3. **Brancher Kirlia** : sa fiche manque alors que son quiz de 98 lignes existe
   déjà. Correction courte, gain immédiat.
4. **Créer les 2 zones manquantes** et trancher le conflit Croisée de Cristal.
5. **Écrire par blocs**, en commençant par l'Épreuve I (la plus autonome).
6. **Étendre `metano_town_ch_8.lua`** sur le modèle du ch7 : c'est là que se
   gagne le quota, et c'est ce qui fait vivre la ville entre les épreuves.

## Réserve

Les chiffres de quota viennent de `tools/count_dialogue.py`, l'outil du projet,
lancé sur le dépôt à jour. Ma propre mesure indépendante donne des totaux
légèrement différents (méthode de comptage des helpers), mais le même ordre de
grandeur et les mêmes conclusions.

Rien n'est testé manette en main.
