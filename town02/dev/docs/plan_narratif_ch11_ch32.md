# Plan narratif complet — chapitres 11 à 32

> **Structure avant rédaction.** La consigne impose : *« Avant de commencer la
> rédaction, établis toute la structure narrative. »* Ce document est cette
> structure. **Aucune ligne de dialogue n'a été écrite, aucun script modifié.**
>
> **Rien n'est testé en jeu.** Tout constat technique ci-dessous est vérifié par
> lecture des données du dépôt.

---

## 1. Audit de l'existant — ce sur quoi ce plan s'appuie

### 1.1 Ce qui existe déjà (et que je ne réinvente pas)

L'audit a révélé que la trame **est déjà posée jusqu'au ch32**, dans
`docs/04_trame_arc1.md`. Mon mandat n'est donc pas de créer une trame, mais de
**détailler les arcs 3 à 6 restés à l'état de squelette**.

| Arc | Ch. | Titre | État réel |
|---|---|---|---|
| 1 | 1-6 | Les Braises de Metano | **détaillé + implémenté** |
| 2 | 7-12 | Les Cœurs qui s'éteignent | détaillé (`arc2_ce_que_la_brume_emporte.md`), ch7-10 implémentés |
| 3 | 13-17 | La Lumière dévorée | **squelette seul** → à détailler |
| 4 | 18-23 | L'Abîme ouvert | **squelette seul** → à détailler |
| 5 | 24-28 | Ascension brisée | **squelette seul** → à détailler |
| 6 | 29-32 | Le Cœur du Vide | **squelette seul** → à détailler |

**Le twist final est déjà canon** et ne doit pas être modifié : la lumière des
Cœurs n'est pas la vie du monde mais **le sceau d'Eternatus**. Chaque Cœur
« sauvé » naïvement a affaibli ce sceau. Necrozma ne volait pas la lumière — il
la **scellait**.

### 1.2 Volumétrie réelle mesurée (`tools/count_dialogue.py`)

| Ch. | Lignes | Cible |
|---|---|---|
| 5 | 1616 | 7000 |
| 6 | 469 | 7000 |
| 7 | 408 | 7000 |
| 8 | 335 | 7000 |
| 9 | 318 | 7000 |
| 10 | 256 | 7000 |

**Constat à assumer franchement** : l'écart est d'un facteur 15 à 27. Les 4000
lignes/chapitre demandées représentent, pour 22 chapitres, environ **88 000
lignes de dialogue**. À titre de comparaison, tout le dépôt actuel en compte
~6 000. Ce plan structure le contenu ; sa rédaction demandera des sessions
dédiées, chapitre par chapitre.

### 1.3 Stock de donjons disponible

- **207 zones** dans `Data/Zone/`, dont **77 non référencées** par les ch1-10.
- Pour 22 chapitres × 3-5 donjons = 66 à 110 donjons requis.
- **Le stock suffit** en réutilisant les zones libres (`new_era_sky_*`,
  `new_era_zone_*`, `imbion_*`), conformément à la règle « réutiliser
  intelligemment les zones existantes plutôt que d'en multiplier ».

### 1.4 Mini-boss — écart constaté avec la règle demandée

Règle exigée : *« Chaque mini-boss doit être un Pokémon évolué, accompagné de ses
pré-évolutions. »*

| Mini-boss | Composition actuelle | Conforme ? |
|---|---|---|
| Tunnel Incandescent **(gabarit)** | Torkoal + Magmar **+ 5 Limagma** | ✅ oui |
| Grande Steppe | Stantler + Mudbray | ❌ paire non apparentée, aucune escorte |
| Mont Venteux | Gligar + Skarmory | ❌ idem |
| Forêt Lugubre | Shiftry + Murkrow | ❌ idem |
| Aegis Cave | Golurk + Claydol | ❌ idem |
| Sanctuaire Cristal | Froslass + Carbink | ❌ idem |
| Marais de l'Oubli | Toxicroak + Swalot | ❌ idem |

**Seul le gabarit est conforme** — ce qui confirme sa valeur de modèle. Les 6
autres sont des paires thématiques sans escorte de lignée.

Correction proposée (à valider, **non appliquée**) — on garde le duo existant et
on lui **ajoute l'escorte de pré-évolutions** qui manque, sur le patron exact du
gabarit :

| Donjon | Évolué (inchangé) | Escorte à ajouter |
|---|---|---|
| Grande Steppe | Stantler | 3 Cerfrousse *(Deerling)* |
| Mont Venteux | Skarmory | 3 Gligar *(Gligar est déjà la pré-évo de Gliscor — inverser : Gliscor + Gligar)* |
| Forêt Lugubre | Shiftry | 2 Nuzleaf + 2 Seedot |
| Aegis Cave | Golurk | 4 Golett |
| Sanctuaire Cristal | Froslass | 3 Snorunt |
| Marais de l'Oubli | Toxicroak | 4 Croagunk |

> Les lignées sont canoniques (le mod ne surcharge que 21 espèces dans
> `Data/Monster/`, le reste vient du jeu de base).

---

## 2. Règle de rythme : 3 à 4 h de jeu par chapitre

Traduction concrète, par chapitre (ch11+) :

| Composant | Volume |
|---|---|
| Donjons | 3 à 5 (dont 1 final à boss) |
| Étages cumulés | 18 à 30 |
| Cinématiques | 10 à 30 selon le poids narratif |
| Dialogues | ~4000 lignes |
| Scènes de vie / respirations | 3 à 5 (ratio 60 drame / 25 comique / 15 contemplatif) |
| Twist | ≥ 1, préparé en amont |

---

## 3. ARC 3 — « La Lumière dévorée » (ch. 13-17)

**Fonction** : Necrozma est nommé. Le joueur croit tenir le coupable. C'est un
piège narratif : tout l'arc construit une certitude que l'arc 5 démolira.

| Ch. | Titre | Enjeu | Donjons | Boss / mini-boss | Twist |
|---|---|---|---|---|---|
| 13 | Le Relevé des Éclats | Phileas cartographie les vols du Suaire ; un motif apparaît | 3 | mini : Nostenfer + Chovsourir | Les vols suivent l'ordre exact des Cœurs — quelqu'un a un plan |
| 14 | Les Yeux d'Or | L'Escouade Fulgur perd un membre dans une faille | 4 | mini : Héliolisk corrompu | Héliolisk revient « changé » : premier corps touché par l'Abîme |
| 15 | Le Nom dans la Pierre | Ruines gravées : le nom de Necrozma apparaît | 4 | boss : gardien de pierre (Regieleki, Ruines Électriques) | Le nom est gravé **par** les bâtisseurs, comme un avertissement |
| 16 | Ce que virent les Anciens | Vision du passé : chute d'Ultra-Necrozma | 3 | mini : Nostenfer + Chovsourir (retour) | Necrozma **tombait**, il n'attaquait pas |
| 17 | La Lumière dévorée | Confrontation directe — le joueur croit vaincre le coupable | 5 | **boss d'arc : Necrozma (forme diminuée)** | Il se laisse faire. Première fissure dans la certitude |

**Foreshadowing payé** : registre des pulses de Phileas (ch5) — « une chose qui
LUTTE, qui s'épuise à tenir quelque chose fermé ». Personne ne l'avait écouté.

**Foreshadowing semé** : la fatigue de Necrozma ; le mot « sceau » prononcé une
fois, par une inscription, sans explication.

---

## 4. ARC 4 — « L'Abîme ouvert » (ch. 18-23)

**Fonction** : le monde se dégrade. Les rivaux deviennent des alliés. Le Cercle
du Suaire révèle son mobile — et il est **cohérent**.

| Ch. | Titre | Enjeu | Donjons | Boss / mini-boss | Twist |
|---|---|---|---|---|---|
| 18 | Les Sauvages | Les Pokémon des donjons deviennent agressifs sans raison | 3 | mini : Ursaring + 3 Teddiursa | L'agressivité suit les zones où un Cœur a été « sauvé » |
| 19 | La Trêve | Fulgur demande de l'aide — Luxray ravale son orgueil | 4 | mini : Lucario (duel d'honneur) | Fulgur avait le même rêve que le héros |
| 20 | Le Suaire démasqué | Banette parle enfin | 4 | boss : Ectoplasma + 2 Spectrum | Ils sont les **descendants des gardiens du sceau** |
| 21 | Ce qu'ils protègent | Le héros comprend leur logique sans l'accepter | 3 | mini : Nostenfer (dernier) | Éteindre les Cœurs affame Eternatus — c'est défendable |
| 22 | La Faille | Une brèche s'ouvre sous Metano | 5 | boss : Zoroark de la brèche | La ville est touchée : l'enjeu devient intime |
| 23 | L'Abîme ouvert | Descente. Le sol du monde se dérobe | 5 | **boss d'arc : Giratina (Monde Miroir)** | Le héros voit le fond de l'Abîme — et quelque chose y respire |

**Enjeu personnel** : la brèche du ch22 menace Metano — la ville que le joueur
habite depuis 22 chapitres. Le danger cesse d'être abstrait.

---

## 5. ARC 5 — « Ascension brisée » (ch. 24-28)

**Fonction** : le retournement. Necrozma n'était pas l'ennemi.

| Ch. | Titre | Enjeu | Donjons | Boss / mini-boss | Twist |
|---|---|---|---|---|---|
| 24 | Le Sommet inversé | Ascension vers Necrozma, cette fois pour parler | 4 | mini : Airmure + 3 Étourmi | Il attendait le héros — il connaît son nom |
| 25 | Ce que je retenais | **Necrozma explique** : il scellait | 3 | aucun (chapitre de dialogue) | Chaque Cœur « sauvé » a desserré le sceau |
| 26 | Le Poids du Bien | Le héros réalise qu'il a causé la catastrophe | 4 | mini : reflet du héros (Zoroark) | Le meilleur ennemi du monde fut sa meilleure intention |
| 27 | Les Gardiens d'Autrefois | Alliance héros + Fulgur + Suaire | 4 | boss : épreuve des trois (Cobalion/Terrakion/Virizion) | Le Suaire avait raison sur le fond, tort sur la méthode |
| 28 | Ascension brisée | Tentative de resceller — échec | 5 | **boss d'arc : Ultra-Necrozma (allié contrôlé)** | Le sceau cède. Eternatus s'éveille |

**Écho verrouillé (bible)** : *« la corniche qui cède — quelqu'un devra rattraper
quelqu'un »*. C'est ici, au ch28, que l'écho se paie : le partenaire rattrape le
héros, exactement comme l'Arcanin hissa Penticus 25 ans plus tôt.

---

## 6. ARC 6 — « Le Cœur du Vide » (ch. 29-32)

| Ch. | Titre | Enjeu | Donjons | Boss | Note |
|---|---|---|---|---|---|
| 29 | Le Monde qui s'éteint | Les Cœurs meurent un à un ; ciel veiné de pourpre | 4 | mini : Drattak + 3 Draby | Compte à rebours visible |
| 30 | Tout ce qui nous reste | Chapitre des adieux **avant** la fin — chacun dit pourquoi il se bat | 3 | aucun | Respiration émotionnelle obligatoire avant le finale |
| 31 | Le Cœur du Vide | Descente finale dans l'Abîme | 5 | **Eternatus (phase 1)** | Abîme de l'Éternité, 7-9 étages |
| 32 | Une Nouvelle Ère | Finale en deux temps | 4 | **Eternatus (phase 2) → Ascension** | Necrozma prête sa lumière |

### 6.1 Structure du chapitre 32

1. **Abîme** — Eternatus, phase 1. Le combat semble perdu.
2. **L'Ascension** — Necrozma, rédempteur, prête sa lumière au héros. Le sceau
   est reforgé non par la lumière volée, mais par la lumière **donnée**.
3. **Le prix** — le héros est le dernier gardien du sceau. Reforger le sceau
   exige qu'il reprenne sa place... c'est-à-dire qu'il quitte ce monde.
4. **La scène d'adieu.**

### 6.2 La scène d'adieu — emblème PMD

C'est la scène que la consigne demande explicitement. Elle n'existe nulle part
dans le dépôt : **entièrement à créer**.

**Ce qui la rend PMD** (relevé sur Rescue Team et Explorers) :

- Le héros **disparaît progressivement**, il ne meurt pas.
- Le partenaire est **seul** au dernier plan, et parle à quelqu'un qui n'est
  déjà plus là.
- La musique s'arrête **avant** la dernière réplique — le silence porte la scène.
- Un objet reste (une écharpe, une pierre) : la preuve matérielle que ce n'était
  pas un rêve.
- **Puis le monde le rend.** Grodoudou l'a dit au ch5 : *« mais le monde le lui
  a rendu. Je choisis toujours cette fin-là. »* — cette réplique, posée 27
  chapitres plus tôt, **est la promesse que le ch32 doit honorer**.

**Découpage proposé** (7 temps) :

| # | Temps | Mise en scène |
|---|---|---|
| 1 | Le sceau tient | Lumière blanche, tout le monde debout, victoire apparente |
| 2 | Le héros comprend | Il regarde ses mains — elles deviennent translucides |
| 3 | Il ne dit rien | Le partenaire comprend avant lui. `EmoteAndPause("Shock")` |
| 4 | Les autres arrivent | Guilde, Fulgur, Suaire — tous témoins, aucun ne peut agir |
| 5 | La dernière réplique | **Musique coupée.** Boîte centrée. Le partenaire seul parle |
| 6 | L'effacement | `DrawEffect.Transparent` → `Absent`, en 3 paliers (patron du rêve de Gardevoir) |
| 7 | L'objet qui reste | Plan fixe long sur l'objet. Écran noir. Titre : *Une Nouvelle Ère* |

**Épilogue (post-générique)** : le monde rend le héros — écho exact de la
promesse de Grodoudou. Réveil, quelque part. Le partenaire court.

---

## 7. Progression des biomes — règle appliquée aux 22 chapitres

*« Plus le joueur s'enfonce, plus les biomes évoluent de manière cohérente. »*

| Arc | Dominante | Dégradé interne au donjon |
|---|---|---|
| 3 (13-17) | minéral, gravé, ancien | surface → galerie → salle gravée |
| 4 (18-23) | corrompu, instable | sain → veiné de pourpre → distordu |
| 5 (24-28) | céleste, raréfié | pente → nuages → vide lumineux |
| 6 (29-32) | abyssal | descente → obscurité → cœur du vide |

Chaque donjon garde le dégradé en 3 temps déjà validé pour le Mont Venteux
(accueillant → escarpé → exposé), transposé à son biome.

---

## 8. Ce que ce plan ne tranche pas — arbitrages requis

1. **Volumétrie** : 4000 lignes/chapitre × 22 = ~88 000 lignes. Le dépôt en
   compte ~6 000 aujourd'hui. Je peux produire ce volume **par sessions
   dédiées, un chapitre à la fois**. Confirmes-tu cette cadence ?
2. **Escortes de mini-boss** : le tableau §1.4 est-il validé ? (les 6 donjons
   concernés sont hors gabarits, donc modifiables)
3. **Ordre de production** : je commence par le ch11-12 (finir l'arc 2), ou par
   la scène d'adieu du ch32 (qui verrouille la cible émotionnelle) ?
4. **Chapitres 1-10 existants** : intouchés, ou reprises légères pour semer le
   foreshadowing des arcs 3-6 ?

---

## 9. Vérifications déjà passées

- 671 fichiers Lua compilent · `audit_bugs` 12 · `audit_integrite` 849
- Aucun script modifié par ce lot : **document seul**
