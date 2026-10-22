# New Era — Zones Vivantes Chapitres 8-10
## Conception PMD — Fonction narrative, Faune, Ambiance, Assets
### Généré 2026-07-26 — New Era: Abyss to Ascension V4

---

## 📐 MÉTHODOLOGIE

Chaque zone suit la même grille :
1. **Fonction narrative** — pourquoi elle existe dans l'histoire
2. **Faune** — peuplement cohérent biome/chaîne alimentaire/lore
3. **Ambiance** — animations justifiées par la logique environnementale
4. **Assets** — vérification disponibilité réelle dans le projet (219 .tile, 58 .rsground)
5. **Cohérence** — lien avec la géographie, le lore, les personnages existants

---

## CHAPITRE 8 — « Le Sanctuaire de Cristal »
### (Arc 2 : Les Cœurs qui s'éteignent — 1/5)

### 1. FONCTION NARRATIVE

**Contexte** : Après avoir vaincu Regigigas et libéré le Cœur des Aegis Cave (Chap. 7),
Phileas révèle l'existence d'un ancien sanctuaire où les premiers gardiens des Cœurs
ont consigné leur savoir. Les héros doivent s'y rendre pour comprendre COMMENT protéger
un Cœur qui s'éteint — la bataille ne suffit pas toujours.

**Rôle dans l'arc** : Premier donjon de l'Arc 2. Montre que les Cœurs sont fragiles et
que la corruption s'étend. Le sanctuaire lui-même est partiellement cristallisé — signe
qu'un Cœur proche est en train de se solidifier/mourir. Introduit la notion de
« Cœur malade » (par opposition à « Cœur possédé » comme Regigigas).

**Structure** : 3 segments — 12 étages normaux + checkpoint + 6 étages profonds + boss
**Boss** : Diancie (Lv. 42) — gardienne cristalline du sanctuaire, non hostile mais
teste les héros. Carbink x4 en renfort. Combat de « purification » (elle est possédée
par la corruption mais pas malveillante).

**Post-combat** : Diancie, libérée, offre un Fragment de Cristal — clé pour le Chapitre 9.

### 2. FAUNE (Spawn Tables par segment)

**Segment 1 — Galeries Cristallines (étages 1-6)**
| Pokémon | Type | Niveau | Comportement |
|---------|------|--------|-------------|
| Tarsal | Psy/Fée | 28-32 | Curieux, fuit si attaqué |
| Archéomire | Psy | 28-33 | Flotte, observe le joueur |
| Séléroc | Roche/Psy | 29-34 | Gardien, attaque si dérangé |
| Carbink | Roche/Fée | 30-34 | Pacifique, soigne ses alliés |
| Racaillou | Roche/Sol | 28-32 | Roule, fonce sur le joueur |
| Mystherbe | Plante/Poison | 27-31 | Camouflé dans les cristaux |
| Ténéfix | Ténèbres/Spectre | 29-33 | Embusqué, attaque par surprise |

**Segment 2 — Salles des Glyphes (étages 7-12)**
| Pokémon | Type | Niveau | Comportement |
|---------|------|--------|-------------|
| Kirlia | Psy/Fée | 30-35 | Danse, téléportation courte |
| Galekid | Roche | 30-34 | Roule en groupe |
| Archéodong | Psy/Acier | 32-36 | Gardien de salle, puissant |
| Zarbi (F, G, K) | Psy | 28-33 | Flotte en motifs, non-hostile sauf si touché |
| Tarinor | Acier/Psy | 30-34 | Bloque les couloirs |
| Téraclope | Spectre | 29-33 | Hante les galeries secondaires |
| Gringolem | Sol/Spectre | 31-35 | Patrouille les salles aux glyphes |

**Segment 3 — Cœur de Cristal (étages 13-18)**
| Pokémon | Type | Niveau | Comportement |
|---------|------|--------|-------------|
| Gardevoir | Psy/Fée | 35-39 | Rare, protège le sanctuaire |
| Galegon | Roche | 34-38 | Gardien d'élite |
| Métang | Acier/Psy | 35-38 | Sentinelle, détecte le joueur à 5 cases |
| Ténéfix (alpha) | Ténèbres/Spectre | 33-37 | Groupe de 3, attaque coordonnée |
| Solaroc | Roche/Psy | 34-37 | Émet une lueur, révèle les pièges ET le joueur |

### 3. AMBIANCE & ANIMATIONS

**Environnement visuel** :
- Sol : dalles de cristal bleuté translucide + pierre grise veinée (First_Core_Location_Base)
- Murs : parois cristallines irrégulières + colonnes de marbre blanc (First_Core_Location + Relic_Forest_Blob_Pillar)
- Eau : aucune — remplacée par des veines cristallines lumineuses au sol (non-walkable)
- Objets : cristaux géants (First_Core_Location_Objects), glyphes lumineux, autels de pierre

**Animations justifiées par le biome** :
1. **Cristaux scintillants** (particules 4×4px, blanc-bleu, cycle 3s) — reflets sur les parois
2. **Glyphes pulsants** (runes au sol qui s'allument/s'éteignent, cycle 6s, lueur cyan)
3. **Poussière cristalline** (particules lentes descendantes, comme de la neige minérale)
4. **Échos lumineux** (flashs ponctuels quand le joueur s'approche d'un cristal)
5. **Ombre mouvante des colonnes** (projection d'ombres tournant lentement)

**Pokémon vivants** :
- Carbink : flotte doucement, émet des notes cristallines (pas de combat, animation uniquement)
- Zarbi : forment des motifs géométriques qui se défont à l'approche du joueur
- Tarsal/Kirlia : dansent ou méditent près des cristaux, téléportent si dérangés

**OST** : `Anima Core.ogg` (déjà présent) — thème cristallin et mystérieux

### 4. VÉRIFICATION ASSETS

| Asset | Catégorie | Disponible | Usage |
|-------|-----------|-----------|-------|
| `First_Core_Location_Base.tile` | Sol cristal | ✅ 448 Ko, 4347 tuiles 8px | Sol du donjon |
| `First_Core_Location_Objects.tile` | Cristaux | ✅ 163 tuiles | Objets décoratifs |
| `First_Core_Location_Shadows.tile` | Ombres | ✅ 86 tuiles | Ombres colonnes |
| `Crooked_Cavern_Base.tile` | Murs caverne | ✅ 1200 tuiles 8px | Murs segments 2-3 |
| `Relic_Forest_Blob_Pillar.tile` | Colonne | ✅ 3 tuiles 24px | Colonnes salle boss |
| `Relic_Forest_Blob_Ruins.tile` | Ruines | ✅ 12 tuiles 24px | Glyphes, autels |
| `Relic_Forest_Blob_Rubble.tile` | Débris | ✅ 1 tuile 24px | Débris cristallins |
| `Spring_Cave_Pit.tile` | Cave puits | ✅ 722 tuiles 24px | Entrée checkpoint |
| `Content/Music/Anima Core.ogg` | Musique | ✅ | OST donjon |
| `Content/BG/Genesis_Cores.dir` | BG cinématique | ✅ | Cinématique post-boss |

✅ **Tous les assets sont disponibles. Aucun nouveau sprite/tileset requis.**

### 5. COHÉRENCE AVEC L'EXISTANT

- **Géographie** : Le sanctuaire est situé dans les contreforts du Mont Venteux (Mount Windswept) — même chaîne montagneuse, logique de continuité spatiale.
- **Lore** : Mentionné par Phileas dans ses dialogues Ch7 (`MT7_Noctowl_005`) comme « les anciens sanctuaires ».
- **Personnages** : Penticus (Tropius) connaît le chemin — dialogue d'introduction à Metano Town (`MT8_Tropius_001`).
- **Progression** : Diancie rejoint la liste des boss vaincus, Fragment de Cristal → clé pour le Marais (Ch9).

---

## CHAPITRE 9 — « Le Marais de l'Oubli »
### (Arc 2 : Les Cœurs qui s'éteignent — 2/5)

### 1. FONCTION NARRATIVE

**Contexte** : Le Fragment de Cristal de Diancie réagit à une source de corruption
lointaine. Les héros suivent sa pulsation jusqu'aux Marais de l'Oubli, une zone
marécageuse où un Cœur se noie littéralement dans une corruption liquide.
**Première apparition du Cercle du Suaire** (Banette, Ectoplasma, Nosferalto) —
ils semblent ACCÉLÉRER la corruption plutôt que la combattre.

**Rôle dans l'arc** : Présente les antagonistes spectraux de l'Arc 2. Montre une
nouvelle forme de corruption (liquide/toxique, pas solide/cristalline comme Ch8).
Établit que les ennemis ne sont pas tous des boss sauvages — certains sont des
Pokémon rationnels avec leurs propres objectifs.

**Structure** : 3 segments — 10 étages marécageux + checkpoint + 8 étages profonds + boss
**Boss** : Méga-Tortank (Lv. 44) — gardien corrompu du Cœur noyé, gonflé par
l'énergie toxique. Combat en 2 phases : carapace (défensif) → berserk (offensif).

**Post-combat** : Le Cœur est purifié mais affaibli. Banette apparaît brièvement
et lance : « Vous croyez sauver quoi que ce soit ? Chaque cœur que vous "guérissez"
rapproche la fin. » — départ en brume. Premier indice du twist de l'Arc 5-6.

### 2. FAUNE (Spawn Tables par segment)

**Segment 1 — Berges Putrides (étages 1-5)**
| Pokémon | Type | Niveau | Comportement |
|---------|------|--------|-------------|
| Tadmorv | Poison | 28-32 | Émerge de la vase, lent |
| Smogogo | Poison | 29-33 | Flotte, émet des spores |
| Bulbizarre | Plante/Poison | 28-32 | Se camoufle dans les nénuphars |
| Nénupiot | Eau/Plante | 28-33 | Flotte sur l'eau, timide |
| Axoloto | Eau | 27-31 | Nage dans l'eau trouble |
| Marcacrin | Sol | 29-33 | Fouille la boue, grogne |
| Goupix | Feu | 28-32 | Égaré, apeuré (incohérence volontaire — intrigue) |

**Segment 2 — Cœur du Marécage (étages 6-10)**
| Pokémon | Type | Niveau | Comportement |
|---------|------|--------|-------------|
| Gobou | Eau | 29-34 | Nage rapide, esquive |
| Ortide | Plante/Poison | 30-35 | Immobile, émet spores paralysantes |
| Tadmorv (alpha) | Poison | 31-35 | Énorme, bloque le chemin |
| Cornèbre | Ténèbres/Vol | 29-33 | Observe depuis les arbres morts |
| Spectrum | Spectre/Poison | 30-34 | Traverse les murs, hante |
| Maraiste | Eau/Sol | 31-35 | Embusqué dans la vase |
| Insolourdo | Normal | 30-34 | Pêche dans l'eau, ignore le joueur |

**Segment 3 — Abysses Vaseux (étages 11-18)**
| Pokémon | Type | Niveau | Comportement |
|---------|------|--------|-------------|
| Smogogo (x2) | Poison | 33-37 | Attaque en duo |
| Florizarre | Plante/Poison | 34-38 | Boss de salle optionnel |
| Flagadoss | Eau/Psy | 33-37 | Bâille, endort le joueur |
| Démolosse | Ténèbres/Feu | 34-37 | Traque, attaque par derrière |
| Maraiste (géant) | Eau/Sol | 35-39 | Mini-boss optionnel |
| Nosferalto | Poison/Vol | 33-36 | **Membre du Cercle du Suaire** — apparaît furtivement, ne combat pas, observe |

### 3. AMBIANCE & ANIMATIONS

**Environnement visuel** :
- Sol : boue sombre + herbes marécageuses + eau stagnante (Altere_Pond_Base)
- Murs : arbres morts + falaises de terre noire (Altere_Pond_Cliffs + Apricorn_Glade_Big_Tree)
- Eau : marais stagnant avec nénuphars, bulles de méthane (Altere_Pond_River_Animations)
- Objets : racines noueuses, arbres tombés, champignons vénéneux, vapeurs toxiques

**Animations justifiées par le biome** :
1. **Eau stagnante** (ondulations lentes, 4 frames, cycle 12s — Altere_Pond_River_Animations)
2. **Bulles de méthane** (particules 8×8px, montent de la vase, éclatent en surface)
3. **Brume basse** (overlay semi-transparent, mouvement lent horizontal)
4. **Vapeurs toxiques** (volutes vert-jaune au-dessus des zones empoisonnées)
5. **Lucioles des marais** (particules jaune-vert, trajectoire erratique)
6. **Pluie fine intermittente** (particules verticales, densité variable)

**Pokémon vivants** :
- Tadmorv : émergent lentement des flaques de boue, laissent une traînée
- Nénupiot : flottent en cercle sur l'eau, plongent à l'approche
- Cornèbre : perché sur les arbres morts, croasse, s'envole si approché
- Nosferalto (Cercle du Suaire) : apparaît en fondu dans la brume, observe, disparaît

**OST** : `Deep Dark Crater.ogg` (déjà présent) — ambiance sombre et oppressante

### 4. VÉRIFICATION ASSETS

| Asset | Catégorie | Disponible | Usage |
|-------|-----------|-----------|-------|
| `Altere_Pond_Base.tile` | Sol marais | ✅ 384 Ko, 11044 tuiles 8px | Sol du marécage |
| `Altere_Pond_Cliffs.tile` | Falaises | ✅ 1840 tuiles 8px | Bordures |
| `Altere_Pond_Objects.tile` | Objets | ✅ 4601 tuiles 8px | Racines, souches |
| `Altere_Pond_River.tile` | Eau | ✅ 1036 tuiles 8px | Eau stagnante |
| `Altere_Pond_River_Animations.tile` | Eau animée | ✅ 4236 tuiles 8px | Ondulations |
| `Altere_Pond_Shadows.tile` | Ombres | ✅ 56 tuiles 8px | Ombres arbres |
| `Apricorn_Glade_Big_Tree.tile` | Arbre géant | ✅ 525 tuiles 8px | Arbres morts |
| `Apricorn_Glade_Trees.tile` | Arbres | ✅ 3319 tuiles 8px | Végétation |
| `Apricorn_Glade_Objects.tile` | Objets forêt | ✅ 247 tuiles 8px | Champignons |
| `Illuminant_Riverbed_Objects.tile` | Rivière | ✅ 543 tuiles 8px | Nénuphars |
| `Deep Dark Crater.ogg` | Musique | ✅ | OST donjon |

✅ **Tous les assets sont disponibles.**

### 5. COHÉRENCE AVEC L'EXISTANT

- **Géographie** : Le marais est situé au sud-est de Metano, au-delà de la Rivière Illuminante (Illuminant Riverbed) — mentionné dans les dialogues Ch2 comme « les marais du sud ».
- **Lore** : Le Cercle du Suaire est teasé dès le Chap. 6 (`MT6_084` : « une ombre dans la forêt ») et Chap. 7 (`MT7_111` : « une présence qui observe »).
- **Personnages** : Mawile (Bria) colporte des rumeurs sur « des spectres dans les marais » (dialogue `MT9_Mawile_001`). Floatzel (Tweed) confirme que « l'eau est devenue acide » (`MT9_Floatzel_001`).
- **Progression** : Première vraie interaction avec les antagonistes de l'Arc 2, escalade du danger.

---

## CHAPITRE 10 — « Le Pic Céleste »
### (Arc 2 : Les Cœurs qui s'éteignent — 3/5)

### 1. FONCTION NARRATIVE

**Contexte** : Après la rencontre avec le Cercle du Suaire, les héros sont troublés.
Leurs rêves (depuis Ch7) s'intensifient — visions d'une silhouette prismatique
enchaînée dans le vide, une voix qui murmure « plus haut... plus haut... ».
Phileas interprète : un être ancien tente de communiquer depuis le Pic Céleste,
une montagne sacrée où le ciel touche la terre. L'Escouade Fulgur (Luxray, Lucario,
Héliolisk) est déjà en route — course vers le sommet.

**Rôle dans l'arc** : Point culminant émotionnel de l'Arc 2. Affrontement indirect
avec l'Escouade Fulgur (pas de combat, mais une course — qui arrive au sommet
en premier ?). Révélation : Necrozma n'est pas nommé, mais sa silhouette apparaît
dans une vision. Le message est cryptique : « La lumière n'est pas ce qu'elle semble.
Cherchez sous l'écaille. »

**Structure** : 4 segments — 8 étages ascension + checkpoint + 6 étages ciel +
miniboss Escouade Fulgur (arrivée simultanée) + 4 étages sommet + boss

**Boss** : Lugia (Lv. 46) — gardien du Pic Céleste, premier contact avec un
légendaire de haut rang. Combat aérien sur plates-formes nuageuses. N'est PAS
corrompu — il teste les héros car « seuls les cœurs purs peuvent entendre la vérité ».

**Post-combat** : Lugia confirme les paroles de Necrozma sans le nommer.
« Quelque chose dort sous le monde. La lumière des Cœurs le contient. Chaque
Cœur qui s'éteint... le rapproche du réveil. » — écho direct au twist final.

### 2. FAUNE (Spawn Tables par segment)

**Segment 1 — Contreforts Venteux (étages 1-8)**
| Pokémon | Type | Niveau | Comportement |
|---------|------|--------|-------------|
| Roucool | Normal/Vol | 30-34 | S'envole à l'approche |
| Hoothoot | Normal/Vol | 30-33 | Dort le jour (si jour), actif la nuit |
| Natu | Psy/Vol | 30-34 | Fixe le joueur, téléportation courte |
| Tylton | Normal/Vol | 30-34 | Plane, descend en piqué |
| Cornèbre | Ténèbres/Vol | 31-35 | Dérobe des objets, fuit |
| Furaiglon | Normal/Vol | 30-33 | Attaque en groupe |
| Hélionceau | Électrik | 31-34 | Éclaireur curieux, non-hostile |

**Segment 2 — Mer de Nuages (étages 9-14)**
| Pokémon | Type | Niveau | Comportement |
|---------|------|--------|-------------|
| Xatu | Psy/Vol | 34-38 | Gardien silencieux, prédit les mouvements |
| Altaria | Dragon/Vol | 34-38 | Chante, berceuse (Sommeil) |
| Togetic | Fée/Vol | 33-37 | Joue, esquive, pacifique |
| Magicarpe | Eau | 30-35 | Saute des nuages (!), inoffensif |
| Léviator | Eau/Vol | 36-40 | Rare, surgit des nuages denses |
| Démanta | Eau/Vol | 33-37 | Plane, insouciant |
| Nosferalto | Poison/Vol | 34-37 | **Cercle du Suaire** — suit les héros discrètement |

**Segment 3 — L'Escouade Fulgur (étages 15-18, affrontement indirect)**
Luxray, Lucario et Héliolisk apparaissent comme PNJ hostiles mais ne combattent pas.
Ils activent des pièges, bloquent des passages, forcent le joueur à trouver des
chemins alternatifs. Course tactique, pas un combat direct.

**Segment 4 — Sommet Sacré (étages 19-22)**
| Pokémon | Type | Niveau | Comportement |
|---------|------|--------|-------------|
| Métalosse | Acier/Psy | 37-42 | Gardien d'élite, très rare |
| Drattak | Dragon/Vol | 37-42 | Patrouille les cimes |
| Libégon | Dragon/Vol | 36-41 | Plane en cercle |
| Crikzik | Insecte | 36-40 | Mélodie apaisante |
| Mentali | Psy | 37-42 | Apparaît, fixe le joueur, disparaît |
| Solaroc | Roche/Psy | 35-40 | Flotte près du soleil (si jour) |
| Séléroc | Roche/Psy | 35-40 | Flotte près de la lune (si nuit) |

### 3. AMBIANCE & ANIMATIONS

**Environnement visuel** :
- Sol (segments 1-2) : pierre grise de montagne + nuages blancs (MountWindswept_Base + TemporalPinnacle)
- Sol (segments 3-4) : dalles flottantes bleutées + plates-formes nuageuses (TemporalPinnacle)
- Murs (segments 1-2) : falaises verticales + ciel ouvert (MountWindswept_Mountain)
- Murs (segments 3-4) : colonnes célestes + vide nuageux (pas de murs — bordures de nuages)
- Eau : aucune — remplacée par des nuages denses (non-walkable, ralentissants)
- Objets : ruines antiques flottantes, piliers brisés, autels de pierre blanche

**Animations justifiées par le biome** :
1. **Nuages mouvants** (masses blanches traversant l'écran lentement, 3 tailles différentes)
2. **Vent puissant** (particules linéaires diagonales, poussent légèrement le joueur)
3. **Aurores boréales** (segments 3-4, overlay ondulant vert/violet/bleu)
4. **Éclats de lumière** (particules dorées flottant vers le haut, comme des braises inversées)
5. **Ciel changeant** (aube→jour→crépuscule→nuit selon l'étage, reflet narratif)
6. **Étoiles filantes** (segments 3-4, rares, rapides)

**Pokémon vivants** :
- Magicarpe : sautent entre les nuages — animation comique PMD canonique
- Altaria : chantent en duo, créent des arcs-en-ciel miniatures
- Xatu : immobiles, fixent l'horizon, ne réagissent pas au joueur
- L'Escouade Fulgur : PNJ mobiles avec routines de course, dialogues de défi

**OST** : `Sky Peak Cave.ogg` (segments 1-2), `Sky Peak Prairie.ogg` (segments 3-4) — déjà présents

### 4. VÉRIFICATION ASSETS

| Asset | Catégorie | Disponible | Usage |
|-------|-----------|-----------|-------|
| `Mount_Windswept_Base.tile` | Sol montagne | ✅ 4347 tuiles 8px | Sol segments 1-2 |
| `Mount_Windswept_Mountain.tile` | Montagne | ✅ 240 Ko, 1388 tuiles 8px | Falaises |
| `Mount_Windswept_Fringe.tile` | Bordures | ✅ 279 tuiles 8px | Bordures falaise |
| `Mount_Windswept_Objects.tile` | Objets | ✅ 640 tuiles 8px | Rochers, piliers |
| `Mount_Windswept_Shadows.tile` | Ombres | ✅ 482 tuiles 8px | Ombres |
| `TemporalPinnacle.tile` | Pic céleste | ✅ 201 Ko, 400 tuiles 24px | Plates-formes nuageuses |
| `Mount_Windswept_Objects_Under.tile` | Sous-couche | ✅ 17 tuiles 8px | Nuages bas |
| `Vast_Steppe_Cliifs.tile` | Falaises | ✅ 697 tuiles 8px | Falaise alternative |
| `Sky Peak Cave.ogg` | Musique | ✅ | OST segments 1-2 |
| `Sky Peak Prairie.ogg` | Musique | ✅ | OST segments 3-4 |

✅ **Tous les assets sont disponibles.**

### 5. COHÉRENCE AVEC L'EXISTANT

- **Géographie** : Le Pic Céleste est le point culminant de la chaîne du Mont Venteux — logique après Ch5 (Mount Windswept) et Ch8 (Sanctuaire de Cristal dans les contreforts).
- **Lore** : La vision de Necrozma (DreamCutscene Ch7) trouve son écho ici — c'est la première confirmation que les rêves ne sont pas des cauchemars, mais des messages.
- **Personnages** : L'Escouade Fulgur (Luxray, Lucario, Héliolisk) a été mentionnée dans les dialogues Ch6-7 comme « l'équipe aux yeux d'or ». Leur introduction physique se fait ici.
- **Progression** : Transition Arc 2 → Arc 3 — le message « Cherchez sous l'écaille » lance la quête des chapitres 11-12.

---

## 📊 TABLEAU RÉCAPITULATIF CHAPITRES 8-10

| | Ch8 — Sanctuaire de Cristal | Ch9 — Marais de l'Oubli | Ch10 — Pic Céleste |
|---|---|---|---|
| **Donjon** | `crystal_sanctuary` | `forgotten_marsh` | `celestial_peak` |
| **Biome PMD ref** | Crystal Cave + Ancient Relic | Poison Swamp + Gourd Swamp | Temporal Tower + Sky Peak |
| **Étages** | 18 (6+6+6) | 18 (5+5+8) | 22 (8+6+4+4) |
| **Segments** | 3 | 3 | 4 |
| **Boss** | Diancie L42 | Méga-Tortank L44 | Lugia L46 |
| **Antagonistes** | Corruption cristalline | Cercle du Suaire (intro) | Escouade Fulgur (course) |
| **Tilesets principaux** | First_Core_Location | Altere_Pond | Mount_Windswept + TemporalPinnacle |
| **Nouveaux assets requis** | ❌ Aucun | ❌ Aucun | ❌ Aucun |
| **Musique** | Anima Core.ogg | Deep Dark Crater.ogg | Sky Peak Cave/Prairie.ogg |
| **Clé narrative** | Apprendre à protéger les Cœurs | Les ennemis ne sont pas tous des boss | Premier contact avec Necrozma |
| **Durée estimée** | ~45 min | ~50 min | ~55 min |

---

## 🎯 PROCHAINES ÉTAPES

1. ✅ Conception narrative et faune — **FAIT**
2. ⬜ Créer les fichiers `Data/Zone/crystal_sanctuary.json`, `forgotten_marsh.json`, `celestial_peak.json`
3. ⬜ Créer les scripts `Data/Script/halcyon/zone/*/init.lua` pour chaque zone
4. ⬜ Créer les `.rsground` d'entrée avec Pillow (composition des tilesets existants)
5. ⬜ Ajouter les flags SV dans `scriptvars.lua` (SV.Chapter8, SV.Chapter9, SV.Chapter10)
6. ⬜ Créer les dialogues Metano Town `metano_town_ch_8.lua`, `_ch_9.lua`, `_ch_10.lua`
7. ⬜ Intégrer les rencontres `dungeon_life.lua` pour chaque zone
8. ⬜ Créer les cinématiques Title Card / Pré-boss
