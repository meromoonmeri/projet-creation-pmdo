# Restitution des donjons canoniques PMD Red

Source autoritative : `meromoonmeri/PMD-RED-PMDO-PORT`.

## Règle

Un donjon canonique importé est incomplet tant que son paquet ne contient pas :

- entrée canonique ;
- étapes intermédiaires disponibles ;
- fin/sommet canonique ;
- collision et géométrie 1:1 ;
- cinématique CIF correspondante ;
- adaptation Lua conservant l’ordre des actions, VFX, flashes, caméra et musique ;
- casting New Era substitué sans détourner le lieu ;
- arène `.rsmap` du même décor si un combat a lieu ;
- aucune copie morte ou association à un autre donjon.

Les 45 cinématiques de la famille D ont été importées comme sources immuables dans :

- `RESERVE/red_cinematics/` ;
- `RESERVE/red_scene_reference/`.

Elles occupent moins de 500 Ko et servent de référence de restitution, pas de scripts chargés directement par le moteur.

## Lot terminé — Sky Tower

### Sommet

- source : D13P03 / `MAP_FILE_ID_SKY_TOWER_END` / gs209 ;
- Ground et tileset remplacés par les sorties exactes de PMD-RED-PMDO-PORT ;
- géométrie : 69×75 cellules de 8 px ;
- entrée héros : `(296,296)` ;
- partenaire : `(256,296)` ;
- Rayquaza : `(272,272)` ;
- déclencheur/caméra : `(272,280)` ;
- boss de la `.rsmap` : Rayquaza seul, niveau 40 ;
- musique de l’arène : `Sky Tower.ogg` au lieu de `Team_Dazzling.ogg`.

### Cinématique

La scène New Era conserve les jalons extraits de `d13p03.cif.json` :

1. Domaine de Rayquaza ;
2. initialisation caméra ;
3. premier message ;
4. deux flashes aller/retour de 8 frames ;
5. rugissement et secousse ;
6. flash de révélation 30 frames, retour 16 frames ;
7. confrontation ;
8. combat ;
9. météorite ;
10. Hyper Beam ;
11. explosions et retour au calme.

Les VFX du port sont déjà présents et identiques octet pour octet :

- `VFX_Rayquaza_Hyperbeam_Core` ;
- `VFX_Meteor_Fragment` ;
- `VFX_Groudon_Awakening_Flame`.

Les deux premiers sont maintenant explicitement joués pendant la séquence finale.

## Doublons Sky Tower

`arc_parvis_celeste`, `arc_palier_celeste` et `arc_tour_ciel_sommet` sont des copies visuelles utilisées par l’Arc Fugitif avec des scripts de contexte distincts. Elles ne sont donc pas classées mortes. Elles devront à terme devenir des variantes de script sur les Grounds canoniques plutôt que des copies physiques, mais leur suppression immédiate casserait la séquence Ch11.

## État des autres paquets Red actifs

L’audit retrouve notamment les familles :

- D04 Sinister Woods ;
- D08 Lapis Cave ;
- D09 Mt. Blaze ;
- D10 Frosty Forest ;
- D11 Mt. Freeze ;
- D12 Magma Cavern ;
- D13 Sky Tower ;
- D23 Wish Cave.

La présence d’un Ground final et de sa CIF est maintenant vérifiée, mais cela ne signifie pas encore que chaque JSON de donjon complet est restitué. Ils doivent être traités lot par lot afin de ne pas recréer les croisements architecturaux précédents.

## Garde-fou

`tools/audit_canonical_summits.py` vérifie :

- 45 CIF et 45 références Lua ;
- correspondance de chaque Ground D actif à sa CIF ;
- géométrie, marqueurs, boss, musique et VFX de D13P03 ;
- doublons actifs non justifiés.

État après le lot Sky Tower : **0 erreur, 0 avertissement**.
