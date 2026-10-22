"""Entrée de la Tour Céleste sud -> nord V1 (EST1) — format 4:3 vaste (768 x 576 px, 96 x 72 cases).

Référence canonique PMD Red Port :
- `references/D13P01.png` (`MAP_FILE_ID_SKY_TOWER_ENTRY`, 408 x 288 px) ;
- `references/rom_d13p01_bpl.json` extrait de `data/map_bg/D13P01.bpl` (Palettes 9 & 10, 8 poses x 8 ticks = 64 ticks).

Pipeline strict conforme à METHODE_MAGENTA_ET_GENERATEUR.md :
- `bruts/decor.png` (1200 x 896, images=[D13P01]) + `bruts/sol_complet.png` (1200 x 896, images=[découpe x4 du sol])
  + `bruts/particules_poses.png` (sur fond #FF00FF pur, détouré par key() avec 0 px magenta) ;
- segmentation pleine résolution `classify_fullres()` avant réduction non mélangeante `down_class()` + `exclusive()` ;
- garde bloquante de fidélité chromatique `assert_fidelity_below(..., 35.0)` ;
- 10 calques RGBA (00..07 statiques disjoints + 08 table BPL matérielle D13P01 + 09 poses pixel-art détourées) + .ora + .rsground.
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
if str(HERE) not in sys.path:
    sys.path.insert(0, str(HERE))

from sky_tower_common import (  # noqa: E402
    ESN,
    assert_fidelity_below,
    build_d13p01_bpl_wave_frames,
    build_sky_particles_frames,
    cell_grid,
    close_,
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
REF_PNG = HERE / 'references/D13P01.png'
REF_SOL_CROP = HERE / 'references/D13P01_sol_crop_4x.png'
REF_BPL_JSON = HERE / 'references/rom_d13p01_bpl.json'

LOT_NAME = 'entree_tour_celeste_sud_nord_v1'
OUT = R / 'renders' / LOT_NAME
NAMESPACE = 'entree_tour_celeste'
STAGE = R / '.cache' / LOT_NAME / NAMESPACE
ASSET = 'est1_entree_tour_celeste'
PFX = 'EST1'
ORA_NAME = f'{PFX}_entree_tour_celeste_calques.ora'

W, H = 768, 576
SRC = (1200, 896)
SCENE_LOOP = 64
BPL_TICKS = 8
PART_TICKS = 4

STATIC = [
    'esplanade_nuage',
    'motifs_vent_sol',
    'rebords_festonnes',
    'arche_portail_nord',
    'seuil_obscur',
    'ciel_royal',
    'panaches_nuages',
]
ANIMS = ['courants_bpl', 'brises_et_eclats']

PALETTE_GROUPS = {
    'sol': (['sol_complet', 'esplanade_nuage', 'motifs_vent_sol'], 48),
    'rebords': (['rebords_festonnes', 'arche_portail_nord'], 48),
    'portail': (['seuil_obscur'], 16),
    'ciel': (['ciel_royal'], 32),
    'panaches': (['panaches_nuages'], 48),
}


def materials(a: np.ndarray) -> dict[str, np.ndarray]:
    """Classifieur chromatique identique appliqué au rip D13P01 et à decor.png (METHODE §8)."""
    lum = lum_of(a)
    return {
        'seuil_obscur': lum < 60.0,
        'ciel_royal': (lum >= 60.0) & (lum < 130.0),
        'rebords_festonnes': (lum >= 130.0) & (lum < 185.0),
        'nuage_moyen': (lum >= 185.0) & (lum < 225.0),
        'nuage_clair': lum >= 225.0,
    }


def classify_fullres(a: np.ndarray) -> dict[str, np.ndarray]:
    """Partitionne 100 % des pixels 1200x896 en 7 classes statiques exclusives."""
    h, w, _ = a.shape
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    yy, xx = np.mgrid[:h, :w]

    # 1. Ouverture sombre nord (portail de la Tour Céleste)
    portal = (r < 32) & (g < 45) & (b < 135) & (yy < 225) & (np.abs(xx - 600) < 130)
    portal = nd.binary_fill_holes(close_(keep_large(portal, 250), 4))

    # 2. Pont sud + grande esplanade centrale praticable jusqu'au pied du portail
    pale_cloud = (r >= 176) & (g >= 224) & (b >= 235)
    core = nd.binary_erosion(pale_cloud, iterations=2)
    lab, _ = nd.label(core)
    seeds = (set(np.unique(lab[-4:, 540:660])) | set(np.unique(lab[420:480, 540:660]))) - {0}
    walk_body = nd.binary_fill_holes(nd.binary_dilation(np.isin(lab, list(seeds)), iterations=6)) & ~portal

    # Couloir de jonction nord reliant l'esplanade au seuil du portail
    py_ys, py_xs = np.where(portal)
    p_south = int(py_ys.max())
    neck = (yy >= p_south - 2) & (yy <= p_south + 78) & (np.abs(xx - 600) <= 58) & ~portal
    walk_platform = (walk_body | neck) & ~portal

    # 3. Motifs internes du sol (croissants blancs purs et triangles/papillons pervenche)
    inner_plat = nd.binary_erosion(walk_platform, iterations=8)
    white_crescents = inner_plat & (r >= 238) & (g >= 250) & (b >= 250)
    blue_marks = inner_plat & (r < 192) & (g < 238)
    motifs_sol = keep_large(white_crescents | blue_marks, 14)
    esplanade = walk_platform & ~motifs_sol

    # 4. Ourlet festonné bleu moyen entourant l'esplanade et le pont sud (même seuil lum >= 125 que le rip)
    rim_band = nd.binary_dilation(walk_platform, iterations=24) & ~walk_platform & ~portal
    rebords = rim_band & (lum_of(a) >= 125.0) & (r < 225)

    # 5. Couronne tourbillonnante organique encadrant l'ouverture nord (zéro découpe rectangulaire)
    arche_halo = nd.binary_dilation(portal, iterations=48) & ~walk_platform & ~rebords & ~portal
    arche = keep_large(arche_halo & (lum_of(a) >= 118.0) & (lum_of(a) < 226.0), 80)

    # 6. Reste extérieur : ciel cobalt royal vs grands panaches de nuages blancs/azur
    rem = ~(esplanade | motifs_sol | rebords | arche | portal)
    ciel_royal = rem & (lum_of(a) < 142.0)
    panaches = rem & ~ciel_royal

    masks = {
        'seuil_obscur': portal,
        'motifs_vent_sol': motifs_sol,
        'esplanade_nuage': esplanade,
        'rebords_festonnes': rebords,
        'arche_portail_nord': arche,
        'ciel_royal': ciel_royal,
        'panaches_nuages': panaches,
    }
    total = sum(m.astype(int) for m in masks.values())
    assert np.all(total == 1), 'Partition fullres non exclusive'
    return masks


def build() -> None:
    (HERE / 'viewer_template.html').write_text(make_viewer_template(
        code='EST1',
        title_short='Entrée Tour Céleste — format 4:3 vaste (768×576)',
        subtitle_html=(
            'Décor généré <strong>référencé sur la capture ROM exacte <code>D13P01</code></strong> '
            '(<em>Sky Tower Entrance</em>) : pont de nuage au sud s’ouvrant sur la grande esplanade de nuage glacé '
            'et montant jusqu’au portail nord. Les <strong>courants des panaches</strong> (calque <code>08</code>) '
            'appliquent les tables RVB exactes des <strong>Palettes 9 &amp; 10 de <code>D13P01.bpl</code></strong> '
            '(<code>8 poses × 8 ticks = 64 ticks</code>), et le calque <code>09</code> anime <strong>8 poses pixel-art '
            'détourées sans aucun halo</strong> (<code>16 poses × 4 ticks = 64 ticks</code>).'
        ),
        ref_label='Référence canonique D13P01 (408×288)',
        poses_legend='Poses détourées (×4) : 4 éclats célestes + 4 brises d’alizé',
        status_html='Statut : décor généré référencé sur <code>D13P01</code> (fidélité matériaux &lt; 18 / 35), <code>art_approved = false</code>, <code>runtime_tested = false</code>.',
        goal_label='donjon_seuil',
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

    # 1. Fidélité chromatique bloquante avant toute suite (METHODE_MAGENTA_ET_GENERATEUR.md §8)
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

    # 2. Segmentation pleine résolution puis réduction non mélangeante 1200x896 -> 768x576
    m_full = classify_fullres(a)
    order = [
        'seuil_obscur',
        'motifs_vent_sol',
        'esplanade_nuage',
        'rebords_festonnes',
        'arche_portail_nord',
        'ciel_royal',
        'panaches_nuages',
    ]
    ex, cols = down_class(a, m_full, order)

    layers = {'sol_complet': rgba(down_full(f), np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba(cols[k], ex[k])

    q = {}
    for keys, n in PALETTE_GROUPS.values():
        q.update(quantize_group({k: layers[k] for k in keys}, n))
    layers = q

    for k, v in ex.items():
        Image.fromarray((v * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')

    # 3. Grille de collision 16x16 : chemin praticable continu de l'entrée sud jusqu'au seuil nord
    walk_px = ex['esplanade_nuage'] | ex['motifs_vent_sol']
    cl, _ = nd.label(walk_px)
    south_seeds = np.unique(cl[-2:, :][walk_px[-2:, :]])
    walk = np.isin(cl, south_seeds[south_seeds > 0])
    blocked = cell_grid(~walk)
    walk_grid_px = (~blocked).repeat(8, 0).repeat(8, 1)
    Image.fromarray((walk_grid_px * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')

    p_ys, p_xs = np.nonzero(ex['seuil_obscur'])
    goal_cell_y = int(p_ys.max() // 8) + 2
    goal_cell_x = int(round(p_xs.mean() / 8))
    entry_px = find_marker_16x16(blocked, (48, 67), range(62, 70))
    threshold_px = find_marker_16x16(blocked, (goal_cell_x, goal_cell_y), range(goal_cell_y, goal_cell_y + 10))
    reach_ok, _ = ESN.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (threshold_px[1] // 8, threshold_px[0] // 8))
    assert reach_ok, f'Chemin 16x16 introuvable entre {entry_px} et {threshold_px}'

    # 4. Extraction propre des 8 poses pixel-art + animations multicalques (08 = D13P01.bpl, 09 = poses détourées)
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

    # Image statique recomposée pour classer les veines organiques exactes sans aucun artefact de bord
    base_comp = Image.new('RGBA', (W, H))
    for nm0 in ['sol_complet'] + STATIC:
        base_comp.alpha_composite(Image.fromarray(layers[nm0]))
    base_rgb = np.array(base_comp)[..., :3]
    plume_lum = lum_of(base_rgb)
    # Veines animées des panaches : franges glacées (Palette 9) + sillons d'alizé (Palette 10)
    bright_plume = ex['panaches_nuages'] & (plume_lum >= 210.0) & (plume_lum < 246.0)
    deep_plume = (ex['panaches_nuages'] & (plume_lum >= 150.0) & (plume_lum < 210.0)) | ex['arche_portail_nord']
    bpl_frames = build_d13p01_bpl_wave_frames(base_rgb, bright_plume, base_rgb, deep_plume, bpl_meta)

    glint_spots = sample_anchors_from_mask(ex['ciel_royal'] | ex['panaches_nuages'], 10, margin=32)
    left_breeze = sample_anchors_from_mask(ex['panaches_nuages'] & (np.arange(W)[None, :] < W // 2 - 80), 4, margin=36)
    right_breeze = sample_anchors_from_mask(ex['panaches_nuages'] & (np.arange(W)[None, :] > W // 2 + 80), 4, margin=36)
    breeze_spots = [(x, y, 1) for x, y in left_breeze] + [(x, y, -1) for x, y in right_breeze]
    part_frames = build_sky_particles_frames(W, H, glints, breezes, glint_spots, breeze_spots, n_frames=SCENE_LOOP // PART_TICKS)

    anim_map = {
        'courants_bpl': (bpl_frames, BPL_TICKS),
        'brises_et_eclats': (part_frames, PART_TICKS),
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

    # 5. Scène animée 64 ticks (pas de 4 ticks = 16 images WebP sans perte) + scène t=0 exacte
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
        title_en='Sky Tower Entrance - South to North (4:3)',
        title_fr='Entrée Tour Céleste',
        description_fr='Arrivée au sud sur le pont de nuages, esplanade glacée et portail nord de la Tour Céleste (réf. D13P01 + D13P01.bpl).',
        comment_fr='PMDO 0.8.12. Rendu généré 4:3 référencé sur D13P01 ; Palettes 9 et 10 exactes de D13P01.bpl (8 x 8 = 64 ticks). Aucun test runtime PMDO.',
        w=W,
        h=H,
        stack_named=stack_named,
        blocked=blocked,
        entry_px=entry_px,
        goal_name='donjon_seuil',
        goal_px=threshold_px,
    )

    rlum = lum_of(ref)
    arch_ref = ref[:110, 100:308]
    ref_targets = {
        'esplanade_nuage': ref[rlum >= 215.0].mean(0),
        'motifs_vent_sol': ref[(rlum >= 180.0) & (rlum <= 255.0)].mean(0),
        'rebords_festonnes': ref[(rlum >= 125.0) & (rlum < 195.0)].mean(0),
        'arche_portail_nord': arch_ref[(lum_of(arch_ref) >= 118.0) & (lum_of(arch_ref) < 226.0)].mean(0),
        'seuil_obscur': ref[rlum < 60.0].mean(0),
        'ciel_royal': ref[(rlum >= 60.0) & (rlum < 142.0)].mean(0),
        'panaches_nuages': ref[rlum >= 142.0].mean(0),
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
    assert sol_fid < 35.0, f'sol_complet hors seuil : {sol_fid}'

    manifest = {
        'id': LOT_NAME,
        'prefix': PFX,
        'format': '4:3 vaste',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'scene_loop_ticks': SCENE_LOOP,
        'canonical_biome': {
            'rom_code': 'D13P01',
            'dungeon_fr': 'Tour Céleste (entrée)',
            'dungeon_en': 'Sky Tower Entrance',
            'reference_png': REF_PNG.relative_to(R).as_posix(),
            'reference_sha256': sha(REF_PNG),
            'rom_bpl_palettes': {
                'palette_9_panaches': {'palette_index': 9, 'frames': 8, 'duration_per_frame_ticks': 8, 'loop_ticks': 64},
                'palette_10_alizes': {'palette_index': 10, 'frames': 8, 'duration_per_frame_ticks': 8, 'loop_ticks': 64},
            },
        },
        'nature': 'Décor généré référencé sur la capture ROM D13P01 (pas des tuiles natives certifiées) ; courants animés pilotés par les Palettes 9 et 10 exactes de D13P01.bpl (8 x 8 = 64 ticks) et poses pixel-art détourées sur calque 09 (16 x 4 = 64 ticks).',
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
