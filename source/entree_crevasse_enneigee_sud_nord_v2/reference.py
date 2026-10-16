"""Référence canonique de la Crevasse enneigée (ECE1) : map D79P11A de PMD Explorers of Sky.

Source : décompilation pret/pmd-sky au commit épinglé par `source/outil_maps_pmdsky/recuperer_maps.py` (clone partiel
dans `.cache/pmd-sky`), rendu skytemple-files `Bma.to_pil` comme l'outil, sans écrire l'index ni les planches
versionnés de l'outil. Le nom du lieu n'est PAS identifié par une capture (le préfixe dNN n'est pas le DUNGEON_ID) :
« Crevasse enneigée » est un nom de travail descriptif (falaise de glace lavande fendue d'une crevasse-grotte au nord,
neige au sud, cristaux de glace au pied des parois). Les autres codes D79 (D79P21A, D79P41A) sont des gabarits vides.

Sorties versionnées (petites) dans `references/` :
- D79P11A.png (600 x 504, frame 0) : référence du décor ECE1 ;
- D79P11A_anim.webp : toutes les frames (une seule si le BPL n'anime rien) ;
- palette_anim.json : animation de palette EXACTE s'il y en a une (emplacements, couleurs par frame, durée BPL) ;
- provenance.json : commit, chemins, hash de blob Git et SHA-256 des BMA/BPC/BPL, SHA-256 des PNG.

Lancer : .venv/bin/python source/entree_crevasse_enneigee_sud_nord_v1/reference.py
"""
from pathlib import Path
import hashlib, importlib.util, json, subprocess

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUTREF = HERE / 'references'
CODES = ('D79P11A',)


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


def sha(b):
    return hashlib.sha256(b).hexdigest()


def slots_of(frames):
    """Pixels qui changent au cours de l'animation, regroupés par séquence de couleurs identique (= un emplacement de
    palette animé). Renvoie la liste des emplacements triés par luminance de leur couleur en frame 0."""
    a = np.stack([np.array(f.convert('RGB')) for f in frames]).astype(int)
    ch = (a != a[:1]).any(-1).any(0)
    seqs = {}
    for y, x in zip(*np.nonzero(ch)):
        k = tuple(tuple(int(v) for v in a[t, y, x]) for t in range(len(a)))
        seqs.setdefault(k, []).append((int(y), int(x)))
    lum = lambda c: 0.299 * c[0] + 0.587 * c[1] + 0.114 * c[2]
    out = []
    for k, px in sorted(seqs.items(), key=lambda kv: lum(kv[0][0])):
        out.append({'couleurs_par_frame': [list(c) for c in k], 'pixels': len(px)})
    keys, seq = [], []
    for t in range(len(a)):
        b = a[t].tobytes()
        if b not in keys:
            keys.append(b)
        seq.append(keys.index(b))
    return out, seq, int(ch.sum())


def main():
    rm = loadmod('outil_maps', R / 'source/outil_maps_pmdsky/recuperer_maps.py')
    mapbg = rm.ensure_clone()
    from skytemple_files.common.types.file_types import FileType
    commit = subprocess.run(['git', 'rev-parse', 'HEAD'], cwd=rm.CLONE, capture_output=True, text=True,
                            check=True).stdout.strip()
    assert commit == rm.PMD_SKY_COMMIT
    ents = {e['code']: e for e in rm.bg_entries(mapbg)}
    OUTREF.mkdir(parents=True, exist_ok=True)
    prov = {'depot': rm.PMD_SKY, 'commit': commit, 'table': 'files/language-specific/US/MAP_BG/bg_list.dat',
            'rendu': 'skytemple-files Bma.to_pil(bpc, bpl, bpas), sans collision (meme methode que outil_maps_pmdsky)',
            'identification': 'aucune capture nommee ne correspond : nom du lieu non verifie ; « Crevasse enneigee » '
                              'est un nom de travail descriptif ; D79P21A et D79P41A sont des gabarits vides',
            'maps': {}}
    anim = {'note': 'animation de palette du BPL : chaque emplacement (pixels qui partagent la meme sequence) change de '
                    'couleur a chaque frame ; duree BPL en frames de jeu (60 i/s), comme les ticks PMDO',
            'maps': {}}
    for code in CODES:
        e = ents[code]
        frames, info = rm.render(mapbg, e, 400)
        bpl = FileType.BPL.deserialize((mapbg / f"{e['bpl'].lower()}.bpl").read_bytes())
        specs = [{'palette': i, 'duree_par_frame': s.duration_per_frame, 'frames': s.number_of_frames}
                 for i, s in enumerate(bpl.animation_specs or []) if s.number_of_frames]
        png = OUTREF / f'{code}.png'
        frames[0].convert('RGB').save(png, optimize=True)
        fr = [f.convert('RGB') for f in frames]
        dur = max(1, specs[0]['duree_par_frame']) if specs else 10
        fr[0].save(OUTREF / f'{code}_anim.webp', save_all=True, append_images=fr[1:], duration=round(dur * 1000 / 60),
                   loop=0, lossless=True)
        files = {}
        for kind in ('bma', 'bpc', 'bpl'):
            rel = f"files/MAP_BG/{e[kind].lower()}.{kind}"
            blob = subprocess.run(['git', 'rev-parse', f'HEAD:{rel}'], cwd=rm.CLONE, capture_output=True, text=True,
                                  check=True).stdout.strip()
            files[kind] = {'chemin': rel, 'blob_git': blob, 'sha256': sha((rm.CLONE / rel).read_bytes())}
        prov['maps'][code] = {'fichiers': files, 'taille_px': info['taille_px'], 'frames': info['frames'],
                              'couches': info['couches'], 'png': png.name, 'png_sha256': sha(png.read_bytes()),
                              'webp': f'{code}_anim.webp'}
        slots, seq, n = slots_of(frames)
        anim['maps'][code] = {'specs_bpl': specs, 'frames': len(frames), 'sequence_etats_distincts': seq,
                              'pixels_animes': n, 'emplacements': slots}
        print(code, info['taille_px'], len(frames), 'frames', len(slots), 'emplacements', n, 'px animes', specs)
    (OUTREF / 'provenance.json').write_text(json.dumps(prov, ensure_ascii=False, indent=1) + '\n')
    (OUTREF / 'palette_anim.json').write_text(json.dumps(anim, ensure_ascii=False, indent=1) + '\n')


if __name__ == '__main__':
    main()
