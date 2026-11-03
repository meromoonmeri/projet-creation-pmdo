# Animations de diva — Team Dazzling (`DIV1` : `DivaFan`, `DivaBloom`, `DivaSnap`)

Trois animations **spéciales de diva** dessinées pour la **morphologie de chaque membre**
de la Team Dazzling, comme demandé dans `AGENTS.md` (étape 1 après les manques de guilde).
Aucun rebond ni geste commun recyclé d'une espèce à l'autre.

| Membre | Animation | Geste propre |
|---|---|---|
| **Lopunny** (`0428`) — Sonata | `DivaFan` — *Salut aux pompons* | ses deux pompons-mains s'ouvrent en éventail vers le haut, tenus par des bras fins qui naissent au buste ; deux éclats brillent au-dessus des mains levées, puis elle s'incline en révérence (oreilles comprises) |
| **Tsar(e)ena** (`0763`) — Adagio | `DivaBloom` — *Éclosion royale* | les deux fleurs des hanches montent en arc jusqu'à la hauteur des épaules, des pétales et un éclat s'ouvrent autour d'elles, la robe ondule latéralement, puis révérence de reine sans plier les jambes |
| **Mawile** (`0303`) — Aria | `DivaSnap` — *Clac de la diva* | les cornes-mâchoires s'écartent de part et d'autre du crâne, se referment d'un claquement sec avec éclat, la tête se renverse en arrière pour un salut théâtral |

18 phases × 8 directions, 3 ticks par phase, boucle fermée (phase 1 = phase 18 = repos natif).

## Méthode, sans approximation

Les sprites natifs sont **récupérés, pas redessinés** : `sprite/0428`, `sprite/0303` et
`sprite/0763` de **PMDCollab/SpriteCollab**, épinglés au commit
`3609a86be2a4c8ad7cf255bd2255f044daafe24f` (le même que `source/sprite_audit_v2/audit.json`).
Références versionnées dans `references/` : `AnimData.xml`, `Idle-Anim/Offsets/Shadow.png`
(8 directions) et les planches de geste utiles (`Appeal`, `Kick`, `Hop`, `Rotate`, `Attack`,
`Swing`) pour l'inspiration anatomique.

Pour chaque direction et chaque phase :

1. on part de **l'image native de cette direction** — aucun sprite de face pivoté, aucun miroir
   automatique entre directions ;
2. la partie déplacée est **détectée par couleur native + connexité** dans cette vue (pompons
   crème chez Lopunny, fleurs jaunes chez Tsar(e)ena, cornes acier chez Mawile), jamais par un
   rectangle arbitraire qui mangerait le visage ;
3. le vide laissé par le déplacement devient **transparent** : rien n'est inventé à la place ;
4. les bras ajoutés sont des polylignes qui ne peignent **que des pixels vides**, avec le pelage
   et le contour pris dans la palette de l'espèce ;
5. les éclats / pétales sont dessinés **uniquement sur des pixels transparents**, avec des
   couleurs **déjà présentes** dans la planche native (contrôle : 0 couleur hors palette sur
   1 197 / 1 695 / 1 242 couleurs observées) ;
6. les repères `Offsets` suivent les parties déplacées ; l'ombre native n'est **jamais** modifiée.

## Livrables

| Chemin | Contenu |
|---|---|
| `renders/diva_dazzling_v1/<slot>_<nom>/` | `Diva<X>-Anim.png`, `-Offsets.png`, `-Shadow.png` (18 × 8) + `AnimData.xml` natif complété |
| `renders/diva_dazzling_v1/verification.json` | provenance, palette, boucle, repères, statuts honnêtes |
| `apercu_diva_dazzling_v1.html` | aperçu autonome : 3 cartes, 8 directions, 18 vignettes cliquables, pause/vitesse/« pose de diva », aucune ressource externe |
| `references/` | sources SpriteCollab épinglées (1,3 Mo) |

Import : copier les 4 fichiers du dossier dans le slot de l'espèce, ou n'ajouter que le bloc
`Diva<X>` à un `AnimData.xml` existant — `build.py` ajoute l'animation **sans toucher** au reste
(test d'idempotence : deux passes donnent le même XML, une seule entrée).

## Reproduction et contrôles

```bash
.venv/bin/python source/diva_dazzling_v1/build.py
.venv/bin/python -m unittest source/diva_dazzling_v1/test_diva.py -v      # 15 tests
NODE_PATH=/tmp/nc/node_modules node source/diva_dazzling_v1/test_page_navigateur.js
```

Le harnais navigateur rejoue la vraie page dans jsdom : il décode réellement chaque data-URI
(signature PNG + IHDR), vérifie les dimensions de planche (576 × 448, 576 × 448, 1008 × 384),
les 54 vignettes, les 8 boutons de direction, la pause et le bouton « Pose de diva », et échoue
si un `drawImage` reçoit une image non décodée (écran vide).

Tests Python : provenance épinglée, gestes réellement distincts, 18 × 8, phases 1 et 18
pixel-identiques au natif, aucune couleur inventée, mouvement réel et borné, aucun débordement
de cadre, repères qui suivent le geste et restent dans la frame, planches importables, ombre
native inchangée, `AnimData.xml` valide (index uniques, `Idle` conservé), patch idempotent,
aperçu autonome, `verification.json` honnête, mutation réelle vérifiée.

## Limites explicites

**`art_approved = false`, `runtime_tested = false`.** Aucune ouverture dans PMDO, aucun import
moteur, aucun ajout proposé à SpriteCollab. Ce sont des animations candidates, contrôlées
techniquement, pas validées artistiquement.

- Les bras de Lopunny sont ajoutés **dans les pixels vides** : ils restent discrets et lisibles
  comme membres, mais ce n'est pas un redessin complet du sprite.
- Chez Mawile, le repère `head` du slot natif tombe parfois sur la corne gauche ; dans ce cas il
  suit la mâchoire au lieu du crâne (documenté dans le code).
- Les vues strictement de profil (Lopunny Est/Ouest) n'ont pas de séparation gauche/droite
  utilisable : les deux pompons montent ensemble, décision assumée et testée.
- Les `Offsets` de SpriteCollab n'ont pas de sémantique documentée (tête / corps / main droite /
  main gauche) : on ne s'en sert pas pour piloter le geste, seulement pour suivre les parties.
