# Quête Shaymin / Sky Peak / Raikou — vérification des assets

Date : 2026-08-02 — branche `new-era-1-9`
Demande : quête secondaire organisée par Spinda, sauver des Shaymin piégés au
Village Shaymin par un légendaire installé au sommet du Sky Peak — **Raikou**
au lieu de Zekrom.

---

## 1. Les grounds n'existent pas. Ni dans EoSO, ni ailleurs.

Vérifié sur les trois dépôts, arbre Git complet :

| Dépôt | Grounds | Shaymin Village | Sky Peak |
|---|---:|---|---|
| **EoSO** (`Minemaker0430`) | 95 | **absent** | **absent** |
| **DumpAsset** (`audinowho`) | 18 | **absent** | **absent** |
| **New Era** | 277 | **absent** | **absent** |

Les 95 grounds d'EoSO ne contiennent aucun `sky_peak_*` ni `shaymin_*`. Les
seuls résultats sur « peak » sont `mt_bristle_peak` et `mt_travail_peak`, sans
rapport. Les 18 grounds de DumpAsset sont des camps et des lieux de hub.

**Ce qui existe en revanche, et qui est exploitable :**

| Asset | Source | État |
|---|---|---|
| `Sky Peak Cave.ogg`, `Coast`, `Forest`, `Prairie` | **déjà dans New Era** | 4 musiques sur 6 |
| `Sky Peak Final Pass.ogg`, `Snowfield.ogg` | EoSO | à importer |
| `Shaymin Village.ogg` | EoSO | à importer |
| `SkyPeak4thPass.tile`, `SkyPeak7thPass.tile`, `SkyPeakSummitPass.tile` | **DumpAsset** | 3 tilesets |
| 9 autotiles `sky_peak_*_pass_{wall,floor,secondary}` | **DumpAsset** | complets |

Autrement dit : **le décor du donjon est disponible**, il manque les cartes
elles-mêmes (les `.rsground` de village et d'entrée) et la zone.

## 2. Raikou et Shaymin sont déjà implémentés — et c'est un conflit

C'est le point qui demande votre arbitrage.

Les deux sont **déjà des Ancrages du Livre II**, avec cinématique écrite,
ground dédié et entrée dans `LegendZones` :

| | Shaymin | Raikou |
|---|---|---|
| Clé `LegendZones` | `thanks_bloom` | `storm_bell` |
| Zone | `jardin_gratitude`, segment 1 | `crete_voilee`, segment 5 |
| Ground de cinématique | `champ_sacre` (87 l.) | `arene_hautes_plaines` (88 l.) |
| Titre | « Là où Fleurit le Merci » | « la Cloche des Orages » |
| Débloqué au | **chapitre 15** | **chapitre 16** |
| Prix de la piste | 30 000 | 26 000 |
| `roam` | true | true |

Les deux cinématiques suivent déjà la grammaire Rescue Team documentée :
signal → irruption → recul → flash → reveal → titre → ligne courte.

**Le problème** : placer une quête Shaymin+Raikou au chapitre 8 ferait
rencontrer au joueur, en quête secondaire, deux légendaires que le jeu réserve
comme Ancrages sept et huit chapitres plus tard. C'est exactement le motif que
la règle « aucun légendaire en boss d'add-on générique » cherche à éviter, et
c'est le même conflit que celui déjà relevé pour Zeraora au ch6.

### Trois options

**(a) Décaler la quête au Livre II**, après le ch16. Les deux Ancrages sont
alors déjà rencontrés, et la quête devient une suite naturelle — « le légendaire
que vous avez affronté s'est installé quelque part ». Zéro conflit, mais ce
n'est plus une quête de Spinda au ch8.

**(b) Garder la quête au ch8 et assumer l'antériorité**, comme pour Zeraora :
Raikou s'installe au sommet, le duo le déloge sans le vaincre vraiment, et
l'Ancrage du ch16 devient la vraie confrontation. Cohérent avec le système de
rematch déjà en place (`fosse_argentee` : « Rematch : intro raccourcie »).

**(c) Un autre Pokémon puissant non légendaire** au sommet du Sky Peak.

Je recommande **(b)** : elle ne coûte aucun asset, réutilise un mécanisme
existant, et donne du poids au ch16 au lieu de le vider.

## 3. Ce que la quête demanderait comme travail

Si vous validez, voici le coût réel — je préfère l'annoncer avant :

| Élément | État | À produire |
|---|---|---|
| Musiques Sky Peak (4/6) | présentes | importer 2 pistes d'EoSO |
| `Shaymin Village.ogg` | EoSO | à importer |
| Tilesets Sky Peak (3) | DumpAsset | à importer |
| Autotiles (9) | DumpAsset | à importer |
| Zone `sky_peak` | **inexistante** | créer, avec segments |
| Ground `shaymin_village` | **inexistant** | créer entièrement (carte, collisions, entités) |
| Ground entrée Sky Peak | **inexistant** | créer |
| Ground sommet (arène Raikou) | **inexistant** | créer |
| Fiches `CharacterEssentials` | Shaymin OK, Raikou OK | ajouter les Shaymin captifs |
| Quête dans `SideQuests.LIST` | 15 quêtes existantes | ajouter la 16e |

Créer trois grounds de zéro — carte, décor, collisions tracées case par case —
est le poste le plus lourd. Les tilesets existent, mais **peindre une carte
n'est pas la même chose que disposer d'un tileset**.

## 4. Ce que j'ai déjà livré dans ce lot

Indépendamment de la quête, le **rythme entre chapitres** est implémenté
(`guild_heros_room/init.lua`) :

Avant, la porte de chapitre n'imposait que `DaysPassed + 2`, et **les portes
ch7 à ch10 ne vérifiaient aucune quête secondaire** — seule celle du ch6 le
faisait. On enchaînait donjon → boss → veillée → donjon suivant en deux nuits.

Désormais, trois conditions cumulatives :

1. le drapeau de clôture du chapitre ;
2. **les 3 requêtes du chapitre rendues** (`SideQuests.AllDone`) ;
3. le délai de repos écoulé — **3 à 5 nuits selon le chapitre** :

| Passage | Nuits |
|---|---:|
| ch7 → ch8 | 3 |
| ch8 → ch9 | 4 |
| ch9 → ch10 | **5** (après le Cercle du Suaire) |
| ch10 → ch11 | **5** (après le climax) |

Le délai suit le poids de ce qui vient de se passer. `AllDone` est sous `pcall` :
si le module n'est pas chargé, le joueur n'est jamais bloqué indéfiniment.

## Réserve

Rien n'est testé manette en main. Et je n'ai pas créé la quête Shaymin : sans
arbitrage sur le conflit du §2, je risquais de produire du contenu à jeter —
comme cela a failli arriver avec `PeakVictory`.
