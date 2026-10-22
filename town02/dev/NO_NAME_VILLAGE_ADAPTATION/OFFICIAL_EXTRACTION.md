# Pipeline officiel UndertaleModLib

Ce pipeline complète l'extracteur structurel Python. Il charge le `data.win`
avec **UndertaleModLib 0.6.1.0**, exporte chaque propriété publique/interne du
modèle, chaque instruction VM et chaque blob binaire, puis exécute le
décompilateur GML officiel.

## Provenance verrouillée

- `data.win` : 301 037 316 octets, SHA-256
  `2f33b595b450b40355554d73f5acc5d7272e5d54519e35cd8971e0f336401227` ;
- PortMaster `PortMaster-New` : commit
  `2951fe9c7afe596c349a7e0f4bf08bfc6c74b536` ;
- `UndertaleModLib.dll` source : SHA-256
  `d1a5c98f899a221a8a2d6c387b9ea0c7d942266a29cc67fd7a8cb6d8bdcbf32d` ;
- `UndertaleModCli.dll` source : SHA-256
  `e07a259a4e1df27d4b6f758b72197c71b6dfee021f8e834a134dc0596c8c9b50` ;
- runtime WASM : `cepha-cli@1.0.137`, .NET 10.0.3 ;
- `NoNameVillageExtractor.dll` suivi : SHA-256
  `bdf87282cdb142148f6961d90e2ec3addde944d17a1aea2e7526891bc7e43ef2`.

Le DLL de l'extracteur est compilé uniquement depuis
`tools/NoNameVillageExtractor.cs`. Il est suivi pour ne pas imposer un SDK .NET
au runner ; le code source reste l'autorité.

## Construction du bundle

```bash
npm pack cepha-cli@1.0.137
mkdir -p .runtime-cache/no-name-village/cepha
# extraire le tarball npm dans ce répertoire, sans le préfixe package/

git clone --depth 1 --filter=blob:none --sparse \
  https://github.com/PortsMaster/PortMaster-New.git \
  .runtime-cache/no-name-village/PortMaster
(
  cd .runtime-cache/no-name-village/PortMaster
  git sparse-checkout set ports/chicoryact/chicoryact/tools/utmt-cli
)

python3 NO_NAME_VILLAGE_ADAPTATION/tools/build_utmt_wasm_bundle.py \
  --cepha-framework .runtime-cache/no-name-village/cepha/_framework \
  --utmt-directory .runtime-cache/no-name-village/PortMaster/ports/chicoryact/chicoryact/tools/utmt-cli \
  --output .runtime-cache/no-name-village/bundle-extract \
  --mode extract
```

## Extraction exhaustive

```bash
node --max-old-space-size=4096 \
  NO_NAME_VILLAGE_ADAPTATION/tools/wasm/extract-all.mjs \
  .runtime-cache/no-name-village/bundle-extract \
  .runtime-cache/no-name-village/source/data.win \
  .runtime-cache/no-name-village/structured
```

Le résultat contient 31 inventaires JSON, les 388 fichiers audio, les bytes
compressés des 96 textures, les 653 masks et les instructions des 2188 entrées
`CODE`. Les fichiers volumineux restent en cache ; les inventaires déterministes
compressés et tous les blobs non audio sont suivis sous `extracted/official/`.

## Décompilation GML

```bash
python3 NO_NAME_VILLAGE_ADAPTATION/tools/build_utmt_wasm_bundle.py \
  --cepha-framework .runtime-cache/no-name-village/cepha/_framework \
  --utmt-directory .runtime-cache/no-name-village/PortMaster/ports/chicoryact/chicoryact/tools/utmt-cli \
  --output .runtime-cache/no-name-village/bundle-decompile \
  --mode decompile

node --max-old-space-size=4096 \
  NO_NAME_VILLAGE_ADAPTATION/tools/wasm/utmt-host.mjs \
  .runtime-cache/no-name-village/bundle-decompile \
  dump .runtime-cache/no-name-village/source/data.win \
  -o .runtime-cache/no-name-village/gml -c UMT_DUMP_ALL -s
```

La compatibilité WASM est une transformation binaire bornée et vérifiée par
SHA-256 (`patch_utmt_for_wasm.py`). Elle ne modifie ni le lecteur GameMaker ni
le décodeur VM. Le cache parallèle des noms de sous-fonctions est initialisé
vide parce que `Task.WaitAny` n'existe pas sur le runtime WASM mono-thread.
Conséquence auditée : deux événements Create des exemples Steam ne passent pas
la mise en forme GML ; leurs instructions VM complètes restent présentes.
Toute la logique village/saisons/heure est décompilée.

## Textures, frames et masks

```bash
python3 NO_NAME_VILLAGE_ADAPTATION/tools/decode_official_textures.py \
  .runtime-cache/no-name-village/structured \
  .runtime-cache/no-name-village/texture-pages

python3 NO_NAME_VILLAGE_ADAPTATION/tools/extract_all_frames.py \
  .runtime-cache/no-name-village/structured \
  .runtime-cache/no-name-village/frames
```

Le décodeur implémente le QOI GameMaker little-endian documenté par
UndertaleModLib, puis BZip2 et PNG sans crop. Le second outil restaure le canvas
complet de chaque frame avec `TargetX/Y`, conserve les 653 masks bit-à-bit et
produit un manifeste stable.
