# Chapitre 10 — audit de continuité avant réécriture

Date : 2026-08-02 — branche `new-era-1-9`
Objet : vérifier l'état réel du climax du ch10 et du passage à l'arc fugitif,
avant d'écrire quoi que ce soit, en remontant la trame depuis le chapitre 1.

---

## 1. La chaîne narrative existante — elle est solide

Contrairement à ce que je craignais, la trame est déjà cohérente et tendue.
Relevé sur les fichiers, pas sur les documents de plan :

| Étape | Où | Ce qui est posé |
|---|---|---|
| ch5 | `metano_town_ch_5.lua` | Amorce : « menace feutrée, brume, vol d'éclats » |
| ch6 | `SuaireArc.lua` | Rumeur « la brume aux trois silhouettes » |
| Actes I-V | `SuaireArc.lua` (429 l.) | Bosquet Voilé → Antre de l'Énigme. Le Suaire passe de silhouette à interlocuteur |
| ch8 | `ChapterAftermath.CrystalVictory` | « Elle n'est pas battue : elle s'arrête de se battre » |
| ch9 | `ChapterAftermath.MarshVictory` | **« Nous sommes venus COMPTER. »** / « Chaque Cœur que vous ranimez brille un peu plus fort. Et chaque fois qu'un Cœur brille, une paroi s'amincit. » |
| ch9 veillée | `guild_heros_room_ch_9.lua` + `GHR9_001..008` | Le doute s'installe : « Et si soigner n'était pas la même chose que sauver ? » |
| ch10 veillée | `GHR10_001..010` | « Quatre Cœurs. Quatre murs de moins. » / « Elle me remerciait. C'est bien pire. » |
| Acte V | `SuaireArc.Act5` | « Une lumière qui protège n'a pas besoin d'être si vaste. Demande-toi ce qu'on enferme avec un mur pareil. » |

Le Cercle du Suaire est écrit comme une **faction ambiguë, pas malveillante** :
Suaire (Banette), Linceul (Gengar), Litanie (Noivern), tous trois déclarés dans
`CharacterEssentials`. Leur réplique clé : « Nous ne sommes pas vos ennemis,
petits. Nous sommes ce qu'il reste de ceux qui ont posé les pierres. »
Et surtout : **« Il n'a pas menti une seule fois. C'est ça qui me terrifie. »**

C'est cette faction qui doit retourner l'opinion au ch10 — pas une « Fédération »
apparue de nulle part. Le matériau est déjà là.

## 2. Bug bloquant — deux scènes post-victoire s'annulent

C'est le point le plus grave, et il rend l'arc fugitif **inatteignable**.

Deux scènes de fin de ch10 existent en parallèle :

| | `ChapterAftermath.PeakVictory()` | `autel_celeste.PlayPostVictoryScene()` |
|---|---|---|
| Boss mis en scène | **Lugia** | **Rayquaza** |
| Contenu | adieu, « Cherchez sous l'écaille », la Voix a peur | météorite, clin d'œil, accusation |
| Pose `Chapter = 11` | non | **oui** |
| Appelée depuis | `zone/celestial_peak/init.lua` segment 5 | `autel_celeste.Enter` |

Le mécanisme, vérifié ligne à ligne :

1. `zone/celestial_peak/init.lua` segment 5 appelle `ChapterAftermath.PeakVictory()`.
2. `PeakVictory` → `Aftermath(cfg)` avec `flag = 'PlayedVictoryScene'`.
   `Aftermath` fait **`cfg.sv[cfg.flag] = true`** dès l'entrée (l. 4 de la fonction).
3. La ligne suivante du segment 5 renvoie le joueur à la **chambre de la guilde**
   (`EndDungeonRun(..., 2, ...)`), pas à l'Autel.
4. `autel_celeste.Enter` teste
   `if SV.Chapter10.CelestialPeakComplete and not SV.Chapter10.PlayedVictoryScene`.
   Le flag vient d'être posé → **la condition est fausse pour toujours**.

**Conséquence** : la scène Rayquaza ne se joue jamais. Et comme
`SV.ChapterProgression.Chapter = 11` n'existe **que** dans cette scène morte
(vérifié : une seule occurrence dans tout le dépôt), **le chapitre 11 n'est
jamais atteint**. L'arc fugitif est injouable.

À l'inverse, le segment 5 pose `SV.ChapterProgression.StoryCompleted = true`
avec le commentaire « Fin de l'histoire actuelle […] Quand les chapitres 11+
existeront, déplacer cette ligne ». Le ch10 se termine donc aujourd'hui comme
une fin de jeu, pas comme une bascule.

## 3. Contradiction Lugia / Rayquaza

Elle traverse tout le chapitre et doit être tranchée, pas contournée :

- `zone/celestial_peak/init.lua` : en-tête « boss Lugia », flags
  `ReachedLugiaAltar`, `DefeatedLugia`, `DiedToLugia`, réplique de mort
  « Lugia... le Gardien des Cieux... nous a jugés... »
- `ChapterAftermath.PeakVictory` : met en scène **Lugia**, avec les dix clés
  `GHR10_*` de la veillée qui y font suite (« On a parlé à LUGIA »).
- `autel_celeste/init.lua` : commentaire « Arrivée divine de Rayquaza
  (remplace Lugia) », textes `CPB_*` signés Rayquaza.

Le remplacement a été fait **sur l'Autel seulement**, sans propager à la zone,
aux flags, ni aux textes de la veillée. Votre brief demande Rayquaza : c'est
donc `PeakVictory` et la veillée qu'il faut aligner, pas l'inverse.

## 4. Violations de règles projet dans les textes du ch10

Relevé sur `autel_celeste/strings.fr.resx` (17 clés `CPB_*`) :

| Clé | Problème |
|---|---|
| `CPB_003`, `CPB_011` | contiennent **« l'Abîme »** — interdit avant l'arc 6 |
| `CPB_006` | « un autre **humain** transformé en Pokémon » — désigne les personnages des jeux d'origine ; interdit |
| `CPB_017` | « les **humains** et les Pokémon de la vallée » |
| `CPB_006` | 157 caractères hors `[pause=N]` (limite 150) |
| `CPB_017` | 171 caractères |

## 5. Bug d'émotion — `'Shock'`

`'Shock'` est une **emote de bulle**, pas une émotion de portrait. C'est le
crash historique corrigé par `7715486`. Trois occurrences retrouvées :

- `ChapterAftermath.lua:225` — `say(partner, 'Shock', ...)`
- `ChapterAftermath.lua:282` — `think(hero, 'Shock', ...)`
- `zone/celestial_peak/init.lua` — `DeathFadeOutDialogue(..., "Shock")`

Pas de crash aujourd'hui : `GeneralFunctions.SetEmotion` valide contre
`EMOTIONS_PORTRAIT` et retombe sur `Normal` en traçant. Mais **l'intention de
jeu est silencieusement perdue** à chaque fois. Les deux premières sont
corrigées en `Surprised` dans ce lot.

## 6. La mise en scène de l'apparition n'était pas conforme

`autel_celeste.Enter` appelait `BossFX.Voice('CPB_001')` pour la première
réplique de Rayquaza. Or `BossFX.Voice` est **réservé à la Voix anonyme**
(`\uE040`) : elle impose l'emote `shock` au héros, le met en animation `Hurt`
et fait tanguer l'écran — « le héros est le SEUL à entendre cette voix, et
l'entendre lui coûte ».

Attribuer la parole de Rayquaza à ce canal brouillait deux entités que tout le
mod sépare depuis `d7ba1ec`. Corrigé : la couche 1 utilise un locuteur vide
(`UI:ResetSpeaker(false)`), sans portrait ni corps à l'écran, conformément à
votre demande.

Note : `BossFX.Voice` reste utilisé par 14 autres fichiers. Je n'y touche pas —
c'est légitime ailleurs, où c'est bien la Voix qui parle.

## 7. Ce que je propose pour la refonte

Le déclencheur de l'arc fugitif doit être **le Cercle du Suaire**, ce qui règle
d'un coup la cohérence et le problème du « pourquoi la ville se retourne ».

Enchaînement proposé, entièrement adossé à l'existant :

1. **Rayquaza** — motivation conforme à votre brief : garant de l'équilibre
   atmosphérique, il perçoit les secousses telluriques convergeant vers sa tour
   comme une agression et purifie. Pas de haine. Apparition en 3 couches :
   voix sans corps → il fend les nuages → déploiement, lumière, thème.
2. **La décharge pourpre** est visible de tout le continent — elle existe déjà
   dans `CPB_016` : « toute la vallée a dû la voir depuis en bas ».
3. **Le Suaire exploite l'événement.** C'est le chaînon manquant. Ils ont passé
   cinq actes à répéter « chaque Cœur ranimé amincit une paroi » ; la lueur
   pourpre est leur **preuve publique**. Ils n'ont pas besoin de mentir — et
   c'est exactement la force du personnage tel qu'il est déjà écrit.
4. **L'accusation** vient donc de la population et de la guilde, *retournées*
   par une faction qui dit une vérité partielle. Pas d'une « Fédération »
   inventée pour l'occasion.
5. **La fuite** de nuit, sous la pluie, vers la route du sud.

## 8. Itinéraire de fuite — vérifié sur la grille

`metano_town_nuit` existe (189×189 cellules, 58,1 % franchissable, 38 marqueurs,
musique `Goodnight.ogg`). Chemins calculés par parcours en largeur sur la grille
de collision réelle :

| Trajet | Résultat |
|---|---|
| Guilde (696, 904) → Place de la Légende (656, 1272) | **52 cases, praticable** |
| Place → Sortie sud (288, 1456) | **80 cases, praticable** |
| Guilde → Sortie sud direct | **121 cases, praticable** |

Jalons relevés pour la mise en scène : (700,908) → (644,1012) → (612,1140) →
(492,1180) → (348,1196) → (292,1300) → (292,1460).

## 9. Limites d'assets constatées

- **Aucun MapStatus de pluie.** Les 10 disponibles sont `autumn_leaves`,
  `blowing_wind`, `blowing_wind_fast`, `darkness`, `dusk`, `falling_ash`,
  `mysterious_distortion`, `sakura_drift`, `steam`, `winter_snow`.
  La pluie devra être suggérée par le texte, le son et `darkness` —
  `GROUND:AddMapStatus` échoue **en silence** sur un nom absent, donc inventer
  `rain` produirait une scène sans effet et sans erreur visible.
- Musiques de tension disponibles : `Rising Fear.ogg`, `Growing Anxiety.ogg`,
  `Outlaw.ogg`, `Team Skull.ogg`, `The Power of Darkness.ogg` (déjà le thème du
  Suaire dans l'acte V).

## 10. Piège technique relevé

`STRINGS.MapStrings` est **propre à chaque carte** : chaque ground charge le
`strings.resx` de son propre dossier. J'avais commencé à écrire les clés `CPF_*`
de la fuite dans `autel_celeste/strings*.resx` alors que la scène se joue dans
`guild_heros_room`. Elles auraient été introuvables à l'exécution. À corriger
avant écriture de la scène.

## Réserve

Rien n'est testé manette en main. Le bug du §2 est déduit de la lecture croisée
de `Aftermath()`, du segment 5 et de la condition d'`autel_celeste.Enter` —
c'est solide, mais seul un lancement le confirmera.
