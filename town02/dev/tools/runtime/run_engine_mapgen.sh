#!/usr/bin/env bash
# =============================================================================
# Validation runtime de la génération des 51 donjons Ch.6-32 PAR LE MOTEUR,
# sans SDK .NET et sans carte graphique.
#
#   ./run_engine_mapgen.sh <dossier-de-travail> [itérations]
#
# Principe : on n'imite rien. On fait tourner le binaire PMDO officiel en
# mode headless (SDL offscreen + ANGLE + SwiftShader) et un service Lua du mod
# (`halcyon.services.mapgen_validator`) rejoue exactement la boucle de
# MapGenTest.Example.StressTestAll :
#
#     ZoneGenContext -> ZoneStep:Instantiate -> structure:GetMap(context)
#
# `structure:GetMap` est l'appel de génération de RogueEssence/RogueElements :
# chaque étage est réellement construit par le moteur, avec ses GenSteps, ses
# spawns, ses features et `DetectIsolatedStairsStep`.
#
# Sortie : <travail>/mapgen_report.md + le JSONL brut (une ligne par étage).
#
# Prérequis réseau : github.com, codeload.github.com, registry.npmjs.org.
# Aucun besoin de dot.net, nuget.org ni de pilote graphique.
# =============================================================================
set -euo pipefail

WORK="${1:?usage: run_engine_mapgen.sh <dossier-de-travail> [itérations]}"
ITER="${2:-1}"
HERE="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$HERE/../.." && pwd)"
MOD_SRC="${PMDO_MAPGEN_MOD_SRC:-$REPO_ROOT}"
MOD_NAME="${PMDO_MAPGEN_MOD_NAME:-new-era}"

BUNDLE="$WORK/pmdo-headless-bundle"
ASSET="$WORK/asset"
APPDATA="$WORK/appdata"
OUT="$WORK/mapgen_runtime.jsonl"

mkdir -p "$WORK"

echo "== 1. binaire PMDO (dépôt runtime fourni par le projet) =="
if [ ! -x "$BUNDLE/PMDO" ]; then
  mkdir -p "$BUNDLE"
  [ -d "$WORK/RUNTIMEPMDO" ] || git clone --depth 1 https://github.com/meromoonmeri/RUNTIMEPMDO.git "$WORK/RUNTIMEPMDO"
  unzip -oq "$WORK/RUNTIMEPMDO/pmdc-linux-x64.zip" -d "$WORK/pmdo-zip"
  cp "$WORK/pmdo-zip/PMDO/PMDO" "$BUNDLE/PMDO"
  chmod +x "$BUNDLE/PMDO"
fi

echo "== 2. pile graphique logicielle : ANGLE + SwiftShader (paquet npm @sparticuz/chromium) =="
if [ ! -f "$BUNDLE/libvk_swiftshader.so" ]; then
  ( cd "$WORK" && npm pack @sparticuz/chromium >/dev/null )
  TGZ="$(ls "$WORK"/sparticuz-chromium-*.tgz | head -1)"
  tar xzf "$TGZ" -C "$WORK"
  # brotli n'est pas garanti présent : installation locale au dossier de travail.
  python3 -c "import brotli" 2>/dev/null || pip install --quiet --target "$WORK/pylibs" brotli
  PYTHONPATH="$WORK/pylibs" python3 - "$WORK" <<'PY'
import brotli, io, sys, tarfile
work = sys.argv[1]
data = brotli.decompress(open(f"{work}/package/bin/swiftshader.tar.br", "rb").read())
tarfile.open(fileobj=io.BytesIO(data)).extractall(f"{work}/pmdo-headless-bundle")
PY
  python3 - "$BUNDLE" <<'PY'
import json, os, sys
bundle = sys.argv[1]
icd = {"file_format_version": "1.0.0",
       "ICD": {"library_path": os.path.join(bundle, "libvk_swiftshader.so"),
               "api_version": "1.3.0"}}
json.dump(icd, open(os.path.join(bundle, "vk_swiftshader_icd.absolute.json"), "w"), indent=1)
PY
fi

echo "== 3. SDL2 corrigé (le pilote offscreen de SDL exige EXT_device_enumeration, absent d'ANGLE) =="
if [ ! -f "$BUNDLE/libSDL2-2.0.so.0" ]; then
  [ -d "$WORK/SDL" ] || git clone --depth 1 --branch release-2.30.3 https://github.com/libsdl-org/SDL.git "$WORK/SDL"
  python3 - "$WORK/SDL/src/video/SDL_egl.c" <<'PY'
import sys
path = sys.argv[1]
src = open(path).read()
anchor = """    /* Check for all extensions that are optional until used and fail if any is missing */
    if (!_this->egl_data->eglQueryDevicesEXT) {"""
if "PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY" not in src:
    patch = """    {
        const char *angle_default = SDL_getenv("PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY");
        if (angle_default && *angle_default == '1') {
            _this->egl_data->egl_display = _this->egl_data->eglGetDisplay(EGL_DEFAULT_DISPLAY);
            if (_this->egl_data->egl_display == EGL_NO_DISPLAY) {
                return SDL_SetError("eglGetDisplay(EGL_DEFAULT_DISPLAY) failed");
            }
            if (_this->egl_data->eglInitialize(_this->egl_data->egl_display, NULL, NULL) != EGL_TRUE) {
                return SDL_SetError("Could not initialize EGL on the default display");
            }
            if (SDL_EGL_ChooseConfig(_this) != 0) {
                return -1;
            }
            return 0;
        }
    }

""" + anchor
    open(path, "w").write(src.replace(anchor, patch, 1))
PY
  ( cd "$WORK/SDL" && ./configure --prefix="$WORK/sdl-install" \
      --enable-video-offscreen --enable-video-opengles \
      --disable-video-x11 --disable-video-wayland --disable-video-kmsdrm \
      --disable-alsa --disable-pulseaudio --disable-jack --disable-sndio --disable-oss \
      >/dev/null && make -j"$(nproc)" >/dev/null )
  cp "$WORK/SDL/build/.libs/libSDL2-2.0.so.0.3000.3" "$BUNDLE/libSDL2-2.0.so.0"
fi

echo "== 4. assets du jeu de base (audinowho/DumpAsset) =="
if [ ! -d "$WORK/dumpasset/Base" ]; then
  git clone --depth 1 --filter=blob:none --sparse https://github.com/audinowho/DumpAsset.git "$WORK/dumpasset"
  ( cd "$WORK/dumpasset" && git sparse-checkout set Base Data Strings Controls CONFIG Content )
fi
mkdir -p "$ASSET" "$APPDATA/CONFIG" "$APPDATA/MODS"
for d in Base Data Strings Controls CONFIG Content; do
  ln -sfn "$WORK/dumpasset/$d" "$ASSET/$d"
done
ln -sfn "$MOD_SRC" "$APPDATA/MODS/$MOD_NAME"
# Sans configuration, la culture est invariante et Text.ModLangPath lève une
# KeyNotFoundException avant même le chargement des données.
cat > "$APPDATA/CONFIG/Config.xml" <<'XML'
<Config>
  <BGM>0</BGM><SE>0</SE>
  <BattleFlow>VeryFast</BattleFlow><DefaultSkills>All</DefaultSkills>
  <Minimap>0</Minimap><MinimapColor>White</MinimapColor>
  <TextSpeed>4</TextSpeed><Border>0</Border><Window>1</Window>
  <Language>en</Language><InactiveInput>true</InactiveInput>
</Config>
XML

echo "== 5. extraction du bundle single-file, pour y placer le SDL corrigé =="
EXTRACT="$WORK/dotnet-bundle"
mkdir -p "$EXTRACT"
DOTNET_BUNDLE_EXTRACT_BASE_DIR="$EXTRACT" "$BUNDLE/PMDO" -asset "$ASSET/" -appdata "$APPDATA/" >/dev/null 2>&1 || true
for target in "$EXTRACT"/PMDO/*/libSDL2-2.0.so.0; do
  cp "$BUNDLE/libSDL2-2.0.so.0" "$target"
done

echo "== 6. liste des zones à tester =="
if [ -n "${PMDO_MAPGEN_VALIDATOR_SPEC:-}" ]; then
  ZONES="$PMDO_MAPGEN_VALIDATOR_SPEC"
else
  ZONES="$(python3 - "$MOD_SRC" <<'PY'
import json, os, sys
root = sys.argv[1]
d = os.path.join(root, "DungeonDefs", "canonical")
ids = sorted(json.loads(open(os.path.join(d, f), encoding="utf-8-sig").read())["id"]
             for f in os.listdir(d))
print(",".join(ids))
PY
)"
fi

echo "== 7. génération réelle par le moteur ($ITER itération(s)) =="
rm -f "$OUT"
env DOTNET_BUNDLE_EXTRACT_BASE_DIR="$EXTRACT" \
    LD_LIBRARY_PATH="$BUNDLE" \
    SDL_VIDEODRIVER=offscreen SDL_AUDIODRIVER=dummy \
    PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY=1 SDL_OPENGL_ES_DRIVER=1 \
    SDL_VIDEO_GL_DRIVER="$BUNDLE/libGLESv2.so" SDL_VIDEO_EGL_DRIVER="$BUNDLE/libEGL.so" \
    FNA3D_FORCE_DRIVER=OpenGL FNA3D_OPENGL_FORCE_ES3=1 \
    ANGLE_DEFAULT_PLATFORM=vulkan VK_ICD_FILENAMES="$BUNDLE/vk_swiftshader_icd.absolute.json" \
    PMDO_MAPGEN_VALIDATOR="$ZONES" PMDO_MAPGEN_ITER="$ITER" PMDO_MAPGEN_OUT="$OUT" \
    "$BUNDLE/PMDO" -asset "$ASSET/" -appdata "$APPDATA/" -quest "$MOD_NAME" \
    > "$WORK/engine.log" 2>&1 &
PID=$!
# Le jeu reste au menu une fois la validation finie : on l'arrête sur la ligne terminale.
for _ in $(seq 1 7200); do
  grep -q '"event":"end"' "$OUT" 2>/dev/null && break
  kill -0 "$PID" 2>/dev/null || break
  sleep 1
done
kill "$PID" 2>/dev/null || true
wait "$PID" 2>/dev/null || true

echo "== 8. rapport =="
python3 "$HERE/summarize_engine_mapgen.py" "$OUT" "$WORK/mapgen_report.md"
grep -q '"event":"end"' "$OUT"
tail -3 "$WORK/mapgen_report.md"
