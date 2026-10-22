# Les mini-boss du chapitre 5 prennent la parole

Build : `2026-07-31-V`

## Le diagnostic (mesuré, pas ressenti)

Demande : « des cinématiques aussi qualitatives que celle des Limagma ».
J'ai donc commencé par mesurer ce qui distingue la scène du Tunnel Ardent des
quatre autres. Ce n'était ni la longueur, ni les effets.

| scène | répliques | **boîtes dites par le boss** |
|---|---|---|
| Tunnel Ardent (Chartor + Magmar) | 42 | **11** |
| Grande Steppe — mini-boss | 29 | **0** |
| Grande Steppe — gardien | 22 | **0** |
| Mont Venteux — mini-boss | 25 | **0** |
| Mont Venteux — gardien | 25 | **0** |

**Voilà tout l'écart.** Les quatre autres boss ne disaient pas un mot. Le duo
commentait des silhouettes muettes qui apparaissaient dans un flash et
disparaissaient dans un autre. Chartor et Magmar, eux, sont des personnages :
ils expliquent pourquoi ils barrent la route, ils cèdent, ils transmettent une
information utile. C'est ça que tu as aimé.

## Ce qui a été fait

**38 clés neuves, EN + FR**, et les prises de parole insérées dans les quatre
scènes. Chaque boss reçoit une voix ET une fonction narrative distincte —
aucun ne recycle le registre d'un autre.

| boss | registre | fonction |
|---|---|---|
| **Tiboudet + Cerfrousse** (Steppe, mini) | jugement | La harde ne hait pas, elle **évalue**. Tiboudet est le jeune impulsif qui veut disperser, Cerfrousse le vieux qui tranche : « Des petits qui marchent ensemble, ce n'est pas du gibier. » |
| **Cerfrousse** (Steppe, gardien) | avertissement | Le plus ancien. Il n'éprouve plus, il **prévient** : « Quelque chose sous l'herbe a cessé de dormir. » Puis il s'écarte, parce qu'il ne peut pas suivre. |
| **Scorplane + Airmure** (Mont, mini) | administratif | Elles **comptent**. « Quarante et un ont passé cette corniche. Neuf sont redescendus. J'ai arrêté de compter après ça. » Le froid bureaucratique fait plus peur qu'une menace. |
| **Ptéra** (Mont, gardien) | vertige | Clôture du chapitre. Le seul qui voit le monde d'en haut : « Il y a une forme sous votre monde. Elle a des angles. **Rien de naturel n'a d'angles.** » |

### Deux fils tendus à travers le chapitre

1. **Personne d'autre n'entend la Voix.** Cerfrousse (mini) : « Ce qui vous
   parle ici — nous, nous ne l'entendons pas. » Cerfrousse (gardien) : « La
   brume ne m'a jamais parlé. Demande-toi pourquoi elle te parle, à toi. »
   Deux témoins indépendants, aucun ne l'entend. Le héros ne relève pas.
2. **La graine de l'arc des Cœurs, sans rien nommer.** Ptéra : « Ne supposez
   pas que les angles ont été bâtis pour vous garder DEHORS. » C'est
   exactement la question que Diancie posera au chapitre 8 (« pourquoi les
   premiers ont-ils bâti des MURS autour de leur lumière ? »). Le mot
   « prison » n'apparaît jamais.

### Mise en scène

Patron du Tunnel appliqué partout : la caméra **remonte sur le boss** quand il
parle, se **resserre** sur la phrase-pivot, puis **redescend** en cadre commun
quand il s'adresse au duo. Les vaincus ne s'évaporent plus sans rien laisser —
ils tranchent, puis transmettent.

## Deux bugs préexistants corrigés

1. **8 appels `STRINGS.Format` au lieu de `STRINGS:Format`** dans
   `mount_windswept_guardian_ch_5.lua` — et nulle part ailleurs dans le dépôt.
   En Lua le point ne passe pas `self` : ces 8 lignes **plantaient à
   l'exécution**, dans la scène de clôture du chapitre 5.
2. **Surnoms anglais.** Les mini-boss s'affichaient `Mudbray`, `Stantler`,
   `Skarmory`, `Aerodactyl`, `Gligar`, `Torkoal` alors que le chapitre 6 est
   déjà en français (`Papilusion`, `Chenipent`, `Limagma`). Francisés :
   Tiboudet, Cerfrousse, Airmure, Ptéra, Scorplane, Chartor. Seul le champ
   `nickname` change — `instance` reste intact, donc les `GROUND:Hide('Mudbray')`
   et les `CH()` continuent de fonctionner. (Magmar s'écrit pareil en français.)

## Résultat

| scène | boîtes du boss avant | après |
|---|---|---|
| Steppe mini | 0 | **10** |
| Steppe gardien | 0 | **9** |
| Mont mini | 0 | **10** |
| Mont gardien | 0 | **9** |
| Tunnel (référence) | 12 | 12 |

Chapitre 5 : **1442 → 1480** répliques.

## Validation

Lua **643/643** · `.resx` **576/576** · zones + index **208/208** ·
`verify_legend` / `verify_bg_format` / `verify_scene_positions` au vert.
Toutes les clés référencées existent en EN **et** en FR (vérifié par script).
Portées Lua vérifiées : chaque variable de boss est déclarée avant ses
nouveaux usages, dans chaque fonction.

## Non testé

**Rien n'est testé en jeu.** Non vérifiable par script : le rythme réel des
`MoveCamera` pendant les tirades, et le fait que les surnoms français
s'affichent bien si `CONFIG.UseNicknames()` est actif — s'il est désactivé, le
moteur retombe sur le nom d'espèce, ce qui est le comportement voulu.
