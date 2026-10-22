# Les 42 gardiens d'Ancrage — animations d'apparition + adieux

Build : `2026-07-31-X`

Dernier bloc de l'audit `tools/audit_boss_cinematics.py`. Deux manques
distincts, traités séparément.

---

## A. 11 arènes avaient la même apparition générique

Sur les 42 arènes, **11 n'avaient qu'un `BossFX.Flash`** — le même éclair
blanc pour Arceus, Genesect, Électhor et Palkia. Un légendaire ne doit pas
apparaître comme n'importe quel autre.

### 5 signatures neuves dans `BossFX.lua`

| fonction | type | principe de mise en scène |
|---|---|---|
| `StrikeThunder` | Électrique | La charge monte en **3 éclats de plus en plus rapprochés**, puis la foudre tombe. Le boss *est* la décharge, il n'arrive pas. |
| `BootMachine` | Acier / machine | Il ne surgit pas, il **s'allume** : cliquetis, plaques qui pivotent, mise sous tension. |
| `WarpSpace` | Psy / espace | **Aucun bruit d'impact.** Distorsion silencieuse, puis il est simplement là — il n'est jamais arrivé. C'est ce qui le rend inquiétant. |
| `RadiantDawn` | Lumière / divin | Le **seul effet où l'écran ne tremble pas**. Rien ne s'impose, tout se révèle. Flash long et doux. |
| `CrashMeteor` | Chute | Variante de `DescendSky` pour les corps qui **tombent** : vitesse 10 au lieu de 6, arrivée brutale. |

### Attribution (par type et par caractère, jamais au hasard)

- **StrikeThunder** — Raikou, Électhor, Zeraora
- **BootMachine** — Magearna, Genesect
- **WarpSpace** — Palkia, Créfadet
- **RadiantDawn** — Arceus, Solgaleo, et le gardien de l'Île Close

`arene_clairiere_secrete` (Mew + Hoopa) a été **laissée telle quelle** : sa
double apparition en cache-cache est déjà travaillée et colle aux deux
personnages.

### Règle de prudence appliquée

**Aucune animation inventée.** Un nom d'animation inexistant échoue *en
silence* côté moteur : l'effet ne se joue pas et rien dans le log ne le
signale. J'ai donc extrait la liste des animations attestées par le contenu
Halcyon d'origine (`git show 45c445a`) et vérifié que les 12 particules et
2 fonds employés par les nouvelles fonctions en font partie. **0 nom
inventé.**

---

## B. Les 42 gardiens n'avaient aucun après-boss — `LegendArc.lua`

On battait Arceus, Dialga ou Rayquaza et… `SetDefeated()`, un fondu, retour
en ville. Le gardien posait une question avant le combat et **n'y répondait
jamais**.

### La règle commune

Un gardien d'Ancrage n'est pas un ennemi : il **tient** une faille. Le combat
ne le tue pas, il le **stabilise**. Le joueur ne prend rien — il prouve qu'il
peut porter ce que l'autre portait. Les 42 scènes disent « la garde change »,
mais **aucune ne le dit de la même façon**.

Quelques exemples de ce que chacun devient :

- **Kyogre** — « Je ne t'ai pas laissé gagner. J'ai arrêté de pousser. »
- **Arceus** — « Vous avez monté des marches qui n'existaient pas. Elles
  existent, maintenant. » / « Je n'ai jamais dit que c'était moi. Vous
  l'avez supposé. »
- **Xerneas** — « J'ai donné la vie mille fois. Je ne me souviens d'aucun
  visage. » — puis, quand le duo dit se souvenir du sien : « …Répétez ça. »
- **Rayquaza** — « Les huit autres ont demandé à passer. Vous, vous avez
  demandé POURQUOI c'était fermé. »
- **Cresselia + Darkrai** — l'un porte les rêves doux, l'autre les cauchemars :
  « Je ne choisis pas les rêves que je porte. Personne ne m'a jamais cru. »
- **Genesect** — « On m'a construit pour quelque chose. Le fichier est
  corrompu. » / « "Choisir." Terme absent de ma documentation. Je vais
  l'ajouter. »
- **Shaymin** — le champ où fleurit le merci est vide la plupart du temps ;
  quand le duo dit « merci », une seule fleur s'ouvre.

**42 fiches**, ~7 boîtes chacune. Idempotent : la cérémonie ne se joue
qu'une fois, même si le joueur revient pour la revanche.

---

## Minutie : ce qui a été vérifié par script

Compte tenu des erreurs de dimensions commises dans les lots précédents,
**tout a été contrôlé automatiquement** :

1. **Positions relues dans les 42 `ground/*/init.lua`** — jamais recopiées
   d'un gabarit. C'est exactement l'erreur commise sur 3 fiches de
   `VeilleurArc` au lot précédent.
2. **Croisement fiche ↔ vérité terrain** : ground, nom d'instance, `x`, `y`
   et second membre des duos. Résultat : **42/42, 0 erreur**.
3. **Caméras bornées** : `near = y+18`, `wide = y+48`, chacune vérifiée à
   l'intérieur de la carte lue dans le `.rsground`. Aucun dépassement.
4. **Animations attestées** : les 12 particules et 2 fonds des nouvelles
   signatures sont tous employés par le contenu d'origine.
5. **Portée Lua** : chaque variable de boss est déclarée avant l'appel à sa
   nouvelle signature, dans les 10 fichiers modifiés.
6. **`require` présent** partout où `LegendArc.Victory` est appelé.

### 6 clés volontairement non branchées

`colossus_quarry`, `first_cradle_hoopa`, `twin_rift_latias`,
`upturned_dream`, `verdant_oath`, `victory_spark` : ce sont des zones de
**revanche** (second membre d'un duo, ou arène rachetée chez Grodoudou), pas
des premières rencontres. Y rejouer la cérémonie d'adieu n'aurait aucun sens.

---

## Résultat mesuré

| famille | boîtes de boss avant | après |
|---|---|---|
| légendaire (42) | **2,0** | **7,4** |
| réseau (10) | 3,5 | **11,7** |
| histoire (11) | 25,8 | 25,8 |
| **boss muets** | 1 | **0** |

Note d'honnêteté sur le score : le score *par fichier* des 38 arènes bouge
peu (16 → 18), parce que leur `init.lua` reste court — le contenu neuf est
porté par le module global `LegendArc`, que l'outil compte à part. La mesure
qui compte ici est **les boîtes par gardien**, qui triple.

## Validation

Lua **645/645** · `.resx` **576/576** · zones + index **208/208** ·
`verify_legend`, `verify_bg_format`, `verify_scene_positions`,
`validate_all` : tous au vert.

## Non testé

**Rien n'est testé en jeu.** Points non vérifiables par script :

- Le **rendu visuel** des 5 nouvelles signatures. Les noms d'animation sont
  attestés, mais leur composition (superposition, timing, couleurs) ne peut
  se juger qu'à l'écran.
- 4 noms de fonds employés par `BossFX` **préexistants à ma session** —
  `Heat_Wave`, `Silver_Wind`, `Fog_2`, `Cosmic_Power` — ne sont attestés
  nulle part ailleurs dans le dépôt. Je ne les ai ni introduits ni modifiés,
  mais s'ils n'existent pas côté moteur, ces overlays échouent en silence
  depuis le début. **À confirmer en jeu** (scènes concernées : `EmergeFire`,
  `EmergeMist`, la forêt du ch6, l'entrée de la Steppe).
- Les cascades `Hurt → Idle` selon les espèces : toutes n'ont pas les mêmes
  animations ground, d'où les `pcall` systématiques.
