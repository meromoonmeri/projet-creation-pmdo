# Causalité narrative — Plum au campement du Mont Windsep

**Build `2026-08-03-G`** · Rien n'a été testé en jeu.

## Le reproche, et pourquoi il était fondé

> « chaque nouvel élément dans une cinématique doit avoir une causalité, rien ne doit
> être mis en retrait. Par exemple je t'ai demandé d'inclure Plum, tu as fait sa
> cinématique mais rien d'autre : elle s'inscrit plus dans la narration en cours,
> elle a pas de paillasse, réagit pas aux cauchemars de Zigzaton. »

Vérifié dans le fichier avant correction. Plum apparaissait dans **un seul beat**
de `CampNightfall` (section 4bis, l.713-895 : 22 manipulations) et **zéro partout
ailleurs**, sur une scène qui compte 16 sections. Elle était ensuite recréée au
matin en (272,238), « roulée en boule près du foyer », sans paillasse, sans réveil,
sans un mot, puis effacée du camp.

Concrètement, ce qui manquait :

| Beat de la séquence | Avant | Après |
|---|---|---|
| Ordre du soir (§6) | absente de la liste d'auditeurs | elle se tourne vers Penticus comme les onze autres |
| Déploiement des couchages (§7) | 11 paillasses, 12 dormeurs | 12ᵉ paillasse posée, conditionnelle à sa présence |
| Coucher (§8) | ne bouge pas | traverse le camp, dernière à se coucher |
| Veillée d'histoires (§8bis) | muette | sursaute, raconte sa propre histoire, se fait gronder |
| Retour du rêve | recréée par terre | recréée sur sa paillasse |
| Réveil (§11) | ne se réveille pas | se réveille en dernier, cherche où elle est |
| Matin | disparaît | §11bis : Penticus tient sa promesse, Coco lui passe la cuisine |
| Rassemblement (§12) | absente | placée hors formation, tournée vers elle |
| Départs (§14) | absente | suit la première vague du regard, adieu à Coco |
| Scène finale (§16) | absente | s'avance en retrait, regarde partir le duo |
| Camp après l'intro | absente | 4ᵉ poste du camp de base, avec dialogue à 3 variantes |

## Le point de causalité du brief : la remarque de Penticus

La veille au soir, Penticus dit (`MWE5_P05`) : *« Tu manges, tu dors, et demain
on avise. »* Une promesse posée dans un beat doit être tenue dans le suivant.
C'est l'objet de la nouvelle section **11bis** : il tranche (non, elle ne monte
pas), mais il ne l'humilie pas — il lui donne un poste. C'est sa manière de
diriger, la même que pour les cordées dix minutes plus tard.

**Incohérence évitée au passage** : la première version faisait dire à Coco
« tu viens avec moi ». Or Coco part au relais avec la cordée de soutien à la
section 14. Elle lui **passe** donc la cuisine du camp de base au lieu de
l'emmener — ce qui justifie aussi sa présence permanente au camp après l'intro.

## Mesures géométriques

Toutes vérifiées contre la grille d'obstacles de `mount_windswept_entrance.rsground`
(552×504 px, cases de 8 px, `Tags == 0` = sol libre) via `tools/nea_map.py`.

| Élément | Position | Contrôle |
|---|---|---|
| `PLUM_BED` (12ᵉ paillasse) | coin (116,288), assise (129,298) | sol libre 40×40 ; 8 px de la paillasse 8 (l'écart minimal entre deux couchages **déjà posés** est de 2 px) ; 28 px du foyer ; 61 px de Hyko ; >20 px des trajets de Philéas et de Rin ; dans le cadre caméra (256,240) |
| Trajet vers la couche | (280,252)→(240,272)→(200,296)→(160,304)→(129,298) | 4 segments, tous marchables, contournent le flanc ouest |
| Plaidoyer du matin | (244,206) | 43 px de Penticus, **40 px du plus proche de tous les autres** |
| Coco qui la rejoint | (276,190) via (304,200) | contourne le bloqueur du foyer (262..286 / 226..250) par l'est ; 36 px de Plum, 28 px de Penticus |
| Rassemblement | (376,240) | 64 px de la formation ; **pas (360,240)** : ce point tombe à 16 px du trajet de départ d'Almotz |
| Scène finale | (344,208) | 45 px de Hyko ; dans le cadre du plan final (264,190) |
| Camp de base (`SetupGround`) | (278,174) | 40 px des flammes, hors du bloqueur, 66 px du plus proche des trois autres postes |

## Choix d'API vérifiés

- `EmoteAndPause` (`GeneralFunctions:547-591`) ne connaît **pas** `"Determined"` :
  son `else` final l'aurait rendu en goutte de sueur, contresens exact sur le beat
  de l'adieu. Remplacé par `CharSetEmote(chara, "determined", 1)`, attesté 9 fois
  dans le dépôt.
- `"Shock"` en émote **est** valide (`EmoteAndPause` l.583, 47 occurrences) — à ne
  pas confondre avec l'émotion de portrait `Shock`, elle invalide, corrigée
  précédemment en `Surprised`.
- `GeneralFunctions.Speak()` utilisé partout pour Plum : Jigglypuff #39 n'a pas de
  portrait dans le mod, `SetSpeaker` direct provoquerait le crash de rendu corrigé
  au build F.

## Nouvel outil : `tools/audit_causalite.py`

La directive demande d'améliorer le processus, pas seulement de corriger.
L'outil découpe chaque cinématique en beats (sections numérotées), relève les
personnages manipulés dans chacun, et signale ceux qui disparaissent N beats
d'affilée après leur introduction sans sortie explicite.

**Calibré contre le bug réel** : rejoué sur la version d'avant correction, il
sort `plum — absente de 7 beats : après « 4bis. L'IRRUPTION DE PLUM » (l.895)
→ jamais revue`. Sur la version corrigée, plus rien même au seuil le plus strict.

Quatre pièges ont dû être traités pour qu'il voie ce défaut :

1. Les listes numérotées à l'intérieur d'un commentaire d'en-tête étaient prises
   pour des sections et doublaient le découpage.
2. `GROUND:Hide(...)` suivi d'un `Unhide` dans le même beat n'est pas une sortie,
   c'est une mise en place.
3. Un `CharSetAnim("Sleep")` annulé par un `CharEndAnim` plus bas dans le même beat
   n'est pas un endormissement — la chute comique de Plum enchaîne les deux.
4. Les auditeurs rangés dans une variable (`local listeners = {...}` puis
   `Listen(x, listeners)`) n'étaient pas comptés comme présents.

Limites assumées : l'outil ne juge ni la géométrie (rôle de `verify_scene_positions`),
ni la qualité d'une réaction — seulement son existence.

## Baselines (inchangées)

- `audit_bugs.py` → 12 signalements
- `audit_integrite.py` → 850 anomalies
- `count_dialogue.py` ch5 → 1619 (était 1602, +17 répliques)
- 670 fichiers Lua compilés, 0 erreur
- 11 nouvelles clés (`MWE5_H10`, `H11`, `P08`..`P15`) présentes en FR **et** EN
- `verify_legend`, `verify_scene_positions`, `verify_bg_format`, `validate_all`,
  `verify_lua_globals`, `verify_cutscene_guard`, `verify_spawner_enabled` : verts
