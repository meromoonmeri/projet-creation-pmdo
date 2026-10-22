# Format des cartes RogueEssence / PMDO — et pourquoi mes planches sont fausses

Date : 2026-08-04. Écrit après une remarque de l'auteur : *« je pense
avoir compris le problème, faut que la map soit composée de tilesets
non ? »*

**Oui. Et c'est mesurable.**

---

## 1. Ce que dit le moteur

`RogueEssence/Ground/Maps/GroundMap.cs` :

```csharp
public int TileSize  { get { return TexSize * GraphicsManager.TEX_SIZE; } }  // l.44
public int Width     { get { return Layers[0].Tiles.Length; } }              // l.49
public int Height    { get { return Layers[0].Tiles[0].Length; } }           // l.54
```

Une carte n'est donc **pas une image**. C'est une grille de cases, et
chaque case porte une pile de calques. `Dungeon/Tiles/TileLayer.cs` :

```csharp
public class TileLayer
{
    public List<TileFrame> Frames;   // plusieurs frames = tuile animée
    public int FrameLength;
}
public TileLayer(Loc texture, string sheet)   // l.44
```

Chaque `TileFrame` est un couple **(planche, coordonnée dans la
planche)**. Vérifié dans un `.rsground` réel :

```json
{"AutoTileset": "", "Associates": [], "NeighborCode": -1,
 "Layers": [{"Frames": [{"Sheet": "Camp_Ruines_Base",
                         "TexLoc": {"X": 10, "Y": 10}}],
             "FrameLength": 60}]}
```

Le format est donc conçu pour que **plusieurs cases pointent la même
tuile**. C'est tout l'intérêt : une planche de quelques centaines de
tuiles suffit à couvrir une carte entière.

---

## 2. La mesure qui condamne ma méthode

Redondance = proportion de cases qui réutilisent une tuile déjà posée.

| Source | Cases | Tuiles uniques | Redondance |
|---|---|---|---|
| Référence PMD fournie par l'auteur | 2 736 | **265** | **90,3 %** |
| Aegis Cave Entrance (dépôt) | 3 672 | 1 981 | 46,1 % |
| Metano Town (carte de l'auteur) | 79 910 | 71 079 | 11,1 % |
| **Ma planche générée** | 3 672 | **3 663** | **0,2 %** |

Sur la référence PMD, **une seule tuile d'herbe couvre 33 % de
l'image**, et les 20 tuiles les plus fréquentes en couvrent 57 %.

Ma planche : 3 672 références pour 3 672 cases. **Chaque case a sa
propre tuile.** Je ne construis pas une carte, je découpe une image en
morceaux et je les recolle un par un.

D'où tout ce que l'auteur a relevé au fil des essais :

* **« trop 3D »** — une image peinte a des dégradés continus sur toute
  la surface ; un tileset a un motif fini qui se répète, donc des
  formes franches et lisibles ;
* **« aucun motif, aucun relief »** — le sol d'un vrai tileset est fait
  de 3-4 tuiles alternées qui créent un rythme visible ; le mien varie
  à chaque case, ce qui produit un bruit uniforme, donc plat ;
* **poids** — 792 Ko de `.tile` pour une carte, contre quelques dizaines
  de Ko pour une planche normale.

---

## 3. Nuance importante

Metano Town, faite à la main par l'auteur dans l'éditeur, n'a que
**11 % de redondance** et emploie 15 planches. La redondance seule
n'est donc pas un critère de qualité absolu : une grande carte variée
consomme beaucoup de tuiles distinctes.

Mais 0,2 % reste une anomalie de nature : cela signifie qu'**aucune
tuile n'est réutilisée**, ce qui n'arrive jamais dans un travail de
tileset, même très varié.

---

## 4. Ce qu'il faudrait faire

La bonne méthode inverse complètement l'ordre de production :

1. dessiner un **jeu de tuiles** — sol (3-4 variantes), bordures,
   coins, rochers, végétation, entrée de grotte — soit quelques
   dizaines de tuiles ;
2. **composer** la carte en posant ces tuiles sur la grille, avec les
   règles d'autotile pour les raccords ;
3. la planche `.tile` ne contient alors que les tuiles uniques, et le
   `.rsground` ne contient que des références.

Générer une image entière puis la découper produit l'inverse : une
planche aussi grande que la carte, sans aucune réutilisation.

`tools/mesurer_redondance.py` permet de contrôler ce point sur
n'importe quelle planche ou `.rsground` avant de valider un rendu.
