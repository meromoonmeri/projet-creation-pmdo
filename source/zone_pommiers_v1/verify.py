#!/usr/bin/env python3
"""Vérifications indépendantes ZPO1; ne lance pas le moteur PMDO.
Usage : .venv/bin/python source/zone_pommiers_v1/verify.py
"""
from pathlib import Path
import importlib.util, json, subprocess, sys, tempfile, zipfile
from xml.etree import ElementTree as ET

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
LOT = 'zone_pommiers_v1'
OUT = ROOT / 'renders' / LOT
STAGE = ROOT / '.cache' / LOT / 'zone_pommiers'
PFX = 'ZPO1'


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f'Module introuvable: {path}')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main():
    manifest_path = OUT / 'manifest.json'
    if not manifest_path.exists():
        subprocess.run([sys.executable, str(HERE / 'build.py')], cwd=ROOT, check=True)
    subprocess.run([sys.executable, '-m', 'unittest', f'source.{LOT}.test_build', '-v'], cwd=ROOT, check=True)

    manifest = json.loads(manifest_path.read_text(encoding='utf-8'))
    assert manifest['size_px'] == [768, 576]
    assert manifest['grid_cells'] == [96, 72]
    assert manifest['pmdo']['version'] == '0.8.12.0'
    assert manifest['pmdo']['runtime_tested'] is False
    assert manifest['pmdo']['warp'] == 'aucun'
    assert manifest['pmdo']['exit'] == 'aucune'
    assert manifest['scene_loop_ticks'] == 240
    assert all(v['distance'] < 35 for v in manifest['fidelite_rip'].values() if isinstance(v, dict))
    assert manifest['pommes']['nombre'] == 8
    assert manifest['pollen']['nombre'] == 12

    with zipfile.ZipFile(OUT / f'{PFX}_zone_pommiers_calques.ora') as archive:
        assert archive.read('mimetype') == b'image/openraster'
        assert {'stack.xml', 'mergedimage.png', 'Thumbnails/thumbnail.png'} <= set(archive.namelist())
        ET.fromstring(archive.read('stack.xml'))

    mod_xml = ET.parse(STAGE / 'Mod.xml').getroot()
    assert mod_xml.findtext('Namespace') == manifest['namespace']
    assert mod_xml.findtext('GameVersion') == '0.8.12.0'

    temp_root = ROOT / '.cache'
    temp_root.mkdir(parents=True, exist_ok=True)
    installer = load_module('installer_zpo1_verify', STAGE / 'INSTALLER.py')
    with tempfile.TemporaryDirectory(prefix='zpo1_install_dry_run_', dir=temp_root) as temporary:
        target = Path(temporary)
        (target / 'Mod.xml').write_bytes((STAGE / 'Mod.xml').read_bytes())
        installer.install(STAGE, target, dry_run=True, namespace=manifest['namespace'])
        assert (target / 'Mod.xml').is_file()
        assert not (target / 'Content').exists(), 'dry-run ne doit rien écrire'
        assert not (target / 'Data').exists(), 'dry-run ne doit rien écrire'

    print('PASS — calques, pommes/pollen, partition, accès 16x16, ORA, Ground/.tile et installateur dry-run vérifiés.')
    print("NOTE — aucune validation graphique ou de gameplay dans PMDO n'a été exécutée.")


if __name__ == '__main__':
    main()
