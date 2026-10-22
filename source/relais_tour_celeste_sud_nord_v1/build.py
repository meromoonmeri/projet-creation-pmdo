"""Relais Mi-Tour de la Tour Céleste sud -> nord V1 (MST1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Référence canonique PMD Red Port :
- `references/D13P02.png` (`MAP_FILE_ID_SKY_TOWER_MID` / `b35`, 456 x 456 px) ;
- `references/D13P02_sol_natif_768x576.png` (tuilage natif exact 72 x 72 px sans couture dx=dy=0) ;
- `references/rom_d13p01_bpl.json` (`D13P01.bpl`, Palettes 9 & 10, 8 poses x 8 ticks = 64 ticks).
"""
from __future__ import annotations

import json
import shutil
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
COMMON_DIR = R / 'source/entree_tour_celeste_sud_nord_v1'
if str(COMMON_DIR) not in sys.path:
    sys.path.insert(0, str(COMMON_DIR))

from sky_tower_common import (  # noqa: E402
    ESN,
    assert_fidelity_below,
    build_d13p01_bpl_wave_frames,
    build_sky_particles_frames,
    cell_grid,
    dist_rgb,
    down_class,
    export_ground_project,
    find_marker_16x16,
    keep_large,
    key_and_extract_sky_poses,
    lum_of,
    make_viewer_template,
    quantize_group,
    rgb,
    rgba,
    sample_anchors_from_mask,
    sha,
    write_ora,
)

RAW = HERE / 'bruts'
REF_PNG = HERE / 'references/D13P02.png'
REF_SOL_NATIF = HERE / 'references/D13P02_sol_natif_768x576.png'
REF_BPL_JSON = HERE / 'references/rom_d13p01_bpl.json'

LOT_NAME = 'relais_tour_celeste_sud_nord_v1'
OUT = R / 'renders' / LOT_NAME
NAMESPACE = 'relais_tour_celeste'
STAGE = R / '.cache' / LOT_NAME / NAMESPACE
ASSET = 'mst1_relais_tour_celeste'
PFX = 'MST1'
ORA_NAME = f'{PFX}_relais_tour_celeste_calques.ora'

W, H = 768, 576
SRC = (1200, 896)
SCENE_LOOP = 64
BPL_TICKS = 8
PART_TICKS = 4

STATIC = [
    'pont_et_ile_relais',
    'motifs_ecaille_sol',
    'ourlets_ponts',
    'douve_celeste',
    'murs_nuages_blancs',
    'ombres_cumulus',
    'etoiles_diamant_bleues',
]
ANIMS = ['scintillement_bpl', 'eclats_et_brises']

PALETTE_GROUPS = {
    'sol': (['pont_et_ile_relais', 'motifs_ecaille_sol'], 48),
    'ourlets': (['ourlets_ponts', 'ombres_cumulus'], 48),
    'douve': (['douve_celeste'], 24),
    'etoiles': (['etoiles_diamant_bleues'], 24),
    'murs': (['murs_nuages_blancs'], 32),
}


def materials(a: np.ndarray) -> dict[str, np.ndarray]:
    """Classifieur chromatique identique appliqué au rip D13P02 et à decor.png."""
    lum = lum_of(a)
    return {
        'bleu_royal': (lum >= 60.0) & (lum < 130.0),
        'ombre_cumulus': (lum >= 130.0) & (lum < 185.0),
        'sol_ecaille_pervenche': (lum >= 185.0) & (lum < 225.0),
        'cumulus_blanc': lum >= 225.0,
    }


def classify_fullres(a: np.ndarray) -> dict[str, np.ndarray]:
    """Partitionne 100 % des pixels 1200x896 en 7 classes statiques exclusives."""
    h, w, _ = a.shape
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    lum = lum_of(a)

    # 1. Traversée centrale praticable (pont sud + île relais plate + pont nord)
    cand = (r >= 135) & (r <= 220) & (g >= 175) & (g <= 238) & (b >= 225)
    core = nd.binary_erosion(cand, iterations=3)
    lab, _ = nd.label(core)
    seeds = (
        set(np.unique(lab[-4:, 540:660]))
        | set(np.unique(lab[:4, 540:660]))
        | set(np.unique(lab[420:480, 540:660]))
    ) - {0}
    walk_platform = nd.binary_fill_holes(nd.binary_dilation(np.isin(lab, list(seeds)), iterations=4))

    # 2. Motifs d'écailles et étoiles douces internes au dallage praticable
    inner_plat = nd.binary_erosion(walk_platform, iterations=6)
    motifs_sol = keep_large(inner_plat & ((lum < 198.0) | (lum >= 220.0)), 14)
    pont_ile = walk_platform & ~motifs_sol

    # 3. Ourlet festonné bordant immédiatement l'île et les deux ponts
    ourlets = nd.binary_dilation(walk_platform, iterations=18) & ~walk_platform & (lum >= 145.0)

    # 4. Douve bleu royal vs étoiles à 4 branches bleu royal incrustées dans les murs blancs
    rem_royal = (lum < 145.0) & ~walk_platform & ~ourlets
    # La douve forme les deux grands bassins connexes autour de l'île centrale (> 8000 px) ;
    # les étoiles à 4 branches dans les murs blancs sont les composantes connexes compactes (< 8000 px).
    douve = keep_large(rem_royal, 8000)
    etoiles = rem_royal & ~douve

    # 5. Reste extérieur : parois de cumulus blanc pur vs ombres sculptées des cumulus
    rem = ~(pont_ile | motifs_sol | ourlets | douve | etoiles)
    ombres_cumulus = rem & (lum < 228.0)
    murs_blancs = rem & ~ombres_cumulus

    masks = {
        'pont_et_ile_relais': pont_ile,
        'motifs_ecaille_sol': motifs_sol,
        'ourlets_ponts': ourlets,
        'douve_celeste': douve,
        'etoiles_diamant_bleues': etoiles,
        'ombres_cumulus': ombres_cumulus,
        'murs_nuages_blancs': murs_blancs,
    }
    assert np.all(sum(m.astype(int) for m in masks.values()) == 1)
    return masks


def build() -> None:
    (HERE / 'viewer_template.html').write_text(make_viewer_template(
        code='MST1',
        title_short='Relais Mi-Tour Céleste — sud → nord · 4:3 vaste (768×576)',
        subtitle_html=(
            'Décor généré <strong>référencé sur la capture ROM exacte <code>D13P02</code></strong> '
            '(<em>Sky Tower Mid Floor</em>) associé au <strong>sol complet natif sans couture</strong> '
            '(tuile périodique <code>72×72 px</code> extraite de <code>D13P02.png</code>, distance RVB <code>0,00</code>). '
            'Traversée continue du <strong>pont sud</strong> au <strong>pont nord</strong> à travers l’île centrale plate '
            'entourée de la douve bleu royal et des parois de cumulus constellées d’étoiles à 4 branches.'
        ),
        ref_label='Référence canonique D13P02 (456×456)',
        poses_legend='Poses détourées (×4) : 4 éclats célestes + 4 brises d’alizé',
        status_html='Statut : décor généré référencé sur <code>D13P02</code> (sol complet 100 % natif <code>0,00</code>, décor max &lt; 21 / 35), <code>art_approved = false</code>, <code>runtime_tested = false</code>.',
        goal_label='donjon_seuil',
    ))

    if OUT.exists():
        shutil.rmtree(OUT)
    for d in ['calques', 'poses', 'masques', 'review'] + [f'animation/{x}' for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)

    a = rgb(RAW / 'decor.png')
    sol_natif = rgb(REF_SOL_NATIF)
    ref = rgb(REF_PNG)
    assert a.shape[:2] == (SRC[1], SRC[0])
    assert sol_natif.shape[:2] == (H, W)
    bpl_meta = json.loads(REF_BPL_JSON.read_text())

    # 1. Fidélité chromatique bloquante (< 35 sur chaque bande)
    m_ref, m_raw = materials(ref), materials(a)
    raw_fid = {}
    for mk_name in m_ref:
        mr = ref[m_ref[mk_name]].mean(0)
        md = a[m_raw[mk_name]].mean(0)
        raw_fid[mk_name] = {
            'ref_rgb': [round(float(v), 1) for v in mr],
            'mean_rgb': [round(float(v), 1) for v in md],
            'distance': dist_rgb(md, mr),
        }
    assert_fidelity_below(raw_fid, 35.0)

    # 2. Segmentation pleine résolution + réduction non mélangeante
    m_full = classify_fullres(a)
    ex, cols = down_class(a, m_full, STATIC)

    layers = {'sol_complet': rgba(sol_natif, np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])

    q = {'sol_complet': layers['sol_complet']}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q

    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')

    # 3. Collision 16x16 : traversée continue du pont sud jusqu'au pont nord
    walk_px = ex['pont_et_ile_relais'] | ex['motifs_ecaille_sol']
    cl, _ = nd.label(walk_px)
    south_seeds = np.unique(cl[-2:, :][walk_px[-2:, :]])
    walk = np.isin(cl, south_seeds[south_seeds > 0])
    blocked = cell_grid(~walk)
    walk_grid_px = (~blocked).repeat(8, 0).repeat(8, 1)
    Image.fromarray((walk_grid_px * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')

    entry_px = find_marker_16x16(blocked, (48, 67), range(62, 70))
    threshold_px = find_marker_16x16(blocked, (48, 3), range(2, 10))
    reach_ok, _ = ESN.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (threshold_px[1] // 8, threshold_px[0] // 8))
    assert reach_ok, f'Chemin sud->nord introuvable entre {entry_px} et {threshold_px}'

    # 4. Poses détourées + animations BPL sans damier
    glints, breezes = key_and_extract_sky_poses(RAW / 'particules_poses.png')
    all_poses = [('eclat', g) for g in glints] + [('brise', b_sp) for b_sp in breezes]
    pose_strip = Image.new(
        'RGBA',
        (sum(p.shape[1] + 8 for _, p in all_poses) + 8, max(p.shape[0] for _, p in all_poses) + 8),
        (0, 0, 0, 0),
    )
    ox = 4
    for idx_p, (kind, p_arr) in enumerate(all_poses):
        Image.fromarray(p_arr).save(OUT / 'poses' / f'{PFX}_pose_{idx_p:02d}_{kind}.png')
        pose_strip.alpha_composite(Image.fromarray(p_arr), (ox, 4))
        ox += p_arr.shape[1] + 8
    pose_strip.save(OUT / 'review' / f'{PFX}_planche_poses.png')

    base_comp = Image.new('RGBA', (W, H))
    for nm0 in ['sol_complet'] + STATIC:
        base_comp.alpha_composite(Image.fromarray(layers[nm0]))
    base_rgb = np.array(base_comp)[..., :3]
    # Auréoles scintillantes autour des étoiles des murs (Palette 9) + reflets d'ombres des cumulus (Palette 10)
    star_halos = nd.binary_dilation(ex['etoiles_diamant_bleues'], iterations=2) & ~ex['etoiles_diamant_bleues'] & ex['ombres_cumulus']
    deep_veins = ex['ombres_cumulus'] & ~star_halos
    bpl_frames = build_d13p01_bpl_wave_frames(base_rgb, star_halos, base_rgb, deep_veins, bpl_meta)

    glint_spots = sample_anchors_from_mask(ex['etoiles_diamant_bleues'] | ex['douve_celeste'], 12, margin=28)
    left_breeze = sample_anchors_from_mask(ex['douve_celeste'] & (np.arange(W)[None, :] < W // 2), 4, margin=32)
    right_breeze = sample_anchors_from_mask(ex['douve_celeste'] & (np.arange(W)[None, :] >= W // 2), 4, margin=32)
    breeze_spots = [(x, y, 1) for x, y in left_breeze] + [(x, y, -1) for x, y in right_breeze]
    part_frames = build_sky_particles_frames(W, H, glints, breezes, glint_spots, breeze_spots, n_frames=SCENE_LOOP // PART_TICKS)

    anim_map = {
        'scintillement_bpl': (bpl_frames, BPL_TICKS),
        'eclats_et_brises': (part_frames, PART_TICKS),
    }

    order_names = ['sol_complet'] + STATIC + ANIMS
    layer_list = []
    stack_named = []
    for i, nm in enumerate(order_names):
        if nm in anim_map:
            frs, tks = anim_map[nm]
            for t, fr in enumerate(frs):
                Image.fromarray(fr).save(OUT / 'animation' / nm / f'{PFX}_{i:02d}_{nm}_f{t:02d}.png')
            layer_list.append({'id': nm, 'file': f'animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png', 'phases': len(frs), 'ticks': tks})
            stack_named.append((nm, frs, tks))
        else:
            fr = layers[nm]
            Image.fromarray(fr).save(OUT / 'calques' / f'{PFX}_{i:02d}_{nm}.png')
            layer_list.append({'id': nm, 'file': f'calques/{PFX}_{i:02d}_{nm}.png', 'phases': 1, 'ticks': SCENE_LOOP})
            stack_named.append((nm, [fr], SCENE_LOOP))

    scenes = []
    for tick in range(0, SCENE_LOOP, PART_TICKS):
        im = Image.new('RGBA', (W, H))
        for _, frs, tks in stack_named:
            im.alpha_composite(Image.fromarray(frs[(tick // tks) % len(frs)]))
        scenes.append(im)
    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(
        OUT / 'review' / f'{PFX}_scene_animee.webp',
        save_all=True,
        append_images=scenes[1:],
        duration=round(PART_TICKS * 1000 / 60),
        loop=0,
        lossless=True,
    )

    ov = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x * 8, y * 8, x * 8 + 7, y * 8 + 7], fill=(220, 45, 45, 95))
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (threshold_px, (60, 220, 255, 255))):
        dr.rectangle([qx, qy, qx + 15, qy + 15], outline=c, width=2)
    ov.save(OUT / 'review' / f'{PFX}_collisions_marqueurs.png')

    write_ora(
        OUT / ORA_NAME,
        {f'{i:02d}_{t}' + ('_f00' if len(fr) > 1 else ''): fr[0] for i, (t, fr, _) in enumerate(stack_named)},
        W,
        H,
    )
    counts = export_ground_project(
        stage=STAGE,
        here=HERE,
        pfx=PFX,
        namespace=NAMESPACE,
        asset=ASSET,
        title_en='Sky Tower Mid Relay - South to North (4:3)',
        title_fr='Relais Mi-Tour Céleste',
        description_fr='Relais intermédiaire de la Tour Céleste entre pont sud, île d’écailles pervenche et pont nord (réf. D13P02 + sol natif sans couture).',
        comment_fr='PMDO 0.8.12. Rendu généré 4:3 référencé sur D13P02 + sol complet natif 72x72 sans couture ; Palettes 9 et 10 exactes de D13P01.bpl. Aucun test runtime PMDO.',
        w=W,
        h=H,
        stack_named=stack_named,
        blocked=blocked,
        entry_px=entry_px,
        goal_name='donjon_seuil',
        goal_px=threshold_px,
    )

    rlum = lum_of(ref)
    ref_targets = {
        'pont_et_ile_relais': ref[(rlum >= 185.0) & (rlum < 225.0)].mean(0),
        'motifs_ecaille_sol': ref[(rlum >= 175.0) & (rlum < 235.0)].mean(0),
        'ourlets_ponts': ref[(rlum >= 195.0) & (rlum <= 255.0)].mean(0),
        'douve_celeste': ref[rlum < 145.0].mean(0),
        'murs_nuages_blancs': ref[rlum >= 228.0].mean(0),
        'ombres_cumulus': ref[(rlum >= 145.0) & (rlum < 228.0)].mean(0),
        'etoiles_diamant_bleues': ref[rlum < 145.0].mean(0),
    }
    final_fid = {}
    for k in STATIC:
        fin_lay = layers[k]
        fin_px = fin_lay[fin_lay[..., 3] > 0][:, :3].mean(0)
        final_fid[k] = {
            'mean_rgb': [round(float(v), 1) for v in fin_px],
            'ref_rgb': [round(float(v), 1) for v in ref_targets[k]],
            'distance_rip': dist_rgb(fin_px, ref_targets[k]),
        }
    assert_fidelity_below(final_fid, 35.0)
    sol_fid = dist_rgb(layers['sol_complet'][..., :3].reshape(-1, 3).mean(0), sol_natif.reshape(-1, 3).mean(0))
    assert sol_fid == 0.0, f'sol_complet natif modifié : {sol_fid}'

    manifest = {
        'id': LOT_NAME,
        'prefix': PFX,
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'scene_loop_ticks': SCENE_LOOP,
        'canonical_biome': {
            'rom_code': 'D13P02',
            'dungeon_fr': 'Tour Céleste (relais mi-tour)',
            'dungeon_en': 'Sky Tower Mid Floor',
            'reference_png': REF_PNG.relative_to(R).as_posix(),
            'reference_sha256': sha(REF_PNG),
            'rom_bpl_palettes': {
                'palette_9_etoiles': {'palette_index': 9, 'frames': 8, 'duration_per_frame_ticks': 8, 'loop_ticks': 64},
                'palette_10_cumulus': {'palette_index': 10, 'frames': 8, 'duration_per_frame_ticks': 8, 'loop_ticks': 64},
            },
        },
        'nature': 'Décor généré référencé sur la capture ROM D13P02 combiné au sol complet 100 % natif périodique 72x72 de D13P02 (dérive RVB 0.0) ; animations multicalques D13P01.bpl + poses pixel-art détourées.',
        'art_approved': False,
        'raw_inputs': [
            {'file': (RAW / 'decor.png').relative_to(R).as_posix(), 'size': list(Image.open(RAW / 'decor.png').size),
             'sha256': sha(RAW / 'decor.png'), 'images': [REF_PNG.relative_to(R).as_posix()]},
            {'file': REF_SOL_NATIF.relative_to(R).as_posix(), 'size': list(Image.open(REF_SOL_NATIF).size),
             'sha256': sha(REF_SOL_NATIF), 'images': [REF_PNG.relative_to(R).as_posix()]},
            {'file': (RAW / 'particules_poses.png').relative_to(R).as_posix(), 'size': list(Image.open(RAW / 'particules_poses.png').size),
             'sha256': sha(RAW / 'particules_poses.png'), 'images': [REF_PNG.relative_to(R).as_posix()]},
        ],
        'layers': layer_list,
        'access': {
            'entry_px': entry_px,
            'threshold_px': threshold_px,
            'walkable_cells': int((~blocked).sum()),
            'blocked_cells': int(blocked.sum()),
            'path_found_16x16': bool(reach_ok),
        },
        'fidelite_rip': {'seuil_max': 35.0, 'brut': raw_fid, 'calques_finaux': final_fid, 'sol_complet': sol_fid},
        'pmdo': {
            'target': '0.8.12',
            'runtime_tested': False,
            'asset_name': ASSET,
            'namespace': NAMESPACE,
            'tex_size': 1,
            'tiles_per_bank': counts,
        },
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    shutil.copyfile(HERE / 'README_PACK.md', OUT / 'README.md')
    print(f'OK {PFX}: walkable={int((~blocked).sum())}, entry={entry_px}, seuil={threshold_px}, max_brut={max(v["distance"] for v in raw_fid.values())}, sol={sol_fid}')


if __name__ == '__main__':
    build()
