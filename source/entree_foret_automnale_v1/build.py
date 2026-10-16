"""EFA1 : forêt générée référencée, neuf calques fonctionnels, formats PMDO natifs.
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
from source.maps_suite_v1.pipeline import Map as BaseMap, ROOT, W, H, PHASES, TICKS, sha, image_size


class Map(BaseMap):
    def materials(self, a):
        # Diagnostic de tons chauds bois/terre, pas une attestation de feuillage automnal ROM.
        r, g, b = a[..., :3].astype(float).transpose(2, 0, 1)
        return {'chauds_clairs': (r > 120) & (g > 80) & (r-g > 15) & (r-g < 95) & (g-b > 30) & (b < 140),
                'chauds_sombres': (r >= 35) & (r <= 120) & (r-g > 5) & (r-g < 65) & (g-b > 8) & (b < 100)}

    def classify(self, a):
        c = self.config
        r, g, b = a.astype(float).transpose(2, 0, 1)
        assert not ((r > 70) & (b > 70) & (r > g*1.45) & (b > g*1.45)).any()
        def polygon(name):
            im = Image.new('1', (a.shape[1], a.shape[0]))
            ImageDraw.Draw(im).polygon([tuple(p) for p in c[name]], fill=1)
            return np.array(im, bool)
        depth = polygon('depth_polygon_raw')
        floor = polygon('floor_polygon_raw') & ~depth
        lum = a.astype(float) @ [.299, .587, .114]
        shadow = floor & (nd.uniform_filter(lum, 5) < c['shadow_luminance_max'])
        earth = floor & ~shadow & (r-g > 12) & (g-b > 15)
        grass = floor & ~(shadow | earth)
        border = nd.binary_dilation(floor, iterations=24) & ~(floor | depth)
        exterior = ~(floor | depth | border)
        # En automne le feuillage et le bois sont tous deux bruns : la couleur ne les sépare pas.
        tr = Image.new('1', (a.shape[1], a.shape[0]))
        draw = ImageDraw.Draw(tr)
        for points in c['trunk_polygons_raw']:
            draw.polygon([tuple(point) for point in points], fill=1)
        trunks = exterior & np.array(tr, bool)
        return {'herbe': grass, 'chemin': earth, 'ombres': shadow, 'sous_bois': border,
                'troncs': trunks, 'feuillage': exterior & ~trunks, 'profondeur': depth}

    def effect_colors(self, ref):
        colors = np.unique(ref.reshape(-1, 3), axis=0).astype(int)
        r, g, b = colors.T
        pool = colors[(r >= 120) & (r <= 200) & (g >= 80) & (g <= 170) & (r-g > 15) & (g-b > 30)]
        assert len(pool) >= 4
        pool = pool[np.argsort(pool @ [.299, .587, .114])]
        return pool[np.linspace(0, len(pool)-1, 4).astype(int)].tolist()

    def effect(self, t, emitters, walk, colors):
        out = np.zeros((H, W, 4), np.uint8)
        for x0, y0, phase in emitters:
            k = (t + phase) % PHASES
            if k >= 18:
                continue
            x = x0 + round(4*np.sin(2*np.pi*k/18))
            y = y0 + k - 9
            color = colors[min(k, 17-k, 3)]
            for dx, dy in ((0, 0), (1, 0), (1, 1)):
                if 0 <= x+dx < W and 0 <= y+dy < H and walk[y+dy, x+dx]:
                    out[y+dy, x+dx] = (*color, 255)
        return out

    def build(self):
        c, b, out, pfx = self.config, self.b, self.out, self.pfx
        for name in ('calques', 'animation', 'review', 'masques'):
            shutil.rmtree(out / name, ignore_errors=True); (out / name).mkdir(parents=True)
        decor = b.rgb(self.here / 'bruts' / c['decor_file']); sol = b.rgb(self.here / 'bruts/sol_complet.png')
        assert decor.shape == (896, 1200, 3)
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
        if c.get('depth_mode') == 'drawn':
            depth_layer = b.quantize({'profondeur': depth_layer})['profondeur']
        layers = {**b.quantize({k: a for k, a in layers.items() if k != 'profondeur'}),
                  **({'profondeur': depth_layer} if has_depth else {})}
        walk = masks['herbe'] | masks['chemin'] | masks['ombres']; blocked = b.collision_grid(walk)
        markers, explored = self.access(blocked, walk)
        emitters, colors = b.dust_setup(walk), self.effect_colors(ref)
        effects = [self.effect(t, emitters, walk, colors) for t in range(PHASES)]
        order = ['sol_complet', 'herbe', 'chemin', 'ombres', 'sous_bois', 'troncs', 'feuillage']
        if has_depth:
            order.append('profondeur')
        stack = [(name, [layers[name]], 60) for name in order] + [('feuilles', effects, TICKS)]
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
        scenes[0].save(out / 'review' / f'{pfx}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                       duration=[83, 83, 84] * 8, lossless=True, loop=0)
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
        files = [self.here / 'bruts' / c['decor_file'], self.here / 'bruts/sol_complet.png']
        manifest = {'lot': self.here.name, 'prefix': pfx, 'title': c['title'], 'kind': c['kind'],
                    'date': '2026-10-16', 'size_px': [W, H], 'grid_8px': [96, 72], 'format': '4:3 vaste',
                    'method': 'Rendu genere reference, reduction par classe puis formats natifs. Pas des pixels ROM.',
                    'art_approved': False, 'reference': {'file': str(self.ref.relative_to(ROOT)), 'sha256': sha(self.ref)},
                    'raw_inputs': [{'file': str(p.relative_to(ROOT)), 'sha256': sha(p),
                                    'size': image_size(p)} for p in files],
                    'config_sha256': sha(self.here / 'config.json'), 'generation': json.loads((self.here / 'generation.json').read_text()),
                    'normalization': normal, 'segmentation': {'floor_polygon_raw': c['floor_polygon_raw'],
                        'shadows': f'luminance lissee 5 px < {c["shadow_luminance_max"]} dans le sol existant',
                        'sous_bois': 'bande de 24 px autour du sol, bloquante', 'details': 'mousse/litiere, chemin, ombres, sous-bois, zones de troncs/racines mesurees et feuillage separes ; petites plantes au sol conservees',
                        'depth_mode': c.get('depth_mode', 'magenta' if has_depth else 'none'),
                        'depth_polygon_raw': c.get('depth_polygon_raw')},
                    'fidelity': fid, 'fidelity_max': 35, 'layers': info,
                    'depth_color': depth_color.tolist() if depth_color is not None else None,
                    'dust': {'label': 'feuilles calculees', 'emitters': emitters, 'colors': colors, 'phases': PHASES, 'ticks': TICKS,
                             'law': c['effect_law'], 'origin': 'calculee, couleurs bois/terre du rip ; ni animation ni feuillage automnal officiels'},
                    'scene_loop_ticks': PHASES * TICKS,
                    'access': {'markers': markers, 'reachable_16px': True, 'reachable_positions': explored,
                               'warp': False, 'destination_linked': False},
                    'origins': {'terrain': 'genere reference ' + c['reference_code'], 'effects': 'recalcules, couleurs du rip',
                                'native': 'formats et grille uniquement'},
                    'pmdo': {'version': '0.8.12', 'namespace': c['namespace'], 'asset': c['asset'],
                             'template': str(b.TEMPLATE.relative_to(ROOT)), 'template_sha256': sha(b.TEMPLATE),
                             'tile_counts': counts, 'runtime_tested': False, 'render_tested': False}}
        manifest['palette_policy'] = c['palette_policy']
        manifest['segmentation']['trunk_polygons_raw'] = c['trunk_polygons_raw']
        (out / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
        print(json.dumps({'prefix': pfx, 'fidelity': fid, 'markers': markers}, indent=2))
        return manifest


if __name__ == '__main__':
    Map(HERE).build()
