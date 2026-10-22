"""Sommet de la Tour Céleste — Arène de Rayquaza V1 (SST1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Référence canonique PMD Red Port :
- `references/b71_sky_tower_summit.png` (`D13P03` / `b71`, 552 x 576 px) ;
- `references/b71_sol_crop_4x.png` ;
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
    down_full,
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
REF_PNG = HERE / 'references/b71_sky_tower_summit.png'
REF_SOL_CROP = HERE / 'references/b71_sol_crop_4x.png'
REF_BPL_JSON = HERE / 'references/rom_d13p01_bpl.json'

LOT_NAME = 'sommet_tour_celeste_rayquaza_v1'
OUT = R / 'renders' / LOT_NAME
NAMESPACE = 'sommet_tour_celeste'
STAGE = R / '.cache' / LOT_NAME / NAMESPACE
ASSET = 'sst1_sommet_tour_celeste'
PFX = 'SST1'
ORA_NAME = f'{PFX}_sommet_tour_celeste_calques.ora'

W, H = 768, 576
SRC = (1200, 896)
SCENE_LOOP = 64
BPL_TICKS = 8
PART_TICKS = 4

STATIC = [
    'couronne_et_acces_sud',
    'reliefs_couronne',
    'ourlet_couronne',
    'stratosphere_outremer',
    'arc_horizon_lumineux',
    'ailes_vent_profondes',
    'plumes_vent_sculptees',
]
ANIMS = ['souffle_stratosphere_bpl', 'alizes_et_eclats']

PALETTE_GROUPS = {
    'sol': (['sol_complet', 'couronne_et_acces_sud', 'reliefs_couronne'], 48),
    'ourlet': (['ourlet_couronne'], 32),
    'stratosphere': (['stratosphere_outremer'], 24),
    'horizon': (['arc_horizon_lumineux'], 48),
    'ailes': (['ailes_vent_profondes', 'plumes_vent_sculptees'], 48),
}


def materials(a: np.ndarray) -> dict[str, np.ndarray]:
    """Classifieur chromatique identique appliqué au rip b71 et à decor.png."""
    lum = lum_of(a)
    return {
        'stratosphere_outremer': lum < 60.0,
        'transition_horizon': (lum >= 60.0) & (lum < 130.0),
        'ailes_vent_pervenche': (lum >= 130.0) & (lum < 185.0),
        'ourlet_et_brume': (lum >= 185.0) & (lum < 225.0),
        'couronne_nuage_clair': lum >= 225.0,
    }


def classify_fullres(a: np.ndarray) -> dict[str, np.ndarray]:
    """Partitionne 100 % des pixels 1200x896 en 7 classes statiques exclusives."""
    h, w, _ = a.shape
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    lum = lum_of(a)

    # 1. Pont d'accès sud + couronne centrale praticable de Rayquaza
    cand = (r >= 176) & (g >= 224) & (b >= 235)
    core = nd.binary_erosion(cand, iterations=2)
    lab, _ = nd.label(core)
    seeds = set(np.unique(lab[-4:, 500:700])) - {0}
    walk_platform = nd.binary_fill_holes(nd.binary_dilation(np.isin(lab, list(seeds)), iterations=3) & cand)

    # 2. Croissants blancs et triangles pervenche incrustés dans la couronne
    inner_plat = nd.binary_erosion(walk_platform, iterations=8)
    white_arcs = inner_plat & (r >= 236) & (g >= 250)
    blue_tris = inner_plat & (r < 194) & (g < 236)
    reliefs = keep_large(white_arcs | blue_tris, 12)
    couronne = walk_platform & ~reliefs

    # 3. Ourlet festonné cernant la couronne et le pont sud
    ourlet = nd.binary_dilation(walk_platform, iterations=22) & ~walk_platform & (lum >= 145.0) & (lum < 232.0)

    # 4. Stratosphère outremer profond au nord (lum < 118)
    rem1 = ~(couronne | reliefs | ourlet)
    stratosphere = rem1 & (lum < 118.0)

    # 5. Arc courbe lumineux de l'atmosphère (bande claire haute/latérale lum >= 188 hors couronne)
    rem2 = rem1 & ~stratosphere
    arc_horizon = rem2 & (lum >= 186.0)

    # 6. Ailes de vent pervenche entourant la couronne : sillons profonds vs plumes sculptées claires
    rem3 = rem2 & ~arc_horizon
    ailes_profondes = rem3 & (lum < 156.0)
    plumes_vent = rem3 & ~ailes_profondes

    masks = {
        'couronne_et_acces_sud': couronne,
        'reliefs_couronne': reliefs,
        'ourlet_couronne': ourlet,
        'stratosphere_outremer': stratosphere,
        'arc_horizon_lumineux': arc_horizon,
        'ailes_vent_profondes': ailes_profondes,
        'plumes_vent_sculptees': plumes_vent,
    }
    assert np.all(sum(m.astype(int) for m in masks.values()) == 1)
    return masks


def build() -> None:
    (HERE / 'viewer_template.html').write_text(make_viewer_template(
        code='SST1',
        title_short='Sommet Tour Céleste · Arène de Rayquaza — 4:3 vaste (768×576)',
        subtitle_html=(
            'Décor généré <strong>référencé sur la capture ROM exacte <code>b71 / D13P03</code></strong> '
            '(<em>Sky Tower Summit</em>, distance chromatique max <strong><code>6,05 &lt; 35</code></strong> sur les 5 bandes) : '
            'pont de nuages au sud débouchant sur la grande couronne festonnée de Rayquaza face à l’arc lumineux '
            'de la stratosphère terrestre. Souffle d’altitude animé par <code>D13P01.bpl</code> (calque <code>08</code>) '
            'et volutes d’alizé détourées (calque <code>09</code>).'
        ),
        ref_label='Référence canonique b71 / D13P03 (552×576)',
        poses_legend='Poses détourées (×4) : 4 éclats célestes + 4 brises d’alizé',
        status_html='Statut : décor généré référencé sur <code>b71</code> (fidélité brute max <code>6,05 / 35</code>), <code>art_approved = false</code>, <code>runtime_tested = false</code>.',
        goal_label='boss_sommet',
    ))

    if OUT.exists():
        shutil.rmtree(OUT)
    for d in ['calques', 'poses', 'masques', 'review'] + [f'animation/{x}' for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)

    a = rgb(RAW / 'decor.png')
    f = rgb(RAW / 'sol_complet.png')
    ref = rgb(REF_PNG)
    ref_sol = rgb(REF_SOL_CROP)
    assert a.shape[:2] == f.shape[:2] == (SRC[1], SRC[0])
    bpl_meta = json.loads(REF_BPL_JSON.read_text())

    # 1. Fidélité chromatique bloquante (< 35, ici < 7.0 sur le brut !)
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

    layers = {'sol_complet': rgba(down_full(f), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])

    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q

    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')

    # 3. Collision 16x16 : pont sud jusqu'au centre de l'arène de Rayquaza
    walk_px = ex['couronne_et_acces_sud'] | ex['reliefs_couronne']
    cl, _ = nd.label(walk_px)
    south_seeds = np.unique(cl[-2:, :][walk_px[-2:, :]])
    walk = np.isin(cl, south_seeds[south_seeds > 0])
    blocked = cell_grid(~walk)
    walk_grid_px = (~blocked).repeat(8, 0).repeat(8, 1)
    Image.fromarray((walk_grid_px * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')

    entry_px = find_marker_16x16(blocked, (48, 67), range(62, 70))
    boss_px = find_marker_16x16(blocked, (48, 36), range(30, 44))
    reach_ok, _ = ESN.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_px[1] // 8, boss_px[0] // 8))
    assert reach_ok, f'Chemin sud->boss introuvable entre {entry_px} et {boss_px}'

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
    base_lum = lum_of(base_rgb)

    # Frange supérieure lumineuse de l'arc d'horizon (Palette 9) + plumes d'ailes de vent (Palette 10)
    bright_horizon = ex['arc_horizon_lumineux'] & (base_lum >= 205.0)
    deep_wings = ex['plumes_vent_sculptees']
    bpl_frames = build_d13p01_bpl_wave_frames(base_rgb, bright_horizon, base_rgb, deep_wings, bpl_meta)

    glint_spots = sample_anchors_from_mask(ex['stratosphere_outremer'] | ex['arc_horizon_lumineux'], 12, margin=28)
    left_breeze = sample_anchors_from_mask(ex['ailes_vent_profondes'] & (np.arange(W)[None, :] < W // 2 - 70), 4, margin=32)
    right_breeze = sample_anchors_from_mask(ex['ailes_vent_profondes'] & (np.arange(W)[None, :] > W // 2 + 70), 4, margin=32)
    breeze_spots = [(x, y, 1) for x, y in left_breeze] + [(x, y, -1) for x, y in right_breeze]
    part_frames = build_sky_particles_frames(W, H, glints, breezes, glint_spots, breeze_spots, n_frames=SCENE_LOOP // PART_TICKS)

    anim_map = {
        'souffle_stratosphere_bpl': (bpl_frames, BPL_TICKS),
        'alizes_et_eclats': (part_frames, PART_TICKS),
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
    for (qx, qy), c in ((entry_px, (255, 230, 40, 255)), (boss_px, (60, 220, 255, 255))):
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
        title_en='Sky Tower Summit - Rayquaza Arena (4:3)',
        title_fr='Sommet Tour Céleste',
        description_fr='Sommet de la Tour Céleste et arène de Rayquaza avec accès sud, couronne de nuages et arc stratosphérique (réf. b71 / D13P03).',
        comment_fr='PMDO 0.8.12. Rendu généré 4:3 référencé sur b71 (fidélité brute max 6.05 < 35) ; Palettes 9 et 10 exactes de D13P01.bpl. Aucun test runtime PMDO.',
        w=W,
        h=H,
        stack_named=stack_named,
        blocked=blocked,
        entry_px=entry_px,
        goal_name='boss_sommet',
        goal_px=boss_px,
    )

    rlum = lum_of(ref)
    ref_targets = {
        'couronne_et_acces_sud': ref[rlum >= 225.0].mean(0),
        'reliefs_couronne': ref[(rlum >= 185.0) & (rlum <= 255.0)].mean(0),
        'ourlet_couronne': ref[(rlum >= 145.0) & (rlum < 225.0)].mean(0),
        'stratosphere_outremer': ref[rlum < 118.0].mean(0),
        'arc_horizon_lumineux': ref[(rlum >= 186.0) & (rlum < 232.0)].mean(0),
        'ailes_vent_profondes': ref[(rlum >= 130.0) & (rlum < 156.0)].mean(0),
        'plumes_vent_sculptees': ref[(rlum >= 156.0) & (rlum < 186.0)].mean(0),
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
    sol_fid = dist_rgb(layers['sol_complet'][..., :3].reshape(-1, 3).mean(0), ref_sol.reshape(-1, 3).mean(0))
    assert sol_fid < 35.0

    manifest = {
        'id': LOT_NAME,
        'prefix': PFX,
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'scene_loop_ticks': SCENE_LOOP,
        'canonical_biome': {
            'rom_code': 'b71 / D13P03',
            'dungeon_fr': 'Sommet de la Tour Céleste (Rayquaza)',
            'dungeon_en': 'Sky Tower Summit',
            'reference_png': REF_PNG.relative_to(R).as_posix(),
            'reference_sha256': sha(REF_PNG),
            'rom_bpl_palettes': {
                'palette_9_horizon': {'palette_index': 9, 'frames': 8, 'duration_per_frame_ticks': 8, 'loop_ticks': 64},
                'palette_10_ailes': {'palette_index': 10, 'frames': 8, 'duration_per_frame_ticks': 8, 'loop_ticks': 64},
            },
        },
        'nature': 'Décor généré référencé sur la capture ROM b71 / D13P03 (distance brute max 6.05 / 35) ; souffle stratosphérique piloté par D13P01.bpl et volutes détourées sur calque 09.',
        'art_approved': False,
        'raw_inputs': [
            {'file': (RAW / 'decor.png').relative_to(R).as_posix(), 'size': list(Image.open(RAW / 'decor.png').size),
             'sha256': sha(RAW / 'decor.png'), 'images': [REF_PNG.relative_to(R).as_posix()]},
            {'file': (RAW / 'sol_complet.png').relative_to(R).as_posix(), 'size': list(Image.open(RAW / 'sol_complet.png').size),
             'sha256': sha(RAW / 'sol_complet.png'), 'images': [REF_SOL_CROP.relative_to(R).as_posix()]},
            {'file': (RAW / 'particules_poses.png').relative_to(R).as_posix(), 'size': list(Image.open(RAW / 'particules_poses.png').size),
             'sha256': sha(RAW / 'particules_poses.png'), 'images': [REF_PNG.relative_to(R).as_posix()]},
        ],
        'layers': layer_list,
        'access': {
            'entry_px': entry_px,
            'boss_px': boss_px,
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
    print(f'OK {PFX}: walkable={int((~blocked).sum())}, entry={entry_px}, boss={boss_px}, max_brut={max(v["distance"] for v in raw_fid.values())}, sol={sol_fid}')


if __name__ == '__main__':
    build()
