# Référence d'affichage PMDO — dérivée du moteur réel (pas supposée)

Vérifiée le 2026-08-25 sur la build exacte utilisée par le projet
(PMDO 0.8.12, `pmdc-linux-x64.zip` sha256 `c64f72af…c61577`, apphost
`faf9755c…e8327`, DumpAsset épinglé `9d864d14…f9c9`).

## Chaîne de vérité

1. `RogueEssence/Content/GraphicsManager.cs` (RogueCollab/RogueEssence) :
   `ScreenWidth` / `ScreenHeight` ne sont **pas** des constantes compilées —
   ils sont lus au boot depuis `Base/GFXParams.xml` des assets :
   ```csharp
   public static int ScreenWidth;          // ligne 131
   public static int ScreenHeight;         // ligne 132
   ScreenWidth  = Int32.Parse(screenWidth.InnerText);   // ligne 334
   ScreenHeight = Int32.Parse(screenHeight.InnerText);  // ligne 337
   public static int TileSize { get { return DungeonTexSize * TEX_SIZE; } }
   public static int WindowWidth  { get { return windowZoom * ScreenWidth; } }
   public static int WindowHeight { get { return windowZoom * ScreenHeight; } }
   ```
2. `DumpAsset/Base/GFXParams.xml` (assets réels du runtime épinglé) :
   ```xml
   <TileSize>24</TileSize>
   <PortraitSize>40</PortraitSize>
   <ScreenWidth>320</ScreenWidth>
   <ScreenHeight>240</ScreenHeight>
   ```
3. Le mod New Era ne fournit **aucun** override `GFXParams.xml` :
   il hérite donc 320×240 logique, tuile 24 px, portrait 40 px.
   La fenêtre physique = 320×240 × WindowZoom (zoom entier, plein écran
   = min(display/Screen)) — le cadrage logique reste 320×240.

## Confirmation empirique (rendu réel, pas fichiers)

* Les captures du validateur runtime historique sont des render targets
  à la taille de la MAP : `a01p01` → 480×384 px = 20×16 chunks × 24 px,
  exactement les dimensions BMA EU décodées. La projection
  1 chunk EU (3×3 tuiles GBA 8 px) → 1 cellule PMDO 24 px est donc celle
  que le moteur rend réellement.
* Campagne historique : comparaisons RGBA pixel-exactes (22 353
  échantillons, `all_rgba_exact=true`) + sondes de collision par
  déplacement réel (MOVEMENT_PASS) + cycles d'animation à ticks planifiés.

## Conséquences pour le convertisseur

* `converter/pmdo/viewport.py` (320×240, 24 px) est ALIGNÉ sur la vérité
  moteur ci-dessus — vérifié, pas supposé.
* Tout Ground converti doit couvrir ≥ 320×240 px et borner la caméra à
  une demi-fenêtre des bords (invariants déjà appliqués, 262/262 OK).
* Interdits : bandes noires, redimensionnement de la source, déformation.
  Un écart de cadrage se corrige côté intégration moteur (caméra/offsets),
  jamais en altérant le contenu canonique de la ROM.
