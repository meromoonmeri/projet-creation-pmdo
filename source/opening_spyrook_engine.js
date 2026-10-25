/* Opening « PMD : Destiny » — traitement « DA Spyrook » (illustration numérique douce) appliqué à tout l'opening ULTIME (153 s).
   Références visuelles étudiées : les illustrations de Spyrook (Pokémon / Mystery Dungeon) — formes rondes et lisses, aplats doux, contours fins brun-violet,
   ombres violettes, lumière chaude qui déborde (bloom), couleurs vives et saturées, aucune trame pixel.
   Technique : chaque image du montage est rendue, puis (1) les pixels sont arrondis par un filtre de Kuwahara (peinture numérique), (2) étalonnage chaud/froid saturé,
   (3) halo lumineux, (4) contour fin sur les silhouettes, (5) grain très léger. Les mouvements restent ceux des animations image par image : la fluidité vient du rendu 60 i/s
   (une image dessinée par image vidéo). Fonction pure du temps : render(ctx, t, opts). Aucune dépendance DOM (le tampon vient de EV.mk). */
(function (root) {
  'use strict';
  const W = 1280, H = 720, D = 153.0, SW = 960, SH = 540, N = SW * SH, R = 5;
  const clamp = (x, a, b) => Math.min(b, Math.max(a, x));
  const sstep = (x) => { x = clamp(x, 0, 1); return x * x * (3 - 2 * x); };
  const hash = (x, y, s) => { const v = Math.sin(x * 127.1 + y * 311.7 + s * 74.7) * 43758.5453; return v - Math.floor(v); };

  function create(EV) {
    const U = root.PMDDestinyUltime.create(Object.assign({}, EV, { inbetween: true })), mk = EV.mk;
    const src = mk(W, H), sx = src.getContext('2d');
    const small = mk(SW, SH), smx = small.getContext('2d', { willReadFrequently: true });
    const out = mk(SW, SH), ox = out.getContext('2d'), outId = ox.createImageData(SW, SH), od = outId.data;
    const bl = mk(SW >> 2, SH >> 2), blx = bl.getContext('2d', { willReadFrequently: true });
    const frame = mk(W, H), fx = frame.getContext('2d');
    const gnoise = new Int8Array(N); for (let i = 0; i < N; i++) gnoise[i] = Math.round((hash(i % SW, (i / SW) | 0, 5) - 0.5) * 7);

    // images intégrales (R, G, B, L, L²) pour le filtre de Kuwahara en O(1) par quadrant
    const IW = SW + 1, IR = new Float64Array(IW * (SH + 1)), IG = new Float64Array(IR.length), IB = new Float64Array(IR.length), IL = new Float64Array(IR.length), IL2 = new Float64Array(IR.length);
    const Lb = new Int16Array(N), A1 = new Int16Array(N), A2 = new Int16Array(N), Gm = new Uint8Array(N);
    const tmp = new Uint8ClampedArray(N * 4);
    const KR = new Uint8ClampedArray(N), KG = new Uint8ClampedArray(N), KB = new Uint8ClampedArray(N);

    function kuwahara(d) {
      for (let y = 0; y < SH; y++) {
        let sr = 0, sg = 0, sb = 0, sl = 0, sl2 = 0;
        for (let x = 0; x < SW; x++) {
          const j = (y * SW + x) * 4, r = d[j], g = d[j + 1], b = d[j + 2], l = (r * 77 + g * 150 + b * 29) >> 8;
          sr += r; sg += g; sb += b; sl += l; sl2 += l * l;
          const a = (y + 1) * IW + x + 1, u = y * IW + x + 1;
          IR[a] = IR[u] + sr; IG[a] = IG[u] + sg; IB[a] = IB[u] + sb; IL[a] = IL[u] + sl; IL2[a] = IL2[u] + sl2;
        }
      }
      const box = (I, x0, y0, x1, y1) => I[(y1 + 1) * IW + x1 + 1] - I[y0 * IW + x1 + 1] - I[(y1 + 1) * IW + x0] + I[y0 * IW + x0];
      const q = [[-R, -R, 0, 0], [0, -R, R, 0], [-R, 0, 0, R], [0, 0, R, R]];
      for (let y = 0; y < SH; y++) for (let x = 0; x < SW; x++) {
        let best = 1e18, br = 0, bg = 0, bb = 0;
        for (let k = 0; k < 4; k++) {
          const x0 = Math.max(0, x + q[k][0]), y0 = Math.max(0, y + q[k][1]), x1 = Math.min(SW - 1, x + q[k][2]), y1 = Math.min(SH - 1, y + q[k][3]);
          const n = (x1 - x0 + 1) * (y1 - y0 + 1), sl = box(IL, x0, y0, x1, y1), v = box(IL2, x0, y0, x1, y1) / n - (sl / n) * (sl / n);
          if (v < best) { best = v; br = box(IR, x0, y0, x1, y1) / n; bg = box(IG, x0, y0, x1, y1) / n; bb = box(IB, x0, y0, x1, y1) / n; }
        }
        const i = y * SW + x; KR[i] = br; KG[i] = bg; KB[i] = bb;
      }
    }

    // Arrondi des pixels : on floute (gaussienne ≈ 3 px), puis chaque pixel prend, parmi les couleurs voisines d'origine (centre + 8 voisins à ±4 px),
    // celle qui est la plus proche du flou. Les aplats restent purs, mais les frontières suivent les courbes lissées → silhouettes rondes, sans escalier.
    const BA = new Float32Array(N), BB = new Float32Array(N), BR_ = new Float32Array(N), BG_ = new Float32Array(N), BB_ = new Float32Array(N), TT = new Float32Array(N);
    function boxPass(a, r) {
      const n = 2 * r + 1;
      for (let y = 0; y < SH; y++) { const o = y * SW; let s = 0; for (let x = -r; x <= r; x++) s += a[o + clamp(x, 0, SW - 1)];
        for (let x = 0; x < SW; x++) { TT[o + x] = s / n; s += a[o + Math.min(SW - 1, x + r + 1)] - a[o + Math.max(0, x - r)]; } }
      for (let x = 0; x < SW; x++) { let s = 0; for (let y = -r; y <= r; y++) s += TT[clamp(y, 0, SH - 1) * SW + x];
        for (let y = 0; y < SH; y++) { a[y * SW + x] = s / n; s += TT[Math.min(SH - 1, y + r + 1) * SW + x] - TT[Math.max(0, y - r) * SW + x]; } }
    }
    const offs = (m) => [[0, 0], [-m, 0], [m, 0], [0, -m], [0, m], [-m, -m], [m, -m], [-m, m], [m, m]];
    function smoothSnap(d, rad, m) {
      const OFF = offs(m);
      for (let i = 0, j = 0; i < N; i++, j += 4) { BR_[i] = d[j]; BG_[i] = d[j + 1]; BB_[i] = d[j + 2]; }
      for (let k = 0; k < 3; k++) { boxPass(BR_, rad); boxPass(BG_, rad); boxPass(BB_, rad); }
      for (let y = 0; y < SH; y++) for (let x = 0; x < SW; x++) {
        const i = y * SW + x, br = BR_[i], bg = BG_[i], bb = BB_[i]; let best = 1e9, bj = 0;
        for (let k = 0; k < 9; k++) {
          const xx = clamp(x + OFF[k][0], 0, SW - 1), yy = clamp(y + OFF[k][1], 0, SH - 1), j = (yy * SW + xx) * 4;
          const dr = d[j] - br, dg = d[j + 1] - bg, db = d[j + 2] - bb, e = dr * dr + dg * dg + db * db;
          if (e < best) { best = e; bj = j; }
        }
        KR[i] = d[bj]; KG[i] = d[bj + 1]; KB[i] = d[bj + 2];
      }
    }
    function sobel(a, k, first) {
      for (let y = 1; y < SH - 1; y++) {
        const o = y * SW;
        for (let x = 1; x < SW - 1; x++) {
          const i = o + x;
          const gx = a[i - SW + 1] + 2 * a[i + 1] + a[i + SW + 1] - a[i - SW - 1] - 2 * a[i - 1] - a[i + SW - 1];
          const gy = a[i + SW - 1] + 2 * a[i + SW] + a[i + SW + 1] - a[i - SW - 1] - 2 * a[i - SW] - a[i - SW + 1];
          let g = (Math.abs(gx) + Math.abs(gy)) * k * 0.25; if (g > 255) g = 255;
          if (first || g > Gm[i]) Gm[i] = g;
        }
      }
    }

    function paint(kt, draw, res) { // kt = 0 → traitement complet ; 1 → allégé (écran-titre)
      sx.setTransform(1, 0, 0, 1, 0, 0);
      const r = draw(sx); res.wing = r.wing; res.shot = r.shot;
      smx.imageSmoothingEnabled = true; smx.drawImage(src, 0, 0, SW, SH);
      const d = smx.getImageData(0, 0, SW, SH).data;
      smoothSnap(d, 2, 4); // une seule passe : silhouettes rondes sans perdre les yeux / détails des personnages
      for (let i = 0; i < N; i++) { Lb[i] = (KR[i] * 77 + KG[i] * 150 + KB[i] * 29) >> 8; A1[i] = KR[i] - KB[i]; A2[i] = KG[i] - ((KR[i] + KB[i]) >> 1); }
      sobel(Lb, 1.0, true); sobel(A1, 0.6, false); sobel(A2, 0.7, false);
      // halo : zones claires floutées (échelle 1/4) rajoutées en lumière
      blx.imageSmoothingEnabled = true; blx.clearRect(0, 0, SW >> 2, SH >> 2); blx.drawImage(small, 0, 0, SW >> 2, SH >> 2);
      const bdat = blx.getImageData(0, 0, SW >> 2, SH >> 2).data, BW = SW >> 2, BH = SH >> 2, bloom = new Uint8ClampedArray(BW * BH * 3);
      for (let i = 0; i < BW * BH; i++) { const l = (bdat[i * 4] * 77 + bdat[i * 4 + 1] * 150 + bdat[i * 4 + 2] * 29) >> 8, k = Math.max(0, l - 150) / 105; bloom[i * 3] = bdat[i * 4] * k; bloom[i * 3 + 1] = bdat[i * 4 + 1] * k * 0.95; bloom[i * 3 + 2] = bdat[i * 4 + 2] * k * 0.8; }
      const TH = 40 + 30 * kt, SOFT = 50, sat = 1.1 - 0.08 * kt, kb = 0.5 * (1 - 0.4 * kt);
      for (let y = 0; y < SH; y++) {
        const by = Math.min(BH - 1, y >> 2);
        for (let x = 0; x < SW; x++) {
          const i = y * SW + x, o = i * 4;
          let r = KR[i], g = KG[i], b = KB[i];
          // étalonnage : saturation, contraste doux, ombres violettes / lumières chaudes
          const l = Lb[i], lu = l;
          r = lu + (r - lu) * sat; g = lu + (g - lu) * sat; b = lu + (b - lu) * sat;
          const sh = clamp((120 - l) / 120, 0, 1), hi = clamp((l - 150) / 105, 0, 1);
          r += 16 * sh * (1 - kt) - 6 * sh + 12 * hi; g += -6 * sh + 6 * hi; b += 26 * sh * (1 - kt) - 10 * hi;
          r = (r - 128) * 1.07 + 130; g = (g - 128) * 1.07 + 130; b = (b - 128) * 1.07 + 132;
          // halo
          const bx = Math.min(BW - 1, x >> 2), bi = (by * BW + bx) * 3;
          r += bloom[bi] * kb; g += bloom[bi + 1] * kb; b += bloom[bi + 2] * kb;
          // contour fin brun-violet (sur les silhouettes seulement)
          const a = clamp((Gm[i] - TH) / SOFT, 0, 1) * 0.88 * (1 - 0.5 * kt);
          if (a > 0.004) { r = r * (1 - a) + (KR[i] * 0.22 + 34) * a; g = g * (1 - a) + (KG[i] * 0.18 + 18) * a; b = b * (1 - a) + (KB[i] * 0.25 + 44) * a; }
          const gn = gnoise[i];
          od[o] = clamp(r + gn, 0, 255); od[o + 1] = clamp(g + gn, 0, 255); od[o + 2] = clamp(b + gn, 0, 255); od[o + 3] = 255;
        }
      }
      ox.putImageData(outId, 0, 0);
    }

    let cache = { idx: -1, wing: 0, shot: '', theme: null };
    function render(ctx, t, opts) {
      opts = opts || {}; t = clamp(t, 0, D);
      const idx = Math.floor(t * 60 + 1e-6);
      if (idx !== cache.idx || opts.theme !== cache.theme) {
        const res = {}; paint(sstep((t - 147.6) / 0.9), (c) => U.render(c, t, opts), res);
        fx.setTransform(1, 0, 0, 1, 0, 0); fx.globalCompositeOperation = 'source-over'; fx.globalAlpha = 1; fx.imageSmoothingEnabled = true; fx.imageSmoothingQuality = 'high'; fx.drawImage(out, 0, 0, W, H);
        cache = { idx, wing: res.wing, shot: res.shot, theme: opts.theme };
      }
      ctx.save(); ctx.globalAlpha = 1; ctx.globalCompositeOperation = 'source-over'; ctx.drawImage(frame, 0, 0); ctx.restore();
      return { wing: cache.wing, shot: cache.shot };
    }
    function renderTitleMode(ctx, tl, theme, nowSec, flapStart) {
      const res = {}; paint(1, (c) => U.renderTitleMode(c, tl, theme, nowSec, flapStart), res);
      fx.setTransform(1, 0, 0, 1, 0, 0); fx.imageSmoothingEnabled = true; fx.drawImage(out, 0, 0, W, H); cache.idx = -1;
      ctx.save(); ctx.globalAlpha = 1; ctx.drawImage(frame, 0, 0); ctx.restore(); return { wing: res.wing || 0 };
    }
    return { render, renderTitleMode, W, H, D, CHAPTERS: U.CHAPTERS, TITLE_T: U.TITLE_T, IMPACTS: U.IMPACTS, SC: U.SC };
  }
  root.PMDDestinySpyrook = { create, W, H, D };
})(typeof window !== 'undefined' ? window : globalThis);
