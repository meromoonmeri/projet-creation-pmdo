# AUDIT INTÉGRAL — PNJ de Metano Town
## Personnalités, relations, fils narratifs existants (Chapitres 1-7)
### New Era: Abyss to Ascension — 2026-07-26

---

## 📊 SYNTHÈSE QUANTITATIVE

| Chapitre | Fichier | Lignes | Fonctions Action | Clés RESX |
|----------|---------|--------|-----------------|-----------|
| Ch1 | metano_town_ch_1.lua | 523 | 0 (cutscenes only) | 44 |
| Ch2 | metano_town_ch_2.lua | 1431 | 32 | 152 |
| Ch3 | metano_town_ch_3.lua | 1380 | 29 | 150 |
| Ch4 | metano_town_ch_4.lua | 945 | 29 | 116 |
| Ch5 | metano_town_ch_5.lua | 352 | 22 | 40 |
| Ch6 | metano_town_ch_6.lua | 815 | 47 | 100 |
| Ch7 | metano_town_ch_7.lua | 1102 | 54 | 113 |
| **TOTAL** | | **6548** | **213** | **715** |

**55 PNJ distincts identifiés.** Chaque PNJ dispatché via `init.lua:assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".NomPNJ_Action(...,...)")))`.

**Système de jours** : `SV.ChapterProgression.DaysPassed` incrémenté par `GeneralFunctions.EndOfDay()` (GeneralFunctions.lua:54-55). Appelé depuis `guild_heros_room_ch_*.lua` et `first_core_location_ch_3.lua`.

---

## 🧬 1. CLASSIFICATION DES 55 PNJ

### 1.1 PNJ PRINCIPAUX — Membres de la Guilde (11)
| PNJ | Espèce | Rôle | Présent depuis | Traits de personnalité | Relations clés |
|-----|--------|------|---------------|----------------------|----------------|
| **Phileas** | Noctowl | Chef adjoint, sage | Ch1 | Mystérieux, paternel, porteur de la Genèse | Penticus, Héros |
| **Penticus** | Tropius | Chef de la guilde | Ch2 | Enthousiaste, fier, protecteur | Phileas, Hyko (Growlithe) |
| **Rin** | Audino | Infirmière, Assemblée | Ch1 | Maternelle, anxieuse, dévouée | Toute la guilde |
| **Coco** | Snubbull | Stand Kecleon Shop | Ch3 | Bavarde, enthousiaste, commère | Clients du shop |
| **Almotz** | Zigzagoon | Membre guilde, aventurier | Ch3 | Fier, loyal, famille unie | Famille Zigzagoon |
| **Ganlon** | Cranidos | Membre guilde, grognon | Ch2 | Râleur au cœur tendre, protecteur envers Shuca | Shuca (Mareep), Machamp |
| **Shuca** | Mareep | Membre guilde, enthousiaste | Ch2 | Joyeuse, énergique, optimiste | Ganlon (Cranidos) |
| **Hyko** | Growlithe | Réceptionniste guilde | Ch2 | Sérieux, loyal, informateur | Penticus, Phileas |
| **Lotus** | Ledian | Maître du Dojo | Ch2 | Disciplinée, encourageante, mentor | Élèves du dojo |
| **Zhayn** | Bisharp | Chef de la police | Ch7 | Sérieux, protecteur, laconique | Sécurité de Metano |
| **Erleuchtet** | Relicanth | Sage ancien | Ch4 | Mystique, calme, gardien du savoir | Phileas, Héros |

### 1.2 PNJ SECONDAIRES — Familles et riverains (17)
| PNJ | Espèce | Rôle | Présent depuis | Traits | Relations |
|-----|--------|------|---------------|--------|-----------|
| **Savran** | Machamp | Garde/pompier, père | Ch2 | Fier, bruyant, protecteur | Medicham (femme), Meditite (fille) |
| **Garish** | Medicham | Méditante, mère | Ch3 | Calme, sage, spirituelle | Machamp (mari), Meditite (fille) |
| **Meditite** | Meditite | Enfant, apprentie méditation | Ch2 | Timide, veut jouer avec les autres | Machamp (père), Medicham (mère) |
| **Monna** | Nidoqueen | Mère protectrice | Ch3 | Maternelle, inquiète | Nidoking (mari), Nidorina (fille), Nidoran_M (fils) |
| **Nidoking** | Nidoking | Père, aubergiste | Ch3 | Fier, chaleureux, entrepreneur | Nidoqueen (femme), Nidorina, Nidoran_M |
| **Dottir** | Nidorina | Fille, admire les héros | Ch2 | Admire l'équipe, veut devenir forte | Nidoking (père), Nidoqueen (mère) |
| **Nidoran_M** | Nidoran ♂ | Fils, fier mais timide | Ch6 | Admire sa sœur et les héros | Nidorina (sœur), Nidoking, Nidoqueen |
| **Bogen** | Vileplume | Fleuriste | Ch2 | Inquiet pour ses plantes, sensible | Bellossom, Gloom, Oddish |
| **Bellossom** | Bellossom | Jardinière joyeuse | Ch2 | Optimiste, aime la nature | Vileplume, Gloom, Oddish |
| **Gloom** | Gloom | Enfant/champion d'Oddish | Ch2 | Naïf, enthousiaste, baveux | Vileplume, Oddish, Bellossom |
| **Oddish** | Oddish | Enfant, ami de Numel | Ch2 | Joueuse, loyale | Numel, Gloom, Vileplume |
| **Numel** | Numel | Enfant rebelle, fugueur Ch2 | Ch2 | Râleur, déteste les corvées, impulsif | Camerupt (mère), Oddish |
| **Mère Numel** | Camerupt | Mère célibataire | Ch3 | Inquiète, reconnaissante | Numel (fils) |
| **Trilec** | Electrike | Sensible aux énergies | Ch2 | Détecte les anomalies, nerveux | Manectric, jumeaux Wooper |
| **Manectric** | Manectric | Protecteur, père ? | Ch3 | Calme, observateur | Electrike |
| **Tweed** | Floatzel | Pêcheur | Ch2 | Observateur, pratique, aime pêcher | Rivière, Quagsire |
| **Maris** | Quagsire | Gardienne de l'étang | Ch2 | Placide, laconique, profonde | Floatzel (mari ?), puits |

### 1.3 PNJ SECONDAIRES — Habitués du Café/Village (12)
| PNJ | Espèce | Rôle | Présent depuis | Traits | Relations |
|-----|--------|------|---------------|--------|-----------|
| **Boosmu** | Gulpin | Gourmand, client café | Ch2 | Obsédé par la nourriture, expressif | Lickitung, Café |
| **Urgil** | Lickitung | Gourmet, client café | Ch2 | Raffiné, quotidien au café | Gulpin, Café |
| **Bria** | Mawile | Commère du village | Ch2 | Potins, expressive, théâtrale | Tout le monde |
| **Almotz Sr.** | Furret | Dormeur professionnel | Ch2 | Nonchalant, aime dormir | Linoone, Sentret |
| **Linoone** | Linoone | Lecteur, calme | Ch3 | Intellectuel, aime lire au bord de l'eau | Furret, Sentret |
| **Sentret** | Sentret | Jeune joueur | Ch2 | Joue avec les autres enfants | Wooper, Oddish, Numel |
| **Dun** | Wooper ♀ | Jumelle, Dee | Ch2 | Joueuse, cache-cache | Dee (Wooper ♂), Electrike |
| **Dee** | Wooper ♂ | Jumeau, Dun | Ch2 | Compétiteur, cache-cache | Dun (Wooper ♀), Electrike |
| **Loaf** | Azumarill | Campeuse, tente | Ch2 | Accueillante, nomade | Voyageurs |
| **Roselia** | Roselia | Apricorn-maniaque | Ch4 | Obsédée par les Apricorns | Apricorn Grove |
| **Spinda** | Spinda | Danseur, futur café ? | Ch2 | Jongleur, énergique | Ludicolo |
| **Ludicolo** | Ludicolo | Musicien/danseur | Ch2 | Festif, joyeux | Spinda |

### 1.4 PNJ MINEURS — Figurants avec dialogues (8)
| PNJ | Espèce | Rôle | Présent depuis | Traits |
|-----|--------|------|---------------|--------|
| **Jigglypuff** | Rondoudou | Chanteuse | Ch2 | Inquiète des disparitions, douce |
| **Marill** | Marill | Aide, trop petit pour aider | Ch2 | Se sent impuissant, veut aider |
| **Spheal** | Spheal | Gourmand, roule | Ch2 | Obsédé par la nourriture |
| **Bagon** | Bagon | Rêveur, veut voler | Ch4 | Ambitieux, admiratif |
| **Doduo** | Doduo | Coureur, commère | Ch4 | Rapide, bavard |
| **Metapod** | Chrysacier | Statue vivante | Ch5 | Immobile, mystérieux |
| **Silcoon** | Armulys | Commère | Ch5 | Bavard, informateur |

### 1.5 PNJ SPÉCIAUX — Équipes Rivales (6)
| PNJ | Équipe | Rôle | Présent depuis | Traits |
|-----|--------|------|---------------|--------|
| **Adagio** | Team Dazzling | Leader, Tsareena | Ch6 | Sérieuse, respectueuse, observatrice |
| **Aria** | Team Dazzling | Membre, Lopunny | Ch6 | Taquine, teste les héros physiquement |
| **Sonata** | Team Dazzling | Membre, Mawile | Ch6 | Farceuse, cache des objets en ville |
| **Papilusion** | Guilde | Mère de Chenipent | Ch6 | Inquiète, reconnaissante |
| **Chenipent** | Guilde | Enfant sauvé | Ch6 | Admire les héros |

### 1.6 MARCHANDS (8) — Boutiques fixes
| PNJ | Espèce | Boutique |
|-----|--------|----------|
| **Kecleon (Vert)** | Kecleon | Shop (nourriture, objets) |
| **Kecleon (Violet)** | Kecleon | TM Shop |
| **Kangourex** | Kangaskhan | Stockage |
| **Murkrow** | Cornèbre | Banque |
| **Sneasel** | Farfuret | Appraisal (coffres) |
| **Slowpoke** | Ramoloss | Move Tutor |
| **Stunky** | Moufouette | Red Merchant |
| **Farfetch'd** | Canarticho | Green Merchant |

---

## 🔍 2. FILS NARRATIFS EXISTANTS (à ne pas contredire)

### 2.1 Arc Numel/Camerupt — Fugue et sauvetage (Ch2-3)
- **Ch2** : Numel déteste les corvées (« Corvées stupides... je déteste ramasser du bois. Ça pue. »), fugue. Camerupt (mère célibataire) panique. Mission Ch2 = sauver Numel dans Illuminant Riverbed.
- **Ch3** : Numel sauvé, Camerupt éternellement reconnaissante (« Je ne peux toujours pas vous remercier assez pour avoir sauvé mon petit garçon ! »). Luxray critique l'absence de punition. Numel veut jouer au tag.
- **POST-Ch3** : Camerupt apparaît seulement Ch3,6,7. Numel présent tous les chapitres.

### 2.2 Famille Machamp/Medicham/Meditite (Ch2-7)
- **Ch2** : Meditite médite (ou essaie). Machamp mentionne l'enfant disparu.
- **Ch3** : Medicham médite à nouveau grâce au sauvetage de Numel. Machamp et Medicham ont une dispute sur la boîte aux lettres — « Garish est cette boîte aux lettres qui chérit mon mari » — Medicham n'aime pas l'obsession de Machamp pour le courrier.
- **Ch4** : « Hoohoo ! Je suis heureux que vous puissiez comprendre pourquoi j'aime la boîte aux lettres, très chère ! » — réconciliation ou ironie.
- **Meditite** : « J'aimerais pouvoir jouer avec les autres enfants. » → enfant timide, élevée strictement.

### 2.3 Famille Nidoking/Nidoqueen (Ch3-7)
- **Nidoking** : Aubergiste (« Rendez-vous au Metano Inn pour le meilleur bed and breakfast ! »), fier de l'équipe.
- **Nidoqueen** : Mère protectrice (« Une mère s'inquiète toujours. Même pour les enfants des autres. »)
- **Nidorina** : Admire les héros (« Papa dit que vous êtes les plus forts ! »), frustrée d'être enfermée.
- **Nidoran ♂** : Apparaît Ch6+, admire sa sœur et les héros (« Ma soeur dit que vous etes ses heros. Moi aussi je le pense. »)

### 2.4 Jumeaux Wooper + Electrike (Ch2-7)
- **Ch2** : Introduction des jumeaux Dee et Dun. Electrike stresse (« Help. Me. ») parce qu'ils sont turbulents.
- **Ch3-4** : Cache-cache permanent. Dun se vante, Dee trouve de meilleures cachettes.
- **Electrike** : sensible aux énergies/perturbations, rôle de détecteur narratif (« L'énergie dans l'air est bizarre aujourd'hui. »)

### 2.5 Lickitung & Gulpin — Le duo du Café (Ch2-7)
- **Ch2** : Café fermé → Lickitung triste, Gulpin paniqué.
- **Ch3+** : Café ouvert, Gulpin commente la nourriture, Lickitung y va « tous les jours ».
- **Relation** : Amis inséparables, liés par l'amour de la nourriture.

### 2.6 Furret/Linoone/Sentret — La famille furet (Ch2-7)
- **Furret** : Dormeur (« Aaah... C'est mon endroit préféré pour dormir ~ »)
- **Linoone** : Lecteur calme au bord de la rivière, lit des livres recommandés.
- **Sentret** : Enfant joueur, ami des autres enfants.
- **Lien** : Possiblement une famille élargie (père/mère/enfant ou frères/sœurs).

### 2.7 Mawile — La commère (Ch2-7)
- Présente dans TOUS les chapitres. Rôle de « radio du village ».
- Colporte les rumeurs, s'enthousiasme, fait semblant de savoir.
- « Je le savais ! Enfin, non, pas du tout, mais je vais faire comme si ! »

### 2.8 Floatzel & Quagsire — Le couple de l'eau (Ch2-7)
- **Floatzel** : Pêcheur, guide du puits à souhaits. Observe les changements dans la rivière.
- **Quagsire** : Gardienne placide de l'étang. Une seule ligne mais profonde.
- **Lien** : Mari/femme probable (Quagsire dit « my husband » — pas encore apparu en français).

### 2.9 Spinda & Ludicolo — Le duo festif (Ch2-7)
- Dansent, jonglent, mettent l'ambiance. Pas encore de café attitré (Ch2-4).
- Spinda : futur tenancier du Café (devient ouvert Ch3).
- Ludicolo : « Yah ! C'est le meilleur endroit en ville pour danser ! »

### 2.10 Team Dazzling — Rivales respectées (Ch6-7)
- **Adagio** (Tsareena) : Leader, distante mais respectueuse. « Vous avez gagné notre attention. C'est rare. »
- **Aria** (Lopunny) : Taquine, teste physiquement. « Vous n'êtes pas si mauvais. Pour des débutants. »
- **Sonata** (Mawile) : Farceuse. « J'ai caché quelque chose en ville. Bonne chance pour le trouver ! »

### 2.11 Luxray — Chef officieux de la sécurité (Ch2-7)
- Apparaît Ch2 (alerte disparition Numel), critique l'absence de punition Ch3.
- Dialogue sec et autoritaire. Respecte la force.
- Probable futur chef de l'Escouade Fulgur (arc concurrent).

---

## 🎯 3. PNJ ÉLIGIBLES POUR ROUTINE DE DÉPLACEMENT (non-marchands)

### Priorité HAUTE (déjà une vie personnelle à développer)
| PNJ | Routine proposée | Pourquoi |
|-----|-----------------|----------|
| **Numel** | Matin: corvées (bois) → Jour: jeu avec Oddish → Soir: maison | Arc fugue à faire évoluer |
| **Oddish** | Matin: jardinage Vileplume → Jour: jeu avec Numel → Soir: maison | Ami loyal de Numel |
| **Meditite** | Matin: méditation → Jour: dojo → Soir: tentative de jouer avec les autres | Enfant timide, veut s'intégrer |
| **Wooper_Dee** | Matin: rivière → Jour: cache-cache (lieux variables) → Soir: maison | Cache-cache perpétuel |
| **Wooper_Dun** | Matin: rivière → Jour: cherche Dee → Soir: maison | Compétition fraternelle |
| **Electrike** | Matin: patrouille → Jour: suit les Wooper → Soir: poste de garde | Baby-sitter forcé |
| **Furret** | Matin: dort → Jour: change de spot de sieste → Soir: rentre | Dormeur nomade |
| **Linoone** | Matin: marché → Jour: lit au bord de l'eau → Soir: auberge | Routinier calme |
| **Sentret** | Matin: école/dojo → Jour: jeu avec enfants → Soir: maison | Enfant sociable |
| **Mawile** | Matin: marché → Jour: fontaine ( ragots) → Soir: tente | Circuit de commérage |
| **Floatzel** | Matin: pêche → Jour: rivière → Soir: étang avec Quagsire | Pêcheur |
| **Nidorina** | Matin: maison → Jour: guilde (admire héros) → Soir: maison | Groupie de l'équipe |
| **Roselia** | Matin: jardin → Jour: marché → Soir: tente | Apricorn-maniaque |
| **Bagon** | Matin: dojo → Jour: falaise (rêve de voler) → Soir: auberge | Rêveur |

### Priorité MOYENNE
| PNJ | Routine proposée |
|-----|-----------------|
| **Gloom** | Suit Vileplume/Bellossom, bave |
| **Bellossom** | Jardine, danse parmi les fleurs |
| **Nidoran_M** | Suit Nidorina |
| **Doduo** | Court entre marché et guilde |
| **Jigglypuff** | Chante près du puits le soir |
| **Marill** | Joue près de l'eau, frustré de ne pas aider |
| **Spheal** | Roule entre café et puits |
| **Ludicolo** | Danse à la fontaine |
| **Spinda** | Alterne entre jonglage et café |
| **Bagon** | Grimpe la falaise, rêve de voler |
| **Metapod** | Fixe — toujours au même endroit mais change d'orientation |
| **Silcoon** | Bavarde avec les passants |

---

## 🏪 4. MARCHANDS — Plan de développement narratif

### Kecleon Vert (Shop)
- **Actuel** : Dialogue purement transactionnel.
- **Plan** : Ch8+ : commente les événements récents de la ville, s'inquiète pour ses fournisseurs, évoque des « clients étranges ».

### Kecleon Violet (TM Shop)
- **Actuel** : Transactionnel.
- **Plan** : Mentionne des TMs rares trouvées près des zones corrompues (nouveaux TMs débloqués par événements).

### Kangourex (Stockage)
- **Actuel** : Transactionnel + checkpoint donjons.
- **Plan** : Ch8+ : s'inquiète pour « ses petits » (statues Kangourex dans les donjons), dialogue sur la sécurité des checkpoints.

### Cornèbre (Banque)
- **Plan** : Rumeurs sur l'économie, les clients riches, les voleurs.

### Farfuret (Appraisal)
- **Plan** : Curieuse des artefacts trouvés dans les ruines, contexte archéologique.

### Canarticho (Green Merchant)
- **Plan** : Rivalité avec Stunky (Red Merchant) à développer en micro-intrigue.

### Moufouette (Red Merchant)
- **Plan** : Essaie de prouver qu'il est meilleur que Farfetch'd, humour.

---

## 🤝 5. PNJ CANDIDATS POUR INTERACTION INITIÉE

### 5.1 MISSIONS PERSONNELLES

| PNJ | Contexte | Type | Développement |
|-----|----------|------|---------------|
| **Camerupt** | Numel fugue encore — cette fois vers un donjon dangereux | Mission sauvetage | Arc Numel Ch8 — il fugue vers le Sanctuaire de Cristal, veut « prouver qu'il est fort » |
| **Machamp** | Sa boîte aux lettres a été vandalisée | Mission enquête | Mini-intrigue rivalité Machamp/Medicham, le coupable est... Sentret qui voulait jouer |
| **Medicham** | Demande au héros de parler à Meditite qui refuse de méditer | Quête sociale | Meditite veut être une aventurière, pas une méditante |
| **Nidorina** | Veut prouver à ses parents qu'elle peut se débrouiller seule | Mission exploration | Part en solo dans un donjon facile, le héros la suit discrètement |
| **Linoone** | A perdu un livre rare emprunté à Relicanth | Mission récupération | Le livre est dans les ruines ou le marais |
| **Floatzel** | La rivière est empoisonnée, les poissons meurent | Mission enquête | Lié à la corruption des Cœurs |
| **Electrike** | « Quelque chose » rôde autour du village la nuit | Mission investigation | Préfiguration Cercle du Suaire |
| **Mawile** | Veut une interview exclusive sur la dernière mission du héros | Quête sociale | Drôle, méta — elle écrit un journal du village |

### 5.2 DEMANDES D'AVANCE (prêt)

| PNJ | Demande | Remboursement | Effet relation |
|-----|---------|--------------|----------------|
| **Camerupt** | 500 Pokés pour acheter des baies | Remercie + donne Baie Rare au Ch suivant | Proximité, elle cuisine pour le héros |
| **Lickitung** | 300 Pokés — le café a augmenté ses prix | Rembourse au Ch suivant | Gratitude, offre un plat spécial |
| **Spinda** | Un objet rare pour son spectacle | Rend l'objet (utilisé) + spectacle privé | Devient ami proche |
| **Bagon** | 200 Pokés pour s'acheter des « ailes mécaniques » (arnaque) | Ne rembourse pas mais réalise que c'était une arnaque | Leçon de vie, Bagon mûrit |

### 5.3 SOUCIS PERSONNELS RÉCURRENTS (arcs multi-chapitres)

| PNJ | Souci | Développement | Arc |
|-----|-------|--------------|-----|
| **Meditite** | Ne veut pas être méditante comme sa mère | Ch8: fugue du dojo → Ch9: le héros l'aide à parler à ses parents → Ch10: compromis (elle médite + s'entraîne) | 3 chapitres |
| **Numel** | Sentiment d'infériorité, veut prouver sa valeur | Ch8: fugue → Ch9: sauvé mais blessé → Ch10: accepte de l'aide, devient apprenti chez Machamp | 3 chapitres |
| **Wooper (Dun)** | Jalousie que Dee soit meilleure à cache-cache | Ch9-10: compétition qui dégénère, le héros arbitre | 2 chapitres |
| **Floatzel & Quagsire** | Dispute conjugale — Floatzel pêche trop, Quagsire se sent délaissée | Ch10-11: médiation, réconciliation | 2 chapitres |
| **Mawile** | Se sent seule — personne ne prend ses ragots au sérieux | Ch9-11: le héros l'écoute → elle découvre un VRAI scoop (Cercle du Suaire) → devient informatrice crédible | 3 chapitres |

---

## 🛠️ 6. CONTRAINTES TECHNIQUES

### Système de jours existant
```lua
-- GeneralFunctions.lua:54
function GeneralFunctions.EndOfDay()
    SV.ChapterProgression.DaysPassed = SV.ChapterProgression.DaysPassed + 1
    -- Reset daily flags...
end
```
Incrémenté depuis `guild_heros_room_ch_*.lua` au moment du coucher.

### Système de déplacement PNJ existant dans le projet
```lua
-- init.lua:114 — AI par défaut pour les PNJ
AI:SetCharacterAI(chara, "halcyon.ai.ground_default",
    RogueElements.Loc(x, y),  -- Top-left wander area
    RogueElements.Loc(w, h),  -- Size of wander area
    1,    -- Speed
    16,   -- Min move distance
    32,   -- Max move distance
    40,   -- Min idle delay
    180)  -- Max idle delay

-- Pattern utilisé Ch6 pour les PNJ marchant
AI:SetCharacterAI(mawile, "halcyon.ai.ground_default", ...)
AI:SetCharacterAI(floatzel, "halcyon.ai.ground_default", ...)
AI:SetCharacterAI(quagsire, "halcyon.ai.ground_default", ...)
```

### Déplacement visible vs téléportation
```lua
-- init.lua — MoveTo (animation visible)
GROUND:MoveToPosition(chara, targetX, targetY, false, speed)
-- Vs Teleport (instantané)
GROUND:TeleportTo(chara, x, y, direction)
```

### Intervalles temporels simulés (matin/jour/soir)
Le projet n'a pas de cycle jour/nuit natif — l'heure est déterminée par les flags `SV.TemporaryFlags.Dinnertime`, `Bedtime`, `MorningWakeup`, `MorningAddress`. Le « moment de la journée » est contrôlé par le script, pas par une horloge. Une routine « matin/jour/soir » doit être implémentée via des flags custom.

---

## 📋 7. CHECK-LIST AVANT IMPLÉMENTATION

- [x] Audit de tous les dialogues existants — 55 PNJ cartographiés
- [x] Identification des fils narratifs existants — 11 arcs identifiés
- [x] Vérification du système de jours — `SV.ChapterProgression.DaysPassed`
- [x] Vérification des fonctions de déplacement — `AI:SetCharacterAI`, `GROUND:MoveToPosition`
- [ ] Validation du plan de routine par l'utilisateur avant implémentation
- [ ] Création des flags `SV.NPCRoutines` dans scriptvars.lua
- [ ] Implémentation progressive PNJ par PNJ
- [ ] Test : pas de PNJ bloqué, pas de duplicat, dialogues cohérents jour/état

---

*Audit réalisé sur 6548 lignes de dialogues (Ch1-7), 213 fonctions Action, 715 clés RESX.*
*Projet New Era: Abyss to Ascension V4 — Arena Agent, 2026-07-26*
