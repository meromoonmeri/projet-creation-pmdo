#!/usr/bin/env python3
"""Écrit un WORKFLOW.md de chantier pour chaque lot de la série (entrée, fin, arène, zone).

Le fichier est déterministe : relancer l'outil l'écrase. Ne pas y mettre de notes de
session irremplaçables — celles-ci vont dans STATUS.md / JOURNAL.

    python3 OUTILS/ecrire_workflows_lots.py
"""
from __future__ import annotations

import ast
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "source"
SERIE = SOURCE / "methode_serie_sud_nord"

PREFIXES = (
    "entree_",
    "fin_",
    "arene_",
    "zone_",
)
EXTRA = {"colonnes_lances_v1", "ruines_zarbi_v1"}

# Lots dont le WORKFLOW est rédigé à la main (gabarit, carte suivante) : ne pas écraser.
GARDER = {
    "entree_jungle_sud_nord_v1",
    "fin_clairiere_tropicale_v1",
}


def assign(tree: ast.AST, name: str) -> str | None:
    for node in tree.body:
        if isinstance(node, ast.Assign):
            for t in node.targets:
                if isinstance(t, ast.Name) and t.id == name:
                    if isinstance(node.value, ast.Constant):
                        return str(node.value.value)
        if isinstance(node, ast.Assign) and isinstance(node.value, ast.Tuple):
            ids = [t.id for t in node.targets if isinstance(t, ast.Tuple) for t in t.elts if isinstance(t, ast.Name)]
            # W, H = 768, 576
            if isinstance(node.targets[0], ast.Tuple):
                names = [e.id for e in node.targets[0].elts if isinstance(e, ast.Name)]
                vals = []
                for e in node.value.elts:
                    if isinstance(e, ast.Constant):
                        vals.append(e.value)
                    else:
                        vals.append(None)
                if name in names and len(names) == len(vals):
                    v = vals[names.index(name)]
                    if v is not None:
                        return str(v)
    return None


def first_assign_re(text: str, name: str) -> str:
    m = re.search(rf"^{name}\s*=\s*'([^']+)'", text, re.M)
    if m:
        return m.group(1)
    m = re.search(rf"^{name}\s*=\s*\"([^\"]+)\"", text, re.M)
    if m:
        return m.group(1)
    return ""


def wh(text: str) -> tuple[str, str]:
    m = re.search(r"^W,\s*H\s*=\s*(\d+),\s*(\d+)", text, re.M)
    if m:
        return m.group(1), m.group(2)
    return "", ""


def gen_files(text: str) -> list[str]:
    files = re.findall(r"'file':\s*'([^']+)'", text)
    seen, out = set(), []
    for f in files:
        if f not in seen:
            seen.add(f)
            out.append(f)
    return out


def ref_hint(text: str, pack: str) -> str:
    for pat in (
        r"REF\s*=\s*R\s*/\s*'([^']+)'",
        r"REF\s*=\s*'([^']+)'",
        r"REF_NAME\s*=\s*'([^']+)'",
    ):
        m = re.search(pat, text)
        if m:
            return m.group(1)
    m = re.search(r"`([^`]+\.png)`", pack)
    return m.group(1) if m else "voir README_PACK.md / GEN"


def kind(name: str) -> str:
    if name.startswith("entree_"):
        return "entrée sud → nord"
    if name.startswith("fin_"):
        return "fin de donjon / arène"
    if name.startswith("arene_"):
        return "arène"
    if name.startswith("zone_"):
        return "zone"
    if name == "colonnes_lances_v1":
        return "zone (colonnes / ruines)"
    if name == "ruines_zarbi_v1":
        return "zone (ruines Zarbi)"
    return "chantier"


def resume(doc: str | None, pack: str) -> str:
    if doc:
        para = doc.strip().split("\n\n", 1)[0]
        lines = [ln.strip() for ln in para.splitlines() if ln.strip()]
        return " ".join(lines)[:900]
    if pack:
        for ln in pack.splitlines():
            if ln.startswith("#") or not ln.strip():
                continue
            return ln.strip()[:900]
    return "Voir README_PACK.md et la docstring de build.py."


def render(lot: Path) -> str:
    build = lot / "build.py"
    text = build.read_text(encoding="utf-8", errors="replace") if build.exists() else ""
    pack = (lot / "README_PACK.md").read_text(encoding="utf-8", errors="replace") if (lot / "README_PACK.md").exists() else ""
    doc = None
    if text:
        try:
            doc = ast.get_docstring(ast.parse(text))
        except SyntaxError:
            doc = None
    pfx = first_assign_re(text, "PFX")
    ns = first_assign_re(text, "NAMESPACE")
    asset = first_assign_re(text, "ASSET")
    w, h = wh(text)
    gens = gen_files(text)
    ref = ref_hint(text, pack)
    files = sorted(p.name for p in lot.iterdir() if p.is_file())
    has_test = "test_build.py" in files
    has_pkg = "package.py" in files
    has_verify = "verify.py" in files
    has_pack = "README_PACK.md" in files
    has_status = "STATUS.md" in files
    tests = []
    if has_test:
        tests.append(f".venv/bin/python -m unittest source.{lot.name}.test_build -v")
    if has_verify:
        tests.append(f".venv/bin/python source/{lot.name}/verify.py")
    if has_pkg:
        tests.append(f".venv/bin/python source/{lot.name}/package.py")
    ident = []
    if pfx:
        ident.append(f"- **Préfixe** : `{pfx}`")
    if ns:
        ident.append(f"- **Namespace** : `{ns}`")
    if asset:
        ident.append(f"- **Asset Ground** : `{asset}`")
    if w and h:
        ident.append(f"- **Format** : {w} × {h} px")
    ident.append(f"- **Type** : {kind(lot.name)}")
    ident.append(f"- **Référence** : `{ref}`")
    ident.append("- **Méthode** : rendu généré référencé (pas des tuiles natives), sauf mention contraire dans README_PACK.")
    bruts = "- *(liste `GEN` absente du builder — voir la docstring)*"
    if gens:
        bruts = "\n".join(f"- `{g}`" for g in gens)
    cmds = [
        f".venv/bin/python source/{lot.name}/build.py",
        *tests,
    ]
    notice = "Notice livrée : `README_PACK.md`." if has_pack else "Pas de `README_PACK.md` dans ce chantier."
    status = "État : `STATUS.md`." if has_status else "Pas de `STATUS.md` : `art_approved: false`, `runtime_tested: false` par défaut de série."
    return f"""# WORKFLOW — `{lot.name}`

Chantier de la **série sud → nord / arènes / zones**. Procédure de session :
[WORKFLOW.md](../../WORKFLOW.md) · méthode de série : [methode_serie_sud_nord/](../methode_serie_sud_nord/).

## Identité

{chr(10).join(ident)}

## Relancer

Les **bruts** (`source/{lot.name}/bruts/`) et le **rip** ne sont pas dans cette extraction.
Les récupérer depuis `meromoonmeri/projet-pmdo` (voir `MANIFESTE_EXTRACTION.md`) avant le build.

```sh
python3 -m venv .venv
.venv/bin/pip install Pillow==12.3.0 numpy==2.4.0 scipy==1.17.0
{chr(10).join(cmds)}
```

Un rebuild réécrit l'ORA (horodatages ZIP) : restaurer le fichier s'il n'a pas d'autre changement.
Les tests relisent `.cache/{lot.name}/` : lancer `build.py` avant `test_build`.

## Bruts attendus (`GEN`)

{bruts}

## Fichiers de méthode ici

{', '.join(f'`{f}`' for f in files) or '*(vide)*'}

## Non extraits

PNG de `bruts/`, rendus de `renders/{lot.name}/` (hors `README.md` / `manifest.json`),
aperçu HTML racine, ZIP PMDO. Récupération : `OUTILS/extraire_depuis_projet-pmdo.py --seulement source/{lot.name} --avec-media`.

## Notes du builder

{resume(doc, pack)}

{notice} {status}
"""


def lots() -> list[Path]:
    out = []
    for d in sorted(SOURCE.iterdir()):
        if not d.is_dir():
            continue
        if d.name in EXTRA or d.name.startswith(PREFIXES):
            if (d / "build.py").exists():
                out.append(d)
    return out


def main() -> None:
    n = 0
    for lot in lots():
        if lot.name in GARDER and (lot / "WORKFLOW.md").exists():
            print(f"garde  {lot.name}")
            continue
        (lot / "WORKFLOW.md").write_text(render(lot), encoding="utf-8")
        n += 1
        print(f"écrit  {lot.name}")
    print(f"{n} WORKFLOW.md écrits")


if __name__ == "__main__":
    main()
