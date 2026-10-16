"""TLG1 : nouveau lac gele généré référencé, formats PMDO, météo indépendante.
Les pixels de terrain sont générés, pas des pixels ROM. Aucun ancien helper modifié.
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
    def materials(self,a):
        r,g,b=a[...,:3].astype(float).transpose(2,0,1)
        return {'neige':(r>190)&(g>210)&(b>230),
                'roche':(r>30)&(r<150)&(g>60)&(g<160)&(b>100)&(b<220)&(g>r+10)&(b>g+10)}

    def classify(self,a):
        c=self.config;r,g,b=a.astype(float).transpose(2,0,1)
        assert not ((r>170)&(b>170)&(g<100)).any()
        def poly(name):
            im=Image.new('1',(a.shape[1],a.shape[0]));ImageDraw.Draw(im).polygon([tuple(p) for p in c[name]],fill=1)
            return np.array(im,bool)
        depth=poly('depth_polygon_raw')
        # Marge de recherche, puis teintes de glace : suivre la vraie rive, pas couper le lac au polygone.
        zone=nd.binary_dilation(poly('lake_polygon_raw'),iterations=24)
        lake=zone&(r>100)&(r<210)&(g>145)&(b>185)&(b>r+12)&(g>r+5)
        labels,n=nd.label(lake);counts=np.bincount(labels.ravel());counts[0]=0;assert n
        lake=nd.binary_fill_holes(labels==counts.argmax())
        assert lake.sum()>200000
        floor=(poly('floor_polygon_raw')&(nd.median_filter(r,5)>160)|lake)&~depth
        floor[:12]=False;floor[:,:12]=False;floor[:,-12:]=False
        lab,n=nd.label(floor);counts=np.bincount(lab.ravel());counts[0]=0;floor=lab==counts.argmax()
        lake&=floor
        shadow=floor&~lake&(nd.uniform_filter(a.astype(float)@[.299,.587,.114],5)<c['shadow_luminance_max'])
        shore=nd.binary_dilation(floor,iterations=12)&~(floor|depth)
        return {'neige':floor&~(lake|shadow),'ombres':shadow,'berges':shore,
                'reliefs':~(floor|shore|depth),'lac_gele':lake,'profondeur':depth}

    def access(self,blocked,walk):
        free=~(blocked[:-1,:-1]|blocked[1:,:-1]|blocked[:-1,1:]|blocked[1:,1:])
        lab,n=nd.label(free,nd.generate_binary_structure(2,1));ys,xs=np.nonzero(free);assert n
        i=min(range(len(xs)),key=lambda i:(-ys[i],abs(xs[i]-48)))
        ey,ex=int(ys[i]),int(xs[i]);component=lab==lab[ey,ex]
        yy,xx=np.indices(component.shape);gy,gx=np.nonzero(component&(abs(xx-self.config['north_target_x']//8)<10));assert len(gx)
        i=min(range(len(gx)),key=lambda i:(gy[i],abs(gx[i]-self.config['north_target_x']//8)))
        marks={'entrance':[ex*8,ey*8],'donjon_seuil':[int(gx[i])*8,int(gy[i])*8]}
        assert marks['entrance'][1]>=552 and marks['donjon_seuil'][1]<288
        return marks,int(component.sum())

    def effect_colors(self, ref):
        colors = np.unique(ref.reshape(-1, 3), axis=0).astype(int)
        r, g, b = colors.T
        pool = colors[(r > 180) & (g > 200) & (b > 220) & (b >= g) & (g >= r)]
        assert len(pool) >= 4
        pool = pool[np.argsort(pool @ [.299, .587, .114])]
        return pool[np.linspace(0, len(pool)-1, 4).astype(int)].tolist()

    def snow_setup(self):
        rng = np.random.default_rng(171026)
        return [[int(rng.integers(8, W-8)), int(rng.integers(18, H-40)), (i*7) % 24]
                for i in range(64)]

    def snow_frame(self, t, emitters, colors):
        out = np.zeros((H, W, 4), np.uint8)
        for x0, y0, phase in emitters:
            k = (t+phase) % 24
            if k >= 18:
                continue
            x = x0 + round(4*np.sin(2*np.pi*k/18))
            y = y0 + 2*k
            color = colors[min(k, 17-k, 3)]
            for dx, dy in ((0, 0), (0, -1)):
                if 0 <= x+dx < W and 0 <= y+dy < H:
                    out[y+dy, x+dx] = (*color, 255)
        return out

    def glint_setup(self, ice):
        y, x = np.nonzero(nd.binary_erosion(ice, iterations=3))
        assert len(x) > 1000
        return [[int(x[i]), int(y[i]), (n*5) % 24]
                for n, i in enumerate(np.linspace(0, len(x)-1, 28).astype(int))]

    def glint_frame(self, t, emitters, ice, colors):
        out = np.zeros((H, W, 4), np.uint8)
        for x, y, phase in emitters:
            k = (t+phase) % 24
            if k >= 8:
                continue
            level = min(k, 7-k, 3)
            offsets = ((0, 0), (-1, 0), (1, 0), (0, -1), (0, 1)) if level == 3 else ((0, 0),)
            for dx, dy in offsets:
                if 0 <= x+dx < W and 0 <= y+dy < H and ice[y+dy, x+dx]:
                    out[y+dy, x+dx] = (*colors[level], 255)
        return out

    def build(self):
        c, b, out, pfx = self.config, self.b, self.out, self.pfx
        for name in ('calques', 'animation', 'review', 'masques'):
            shutil.rmtree(out / name, ignore_errors=True)
            (out / name).mkdir(parents=True)
        decor = b.rgb(self.here / 'bruts' / c['decor_file'])
        sol = b.rgb(self.here / 'bruts/sol_complet.png')
        assert decor.shape == (896, 1200, 3)
        layers, masks, plane, normal = b.reduce_classes(decor, self.classify(decor))
        scale = H / sol.shape[0]; width = round(sol.shape[1]*scale); crop = (width-W)//2
        assert width >= W
        floor_rgb = np.stack([np.array(Image.fromarray(sol[..., i].astype('float32')).resize(
            (width, H), Image.Resampling.BOX))[:, crop:crop+W] for i in range(3)], -1)
        layers['sol_complet'] = b.rgba(np.uint8(np.clip(np.rint(floor_rgb), 0, 255)), np.ones((H, W), bool))
        normal['floor_support'] = {'source_size': image_size(self.here/'bruts/sol_complet.png'),
            'scale_xy': scale, 'scaled_width': width, 'crop_left': crop,
            'note': 'Nouveau support de neige non aligne sous partition complete, pas une seconde composition.'}
        depth = b.quantize({'profondeur': layers['profondeur']})['profondeur']
        layers = b.quantize({k: v for k, v in layers.items() if k != 'profondeur'})
        layers['profondeur'] = depth
        ref = b.rgb(self.ref)
        walk = masks['neige'] | masks['ombres'] | masks['lac_gele']
        blocked = b.collision_grid(walk)
        markers, explored = self.access(blocked, walk)
        colors = self.effect_colors(ref)
        snow_emitters = self.snow_setup(); glint_emitters = self.glint_setup(masks['lac_gele'])
        order = ['sol_complet', 'neige', 'ombres', 'berges', 'reliefs', 'lac_gele', 'profondeur']
        stack = [(name, [layers[name]], 60) for name in order]
        stack += [('scintillements', [self.glint_frame(t, glint_emitters, masks['lac_gele'], colors) for t in range(24)], 5),
                  ('flocons', [self.snow_frame(t, snow_emitters, colors) for t in range(24)], 5)]
        info = []
        for i, (name, frames, ticks) in enumerate(stack):
            path = f'calques/{pfx}_{i:02d}_{name}.png' if len(frames) == 1 else f'animation/{pfx}_{i:02d}_{name}_fNN.png'
            for t, a in enumerate(frames):
                Image.fromarray(a).save(out/path.replace('NN', f'{t:02d}'))
            info.append({'name': name, 'file': path, 'phases': len(frames), 'ticks': ticks})
        for name, mask in {**masks, 'praticable': walk, 'collisions': blocked}.items():
            Image.fromarray(np.uint8(mask)*255).save(out/'masques'/f'{pfx}_{name}.png')
        scenes = []
        for t in range(24):
            im = Image.new('RGBA', (W, H))
            for _, frames, _ in stack:
                im.alpha_composite(Image.fromarray(frames[t % len(frames)]))
            scenes.append(im)
        scenes[0].save(out/'review'/f'{pfx}_scene_t000.png')
        scenes[0].save(out/'review'/f'{pfx}_scene_animee.webp', save_all=True, append_images=scenes[1:],
                       duration=[83, 83, 84]*8, lossless=True, loop=0)
        overlay = Image.new('RGBA', (W, H)); dr = ImageDraw.Draw(overlay)
        for y, x in zip(*np.nonzero(blocked)):
            dr.rectangle((x*8, y*8, x*8+7, y*8+7), fill=(230, 30, 30, 85))
        for name, p in markers.items():
            dr.rectangle((*p, p[0]+15, p[1]+15), outline=(255, 230, 40, 255) if name == 'entrance' else (40, 240, 255, 255), width=2)
        review = scenes[0].copy(); review.alpha_composite(overlay)
        review.save(out/'review'/f'{pfx}_collisions_marqueurs.png')
        fid = {'brut': self.fidelity(decor, ref), 'sortie': self.fidelity(np.array(scenes[0]), ref)}
        assert all(v['distance'] < 35 for stage in fid.values() for v in stage.values()), fid
        counts = self.native(stack, blocked, markers); self.ora(stack)
        files = [self.here/'bruts'/c['decor_file'], self.here/'bruts/sol_complet.png']
        manifest = {'lot': self.here.name, 'prefix': pfx, 'title': c['title'], 'kind': c['kind'], 'date': '2026-10-17',
            'size_px': [W, H], 'grid_8px': [96, 72], 'format': '4:3 vaste',
            'method': 'Nouveau rendu genere avec rip fourni, segmentation puis reduction et formats natifs. Pas des pixels ROM.',
            'art_approved': False,
            'reference': {'file': str(self.ref.relative_to(ROOT)), 'sha256': sha(self.ref)},
            'extra_references': [{'file': str(p.relative_to(ROOT)), 'sha256':sha(p)} for p in [self.here/'reference/D52P11C.png',self.here/'reference/D52P11C_sol_crop.png']],
            'raw_inputs': [{'file': str(p.relative_to(ROOT)), 'sha256': sha(p), 'size': image_size(p)} for p in files],
            'palette_policy': c['palette_policy'], 'config_sha256': sha(self.here/'config.json'),
            'generation': json.loads((self.here/'generation.json').read_text()), 'normalization': normal,
            'segmentation': {'floor_polygon_raw': c['floor_polygon_raw'], 'depth_polygon_raw': c['depth_polygon_raw'],
                'walk': 'lac gele SOLIDE et neige, enveloppes propres au decor, mediane R5px>160 hors lac ; pas pont/chemin repeint',
                'shadows': 'luminance moyenne5px sous seuil config, pixels existants',
                'berges': 'bande12px bruts, bloquante', 'lac_gele': 'enveloppe relevee, composante bleue, trous combles ; glace pleine traversable, pas eau liquide',
                'depth_mode': 'drawn', 'limits': 'zones fonctionnelles, pas detourage parfait des objets ; les reliefs gardent aussi leurs caps de neige'},
            'fidelity': fid, 'fidelity_max': 35, 'layers': info, 'depth_color': None,
            'snow': {'emitters': snow_emitters, 'colors': colors, 'phases': 24, 'ticks': 5, 'law': c['snow_law'],
                     'origin': 'particules calculees deux pixels, couleurs exactes du rip ; pas sprites/BPA officiels'},
            'glints': {'emitters': glint_emitters, 'colors': colors, 'phases': 24, 'ticks': 5, 'law': c['glint_law'],
                       'origin': 'reflets ponctuels calcules, clips sur le lac gele statique ; pas animation officielle'},
            'scene_loop_ticks': 120,
            'access': {'markers': markers, 'reachable_16px': True, 'reachable_positions': explored, 'warp': False, 'destination_linked': False},
            'origins': {'terrain': 'genere references D53P11B et crop sol D52P11C, lac invente', 'effects': 'calcules aux couleurs du rip, pas images du jeu animees', 'native': 'formats et grille uniquement'},
            'pmdo': {'version': '0.8.12', 'namespace': c['namespace'], 'asset': c['asset'],
                     'template': str(b.TEMPLATE.relative_to(ROOT)), 'template_sha256': sha(b.TEMPLATE),
                     'tile_counts': counts, 'runtime_tested': False, 'render_tested': False}}
        (out/'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2)+'\n')
        print(json.dumps({'prefix': pfx, 'fidelity': fid, 'markers': markers}, indent=2))
        return manifest


if __name__ == '__main__':
    Map(HERE).build()
