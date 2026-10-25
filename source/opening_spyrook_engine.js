/* Opening « PMD : Destiny » — rendu « Peinture HD » : tout le montage de l'ULTIME (153 s) en 1920×1080 NET, avec une caméra de dessin animé.
   (1) L'opening est dessiné directement en 1920×1080 (le moteur est mis à l'échelle ×1,5 : traits, dégradés, effets et textes restent nets).
   (2) Contours arrondis SANS flou : on lisse légèrement, puis chaque pixel reprend la couleur d'origine voisine la plus proche du lissé (aplats purs, frontières courbes).
   (3) Contour fin brun-violet sur les silhouettes ; étalonnage naturel (aucune sursaturation, pas de grain, pas de halo qui baveux).
   (4) Caméra d'animation : un mouvement par plan (avancée lente / recul, dérive vers un coin), tremblement amorti sur chaque impact, bandes de cinéma fixes.
   Fonction pure du temps : render(ctx, t, opts). Aucune dépendance DOM (les tampons viennent de EV.mk). */
(function (root) {
  'use strict';
  const K = 1.5, W = 1920, H = 1080, D = 153.0, N = W * H;
  const clamp = (x, a, b) => Math.min(b, Math.max(a, x));
  const sstep = (x) => { x = clamp(x, 0, 1); return x * x * (3 - 2 * x); };
  // limites des plans : OC1 / SF / MR, puis les plans du clip « sprites » (≥ 46 s) — une caméra différente par plan
  const BOUNDS_DEFAULT = [0, 20, 31, 46, 52.5, 58, 62, 68, 77, 88, 98, 106, 122, 132, 137, 142, 145.2, 148, 153];

  function create(EV) {
    const U = root.PMDDestinyUltime.create(Object.assign({}, EV, { inbetween: true })), mk = EV.mk;
    const src = mk(W, H), sx = src.getContext('2d', { willReadFrequently: true });
    const out = mk(W, H), ox = out.getContext('2d'), outId = ox.createImageData(W, H), od = outId.data;
    const IMP = (U.IMPACTS || []).slice();
    // décors repeints en haute définition : le moteur croit dessiner l'image d'origine (petite) ; au dessin on substitue la version HD (lissée), coordonnées de source mises à l'échelle
    const HI = new Map(); if (EV.hires) for (const k in EV.hires) { const lo = EV.imgs[k], hi = EV.hires[k]; if (lo && hi) HI.set(lo, { hi, fx: hi.width / lo.width, fy: hi.height / lo.height }); }
    if (HI.size) {
      const d0 = sx.drawImage.bind(sx);
      sx.drawImage = function (img, a, b, c, d, e, f, g, h) {
        const m = HI.get(img), n = arguments.length; if (!m) return d0.apply(null, arguments);
        const sm = sx.imageSmoothingEnabled; sx.imageSmoothingEnabled = true; sx.imageSmoothingQuality = 'high';
        if (n === 3) d0(m.hi, a, b, img.width, img.height); else if (n === 5) d0(m.hi, a, b, c, d); else d0(m.hi, a * m.fx, b * m.fy, c * m.fx, d * m.fy, e, f, g, h);
        sx.imageSmoothingEnabled = sm;
      };
    }
    let BOUNDS = BOUNDS_DEFAULT;
    if (U.SHOTS) { const b = new Set([0, 153]); U.SHOTS.forEach((q) => { if (q[1] >= 46 || ['OC1', 'SF', 'MR'].includes(q[0])) { b.add(q[1]); b.add(Math.min(153, q[2])); } }); BOUNDS = [...b].sort((p, q) => p - q).filter((v, i, a) => i === 0 || v - a[i - 1] > 0.5); }

    // ---------------- caméra de dessin animé ----------------
    const PAN = [[-1, 0.4], [1, -0.3], [0.6, 0.7], [-0.8, -0.5], [0, 0.9], [1, 0.2], [-0.5, 0.8], [0.9, -0.6]];
    function camAt(t) {
      let i = 0; while (i < BOUNDS.length - 2 && t >= BOUNDS[i + 1]) i++;
      const b0 = BOUNDS[i], b1 = BOUNDS[i + 1], dur = Math.max(0.5, b1 - b0), u = clamp((t - b0) / dur, 0, 1), e = u * u * (3 - 2 * u) * 0.55 + u * 0.45; // départ et arrivée doux, vitesse presque constante
      const push = i % 2 === 0, amp = dur > 12 ? 0.05 : dur > 6 ? 0.04 : 0.03, live = 1 - sstep((t - 146.4) / 1.0); // le titre final reste immobile
      const z = (1.014 + amp * (push ? e : 1 - e)) * live + (1 - live), pz = (z - 1) * live;
      const p = PAN[i % PAN.length];
      let px = pz * (W / 2) * 0.8 * p[0] * (push ? 1 : -1) * 0.8, py = pz * (H / 2) * 0.8 * p[1] * 0.8;
      // tremblement amorti sur chaque impact (±10 px à 1080p), jamais plus que la réserve de zoom
      let sh = 0; for (const ti of IMP) { const d = t - ti; if (d >= 0 && d < 0.5) sh = Math.max(sh, Math.exp(-d * 9)); }
      if (sh > 0.01) { const a = 9 * sh * live; px += Math.sin(t * 131) * a; py += Math.cos(t * 97) * a * 0.8; }
      const mx = (z - 1) * (W / 2), my = (z - 1) * (H / 2); px = clamp(px, -mx, mx); py = clamp(py, -my, my);
      return { z, px, py };
    }

    // ---------------- contours arrondis nets ----------------
    const BR_ = new Float32Array(N), BG_ = new Float32Array(N), BB_ = new Float32Array(N), TT = new Float32Array(N);
    const KR = new Uint8ClampedArray(N), KG = new Uint8ClampedArray(N), KB = new Uint8ClampedArray(N);
    const Lb = new Int16Array(N), A1 = new Int16Array(N), A2 = new Int16Array(N), Gm = new Uint8Array(N);
    function boxPass(a, r) {
      const n = 2 * r + 1;
      for (let y = 0; y < H; y++) {
        const o = y * W; let s = 0; for (let x = -r; x <= r; x++) s += a[o + clamp(x, 0, W - 1)];
        for (let x = 0; x < W; x++) { TT[o + x] = s / n; s += a[o + Math.min(W - 1, x + r + 1)] - a[o + Math.max(0, x - r)]; }
      }
      for (let x = 0; x < W; x++) {
        let s = 0; for (let y = -r; y <= r; y++) s += TT[clamp(y, 0, H - 1) * W + x];
        for (let y = 0; y < H; y++) { a[y * W + x] = s / n; s += TT[Math.min(H - 1, y + r + 1) * W + x] - TT[Math.max(0, y - r) * W + x]; }
      }
    }
    function smoothSnap(d, rad, m) {
      for (let i = 0, j = 0; i < N; i++, j += 4) { BR_[i] = d[j]; BG_[i] = d[j + 1]; BB_[i] = d[j + 2]; }
      for (let k = 0; k < 2; k++) { boxPass(BR_, rad); boxPass(BG_, rad); boxPass(BB_, rad); }
      const o = [0, -m, m, -m * W, m * W, -m * W - m, -m * W + m, m * W - m, m * W + m].map((v) => v * 4);
      for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) {
        const i = y * W + x, j0 = i * 4;
        if (x < m || y < m || x >= W - m || y >= H - m) { KR[i] = d[j0]; KG[i] = d[j0 + 1]; KB[i] = d[j0 + 2]; continue; }
        const br = BR_[i], bg = BG_[i], bb = BB_[i]; let best = 1e9, bj = j0;
        for (let k = 0; k < 9; k++) {
          const j = j0 + o[k], dr = d[j] - br, dg = d[j + 1] - bg, db = d[j + 2] - bb, e = dr * dr + dg * dg + db * db;
          if (e < best) { best = e; bj = j; }
        }
        KR[i] = d[bj]; KG[i] = d[bj + 1]; KB[i] = d[bj + 2];
      }
    }
    function sobel(a, k, first) {
      for (let y = 1; y < H - 1; y++) {
        const o = y * W;
        for (let x = 1; x < W - 1; x++) {
          const i = o + x;
          const gx = a[i - W + 1] + 2 * a[i + 1] + a[i + W + 1] - a[i - W - 1] - 2 * a[i - 1] - a[i + W - 1];
          const gy = a[i + W - 1] + 2 * a[i + W] + a[i + W + 1] - a[i - W - 1] - 2 * a[i - W] - a[i - W + 1];
          let g = (Math.abs(gx) + Math.abs(gy)) * k * 0.25; if (g > 255) g = 255;
          if (first || g > Gm[i]) Gm[i] = g;
        }
      }
    }

    function paint(kt, draw, res, cam) { // kt = 0 → traitement complet ; 1 → écran-titre allégé
      sx.setTransform(1, 0, 0, 1, 0, 0); sx.globalAlpha = 1; sx.globalCompositeOperation = 'source-over'; sx.fillStyle = '#000'; sx.fillRect(0, 0, W, H);
      sx.save(); sx.translate(W / 2 + cam.px, H / 2 + cam.py); sx.scale(cam.z * K, cam.z * K); sx.translate(-W / (2 * K), -H / (2 * K));
      const r = draw(sx); res.wing = r.wing; res.shot = r.shot; sx.restore();
      const d = sx.getImageData(0, 0, W, H).data;
      smoothSnap(d, 3, 6);
      for (let i = 0; i < N; i++) { Lb[i] = (KR[i] * 77 + KG[i] * 150 + KB[i] * 29) >> 8; A1[i] = KR[i] - KB[i]; A2[i] = KG[i] - ((KR[i] + KB[i]) >> 1); }
      sobel(Lb, 1.0, true); sobel(A1, 0.6, false); sobel(A2, 0.7, false);
      const TH = 46 + 30 * kt, SOFT = 60, sat = 1.0 - 0.02 * kt;
      for (let i = 0; i < N; i++) {
        const o = i * 4; let r = KR[i], g = KG[i], b = KB[i];
        const l = Lb[i]; // étalonnage naturel : saturation d'origine, ombres à peine violettes, hautes lumières à peine chaudes
        r = l + (r - l) * sat; g = l + (g - l) * sat; b = l + (b - l) * sat;
        const sh = clamp((110 - l) / 110, 0, 1), hi = clamp((l - 170) / 85, 0, 1);
        r += -3 * sh + 5 * hi; g += -5 * sh + 3 * hi; b += 9 * sh * (1 - kt) - 5 * hi;
        // contour fin brun-violet (sur les silhouettes seulement)
        const a = clamp((Gm[i] - TH) / SOFT, 0, 1) * 0.8 * (1 - 0.5 * kt);
        if (a > 0.004) { r = r * (1 - a) + (KR[i] * 0.25 + 30) * a; g = g * (1 - a) + (KG[i] * 0.2 + 16) * a; b = b * (1 - a) + (KB[i] * 0.28 + 40) * a; }
        od[o] = clamp(r, 0, 255); od[o + 1] = clamp(g, 0, 255); od[o + 2] = clamp(b, 0, 255); od[o + 3] = 255;
      }
      ox.putImageData(outId, 0, 0);
      // bandes de cinéma fixes (par-dessus la caméra)
      const bh = 52 * K * sstep((cam.t - 0.2) / 1.2) * (1 - sstep((cam.t - 146.8) / 0.8));
      if (bh > 0.5) { ox.fillStyle = '#000'; ox.fillRect(0, 0, W, bh); ox.fillRect(0, H - bh, W, bh); }
    }

    let cache = { idx: -1, wing: 0, shot: '', theme: null };
    function render(ctx, t, opts) {
      opts = opts || {}; t = clamp(t, 0, D);
      const idx = Math.floor(t * 60 + 1e-6);
      if (idx !== cache.idx || opts.theme !== cache.theme) {
        const res = {}, cam = camAt(t); cam.t = t;
        paint(sstep((t - 147.6) / 0.9), (c) => U.render(c, t, opts), res, cam);
        cache = { idx, wing: res.wing, shot: res.shot, theme: opts.theme };
      }
      ctx.save(); ctx.globalAlpha = 1; ctx.globalCompositeOperation = 'source-over'; ctx.drawImage(out, 0, 0); ctx.restore();
      return { wing: cache.wing, shot: cache.shot };
    }
    function renderTitleMode(ctx, tl, theme, nowSec, flapStart) {
      const res = {}; paint(1, (c) => U.renderTitleMode(c, tl, theme, nowSec, flapStart), res, { z: 1, px: 0, py: 0, t: 150 }); cache.idx = -1;
      ctx.save(); ctx.globalAlpha = 1; ctx.drawImage(out, 0, 0); ctx.restore(); return { wing: res.wing || 0 };
    }
    return { render, renderTitleMode, W, H, D, CHAPTERS: U.CHAPTERS, TITLE_T: U.TITLE_T, IMPACTS: U.IMPACTS, SC: U.SC, SHOTS: U.SHOTS, BOUNDS, camAt };
  }
  root.PMDDestinySpyrook = { create, W, H, D };
})(typeof window !== 'undefined' ? window : globalThis);
