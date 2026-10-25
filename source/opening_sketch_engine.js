/* Opening « PMD : Destiny » — version STUDIO D'ANIMATION 2D « SKETCH » (153 s, même montage et même musique que l'opening ULTIME).
   Chaque image de l'opening ULTIME est redessinée comme sur une feuille de studio : traits au crayon coloré qui « bouillonnent » (3 variantes de tracé en rotation),
   animation « on twos » à 12 images/s, aplats de couleur gouachés légèrement décalés du trait (mauvais repérage), hachures croisées dans les ombres,
   papier à grain avec fibres et taches. Fonction pure du temps : render(ctx, t, opts). Aucune dépendance DOM (le tampon vient de EV.mk). */
(function (root) {
  'use strict';
  const W = 1280, H = 720, D = 153.0, FPS = 12, SW = 640, SH = 360, N = SW * SH;
  const clamp = (x, a, b) => Math.min(b, Math.max(a, x));
  const sstep = (x) => { x = clamp(x, 0, 1); return x * x * (3 - 2 * x); };
  const hash = (x, y, s) => { const v = Math.sin(x * 127.1 + y * 311.7 + s * 74.7) * 43758.5453; return v - Math.floor(v); };

  function create(EV) {
    const U = root.PMDDestinyUltime.create(EV), mk = EV.mk;
    const src = mk(W, H), sx = src.getContext('2d');
    const small = mk(SW, SH), smx = small.getContext('2d', { willReadFrequently: true });
    const out = mk(SW, SH), ox = out.getContext('2d');
    const outId = ox.createImageData(SW, SH), od = outId.data;

    // ---------- papier : fond crème + grain + fibres + taches (une seule fois) ----------
    const paper = new Uint8ClampedArray(N * 3), grain = new Uint8ClampedArray(N);
    (function () {
      const blot = new Float32Array(N);
      for (let y = 0; y < SH; y++) for (let x = 0; x < SW; x++) {
        const i = y * SW + x;
        blot[i] = 0.5 * Math.sin(x * 0.011 + Math.sin(y * 0.017) * 2.0) + 0.35 * Math.sin(y * 0.021 - x * 0.006 + 1.3) + 0.25 * Math.sin((x + y) * 0.043);
      }
      for (let y = 0; y < SH; y++) for (let x = 0; x < SW; x++) {
        const i = y * SW + x, g = hash(x, y, 1), g2 = hash(x >> 1, y >> 1, 2), fib = (hash(x >> 3, y, 3) > 0.985 ? 1 : 0) + (hash(x, y >> 3, 4) > 0.985 ? 1 : 0);
        const e = Math.pow(Math.hypot((x - SW / 2) / (SW / 2), (y - SH / 2) / (SH / 2)), 2.4); // bord de feuille plus chaud/sombre
        const k = 1 + 0.035 * blot[i] + 0.05 * (g - 0.5) + 0.03 * (g2 - 0.5) - 0.05 * fib - 0.09 * e;
        paper[i * 3] = clamp(247 * k, 0, 255); paper[i * 3 + 1] = clamp(240 * k, 0, 255); paper[i * 3 + 2] = clamp(224 * k - 5 * e * 2, 0, 255);
        grain[i] = clamp(Math.round(110 + 150 * g), 0, 255);
      }
    })();
    // champs de déplacement du trait (« boil ») : 3 variantes
    const DX = [], DY = [];
    for (let v = 0; v < 3; v++) {
      const ax = new Int8Array(N), ay = new Int8Array(N);
      for (let y = 0; y < SH; y++) for (let x = 0; x < SW; x++) {
        const i = y * SW + x;
        ax[i] = Math.round(1.5 * Math.sin(x * 0.047 + y * 0.031 + v * 2.1) + 1.0 * Math.sin(y * 0.073 - x * 0.021 + v * 4.3));
        ay[i] = Math.round(1.5 * Math.sin(y * 0.052 - x * 0.029 + v * 3.3) + 1.0 * Math.sin(x * 0.067 + y * 0.019 + v * 1.7));
      }
      DX.push(ax); DY.push(ay);
    }
    // pleine résolution : voile de grain
    const gf = mk(W, H), gfx = gf.getContext('2d'), gid = gfx.createImageData(W, H);
    for (let i = 0; i < W * H; i++) { const v = 205 + Math.round(50 * hash(i % W, (i / W) | 0, 9)); gid.data[i * 4] = v; gid.data[i * 4 + 1] = v - 2; gid.data[i * 4 + 2] = v - 8; gid.data[i * 4 + 3] = 255; }
    gfx.putImageData(gid, 0, 0);

    const WOB = new Float32Array(N); // ondulation des hachures (précalculée)
    for (let y = 0; y < SH; y++) for (let x = 0; x < SW; x++) WOB[y * SW + x] = Math.sin(x * 0.07 + y * 0.03) * 1.6 + Math.sin(y * 0.11) * 0.7;
    const L = new Int16Array(N), C1 = new Int16Array(N), C2 = new Int16Array(N), T = new Int16Array(N);
    const Gm = new Uint8Array(N), S = new Uint8ClampedArray(N * 3);
    function blur3(a) { // flou [1 2 1] séparable
      for (let y = 0; y < SH; y++) { const o = y * SW; for (let x = 1; x < SW - 1; x++) T[o + x] = (a[o + x - 1] + 2 * a[o + x] + a[o + x + 1]) >> 2; T[o] = a[o]; T[o + SW - 1] = a[o + SW - 1]; }
      for (let y = 1; y < SH - 1; y++) { const o = y * SW; for (let x = 0; x < SW; x++) a[o + x] = (T[o - SW + x] + 2 * T[o + x] + T[o + SW + x]) >> 2; }
    }
    function sobelInto(a, k, first) { // |∇a|·k ; first = écrase Gm sinon prend le max
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

    // ---------- une image de studio ----------
    function drawSketch(kt, v, draw, res) {
      sx.setTransform(1, 0, 0, 1, 0, 0);
      const r = draw(sx); res.wing = r.wing; res.shot = r.shot;
      smx.imageSmoothingEnabled = true; smx.drawImage(src, 0, 0, SW, SH);
      const d = smx.getImageData(0, 0, SW, SH).data;
      for (let i = 0, j = 0; i < N; i++, j += 4) {
        const R = d[j], G = d[j + 1], B = d[j + 2];
        L[i] = (R * 77 + G * 150 + B * 29) >> 8; C1[i] = R - B; C2[i] = G - ((R + B) >> 1);
        // aplats gouachés : couleur relevée dans les ombres, posterisée en 7 niveaux, légèrement pastel
        let lr = R + (255 - R) * 0.3, lg = G + (255 - G) * 0.3, lb = B + (255 - B) * 0.32; // gouache clair : on tire vers le papier
        const lu = lr * 0.3 + lg * 0.59 + lb * 0.11, ds = 1.3;
        lr = clamp(lu + (lr - lu) * ds, 0, 255); lg = clamp(lu + (lg - lu) * ds, 0, 255); lb = clamp(lu + (lb - lu) * ds, 0, 255);
        lr = ((lr * 0.0235) + 0.5 | 0) * 42.5; lg = ((lg * 0.0235) + 0.5 | 0) * 42.5; lb = ((lb * 0.0235) + 0.5 | 0) * 42.5;
        S[i * 3] = lr + (R - lr) * kt * 0.6; S[i * 3 + 1] = lg + (G - lg) * kt * 0.6; S[i * 3 + 2] = lb + (B - lb) * kt * 0.6;
      }
      blur3(L); blur3(C1); blur3(C2);
      sobelInto(L, 1.0, true); sobelInto(C1, 0.7, false); sobelInto(C2, 0.8, false);
      const dx = DX[v], dy = DY[v], cox = [2, -1, 1][v], coy = [1, 2, -1][v];
      const TH = 20 + 40 * kt, SOFT = 34, hv = v * 2, st = 1 - 0.45 * kt;
      for (let y = 0; y < SH; y++) {
        for (let x = 0; x < SW; x++) {
          const i = y * SW + x, j = i * 3, o = i * 4;
          // couleur décalée du trait
          const cx = clamp(x + cox, 0, SW - 1), cy = clamp(y + coy, 0, SH - 1), ci = (cy * SW + cx) * 3;
          const pm0 = paper[j] / 255, pm1 = paper[j + 1] / 255, pm2 = paper[j + 2] / 255;
          let r = S[ci] * pm0, g = S[ci + 1] * pm1, b = S[ci + 2] * pm2;
          // trait : gradient échantillonné avec déplacement
          const sxp = clamp(x + dx[i], 0, SW - 1), syp = clamp(y + dy[i], 0, SH - 1), gi = syp * SW + sxp;
          const gr = Math.max(Gm[gi], Gm[Math.min(N - 1, gi + 1)], Gm[Math.min(N - 1, gi + SW)]);
          let a = clamp((gr - TH) / SOFT, 0, 1) * (0.95 + 0.5 * (grain[i] / 255 - 0.5)) * st;
          // hachures dans les ombres (on lit la luminance non décalée)
          const lum = L[i];
          if (lum < 125 && kt < 0.98) {
            const dark = (125 - lum) / 125, wob = WOB[i];
            const h1 = ((x + y + wob + hv) % 6 + 6) % 6 < 1.25, h2 = lum < 80 && ((x - y + wob * 1.3 + hv * 1.5) % 6 + 6) % 6 < 1.15;
            const ha = (h1 ? 0.5 * dark : 0) + (h2 ? 0.45 * dark : 0);
            a = Math.max(a, ha * (1 - kt) * (0.7 + 0.5 * grain[i] / 255));
          }
          if (a > 0.004) {
            // crayon de couleur : le trait prend la teinte (assombrie) de l'aplat
            const ir = S[ci] * 0.16 + 26, ig = S[ci + 1] * 0.16 + 22, ib = S[ci + 2] * 0.16 + 34;
            r = r * (1 - a) + ir * a; g = g * (1 - a) + ig * a; b = b * (1 - a) + ib * a;
          }
          od[o] = r; od[o + 1] = g; od[o + 2] = b; od[o + 3] = 255;
        }
      }
      ox.putImageData(outId, 0, 0);
    }

    // ---------- rendu ----------
    let cache = { idx: -1, wing: 0, shot: '' };
    const frame = mk(W, H), fx = frame.getContext('2d');
    function render(ctx, t, opts) {
      opts = opts || {}; t = clamp(t, 0, D);
      const idx = Math.floor(t * FPS + 1e-6), tq = Math.min(D, idx / FPS);
      if (idx !== cache.idx || opts.theme !== cache.theme) {
        const res = {}; drawSketch(sstep((t - 147.6) / 0.9), idx % 3, (c) => U.render(c, tq, opts), res); // écran-titre : le logo reste lisible → traitement allégé
        fx.setTransform(1, 0, 0, 1, 0, 0); fx.globalCompositeOperation = 'source-over'; fx.globalAlpha = 1; fx.imageSmoothingEnabled = true; fx.drawImage(out, 0, 0, W, H);
        // grain pleine résolution
        fx.globalCompositeOperation = 'multiply'; fx.globalAlpha = 0.55; fx.drawImage(gf, 0, 0); fx.globalAlpha = 1; fx.globalCompositeOperation = 'source-over';
        // bandes de lettrebox : papier chargé au fusain (au lieu du noir)
        const h = 52 * sstep((tq - 0.2) / 1.2) * (1 - sstep((tq - 146.8) / 0.8));
        if (h > 0.5 && tq < 148) {
          fx.fillStyle = 'rgba(38,31,34,0.93)'; fx.fillRect(0, 0, W, h); fx.fillRect(0, H - h, W, h);
          fx.strokeStyle = 'rgba(30,24,28,0.9)'; fx.lineWidth = 2.5; fx.beginPath();
          for (const yy of [h, H - h]) { fx.moveTo(0, yy + Math.sin(idx) * 0.8); for (let x = 0; x <= W; x += 64) fx.lineTo(x, yy + Math.sin(x * 0.05 + idx * 1.3) * 1.2); }
          fx.stroke();
        }
        cache = { idx, wing: res.wing, shot: res.shot, theme: opts.theme };
      }
      ctx.save(); ctx.globalAlpha = 1; ctx.globalCompositeOperation = 'source-over'; ctx.drawImage(frame, 0, 0); ctx.restore();
      return { wing: cache.wing, shot: cache.shot };
    }
    let tc = { idx: -1, wing: 0 };
    function renderTitleMode(ctx, tl, theme, nowSec, flapStart) {
      const idx = Math.floor(nowSec * FPS);
      if (idx !== tc.idx) {
        const res = {}; drawSketch(1, idx % 3, (c) => U.renderTitleMode(c, tl, theme, nowSec, flapStart), res);
        fx.setTransform(1, 0, 0, 1, 0, 0); fx.globalCompositeOperation = 'source-over'; fx.globalAlpha = 1; fx.drawImage(out, 0, 0, W, H);
        fx.globalCompositeOperation = 'multiply'; fx.globalAlpha = 0.55; fx.drawImage(gf, 0, 0); fx.globalAlpha = 1; fx.globalCompositeOperation = 'source-over';
        tc = { idx, wing: res.wing || 0 }; cache.idx = -1;
      }
      ctx.save(); ctx.globalAlpha = 1; ctx.drawImage(frame, 0, 0); ctx.restore(); return { wing: tc.wing };
    }
    return { render, renderTitleMode, W, H, D, CHAPTERS: U.CHAPTERS, TITLE_T: U.TITLE_T, IMPACTS: U.IMPACTS, SC: U.SC };
  }
  root.PMDDestinySketch = { create, W, H, D, FPS };
})(typeof window !== 'undefined' ? window : globalThis);
