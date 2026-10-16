"""SVJ2 : quatre cartes volcaniques, jets generes hors cadre, formats PMDO natifs.
Aucun ancien lot ni helper commun modifié. Les pixels ne sont pas extraits de la ROM.
"""
from pathlib import Path
import sys
import json
import shutil
import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1]))
from source.entree_terres_volcaniques_v1.build import Map as BaseMap
from source.maps_suite_v1.pipeline import ROOT, W, H, PHASES, TICKS, sha, image_size
from source.suite_jaillissements_v2.columns import Columns


class Map(BaseMap):
    def __init__(self, here):
        super().__init__(here)
        self.out = ROOT / 'renders/suite_jaillissements_v2' / self.here.name
        self.b.OUT = self.out
        self.ref = HERE / 'reference/D41P41A.png'
        self.columns = Columns()

    def classify(self, a):
        c=self.config
        r,g,b=a.astype(float).transpose(2,0,1)
        def polygon(points):
            im=Image.new('1',(a.shape[1],a.shape[0]));ImageDraw.Draw(im).polygon([tuple(p) for p in points],fill=1)
            return np.array(im,bool)
        lava=nd.binary_fill_holes((r>175)&(g>30)&(r-b>100)&(g-b>10))
        depth=polygon(c['depth_polygon_raw']) & ~lava if c['kind']=='entrance' else np.zeros(lava.shape,bool)
        envelope=polygon(c['floor_polygon_raw'])
        lum=a.astype(float) @ [.299,.587,.114]
        floor=envelope & (nd.median_filter(lum,5)>=65) & ~(lava|depth)
        floor=nd.binary_closing(floor,iterations=2)
        # Conserver aussi l'arrivee au bord sud, que la fermeture zero-border retirerait.
        floor[-4:] = envelope[-4:] & ~(lava[-4:]|depth[-4:]) & (lum[-4:]>=65)
        labels,n=nd.label(floor);counts=np.bincount(labels.ravel());counts[0]=0
        floor=labels==counts.argmax()
        floor=nd.binary_erosion(floor,iterations=2,border_value=1) & ~(lava|depth)
        floor[:,:3]=False;floor[:,-3:]=False
        shadow=floor & (nd.uniform_filter(lum,5)<c['shadow_luminance_max'])
        rim=nd.binary_dilation(floor,iterations=12)&~(floor|lava|depth)
        result={'cendre':floor&~shadow,'ombres':shadow,'rebords':rim,'basalte':~(floor|rim|lava|depth)}
        if c['kind']=='entrance':result['profondeur']=depth
        result['lave']=lava
        return result

    def build(self):
        c, b, out, pfx = self.config, self.b, self.out, self.pfx
        for name in ('calques', 'animation', 'review', 'masques'):
            shutil.rmtree(out / name, ignore_errors=True); (out / name).mkdir(parents=True)
        decor = b.rgb(self.here / 'bruts' / c['decor_file']); sol = b.rgb(ROOT / 'source/entree_terres_volcaniques_v1/bruts/sol_complet.png')
        assert decor.shape == (896, 1200, 3)
        out.mkdir(parents=True, exist_ok=True)
        layers, masks, plane, normal = b.reduce_classes(decor, self.classify(decor))
        # Le sol est un support de texture, pas une nouvelle composition. Un sol panoramique
        # peut être recadré à facteur uniforme sans jamais étirer la carte ni changer son décor.
        floor_scale = H / sol.shape[0]
        floor_width = round(sol.shape[1] * floor_scale)
        assert floor_width >= W, 'Sol complet trop étroit'
        floor_crop = (floor_width - W) // 2
        floor_rgb = np.stack([np.array(Image.fromarray(sol[..., i].astype(np.float32)).resize(
            (floor_width, H), Image.Resampling.BOX))[:, floor_crop:floor_crop + W] for i in range(3)], -1)
        layers['sol_complet'] = b.rgba(np.clip(np.round(floor_rgb), 0, 255).astype('uint8'), np.ones((H, W), bool))
        normal['floor_support'] = {'source_size': [sol.shape[1], sol.shape[0]], 'scale_xy': floor_scale,
                                   'scaled_width': floor_width, 'crop_left': floor_crop,
                                   'note': 'support texture indépendant, non aligné ; sol visible issu du décor'}
        ref = b.rgb(self.ref)
        depth_color = None
        has_depth = c['kind'] == 'entrance'
        if has_depth and c.get('depth_mode') != 'drawn':
            flat = ref.reshape(-1, 3); lum = flat.astype(float) @ [.299, .587, .114]
            pool = flat[lum < 40]; assert len(pool) > 10
            cs, ns = np.unique(pool, axis=0, return_counts=True); depth_color = cs[ns.argmax()]
            layers['profondeur'] = b.rgba(depth_color, masks['profondeur'])
        # La profondeur dessinée garde ses volumes générés, sans les remplacer par un aplat.
        depth_layer = layers.get('profondeur')
        if has_depth and c.get('depth_mode') == 'drawn':
            depth_layer = b.quantize({'profondeur': depth_layer})['profondeur']
        layers = {**b.quantize({k: a for k, a in layers.items() if k != 'profondeur'}),
                  **({'profondeur': depth_layer} if has_depth else {})}
        walk = masks['cendre'] | masks['ombres']; blocked = b.collision_grid(walk)
        markers, explored = self.access(blocked, walk)
        emitters, colors = b.dust_setup(masks['lave']), self.effect_colors(ref)
        effects = [self.effect(t, emitters, masks['lave'], colors) for t in range(PHASES)]
        order = ['sol_complet', 'cendre', 'ombres', 'rebords', 'basalte']
        if has_depth:
            order.append('profondeur')
        lava_frames = [self.lava_frame(t, layers['lave']) for t in range(PHASES)]
        cols = self.columns.choose(masks['lave'], walk)
        jets = self.columns.frames(cols, masks['lave'], walk)
        stack = [(name, [layers[name]], 60) for name in order] + [('lave', lava_frames, TICKS), ('braises', effects, TICKS)] + [(k, jets[k], TICKS) for k in jets]
        info = []
        for i, (name, frames, ticks) in enumerate(stack):
            path = f'calques/{pfx}_{i:02d}_{name}.png' if len(frames) == 1 else f'animation/{pfx}_{i:02d}_{name}_fNN.png'
            for t, a in enumerate(frames):
                Image.fromarray(a).save(out / path.replace('NN', f'{t:02d}'))
            info.append({'name': name, 'file': path, 'phases': len(frames), 'ticks': ticks})
        for name, mask in {**masks, 'praticable': walk, 'collisions': blocked}.items():
            Image.fromarray(mask.astype('uint8') * 255).save(out / 'masques' / f'{pfx}_{name}.png')
        scenes = []
        for t in range(PHASES):
            im = Image.new('RGBA', (W, H))
            for _, frames, _ in stack:
                im.alpha_composite(Image.fromarray(frames[t % len(frames)]))
            scenes.append(im)
        scenes[0].save(out / 'review' / f'{pfx}_scene_t000.png')
        # Apercu anime dans le navigateur : pas quatre WebP lourds dupliques.
        ov = Image.new('RGBA', (W, H)); dr = ImageDraw.Draw(ov)
        for y, x in zip(*np.nonzero(blocked)):
            dr.rectangle((x * 8, y * 8, x * 8 + 7, y * 8 + 7), fill=(230, 30, 30, 85))
        for name, p in markers.items():
            color = {'entrance': (255, 230, 40, 255), 'boss': (255, 80, 200, 255)}.get(name, (40, 240, 255, 255))
            dr.rectangle((*p, p[0] + 15, p[1] + 15), outline=color, width=2)
        review = scenes[0].copy(); review.alpha_composite(ov); review.save(out / 'review' / f'{pfx}_collisions_marqueurs.png')
        fid = {'brut': self.fidelity(decor, ref), 'sortie': self.fidelity(np.array(scenes[0]), ref)}
        assert all(v['distance'] < 35 for stage in fid.values() for v in stage.values()), fid
        counts = self.native(stack, blocked, markers); self.ora(stack)
        files = [self.here / 'bruts' / c['decor_file'], ROOT / 'source/entree_terres_volcaniques_v1/bruts/sol_complet.png']
        manifest = {'lot': self.here.name, 'prefix': pfx, 'title': c['title'], 'kind': c['kind'],
                    'date': '2026-10-16', 'columns': cols, 'column_sprite': {'file':str((HERE/'shared/colonne_magenta.png').relative_to(ROOT)), 'sha256':sha(HERE/'shared/colonne_magenta.png')}, 'column_method': 'nouveau sprite, preparation AGM3 immuable ; bande periodique ascendante, couronne translatee, gouttes paraboliques ; 24x5 ticks, aucun sommet visible', 'base_recipe_sha256':sha(ROOT/'source/entree_terres_volcaniques_v1/build.py'), 'column_prep_sha256':sha(ROOT/'source/arene_groudon_magma_v3/colonnes_generees.py'), 'size_px': [W, H], 'grid_8px': [96, 72], 'format': '4:3 vaste',
                    'method': 'Rendu genere reference, reduction par classe puis formats natifs. Pas des pixels ROM.',
                    'art_approved': False, 'reference': {'file': str(self.ref.relative_to(ROOT)), 'sha256': sha(self.ref)},
                    'raw_inputs': [{'file': str(p.relative_to(ROOT)), 'sha256': sha(p),
                                    'size': image_size(p)} for p in files],
                    'palette_policy': c['palette_policy'], 'config_sha256': sha(self.here / 'config.json'), 'generation': json.loads((self.here / 'generation.json').read_text()),
                    'normalization': normal, 'segmentation': {'floor_polygon_raw': c['floor_polygon_raw'],
                        'shadows': f'luminance lissee 5 px < {c["shadow_luminance_max"]} dans le sol existant',
                        'rebords': 'bande de 12 px bruts autour du sol, bloquante', 'details': 'cendre, teintes sombres du sol, rebords, basalte, prolongement nord, lave separes ; zones d edition pas detourage parfait', 'lava_mask_raw': 'fill_holes(R>175,G>30,R-B>100,G-B>10)',
                        'depth_mode': c.get('depth_mode', 'magenta' if has_depth else 'none'),
                        'depth_polygon_raw': c.get('depth_polygon_raw')},
                    'fidelity': fid, 'fidelity_max': 35, 'layers': info,
                    'depth_color': depth_color.tolist() if depth_color is not None else None,
                    'dust': {'label': 'braises montantes calculees (deux pixels)', 'emitters': emitters, 'colors': colors, 'phases': PHASES, 'ticks': TICKS,
                             'law': c['effect_law'], 'origin': 'calculee, couleurs exactes du rip ; pas une animation officielle'},
                    'lava_animation': {'law': c['lava_law'], 'origin': 'deplacement periodique des pixels de lave generes, sans recoloration ; pas le BPL officiel', 'border_fixed_px': 3, 'phases': PHASES, 'ticks': TICKS},
                    'scene_loop_ticks': PHASES * TICKS,
                    'access': {'markers': markers, 'reachable_16px': True, 'reachable_positions': explored,
                               'warp': False, 'destination_linked': False},
                    'origins': {'terrain': 'genere reference ' + c['reference_code'], 'effects': 'recalcules, couleurs du rip',
                                'native': 'formats et grille uniquement'},
                    'pmdo': {'version': '0.8.12', 'namespace': c['namespace'], 'asset': c['asset'],
                             'template': str(b.TEMPLATE.relative_to(ROOT)), 'template_sha256': sha(b.TEMPLATE),
                             'tile_counts': counts, 'runtime_tested': False, 'render_tested': False}}
        (out / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
        print(json.dumps({'prefix': pfx, 'fidelity': fid, 'markers': markers}, indent=2))
        return manifest


if __name__ == '__main__':
    import argparse
    parser=argparse.ArgumentParser();parser.add_argument('--map',default='all');a=parser.parse_args()
    for path in sorted((HERE/'maps').iterdir()):
        if a.map=='all' or a.map==path.name: Map(path).build()
