# Qualité des combats de boss — Régigigas + les 10 Veilleurs

Build : `2026-07-31-W`

## Point de départ : l'audit

`tools/audit_boss_cinematics.py` avait établi le constat :

| famille | scènes | score moyen | boîtes du boss |
|---|---|---|---|
| histoire | 9 | 80,2/100 | 19,9 |
| réseau | 10 | 24,1/100 | 3,6 |
| légendaire | 38 | 17,3/100 | 2,0 |

Deux chantiers prioritaires : **le seul boss d'histoire muet** (Régigigas) et
**les 10 Veilleurs du Réseau**.

---

## 1. Régigigas — le boss d'histoire qui ne parlait pas

`cloven_ruins_boss_ch_7` : 37 répliques, 9 caméras, 8 effets — du vrai travail —
mais **pas une ligne du boss**. Le partenaire criait son nom, et on enchaînait
sur le combat. Score **46/100**.

### Registre choisi : une sentinelle qui n'a plus d'ordres

Il ne hait pas (Zarude), ne teste pas (la harde), ne compte pas (les
Sentinelles du Pic) : il **exécute une consigne dont il a oublié l'auteur**.
Diction hachée, presque militaire — un rapport, pas une conversation.

> « Désignation : sentinelle. Poste : cette salle. Durée : inconnue. »
> « On m'a dit de tenir jusqu'à la relève. Personne n'est venu. »
> « Petits. Êtes-vous la relève ? »
> — puis il répond lui-même : « Non. La relève n'arrive pas en armes. »

Personne n'a le temps de placer un mot : c'est ce qui montre qu'il ne dialogue
pas vraiment.

### L'après-boss : il n'est pas vaincu, il est **relevé**

Renversement du sens du combat. Le duo croit avoir gagné ; il vient de libérer
un veilleur de sa faction. Et c'est là que tombe la phrase de la scène :

> « Si nous devions le protéger… **pourquoi m'a-t-on posté FACE à lui ?** »
> « Un garde fait face à ce qu'il tient dehors. J'ai fait face à ce Cœur
> pendant mille ans. »

Le partenaire encaisse sans réponse — c'est voulu. Le mot « prison » n'est
jamais prononcé ; le twist reste intact pour l'arc 6.

**16 clés neuves EN + FR.** Score : **46 → 94/100**.

---

## 2. Les 10 Veilleurs — `VeilleurArc.lua`

Leur amorce était bonne (signal → irruption → recul → reveal → titre →
échange) et leur identité déjà juste : « Je suis la lampe qu'on a laissée au
fond. » Ce qui manquait n'était pas l'entrée, c'était **la sortie** :

- aucun après-boss ; le partenaire lâchait **une** phrase depuis `zone/…/init.lua` ;
- le Veilleur posait une question avant le combat et **n'y répondait jamais**.

### La règle commune, tirée du lore

Un Veilleur n'est pas un légendaire : c'est un Pokémon ordinaire chargé par les
bâtisseurs de tenir une porte « jusqu'à ce que quelqu'un ait une bonne raison
de passer ». Donc, pour les dix : **ils ne sont pas vaincus, ils sont relevés.**

### Dix réactions différentes à la même libération

C'est là que se joue leur individualité — aucune redite :

| Veilleur | réaction |
|---|---|
| Rempart | **incompréhension** — « On m'a dit de tenir. Personne ne m'a dit ce qu'on fait après. » |
| Câble-Vif | **soulagement bavard** — il n'a parlé à personne depuis des siècles |
| Fusible | **colère froide** — « Ils m'ont posté, puis ils sont partis. Le feu, lui, est resté. » |
| Blizzard-Sentinelle | **deuil** — il garde une forêt qui n'existe plus |
| Voile-Blanc + Masque-Gel | **duo qui se chamaille** depuis mille ans (seul registre léger) |
| Soleil-de-Cendre | **gratitude** — « Vous venez de me donner le droit de baisser. » |
| Déchire-Nuages | **déni** — « Ce n'est pas une défaite, c'est une pause. » |
| Lame-de-Fond | **peur** — il ne gardait pas la voie, il gardait ce qu'il y a dessous |
| Lanterne-Noyée + Ancre-Morte | **désaccord** — l'un veut parler, l'autre dit « tais-toi » |
| Portier-du-Vide | **il attendait** — « Trois cents ans, et personne n'a jamais demandé POURQUOI. » |

**61 boîtes** réparties sur 10 Veilleurs. Chacun passe de ~3 à ~9 boîtes
(3 d'intro + 6 d'adieu). Idempotent : un rematch ne rejoue pas la cérémonie.

---

## Erreur commise et corrigée

**3 fiches sur 10 avaient des positions inventées**, recopiées d'un gabarit
au lieu d'être lues dans les `ground/*/init.lua` : Câble-Vif (184,176 et non
160,112), Blizzard-Sentinelle (136,200) et Déchire-Nuages (224,216). Détecté
en croisant chaque coordonnée avec les `obstacles` du `.rsground`, puis
réaligné sur la source de vérité. Les caméras sont recalculées à partir de la
position réelle et vérifiées dans les bornes de chaque carte.

Note de méthode : une case de Veilleur **non marchable** n'est pas un bug —
ils émergent d'un mur ou d'un rocher (`EmergeGround` / `EmergeFire`), c'est
volontaire. Seule la caméra doit impérativement rester dans la carte.

---

## Résultat

| | avant | après |
|---|---|---|
| **boss muets** | 1 | **0** |
| Régigigas (ch7) | 46/100 | **94/100** |
| famille histoire | 80,2 | **82,0** |
| chaque Veilleur | ~3 boîtes | **~9 boîtes** |

## Validation

Lua **644/644** · `.resx` **576/576** · zones + index **208/208** ·
`verify_legend` / `verify_bg_format` / `verify_scene_positions` au vert.
Toutes les clés CRB référencées existent en EN et FR. Portées Lua vérifiées
fonction par fonction (`regigigas` déclaré avant chacun de ses 13 usages).
Toutes les coordonnées de `VeilleurArc` sont dans les bornes de leur carte.

## Reste à faire

**Les 38 arènes de légendaires** (17,3/100) — le plus gros volume. Elles
tiennent en 4 boîtes et 1 mouvement de caméra. Leur identité individuelle est
déjà écrite ; il leur faut le même traitement que les Veilleurs : un
après-boss et une caméra qui respire.

## Non testé

**Rien n'est testé en jeu.** Non vérifiable par script : le rendu réel des
cascades d'animations `Hurt → Idle → EventSleep` selon les espèces (certaines
n'ont pas toutes les animations ground — d'où les `pcall` systématiques), et
le rythme des `MoveCamera` pendant les tirades.
