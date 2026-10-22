#!/usr/bin/env bash
# Restore and gate the ignored exact-PMDO 0.8.12 validation environment.
#
# Safety contract:
# - authenticated GitHub access is used for absent upstream inputs;
# - every destination is create-only;
# - any existing mismatched file, checkout, extraction, or build aborts;
# - temporary paths are retained on failure for diagnosis; and
# - the original .NET extraction is preserved separately from the patched copy.
set -euo pipefail
IFS=$'\n\t'

ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"
case $(git branch --show-current) in
  arena/019ff05e-new-era-abyss-to-ascension-v4|arena/019ff57e-new-era-abyss-to-ascension-v4|arena/01a0159e-new-era-abyss-to-ascension-v4|arena/01a0357e-new-era-abyss-to-ascension-v4) ;;
  *)
    echo "ERROR: run on the Agent A reference branch or this Arena continuation branch" >&2
    exit 2
    ;;
esac

PMDO_ARCHIVE_SHA=c64f72afd27b96d5a870f71e44d05ee1e952909e86b9a53d0479163763c61577
PMDO_EXE_SHA=faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327
ROM_SHA=0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd
DUMP_ARCHIVE_SHA=956ad1047c8e66ea545c26033119e7e2fc3c1ff614ecfd37f96f57912178eb17
# GitHub codeload recompressed the same locked commit in August 2026. Both
# authenticated transports extract to the exact tree manifest below.
DUMP_ARCHIVE_SHA_RECOMPRESSED=216d97a6757782b540b657f3684a9342bda00fd233b2ecae0a240e855f0a96ce
DUMP_TREE_MANIFEST_SHA=42be740813125641bb5c3a15adefcb24b53e70fa5401863e3913b77ea0c2356d
EXTRACTION_TREE_MANIFEST_SHA=931c9e0363b6dc0936502e9fc58b61fb705a1dd07d9f25861b635c542bba00a5
CANDIDATE_TREE_MANIFEST_SHA=dbf91db99f988f596d32869a5eaf73e85c3de52688d72a7e303304ad8e387184
CANDIDATE_REPORT_SHA=91f3b460b3e3b7689bc608ece2006cb6103d653bcdc22ad028f4172c3a1b0fdc
CANDIDATE_AUDIT_SHA=2434d193ed48596314fe4c188da2b3800d7145f6189086c25ed57b3757acd43b
PLAN_SHA=dcf498ae5f8970e15e44e044d000b6f28b342eae5e23f401516a9bb2738c0cb0
# The historical runtime logs use an em dash in the NREProbe line. The fixed
# Arena continuation currently contains an authenticated ASCII-hyphen source
# variant in main.lua; accept it only with both exact current-source and output
# hashes. Never normalize either log silently.
INDEX_LOG_SHA_HISTORICAL=3df47e3be040b124c5768b076c89fb586ff4b807890f154b22387667069c8ab8
INDEX_LOG_SHA_CURRENT=ba292fb1338fd8c41e24943f5ed66065d47e9ef26f45a38e5efa7be95a7f5fbb
CURRENT_MAIN_LUA_SHA=8add81a133b5dbd5995c17cd98b9b5dc7aec8ce6c636d8e4d1a8dedcde31481d
# main.lua a été restauré à l'état canonique verrouillé 0f691fa3 (commit
# 2c08bc72, lockfile ch1_5_lockfile.py). L'index zone produit est identique
# octet à octet (INDEX_LOG_SHA_CURRENT) : accepter aussi ce sha canonique.
LOCKED_MAIN_LUA_SHA=04f679b228d30b0d5bbc94dfafe1b0bc014500d23ec5f6e19883ab3c80ec8be3
SDL_ORIGINAL_SHA=52cf4d7fa12c1ee9a96ce875fa79da3eae7a901965f02e1ca1d4238bd5dc549e
SDL_PATCHED_SHA=2cec7b5f9603a8a856a94b3a5e4fb5bd5e93e3ed0d04b85431625d5acb14e71f
SDL_PATCH_SHA=7fb310776961e5a6a30cb9bc4550a070d3eb284b3813ee03406e418e60119f6f
SDL_COMMIT=793a0681a92d156733fa3aaa174651dc7345cc5f
RUNTIME_COMMIT=61c005e1dc9fd4eee6e6e7fcde77364de33d291e
PORT_COMMIT=b441d467091a1678218168558fa480a3d8292012
ANGLE_COMMIT=3be040fab553c751ffcdc7ad8d806b95b8e52af8
PRET_COMMIT=bf0092d0e34fd8e49b859a0b5f96f00740faa42d
DUMP_COMMIT=9d864d1425f002b051e7a54fffc639988d8ef9c9
mkdir -p .runtime-cache/downloads .runtime-cache/recovery-sources \
  .runtime-cache/pmdo-headless-bundle .runtime-cache/recovery \
  .runtime-cache/build .runtime-cache/tooling

fail() { echo "ERROR: $*" >&2; exit 1; }
actual_sha() { sha256sum "$1" | cut -d' ' -f1; }
verify_file() {
  local path=$1 expected_sha=$2 expected_bytes=${3:-}
  [[ -f $path ]] || fail "required file missing: $path"
  [[ $(actual_sha "$path") == "$expected_sha" ]] || fail "SHA-256 mismatch: $path"
  if [[ -n $expected_bytes ]]; then
    [[ $(stat -c %s "$path") == "$expected_bytes" ]] || fail "size mismatch: $path"
  fi
  echo "FILE_PASS $path"
}
verify_dump_archive_transport() {
  local path=$1 digest bytes
  [[ -f $path ]] || fail "required file missing: $path"
  digest=$(actual_sha "$path"); bytes=$(stat -c %s "$path")
  if [[ $digest == "$DUMP_ARCHIVE_SHA" && $bytes == 338722101 ]] || \
     [[ $digest == "$DUMP_ARCHIVE_SHA_RECOMPRESSED" && $bytes == 338682930 ]]; then
    echo "DUMP_TRANSPORT_PASS $path $digest"
  else
    fail "unrecognized DumpAsset transport: $path sha=$digest bytes=$bytes"
  fi
}
verify_runtime_index_log() {
  local path=$1 actual main_sha
  actual=$(actual_sha "$path")
  if [[ $actual == "$INDEX_LOG_SHA_HISTORICAL" ]]; then
    verify_file "$path" "$INDEX_LOG_SHA_HISTORICAL" 393
    return
  fi
  main_sha=$(actual_sha Data/Script/halcyon/main.lua)
  if [[ $actual == "$INDEX_LOG_SHA_CURRENT" ]] \
     && [[ $main_sha == "$CURRENT_MAIN_LUA_SHA" || $main_sha == "$LOCKED_MAIN_LUA_SHA" ]]; then
    verify_file "$path" "$INDEX_LOG_SHA_CURRENT" 392
    echo "INDEX_LOG_SOURCE_VARIANT_PASS main.lua=$main_sha"
    return
  fi
  fail "runtime index log mismatch: $path sha=$actual main.lua=$main_sha"
}
copy_create_only() {
  local src=$1 dst=$2 expected_sha=$3 expected_bytes=${4:-}
  if [[ -e $dst ]]; then
    verify_file "$dst" "$expected_sha" "$expected_bytes"
    return
  fi
  local tmp="${dst}.copy.$$"
  [[ ! -e $tmp ]] || fail "temporary path already exists: $tmp"
  cp --reflink=auto "$src" "$tmp"
  verify_file "$tmp" "$expected_sha" "$expected_bytes"
  mv -n "$tmp" "$dst"
  verify_file "$dst" "$expected_sha" "$expected_bytes"
}
ensure_checkout() {
  local repo=$1 commit=$2 dst=$3
  if [[ ! -e $dst ]]; then
    command -v gh >/dev/null || fail "gh is required to restore $repo"
    gh auth status >/dev/null 2>&1 || fail "GitHub authentication is not connected"
    local tmp="${dst}.clone.$$"
    [[ ! -e $tmp ]] || fail "temporary path already exists: $tmp"
    timeout --signal=TERM --kill-after=15 900 gh repo clone "$repo" "$tmp" -- --depth 1
    if [[ $(git -C "$tmp" rev-parse HEAD) != "$commit" ]]; then
      # A pinned dependency may no longer be the repository's default-branch tip.
      # Fetch only the authenticated lock commit instead of accepting a newer HEAD.
      timeout --signal=TERM --kill-after=15 900 git -C "$tmp" fetch --depth 1 origin "$commit"
      git -C "$tmp" checkout --detach "$commit"
    fi
    [[ $(git -C "$tmp" rev-parse HEAD) == "$commit" ]] || fail "unexpected head for $repo"
    mv -n "$tmp" "$dst"
  fi
  [[ -d $dst/.git ]] || fail "not a Git checkout: $dst"
  [[ $(git -C "$dst" rev-parse HEAD) == "$commit" ]] || fail "checkout commit mismatch: $dst"
  echo "CHECKOUT_PASS $dst $commit"
}
make_tree_manifest() {
  local tree=$1 output=$2 exclude=${3:-}
  python3 - "$tree" "$output" "$exclude" <<'PY'
import hashlib, sys
from pathlib import Path
root, output, exclude = Path(sys.argv[1]), Path(sys.argv[2]), sys.argv[3]
tmp = output.with_name(output.name + '.tmp')
paths = (p for p in root.rglob('*') if p.is_file() and p.relative_to(root).as_posix() != exclude)
with tmp.open('w', encoding='utf-8', newline='\n') as stream:
    for path in sorted(paths, key=lambda p: p.relative_to(root).as_posix()):
        digest = hashlib.sha256()
        with path.open('rb') as source:
            while chunk := source.read(1024 * 1024):
                digest.update(chunk)
        stream.write(f'{digest.hexdigest()}  {path.relative_to(root).as_posix()}\n')
tmp.replace(output)
PY
}
verify_tree() {
  local tree=$1 manifest=$2 manifest_sha=$3 expected_count=$4 exclude=${5:-}
  local generated="${manifest}.verify.$$"
  make_tree_manifest "$tree" "$generated" "$exclude"
  [[ $(actual_sha "$generated") == "$manifest_sha" ]] || fail "tree mismatch: $tree (details: $generated)"
  [[ $(wc -l < "$generated") == "$expected_count" ]] || fail "tree file count mismatch: $tree"
  if [[ -e $manifest ]]; then
    [[ $(actual_sha "$manifest") == "$manifest_sha" ]] || fail "tree manifest mismatch: $manifest"
  else
    mv -n "$generated" "$manifest"
  fi
  [[ -e $generated ]] && rm -f "$generated"
  echo "TREE_PASS $tree files=$expected_count"
}

# Authenticated pinned source recovery. Existing checkouts are only inspected.
ensure_checkout meromoonmeri/RUNTIMEPMDO "$RUNTIME_COMMIT" .runtime-cache/recovery-sources/RUNTIMEPMDO
ensure_checkout meromoonmeri/PMD-RED-PMDO-PORT "$PORT_COMMIT" .runtime-cache/recovery-sources/PMD-RED-PMDO-PORT
ensure_checkout IsaacTalb/tiktok-wrapper "$ANGLE_COMMIT" .runtime-cache/recovery-sources/tiktok-wrapper
ensure_checkout libsdl-org/SDL "$SDL_COMMIT" .runtime-cache/src/SDL
ensure_checkout pret/pmd-red "$PRET_COMMIT" .runtime-cache/pmd-red-reference

copy_create_only .runtime-cache/recovery-sources/RUNTIMEPMDO/pmdc-linux-x64.zip \
  .runtime-cache/downloads/pmdc-linux-x64.zip "$PMDO_ARCHIVE_SHA" 77503089
copy_create_only ".runtime-cache/recovery-sources/PMD-RED-PMDO-PORT/Pokemon Mystery Dungeon - Red Rescue Team (Europe) (En,Fr,De,Es,It).gba" \
  .runtime-cache/downloads/pmdred-eu.gba "$ROM_SHA" 33554432

for entry in \
  'libEGL.so 600273ce12be556fc44d9dff9a14ce9c3aad84c560405cfafba2dae386987329 251064' \
  'libGLESv2.so ab560af215dbe4eb2f528cf1dd1c30f099c436d143e50fe8bb6bacb191187a3b 6437608' \
  'libvk_swiftshader.so 43a8214c29b5b2daf3efa82ff95d1c5b615f6a4c2ad2aacf459bd579b25c88dc 4565640' \
  'libvulkan.so.1 6be82e54960ba8243902667dbc8083b2200c5467402e571d7cd49fa325d42e26 6396248' \
  'vk_swiftshader_icd.json c9eef28b6b984fec220ef0abfecc40b502d46946706e47bfe97707027cb818bd 107'
do
  IFS=' ' read -r name digest bytes <<< "$entry"
  copy_create_only ".runtime-cache/recovery-sources/tiktok-wrapper/TikTok-linux-x64/$name" \
    ".runtime-cache/pmdo-headless-bundle/$name" "$digest" "$bytes"
done

# The codeload tarball is the only large source that is not duplicated as a
# checkout. GitHub CLI supplies authenticated bounded transport when absent.
DUMP_ARCHIVE=.runtime-cache/downloads/DumpAsset-${DUMP_COMMIT}.tar.gz
# Once the exact extracted tree exists, its locked 11,485-file manifest is the
# durable authority; a codeload gzip transport is not required on later runs.
if [[ ! -e .runtime-cache/DumpAsset ]]; then
  if [[ ! -e $DUMP_ARCHIVE ]]; then
    command -v gh >/dev/null || fail "gh is required to restore DumpAsset"
    gh auth status >/dev/null 2>&1 || fail "GitHub authentication is not connected"
    tmp="${DUMP_ARCHIVE}.download.$$"
    timeout --signal=TERM --kill-after=15 1800 gh api \
      -H 'Accept: application/vnd.github+json' \
      "repos/audinowho/DumpAsset/tarball/$DUMP_COMMIT" > "$tmp"
    verify_dump_archive_transport "$tmp"
    mv -n "$tmp" "$DUMP_ARCHIVE"
  fi
  verify_dump_archive_transport "$DUMP_ARCHIVE"
  tmp=".runtime-cache/DumpAsset.extract.$$"
  mkdir "$tmp"
  tar -xzf "$DUMP_ARCHIVE" -C "$tmp" --strip-components=1
  printf '%s\n' "$DUMP_COMMIT" > "$tmp/.source-commit"
  make_tree_manifest "$tmp" .runtime-cache/DumpAsset.tree-sha256.tmp.$$ .source-commit
  [[ $(actual_sha .runtime-cache/DumpAsset.tree-sha256.tmp.$$) == "$DUMP_TREE_MANIFEST_SHA" ]] || fail "DumpAsset extraction mismatch"
  mv -n .runtime-cache/DumpAsset.tree-sha256.tmp.$$ .runtime-cache/DumpAsset.tree-sha256
  mv -n "$tmp" .runtime-cache/DumpAsset
fi
[[ $(cat .runtime-cache/DumpAsset/.source-commit) == "$DUMP_COMMIT" ]] || fail "DumpAsset source marker mismatch"
verify_tree .runtime-cache/DumpAsset .runtime-cache/DumpAsset.tree-sha256 "$DUMP_TREE_MANIFEST_SHA" 11485 .source-commit

# Extract the exact PMDO apphost create-only from the authenticated archive.
if [[ ! -e .runtime-cache/pmdo-headless-bundle/PMDO ]]; then
  tmp=.runtime-cache/pmdo-headless-bundle/PMDO.extract.$$
  unzip -p .runtime-cache/downloads/pmdc-linux-x64.zip PMDO/PMDO > "$tmp"
  chmod 755 "$tmp"
  verify_file "$tmp" "$PMDO_EXE_SHA" 116173385
  mv -n "$tmp" .runtime-cache/pmdo-headless-bundle/PMDO
fi
verify_file .runtime-cache/pmdo-headless-bundle/PMDO "$PMDO_EXE_SHA" 116173385

# Absolute SwiftShader ICD is intentionally path-bound and checked after write.
ABS_ICD=.runtime-cache/pmdo-headless-bundle/vk_swiftshader_icd.absolute.json
if [[ ! -e $ABS_ICD ]]; then
  python3 - "$ABS_ICD.tmp.$$" <<'PY'
import json, sys
from pathlib import Path
bundle = Path('.runtime-cache/pmdo-headless-bundle').resolve()
data = json.loads((bundle / 'vk_swiftshader_icd.json').read_text())
data['ICD']['library_path'] = str(bundle / 'libvk_swiftshader.so')
Path(sys.argv[1]).write_text(json.dumps(data, separators=(',', ':')) + '\n')
PY
  mv -n "$ABS_ICD.tmp.$$" "$ABS_ICD"
fi
verify_file "$ABS_ICD" 9d3b059ac8534ecf3ad2f528d3f81a50b18f1af5336c49bff2ea4a4689d716f7 177

# Apply the tracked SDL adaptation only in the ignored pinned source checkout.
verify_file dev/tools/patches/pmdo-0.8.12-headless-sdl.patch "$SDL_PATCH_SHA" 3380
if git -C .runtime-cache/src/SDL apply --check "$ROOT/dev/tools/patches/pmdo-0.8.12-headless-sdl.patch" 2>/dev/null; then
  git -C .runtime-cache/src/SDL apply "$ROOT/dev/tools/patches/pmdo-0.8.12-headless-sdl.patch"
elif ! git -C .runtime-cache/src/SDL apply --reverse --check "$ROOT/dev/tools/patches/pmdo-0.8.12-headless-sdl.patch" 2>/dev/null; then
  fail "SDL source is neither pristine nor exactly patched"
fi
[[ $(git -C .runtime-cache/src/SDL diff --name-only | tr '\n' ' ') == \
  'src/video/offscreen/SDL_offscreenevents.c src/video/offscreen/SDL_offscreenopengles.c ' ]] || fail "unexpected SDL source modifications"

SDL_BUILD=.runtime-cache/build/SDL-headless
SDL_BUILT=$SDL_BUILD/libSDL2-2.0.so.0.3000.3
if [[ ! -e $SDL_BUILT ]]; then
  CMAKE=.runtime-cache/tooling/cmake/cmake/data/bin/cmake
  if [[ ! -x $CMAKE ]]; then
    tool_tmp=.runtime-cache/tooling/cmake.install.$$
    python3 -m pip install --target "$tool_tmp" --no-compile 'cmake==3.25.0'
    [[ $($tool_tmp/cmake/data/bin/cmake --version | head -1) == 'cmake version 3.25.0' ]] || fail "unexpected CMake version"
    [[ ! -e .runtime-cache/tooling/cmake ]] || fail "existing CMake tooling is incomplete"
    mv -n "$tool_tmp" .runtime-cache/tooling/cmake
  fi
  build_tmp="${SDL_BUILD}.build.$$"
  "$CMAKE" -S .runtime-cache/src/SDL -B "$build_tmp" \
    -DSDL_SHARED=ON -DSDL_STATIC=OFF -DSDL_TEST=OFF -DCMAKE_BUILD_TYPE=Release
  "$CMAKE" --build "$build_tmp" --parallel 4
  built_tmp=$(find "$build_tmp" -type f -name 'libSDL2-2.0.so.0*' -print -quit)
  verify_file "$built_tmp" "$SDL_PATCHED_SHA" 2013784
  mv -n "$build_tmp" "$SDL_BUILD"
fi
verify_file "$SDL_BUILT" "$SDL_PATCHED_SHA" 2013784

# Force one single-file expansion into a temporary original tree if needed.
if [[ ! -e .runtime-cache/dotnet-original ]]; then
  extract_tmp=.runtime-cache/dotnet-original.extract.$$
  mkdir "$extract_tmp"
  set +e
  DOTNET_BUNDLE_EXTRACT_BASE_DIR="$ROOT/$extract_tmp" \
    timeout --signal=TERM --kill-after=3 15 .runtime-cache/pmdo-headless-bundle/PMDO \
    -asset "$ROOT/.runtime-cache/DumpAsset/" -appdata "$ROOT/.runtime-cache/dotnet-extraction-appdata/" \
    -quest __extraction_only__ >.runtime-cache/dotnet-extraction.log 2>&1
  set -e
  original_sdl=$(find "$extract_tmp/PMDO" -type f -name libSDL2-2.0.so.0 -print -quit)
  [[ -n $original_sdl ]] || fail "PMDO single-file extraction did not complete"
  verify_file "$original_sdl" "$SDL_ORIGINAL_SHA" 2526784
  mv -n "$extract_tmp" .runtime-cache/dotnet-original
fi
original_sdl=$(find .runtime-cache/dotnet-original/PMDO -type f -name libSDL2-2.0.so.0 -print -quit)
[[ -n $original_sdl ]] || fail "original .NET SDL is missing"
verify_file "$original_sdl" "$SDL_ORIGINAL_SHA" 2526784
if [[ ! -e .runtime-cache/dotnet-headless ]]; then
  adapted_tmp=.runtime-cache/dotnet-headless.copy.$$
  cp -a --reflink=auto .runtime-cache/dotnet-original "$adapted_tmp"
  adapted_sdl=$(find "$adapted_tmp/PMDO" -type f -name libSDL2-2.0.so.0 -print -quit)
  cp "$SDL_BUILT" "$adapted_sdl.new"
  chmod --reference="$adapted_sdl" "$adapted_sdl.new"
  mv -f "$adapted_sdl.new" "$adapted_sdl"
  verify_file "$adapted_sdl" "$SDL_PATCHED_SHA" 2013784
  mv -n "$adapted_tmp" .runtime-cache/dotnet-headless
fi
adapted_sdl=$(find .runtime-cache/dotnet-headless/PMDO -type f -name libSDL2-2.0.so.0 -print -quit)
[[ -n $adapted_sdl ]] || fail "adapted .NET SDL is missing"
verify_file "$adapted_sdl" "$SDL_PATCHED_SHA" 2013784

# Exact isolated Python dependency environment.
if [[ ! -e .runtime-cache/test-venv ]]; then
  venv_tmp=.runtime-cache/test-venv.create.$$
  python3 -m venv "$venv_tmp"
  "$venv_tmp/bin/python" -m pip install --disable-pip-version-check -r dev/tools/requirements-pmdred.txt
  mv -n "$venv_tmp" .runtime-cache/test-venv
fi
.runtime-cache/test-venv/bin/python - <<'PY'
from importlib.metadata import version
assert version('Pillow') == '12.3.0'
assert version('skytemple-files') == '1.8.5'
assert version('lupa') == '2.8'
from PIL import Image
from lupa import LuaRuntime
import skytemple_files
print('PYTHON_COMPONENT_PASS Pillow=12.3.0 skytemple-files=1.8.5 lupa=2.8')
PY

# Deterministic EU-ROM normalized extraction, retaining any failed temporary run.
EXTRACTION=.runtime-cache/pmdred-eu-ground
if [[ ! -e $EXTRACTION ]]; then
  extraction_tmp="${EXTRACTION}.extract.$$"
  report_tmp=.runtime-cache/pmdred-eu-ground-manifest.json.tmp.$$
  .runtime-cache/test-venv/bin/python dev/tools/audit_pmdred_eu_rom.py \
    .runtime-cache/downloads/pmdred-eu.gba --report "$report_tmp" \
    --extract-dir "$extraction_tmp" --pret-map-bg .runtime-cache/pmd-red-reference/data/map_bg
  python3 - "$report_tmp" <<'PY'
import json, sys
from pathlib import Path
actual = json.loads(Path(sys.argv[1]).read_text())
expected = json.loads(Path('dev/docs/pmdred_eu/ground_manifest.json').read_text())
actual['authority']['source_filename'] = expected['authority']['source_filename']
actual['extraction']['performed'] = False
actual['extraction']['resource_count'] = 0
assert actual == expected
print('ROM_MANIFEST_SEMANTIC_PASS')
PY
  make_tree_manifest "$extraction_tmp" .runtime-cache/pmdred-eu-ground.tree-sha256.tmp.$$
  [[ $(actual_sha .runtime-cache/pmdred-eu-ground.tree-sha256.tmp.$$) == "$EXTRACTION_TREE_MANIFEST_SHA" ]] || fail "normalized extraction tree mismatch"
  mv -n .runtime-cache/pmdred-eu-ground.tree-sha256.tmp.$$ .runtime-cache/pmdred-eu-ground.tree-sha256
  mv -n "$extraction_tmp" "$EXTRACTION"
  mv -n "$report_tmp" .runtime-cache/pmdred-eu-ground-manifest.json
fi
verify_tree "$EXTRACTION" .runtime-cache/pmdred-eu-ground.tree-sha256 "$EXTRACTION_TREE_MANIFEST_SHA" 724

PLAN=.runtime-cache/pmdred-eu-reference-plan-v2.json
copy_create_only dev/docs/pmdred_eu/runtime_reference_plan_v2.json "$PLAN" "$PLAN_SHA"

# Regenerate all 219 candidates into a new destination and audit two complete
# local source cycles before making the destination visible.
CANDIDATES=.runtime-cache/pmdred-eu-remaining-regenerated-v201
if [[ ! -e $CANDIDATES ]]; then
  candidates_tmp="${CANDIDATES}.generate.$$"
  .runtime-cache/test-venv/bin/python dev/tools/convert_red_all.py \
    --source-dir "$EXTRACTION" --manifest dev/docs/pmdred_eu/ground_manifest.json \
    --conversion-set remaining --apply --output-root "$candidates_tmp" \
    --report "$candidates_tmp/conversion_report.json"
  verify_file "$candidates_tmp/conversion_report.json" "$CANDIDATE_REPORT_SHA"
  .runtime-cache/test-venv/bin/python dev/tools/audit_pmdred_remaining_candidates.py \
    --source-dir "$EXTRACTION" --candidate-root "$candidates_tmp" \
    --output "$candidates_tmp/audit.json"
  verify_file "$candidates_tmp/audit.json" "$CANDIDATE_AUDIT_SHA"
  python3 - "$candidates_tmp/audit.json" <<'PY'
import json, sys
report = json.load(open(sys.argv[1]))
summary = report['summary']
assert not report['failures'] and summary['failure_count'] == 0
assert summary['passing_candidate_count'] == 219
assert summary['all_graphical_tick_comparisons_exact']
assert summary['validated_local_cycle_count'] == 2
print('CANDIDATE_AUDIT_PASS')
PY
  make_tree_manifest "$candidates_tmp" .runtime-cache/pmdred-eu-remaining-regenerated-v201.tree-sha256.tmp.$$
  [[ $(actual_sha .runtime-cache/pmdred-eu-remaining-regenerated-v201.tree-sha256.tmp.$$) == "$CANDIDATE_TREE_MANIFEST_SHA" ]] || fail "candidate tree mismatch"
  mv -n .runtime-cache/pmdred-eu-remaining-regenerated-v201.tree-sha256.tmp.$$ .runtime-cache/pmdred-eu-remaining-regenerated-v201.tree-sha256
  mv -n "$candidates_tmp" "$CANDIDATES"
fi
verify_tree "$CANDIDATES" .runtime-cache/pmdred-eu-remaining-regenerated-v201.tree-sha256 "$CANDIDATE_TREE_MANIFEST_SHA" 440
verify_file "$CANDIDATES/conversion_report.json" "$CANDIDATE_REPORT_SHA"
verify_file "$CANDIDATES/audit.json" "$CANDIDATE_AUDIT_SHA"

# Bounded exact-engine component/import gate. The index command is deterministic
# and is checked against the historical evidence or the exact current-branch
# source variant above; neither output is normalized or accepted implicitly.
GATE=.runtime-cache/pmdred-eu-runtime-restoration-gate
if [[ ! -e $GATE ]]; then
  .runtime-cache/test-venv/bin/python dev/tools/build_pmdred_eu_runtime_fixture.py \
    --conversion-set remaining --candidate-root "$CANDIDATES" --plan "$PLAN" \
    --ids t01p07 --output "$GATE"
  BUNDLE=$ROOT/.runtime-cache/pmdo-headless-bundle
  env DOTNET_BUNDLE_EXTRACT_BASE_DIR="$ROOT/.runtime-cache/dotnet-headless" \
    LD_LIBRARY_PATH="$BUNDLE" SDL_VIDEODRIVER=offscreen SDL_AUDIODRIVER=dummy \
    SDL_VIDEO_GL_DRIVER="$BUNDLE/libGLESv2.so" SDL_VIDEO_EGL_DRIVER="$BUNDLE/libEGL.so" \
    PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY=1 PMDO_HEADLESS_DISMISS_SPLASH=1 \
    FNA3D_FORCE_DRIVER=OpenGL FNA3D_OPENGL_FORCE_ES3=1 ANGLE_DEFAULT_PLATFORM=vulkan \
    VK_ICD_FILENAMES="$BUNDLE/vk_swiftshader_icd.absolute.json" \
    timeout --signal=TERM --kill-after=5 300 "$BUNDLE/PMDO" \
    -asset "$GATE/asset/" -appdata "$GATE/appdata/" \
    -quest pmdred_eu_fixture -index zone >"$GATE/index.log" 2>&1
fi
verify_runtime_index_log "$GATE/index.log"

python3 - <<'PY'
import hashlib, json, subprocess
from datetime import datetime, timezone
from pathlib import Path
root = Path.cwd()
progress_path = Path('docs/pmdred_eu/pmdo_validation/progress.json')
next_ground = (
    json.loads(progress_path.read_text())['summary']['next_ground']
    if progress_path.is_file() else 't01p07'
)
status = {
    'schema': 'new-era.pmdred-eu-runtime-restoration-status.v1',
    'checked_at': datetime.now(timezone.utc).isoformat(timespec='seconds'),
    'result': 'PASS',
    'pmdo_version': '0.8.12',
    'next_ground': next_ground,
    'gates': {
        'pmdo_executable_sha256': hashlib.sha256(Path('.runtime-cache/pmdo-headless-bundle/PMDO').read_bytes()).hexdigest(),
        'eu_rom_sha256': hashlib.sha256(Path('.runtime-cache/downloads/pmdred-eu.gba').read_bytes()).hexdigest(),
        'sdl_patched_sha256': hashlib.sha256(next(Path('.runtime-cache/dotnet-headless/PMDO').rglob('libSDL2-2.0.so.0')).read_bytes()).hexdigest(),
        'candidate_count': 219,
        'normalized_resource_count': 724,
        'index_output_sha256': hashlib.sha256(Path('.runtime-cache/pmdred-eu-runtime-restoration-gate/index.log').read_bytes()).hexdigest()
    },
    'resume': [
        'bash dev/tools/restore_pmdred_eu_validation_runtime.sh',
        'python3 dev/tools/update_pmdred_eu_validation_progress.py --check',
        (
            f'cp docs/pmdred_eu/pmdo_validation/t01p07_exhaustive_pass/commands.sh .runtime-cache/{next_ground}-working-recipe.sh'
            if next_ground is not None
            else 'all canonical archive-backed Grounds are checkpointed; continue with dungeon-backed and narrative gates'
        ),
    ]
}
path = Path('.runtime-cache/recovery/runtime_restoration_status.json')
path.write_text(json.dumps(status, indent=2) + '\n')
print('RUNTIME_RESTORATION_STATUS', path)
print('PMDRED_EU_RUNTIME_RESTORATION_PASS next=' + str(next_ground))
PY
