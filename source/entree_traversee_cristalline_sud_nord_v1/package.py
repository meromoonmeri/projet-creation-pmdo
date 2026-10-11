"""Empaquetage Entrée Traversée Cristalline V1 (ETX1) + génération apercu_entree_traversee_cristalline_sud_nord_v1.html."""
from pathlib import Path
import json, subprocess, sys, zipfile

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders/entree_traversee_cristalline_sud_nord_v1'
STAGE = R / '.cache/entree_traversee_cristalline_sud_nord_v1/entree_traversee_cristalline_sud_nord'
ZIP_PATH = OUT / 'mod_entree_traversee_cristalline_sud_nord_pmdo_0812.zip'
HTML_PATH = R / 'apercu_entree_traversee_cristalline_sud_nord_v1.html'


def main():
    subprocess.run([sys.executable, str(HERE / 'build.py')], check=True)
    subprocess.run([sys.executable, str(HERE / 'test_build.py')], check=True)
    with zipfile.ZipFile(ZIP_PATH, 'w', zipfile.ZIP_DEFLATED) as z:
        for p in sorted(STAGE.rglob('*')):
            if p.is_file():
                z.write(p, p.relative_to(STAGE.parent))
    tpl = (HERE / 'viewer_template.html').read_text(encoding='utf-8')
    manifest_txt = (OUT / 'manifest.json').read_text(encoding='utf-8')
    HTML_PATH.write_text(tpl.replace('__MANIFEST_JSON__', manifest_txt), encoding='utf-8')
    print(json.dumps({'zip': str(ZIP_PATH.relative_to(R)), 'zip_bytes': ZIP_PATH.stat().st_size,
                      'html': str(HTML_PATH.relative_to(R))}, indent=2))


if __name__ == '__main__':
    main()
