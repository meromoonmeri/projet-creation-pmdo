# Rêve manqué au Mont Venteux — cause racine, et réaction de Plum au respawn

> **Rien n'a été testé en jeu.** Tout ce qui suit est établi par lecture du
> moteur (fichier + ligne), exécution du script sous moteur simulé, et mesure
> sur la carte réelle.

---

## 1. Le rêve ne se lançait pas

### Symptôme rapporté

> « la scène du rêve ne s'est pas lancée. Il y a uniquement le réveil en sursaut
> au milieu de la nuit, suivi de la discussion avec Philéas. La scène avec
> Gardevoir est totalement absente. »

### Ce qui a été éliminé (tout est sain)

| Vérification | Résultat |
|---|---|
| `hero_dream` dans `master_zone.GroundMaps` | présent, **position 51** |
| `hero_dream` dans `Data/Zone/index.idx` (résumé lu par `GroundValid`) | présent, position 51 |
| `Main_Entrance_Marker` sur la carte (requis par `GetEntryPointIdx`, GameManager.cs:743) | présent en (152,112) |
| `hero_dream.rsground` désérialisable | oui — champs identiques à `personality_test`, même version 0.8.9.0 |
| 27 clés `DRM_000..026` | présentes en FR **et** EN |
| Nom du BGM `Welcome to the World of Pokémon!.ogg` | identique **octet pour octet** au fichier disque (NFC) |
| Corps du rêve exécuté sous moteur simulé (`lupa`) | **27/27 boîtes** jouées, aucune erreur |

Le rêve n'était donc pas cassé : **il n'était jamais atteint**.

### Cause racine — le routeur

Deux drapeaux encadrent l'aller-retour, et ils ne sont pas posés au même instant :

| Drapeau | Posé où | Quand |
|---|---|---|
| `CampNightWatchDone` | `mount_windswept_entrance_ch_5.lua:1594` | **avant** la bascule |
| `DreamSceneSeen` | `hero_dream/init.lua:532` (fin) et `:561` (secours) | **après** le rêve |

`PlotScripting` ne lisait que le **premier** :

```lua
if SV.Chapter5.CampNightWatchDone and not SV.Chapter5.FinishedMountWindsweptIntro then
  mount_windswept_entrance_ch_5.ResumeAfterDream()   -- réveil + Philéas
```

Toute interruption entre les deux poses — fermeture du jeu sur l'écran noir,
sauvegarde reprise à cet instant, bascule avortée côté moteur — laisse l'état :

```
CampNightWatchDone = true    → le routeur croit le rêve joué
DreamSceneSeen     = false   → le rêve n'a jamais tourné
```

et part droit sur `ResumeAfterDream`, qui commence précisément par le sursaut du
réveil (ch_5.lua:1863) puis Philéas (:1913). **Exactement le symptôme décrit.**

### Correctif

Le routeur distingue maintenant les deux situations et rattrape le rêve manqué
via `RetryDream()`, qui :

1. repose l'écran noir et le mode cinématique avant toute bascule ;
2. refait le **même préflight** que l'aller — nom enregistré, zone en mémoire
   (`GroundMaps.FindIndex`, GameManager.cs:729-731), asset réellement chargeable ;
3. ne retente **qu'une seule fois** (`DreamRetryDone`, persisté dans `SV`).

Un échec répété dégrade la nuit au lieu de boucler entre deux cartes.

### Machine à états simulée — aucune boucle

| Cas | Résultat |
|---|---|
| Rêve déjà joué | `ResumeAfterDream` (nominal) |
| **Rêve jamais joué** (bug signalé) | `RetryDream` → **rêve joué** → retour → réveil |
| Carte non chargeable | préflight KO → rêve sauté proprement |
| Rattrapage déjà tenté | abandon → réveil, pas de boucle |

---

## 2. Plum réagit au respawn (`KODefeatCutscene`)

### Causalité

Plum tient les marmites du camp depuis son irruption de la veille
(`PlumAtMountCamp`). L'équipe qu'elle nourrit rentre à moitié morte : la laisser
muette en ferait un décor — le défaut de causalité déjà reproché.

Son angle est le sien, distinct de tous les autres : ni l'inquiétude de Penticus
(le chef), ni la culpabilité de Hyko (le garde), mais le **reproche affectueux de
celle qu'on n'a pas emmenée**.

| Clé | Beat |
|---|---|
| `MWE5_P16` | « VOILÀ ! C'est votre faute, aussi ! Fallait m'emmener !!! » |
| `MWE5_P17` | elle se trahit : « ...Vous n'avez rien de cassé ? Rien du tout ? » |
| `MWE5_P18` | Penticus la recadre en lui **donnant un rôle** |
| `MWE5_P19` | elle cède à sa manière : « la prochaine fois, vous m'emmenez » |

Puis elle repart à son poste **exact** de `SetupGround` (236,230) : camp et
cinématique restent d'accord, le joueur la retrouve où elle doit être.

### Non-collision — tenue par la géométrie, pas par la chance

Contrainte : *« ne doit à aucun moment entrer en collision ou interagir avec le
partenaire (Shuca ou Galon) pendant toute la scène »*.

Trajet : `(236,230) → (220,212) → (196,196)`, puis retour symétrique.
Mesuré avec `tools/nea_map.py` sur la carte réelle :

- marchable de bout en bout, **entièrement à l'ouest** du couloir central ;
- distance minimale à **tout** autre personnage, sur l'aller **et** le retour :
  **jamais moins de 24 px** ;
- à l'arrêt : Ganlon **58 px**, Shuca **116 px**, partenaire **104 px** ;
- Ganlon (244,164) et Shuca (308,164) gisent au **nord**, contre la porte du
  donjon — le trajet ne les croise jamais ;
- **aucun** appel `CharTurnToChar` / `MoveTo` ne lie Plum à Ganlon ou Shuca :
  elle ne s'adresse qu'au héros et à Penticus (vérifié par extraction du bloc).

Toute la séquence est sous `pcall` et sous `if plum ~= nil and PlumAtMountCamp` :
si le joueur n'a pas déclenché son arrivée la veille, la scène se joue sans elle,
exactement comme avant.

---

## 3. Architecture des donjons — état constaté

Le prompt impose trois structures et pas une de plus : **Route**, **Boss**,
**Mini-boss**. État actuel des donjons concernés :

| Donjon | Entrée (Route) | Point médian (Route) | Mini-boss | Boss |
|---|---|---|---|---|
| Tunnel Incandescent | ✅ | ✅ | ✅ | — (Creuset séparé) |
| Grande Steppe | ✅ | ✅ | ✅ | ✅ gardien |
| Mont Venteux | ✅ | ✅ | ✅ | ✅ gardien |
| Forêt Lugubre | ✅ | ✅ | ✅ | ✅ |
| Aegis Cave | ✅ | ✅ | ✅ | ✅ |
| Caverne Tortueuse | ✅ | ✅ | — | — |

Aucune structure hors des trois catégories n'a été trouvée sur ces donjons : les
entrées et points médians appartiennent à la Route (relais construits à la main
mais intégrés), et chaque arène est un ground dédié. **Aucune migration n'est
donc requise ici** — le point à traiter reste la narration des entrées de boss
(structure en 3 flashs), non couverte par ce lot.
