# Rendus du village NNV — 6 bâtiments PMU

PNG lus depuis les Grounds transformés (`TexSize 1`, 624×624, cellule 8 px).

| Fichier | Contenu |
|---|---|
| `village_spring.png` | printemps, 624×624 |
| `village_summer.png` | été, 624×624 |
| `village_autumn.png` | automne, 624×624 |
| `village_winter.png` | hiver, 624×624 |
| `VILLAGE_ALL_SEASONS.png` | planche comparative |

## Bâtiments

| Parcelle | Asset PMU | Dimensions ×1 | Position | Origine |
|---|---|---:|---|---|
| Sud-ouest | `tiles9_0744` | 122×120 | (50,361) | remplace `objplayerhouse` |
| Nord-ouest | `tiles9_0422` | 116×99 | (102,181) | remplace `objloggerhouse` |
| Est | `tiles9_0434` | 115×98 | (478,215) | remplace `objhunterhouse` |
| Nord | `tiles9_0406` | 126×94 | (176,3) | remplace `objcarpenterhouse` |
| Centre | `tiles9_0361` | 110×98 | (304,272) | **ajout** sur clairière 100 % libre |
| Sud-est | `tiles9_0380` | 125×88 | (432,456) | **ajout** sur clairière 80 % libre |

Six assets **distincts**, tous à l'échelle native ×1, jamais redimensionnés.

## Méthode des deux ajouts

Emplacements choisis par analyse de la grille de collision : seules les zones
réellement dégagées et éloignées d'au moins 170 px des bâtiments existants ont
été retenues. Parcelles réadaptées comme les quatre premières — herbe dégagée
sur l'emprise + marge de 16 px, couloir d'accès sud 48×72, collision dérivée du
masque alpha réel.

Aucun arbre, chemin ou rocher NNV n'a été supprimé pour faire de la place :
les deux maisons occupent des clairières préexistantes.

## Limite importante

Ces bâtiments sont ajoutés **dans `rmvillage`**, la seule zone NNV convertie.
Les autres zones (`rm54`, `rm45`, `rm56`, `rm65`…) ne peuvent pas recevoir de
maisons : elles ne sont pas converties, et `data.win` reste inaccessible
(blocage TLS sur le CDN LFS), tout comme les matrices de tuiles qui ne sont
suivies que sous forme de hashes.

## Statut

`RENDERED_RUNTIME_NOT_RUN`. 4 saisons alignées, sources PMU intactes.

---

# 4 zones NNV voisines — terrain seul, SANS STRUCTURE

`data.win` a été récupéré via **`codeload.github.com`**, qui sert les fichiers
LFS résolus là où le CDN `media/objects.githubusercontent.com` coupe le TLS.
Les 4 parts réassemblées donnent le SHA-256 attendu
`2f33b595b450b40355554d73f5acc5d7272e5d54519e35cd8971e0f336401227`.

Zones converties puis normalisées ×0,125 (624×624, cellule 8 px, `TexSize 1`) :

| Zone | Position | Structures | Identité visuelle | Collision bloquée |
|---|---|---:|---|---:|
| `rm65` | nord | **0** | rivière, grotte | 17,0 % |
| `rm54` | nord-est | **0** | champs cultivés | 16,4 % |
| `rm45` | ouest | **0** | forêt d'automne | 30,1 % |
| `rm56` | sud | **0** | rivière, berges | 28,6 % |

**Aucune structure PMU.** Terrain NNV d'origine uniquement : `Decorations`
vide, aucune planche `PMU_Buildings.tile`, aucune herbe dégagée, aucune
collision ajoutée.

| Fichier | Contenu |
|---|---|
| `rm54.png` `rm45.png` `rm56.png` `rm65.png` | zones individuelles |
| `ZONES_NOSTRUCT.png` | planche des 4 zones |

## Les deux défauts précédents ont disparu

Le placement de maisons avait introduit deux problèmes, tous deux **résolus par
la restauration** :

1. **`rm65`** — le damier de transparence venait du dégagement d'herbe sur un
   sol non uniformément couvert. Mesure après restauration : **0 pixel
   transparent** sur les 4 zones.
2. **`rm56`** — la maison posée sur une berge n'existe plus.

Le contenu d'origine réapparaît : la grotte de `rm65`, la ferme et ses champs
labourés de `rm54`, la forêt orangée de `rm45`, les berges de `rm56`.

## Blockers hérités du convertisseur

- `rm56`/`rm65` : `unsupported layer type Effect:watereffect` — l'effet d'eau
  animé n'est pas porté.
- `rm45`/`rm56`/`rm65` : rôles `objmob*` en attente de mapping Pokémon natif.

## Statut

`TERRAIN_ONLY_NO_STRUCTURE`. Runtime PMDO non exécuté.
