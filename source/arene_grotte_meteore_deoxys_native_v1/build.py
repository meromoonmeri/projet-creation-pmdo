"""Grotte Météore — Arène de Deoxys V1 (FGM1) — Port Natif Multicalque 576 x 576 px (72 x 72 cases).

Référence canonique PMD Red Port : `references/b74_meteor_cave_deoxys.png` (576 x 576 px).
Nature : 100 % Natif (dérive RVB 0,00 ; recomposition t=0 bit-à-bit égale à b74_meteor_cave_deoxys.png ;
extraction des météorites flottantes par composantes connexes entières sans aucune découpe de cristal ;
couleurs d'animation strictement incluses dans la palette native exacte de b74).
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
    cell_grid,
    dist_rgb,
    export_ground_project,
    find_marker_16x16,
    lum_of,
    make_viewer_template,
    rgb,
    rgba,
    sha,
    write_ora,
)

REF_PNG = HERE / 'references/b74_meteor_cave_deoxys.png'
LOT_NAME = 'arene_grotte_meteore_deoxys_native_v1'
OUT = R / 'renders' / LOT_NAME
NAMESPACE = 'arene_grotte_meteore_deoxys'
STAGE = R / '.cache' / LOT_NAME / NAMESPACE
ASSET = 'fgm1_arene_grotte_meteore'
PFX = 'FGM1'
ORA_NAME = f'{PFX}_arene_grotte_meteore_calques.ora'

W, H = 576, 576
SCENE_LOOP = 64
ANIM_TICKS = 4
N_PHASES = SCENE_LOOP // ANIM_TICKS  # 16 poses x 4 ticks = 64 ticks

STATIC = [
    'dalle_meteorite_violette',
    'anneaux_gravures_sombres',
    'coeur_cyan_central',
    'circuits_psioniques',
    'rempart_cristaux_sombres',
    'rempart_facettes_vives',
    'meteorites_fixes_et_cosmos',
]
ANIMS = ['onde_psionique_b74', 'levitation_meteorites']


def rgba_any(colors: np.ndarray, mask: np.ndarray) -> np.ndarray:
    out = np.zeros((*mask.shape, 4), dtype=np.uint8)
    out[..., :3] = colors
    out[..., 3] = 255
    out[~mask] = 0
    return out


def cell_grid_any(blocked_px: np.ndarray) -> np.ndarray:
    h, w = blocked_px.shape
    return blocked_px.reshape(h // 8, 8, w // 8, 8).any(axis=(1, 3))


def build() -> None:
    (HERE / 'viewer_template.html').write_text(make_viewer_template(
        code='FGM1',
        title_short='Grotte Météore · Arène de Deoxys — Port Natif Multicalque (576×576)',
        subtitle_html=(
            '<strong>Port 100 % Natif (dérive RVB <code>0,00</code>)</strong> de la salle finale post-Rayquaza '
            '<code>b74</code> (<em>Meteor Cave</em>, <code>576×576 px</code>, <code>72×72</code> cases) décomposée en '
            '<strong>10 calques RGBA</strong> : la recomposition à <code>t = 0</code> est <strong>bit-à-bit identique</strong> '
            'à la capture native. Onde radiale centrifuge dans la palette native exacte (calque <code>08</code>) et '
            'lévitation douce de <strong>8 modules entiers de météorites</strong> sans découpe (calque <code>09</code>).'
        ),
        ref_label='Référence native b74 (576×576, distance 0,00)',
        poses_legend='Modules natifs entiers (×4) : 8 météorites en lévitation',
        status_html='Statut : <strong>100 % pixels natifs exacts de <code>b74</code></strong> (recomposition <code>t=0</code> bit-à-bit identique, <code>distance = 0,00</code>), <code>art_approved = false</code>, <code>runtime_tested = false</code>.',
        goal_label='coeur_deoxys',
    ))

    if OUT.exists():
        shutil.rmtree(OUT)
    for d in ['calques', 'poses', 'masques', 'review'] + [f'animation/{x}' for x in ANIMS]:
        (OUT / d).mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)

    ref = rgb(REF_PNG)
    assert ref.shape == (H, W, 3)
    r, g, b = ref[..., 0], ref[..., 1], ref[..., 2]
    yy, xx = np.mgrid[:H, :W]

    # Couleur spatiale dominante exacte du rip b74 : (0, 0, 95)
    space_mask = (r < 20) & (g < 20) & (b < 120)
    vals, cnts = np.unique(ref[space_mask].reshape(-1, 3), axis=0, return_counts=True)
    bg_space_rgb = vals[int(np.argmax(cnts))]  # [0, 0, 95]

    # 1. Extraction par composantes connexes entières des météorites isolées dans l'espace
    fg_all = ~space_mask
    lab_fg, n_fg = nd.label(fg_all)
    comp_sizes = nd.sum(fg_all, lab_fg, range(1, n_fg + 1))
    main_crater_label = int(np.argmax(comp_sizes)) + 1
    crater_whole = lab_fg == main_crater_label
    outer_meteors_all = fg_all & ~crater_whole

    # Sélection de 8 modules complets de météorites flottantes bien espacés (jamais coupés !)
    meteor_candidates = []
    for lbl_i in range(1, n_fg + 1):
        if lbl_i == main_crater_label:
            continue
        m_i = lab_fg == lbl_i
        ys_i, xs_i = np.where(m_i)
        # Marge >= 4 px des bords pour que ±2 px ne touche jamais le cadre
        if ys_i.min() >= 4 and ys_i.max() < H - 4 and xs_i.min() >= 4 and xs_i.max() < W - 4 and m_i.sum() >= 35:
            ang = float(np.arctan2(ys_i.mean() - H / 2.0, xs_i.mean() - W / 2.0))
            meteor_candidates.append((ang, lbl_i, m_i))
    meteor_candidates.sort(key=lambda t: t[0])
    step_m = max(1, len(meteor_candidates) // 8)
    chosen_meteors = [meteor_candidates[k * step_m] for k in range(min(8, len(meteor_candidates)))]
    levitating_mask = np.zeros((H, W), dtype=bool)
    for _, _, m_i in chosen_meteors:
        levitating_mask |= m_i

    # 2. Segmentation intérieure/rempart du cratère central sans aucune altération de couleur
    # Intérieur praticable : dalle carrée centrale entourée par le rempart cristallin
    floor_seed = crater_whole & (b >= 165) & (r < 115) & (np.abs(xx - 288) < 146) & (np.abs(yy - 288) < 146)
    crater_floor = nd.binary_fill_holes(nd.binary_closing(floor_seed, iterations=12)) & crater_whole
    rim_wall = crater_whole & ~crater_floor

    coeur_cyan = crater_floor & (g >= 100) & (b >= 200) & (r < 90)
    circuits_psi = crater_floor & (r >= 165) & (b >= 150) & ~coeur_cyan
    anneaux_sombres = crater_floor & (r < 55) & (g < 20) & ~coeur_cyan & ~circuits_psi
    dalle_violette = crater_floor & ~(coeur_cyan | circuits_psi | anneaux_sombres)

    rempart_vif = rim_wall & ((r >= 175) | (g >= 95))
    rempart_sombre = rim_wall & ~rempart_vif

    # Le calque 07 porte les météorites fixes + les nuances spatiales hors (0,0,95),
    # tandis que les 8 météorites en lévitation sont portées par le calque 09 (et (0,0,95) en dessous sur 00).
    fixes_et_cosmos = (~crater_whole) & (~levitating_mask)

    ex = {
        'dalle_meteorite_violette': dalle_violette,
        'anneaux_gravures_sombres': anneaux_sombres,
        'coeur_cyan_central': coeur_cyan,
        'circuits_psioniques': circuits_psi,
        'rempart_cristaux_sombres': rempart_sombre,
        'rempart_facettes_vives': rempart_vif,
        'meteorites_fixes_et_cosmos': fixes_et_cosmos,
    }
    # Partout hors levitating_mask, la somme des 7 masques vaut exactement 1 ; sous levitating_mask, calque 00 fournit bg_space_rgb.
    assert np.all(sum(m.astype(int) for m in ex.values()) == (~levitating_mask).astype(int))

    sol_full = np.broadcast_to(bg_space_rgb.astype(np.uint8), (H, W, 3)).copy()
    layers = {'vide_spatial': rgba_any(sol_full, np.ones((H, W), bool))}
    for k in STATIC:
        layers[k] = rgba_any(ref, ex[k])
        Image.fromarray((ex[k] * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_{k}.png')

    # 3. Collision 16x16 praticable sur toute la dalle centrale du cratère
    blocked = cell_grid_any(~crater_floor)
    walk_grid_px = (~blocked).repeat(8, 0).repeat(8, 1)
    Image.fromarray((walk_grid_px * 255).astype('uint8')).save(OUT / 'masques' / f'{PFX}_masque_praticable.png')

    entry_px = find_marker_16x16(blocked, (36, 48), range(44, 53))
    boss_px = find_marker_16x16(blocked, (36, 35), range(31, 40))
    reach_ok, _ = ESN.reachable(blocked, (entry_px[1] // 8, entry_px[0] // 8), (boss_px[1] // 8, boss_px[0] // 8))
    assert reach_ok

    # 4. Poses natives entières (les 8 météorites en lévitation) + animations 100 % palette native b74
    pose_list = []
    for idx_m, (_, _, m_i) in enumerate(chosen_meteors):
        ys_i, xs_i = np.where(m_i)
        sub = np.zeros((ys_i.max() - ys_i.min() + 1, xs_i.max() - xs_i.min() + 1, 4), dtype=np.uint8)
        sub_m = m_i[ys_i.min():ys_i.max() + 1, xs_i.min():xs_i.max() + 1]
        sub[sub_m, :3] = ref[ys_i.min():ys_i.max() + 1, xs_i.min():xs_i.max() + 1][sub_m].astype(np.uint8)
        sub[sub_m, 3] = 255
        pose_list.append((int(xs_i.min()), int(ys_i.min()), sub))
        Image.fromarray(sub).save(OUT / 'poses' / f'{PFX}_pose_{idx_m:02d}_meteorite.png')

    pose_strip = Image.new(
        'RGBA',
        (sum(p[2].shape[1] + 8 for p in pose_list) + 8, max(p[2].shape[0] for p in pose_list) + 8),
        (0, 0, 0, 0),
    )
    ox = 4
    for _, _, p_arr in pose_list:
        pose_strip.alpha_composite(Image.fromarray(p_arr), (ox, 4))
        ox += p_arr.shape[1] + 8
    pose_strip.save(OUT / 'review' / f'{PFX}_planche_poses.png')

    # Calque 08 : onde psionique radiale centrifuge strictement dans les couleurs natives exactes de b74
    # À t = 0 : pixels 100 % identiques au rip natif (0 pixel modifié !)
    psi_colors_native = [
        tuple(int(v) for v in ref[circuits_psi][0]),
        tuple(int(v) for v in ref[coeur_cyan][0]),
        tuple(int(v) for v in ref[dalle_violette][0]),
    ]
    # Extraire les tons exacts les plus fréquents des circuits, facettes et coeur cyan dans b74
    def top_color(mask_m: np.ndarray) -> np.ndarray:
        vs, cs = np.unique(ref[mask_m].reshape(-1, 3), axis=0, return_counts=True)
        return vs[int(np.argmax(cs))].astype(np.uint8)

    c_neon = top_color(circuits_psi)
    c_mid = top_color(rempart_vif)
    c_cyan = top_color(coeur_cyan)
    c_deep = top_color(dalle_violette)

    rad = np.sqrt((xx - 288.0) ** 2 + (yy - 288.0) ** 2)
    ring_band = (rad / 24.0).astype(int)  # anneaux concentriques larges (24 px), zéro damier !

    onde_frames = []
    for t in range(N_PHASES):
        fr = np.zeros((H, W, 4), dtype=np.uint8)
        if t == 0:
            # Identité bit-à-bit exacte au rip à t = 0
            active = circuits_psi | coeur_cyan
            fr[active, :3] = ref[active].astype(np.uint8)
            fr[active, 3] = 255
        else:
            # Onde radiale douce se propageant du coeur vers l'extérieur sur les circuits gravés
            wave_phase = (ring_band - t // 2) % 4
            m0 = circuits_psi & (wave_phase == 0)
            m1 = circuits_psi & (wave_phase == 1)
            m2 = circuits_psi & (wave_phase == 2)
            m3 = circuits_psi & (wave_phase == 3)
            fr[m0, :3] = c_cyan; fr[m0, 3] = 255
            fr[m1, :3] = c_neon; fr[m1, 3] = 255
            fr[m2, :3] = c_mid;  fr[m2, 3] = 255
            fr[m3, :3] = c_deep; fr[m3, 3] = 255
            # Respiration douce de la couronne interne du coeur cyan aux phases 6..10
            core_ring = coeur_cyan & (rad >= 22.0)
            fr[coeur_cyan, :3] = ref[coeur_cyan].astype(np.uint8)
            fr[coeur_cyan, 3] = 255
            if t in (6, 7, 8, 9):
                fr[core_ring, :3] = c_neon
        onde_frames.append(fr)

    # Calque 09 : lévitation orbitale entière fermée des 8 modules entiers de météorites (shift = 0 à t = 0 !)
    bob_curve = [0, 0, -1, -1, -2, -2, -1, -1, 0, 0, 1, 1, 2, 2, 1, 1]
    lev_frames = []
    for t in range(N_PHASES):
        canvas = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        for idx_m, (px0, py0, sub) in enumerate(pose_list):
            dy = bob_curve[t] if idx_m % 2 == 0 else -bob_curve[t]
            canvas.alpha_composite(Image.fromarray(sub), (px0, py0 + dy))
        lev_frames.append(np.array(canvas))

    anim_map = {
        'onde_psionique_b74': (onde_frames, ANIM_TICKS),
        'levitation_meteorites': (lev_frames, ANIM_TICKS),
    }

    order_names = ['vide_spatial'] + STATIC + ANIMS
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
    for tick in range(0, SCENE_LOOP, ANIM_TICKS):
        im = Image.new('RGBA', (W, H))
        for _, frs, tks in stack_named:
            im.alpha_composite(Image.fromarray(frs[(tick // tks) % len(frs)]))
        scenes.append(im)
    # Vérification stricte : à t = 0, la scène recomposée est BIT-À-BIT IDENTIQUE à b74_meteor_cave_deoxys.png !
    assert np.array_equal(np.array(scenes[0])[..., :3], ref.astype(np.uint8)), 'Écart avec le rip natif b74 à t=0 !'

    scenes[0].save(OUT / 'review' / f'{PFX}_scene_t000.png')
    scenes[0].save(
        OUT / 'review' / f'{PFX}_scene_animee.webp',
        save_all=True,
        append_images=scenes[1:],
        duration=round(ANIM_TICKS * 1000 / 60),
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
        title_en='Meteor Cave - Deoxys Arena Native Multilayer (576x576)',
        title_fr='Grotte Météore · Arène de Deoxys',
        description_fr='Port multicalque 100 % natif (distance RVB 0.00) de l’arène finale de Deoxys (b74, 576x576, 10 calques).',
        comment_fr='PMDO 0.8.12. Pixels 100 % natifs exacts de b74 (recomposition t=0 bit-à-bit égale, distance 0.00) ; 10 calques. Aucun test runtime PMDO.',
        w=W,
        h=H,
        stack_named=stack_named,
        blocked=blocked,
        entry_px=entry_px,
        goal_name='coeur_deoxys',
        goal_px=boss_px,
    )

    final_fid = {}
    for k in STATIC:
        fin_lay = layers[k]
        fin_px = fin_lay[fin_lay[..., 3] > 0][:, :3].mean(0)
        ref_px = ref[ex[k]].mean(0)
        final_fid[k] = {
            'mean_rgb': [round(float(v), 2) for v in fin_px],
            'ref_rgb': [round(float(v), 2) for v in ref_px],
            'distance_rip': dist_rgb(fin_px, ref_px),
        }
        assert final_fid[k]['distance_rip'] == 0.0

    manifest = {
        'id': LOT_NAME,
        'prefix': PFX,
        'format': '1:1 natif multicalque',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'scene_loop_ticks': SCENE_LOOP,
        'canonical_biome': {
            'rom_code': 'b74',
            'dungeon_fr': 'Grotte Météore (Deoxys)',
            'dungeon_en': 'Meteor Cave (Deoxys)',
            'reference_png': REF_PNG.relative_to(R).as_posix(),
            'reference_sha256': sha(REF_PNG),
        },
        'nature': '100 % Natif : pixels natifs exacts de b74_meteor_cave_deoxys.png découpés par matériaux et modules connexes entiers sans aucune modification RVB (recomposition t=0 bit-à-bit égale au rip, distance = 0.00).',
        'art_approved': False,
        'raw_inputs': [
            {'file': REF_PNG.relative_to(R).as_posix(), 'size': list(Image.open(REF_PNG).size),
             'sha256': sha(REF_PNG), 'images': [REF_PNG.relative_to(R).as_posix()]},
        ],
        'layers': layer_list,
        'access': {
            'entry_px': entry_px,
            'boss_px': boss_px,
            'walkable_cells': int((~blocked).sum()),
            'blocked_cells': int(blocked.sum()),
            'path_found_16x16': bool(reach_ok),
        },
        'fidelite_rip': {'seuil_max': 35.0, 'brut': final_fid, 'calques_finaux': final_fid, 'sol_complet': 0.0},
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
    print(f'OK {PFX}: 100% NATIF BIT-EXACT, walkable={int((~blocked).sum())}, entry={entry_px}, boss={boss_px}, max_dist=0.00')


if __name__ == '__main__':
    build()
