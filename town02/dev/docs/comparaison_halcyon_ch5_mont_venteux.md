# Comparaison — scène du Mont Venteux ch5 : Halcyon (Palikadude) vs notre mod

Demande : « les cinématiques de Halcyon sont beaucoup mieux chez eux pour le
chapitre 5 de cette zone ». Vérification faite le 2026-07-29 en clonant leur
dépôt public complet (toutes branches, tous tags).

## 1. Où est « chez eux » — sources comparées

| Source | Contenu chapitre 5 ? |
|---|---|
| `Palikadude/Halcyon`, branche **master** (= release publique **v0.4.0**, mars 2024) | NON. Chapitres 1-4 seulement. Aucune zone « windswept ». |
| `Palikadude/Halcyon`, branche **working-copy** (HEAD `1522c7a`, oct. 2025) | OUI — le seul endroit public où leur chapitre 5 existe. |

Leur chapitre 5 (working-copy) contient exactement nos mêmes zones d'arc :
`vast_steppe_entrance`, `searing_tunnel_entrance`, `searing_tunnel_midpoint`,
`searing_crucible`, `mount_windswept_entrance`. Notre mod est né d'une copie de
cet arc puis a été traduit, re-scénarisé et étendu en français.

## 2. Verdict sur la scène du Mont Venteux elle-même

**Chez Halcyon, cette scène n'existe pas.** Leur
`mount_windswept_entrance_ch_5.lua` fait **185 lignes** : une `ArrivalCutscene`
qui s'arrête en plein milieu d'une marche (4 coroutines lancées, jamais
rejointes par du contenu) suivie de notes d'intention non scénarisées
(« Penticus is pacing around nervously… », « Ganlon hasn't been getting to act
like a jerk… »). Dernier commit sur ce fichier : `ac4ff3d`, 2025-06-06. Depuis,
rien. Pas de dîner, pas de coucher, pas de rêve, pas de matin.

La nôtre : **2623 lignes** — arrivée au couchant, dîner au feu, conversations
en trois groupes, déploiement des couchages sous le fondu, rêve sur carte
dédiée, réveil, veille de Phileas, matin. Il n'y a donc **aucune version
Halcyon supérieure de CETTE scène à importer** : elle n'a jamais été écrite
chez eux.

Si une scène « beaucoup mieux » a été vue ailleurs (vidéo de développement,
build de test privé du Discord PMDO), elle n'est pas dans leur dépôt public —
il faut nous indiquer la source exacte pour comparer ce que Palika aurait
fait en privé.

## 3. Ce qui est comparable : les 4 scènes partagées de l'arc ch5

« Signature chorégraphique » extraite (toutes les lignes d'API moteur —
GROUND/GAME/SOUND/UI/GeneralFunctions — avec textes neutralisés) et diff :

| Scène (fichier `_ch_5.lua`) | Halcyon | Nous | Verdict |
|---|---|---|---|
| `searing_tunnel_midpoint` | 448 l. | 449 l. | **Copie conforme** (traduction seule). Zéro écart de mise en scène. |
| `vast_steppe_entrance` | 1257 l. | 1416 l. | Fidèle + nos scènes exclusives en plus (`SkyTremorScene` : stingers de secousse, `PanCamera`, BGM *Growing Anxiety* / *Rising Fear*). |
| `searing_tunnel_entrance` | 2291 l. | 2426 l. | Fidèle + notre scène exclusive (`FurnaceLegendScene`). Les 4 dialogues flottants minutés (`WaitShowTimedDialogue`) existent bien chez nous aussi (STE5_213-216). |
| `searing_crucible` | 1305 l. | 1349 l. | Fidèle **sauf 4 écarts**, détaillés ci-dessous. |

### Les 4 écarts réels du Creuset (searing_crucible)

1. **Apparition de Magcargo** — chez eux : colonne de flamme
   `Sacred_Fire_Ranger` (calque Front, sur le boss) + SE `_UNK_EVT_003` +
   tremblement ; chez nous : le LOT 2.1 l'avait remplacée par un flash blanc
   générique à position codée en dur (256,192).
   → **RESTAURÉ fidèlement** (port exact de leur bloc), sous `pcall` avec
   repli au flash à la position du boss si l'asset venait à manquer.
2. **Disparition/explosion de Magcargo** — même histoire (leur flamme +
   `_UNK_EVT_003` vs notre flash LOT 2.2 + `EVT_Battle_Flash`).
   → **RESTAURÉ** de la même façon.
3. **Timing du fondu de sortie vers le Mont** — eux : fondu lancé à t=50
   (marcheurs visibles debout ~20 frames), puis **90 frames de noir mort** ;
   nous : fondu t=30→90, noir complet pile à l'arrêt du dernier marcheur, 20
   frames de respiration. Ce n'est pas une perte : c'est la correction demandée
   par le retour de jeu sur le fondu cassé. **Conservé volontairement.**
4. **Reprise du donjon après la 1re scène** — eux : étage 2 ; nous : étage 3.
   Choix de difficulté assumé de notre côté, hors mise en scène.

## 4. La map du Mont Venteux aussi diffère

`mount_windswept_entrance.rsground` : 3,0 Mo chez eux, 6,4 Mo chez nous (map
reprise et agrandie, littoral océan au sud). Conséquence historique : leurs
coordonnées d'arrivée (angle ouest, 92,176 / 60,136) tombaient au mauvais
endroit de NOTRE map — c'était le vieux bug d'arrivée au milieu de la carte.
Notre arrivée par le sentier sud au couchant, caméra en deux glissements, est
un choix assumé adapté à notre géographie — pas un manquement à copier.

## 5. Leurs notes d'intention pour la suite du Mont Venteux (non écrites)

Leur ébauche annonce scénario : Penticus en panique à l'arrivée du groupe
(retrouvailles avec Hyko), explication de Phileas sur le décalage des donjons
mystères, idée de faire entrer Almotz/Rin/Coco en boitant au camp. Notre
veillée couvre déjà ces tonalités (inquiétude de Phileas façon veille, gag de
Kino le matin, briefing de Penticus). Rien à importer tel quel.

## 6. Travail effectué suite à cette comparaison (build 2026-08-02-B)

- `searing_crucible_ch_5.lua` : apparition et disparition de Magcargo rendues
  à l'effet de flamme d'origine (`Sacred_Fire_Ranger`), sons d'origine,
  positions exactes du jeu d'origine — le tout sous `pcall` avec repli flash,
  sortie garantie conservée (le `DefeatedBoss` ne peut toujours pas bloquer la
  transition vers le Mont).
- Tout le reste des écarts relevés est volontaire et documenté ci-dessus.

> Réserve permanente : validation statique uniquement (compilateur Lua + suite
> d'outils du dépôt). RIEN N'A ÉTÉ TESTÉ EN JEU. En particulier : si l'AnimData
> « Sacred_Fire_Ranger » était absente du contenu moteur chez un joueur, le
> repli flash prend le relais — à confirmer à l'écran.
