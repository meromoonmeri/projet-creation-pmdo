# Écosystème Pokémon vivant des zones NNV

**Statut : architecture + casting + placement + comportements + pipeline de duel
construits et validés. Aucun Ground existant n'a été modifié.** Conformément à
la consigne, l'écriture dans les Grounds attend la validation de cet audit.

45 rooms analysées · 25 espèces · 1 808 individus placés · 0 violation
écologique · duels pixel-identiques sur 6 biomes · **4 876 contrôles au vert**.

---

## 1. Ce qui a été construit

| Livrable | Fichier |
|---|---|
| Atlas écologique des 45 rooms | `biome-atlas.json.gz` |
| Roster d'espèces + profils comportementaux | `../../config/fauna-species.json` |
| Placement de 1 808 individus | `fauna-placement.json.gz` |
| Moteur de vie autonome | `../../generated/fauna/NNVEcology.lua` |
| Duel sauvage | `../../generated/fauna/NNVDuel.lua` |
| Générateur de map de duel | `../../tools/build_duel_map.py` |
| Gardes anti-régression | `../../test_fauna_ecology.py` |
| Audit d'emprise écran | `DUEL_EMPRISE_ECRAN.md` |

---

## 2. L'atlas : lire le terrain avant de placer quoi que ce soit

Trois autorités, par ordre de confiance :

1. **Le rendu réel** (4992×4992 px par room). Les identifiants de tuiles
   **mentent** : les couches `water` / `endwater` / `marsh` sont des fonds
   pleins 39×39 parfois entièrement recouverts. rmvillage a une couche
   `endwater` pleine et **pas une goutte d'eau à l'écran**. Classer l'eau par
   tile-ID aurait noyé le village.
2. **La collision du Ground reconverti** (624×624 cellules de 8 px, agrégée en
   78×78) : autorité sur la praticabilité.
3. **Les GameObjects source** avec leurs vrais préfixes saisonniers
   (`objsmtree`/`objautree`/`objwntree`/`objtree`, `objauplant`/`objsmplant`/…,
   `objboulder`, `objwaterfall`, `objsnowpile`, `objcolwall`…).

### Le piège de rm59

Le feuillage lavande de rm59 `(180,185,227)` passe **tous** les tests « bleu »
naïfs et faisait apparaître 2 757 cellules d'eau dans une forêt. L'eau NNV est
un **cyan saturé** : `b ≥ 150 ∧ (b−r) ≥ 90 ∧ g > r+40`. Discriminateur validé
sur 14 couleurs témoins (eaux des 3 rooms, 4 nuances de lavande, herbes, terre,
sable, ombres) → rm59 retombe à 92 cellules d'eau, ses vrais ruisseaux.

Contrôle visuel atlas vs rendu : `atlas-vs-render.png`.

---

## 3. Le casting : 25 espèces, zéro doublon

Les trois exclusions sont **vérifiées par script**, pas déclarées :

- **98 espèces exclues** (26 lues dans les Grounds `metano_*`/`guild_*`, plus
  les PNJ instanciés par script via `CharacterEssentials`) ;
- **83 légendaires/fabuleux** exclus.

Conséquences directes : Croagunk, Murkrow, Ledian, Skorupi, Wooper et Shuckle
— tous plausibles au vu des sprites — sont **interdits**. D'où :

| Sprite source | Choix canonique | Retenu après exclusion |
|---|---|---|
| grenouille verte `sfrog00` | ~~Croagunk~~ | **Politoed** |
| patineur d'eau `smobsm2i1` | ~~Wooper~~ | **Surskit** |
| arachnide sur pattes `smobau1i0` | ~~Ledian~~ | **Ariados** |
| crustacé de face `smobwn2i0` | ~~Skorupi~~ | **Crabrawler** |
| petit volant noir `smobwn5i0` | ~~Murkrow~~ | **Delibird** |

Chaque espèce porte sa preuve (`evidence`) : dimensions du sprite décodé +
constantes GML (`maxhp`, `dmg`, `level`, `season`, `dig`/`fly`/`water`). Les
choix non déductibles du sprite sont marqués `design_adaptation: true` avec la
raison — comme demandé, **je tranche et j'assume plutôt que de laisser des
`NON_IDENTIFIÉ`**.

Deux lignes évolutives émergent de la source elle-même :
**Ledyba → Ariados** (automne, hp 4 → 6) et **Swinub → Piloswine**
(hiver, hp 8 → 35, `dig`+`bite`, `collision=false`).

---

## 4. Le placement : écologique, pas décoratif

On ne recopie **pas** les coordonnées source — elles pointaient vers des arbres
et des murs. Chaque occurrence dit *combien* d'individus vivaient là ; l'atlas
dit *où* ils peuvent crédiblement vivre. On recompose des **colonies**.

Règles dures, vérifiées par assert avant écriture :

- jamais sur `blocked` / `tree` / `rock` / `cliff` / mur / bâtiment ;
- une espèce `requires: water` est **dans** l'eau ; `near_water` à ≤ 2 cellules
  de la rive ; `near_tree` à ≤ 2 cellules d'un tronc ;
- un volant exige un ciel dégagé (≥ 6 voisines libres sur 9) ;
- deux individus ne partagent jamais une cellule ;
- **9 cellules minimum** entre deux colonies de la même espèce (pas de grappes) ;
- **densité plafonnée à 26 individus / 1 000 cellules exploitables**, et le test
  échoue au-delà de 10 % d'occupation : les espaces vides sont garantis.

Résultat : **1 808 individus, 0 violation**. Contrôle visuel sur le rendu réel :
`placement-on-render.png` (les Magikarp sont dans l'eau, les Vivillon dans les
clairières, rien dans les maisons de rmvillage).

---

## 5. Les comportements : rien de végétatif

16 profils, chacun avec vitesse, taux de pause, rayon, distance de fuite et une
**liste d'états nommés**. Toute immobilité est un état volontaire — `broute`,
`guet`, `embuscade`, `immobile_eau`, `sous_terre`, `ancre` — jamais un trou du
système. Le test refuse tout profil non-sessile dont `pause_ratio = 1.0`.

Exemples : `wader` (échassier) reste 70 % du temps planté dans l'eau puis pique
du bec ; `ambusher` (Ariados) est immobile à 85 % puis se détend d'un coup ;
`sessile` (Cradily, Bellsprout) ne se déplace **jamais** mais oscille et
s'oriente ; `predator` (Piloswine) patrouille large et fait des charges courtes.

### Le monde tourne sans le joueur

Aucun comportement n'est déclenché par une action du joueur. Les rencontres
inter-espèces appliquent une **matrice de relations** à 7 verbes : `ignore`
(défaut), `curieux`, `evite`, `fuit`, `chasse`, `grege`, `rivalise`. Ariados
chasse les papillons, Swanna chasse les Magikarp, Cutiefly fuit tout ce qui
vole plus gros, Swinub se regroupe avec Piloswine, deux Crabrawler se
confrontent. Le calme est le défaut : c'est ce qui donne de la valeur aux
scènes.

**Budget CPU** : 6 individus simulés finement par passe (≈ 0,66 s), curseur
circulaire, simulation fine réservée aux individus à moins de 640 px du joueur.
Une room de 100 Pokémon coûte autant qu'une room de 12.

Saison et heure filtrent la présence : Volbeat et Illumise n'existent que la
nuit, Ledyba/Ariados/Dwebble/Chinchou/Swanna/Lotad en automne, Swinub/
Piloswine/Crabrawler/Delibird/Ducklett en hiver. La bascule montre/cache sans
recharger la room.

---

## 6. Le duel : même lieu, plein écran, pixel-perfect — prouvé

### Le chiffre qui a tout décidé

Une `.rsmap` couvrant **tout** le Ground NNV : 208 × 208 = 43 264 tuiles ≈
**139 Mo par duel et par saison**. Non viable.

### Ce que le moteur prouve

`BaseGroundScene.cs` l. 155 et `BaseDungeonScene.cs` l. 167 calculent le
`ViewRect` **en pixels**, à l'identique. L'emprise visible est **la même surface
en pixels** dans les deux scènes ; seule la taille de tuile qui la remplit
diffère (64 px en Ground, 24 px en donjon). Les 4992 × 4992 px du Ground **ne
sont jamais visibles**.

### La solution retenue

Fenêtre de **26 × 14 tuiles = 624 × 336 px**, soit 1,3 × 1,24 écran à 480×270 —
le décor déborde de tous les côtés : aucune bande noire, aucun bord de map, le
scroll pendant le combat reste dans le décor authentique. La fenêtre est
**découpée pixel à pixel dans le rendu du Ground**, centrée sur le lieu de
l'affrontement, clampée aux bords, puis retuilée en 24 px avec déduplication.

Collision reprise du Ground (8 px → 24 px, règle MAJORITÉ).

### La preuve

| Room | Biome | Tuiles distinctes | Pixels divergents | Identique |
|---|---|---:|---:|---|
| rm83 | étang / nénuphars | 328 | **0** | ✅ |
| rm82 | lac / berge sableuse | 323 | **0** | ✅ |
| rm35 | marais d'automne | 324 | **0** | ✅ |
| rmvillage | village | 292 | **0** | ✅ |
| rm59 | forêt lavande | 338 | **0** | ✅ |
| rm84 | prairie / cultures | 286 | **0** | ✅ |

SHA-256 de la fenêtre source == SHA-256 de la map reconstruite, sur les six.
Comparaison visuelle : `duel-maps/PIXEL_PROOF_rm83.png` (`bbox diff: None`).

Coût : **~190 Ko par duel** (143 Ko de map + 46 Ko de planche) au lieu de
139 Mo, pour un rendu strictement identique dans tout ce que le joueur voit.

Les duels sont **rares et autonomes** : uniquement entre territoriaux d'espèces
autorisées, cooldown de 2 minutes de jeu par room, jamais déclenchés par le
joueur — qui assiste sans participer.

---

## 7. Gardes anti-régression

`test_fauna_ecology.py` — **4 876 contrôles**. Vérifié qu'ils échouent
réellement sur régression simulée :

| Régression injectée | Détectée |
|---|---|
| Ajout de Croagunk (déjà à Metano) | ✅ 2 échecs |
| Un individu déplacé dans un arbre | ✅ `rm14/ariados dans un obstacle (13,0) t=5` |
| Preuve de duel corrompue (812 px divergents) | ✅ 2 échecs |
| Profil `timid` mis en pause permanente | ✅ `profil timid en pause permanente` |

Retour au vert après restauration dans les quatre cas.

---

## 8. Ce qui reste, et pourquoi

- **11 rooms sans preuve de terrain** (`rm38`, `rm47`, `rm48`, `rm49`, `rm57`,
  `rm68`, `rm77`, `rmcave1*`) : leurs Grounds reconvertis n'existent pas encore,
  donc ni collision ni rendu. Elles sont placées sur les seuls GameObjects, avec
  une densité prudente. **Cradily n'est pas placé** pour cette raison : ses 92
  occurrences sont toutes dans `rmcave1_*`. Fail-closed plutôt que deviner.
- **Injection dans les Grounds non faite** : conformément à la consigne, aucun
  Ground n'est modifié avant validation de cette architecture.
- **Runtime PMDO jamais relancé** : le bundle headless est absent du sandbox.
  Statut global inchangé, `NOT_CERTIFIED`.
- **`index.idx`** : l'injection des planches de duel est codée mais non
  installée (pas de `--install` lancé). Sans elle : damier mauve/noir.
