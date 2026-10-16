"""SVJ2 : decoupe du nouveau sprite, matiere ascendante, gerbes et gouttes separees.
Preparation de bande/palette reutilisee SANS modifier AGM3. Aucun ancien sprite reutilise.
"""
from pathlib import Path
import numpy as np
from scipy import ndimage as nd
from source.maps_suite_v1.pipeline import module, ROOT, W, H

HERE = Path(__file__).resolve().parent
PREP = ROOT / 'source/arene_groudon_magma_v3/colonnes_generees.py'


class Columns:
    def __init__(self):
        self.lib = module(PREP, 'svj2_column_preparation')
        self.lib.RAW = HERE / 'shared/colonne_magenta.png'
        self.lib.BODY_END = 940
        self.lib.CROWN_TOP = 950
        self.lib.MOUTH_ROW = 1200
        self.lib.CROWN_X = (0, 784)
        self.lib.PHASES = 24
        self.lib._CACHE = {}
        self.palette = self.lib.palette()[0]

    def choose(self, lava, walk):
        distance = nd.distance_transform_edt(lava)
        result = []
        for target, scale, side in [((110,180),.16,'left'),((660,170),.16,'right'),
                                    ((65,450),.23,'left'),((715,440),.23,'right')]:
            pr = self.lib.prepare(scale, side == 'right')
            xs = np.nonzero((pr['strip'] >= 0).any(0))[0]
            lo, hi = int(np.floor(xs.min()-pr['body_cx']))-2, int(np.ceil(xs.max()-pr['body_cx']))+2
            candidates = []
            for x in range(36, 165) if side == 'left' else range(603, 734):
                if x+lo < 0 or x+hi >= W:
                    continue
                prefix = np.maximum.accumulate(walk[:, x+lo:x+hi+1].any(1))
                for y in np.flatnonzero((distance[:,x] > 14) & ~prefix):
                    if not 110 <= y <= 490:
                        continue
                    overlap = sum(max(0, 65-abs(x-c['x']))**2 for c in result)
                    score = 3*(x-target[0])**2 + (int(y)-target[1])**2 + 3*overlap
                    candidates.append((score, x, int(y)))
            assert candidates, 'Pas de bouche de jet sure : '+side
            _, x, y = min(candidates)
            result.append({'x':x, 'y':y, 'echelle':scale, 'miroir':side=='right',
                           'decalage':len(result)*5, 'graine':len(result)+21,
                           'period_px':int(pr['P'])})
        return sorted(result, key=lambda c:c['y'])

    def frames(self, cols, lava, walk):
        tracks = {name: [] for name in ('colonnes','jaillissements','projections')}
        yy_full, xx_full = np.indices((H,W))
        for t in range(24):
            planes = {name: np.zeros((H,W,4),np.uint8) for name in tracks}
            def put(name, idx, ox, oy, allowed):
                yy,xx = np.nonzero(idx >= 0); Y=yy+oy; X=xx+ox
                inside=(Y>=0)&(Y<H)&(X>=0)&(X<W)
                yy,xx,Y,X = yy[inside],xx[inside],Y[inside],X[inside]
                keep=allowed[Y,X]; yy,xx,Y,X=yy[keep],xx[keep],Y[keep],X[keep]
                planes[name][Y,X,:3]=self.palette[idx[yy,xx]];planes[name][Y,X,3]=255
            for c in cols:
                pr=self.lib.prepare(c['echelle'],c['miroir']);u=((t-c['decalage'])%24)/24
                # d/du = P*(1-.6*cos(4*pi*u)) > 0 : montee strictement croissante.
                shift=self.lib.shift_of(u,pr['P'])+c['graine']*37
                idx=pr['strip'][(np.arange(c['y']+1)+shift)%pr['P']]
                put('colonnes',idx,round(c['x']-pr['body_cx']),0,~walk)
                # Gerbe generee translatee de quelques pixels, aucune rotation de palette.
                pulse=round(2*np.sin(4*np.pi*u))
                put('jaillissements',pr['crown'],round(c['x']-pr['crown_cx']),
                    round(c['y']-pr['mouth_r'])+pulse,lava)
                rng=np.random.default_rng(c['graine']*31+5)
                for d in pr['drops']:
                    phase=rng.random();height=25+40*rng.random()
                    f=(2*u+phase)%1;side=1 if d['dx']>=0 else -1
                    x=c['x']+side*(abs(d['dx'])+15)*f
                    y=c['y']-4*height*f*(1-f)
                    h,w=d['idx'].shape
                    put('projections',d['idx'],round(x-w/2),round(y-h/2),~walk)
            for name in tracks:
                tracks[name].append(planes[name])
        return tracks
