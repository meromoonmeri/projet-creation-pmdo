# Duel sauvage : emprise écran Ground → `.rsmap` — audit avant implémentation

Objectif imposé : quand un duel démarre, le joueur doit voir **exactement le
même lieu, plein écran, pixel-perfect**, sans recadrage ni petite arène.

Cet audit détermine ce que cela signifie **en pixels réellement affichés**, et
non par égalité naïve entre deux fichiers.

## 1. Les deux formats n'ont pas la même unité — et ça n'a aucune importance

| | Ground NNV | `.rsmap` de donjon |
|---|---|---|
| Unité de tuile | `TexSize 8` → **64 px** | `TileSize` → **24 px** |
| Grille | 78 × 78 tuiles | variable |
| Collision | 624 × 624 cellules de 8 px | 1 par tuile de 24 px |
| Emprise totale | 4992 × 4992 px | Width × 24 px |

La règle déjà appliquée dans le dépôt (`tools/audit_battle_same_ground.py`,
11 paires vérifiées, 0 erreur) est :

```
taille .rsmap en tuiles = collision du Ground / 3
```

soit 8 px × 3 = 24 px. C'est cohérent, mais ça concerne des Grounds de petite
taille. Appliqué à NNV, ça donne 624/3 = **208 × 208 tuiles**.

## 2. Le chiffre qui tranche

`metano_raid_1.rsmap` fait 15 × 18 tuiles, 8 couches, **867 589 octets** — soit
~3 213 octets par colonne-tuile, toutes couches confondues.

Une `.rsmap` couvrant **tout** le Ground NNV :

```
208 × 208 = 43 264 tuiles  →  ~139 Mo par duel, par saison
```

**Non viable.** Ce n'est pas un compromis visuel que je refuse, c'est un mur
technique : le dépôt entier ferait plusieurs gigaoctets pour une poignée de
duels, et le moteur devrait charger 139 Mo de JSON à chaque affrontement.

## 3. Ce que le joueur voit réellement — la preuve moteur

`Ground/BaseGroundScene.cs` l. 155 et `Dungeon/BaseDungeonScene.cs` l. 167
calculent tous les deux le `ViewRect` **en pixels**, de la même façon :

```csharp
ViewRect = new Rect(focusedLoc.X - GraphicsManager.ScreenWidth  / scale / 2,
                    focusedLoc.Y - GraphicsManager.ScreenHeight / scale / 2,
                    GraphicsManager.ScreenWidth  / scale,
                    GraphicsManager.ScreenHeight / scale);
```

**L'emprise visible est la même surface en pixels dans les deux scènes.** Seule
la taille de tuile employée pour la remplir diffère. C'est exactement ce que tu
décrivais : la correspondance se joue au rendu, pas sur les valeurs internes.

Concrètement, à 480 × 270 px d'écran :

| | tuiles visibles |
|---|---|
| Ground (64 px) | 7,5 × 4,2 |
| `.rsmap` (24 px) | 20,0 × 11,2 |

Le joueur voit **480 × 270 px du lieu** dans les deux cas.

## 4. Conséquence : la règle correcte

> La `.rsmap` de duel doit couvrir **toute la surface visible à l'écran, plus
> une marge de scroll**, remplie par le décor exact du Ground à cet endroit.
> Elle n'a pas besoin de couvrir les 4992 × 4992 px du Ground — le joueur ne
> peut physiquement pas les voir.

Fenêtre retenue : **26 × 14 tuiles = 624 × 336 px**, soit 1,3 × 1,24 écran à
480 × 270. Le décor déborde donc de l'écran de tous les côtés : **aucune bande
noire, aucun bord de map visible**, et le scroll pendant le combat reste dans
le décor authentique.

En cellules du Ground, cette fenêtre couvre 9,75 × 5,25 cellules de 64 px : elle
est **découpée pixel à pixel dans le rendu du Ground source**, centrée sur le
lieu de l'affrontement, puis retuilée en 24 px.

Coût : ~1,2 Mo par map de duel au lieu de 139 Mo, pour un rendu **strictement
identique dans tout ce que le joueur peut voir**.

## 5. Ce qui reste à garantir à l'implémentation

- Découpe centrée sur le couple en duel, **clampée** aux bords du Ground pour
  ne jamais inclure de hors-carte.
- Rééchantillonnage **NEAREST exclusivement** (règle du projet) — en pratique
  aucun rééchantillonnage : 624 × 336 px du Ground sont copiés tels quels, puis
  regroupés en tuiles de 24 px.
- Injection obligatoire dans `Content/Tile/index.idx`, sinon **damier
  mauve/noir** (`docs/DIAGNOSTIC_DAMIER_DUEL_METANO_2026-08-05.md`).
- Vérification automatique : rendu de la `.rsmap` comparé pixel à pixel à la
  fenêtre correspondante du Ground source. Résultat attendu : identité stricte
  sur le décor statique.
- Segment de zone `IsRelevant = false`, retour au Ground à la position exacte.

## Statut

`AUDIT_VALIDÉ` — la contrainte « plein écran, même lieu, pixel-perfect » est
tenable et chiffrée. La contrainte « toute la surface du Ground » ne l'est pas,
et le moteur prouve qu'elle est sans objet : cette surface n'est jamais visible.
