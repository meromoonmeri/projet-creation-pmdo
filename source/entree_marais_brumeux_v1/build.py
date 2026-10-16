"""EMB1 : marais généré référencé, neuf calques fonctionnels, formats PMDO natifs.
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
        r,g,b=a[...,:3].astype(float).transpose(2,0,1)
        return {'vase':(r>45)&(r<155)&(r>g+5)&(b>g+3)&(abs(r-b)<35),
                'feuillage':(b>r+12)&(g>r+8)&(b>g+3)&(g>35)}

    def classify(self, a):
        c=self.config;r,g,b=a.astype(float).transpose(2,0,1)
        # La vase violette n'est pas la clef magenta saturee du sprite.
        assert not ((r>170)&(b>170)&(g<100)).any()
        def poly(points):
            im=Image.new('1',(a.shape[1],a.shape[0]));ImageDraw.Draw(im).polygon([tuple(p) for p in points],fill=1)
            return np.array(im,bool)
        zones=np.logical_or.reduce([poly(p) for p in c['water_zones_raw']])
        candidates=zones&(g>r+18)&(b>r+24)&(g>=b*.8)&(r<75)&(g<115)
        lab,_=nd.label(candidates);labels={int(lab[y,x]) for x,y in c['water_seeds_raw']};assert 0 not in labels
        water=np.isin(lab,list(labels))
        # Petits reflets inclus, vrais ilots preservés (pas de fill_holes global).
        holes=nd.binary_fill_holes(water)&~water;hl,n=nd.label(holes);counts=np.bincount(hl.ravel());small=counts<1000;small[0]=False
        water|=small[hl]
        assert water.sum()>150000
        depth=poly(c['depth_polygon_raw'])&~water
        floor=poly(c['floor_polygon_raw'])&~(water|depth)
        shadow=floor&(nd.uniform_filter(a.astype(float)@[.299,.587,.114],5)<c['shadow_luminance_max'])
        shore=nd.binary_dilation(floor,iterations=12)&~(floor|water|depth)
        exterior=~(floor|shore|water|depth)
        roots=exterior&(r>g*1.05)
        return {'vase':floor&~shadow,'ombres':shadow,'berges':shore,'racines':roots,
                'feuillage':exterior&~roots,'profondeur':depth,'eau':water}

    def water_frame(self,t,base):
        from source.entree_terres_volcaniques_v1.build import Map as VolcanMap
        return VolcanMap.lava_frame(self,t,base)

    def prepare_fog(self):
        a=self.b.rgb(self.here/'bruts/brume_magenta.png').astype(float);r,g,b=a.transpose(2,0,1)
        mask=~((r>g*1.2)&(b>g*1.2));ys,xs=np.nonzero(mask)
        box=[int(xs.min()),int(ys.min()),int(xs.max()+1),int(ys.max()+1)]
        x0,y0,x1,y1=box;a=a[y0:y1,x0:x1];mask=mask[y0:y1,x0:x1]
        base=np.zeros((H,W,4),np.uint8)
        palette=Image.fromarray(np.uint8(a[mask]).reshape(-1,1,3)).quantize(32,method=Image.Quantize.MEDIANCUT,dither=Image.Dither.NONE)
        for cx,cy,width,mirror in self.config['fog_placements']:
            height=round(width*a.shape[0]/a.shape[1]);size=(width,height)
            weight=np.array(Image.fromarray(mask.astype('float32')).resize(size,Image.Resampling.BOX))
            rgb=np.stack([np.array(Image.fromarray((a[...,i]*mask).astype('float32')).resize(size,Image.Resampling.BOX))/np.maximum(weight,1e-6) for i in range(3)],-1)
            visible=weight>.45;rgb=np.uint8(np.clip(np.rint(rgb),0,255))
            rgb=np.array(Image.fromarray(rgb).quantize(palette=palette,dither=Image.Dither.NONE).convert('RGB'))
            patch=np.zeros((height,width,4),np.uint8)
            patch[visible,:3]=rgb[visible];patch[visible,3]=255
            if mirror:patch=patch[:,::-1].copy()
            yy,xx=np.indices(visible.shape);patch[(xx+2*yy)%4!=0]=0
            oy=cy-height//2;ox=cx-width//2
            assert ox>=0 and oy>=0 and ox+width<=W and oy+height<=H
            dest=base[oy:oy+height,ox:ox+width];use=patch[...,3]>0;dest[use]=patch[use]
        colors=np.unique(base[base[...,3]>0,:3],axis=0).tolist()
        return base,{'source':'bruts/brume_magenta.png','sha256':sha(self.here/'bruts/brume_magenta.png'),'crop_raw':box,'placements':self.config['fog_placements'],'colors':colors,'phases':24,'ticks':5,'law':self.config['effect_law'],'origin':'texture nouvellement generee, mouvement calcule et trame alpha binaire ; ni sprite ROM ni transparence moteur'}

    def fog_frame(self,t,base,water):
        theta=2*np.pi*(t%24)/24;dx=round(6*np.sin(theta));dy=round(2*(np.cos(theta)-1))
        out=np.zeros_like(base);ys,xs=np.nonzero(base[...,3]);Y=ys+dy;X=xs+dx
        inside=(Y>=0)&(Y<H)&(X>=0)&(X<W);ys,xs,Y,X=ys[inside],xs[inside],Y[inside],X[inside]
        use=water[Y,X];out[Y[use],X[use]]=base[ys[use],xs[use]]
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
        walk = masks['vase'] | masks['ombres']; blocked = b.collision_grid(walk)
        markers, explored = self.access(blocked, walk)
        fog_base, fog_metadata = self.prepare_fog()
        effects = [self.fog_frame(t, fog_base, masks['eau']) for t in range(PHASES)]
        order = ['sol_complet', 'vase', 'ombres', 'berges', 'racines', 'feuillage']
        if has_depth:
            order.append('profondeur')
        water_frames = [self.water_frame(t, layers['eau']) for t in range(PHASES)]
        stack = [(name, [layers[name]], 60) for name in order] + [('eau', water_frames, TICKS), ('brume', effects, TICKS)]
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
        files = [self.here / 'bruts' / c['decor_file'], self.here / 'bruts/sol_complet.png', self.here / 'bruts/brume_magenta.png']
        manifest = {'lot': self.here.name, 'prefix': pfx, 'title': c['title'], 'kind': c['kind'],
                    'date': '2026-10-16', 'size_px': [W, H], 'grid_8px': [96, 72], 'format': '4:3 vaste',
                    'method': 'Rendu genere reference, reduction par classe puis formats natifs. Pas des pixels ROM. Eau et brume inventees depuis une reference forestiere.',
                    'art_approved': False, 'reference': {'file': str(self.ref.relative_to(ROOT)), 'sha256': sha(self.ref)},
                    'raw_inputs': [{'file': str(p.relative_to(ROOT)), 'sha256': sha(p),
                                    'size': image_size(p)} for p in files],
                    'palette_policy': c['palette_policy'], 'config_sha256': sha(self.here / 'config.json'), 'generation': json.loads((self.here / 'generation.json').read_text()),
                    'normalization': normal, 'segmentation': {'floor_polygon_raw': c['floor_polygon_raw'],
                        'shadows': f'luminance lissee 5 px < {c["shadow_luminance_max"]} dans le sol existant',
                        'berges': 'bande de 12 px bruts autour du sol, bloquante', 'details': 'vase, ombres, berges, racines, feuillage, profondeur, eau ; zones d edition pas detourage parfait', 'water_mask_raw': 'zones explicites, composantes aux deux graines dans teintes teal, petits trous <1000px inclus, ilot preserve',
                        'depth_mode': c.get('depth_mode', 'magenta' if has_depth else 'none'),
                        'depth_polygon_raw': c.get('depth_polygon_raw')},
                    'fidelity': fid, 'fidelity_max': 35, 'layers': info,
                    'depth_color': depth_color.tolist() if depth_color is not None else None,
                    'fog': fog_metadata,
                    'water_animation': {'law': c['water_law'], 'origin': 'ondulation des pixels EAU du nouveau decor par helper ETV1 inchange ; ni recoloration ni BPL officiel', 'border_fixed_px': 3, 'phases': PHASES, 'ticks': TICKS},
                    'scene_loop_ticks': PHASES * TICKS,
                    'access': {'markers': markers, 'reachable_16px': True, 'reachable_positions': explored,
                               'warp': False, 'destination_linked': False},
                    'origins': {'terrain': 'genere reference ' + c['reference_code'], 'effects': 'brume generee transformee, eau generee deplacee',
                                'native': 'formats et grille uniquement'},
                    'pmdo': {'version': '0.8.12', 'namespace': c['namespace'], 'asset': c['asset'],
                             'template': str(b.TEMPLATE.relative_to(ROOT)), 'template_sha256': sha(b.TEMPLATE),
                             'tile_counts': counts, 'runtime_tested': False, 'render_tested': False}}
        (out / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
        print(json.dumps({'prefix': pfx, 'fidelity': fid, 'markers': markers}, indent=2))
        return manifest


if __name__ == '__main__':
    Map(HERE).build()
