# Extraction officielle exhaustive — No Name Village

- **État :** `OFFICIAL_MODEL_EXTRACTED_EXHAUSTIVELY`
- **Lecteur :** UndertaleModLib 0.6.1.0 exécuté sous .NET 10.0.3/WASM
- **Source :** `data.win`, 301 037 316 octets, SHA-256 `2f33b595…`
- **Rooms :** 98 avec layers, grilles de tiles, placements et instances complets
- **Code VM :** 2188 entrées, 273883 instructions conservées
- **GML :** 2025 corps décompilés, 161 alias enfants, 2 échecs Steam hors village
- **Sprites :** 2775, 9084 frames, 653 masks
- **Textures :** 9134 page-items issus de 96 pages QOI+BZip2
- **Audio :** 388 fichiers (383 WAV, 5 OGG), 249521056 octets
- **Erreurs de getter modèle :** 0

Les deux échecs GML concernent `Obj_Steam_Input` et `Obj_Steam_ProfileImage`; leurs instructions VM complètes sont présentes dans `extracted/official/inventory/Code.json.gz`. Toute la logique du village, des quatre saisons, de l'heure, des layers et des transitions est décompilée sans échec.
