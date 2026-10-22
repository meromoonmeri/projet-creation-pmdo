# Plan de beats — Cinématiques internes des Ruines (Lot 5)

Produit **avant** le script, conformément à la méthode (section 10 du prompt
cutscenes). Ce document décide ; le Lua l'applique.

---

## 1. Écart mesuré, pas estimé

| Fichier | Lignes | Caméra | Orientation | Emote | Anim | Dialogues |
|---|---|---|---|---|---|---|
| `mount_windswept_miniboss_ch_5` (référence, **1 boss**) | 309 | 17 | 6 | 2 | 12 | 35 |
| `RuinesGardiens` (**3 gardiens**) | 288 | 3 | 2 | 1 | 1 | 2 |

Le déséquilibre est net : trois éveils tiennent dans moins de place qu'un seul
combat de référence. Le Lot 3 a posé une **ossature correcte** (signature par
gardien, silence, apparition construite) mais **pas la densité**.

Total donjon : **4484 lignes** contre **6103** au Mont Venteux.

## 2. Ce que le Lot 5 ne fera PAS

- Gonfler les dialogues pour atteindre un nombre de lignes. La consigne est
  « même qualité », pas « même volume à tout prix ».
- Toucher au camp d'entrée (déjà refait) ni au ground d'entrée.
- Réécrire les scènes de Regigigas : elles sont denses et validées.

## 3. Cible : densifier les 3 éveils + les 3 après-combats

Chaque gardien passe d'un bloc unique à **4 actes**, sur le patron du
mini-boss du Mont.

### Structure commune (le rituel doit se reconnaître)

| # | Beat | Personnages / action | Caméra | Notes |
|---|---|---|---|---|
| A1.1 | La descente | Le duo arrive par le sud, s'arrête net | Fixe salle | Aucun dialogue : on laisse voir |
| A1.2 | Le détail qui cloche | Partenaire remarque un signe propre au gardien | Insert sur le signe | 1 réplique |
| A1.3 | Pensée du héros | Aparté bref, jamais un résumé de l'image | — | Pensée seule |
| A2.1 | Le silence | BGM déjà coupée, 40 frames sans rien | Glisse lente vers le socle | Le vide fait le travail |
| A2.2 | Le gardien parle avant d'être vu | `GuardianVoice`, portrait, nom masqué | Socle | 1 réplique |
| A2.3 | Le duo se retourne | Décalage 9 frames hero/partner | — | Jamais d'un bloc |
| A3.1 | **L'éveil** | Signature propre (voir §4) | Insert socle | Musique entre ICI |
| A3.2 | Réaction immédiate | Emote + recul, partenaire d'abord | Recadre duo | 1 réplique |
| A3.3 | Le gardien pose l'enjeu | 2 répliques, registre propre | Socle | Ce qu'il veut |
| A4.1 | Réponse du partenaire | Détermination, pas bravade | Duo | 1 réplique |
| A4.2 | Transition combat | `BossTransition` hors pcall | — | Sortie garantie |

### Après-combat, par gardien (actuellement générique pour les trois)

| # | Beat | Notes |
|---|---|---|
| V1 | Le gardien se range | Pas « meurt » : il se retire, tour de garde fini |
| V2 | Ce qu'il dit en partant | **Propre à chacun** — c'est ce qui manque le plus |
| V3 | Réaction du duo | Le partenaire tire la leçon |
| V4 | Le passage s'ouvre | Retour camp |

## 4. Les trois signatures (posées au Lot 3, à densifier)

| Gardien | Signe avant-coureur | Éveil | Ce qu'il révèle en partant |
|---|---|---|---|
| **Regice** | Le froid monte, souffle visible | Givre + fracture | Il a **oublié** depuis quand il veille |
| **Regirock** | Secousse rythmée, pas un éboulement | Éclats + redressement | Il a **compté** chaque pas depuis mille ans |
| **Registeel** | **Rien** — l'absence de signe est le signe | Lumière seule, aucun bruit | Il n'a **jamais** dormi, contrairement aux deux autres |

Les trois révélations convergent vers la question posée par Regigigas
(`CRB_057`, déjà écrit) : *pourquoi les a-t-on postés face à ce qu'ils
gardaient ?* Chaque gardien en donne **un morceau**, sans que le joueur ait
la réponse avant le boss final.

## 5. OST

| Segment | Piste | Raison |
|---|---|---|
| A1–A2 | **silence** (BGM coupée à l'entrée) | Le vide rend l'imminence |
| A3–A4 | `Aegis Cave.ogg` (via `BossMusic`, T.MACHINE) | Entre à l'éveil, pas avant |
| Après-combat | `FadeOutBGM` puis silence | La salle redevient une salle |

## 6. Auto-questionnement propre à cette scène

- Les trois éveils se **reconnaissent** comme un rituel sans se **répéter** ?
  → structure commune, signatures et révélations distinctes.
- Un joueur qui enchaîne les trois d'affilée s'ennuie-t-il au troisième ?
  → Registeel est volontairement le contraire des deux autres (aucun signe).
- Le partenaire dit-il trois fois la même chose ?
  → ses répliques réagissent au **signe précis** de chaque gardien.
- La sortie vers le combat survit-elle à un crash de mise en scène ?
  → `BossTransition` et `ContinueDungeon` déjà hors `pcall` (Lot 3).
- Ajoute-t-on du mouvement pour remplir ?
  → non : les gardiens sont **immobiles** par nature, c'est la caméra et le
  duo qui portent le mouvement.
