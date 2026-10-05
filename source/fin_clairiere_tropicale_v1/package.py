#!/usr/bin/env python3
"""Rebuild FCT2, verify native files and write a safe PMDO installation archive."""
import argparse
import hashlib
from pathlib import Path
import tempfile
import zipfile

from build import build
from verify import verify

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = ROOT / 'renders/fin_clairiere_tropicale_v1'
STAGE = ROOT / '.cache/fin_clairiere_tropicale_v1/fin_clairiere_tropicale'
DEFAULT_OUTPUT = OUT / 'FCT2_JN_fin_clairiere_tropicale_PMDO_0812.zip'


def package(output):
    build()
    report = verify(STAGE)
    if report['result'] != 'PASS' or report['pmdo_engine_or_dotnet_tested']:
        raise AssertionError('État de vérification inattendu, archive non créée.')

    output = Path(output).resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    files = [path for path in STAGE.rglob('*') if path.is_file()
             and path.name != 'index.idx'
             and '__pycache__' not in path.parts
             and path.suffix != '.pyc']
    names = {path.relative_to(STAGE).as_posix() for path in files}
    assert 'Data/Ground/fct2_fin_clairiere_tropicale.rsground' in names
    assert 'Data/Ground/fct2_fin_clairiere_tropicale_nuit.rsground' in names
    assert 'INSTALLER.py' in names and 'README.md' in names and 'Mod.xml' in names
    assert 'manifest.json' in names and 'verification.json' in names
    assert not any(name.endswith('/index.idx') for name in names)

    with zipfile.ZipFile(output, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for path in sorted(files):
            info = zipfile.ZipInfo(path.relative_to(STAGE).as_posix(), (2026, 10, 3, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            archive.writestr(info, path.read_bytes(), compresslevel=9)
    with zipfile.ZipFile(output) as archive:
        assert archive.testzip() is None
        assert len([name for name in archive.namelist() if name.endswith('.rsground')]) == 2
        assert len([name for name in archive.namelist() if name.endswith('.tile')]) == 17
        assert not any(name.endswith('index.idx') for name in archive.namelist())
        assert set(archive.namelist()) == names
    # Re-open the actual delivered archive and repeat binary, visual and installer checks
    # without relying on the build stage's generated index.idx.
    with tempfile.TemporaryDirectory(prefix='fct2_bundle_') as temporary:
        with zipfile.ZipFile(output) as archive:
            archive.extractall(temporary)
        archive_report = verify(Path(temporary))
        if archive_report['result'] != 'PASS':
            raise AssertionError('Le contrôle de l’archive extraite a échoué.')

    digest = hashlib.sha256(output.read_bytes()).hexdigest()
    print(f'Archive valide : {output} ({output.stat().st_size / 2**20:.2f} MiB)')
    print(f'SHA-256 : {digest}')
    return output, digest


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    package(args.output)


if __name__ == '__main__':
    main()
