"""Suite de production après EDR1 : mêmes codecs, paramètres et sources propres à chaque map.
Les helpers d'EDR1 sont chargés dans une instance isolée : aucun changement du lot EDR1.
"""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import io
import json
import shutil
import uuid
import zipfile
import xml.etree.ElementTree as ET

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

ROOT = Path(__file__).resolve().parents[2]
W, H, PHASES, TICKS = 768, 576, 24, 5


def module(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec); spec.loader.exec_module(mod)
    return mod


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def image_size(path):
    with Image.open(path) as im:
        return list(im.size)


class Map:
    def __init__(self, here):
        self.here = Path(here).resolve()
        self.config = json.loads((self.here / 'config.json').read_text())
        c = self.config
        self.pfx = c['prefix']; self.out = ROOT / 'renders' / self.here.name
        self.stage = ROOT / '.cache' / self.here.name / c['namespace']
        self.ref = self.here / 'reference' / (c['reference_code'] + '.png')
        self.b = module(ROOT / 'source/entree_defile_roches_grises_v1/build.py', 'helpers_' + self.pfx)
        for k, v in {'HERE': self.here, 'OUT': self.out, 'STAGE': self.stage, 'PFX': self.pfx,
                     'NAMESPACE': c['namespace'], 'ASSET': c['asset']}.items():
            setattr(self.b, k, v)

    def materials(self, a):
        if self.config['material'] == 'grey':
            return self.b.materials(a)
        r, g, b = a[..., :3].astype(float).transpose(2, 0, 1)
        return {'sol': (r > 150) & (g > 130) & (b < 180) & (r - g > -15) & (r - g < 45) & (g - b > 25),
                'roche': (r > 35) & (r < 160) & (r - g > -10) & (r - g < 45) & (g - b > 7) & (g - b < 80)}

    def fidelity(self, a, ref):
        ma, mr = self.materials(a), self.materials(ref); out = {}
        for name in ma:
            assert ma[name].sum() > 100 and mr[name].sum() > 100, name
            ca, cr = a[..., :3][ma[name]].mean(0), ref[..., :3][mr[name]].mean(0)
            out[name] = {'distance': round(float(np.linalg.norm(ca - cr)), 2), 'rgb_lot': ca.round(2).tolist(),
                         'rgb_rip': cr.round(2).tolist(), 'pixels_lot': int(ma[name].sum()), 'pixels_rip': int(mr[name].sum())}
        return out

    def classify(self, a):
        c = self.config
        r, g, b = a.astype(float).transpose(2, 0, 1)
        mag = (r > 70) & (b > 70) & (r > g * 1.45) & (b > g * 1.45)
        depth = np.zeros(a.shape[:2], bool)
        if c['kind'] == 'entrance' and c.get('depth_mode') == 'drawn':
            assert not mag.any(), 'Magenta inattendu dans la profondeur dessinée'
            poly_depth = Image.new('1', (a.shape[1], a.shape[0]))
            ImageDraw.Draw(poly_depth).polygon([tuple(p) for p in c['depth_polygon_raw']], fill=1)
            depth = np.array(poly_depth, bool)
        elif c['kind'] == 'entrance':
            lab, n = nd.label(mag)
            assert n and mag.sum() > 1000, 'Clé magenta absente'
            counts = np.bincount(lab.ravel()); counts[0] = 0
            depth = nd.binary_dilation(lab == counts.argmax(), iterations=3)
            depth |= nd.binary_dilation(depth, iterations=15) & (r > g * 1.1) & (b > g * 1.1)
        else:
            assert not mag.any(), 'Magenta inattendu dans une fin sèche'
        poly = Image.new('1', (a.shape[1], a.shape[0]))
        ImageDraw.Draw(poly).polygon([tuple(p) for p in c['floor_polygon_raw']], fill=1)
        floor = np.array(poly, bool) & ~depth
        lum = a.astype(float) @ [.299, .587, .114]
        shadow = floor & (nd.uniform_filter(lum, 5) < c['shadow_luminance_max'])
        foot = nd.binary_dilation(floor, iterations=24) & ~floor & ~depth
        masks = {'sol': floor & ~shadow, 'ombres': shadow, 'talus': foot,
                 'parois': ~(floor | foot | depth)}
        if c['kind'] == 'entrance':
            masks['profondeur'] = depth
        return masks

    def access(self, blocked, walk):
        free = np.zeros_like(blocked)
        free[:-1, :-1] = ~(blocked[:-1, :-1] | blocked[1:, :-1] | blocked[:-1, 1:] | blocked[1:, 1:])
        lab, _ = nd.label(free, nd.generate_binary_structure(2, 1))
        ys, xs = np.nonzero(free); assert len(xs)
        i = min(range(len(xs)), key=lambda i: (-ys[i], abs(xs[i] - W // 16)))
        ey, ex = int(ys[i]), int(xs[i]); component = lab == lab[ey, ex]
        gy, gx = np.nonzero(component & (np.abs(np.indices(lab.shape)[1] - W // 16) < 10))
        i = min(range(len(gx)), key=lambda i: (gy[i], abs(gx[i] - W // 16)))
        north = [int(gx[i]) * 8, int(gy[i]) * 8]
        markers = {'entrance': [ex * 8, ey * 8]}
        if self.config['kind'] == 'end':
            wy, wx = np.nonzero(walk & (np.indices(walk.shape)[0] < H - 100))
            sy, sx = np.nonzero(component)
            i = int(np.argmin((sx * 8 - wx.mean()) ** 2 + (sy * 8 - wy.mean()) ** 2))
            markers['boss'] = [int(sx[i]) * 8, int(sy[i]) * 8]
            markers['objectif'] = north
        else:
            markers['donjon_seuil'] = north
        assert markers['entrance'][1] >= H - 24 and north[1] < H / 2
        return markers, int(component.sum())

    def effect_colors(self, ref):
        colors = np.unique(ref.reshape(-1, 3), axis=0).astype(int)
        if self.config['material'] == 'grey':
            ok = (np.ptp(colors, axis=1) < 8) & (colors.mean(1) >= 110) & (colors.mean(1) < 145)
        else:
            ok = (colors[:, 0] >= 150) & (colors[:, 1] >= 120) & (colors[:, 0] > colors[:, 2] + 35)
        pool = colors[ok]; assert len(pool) >= 4
        pool = pool[np.argsort(pool @ [.299, .587, .114])]
        return pool[np.linspace(0, len(pool) - 1, 4).astype(int)].tolist()

    def effect(self, t, emitters, walk, colors):
        if self.config['material'] == 'grey':
            return self.b.dust_frame(t, emitters, walk, colors)
        a = np.zeros((H, W, 4), np.uint8)
        for x0, y0, phase in emitters:
            k = (t + phase) % PHASES
            if k >= 18:
                continue
            x, y = x0 + round(2 * np.sin(2 * np.pi * k / 18)), y0 + k - 9
            color = colors[min(k, 17 - k, 3)]
            if walk[y, x]:
                a[y, x] = (*color, 255)
        return a

    def native(self, stack, blocked, markers):
        counts = self.b.native_project(stack, blocked, markers)
        c = self.config
        p = self.stage / f'Data/Ground/{c["asset"]}.rsground'
        doc = json.loads(p.read_text()); o = doc['Object']
        o['Name']['DefaultText'] = c['title'] + ' (4:3)'
        o['Comment'] = f'{self.pfx} : rendu genere reference {c["reference_code"]}. Effet calcule. Aucun warp. Runtime non teste.'
        o['Layers'][-1]['Name'] = f'{len(stack):02d} Vos elements avant-plan (Top)'
        p.write_text(json.dumps(doc, ensure_ascii=False))
        xml = ET.parse(self.stage / 'Mod.xml'); header = xml.getroot()
        header.find('Name').text = c['title'] + ' - ' + self.pfx
        header.find('Description').text = f'Base d edition generee reference {c["reference_code"]}. Aucun warp. Pas une aventure jouable.'
        xml.write(self.stage / 'Mod.xml', encoding='utf-8', xml_declaration=True)
        return counts

    def ora(self, stack):
        root = ET.Element('image', w=str(W), h=str(H), name=self.config['title'])
        group = ET.SubElement(root, 'stack')
        with zipfile.ZipFile(self.out / f'{self.pfx}_calques.ora', 'w') as z:
            z.writestr('mimetype', 'image/openraster')
            for i, (name, frames, _) in reversed(list(enumerate(stack))):
                path = f'data/{i:02d}_{name}.png'; stream = io.BytesIO()
                Image.fromarray(frames[0]).save(stream, format='PNG'); z.writestr(path, stream.getvalue())
                ET.SubElement(group, 'layer', name=name, src=path, opacity='1.0', visibility='visible',
                              **{'composite-op': 'svg:src-over', 'x': '0', 'y': '0'})
            z.writestr('stack.xml', ET.tostring(root, encoding='utf-8'))

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
        walk = masks['sol'] | masks['ombres']; blocked = b.collision_grid(walk)
        markers, explored = self.access(blocked, walk)
        emitters, colors = b.dust_setup(walk), self.effect_colors(ref)
        effects = [self.effect(t, emitters, walk, colors) for t in range(PHASES)]
        order = ['sol_complet', 'sol', 'ombres', 'talus', 'parois']
        if has_depth:
            order.append('profondeur')
        stack = [(name, [layers[name]], 60) for name in order] + [('poussiere', effects, TICKS)]
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
                        'talus': 'bande de 24 px autour du sol, bloquante', 'details': 'racines et aiguilles conservees avec les parois',
                        'depth_mode': c.get('depth_mode', 'magenta' if has_depth else 'none'),
                        'depth_polygon_raw': c.get('depth_polygon_raw')},
                    'fidelity': fid, 'fidelity_max': 35, 'layers': info,
                    'depth_color': depth_color.tolist() if depth_color is not None else None,
                    'dust': {'emitters': emitters, 'colors': colors, 'phases': PHASES, 'ticks': TICKS,
                             'law': c['effect_law'], 'origin': 'calculee, couleurs exactes du rip ; pas une animation officielle'},
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


def main():
    parser = argparse.ArgumentParser(description=__doc__); parser.add_argument('lot', type=Path)
    args = parser.parse_args(); Map(args.lot).build()


if __name__ == '__main__':
    main()
