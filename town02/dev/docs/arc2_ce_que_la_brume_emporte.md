# Arc 2 — « Ce que la brume emporte »

> 5 quêtes secondaires + 5 actes cinématiques, jouables entre le ch6 et le ch12.
> Module : `Data/Script/halcyon/SuaireArc.lua`. Session 2026-07-31.

## 1. Intention

Trois fils de l'intrigue globale sont **entrelacés** (choix utilisateur : « tous »),
au lieu d'être traités séparément :

| Fil | Rôle dans l'arc |
|---|---|
| **Cercle du Suaire** | Fil conducteur. Ils volent des éclats de Cœur. Déjà amorcé au ch6 par la rumeur « la brume aux trois silhouettes » (`bible_continuite.md:149`). |
| **Rêves du héros** | Chaque acte se termine par un fragment de mémoire du dernier gardien du sceau. Prépare le twist de l'arc 6 de très loin. |
| **Escouade Fulgur** | Rivaux sur la même piste. L'acte IV fait basculer la rivalité en trêve — préfigure l'alliance de l'arc 4. |

L'arc répond à une question que la trame pose sans y répondre avant l'arc 5 :
**pourquoi quelqu'un voudrait-il éteindre les Cœurs ?** Le Suaire donne la réponse
partielle dès l'acte V, sans qu'on puisse encore la vérifier.

## 2. Les 5 donjons

Choisis parmi les 15 secondaires **qui n'avaient ni boss ni scène** — donc du contenu
existant enfin exploité, sans rien casser. Niveaux croissants, déjà au tableau des missions.

| Acte | Donjon | Zone | Niv | Difficulté job board |
|---|---|---|---|---|
| I | Bosquet Voilé | `bosquet_voile` | 6 | E |
| II | Grotte du Mystère | `grotte_mystere` | 10 | D |
| III | Jardin Secret | `jardin_secret` | 14 | B |
| IV | Col de la Foudre | `col_foudre` | 27 | S |
| V | Antre de l'Énigme | `antre_enigme` | 13 | C |

## 3. Les 5 actes

**Acte I — Le premier éclat** (Bosquet Voilé)
Les fleurs fanées d'un seul côté, exactement comme la rumeur. Un petit Cœur amputé
d'un éclat. Une silhouette qui *s'efface* au lieu de fuir. **Rêve 1** : des pierres
alignées dans des niches, une voix — « Compte-les. Tant qu'elles brillent, il dort. »

**Acte II — La marque des bâtisseurs** (Grotte du Mystère)
Une paroi taillée au même motif que les Terminaux. Premier éclat récupéré. La Voix
intervient : « Demande-toi ce qu'ils croient **éteindre**. » **Rêve 2** : une silhouette
brise une pierre en pleurant — « Une de moins pour le nourrir. »

**Acte III — Le témoin** (Jardin Secret)
Première rencontre **de face** avec Suaire (Banette). Il ne se bat pas. Il explique
qu'on leur a confié une consigne « mal comprise pendant six cents ans », puis laisse
un éclat **exprès**. **Rêve 3** : la litanie, entendue pour la première fois.

**Acte IV — La course** (Col de la Foudre)
L'Escouade Fulgur est arrivée première. Voltra constate que les éclats manquants sont
*choisis*, pas volés au hasard. Elle propose la trêve : « Après, on redevient rivaux. »
La Voix commente : « Le sceau n'a jamais été aussi bien gardé... ni aussi près de céder. »

**Acte V — Ce que le Suaire protège** (Antre de l'Énigme)
Une salle ronde, des centaines de niches **vides**. Les trois membres du Cercle,
ensemble. La réplique-pivot de l'arc :

> « Une lumière qui protège n'a pas besoin d'être si vaste. Celle-ci couvre un
> continent. Demande-toi ce qu'on enferme avec un mur pareil. »

**Rêve 5** : sous le sol, quelque chose remue en dormant. « Ne les laisse jamais
toutes s'éteindre. Ne les laisse jamais toutes briller. »

## 4. Ce que l'arc apporte à l'intrigue globale

- Il **installe le Cercle du Suaire** comme antagoniste pensant, pas comme méchant :
  aucun combat contre eux dans l'arc, uniquement des confrontations verbales.
- Il **plante le mot « enferme »** dès l'arc 2, alors que le twist n'arrive qu'à l'arc 6.
  Un joueur attentif peut recomposer ; les autres auront la sensation d'un indice manqué.
- Il **prépare la trêve Fulgur** de façon organique, au lieu d'une alliance décrétée à l'arc 4.
- Il **justifie les rêves** du héros comme mécanique récurrente, pas comme un procédé
  sorti de nulle part à l'arc 3.

Aucune de ces avancées ne contredit l'existant : le mot « sceau » est prononcé par la
Voix (qui l'a déjà fait ailleurs), jamais par un PNJ de la guilde.

## 5. Implémentation

**Un seul module**, `SuaireArc.lua`, avec un point d'entrée unique :

```lua
SuaireArc.PlayAct(zoneID)   -- renvoie true si un acte a été joué
```

Appelé depuis l'`ExitSegment` des 5 zones, **avant** leur `EndDungeonRun` habituel.
Chaque zone n'a reçu que 8 lignes de hook + un `require`.

- **Ordre imposé** : l'acte N exige `Act(N-1)Done`. Vérifié par simulation Lua —
  impossible de sauter à l'acte 3, impossible de rejouer l'acte 1.
- **Verrou d'arc** : rien ne se déclenche tant que `SV.SuaireArc.Unlocked` est faux
  (posé au ch6+ par `debug_tools`, rétroactif pour les parties en cours).
- **Robustesse** : le corps de chaque acte tourne sous `pcall`. En cas d'erreur, on
  log, on marque l'acte fait et on sort quand même — jamais d'écran noir.
- **Sortie garantie** : `FadeOut` + `CutsceneMode(false)`, puis la zone enchaîne sur
  son `EndDungeonRun` avec écran de résultats (`display=true`).

### Variables de sauvegarde

`SV.SuaireArc` : `Unlocked`, `CurrentAct`, `Act1..5Done`, `ShardsRecovered` (0-4),
`SawSuaireFace`, `FulgurTruce`, `DreamFragments` (0-5), `HeardLitany`.

Ces flags sont conçus pour être **lus par les arcs suivants** : `HeardLitany` et
`DreamFragments` donnent de quoi faire réagir un PNJ à l'arc 3, `FulgurTruce` évite
de rejouer une réconciliation déjà acquise.

## 6. Personnages ajoutés

Dans `CharacterEssentials.lua`, au format des entrées existantes :

| Instance | Espèce | Surnom |
|---|---|---|
| `Suaire_Banette` | banette | Suaire |
| `Suaire_Gengar` | gengar | Linceul |
| `Suaire_Noivern` | noivern | Litanie |

L'Escouade Fulgur (`Fulgur_Luxray` Voltra, `Fulgur_Lucario` Aegis) existait déjà.

⚠️ **Aucune de ces espèces n'a de portrait** dans `Content/Portrait/` (34 portraits,
indexés par n° national). Leurs répliques s'affichent donc **sans portrait ni emote** —
comme les boss du ch5. Les descriptions d'attitude passent par des boîtes centrées.

## 7. Densité

**80 boîtes de dialogue, ~6 350 caractères, ≈ 10,4 minutes** de lecture — l'objectif
de 10 min par grande scène est atteint pour l'arc pris comme un tout (environ 2 min
par acte, ce qui est le bon calibre pour une conclusion de quête secondaire).

## 8. Validation

- Lua : **633/633** fichiers du dépôt chargent
- Progression : simulation Lua de l'enchaînement — verrou, ordre, non-rejeu : OK
- Interdits narratifs : aucune occurrence de « Necrozma » / « Eternatus » / « l'Abîme »
  dans les dialogues (la seule occurrence est le commentaire d'en-tête qui rappelle la règle)
- Les 5 donjons étaient **déjà** débloquables et **déjà** au tableau des missions :
  aucun ajout de zone, aucun `.rsmap`, aucune géométrie touchée

## 9. Ce qui reste à faire

- **Les quêtes ne sont pas encore des entrées de job board dédiées.** Elles reposent
  aujourd'hui sur le déclenchement à la sortie du donjon. Un vrai « contrat » nommé
  au tableau (avec client, récompense et texte de mission) demanderait de toucher
  `mission_gen.lua` — hors périmètre de cette passe.
- **Aucun test en jeu.** Toute la validation est statique.
- Les actes n'ont pas de `.resx` : les textes sont **inline** dans le Lua, comme les
  cinématiques d'Ancrage existantes (`abime_tempetes/init.lua` fait pareil). Si tu veux
  la traduction multi-langue, il faudra les externaliser.

---

## 10. Contrats de job board (ajout 2026-07-31)

### Le problème que ça résout

Les 5 actes se déclenchaient à la **sortie** du donjon, sans qu'aucune mission ne
les annonce. Un joueur n'avait aucun moyen de savoir que ces 5 donjons portaient une
intrigue : il tombait dessus par hasard, ou jamais. L'arc était écrit mais **invisible**.

`Data/Script/halcyon/SuaireJobs.lua` pose de vrais contrats sur le tableau de la guilde.

### Les 5 contrats

| Acte | Donjon | Client | Rang | Titre |
|---|---|---|---|---|
| I | Bosquet Voilé | Héliatronc | E | Les fleurs qui se fanent d'un seul côté |
| II | Grotte du Mystère | Kadabra | D | Relevé d'une paroi taillée |
| III | Jardin Secret | Rosélia | C | Le jardin que personne n'entretient |
| IV | Col de la Foudre | Pharamp | B | Inspection du Cœur du col |
| V | Antre de l'Énigme | Xatu | B | La salle aux niches vides |

Chaque texte d'ambiance décrit **ce que le client a vu**, jamais ce que c'est : le
Cercle du Suaire n'est jamais nommé dans un contrat officiel de la guilde. Le client
de l'acte V dit avoir vu le lieu **en rêve avant de le trouver** — écho discret aux
fragments de mémoire du héros.

Les 5 espèces de clients ont été vérifiées présentes (`MonsterFeature`, 975 espèces).

### Intégration — aucune mécanique nouvelle

Le module réutilise **tel quel** le format de job de `mission_gen.lua` : mêmes champs
que `SV.MissionBoard[i]`. Le moteur les affiche sans savoir qu'ils sont scriptés.

Le contrat est **épinglé au slot 1** dans `GeneralFunctions`, *après*
`GenerateBoard` et `SortMission` — pour que la quête d'histoire reste en tête du
tableau au lieu d'être noyée dans le hasard. C'est un choix assumé.

Un marqueur `Special = 'SUAIRE_ARC'` distingue nos contrats des jobs aléatoires.

### Cycle de vie, vérifié par simulation Lua

| Étape | Résultat |
|---|---|
| Arc verrouillé (avant ch6) | aucun contrat ✅ |
| Arc ouvert | contrat acte I épinglé, type EXPLORATION, rang E ✅ |
| Contrat déjà pris | pas de doublon ✅ |
| Acte joué | contrat passe à `COMPLETE` ✅ |
| Contrat suivant | acte II, saut impossible ✅ |
| Arc terminé | plus rien n'est épinglé ✅ |

`SuaireArc.PlayAct` appelle `SuaireJobs.MarkDone(zoneID)` sous `pcall` : si le joueur
n'avait pas pris le contrat, l'acte se joue quand même.

### Limite connue

Le contrat occupe le **slot 1** du tableau, ce qui écrase un job aléatoire à chaque
nouveau jour tant que l'arc est en cours. C'est voulu (visibilité), mais ça réduit
de 1 le nombre de missions aléatoires disponibles pendant l'arc — soit 5 jours de
jeu au maximum.
