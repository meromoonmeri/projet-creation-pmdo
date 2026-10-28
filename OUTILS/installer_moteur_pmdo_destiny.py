#!/usr/bin/env python3
"""Installe le moteur PMDO avec notre quest PMD Destiny PAR DÉFAUT.

Chaîne de provenance (déjà vérifiée, cf. source/pmdo_runtime/README.md) :
  * moteur PMDC v0.8.12 : meromoonmeri/RUNTIMEPMDO, commit 61c005e1…,
    archive `pmdc-linux-x64.zip` (77 503 089 o, SHA-256 officiel PMDC
    v0.8.12 asset 406230348) — téléchargée comme blob Git (l'hôte des
    releases échoue) ;
  * ressources de base : audinowho/DumpAsset, commit 3e767571…, par
    tarball codeload (Base/PathParams.xml etc.) ;
  * notre quest : quest_pmd_destiny/ (ModType Quest, namespace destiny)
    copiée dans MODS/quest_pmd_destiny — le lanceur écrit par ce script
    démarre PMDO avec `-quest quest_pmd_destiny` : notre quest est la
    quest par défaut, après le choix de la langue puis Nouvelle partie
    (Data/StartParams.xml → intro_halo → test de personnalité).

Installation par défaut : .cache/pmdo-runtime/engine/PMDO/ (ignoré par
Git — rien des centaines de Mo n'est archivé ici). Avec --cible, la quest
est aussi copiée dans MODS/ d'une installation PMDO existante (par ex.
l'installation Windows de l'auteur).

Usage :
  .venv/bin/python OUTILS/installer_moteur_pmdo_destiny.py
  .venv/bin/python OUTILS/installer_moteur_pmdo_destiny.py --cible "CHEMIN/PMDO"
  .venv/bin/python OUTILS/installer_moteur_pmdo_destiny.py --sans-moteur --cible ...
"""
from __future__ import annotations

import argparse
import hashlib
import shutil
import subprocess
import sys
import tarfile
import zipfile
from pathlib import Path

R = Path(__file__).resolve().parents[1]
CACHE = R / '.cache' / 'pmdo-runtime'
ENGINE = CACHE / 'engine' / 'PMDO'
QUEST = R / 'quest_pmd_destiny'

RUNTIME_REPO = 'meromoonmeri/RUNTIMEPMDO'
RUNTIME_COMMIT = '61c005e1dc9fd4eee6e6e7fcde77364de33d291e'
RUNTIME_ZIP = 'pmdc-linux-x64.zip'
RUNTIME_ZIP_SHA256 = 'c64f72afd27b96d5a870f71e44d05ee1e952909e86b9a53d0479163763c61577'
DUMP_REPO = 'audinowho/DumpAsset'
DUMP_COMMIT = '3e767571f9dd94270b848b3a73de9bec2553a2eb'


def gh(args: list[str], sortie: Path | None = None) -> None:
    """gh api … ; vers un fichier si sortie (Accept raw)."""
    cmd = ['gh', 'api'] + args
    if sortie is not None:
        cmd += ['-H', 'Accept: application/vnd.github.raw']
    if sortie is None:
        subprocess.run(cmd, check=True)
        return
    with open(sortie, 'wb') as f:
        subprocess.run(cmd, check=True, stdout=f)


def installer_moteur() -> None:
    if not (ENGINE / 'PMDO').is_file():
        CACHE.mkdir(parents=True, exist_ok=True)
        zdir = CACHE / 'downloads'
        zdir.mkdir(exist_ok=True)
        zpath = zdir / RUNTIME_ZIP
        if not zpath.is_file():
            print(f'→ blob {RUNTIME_ZIP} depuis {RUNTIME_REPO}@{RUNTIME_COMMIT[:9]}')
            tree = subprocess.run(
                ['gh', 'api', f'repos/{RUNTIME_REPO}/git/trees/{RUNTIME_COMMIT}?recursive=1',
                 '--jq', f'.tree[] | select(.path=="{RUNTIME_ZIP}") | .sha'],
                check=True, capture_output=True, text=True).stdout.strip()
            assert tree, 'blob introuvable dans RUNTIMEPMDO'
            gh([f'repos/{RUNTIME_REPO}/git/blobs/{tree}'], sortie=zpath)
        digest = hashlib.sha256(zpath.read_bytes()).hexdigest()
        assert digest == RUNTIME_ZIP_SHA256, f'SHA-256 inattendu : {digest}'
        print(f'  SHA-256 OK ({digest[:16]}…)')
        with zipfile.ZipFile(zpath) as z:
            assert z.testzip() is None
            for n in z.namelist():
                assert not Path(n).is_absolute() and '..' not in Path(n).parts
            z.extractall(CACHE / 'engine')
        print(f'  moteur installé → {ENGINE}')
    else:
        print(f'  moteur déjà présent → {ENGINE}')

    if not (ENGINE / 'Base' / 'PathParams.xml').is_file():
        tpath = CACHE / 'downloads' / 'dumpasset.tar.gz'
        print(f'→ ressources de base {DUMP_REPO}@{DUMP_COMMIT[:9]}')
        # codeload.github.com est autorisé ; gh api tarball redirige dessus
        subprocess.run(
            ['curl', '-sL', '--fail',
             f'https://codeload.github.com/{DUMP_REPO}/tar.gz/{DUMP_COMMIT}',
             '-o', str(tpath)], check=True)
        with tarfile.open(tpath) as t:
            membres = []
            for m in t.getmembers():
                parts = Path(m.name).parts[1:]   # strip du dossier racine
                if parts:
                    m.name = '/'.join(parts)
                    membres.append(m)
            t.extractall(ENGINE, members=membres)
        print(f'  ressources de base installées → {ENGINE}/Base')
    else:
        print('  ressources de base déjà présentes')


def copier_quest(cible_mods: Path) -> None:
    dest = cible_mods / 'quest_pmd_destiny'
    print(f'→ quest PMD Destiny → {dest}')
    shutil.copytree(QUEST, dest, dirs_exist_ok=True)
    print('  (ModType Quest, namespace destiny, StartParams → intro_halo)')


def ecrire_lanceurs() -> None:
    sh = R / 'PMDO_DESTINY.sh'
    sh.write_text(
        '#!/bin/sh\n'
        '# PMD Destiny — moteur PMDO avec notre quest par défaut\n'
        f'# (généré par OUTILS/installer_moteur_pmdo_destiny.py)\n'
        f'cd "$(dirname "$0")/{ENGINE.relative_to(R)}" && exec ./PMDO -quest quest_pmd_destiny "$@"\n')
    sh.chmod(0o755)
    bat = R / 'PMDO_DESTINY.bat'
    bat.write_text(
        '@echo off\r\n'
        'REM PMD Destiny - moteur PMDO avec notre quest par defaut\r\n'
        'REM Adapter le chemin ci-dessous a votre installation PMDO.\r\n'
        'cd /d "%~dp0.cache\\pmdo-runtime\\engine\\PMDO"\r\n'
        'PMDO.exe -quest quest_pmd_destiny %*\r\n')
    print(f'  lanceurs → {sh.name} / {bat.name} (-quest quest_pmd_destiny)')


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument('--cible', type=Path, default=None,
                    help='dossier d\'une installation PMDO existante (y copier la quest dans MODS/)')
    ap.add_argument('--sans-moteur', action='store_true',
                    help='ne pas (ré)installer le moteur en cache')
    a = ap.parse_args()

    if not a.sans_moteur:
        installer_moteur()
    copier_quest(ENGINE / 'MODS')
    if a.cible is not None:
        copier_quest(a.cible / 'MODS')
    ecrire_lanceurs()
    print('Terminé — notre quest est la quest par défaut du lancement.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
