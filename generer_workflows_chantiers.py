#!/usr/bin/env python3
"""Génère les fiches WORKFLOW.md manquantes dans source/*/ à partir des fichiers et manifests réels de chaque chantier.

Usage :
  .venv/bin/python OUTILS/generer_workflows_chantiers.py [--force]
"""
from pathlib import Path
import argparse, json

R = Path(__file__).resolve().parents[1]
SRC = R / 'source'
RENDERS = R / 'renders'
SKIP_DIRS = {'serveur_apercus', 'outil_maps_pmdsky'}
HANDCRAFTED_WORKFLOWS = {
    'cafe_multietage_v3',
    'cafe_spinda_reseau_v4',
    'cafe_spinda_revisite_v5',
    'dungeon_autotiles_v1',
    'entree_tour_temporelle_sud_nord_v1',
    'entree_tour_temporelle_sud_nord_v2',
    'entree_vallon_fleuri_sud_nord_v1',
    'layouts_magenta_v1',
    'zones_pmd_20_v1',
}


def find_apercu(lot: str) -> str | None:
    exact = R / f'apercu_{lot}.html'
    if exact.exists():
        return exact.name
    stem = lot.rsplit('_v', 1)[0]
    for p in sorted(R.glob('apercu_*.html')):
        if stem in p.stem:
            return p.name
    return None


def describe_chantier(d: Path) -> str:
    lot = d.name
    rdir = RENDERS / lot
    manifest_path = rdir / 'manifest.json'
    m_raw = json.loads(manifest_path.read_text(encoding='utf-8')) if manifest_path.exists() else {}
    m = m_raw if isinstance(m_raw, dict) else (m_raw[0] if (isinstance(m_raw, list) and m_raw and isinstance(m_raw[0], dict)) else {})

    pfx = m.get('prefix', '—')
    size_px = m.get('size_px') or m.get('dimensions_px') or '—'
    grid_8px = m.get('grid_8px') or '—'
    fmt = m.get('format', '—')
    method = m.get('method', 'Pipeline Python reproductible')
    ref_da = m.get('reference_da')
    if isinstance(ref_da, dict):
        ref_str = ref_da.get('file') or ref_da.get('code_rom') or json.dumps(ref_da, ensure_ascii=False)
    elif isinstance(ref_da, str):
        ref_str = ref_da
    else:
        refs = sorted((d / 'reference').glob('*')) if (d / 'reference').exists() else []
        ref_str = ', '.join(p.name for p in refs[:5]) if refs else '—'

    scripts = [p.name for p in sorted(d.glob('*.py'))]
    bruts = [p.name for p in sorted((d / 'bruts').glob('*.png'))] if (d / 'bruts').exists() else []
    apercu = find_apercu(lot)

    cmds = []
    if (d / 'build.py').exists():
        cmds.append(f'.venv/bin/python source/{lot}/build.py')
    elif (d / 'generate_all.py').exists():
        cmds.append(f'.venv/bin/python source/{lot}/generate_all.py')
    if (d / 'test_build.py').exists():
        cmds.append(f'.venv/bin/python source/{lot}/test_build.py')
    elif (d / 'verify.py').exists():
        cmds.append(f'.venv/bin/python source/{lot}/verify.py')
    if (d / 'package.py').exists():
        cmds.append(f'.venv/bin/python source/{lot}/package.py')

    lines = [
        f'# Workflow du chantier `{lot}`',
        '',
        f'Fiche opérationnelle du chantier `source/{lot}/` (voir aussi le pipeline général dans [`../../WORKFLOW.md`](../../WORKFLOW.md)).',
        '',
        '## 1. Caractéristiques du lot',
        '',
        f'- **Lot** : `{lot}`',
        f'- **Préfixe `.tile`** : `{pfx}`',
        f'- **Format / dimensions** : `{fmt}` (`{size_px}` px, grille 8 px `{grid_8px}`)',
        f'- **Référence DA** : `{ref_str}`',
        f'- **Méthode** : {method}',
        f'- **Scripts présents** : {", ".join(f"`{s}`" for s in scripts) if scripts else "—"}',
        f'- **Bruts (`bruts/`)** : {", ".join(f"`{b}`" for b in bruts) if bruts else "—"}',
        f'- **Sorties (`renders/{lot}/`)** : `{"oui" if rdir.exists() else "non"}`',
        f'- **Aperçu HTML** : {f"[`{apercu}`](../../{apercu})" if apercu else "—"}',
        '',
        '## 2. Commandes d\'exécution',
        '',
        'Depuis la racine du dépôt :',
        '',
        '```bash',
        *(cmds if cmds else [f'# Consulter les scripts dans source/{lot}/']),
        '```',
        '',
        '## 3. Contrôles de qualité avant validation',
        '',
        '- Vérifier que chaque calque PNG dans `renders/' + lot + '/calques/` est un multiple exact de `8 px` sans pixel `#FF00FF` résiduel.',
        '- Ouvrir les planches `renders/' + lot + '/review/` avec `read_file` pour contrôler visuellement l\'absence de couture ou de bavure.',
        '- S\'assurer que `manifest.json` conserve `art_approved: false` et `runtime_tested: false` tant que la validation humaine et le test en moteur PMDO `0.8.12` n\'ont pas été réalisés.',
        '',
    ]
    return '\n'.join(lines)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--force', action='store_true', help='Écraser les WORKFLOW.md existants')
    args = ap.parse_args()

    created, skipped = [], []
    for d in sorted(SRC.iterdir()):
        if not d.is_dir() or d.name in SKIP_DIRS:
            continue
        wf = d / 'WORKFLOW.md'
        if d.name in HANDCRAFTED_WORKFLOWS or (wf.exists() and not args.force):
            skipped.append(d.name)
            continue
        wf.write_text(describe_chantier(d), encoding='utf-8')
        created.append(d.name)
    print(f'WORKFLOW.md créés : {len(created)} ; conservés tels quels : {len(skipped)} ({", ".join(skipped)})')


if __name__ == '__main__':
    main()
