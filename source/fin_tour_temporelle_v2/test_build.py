"""Tests du lot Fin Tour Temporelle V2 (FTT2, arene du prisme temporel, 4:3 vaste 768 x 576 px).

.venv/bin/python source/fin_tour_temporelle_v2/test_build.py
"""
from pathlib import Path
import importlib.util, json, subprocess, sys, tempfile, zipfile

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT = R / 'renders/fin_tour_temporelle_v2'
STAGE = R / '.cache/fin_tour_temporelle_v2/fin_tour_temporelle_v2'


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


B = loadmod('ftt2', HERE / 'build.py')
v1 = loadmod('esn1', R / 'source/entree_sud_nord_generee_v1/build.py')
tools = loadmod('inst', R / 'source/pmdo_cote/INSTALLER.py')
W, H = B.W, B.H


def load(rel):
    return np.array(Image.open(OUT / rel))


def main():
    m = json.loads((OUT / 'manifest.json').read_text())
    assert m['lot'] == 'fin_tour_temporelle_v2' and m['prefix'] == 'FTT2'
    assert m['size_px'] == [W, H] == [768, 576] and m['grid_8px'] == [96, 72]
    assert W * 3 == H * 4 and W % 8 == 0 and H % 8 == 0

    # 1. ETT2 (l'entree) presente ; sol et nuages de FTT2 byte-identiques a ses bruts ; lois d'animation identiques.
    B2 = loadmod('ett2_ref', R / 'source/entree_tour_temporelle_sud_nord_v2/build.py')
    assert (R / 'source/entree_tour_temporelle_sud_nord_v2').is_dir()
    for f in ('sol_complet.png', 'nuages_magenta.png'):
        assert B.sha(B.RAW / f) == B.sha(B.ETT2_RAW / f), f'copie non byte-identique: {f}'
    assert m['entree_ett2']['sol_complet_sha256_ett2'] == B.sha(B.ETT2_RAW / 'sol_complet.png')
    assert m['entree_ett2']['nuages_sha256_ett2'] == B.sha(B.ETT2_RAW / 'nuages_magenta.png')
    assert B.GOLD_RAMPS == B2.GOLD_RAMPS and B.TARGET_PALETTE_V2 == B2.TARGET_PALETTE_V2
    for c in ('CLOUD_PHASES', 'CLOUD_TICKS', 'CLOUD_STEP', 'CLOUD_ROWS', 'REF_PHASES', 'REF_TICKS',
              'ROCK_PHASES', 'CIRCUIT_PHASES', 'CIRCUIT_TICKS', 'RIFT_PHASES', 'RIFT_TICKS', 'LOOP_TICKS'):
        assert getattr(B, c) == getattr(B2, c), c

    # 2. Trois bruts (1200 x 896) + deux essais ecartes archives (hashes, jamais en raw_inputs) + references DA explicites.
    assert len(m['bruts_ecartes']) == 2
    for e in m['bruts_ecartes']:
        pe = R / e['file']
        assert pe.exists() and B.sha(pe) == e['sha256'] and 'ecartes' in e['file']
    assert len(m['raw_inputs']) == 3
    for r in m['raw_inputs']:
        p = R / r['file']
        assert p.exists() and B.sha(p) == r['sha256']
        assert list(Image.open(p).size) == [1200, 896]
    refs = m['reference_da']
    assert refs['present'] == B.REF_D29.is_file()
    assert refs['present_distorsion'] == B.REF_D30.is_file()
    assert (refs['sha256'] is not None) == refs['present']
    assert (refs['sha256_distorsion'] is not None) == refs['present_distorsion']

    # 3. Fidélité aux cibles Noir / Or / Nuages Rouge-Noir (< 35)
    a_dec = B.rgb(B.RAW / 'decor_magenta.png')
    a_sol = B.rgb(B.RAW / 'sol_complet.png')
    a_nua = B.rgb(B.RAW / 'nuages_magenta.png')
    masks_full, _ = B.classify(a_dec)
    fid = B.compute_fidelity(a_dec, a_sol, a_nua, masks_full)
    for k in ('dalles_ardoise', 'muraille_noire', 'roche_noire', 'circuits_or', 'nuages_rouge_noir', 'sol_complet'):
        assert fid[k]['distance'] < B.FIDELITY_MAX, (k, fid[k])
        assert fid[k] == m['fidelite_rip']['mesures'][k]

    # 4. Partition exclusive sur la plateforme : chaque pixel hors (void U rochers_flottants) est couvert exactement
    #    par (chaussee_noire | arene_dalles | parois_rocheuses | muraille_gothique | prisme_cristal | circuits_or)
    void = load('masques/FTT2_masque_void.png') > 0
    rocks = load('masques/FTT2_masque_rochers_flottants.png') > 0
    cir_m = load('masques/FTT2_masque_circuits_or.png') > 0
    stat = {
        s: load(f'calques/FTT2_{i:02d}_{s}.png')
        for i, s in [(3, 'chaussee_noire'), (4, 'arene_dalles'), (5, 'parois_rocheuses'), (6, 'muraille_gothique'), (7, 'prisme_cristal')]
    }
    for a in stat.values():
        assert a.shape == (H, W, 4) and set(np.unique(a[..., 3])) <= {0, 255}
    stack = np.stack([a[..., 3] == 255 for a in stat.values()] + [cir_m])
    assert np.array_equal(stack.sum(0), (~void & ~rocks).astype(int)), 'chevauchement ou trou hors vide et rochers'
    sol = load('calques/FTT2_02_sol_complet.png')
    assert np.array_equal(sol[..., 3] == 255, ~void)
    ciel = load('calques/FTT2_00_ciel.png')
    assert (ciel[..., 3] == 255).all() and (ciel[..., :3] == B.SKY_TONE).all()

    # 5. Zéro magenta résiduel dans tous les calques et toutes les phases d'animation
    all_pngs = list((OUT / 'calques').glob('*.png')) + list((OUT / 'animation').rglob('*.png'))
    assert len(all_pngs) == 7 + (48 + 24 + 24 + 16 + 24 + 24)
    for p in all_pngs:
        a = np.array(Image.open(p))
        op = a[..., 3] > 0
        if op.any():
            r, g, b = a[op, 0].astype(int), a[op, 1].astype(int), a[op, 2].astype(int)
            assert int(((r > 200) & (b > 200) & (g < 90)).sum()) == 0, p.name

    # 6. Nuages rouge/noir : 48 phases x 5 ticks = 240 ticks, dominante R > G + 20 et R > B + 15, boucle fermée
    allowed_sky = load('masques/FTT2_masque_ciel_visible.png') > 0
    nf = [load(f'animation/nuages/FTT2_01_nuages_f{t:02d}.png') for t in range(B.CLOUD_PHASES)]
    for f in nf:
        op = f[..., 3] > 0
        assert not (op & ~allowed_sky).any()
        rgb_mean = f[op][:, :3].mean(0)
        assert rgb_mean[0] > rgb_mean[1] + 25 and rgb_mean[0] > rgb_mean[2] + 15, rgb_mean
    assert not np.array_equal(nf[0], nf[1])

    # 7. Reflets légèrement arc-en-ciel : limités aux facettes du portail de cristal et aux ogives de la tour
    portal_m = load('masques/FTT2_masque_prisme_cristal.png') > 0
    wall_m = load('masques/FTT2_masque_muraille_gothique.png') > 0
    rf_arc = [load(f'animation/reflets_arc_en_ciel/FTT2_08_reflets_arc_en_ciel_f{t:02d}.png') for t in range(B.REF_PHASES)]
    for f in rf_arc:
        op = f[..., 3] == 255
        assert not (op & ~(portal_m | wall_m)).any()
        assert (op & portal_m).any()
    assert not np.array_equal(rf_arc[0], rf[6] if False else rf_arc[6])

    # 8. Circuits et veines d'OR : 16 phases x 5 ticks = 80 ticks, 100 % tons d'or (R > G > B), aucun ton rouge pur
    cf = [load(f'animation/circuits_or/FTT2_10_circuits_or_f{t:02d}.png') for t in range(B.CIRCUIT_PHASES)]
    gold_tones = {tuple(c) for c in B.GOLD_CIRCUIT_TONES}
    for f in cf:
        op = f[..., 3] == 255
        assert np.array_equal(op, cir_m)
        cols = {tuple(int(v) for v in x) for x in np.unique(f[op][:, :3], axis=0)}
        assert cols <= gold_tones, cols - gold_tones
        for r, g, b in cols:
            assert r > g > b and g >= 79, (r, g, b)
    assert not np.array_equal(cf[0], cf[7]) and np.array_equal(cf[0], cf[15])

    # 9. Brèches de réalité : s'ouvrent et se ferment sur les rochers et les nuages, JAMAIS sur le chemin praticable
    walk = load('masques/FTT2_masque_praticable.png') > 0
    parois_m = load('masques/FTT2_masque_parois_rocheuses.png') > 0
    rock_mass = parois_m | (cir_m & (np.mgrid[:H, :W][0] >= 170))
    bf = [load(f'animation/breches_realite/FTT2_11_breches_realite_f{t:02d}.png') for t in range(B.RIFT_PHASES)]
    counts_per_phase = [int((f[..., 3] == 255).sum()) for f in bf]
    assert min(counts_per_phase) > 200 and max(counts_per_phase) > 800
    assert not np.array_equal(bf[0], bf[6]) and not np.array_equal(bf[6], bf[12])
    for t, f in enumerate(bf):
        op = f[..., 3] == 255
        # Zéro pixel sur le chemin praticable (walk), le parvis ou la chaussée
        assert int((op & walk).sum()) == 0, f'brèche sur le chemin à la phase {t}'
        assert int((op & ~(rock_mass | allowed_sky)).sum()) == 0, f'brèche hors rochers/nuages à la phase {t}'
    # Vérifie que chaque brèche individuelle s'ouvre puis se ferme complètement (0 px pendant ses 8 phases fermées)
    for rf_spec in m['breches_realite']['liste']:
        cx, cy = rf_spec['centre_xy']
        ph_off = rf_spec['phase_offset']
        box_open = bf[(ph_off + 8) % B.RIFT_PHASES][max(0, cy - 12):cy + 13, max(0, cx - 12):cx + 13, 3] > 0
        box_closed = bf[(ph_off + 20) % B.RIFT_PHASES][max(0, cy - 12):cy + 13, max(0, cx - 12):cx + 13, 3] > 0
        assert box_open.any() and not box_closed.any(), rf_spec

    # 10. Scène complète bouclée sur 240 ticks (48 images dans le WebP, pas de 5 ticks)
    with Image.open(OUT / 'review/FTT2_scene_animee.webp') as im:
        assert im.n_frames == 48 and im.size == (W, H)

    # 11. Fin de donjon : chemins 16 x 16 entrance -> boss (centre) et entrance -> objectif (pied du prisme), aucune sortie
    blk = B.cell_grid(~walk)
    ep, bp, op = m['access']['entry_px'], m['access']['boss_px'], m['access']['objectif_px']
    assert ep[1] == H - 16 and op[1] < bp[1] < ep[1]
    ok_b, cnt_b = v1.reachable(blk, (ep[1] // 8, ep[0] // 8), (bp[1] // 8, bp[0] // 8))
    ok_o, cnt_o = v1.reachable(blk, (ep[1] // 8, ep[0] // 8), (op[1] // 8, op[0] // 8))
    assert ok_b and cnt_b == m['access']['cells_explored_vers_boss']
    assert ok_o and cnt_o == m['access']['cells_explored_vers_objectif']
    # boss au coeur de l'arene : pas de case bloquee a moins de 5 cases autour du repere 2x2
    by, bx = bp[1] // 8, bp[0] // 8
    assert not blk[by - 5:by + 7, bx - 5:bx + 7].any()
    # objectif colle au prisme sans le chevaucher : bas du prisme a moins de 24 px au-dessus, 0 px de prisme dans le repere
    assert not portal_m[op[1]:op[1] + 16, op[0]:op[0] + 16].any()
    assert 0 <= op[1] - int(np.nonzero(portal_m)[0].max()) <= 24
    # aucune sortie : le praticable ne touche ni le bord nord ni les bords lateraux, seulement le sud
    assert blk[0].all() and blk[:, 0].all() and blk[:, -1].all() and not blk[-1, ep[0] // 8:ep[0] // 8 + 2].any()

    # 12. Archive ORA valide (13 calques)
    with zipfile.ZipFile(OUT / 'FTT2_fin_tour_temporelle_v2_calques.ora') as z:
        assert z.read('mimetype') == b'image/openraster'
        assert len([n for n in z.namelist() if n.startswith('data/layer')]) == 13

    # 13. Projet Ground PMDO 0.8.12 + banques .tile + index.idx + INSTALLER.py sans warp
    rs = json.loads((STAGE / 'Data/Ground/ftt2_fin_tour_temporelle_noire_or.rsground').read_text(encoding='utf-8-sig'))
    o = rs['Object']
    assert rs['Version'] == '0.8.12.0' and o['TexSize'] == 1 and len(o['Layers']) == 14 and o['Layers'][-1]['Layer'] == 4
    mks = {k['EntName']: k['Collider'] for k in o['Entities'][0]['Markers']}
    assert set(mks) == {'entrance', 'boss', 'objectif'}, 'une fin n a ni donjon_seuil ni autre marqueur'
    assert [mks['entrance']['X'], mks['entrance']['Y']] == ep
    assert [mks['boss']['X'], mks['boss']['Y']] == bp
    assert [mks['objectif']['X'], mks['objectif']['Y']] == op
    lua = (STAGE / 'Data/Script/fin_tour_temporelle_v2/ground/ftt2_fin_tour_temporelle_noire_or/init.lua').read_text()
    assert 'EnterDungeon' not in lua and 'MoveToZone' not in lua
    idx = tools.read_index(STAGE / 'Content/Tile/index.idx')
    assert len(m['pmdo']['banks']) == 13 and set(m['pmdo']['banks']) <= set(idx) and all(b.startswith('FTT2_') for b in m['pmdo']['banks'])
    with tempfile.TemporaryDirectory() as td:
        mod = Path(td) / 'fin_tour_temporelle_v2'
        (mod / 'Content/Tile').mkdir(parents=True)
        (mod / 'Mod.xml').write_text('<Header/>')
        (mod / 'Content/Tile/index.idx').write_bytes(tools.encode_index({'DUMMY': idx['FTT2_00_CIEL']}))
        subprocess.run([sys.executable, str(STAGE / 'INSTALLER.py'), str(mod)], check=True, stdout=subprocess.DEVNULL)
        merged = tools.read_index(mod / 'Content/Tile/index.idx')
        assert 'DUMMY' in merged and set(m['pmdo']['banks']) <= set(merged)

    # 14. Statuts honnêtes exigés par AGENTS.md
    assert m['art_approved'] is False and m['pmdo']['runtime_tested'] is False
    print('OK test_build fin_tour_temporelle_v2 (14 verifications de sortie)')
    if not (refs['present'] and refs['present_distorsion']):
        print('AVIS : D29P11A/D30P34A absents ; fidelite canonique ROM non verifiable, art_approved reste false.')


if __name__ == '__main__':
    main()
