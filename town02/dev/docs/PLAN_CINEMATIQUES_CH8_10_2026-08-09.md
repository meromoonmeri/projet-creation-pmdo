# PLAN DE CONCEPTION — CINÉMATIQUES CHAPITRES 8-10 (vers +7k dialogues)

**Date : 2026-08-09 — Branche `arena/019fd882-new-era-abyss-to-ascension-v4`.**
Objectif : porter les chapitres 8, 9, 10 (actuellement ~220/210/170 dialogues) vers une densité
comparable aux ch6-7 (~2800/2900), en **créant des cinématiques logiques à la narration** et en
**enrichissant qualitativement** l'existant, selon le `CUTSCENE_QUALITY_STANDARD`.

---

## 1. DIAGNOSTIC (mesuré sur la branche)

| Chapitre | Dialogues | Ce qui existe | Ce qui MANQUE |
|---|---|---|---|
| **ch6** | ~2800 | riche (Forêt Lugubre, Zarude, ville) | — (bonne base) |
| **ch7** | ~2900 | riche (Ruines Tordues/Regigigas, ville) | — (bonne base) |
| **ch8** | ~220 | arrivée (CrystalArrival), afterboss (CrystalVictory), ville MT8, veillée | **relais, miniboss (Carbink+Froslass), boss Diancie, scènes de guilde** |
| **ch9** | ~210 | arrivée (MarshArrival), relais (DuoArrival), miniboss (Avaltout+Coatox), afterboss (MarshVictory), ville MT9 | **boss Mega-Blastoise, rencontre Cercle du Suaire, dispute Floatzel, retour** |
| **ch10** | ~170 | arrivée (PeakArrival), tour (PeakTowerReveal), afterboss (PeakVictory), ville MT10 | **relais, Escouade Fulgur, boss Lugia, vision Necrozma, retour** |

**Cause racine** : les rsmap relais/miniboss/boss des ch8-10 n'ont **aucun `OnMapStarts`** → les
arènes se jouent sans mise en scène. Le pattern existe déjà (cloven_ruins : `MapEffectStep` +
`SingleCharScriptEvent` → `SINGLE_CHAR_SCRIPT.X`).

---

## 2. GRAMMAIRE COMMUNE (appliquée à toutes les scènes)

1. **Le lieu avant les personnages** : musique + cadrage du décor, puis le duo parle.
2. **Dialogue en 3 temps** : constat sensoriel → réaction affective → décision.
3. **Caméra qui cadre le sujet du discours** (décor puis duo).
4. **Personnages actifs** : déplacements, orientations selon la position réelle, émotes, réactions.
5. **Apparition jamais instantanée** : le boss se manifeste (éveil, lumière, brume) avant de parler.
6. **Registre distinct par chapitre** : ch8 contemplation/émerveillement · ch9 malaise/peur ·
   ch10 urgence/rivalité.
7. **Tout sous pcall** (sortie garantie), héros muet à voix haute (pensées), la Voix rare.

---

## 3. CHAPITRE 8 — LE SANCTUAIRE DE CRISTAL (Diancie) — 3 scènes à créer

Registre : **l'émerveillement qui inquiète**. Silence, lumière, beauté trop parfaite.

| Scène | Où (hook) | Contenu |
|---|---|---|
| **8.1 Relais du Sanctuaire** | `waterfall_pond` seg1 (crystal_sanctuary_relay) OnMapStarts | Le duo émerge du rideau d'eau dans la salle des reliques. Kangourex les accueille. Contemplation des cristaux, lecture d'un fragment de savoir laissé par les premiers gardiens (« la lumière qui bat = un cœur qui se noie »). Décision : continuer. |
| **8.2 Miniboss — Strassie & Momartik** | seg3 (crystal_sanctuary_miniboss) OnMapStarts | Les deux gardiens de cristal se réveillent (éveil dans la lumière). Ils parlent de leur serment (« nous gardons ce que la lumière ne doit pas voir »). Combat. Après : réaction du duo, soupçon sur Diancie. |
| **8.3 Boss — Diancie** | seg5 (crystal_sanctuary_boss) OnMapStarts | La salle du trône de cristal. Diancie se révèle (émergence de lumière), parle de son rôle de gardienne du Cœur d'Anima, de sa peur que le monde l'oublie. Le duo doit la convaincre qu'ils ne viennent pas voler mais sauver. Combat. |

Enrichissements (en plus) : scène de **préparation à la guilde** (briefing Phileas/Penticus avant le
donjon), scène de **retour** après le fragment (Metano célèbre), enrichissement de la **veillée**.

---

## 4. CHAPITRE 9 — LE MARAIS DE L'OUBLI (Mega-Blastoise + Cercle du Suaire) — 3 scènes à créer

Registre : **le dégoût, puis la peur**. Odeur, vase, présence qui a déjà traversé le lieu.

| Scène | Où (hook) | Contenu |
|---|---|---|
| **9.1 Rencontre — Cercle du Suaire** | seg4 (avant le boss) / ground | Au fond des abysses vaseux, le duo **voit** le Cercle du Suaire (Banette, Ectoplasma, Nostenfer) autour du Cœur qui se noie. Ils ne se battent pas : ils s'effacent, laissant une phrase (« On ne tue pas un cœur. On le laisse se vider. »). Le duo comprend que la menace est plus grande qu'un monstre. |
| **9.2 Boss — Mega-Blastoise** | seg5 (forgotten_marsh_boss) OnMapStarts | Le gardien du marais émerge de la vase (éveil dans la boue). Il protège le Cœur noyé, persuadé que l'éteindre est la seule paix. Le duo doit le convaincre que le Cœur peut revivre. Combat. |
| **9.3 Dispute Floatzel** | ground (retour / ville) | Résolution de la dispute annoncée par `FloatzelDisputeResolved` : deux PNJ qui s'accusent mutuellement de la noyade du Cœur ; le duo arbitre, révélant que c'est le Suaire qui a tari la source. |

Enrichissements : scène d'**arrivée au relais** enrichie (l'eau qui monte), scène de **retour** (la
ville apprend la vérité sur le Suaire), enrichissement de la **veillée**.

---

## 5. CHAPITRE 10 — LE PIC CÉLESTE (Lugia + Rayquaza + vision Necrozma) — 3 scènes à créer

Registre : **l'urgence et la rivalité**. Vent, course, trois dragons qui gardent la voie.

| Scène | Où (hook) | Contenu |
|---|---|---|
| **10.1 Relais des Nuages** | `sky_tower` seg1 (palier_celeste) OnMapStarts | Le duo atteint le palier entre les nuages. L'Escouade Fulgur est arrivée première (rivalité). Échange tendu : ils se toisent, Fulgur prétend que le duo « n'a plus rien à prouver » mais qu'ils n'ont pas leur place au sommet. Trêve forcée par le danger commun. |
| **10.2 Boss — Lugia** | seg5 (tour_ciel_sommet) OnMapStarts | (Le climax existe déjà : ChapterAftermath.PeakVictory = acte 1 Lugia, acte 2 Rayquaza/météorite.) À enrichir : l'arrivée de Lugia au-dessus des nuages (DescendSky), son jugement du duo et de l'Escouade Fulgur, la discussion post-combat (« Cherchez sous l'écaille »). |
| **10.3 Vision — Necrozma** | ground (après le boss / rêve) | `SawNecrozmaVision` : dans le rêve, le héros voit la chute d'Ultra-Necrozma et la silhouette prismatique enchaînée — premier fragment du twist Eternatus (préparé dès l'arc 2 par les rêves). |

Enrichissements : scène de **préparation** (la ville panique, le ciel parle), scène de **retour
triomphal** (Metano réalise), enrichissement de la **veillée**.

---

## 6. MÉTHODE D'IMPLÉMENTATION

1. **Module `halcyon/Ch6_10Scenes.lua`** : fonctions `SINGLE_CHAR_SCRIPT.Ch8_*`, `Ch9_*`, `Ch10_*`
   (OnMapStarts), utilisant `DonjonFX` (Recit/Dire/Penser/VoixGardien/RegarderVers) + `BossFX`
   (apparitions) + `GeneralFunctions` (déplacements). Texte par clés `CH8_*`/`CH9_*`/`CH10_*`.
2. **Clés ajoutées** dans `Strings/stringsEx.fr.resx` + `stringsEx.resx` (même endroit que RUINES_*).
3. **`main.lua`** : `require 'halcyon.Ch6_10Scenes'`.
4. **Branchement** : `MapEffectStep` + `OnMapStarts` (SingleCharScriptEvent) dans
   `waterfall_pond.json` (seg1/3/5), `poisonous_forest.json` (seg5), `sky_tower.json` (seg1/5).
5. **Enrichissement** des scènes de ville (MT8/MT9/MT10) et des veillées : nouvelles clés + dialogues.
6. Audit de syntaxe (lupa), vérification des clés remplies, push.

## 7. ORDRE DE LIVRAISON

1. Lot A : ch8 (relais + miniboss + boss Diancie) — le plus manquant.
2. Lot B : ch9 (Suaire + boss + dispute Floatzel).
3. Lot C : ch10 (relais Fulgur + vision Necrozma + enrichissement Lugia).
4. Enrichissements transverses (veillées, retours, guilde).

Chaque lot : module + textes + branchement + audit + commit + push.
