"""Régénération OPTIONNELLE du rip : gh authentifié + skytemple-files==1.8.5.
Le build normal reste hors ligne, avec le PNG/provenance versionnés.
Ne lance pas la CLI rom --only qui réécrirait l'index partagé.
"""
from pathlib import Path
import base64
import hashlib
import importlib.util
import json
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
COMMIT = 'c8073235b39746a7ee74e6cea16c730bd91a1e67'
CODE = 'D41P41A'


def main():
    from skytemple_files.common.types.file_types import FileType
    cache = ROOT / '.cache' / HERE.name / 'rom_reference'
    cache.mkdir(parents=True, exist_ok=True)
    provenance = []

    def get(path):
        data = json.loads(subprocess.check_output(
            ['gh', 'api', f'repos/pret/pmd-sky/contents/{path}?ref={COMMIT}'], text=True))
        raw = base64.b64decode(data['content'])
        (cache / Path(path).name).write_bytes(raw)
        provenance.append({'path': path, 'git_blob': data['sha'],
                           'sha256': hashlib.sha256(raw).hexdigest()})
        return raw

    table = FileType.BG_LIST_DAT.deserialize(get('files/language-specific/US/MAP_BG/bg_list.dat'))
    matches = [(i, e) for i, e in enumerate(table.level) if e.bma_name.upper() == CODE]
    assert len(matches) == 1
    i, e = matches[0]
    entry = {'code': CODE, 'bg_list_index': i, 'bma': e.bma_name, 'bpc': e.bpc_name,
             'bpl': e.bpl_name, 'bpa': list(e.bpa_names)}
    for ext in ('bma', 'bpc', 'bpl'):
        get(f'files/MAP_BG/{entry[ext].lower()}.{ext}')
    for name in entry['bpa']:
        if name:
            get(f'files/MAP_BG/{name.lower()}.bpa')
    spec = importlib.util.spec_from_file_location('etv1_reference_renderer', ROOT / 'source/outil_maps_pmdsky/recuperer_maps.py')
    renderer = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(renderer)
    frames, info = renderer.render(cache, entry, 1)
    target = HERE / 'reference' / f'{CODE}.png'
    target.parent.mkdir(exist_ok=True)
    frames[0].convert('RGB').save(target)
    report = {'repository': 'https://github.com/pret/pmd-sky.git', 'commit': COMMIT,
              'entry': entry, 'render': info, 'renderer_version': 'skytemple-files==1.8.5',
              'sha256': hashlib.sha256(target.read_bytes()).hexdigest(), 'source_blobs': provenance,
              'identification': 'Reference volcanique descriptive ; pas de nom officiel deduit du code ROM.',
              'animation_note': 'Seule la frame 0 sert de guide. Les animations du nouveau lot sont calculees, non reprises du BPL.'}
    (target.parent / 'provenance.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
