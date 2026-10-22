# AUDIT — nuit du Mont Venteux (retour de jeu 2026-07-30)

Commande : « FAIT UN AUDIT TU DOIS TOUT CORRIGER ». Chaque souci du test
en jeu est relié ici à sa cause, preuve à l'appui (fichier + ligne), et à
sa correction. Statut : ✅ corrigé dans ce lot / en cours.

## P0 — CRASH à l'entrée de la map du rêve (et black screen au coucher)

**Constat testeur** : « quand je vais sur le ground du rêve je crash »
et « black screen au moment du coucher ».

**Cause (preuve)** : la carte `songe_source` n'était **pas enregistrée**
dans `Data/Zone/master_zone.json` (liste des Grounds de la zone maîtresse).
`genesis_vision` y figure (ligne ~83099), `personality_test` aussi (83074),
`mount_windswept_entrance` aussi (83084) — `songe_source`, non.
`EnterGroundMap('songe_source')` → carte inconnue → crash. Le coucher
finissait sur un fondu noir vers cette carte inexistante : d'où le black
screen au coucher.

**Correction** : `"songe_source",` ajouté à la liste juste après
`"personality_test",`. ✅

**Compagnon de route** : le sprite 282 (Gardevoir) n'est pas dans le
`Content/` du mod (39 packs chara, 34 portraits, 282 absent des deux).
Si le moteur ne le fournit pas non plus, son spawn est un second risque de
crashau dessin. **Correction** : spawn désormais sous `pcall` avec
filet — si la création échoue, la scène bascule sur la « présence de
lumière » (brume, pulsations, scintillement, éclat) au lieu de casser ;
toutes les touches sur le sprite sont gardées par `if elle ~= nil`. ✅

## P1 — le Ground du rêve « moche » : une NOUVELLE map ✅ livrée

**Constat testeur** : le clone de `luminous_spring` déçoit ; une vraie
map onirique était attendue (carte blanche §6 + brief : « Conception de
la nouvelle Ground »).

**Réalisé** (`tools/make_dream_map.py`, idempotent) : nouvelle
composition « jardins suspendus » à même tileset que la Source
(souvenir du chapitre 2, cohérence du rêve) —
- le bloc source (bassin, colonne de lumière, gemmes, rive) est
  conservé à l'identique : **toutes les ancres de la scène sont
  inchangées** (glow (390,205), rive y≈285-305, axe du héros col 16,
  marqueur d'entrée (292,580)) — `PlayDream` n'a pas bougé ;
- flancs et coins deviennent du vide transparent : la parallaxe de rêve
  (Background identique au test de personnalité) se voit à travers —
  le jardin flotte dans le songe ;
- flancs et angles fondus en alpha (94 variantes de frames générées ;
  le paquet `LuminousSpring.tile` est **étendu**, jamais modifié :
  les 625 frames d'origine sont byte-identiques, `luminous_spring`
  n'est pas touchée) ;
- 6 îlots de pré suspendus, silhouettes en gouttière (coins retirés),
  textures prélevées par patchs 3×3 sur la clairière d'origine (motif
  cyclique mesuré) — deux points de lecture pour varier ;
- obstacles recalculés (vide/eau/lumière/sous-bois bloqués ; clairière,
  rive, îlots, aire d'atterrissage libres ; axe du héros col 16
  y∈[264,456] et son point d'ancre (390,297) prouvés libres) ;
- rendu de contrôle : `docs/renders/songe_source.png` (+ `_zoom`).
**À confirmer en jeu** : la parallaxe de rêve doit défiler visiblement
dans les zones noires (comportement moteur, impossible à valider ici).

## P1 — déplacements au coucher

**Constat testeur** : « le partenaire (Riolu) fait un long déplacement
inutile », « les pokémon ne s'évitent pas quand ils se déplacent ».

**Causes (preuves, `mount_windswept_entrance_ch_5.lua`)** :
1. Section 2 (l. 143-151) : les 12 sont envoyés à leurs paillasses en
   **12 coroutines parallèles** décalées de 6 frames — 12 trajectoires
   qui se croisent au centre du camp.
2. Section 7 (l. 514-527) : sous le fondu des paillasses, personne n'est
   repositionné — ceux qui ont dérivé pendant la veillée restent où ils
   sont (Rin s'est promenée, l. 402/435).
3. Section 8 (l. 545-556) : 7 marches parallèles vers les couches
   décalées de 14 frames, `MoveToPosition` n'évite pas les personnages
   (seulement les obstacles de carte) → traversées visibles.

**Corrections** :
- Section 2 : ordre du cercle **annulaire** (positions adjacentes servies
  dans l'ordre, pas de diamètres qui se croisent) + cadence relevée
  (i×10) pour que chacun dégage avant le départ du suivant.
- Section 7 : sous le fondu, **téléportation nette des 12 près de leur
  paillasse** (y compris le duo) — après la réouverture, chacun est là où
  la fiction l'exige (« proche de sa paillasse, comme chaque pokémon »).
- Section 8 : suppression des marches résiduelles ; le coucher devient
  purement postural (se tourner, s'allonger, en décalé) — zéro trajet,
  zéro croisement possible. Phileas prend son poste par le couloir nord
  prouvé libre, seul mouvement restant, sans traversée (il part quand
  tout le monde est déjà étendu).
- Section 9 : inchangée (le duo est déjà sur ses couches). ✅

## P2 — « soucis de fondu » boss des Limagma → Mont (j'insiste)

**Constat testeur** : la transition reste cassée à ses yeux.

**Cause (preuve géométrique)** : caméra du Creuset à (264,264) — cadre
visible y∈[144,384] (`searing_crucible_ch_5.lua:810`). Les quatre
marcheurs de sortie partent de ~y=264-320 et marchent de **106-120 px** :
ils s'arrêtent à y≈150-210, **en plein cadre**, figés en pleine lumière,
PUIS le noir tombe (post-lot 3). Personnage qui s'arrête net à l'image =
fondu raté, quels que soient les réglages de durée.

**Correction** : le fondu **accompagne la fin de la marche** — il démarre
pendant qu'ils progressent et atteint le noir complet pile quand le
dernier s'arrête (t≈83-90 frames). Personne n'est jamais vu debout
immobile en pleine lumière après l'arrêt ; et le noir mort de 90 frames
du scénario d'origine ne revient pas (20 frames de respiration). ✅

## P2 — I8 (récurrent dans « toutes les erreurs évoquées »)

**Constat** : la même scène nomme le gardien « l'Aérodactyle »
(entrance_ch_5 l. 2212/2239/2245) tandis que son arène dit « l'Aerodactyl »
(guardian MWG_020/025, CharacterEssentials 'Aerodactyl').

**Correction** : harmonisation vers **« l'Aerodactyl »** (forme de
l'arène + de l'entrée CharacterEssentials) aux trois endroits incriminés. ✅

## Hors périmètre, rappel honnête

- Rien de tout cela n'a pu être **testé en jeu** de mon côté (pas de
  moteur ici) : validation statique + géométrie prouvée, ton test reste
  le juge.
- I6 (mix `Sleep`/`EventSleep` chez les dormeurs) : toujours non confirmé
  visible ; si tu le vois en jeu, dis-le.
