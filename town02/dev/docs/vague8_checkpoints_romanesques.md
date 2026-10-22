# Vague 8 — Checkpoints romanesques & identité visuelle des secondes moitiés (2026-07-27)

Directive : « après avoir sauvegardé au relais, si on meurt dans la seconde
partie, elle doit être VISUELLEMENT différente (ex. prairie plus foncée/aride),
et on doit respawn AU RELAIS avec une cinématique et un dialogue
("olala c'était dur"). »

## 1. Identité visuelle des secondes moitiés (ch5)

| Donjon | 1re moitié | 2e moitié (nouveau) | Nom d'étage FR | Musique |
|---|---|---|---|---|
| Grande Steppe | lush_prairie (prairie verte), Sky Peak Prairie | **far_amp_plains** — plaine sombre et aride | **« Profondeurs de la Grande Steppe »** | **Amp Plains** (orage sourd) |
| Mont Venteux | craggy_peak (roche claire), Mt. Travail | **mt_horn** — roche sombre escarpée | **« Crêtes du Mont Venteux »** | **Mt. Horn** |
| Tunnel Incandescent | mt_blaze (roche rouge), Spring Cave | **deep_dark_crater** — roche noire en fusion | « Profondeurs Incandescentes » (existant) | Lower Spring Cave (existant) |

Vérifié machine : autotiles ET musiques des seg0/seg2 strictement différents (3/3).
Le joueur SENT qu'il a franchi le checkpoint : le monde change de couleur.

## 2. Mort au-delà du checkpoint → réveil AU relais, en scène

Avant : mourir dans la 2e moitié renvoyait à l'ENTRÉE du donjon (et, bug
hérité, les ch7-10 renvoyaient… à l'entrée de la Grande Steppe, index 46 !).

Maintenant (patron ch3/ch6 étendu, 7 donjons couverts) :
- La zone route la défaite vers le RELAIS (master_zone 62/48/63/66/71/73/75)
  et pose `SV.<Chapitre>.<X>MidState = 'DeathArrival'`.
- Le relais joue **WipedCutscene** : réveil en `EventSleep` près du Terminal
  Kangourex, fondu long, OST « Heartwarming », réveils désynchronisés
  (coroutines), puis dialogue FR en 3-4 répliques avec ÉMOTIONS :
  douleur → explication located (chaque donjon a la sienne) → réconfort →
  relance déterminée.

Extraits (chaque relais a sa voix) :
- Mont Venteux : « Olala... c'était dur. C'était vraiment, VRAIMENT dur. » →
  « le vent là-haut ne souffle pas, il MORD » → « On attend que le vent tombe...
  et on reprend l'ascension. »
- Steppe : « Les herbes sombres nous ont avalés d'un coup. » → « cette fois,
  [héros], on reste GROUPÉS. »
- Tunnel : « Ça sent le poil roussi. C'est nous, le poil roussi. » →
  « on longe la paroi froide, j'ai repéré le chemin. »
- Sanctuaire : « les cristaux chantaient encore quand tout est devenu noir »
  → « je crois qu'elle nous OBSERVE » (Diancie, sans la nommer).
- Pic Céleste : « Le Pic nous a repoussés — pas par méchanceté... on n'était
  juste pas prêts. »

## 3. Couverture

| Donjon | Route mort→relais | Scène de réveil | Flag |
|---|---|---|---|
| Grande Steppe (ch5) | seg2 → 62 | vast_steppe_midpoint_ch_5 | SteppeMidState |
| Tunnel Incandescent (ch5) | seg1 → 48 (déjà bon) + flag | searing_tunnel_midpoint_ch_5 | TunnelMidState |
| Mont Venteux (ch5) | seg2 → 63 | mount_windswept_midpoint_ch_5 | WindsweptMidState |
| Aegis Cave (ch7) | seg2/3 → 66 (**fix bug 46**) | cloven_ruins_midpoint | RuinsMidState |
| Sanctuaire de Cristal (ch8) | seg2/3 → 71 (**fix bug 46**) | crystal_sanctuary_relay | SanctuaryMidState |
| Marais de l'Oubli (ch9) | seg2/3 → 73 (**fix bug 46**) | forgotten_marsh_relay | MarshMidState |
| Pic Céleste (ch10) | seg2/3/4/5 → 75 (**fix bug 46**) | celestial_peak_relay | PeakMidState |

(ch3 Caverne Tortueuse et ch6 Forêt Lugubre avaient déjà leur WipedCutscene —
c'est leur patron qui a été étendu.)

Audit : 7/7 routes+flags+scènes+hooks+positions de réveil sur sol walkable ;
SV déclarés (scriptvars + garde-fous OnUpgrade) ; Lua dépôt entier OK.
