# Rapport complet — Chapitre 5

Date : 24 juillet 2026
Projet : **New Era : Abyss to Ascension**

## 1. Identité du chapitre

Le chapitre 5 est un chapitre d'expédition. L'équipe de la guilde se prépare à rejoindre les ruines situées dans la chaîne de montagnes, au nord de la région.

La règle narrative est respectée :

- Necrozma n'est pas nommé ;
- Eternatus n'est pas nommé ;
- l'Abîme reste une inquiétude descriptive ;
- les Pokémon rencontrés sont présentés comme perturbés ou territoriaux ;
- les Aegis Cave sont préparées mais réservées au chapitre 6.

## 2. Progression narrative

### 2.1 Préparation à la guilde

Le chapitre commence par le réveil et le lancement du chapitre, puis :

1. annonce de l'expédition par le Maître de Guilde ;
2. préparation de l'équipe et interdiction temporaire des missions ordinaires ;
3. discussions à la guilde, au café, à l'auberge et dans les maisons de Metano ;
4. scène de la famille de Zigzaton/Almotz avant le départ ;
5. constitution des équipes et briefing de l'itinéraire ;
6. départ collectif de la guilde.

### 2.2 Grande Steppe

La Grande Steppe est le premier donjon de l'expédition.

- 14 étages techniques : `0–13` ;
- un segment ;
- deux plages de génération : `0–6` puis `7–13` ;
- entrée : `vast_steppe_entrance` ;
- premier camp suivant l'expédition : `searing_tunnel_entrance` ;
- secours autorisés ;
- sauvegarde de l'entrée dans `SV.TemporaryFlags.LastDungeonEntered` ;
- gestion distincte de la victoire, de la fuite et de la défaite.

Ambiance prévue : plaine ouverte, troupeaux, adversaires rapides et visibilité plus large. La transition narrative prévoit une arrivée au premier camp après la traversée.

Les scènes de l'entrée gèrent également :

- la première introduction de la Steppe ;
- le ravitaillement après une défaite ;
- la fuite ;
- les conseils de Tropius et Noctowl ;
- la préparation avec le rocher de Kangourex.

### 2.3 Premier camp et nuit

Après la Steppe, la guilde installe un camp. La scène contient :

- l'installation du camp ;
- la préparation du repas ;
- la fatigue et les tensions entre membres ;
- les réflexions du héros sur la tension étrange ressentie depuis le départ ;
- le coucher ;
- le réveil du lendemain ;
- la présentation du Tunnel Incandescent.

### 2.4 Tunnel Incandescent

Le Tunnel est le deuxième donjon de l'expédition et le donjon le plus complexe du chapitre.

La zone possède actuellement trois segments techniques :

- segment 0 : 10 étages normaux, plages `0–4` et `5–9` ;
- segment 1 : 5 étages normaux de profondeurs ;
- segment 2 : une arène de boss au Crucible.

La structure de production retenue est donc **15 étages normaux + l’arène du Crucible**. Elle est volontaire et ne doit pas être réduite à l’ancien plan de 10 étages.

Les transitions implémentées sont :

- segment 0 réussi → point médian ;
- segment 0 échoué ou fui → entrée du Tunnel ;
- segment 1 échoué → point médian ;
- segment 1 réussi → Crucible ;
- boss vaincu → scène du Crucible ;
- boss perdu → retour au point médian ;
- échappée → entrée du Tunnel.

Les variables principales sont :

- `TunnelLastExitReason` : `Died`, `Escaped` ou `Retreated` ;
- `TunnelMidpointState` : `FirstArrival`, `RepeatArrival` ou `DeathArrival` ;
- `EncounteredBoss` ;
- `DefeatedBoss` ;
- `DiedToBoss` ;
- `JustDiedToBoss` ;
- `DiedPastCheckpoint` ;
- `PlayTempTunnelScene`.

Le Tunnel contient les scènes de :

- briefing du donjon ;
- équipe du premier passage ;
- défaite et ravitaillement ;
- fuite et retraite ;
- point médian ;
- clan de Pokémon lave ;
- introduction du Crucible ;
- combat ;
- effondrement contrôlé et évacuation ;
- retour au point médian après un échec.

### 2.5 Incohérence de conception à surveiller

Le document de planification indique : **10 étages + arène**, organisés en `2 × 5 + Crucible`.

Le JSON actuellement présent dans le dépôt expose en réalité :

- 10 étages dans le segment 0 ;
- 5 étages supplémentaires dans le segment 1 ;
- 1 arène de boss dans le segment 2.

Le moteur contient donc actuellement **15 étages normaux + l'arène**, et non 10 + l'arène. Cette différence doit être tranchée avant une validation finale de la génération du chapitre 5.

### 2.6 Mont Venteux

Le Mont Venteux est le troisième donjon de l'expédition.

- 13 étages techniques : `0–12` ;
- un segment ;
- deux plages : `0–6` puis `7–12` ;
- entrée : `mount_windswept_entrance` ;
- secours autorisés ;
- sortie de zone implémentée ;
- transition après réussite vers le retour de l'expédition.

Ambiance prévue : montée progressive, vents, Pokémon volants, falaises et visibilité réduite.

La progression contient :

- introduction du Mont ;
- équipe et préparation ;
- scènes de perte de repères ;
- défaite, fuite et ravitaillement ;
- sommet ;
- gardien du sommet ;
- phénomène lumineux inexpliqué ;
- retour à la guilde.

### 2.7 Retour à la guilde

La conclusion prévue comprend :

1. arrivée de l'équipe ;
2. rapport incomplet de l'expédition ;
3. inquiétude persistante concernant le phénomène lumineux ;
4. décision de préparer l'accès aux Aegis Cave ;
5. report de la résolution des ruines au chapitre 6.

## 3. État technique

### Zones

| Zone | Publiée | Segments | Étages / structure | État |
|---|---:|---:|---|---|
| `vast_steppe` | oui | 1 | 14 étages | jouable |
| `searing_tunnel` | oui | 3 | 15 étages normaux + arène | jouable, structure de production validée statiquement |
| `mount_windswept` | oui | 1 | 13 étages | jouable |
| `cloven_ruins` | non | 0 | aucune | volontairement réservée au chapitre 6 |

### Sorties de donjon

Les sorties gèrent désormais explicitement les résultats du moteur :

- défaite ;
- fuite ;
- victoire ;
- secours.

Le correctif écran noir précédent a notamment concerné :

- `mount_windswept/init.lua` ;
- `cloven_ruins/init.lua` ;
- `GeneralFunctions.RestoreIdleAnim()` ;
- le dialogue spécial de défaite qui déclenchait un second fondu frontal.

## 4. État de la traduction française

### Traduction effectuée

- 739 clés principales `MapStrings` du chapitre 5 vérifiées et traduites ;
- dialogues annexes des entrées, camps, maisons, café et auberge traduits ;
- voix off du départ traduites ;
- objectifs de mission du chapitre 5 traduits ;
- textes de défaite de la Steppe et du Tunnel traduits ;
- noms français ajoutés pour :
  - Grande Steppe ;
  - Tunnel Incandescent ;
  - Profondeurs Incandescentes ;
  - Mont Venteux ;
  - étages correspondants ;
- 80 clés de commentaires de personnalité d'expédition ajoutées dans `Strings/stringsEx.fr.resx`.

### Résultat du contrôle statique

- 178 fichiers Lua analysés ;
- 0 erreur de syntaxe Lua ;
- fichiers `.resx` analysés ;
- 0 erreur XML ;
- JSON de zones vérifiés ;
- 0 erreur JSON sur les zones modifiées.

Les appels de dialogue actifs du chapitre 5 ont été relus et leur texte visible est maintenant en français. Le nom du fichier audio `Guildmaster Wigglytuff.ogg` reste volontairement un identifiant de ressource et n'est pas un dialogue.

### Limite technique restante

Une partie des traductions annexes a été corrigée directement dans les scripts Lua au lieu d'être entièrement extraite dans des clés `.resx`. Le texte visible est français, mais une passe supplémentaire d'extraction serait nécessaire pour respecter strictement une architecture où chaque phrase est localisée uniquement par ressource.

Le reste du projet, surtout les chapitres 1 à 4, les menus génériques et `PartnerEssentials.lua`, contient encore de l'anglais et ne doit pas être présenté comme entièrement francisé.

## 5. Rencontres fixes du chapitre 5

Les mini-boss et gardiens sont désormais déclarés par `ScriptGenStep` et générés uniquement sur leur étage cible. La génération utilise les classes déjà présentes dans le projet et documentées par PMDO : `SpecificTeamSpawner`, `PresetMultiTeamSpawner`, `PlaceEntranceMobsStep` et `MobSpawn`.

| Zone | Étage affiché | `CurrentID` | Rencontre | Niveau | Génération |
|---|---:|---:|---|---:|---|
| Grande Steppe | 7 | 6 | Stantler + Mudbray | 20 / 19 | garantie à l’entrée de l’étage |
| Grande Steppe | 14 | 13 | Stantler, gardien | 23 | garantie à l’entrée de l’étage |
| Tunnel Incandescent | 5 | 4 (segment 0) | Torkoal + Magmar | 21 / 20 | garantie à l’entrée de l’étage |
| Mont Venteux | 7 | 6 | Gligar + Skarmory | 22 / 21 | garantie à l’entrée de l’étage |
| Mont Venteux | 13 | 12 | Aerodactyl, gardien du sommet | 24 | garantie à l’entrée de l’étage |

Les espèces et les capacités par défaut restent cohérentes avec les tables déjà utilisées dans ces trois zones. Les combats sont des rencontres hostiles normales avec tactique `boss`, sans commande PMDO inventée et sans téléchargement d’asset. La génération ne modifie ni le nombre d’étages du Tunnel, ni son arène.

**Limite de validation :** les rencontres ont été validées par analyse JSON et correspondance des fonctions Lua. PMDO n’est pas installé dans cet environnement ; l’apparition réelle, la position exacte sur une carte générée et l’équilibrage doivent encore être vérifiés en jeu.

## 6. Tests à faire dans PMDO

Le chargement réel dans PMDO n'a pas été effectué dans cet audit statique. Il faut tester :

1. entrée et sortie de la Grande Steppe ;
2. KO après le journal d'échec ;
3. fuite de la Grande Steppe ;
4. arrivée au camp ;
5. première entrée du Tunnel ;
6. KO avant le point médian ;
7. fuite avant le point médian ;
8. KO dans les profondeurs ;
9. arrivée au Crucible ;
10. défaite contre le boss ;
11. victoire contre le boss ;
12. entrée et défaite au Mont Venteux ;
13. victoire au sommet ;
14. retour à la guilde ;
15. non-répétition des cinématiques déjà jouées.

## Conclusion

Le contenu narratif du chapitre 5 est présent et ses trois destinations principales sont déclarées. La traduction visible du chapitre 5 a été complétée par la passe statique. Les mini-boss et gardiens sont maintenant branchés sur leurs étages cibles. Le Tunnel Incandescent conserve bien sa structure validée de 15 étages normaux + arène ; il reste à effectuer le parcours réel dans PMDO avant de déclarer le chapitre terminé en jeu.
