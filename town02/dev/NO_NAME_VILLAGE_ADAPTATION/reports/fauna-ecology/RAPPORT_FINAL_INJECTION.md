# Injection de la faune — rapport final

Ordre imposé respecté :
`double pilotage → backup/tag → index.idx → validations → dry-run final →
injection → validations → contrôle visuel → rapport`.

**21 232 contrôles au vert** (5 991 suite écologie + 15 241 post-injection),
0 régression, 0 refus d'injection.

---

## 1. Double pilotage retiré

`source_birds` (12) et `source_butterflies` (19) supprimés de **trois** endroits
— les deux copies de `NNVLife.lua` **et** le générateur
`build_rmvillage_life_patch.py` qui les recréait à chaque exécution
(`EMIT_SOURCE_ANIMALS=False`). Sans ce troisième point, le conflit serait revenu
à la première régénération.

`NNVEcology` est désormais propriétaire unique : chaque entité injectée porte
`nnv_owner: "NNVEcology"`.

Garde ajoutée + vérifiée par régression : réintroduire `source_birds` fait
échouer le test (`double pilotage avec NNVEcology`).

## 2. Sauvegarde et tag

| Élément | État |
|---|---|
| Tag `pre-fauna-injection` | `d17766cd`, poussé |
| `Content/Tile/index.idx` (23,5 Mo) | sauvegardé, sha256 vérifié identique |
| `Data/Zone/index.idx` | sauvegardé |
| 34 Grounds | sauvegardés en `.pre-fauna.bak` avant écriture |

## 3. `index.idx` — installé et prouvé

735 → **741 planches**. Les 735 préexistantes sont vérifiées **entrée par
entrée** après réécriture : intactes.

### Un incident réel, détecté par la garde

La première tentative d'installation a été tuée par timeout après 900 s : les
`.tile` et `.rsmap` étaient copiés mais **`index.idx` n'était pas mis à jour**.
`verify_tile_index.py` a immédiatement signalé `DAMIER (cause A)` sur les six
maps. Rollback complet, cause identifiée — concaténation de `bytes` quadratique
sur 1,47 M d'entrées — corrigée par `b''.join`. Nouvelle exécution : **1,06 s**.

C'est exactement le scénario du commit `9cbdf80` de 2026-08-05. Cette fois il a
été attrapé avant d'atteindre le jeu.

### Les deux causes du damier, revalidées après installation

| Cause | Test | Résultat |
|---|---|---|
| A — `Sheet` inconnu | planche `Planche_Fantome` | ✅ détectée |
| B — `TexLoc` inconnu | `(9999,9999)` | ✅ détectée |

Non-régression : les 3 maps de raid préexistantes → **2 064 tuiles, aucun
damier**. Les 6 maps de duel → **1 891 tuiles, aucun damier**.

## 4. Dry-run final — réconciliation exacte

```
1 808 placés = 1 642 injectés + 109 hors-saison + 57 sans-preuve  → COHÉRENT
```

| Axe | Valeur |
|---|---|
| Cellules uniques | 1 642 (aucun doublon) |
| Par saison | `summer: 1642` |
| **Par biome** | `grass 949 · open 419 · plant 135 · water 129 · marsh 10` |
| Espèces injectées | 12 (été) sur 23 promouvables |
| Rooms touchées | 34 |
| Double pilotage | **AUCUN** |

Le tableau par biome est la preuve directe qu'**aucun Pokémon n'est dans un
arbre, un rocher, un mur ou une falaise** : ces terrains n'apparaissent pas.

## 5. Injection

**1 642 entités écrites dans 34 Grounds, 0 refus.** Chaque position a franchi
deux gardes indépendantes : le terrain de l'atlas *et* la grille de collision du
Ground lui-même relue à 8 px.

Chaque entité porte ses `ScriptVars` : espèce, profil, colonie, saisons, heure,
comportement social, propriétaire. **Aucun sprite posé sans comportement.**

### Ce qui n'a PAS été injecté — conforme aux arbitrages

| Retenu | Nombre | Raison |
|---|---:|---|
| Rooms `NO_PROOF` | 57 individus | 11 rooms sans rendu ni collision |
| Hors-saison | 109 individus | seule la variante `summer` existe |
| **Cradily** | 92 occurrences | toutes dans `rmcave1*`, aucune preuve |
| **Sandshrew** | 16 individus | idem |

Aucun relogement, aucun remplacement, aucune extrapolation.

## 6. Validations post-injection — 15 241 contrôles

Relues **depuis les fichiers écrits**, sans faire confiance aux rapports :

| Exigence | Résultat |
|---|---|
| Aucun Pokémon exclu | ✅ |
| Aucun légendaire/fabuleux | ✅ |
| Aucun doublon Metano/Guilde | ✅ |
| Aucun Pokémon sur obstacle | ✅ (terrain + collision 8 px) |
| Aucune room `NO_PROOF` injectée | ✅ (vérifié aussi côté rooms) |
| Aucun `HELD` injecté | ✅ |
| Aucun profil végétatif | ✅ |
| Aucun double pilotage | ✅ |
| Duel non pixel-perfect | ✅ aucun |
| Damier mauve | ✅ aucun |
| Ground cassé | ✅ aucun |
| **Régression de collision** | ✅ aucune — `obstacles` identiques au backup |
| **Régression de rendu** | ✅ aucune — `Layers` identiques au backup |

Comparaison structurelle stricte contre les `.pre-fauna.bak` : seule la liste
`MapChars` a changé.

## 7. Contrôle visuel

`injected-grounds-view.png` — entités relues **dans les Grounds injectés**, pas
depuis le plan :

- **rm83** (87) : Magikarp et Barboach dans l'étang, Vivillon et Cutiefly dans
  les clairières, rien sur les nénuphars ni dans les arbres ;
- **rm82** (62) : la colonie aquatique épouse le lac, la berge sableuse reste
  libre ;
- **rmvillage** (31) : **aucun Pokémon dans les quatre maisons ni sur les
  chemins de terre** ; ils occupent les lisières et les jardins ;
- **rm84** (99) : dispersion en prairie avec de vrais espaces vides.

## 8. Le monde vit — mesuré, pas affirmé

Simulation de la boucle `NNVEcology` sur les 87 entités réelles de rm83,
300 passes (~3 min 20 de jeu), **sans aucune action du joueur** :

| Mesure | Résultat |
|---|---|
| Déplacements | **21 415** |
| Rencontres inter-espèces | **80** |
| Individus n'ayant jamais bougé | **0** |
| Dont végétatifs (anomalie) | **0** |

Les Pokémon errent, marquent des pauses volontaires nommées (`guet`, `broute`,
`embuscade`, `immobile_eau`…), se croisent et réagissent selon la matrice de
relations à 7 verbes.

---

## 9. État final et limites honnêtes

**Ce qui est dans le dépôt** (poussé) : les 6 maps de duel, leurs planches,
`index.idx` à 741 planches, les scripts Lua, les outils et tous les rapports.

**Ce qui n'y est pas** : les 34 Grounds injectés vivent dans `/tmp/reconv`
(1,7 Go). C'était le plan validé — ils sont hors dépôt depuis la reconversion.
Ils sont sauvegardés en `.pre-fauna.bak` mais **un reset du sandbox les
détruirait**. Leur empaquetage (`package_zone_grounds.py`, gzip ×26) reste à
faire si tu veux les conserver.

**Non fait, faute de moyen** :
- Runtime PMDO jamais lancé — bundle headless absent. Statut `NOT_CERTIFIED`.
- Zone `nnv_wild.json` et ses segments non créés : les duels ont leurs maps et
  leurs planches, mais `NNVDuel.SEGMENTS` est vide, donc **aucun duel ne peut
  encore se déclencher**. C'est volontaire : créer la zone touche
  `Data/Zone/index.idx`, second fichier partagé à risque.
- Les scripts Lua sont dans `generated/fauna/`, **pas encore copiés** dans
  `Data/Script/halcyon/`.

Le contrôle visuel est un rendu statique annoté, pas une capture du moteur en
mouvement : la vie est prouvée par simulation de la boucle, pas par le jeu.
