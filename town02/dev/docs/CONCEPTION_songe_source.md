# Revue et refonte — Le rêve de la Source (Mont Venteux, ch. 5)

Document de travail produit le 2026-07-29, conformément à
`docs/CARTE_BLANCHE_CUTSCENES.md` (6 contraintes non négociables) et
`docs/BRIEF_REVE_GARDEVOIR.md` (direction artistique). Méthode :
`docs/PASSATION_AGENT_ARENA.md`.

> **Réserve — RIEN N'A ÉTÉ TESTÉ EN JEU.** Validation statique seulement
> (compilation, formats, positions, marchabilité, mots interdits).

---

## 1. AUDIT DE L'EXISTANT (fichier + ligne, rien de supposé)

### 1.1 La scène actuelle

`Data/Script/halcyon/ground/mount_windswept_entrance/mount_windswept_entrance_ch_5.lua`,
section 10 de `CampNightfall` (lignes 609-663) : « LE REVE — l'ombre inconnue ».

- Le rêve se joue **sur écran noir** : `FadeOut` (l. 606) puis
  `VoiceVisions.DreamSky(560)` + `UI:WaitShowBG('Genesis_Void', 180, 30)` (l. 624-625)
  avec 5 répliques de la Voix anonyme (MWE5_080-084) et 2 pensées du héros
  (MWE5_085-086) après la disparition du fond.
- Le héros **n'est pas visible** dans son propre rêve. Aucun décor, aucun lieu,
  aucun personnage. C'est une suite de boîtes de dialogue sur planche noire.

### 1.2 Pourquoi ça ne fonctionne pas (points cumulés, contradictoires avec le brief)

| Exigence du brief | État constaté |
|---|---|
| Héros physiquement présent, au centre | Absent : sprites noyés sous le fondu noir (leçon déjà écrite dans VoiceVisions.lua) |
| Un lieu onirique qui vit (eau, nature, brume, particules) | Aucun lieu, une seule planche `Genesis_Void` |
| Apparition de Gardevoir progressive, moment fort | Aucune apparition : une signature `\uE040` et du texte |
| Musique du test de personnalité + dream parallax | `I Saw Something Again....ogg` à la place, nuages Dream_Back/Front en overlay temporaire seulement |
| Dialogue héros ↔ Gardevoir | Monologue : 5 répliques à sens unique, zéro réaction du héros pendant le rêve |
| Arc complet (intro → montée → révélation → conclusion) | Flat : 5 boîtes à la suite, puis noir |

**Décision** : reconstruire entièrement. La structure noire actuelle est démolie,
pas patchée — conformément au brief (« ne pas réparer l'existant morceau par morceau »).

### 1.3 Ce qui est gardé

- **Les textes de la Voix (MWE5_080-084)** : ils sont la continuité narrative du mod
  (le « petit écho »). Re-montés dans la nouvelle scène, prononcés par Gardevoir
  incarnée — la Voix avait raison de rester anonyme à l'écran noir ; elle gagne un corps.
- **MWE5_085-086 (pensées du héros au réveil)** : déplacées dans la scène de réveil
  au camp, où elles ont plus de poids (le héros parle dans la nuit, Phileas entend).
- La veillée (sections 1-9 de `CampNightfall`) et le matin (sections 11-16) :
  inchangés dans leur contenu, re-câblés (voir §4).

### 1.4 Inventaire des assets prouvés

- **Map donneuse** : `Data/Ground/luminous_spring.rsground` — 75×75 cellules de 24 px
  (1800×1800), zone bâtie mesurée au pixel : x∈[0,596], y∈[0,596]. Source magique
  lumineuse (piscine y 128-272, glow blanc ≈(390,205)), rive sableuse (y 285-305,
  centre ≈(390,297)), prairie (y 310-525), forêt sombre tout autour, **vide noir
  partout ailleurs**. Utilisée par `illuminant_riverbed` (ch. 2, scène Numel) →
  **clone, jamais modification de l'original**.
- **Dream parallax du test de personnalité** : `personality_test.rsground`,
  `Background = RogueEssence.Dungeon.LayeredBG` avec `Dream_Back` (mouvement X 30,
  RepeatX) et `Dream_Front` (mouvement X 56). Configuration copiée à l'identique :
  dans le vide de la map, le ciel de rêve défile à l'infini autour de la clairière.
- **Musique du test de personnalité** : `Welcome to the World of Pokémon!.ogg`
  (champ `Music` de `personality_test.rsground` + `SOUND:PlayBGM` dans son init.lua:141).
- **Gardevoir** : espèce `gardevoir` attestée (cliente de mission,
  `mission_gen.lua:1149`). Sprites/portraits fournis par le socle PMDO hors dépôt.
  Aucune occurrence comme personnage scripté : création d'une entrée
  `CharacterEssentials` dédiée (instance `Gardevoir`).
- **Effets attestés dans le dépôt** : `BossFX.EmergeMist` (Fog + Silver_Wind +
  `DUN_Mist`, « la brume se condense et la silhouette se matérialise » — signature
  spectrale de BossFX), `BossFX.Flash`, `BossFX.Particle` (`Sakura_Fall`,
  `Leaf_Fall`, `Snow_Fall` présents dans Content/Particle), SE `DUN_Power_Gem`
  (son de cristal, déjà le son des rêves du héros), `DUN_Heal_Bell` (soin/soothing).
- **Patron de map narrative aller-retour** : `genesis_vision`
  (`GAME:EnterGroundMap` depuis `guild_third_floor_lobby_ch_7.lua:121`,
  Enter → cinématique complète → `GAME:EnterGroundMap` retour, routage par flag SV).

### 1.5 Transitions existantes (avant refonte)

```
tunnel (searing_crucible) ──EnterGroundMap──▶ mount_windswept_entrance
        ArrivalCutscene ─▶ CampNightfall (sections 1-16 dont rêve noir §10)
                        ─▶ SetParty ─▶ camp de base jouable
```

Le rêve est un bloc interne : rien d'autre n'en dépend. Les sections 11-16 du matin
sont indépendantes du §10 (elles redémarrent sur téléportations sous le noir).

---

## 2. CONCEPTION — LE SONGE DE LA SOURCE

### 2.1 Nouvelle map `songe_source`

Clone de `luminous_spring` avec :

- `AssetName = songe_source`, nom affiché EN « Dream Spring » / FR « Source du Songe » ;
- `Released = false`, `NoSwitching = true`, musique vide (la scène pilote la BGM) ;
- **Background** ← configuration Dream_Back/Dream_Front de `personality_test`
  (parallaxe infini visible dans tout le vide de la map) ;
- entités héritées (marqueur `Main_Entrance_Marker` (292,580), spawners) ;
- objets `South_Exit` / `Spring` retirés (map uniquement cinématique, pas de
  callback tactile à recréer ; la sortie se fait par `EnterGroundMap`).

### 2.2 Scène `songe_source_ch_5.PlayDream` — 5 actes

Personnages : héros seul (partenaire et équipiers cachés à l'entrée), Gardevoir
(spawn cachée, révélée par la séquence d'apparition).

Composition (mesurée sur le rendu pixel de la map, `docs/renders/`) :

- héros : prairie, (390, 430) — centre de la clairière ;
- Gardevoir : rive sableuse au bord de la source, (390, 297) — l'eau comme ancre,
  glow de la source derrière elle (composition verticale : cascade → source → elle → héros) ;
- caméra : intro **(390,315)** plan large clairière+source — arbitrage au pixel :
  le halo (y≈205) et les pieds du héros (y=430) distants de 225 px, écran 240 px ;
  315 laisse 5 px sous ses pieds ET le halo visible (bord haut 195) — la
  proposition initiale (390,300) lui rognait 10 px de chausses. La caméra
  accompagne ensuite sa marche jusqu'à (390,300) ; apparition (390,285) ;
  dialogue (390,315) (cadre source + les deux) ; dissolution (390,330).

1. **L'éveil dans le songe** — noir, la musique du test de personnalité ENTRE dans
   le noir (avant l'image, règle « le son, puis l'image, puis le mot »). FadeIn lent
   (100). Héros allongé (`EventSleep`) au centre ; Shake, Wake, LookAround ; caméra
   balayée vers la source. Pensées REVE5_001-002 (le lieu est familier — il y est
   allé au ch. 2 — mais le ciel n'est pas réel : « Je rêve. »). Pétales `Sakura_Fall`.
2. **L'apparition** — la musique se retire : **silence temporaire**. La source pulse
   (Flash doux ×2, `DUN_Power_Gem`). Brouillard + vent d'argent (patron
   `BossFX.EmergeMist`), puis **clignotement progressif du sprite** : 3 battements
   Hide/Unhide décroissants rythmés par le son de cristal, flash à chaque
   réapparition, puis stabilisation (`glowing`). Caméra attirée vers la rive.
   REVE5_003 : « … Te voilà encore. Encore une fois. »
3. **Le dialogue** — choc du héros (« C'est ELLE, la voix. »), elle apaise
   (« N'aie pas peur, petit écho… »), il s'approche de 2 pas (justifié : attiré),
   il demande, elle répond sans se nommer (« Une amie d'un autre temps. »).
4. **La révélation** — plan resserré, silence mesuré : « La montagne s'est allumée…
   Tu l'as déjà vue brûler… » → héros : vertige (Nausea 1) + pulsation lumineuse ;
   « Monte. Le vent se souvient de toi. »
5. **La dissolution** — clignotement inverse, brouillard, pétales : « Au sommet, ne
   me cherche pas. C'est moi qui te trouverai. » / « Nous nous sommes déjà
   rencontrés, petit écho. Et nous nous rencontrerons encore. » Elle s'efface ;
   héros seul ; Nausea(2) ; voile ; FadeOut.

Speaker de Gardevoir : `\uE040` anonyme (continuité de la Voix ; elle ne se nomme
pas — douce, mystérieuse, ancienne). Sprite clairement Gardevoir.

Sortie garantie hors pcall : flags, `CutsceneMode(false)`, `FadeOut`, retour
`EnterGroundMap('mount_windswept_entrance', 'Main_Entrance_Marker')`.

### 2.3 Recâblage de la nuit du Mont

```
ArrivalCutscene ─▶ CampNightfall §1-9 (INCHANGÉ : dîner…coucher, caméra sur le
│                    camp endormi, FadeOut)
│   SV.Chapter5.MountDreamPending = true ─▶ EnterGroundMap('songe_source')
▼
songe_source.PlayDream ─▶ MountDreamDone = true, Pending = false
│                     ─▶ EnterGroundMap('mount_windswept_entrance')
▼
init.PlotScripting : (MountDreamDone and not FinishedMountWindsweptIntro)
   ─▶ mount_windswept_entrance_ch_5.DreamWakeAndMorning()
        a. Réveil : camp de nuit reconstruit sous le noir (paillasses DeployBeds,
           darkness, 10 PNJ recréés endormis à leurs couches — EXACTEMENT leur
           état de fin de §9 —, Phileas au poste (256,148)), FadeIn.
           Le héros se réveille agité (Shake×2, Wake, LookAround) : MWE5_085-086.
        b. LA VEILLE DE PHILEAS (lot 2 validé) : notice → trajet prouvé BFS
           (244,156) → (244,204) → (236,268), 26 px de distance des dormeurs,
           DownLeft vers le héros → MWE5_090 (rassure) / MWE5_091 (héros surpris)
           / MWE5_118 (les rêves du vent, archives du vieux poste) / MWE5_119
           (« Rendors-toi… ») → héros se recouche (EventSleep) → Phileas retourne
           à son poste par le même corridor, reprend la veille → FadeOut.
        c. Matin §11-16 DÉPLACÉES telles quelles (réveil, rassemblement, cordées,
           départs, scène finale) → SetParty, FinishedMountWindsweptIntro,
           caméra rendue, BGM — queue identique à l'ancienne ArrivalCutscene.
```

Nouveaux flags SV.Chapter5 : `MountDreamPending`, `MountDreamDone`
(déclarés dans `scriptvars.lua` + rattrapage `OnUpgrade` de `debug_tools`).

### 2.4 Conformité aux 6 contraintes

1. **Cadrage** — chaque beat a sa cible caméra ; personne ne parle hors champ
   (dialogue cadre 195-435 en Y : source, Gardevoir, héros visibles).
2. **Positionnement esthétique** — axe vertical source/elle/héros mesuré au pixel
   sur le rendu ; distance de dialogue 32 px (2 cases) ; lui approche à 64 px.
3. **Réactivité** — le héros réagit à chaque beat (Wake, LookAround, shock, Nausea,
   mouvement) ; elle réagit (glowing, tourne vers lui, se retire).
4. **Dialogues en personnalité** — elle : douceur ancienne, jamais de phrase
   générique ; héros : pensées courtes, qui portent peur/curiosité/émerveillement.
5. **Déplacements justifiés** — dans le songe : un seul rapprochement volontaire ;
   au camp : le trajet de veille est prouvé BFS, ne traverse personne (26 px).
6. **Rêve** — héros au centre, musique du test de personnalité, dream parallax,
   apparition progressive de Gardevoir, dialogue après stabilisation. ✔

### 2.5 Impact comptage d'intégrité

- `MWE5_080-084` (textes du rêve noir démoli, repris dans
  REVE5_003/008/010/011/013) : **supprimées** des deux resx de l'entrée,
  par souci d'hygiène → référence `audit_integrite` **inchangée à 925**
  (vérifié après livraison, toutes catégories identiques à la baseline).
- Toutes les nouvelles clés sont référencées ; aucune nouvelle instance
  inconnue (Gardevoir entre dans CharacterEssentials) ; aucun son unique.
- `verify_bg_format` : les overlays Fog/Silver_Wind passent par
  `BossFX.EmergeMist(nil, ...)` (helper attesté) → aucun overlay littéral
  nouveau dans les scripts.

---

## 3. STATUT

| Élément | État |
|---|---|
| Audit (§1) | ✅ terminé |
| Conception validée (§2) | ✅ carte blanche + brief du 2026-07-29 |
| Map `songe_source.rsground` | ✅ générée + rendue (`tools/make_songe_source.py`) |
| Scène du songe | ✅ écrite (`songe_source_ch_5.PlayDream`, 5 actes) |
| Réveil + veille + matin (DreamWakeAndMorning) | ✅ codé (`tools/refonte_songe_entrance.py`) |
| Clés resx | ✅ 13 REVE5_* (EN+FR), 4 MWE5_* veille (EN+FR), 5 obsolètes retirées |
| Flags SV | ✅ MountDreamPending / MountDreamDone (scriptvars + OnUpgrade) |
| Validation statique | ✅ compile 664/664, audit_bugs 12, legend ✓, positions ✓, bg_format ✓, validate_all ✓, intégrité 925 (baseline), ch5 1572/7000 |
| **Test en jeu** | ❌ **non testé — à valider par l'utilisateur** |
