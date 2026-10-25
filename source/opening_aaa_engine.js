/* Moteur de rendu de la Cinématique d'Opening AAA « Pokémon Mystery Dungeon : Destiny » — 1280×720, 60 FPS,
   durée EXACTE 153,0 s (02:33) = durée de la vidéo de référence « Simple and Clean -Ray of Hope MIX- ».
   Fonction pure du temps : render(ctx, t, opts) => aucun état caché, donc scrub / pause / reprise sans dérive.
   Aucune dépendance DOM : testable sous Node (@napi-rs/canvas) ET exécutable dans n'importe quel visualiseur. */
(function (root) {
  'use strict';
  const W = 1280, H = 720, D = 153.0, BEAT = 60 / 128;
  const TAU = Math.PI * 2;

  const clamp = (x, a, b) => Math.min(b, Math.max(a, x));
  const sstep = (x) => { x = clamp(x, 0, 1); return x * x * (3 - 2 * x); };
  const lerp = (a, b, u) => a + (b - a) * u;
  const rnd = (i, s) => { const x = Math.sin(i * 127.1 + (s || 0) * 311.7) * 43758.5453; return x - Math.floor(x); };
  function kf(t, keys) {
    if (t <= keys[0][0]) return keys[0][1];
    for (let i = 0; i < keys.length - 1; i++) {
      const a = keys[i], b = keys[i + 1];
      if (t < b[0]) return lerp(a[1], b[1], sstep((t - a[0]) / (b[0] - a[0])));
    }
    return keys[keys.length - 1][1];
  }

  const CHAPTERS = [
    { t: 0.0, name: "I · Au fond de l'océan — le Wayfinder", short: 'I · Océan & Rivage' },
    { t: 24.0, name: 'II · Chute dans la lumière — le Vitrail du Destin', short: 'II · Vitrail du Destin' },
    { t: 46.0, name: 'III · Trois Wayfinders — les 13 sièges de ténèbres', short: 'III · 13 Ténèbres' },
    { t: 68.0, name: "IV · Mêlée dans l'Arène Eau-Miroir", short: 'IV · Mêlée Eau-Miroir' },
    { t: 106.0, name: 'V · Chute céleste — la barrière de lumière', short: 'V · Chute Céleste' },
    { t: 132.0, name: "VI · Le Rayon d'Espoir", short: "VI · Rayon d'Espoir" },
  ];
  const TITLE_T = 148.0;
  const IMPACTS = [78.0, 80.4, 83.1, 86.0, 88.5, 91.2, 94.0, 96.8, 99.0, 101.8, 104.3];

  function create(E) {
    const I = E.imgs;
    const mk = E.mk;
    const scr = mk(W, H);
    const sctx = scr.getContext('2d');
    const overlay = mk(W, H);
    const octx = overlay.getContext('2d');
    const rigC = mk(580, 418); const rigX = rigC.getContext('2d');
    const tintC = mk(580, 418); const tintX = tintC.getContext('2d');
    const tintCache = {};

    function tinted(img, color, amt, key) {
      if (tintCache[key]) return tintCache[key];
      const c = mk(img.width, img.height); const g = c.getContext('2d');
      g.drawImage(img, 0, 0);
      g.globalCompositeOperation = 'source-atop';
      g.globalAlpha = amt; g.fillStyle = color; g.fillRect(0, 0, img.width, img.height);
      tintCache[key] = c; return c;
    }
    const starCyan = () => I.wayfinder;
    const starRose = () => tinted(I.wayfinder, '#ff5a9a', 0.55, 'rose');
    const starAmber = () => tinted(I.wayfinder, '#ffb020', 0.6, 'amber');

    // ---------- Primitives ----------
    function drawPlate(ctx, img, fx, fy, zoom, alpha) {
      const s = (W / img.width) * zoom * 1.035;
      const iw = img.width * s, ih = img.height * s;
      let dx = W / 2 - fx * iw, dy = H / 2 - fy * ih;
      dx = clamp(dx, W - iw, 0); dy = clamp(dy, H - ih, 0);
      ctx.globalAlpha = alpha == null ? 1 : alpha;
      ctx.drawImage(img, dx, dy, iw, ih);
      ctx.globalAlpha = 1;
      return { dx, dy, iw, ih, X: (u) => dx + u * iw, Y: (v) => dy + v * ih, s: iw / W };
    }
    function glow(ctx, x, y, r, rgb, a) {
      if (a <= 0.003) return;
      ctx.save(); ctx.globalCompositeOperation = 'lighter';
      const g = ctx.createRadialGradient(x, y, 0, x, y, r);
      g.addColorStop(0, `rgba(${rgb},${clamp(a, 0, 1).toFixed(3)})`);
      g.addColorStop(0.45, `rgba(${rgb},${(clamp(a, 0, 1) * 0.35).toFixed(3)})`);
      g.addColorStop(1, `rgba(${rgb},0)`);
      ctx.fillStyle = g; ctx.fillRect(x - r, y - r, r * 2, r * 2); ctx.restore();
    }
    function sprite(ctx, img, x, y, w, rot, alpha) {
      const h = w * (img.height / img.width);
      ctx.save(); ctx.translate(x, y); ctx.rotate(rot || 0);
      ctx.globalAlpha = alpha == null ? 1 : alpha;
      ctx.drawImage(img, -w / 2, -h / 2, w, h); ctx.restore();
    }
    function flash(ctx, a, rgb) {
      if (a <= 0.003) return;
      ctx.fillStyle = `rgba(${rgb || '255,255,255'},${clamp(a, 0, 1).toFixed(3)})`; ctx.fillRect(0, 0, W, H);
    }
    function grade(ctx, color, mode) {
      ctx.save(); ctx.globalCompositeOperation = mode || 'multiply'; ctx.fillStyle = color; ctx.fillRect(0, 0, W, H); ctx.restore();
    }
    function bubbles(ctx, t, n, seed, alpha, speed, x0, x1) {
      ctx.save(); ctx.lineWidth = 1.6;
      for (let i = 0; i < n; i++) {
        const x = lerp(x0 == null ? 0 : x0, x1 == null ? W : x1, rnd(i, seed + 1)) + Math.sin(t * 1.3 + i * 2.1) * 14;
        const y = H + 40 - ((t * speed * (0.45 + rnd(i, seed + 2)) * 55 + rnd(i, seed) * H * 1.3) % (H + 80));
        const r = 3 + rnd(i, seed + 3) * 14;
        ctx.strokeStyle = `rgba(200,244,255,${alpha})`; ctx.beginPath(); ctx.arc(x, y, r, 0, TAU); ctx.stroke();
        ctx.fillStyle = `rgba(255,255,255,${alpha * 0.9})`; ctx.beginPath(); ctx.arc(x - r * 0.35, y - r * 0.35, Math.max(1, r * 0.22), 0, TAU); ctx.fill();
      }
      ctx.restore();
    }
    function motes(ctx, t, n, seed, rgb, alpha, speed, up) {
      ctx.save(); ctx.globalCompositeOperation = 'lighter';
      for (let i = 0; i < n; i++) {
        const x = (rnd(i, seed) * W + Math.sin(t * 0.7 + i) * 24 + W) % W;
        const dir = up ? -1 : 1;
        const y = (((rnd(i, seed + 1) * H + dir * t * speed * (8 + 40 * rnd(i, seed + 2))) % H) + H) % H;
        const tw = 0.35 + 0.65 * Math.abs(Math.sin(t * (1.5 + rnd(i, seed + 3) * 3) + i));
        const r = 1 + rnd(i, seed + 4) * 2.6;
        ctx.fillStyle = `rgba(${rgb},${(alpha * tw).toFixed(3)})`; ctx.beginPath(); ctx.arc(x, y, r, 0, TAU); ctx.fill();
      }
      ctx.restore();
    }
    function godRays(ctx, t, a, ox, oy, n, spread, len) {
      ctx.save(); ctx.globalCompositeOperation = 'lighter';
      for (let i = 0; i < n; i++) {
        const ang = Math.PI / 2 + (-0.5 + i / (n - 1)) * spread + Math.sin(t * 0.3 + i) * 0.035;
        const w = 22 + rnd(i, 3) * 80;
        const dx = Math.cos(ang), dy = Math.sin(ang);
        const x2 = ox + dx * len, y2 = oy + dy * len;
        const g = ctx.createLinearGradient(ox, oy, x2, y2);
        const aa = a * (0.45 + 0.55 * Math.sin(t * 0.8 + i * 1.7) ** 2) * 0.55;
        g.addColorStop(0, `rgba(255,246,206,${aa.toFixed(3)})`); g.addColorStop(1, 'rgba(255,246,206,0)');
        ctx.fillStyle = g; ctx.beginPath();
        ctx.moveTo(ox - 5, oy); ctx.lineTo(ox + 5, oy);
        ctx.lineTo(x2 + w, y2); ctx.lineTo(x2 - w, y2); ctx.closePath(); ctx.fill();
      }
      ctx.restore();
    }
    function speedLines(ctx, t, n, cx, cy, rgb, alpha, inner) {
      ctx.save(); ctx.globalCompositeOperation = 'lighter';
      for (let i = 0; i < n; i++) {
        const ang = rnd(i, 7) * TAU;
        const ph = (t * (1.6 + rnd(i, 8) * 2.2) + rnd(i, 9)) % 1;
        const r0 = (inner || 180) + ph * 700, r1 = r0 + 70 + rnd(i, 10) * 260 * ph;
        ctx.strokeStyle = `rgba(${rgb},${(alpha * Math.sin(ph * Math.PI)).toFixed(3)})`;
        ctx.lineWidth = 1 + rnd(i, 11) * 2.4;
        ctx.beginPath(); ctx.moveTo(cx + Math.cos(ang) * r0, cy + Math.sin(ang) * r0);
        ctx.lineTo(cx + Math.cos(ang) * r1, cy + Math.sin(ang) * r1); ctx.stroke();
      }
      ctx.restore();
    }
    function ring(ctx, x, y, r, w, rgb, a) {
      if (a <= 0.003) return;
      ctx.save(); ctx.globalCompositeOperation = 'lighter';
      ctx.strokeStyle = `rgba(${rgb},${clamp(a, 0, 1).toFixed(3)})`; ctx.lineWidth = Math.max(1, w);
      ctx.beginPath(); ctx.arc(x, y, Math.max(1, r), 0, TAU); ctx.stroke(); ctx.restore();
    }
    function starBurst(ctx, x, y, r, a, rays, rot) {
      if (a <= 0.003) return;
      ctx.save(); ctx.translate(x, y); ctx.rotate(rot || 0); ctx.globalCompositeOperation = 'lighter';
      for (let i = 0; i < rays; i++) {
        ctx.rotate(TAU / rays);
        const g = ctx.createLinearGradient(0, 0, r, 0);
        g.addColorStop(0, `rgba(255,255,255,${clamp(a, 0, 1).toFixed(3)})`); g.addColorStop(1, 'rgba(255,230,160,0)');
        ctx.fillStyle = g; ctx.beginPath(); ctx.moveTo(0, -r * 0.035); ctx.lineTo(r, 0); ctx.lineTo(0, r * 0.035); ctx.closePath(); ctx.fill();
      }
      ctx.restore();
    }
    function shards(ctx, x, y, u, n, seed, cols, speed, size) {
      if (u < 0 || u > 1.6) return;
      ctx.save();
      for (let i = 0; i < n; i++) {
        const a = rnd(i, seed) * TAU, v = speed * (0.35 + rnd(i, seed + 1));
        const px = x + Math.cos(a) * v * u, py = y + Math.sin(a) * v * u * 0.8 + 420 * u * u;
        const rot = u * (rnd(i, seed + 2) - 0.5) * 18, s = size * (0.5 + rnd(i, seed + 3));
        ctx.globalAlpha = clamp(1 - u / 1.5, 0, 1);
        ctx.fillStyle = cols[i % cols.length];
        ctx.save(); ctx.translate(px, py); ctx.rotate(rot);
        ctx.beginPath(); ctx.moveTo(-s, s * 0.6); ctx.lineTo(s * 0.2, -s); ctx.lineTo(s, s * 0.5); ctx.closePath(); ctx.fill();
        ctx.strokeStyle = 'rgba(255,255,255,0.8)'; ctx.lineWidth = 1; ctx.stroke(); ctx.restore();
      }
      ctx.restore();
    }
    let vig = null;
    function vignette(ctx, k) {
      if (!vig) {
        vig = mk(W, H); const g = vig.getContext('2d');
        const gr = g.createRadialGradient(W / 2, H / 2, H * 0.42, W / 2, H / 2, H * 1.0);
        gr.addColorStop(0, 'rgba(0,0,0,0)'); gr.addColorStop(1, 'rgba(0,0,0,0.78)');
        g.fillStyle = gr; g.fillRect(0, 0, W, H);
      }
      ctx.globalAlpha = k; ctx.drawImage(vig, 0, 0); ctx.globalAlpha = 1;
    }
    function impactFrame(ctx, a) {
      ctx.save(); ctx.globalAlpha = a;
      ctx.globalCompositeOperation = 'saturation'; ctx.fillStyle = '#808080'; ctx.fillRect(0, 0, W, H);
      ctx.globalCompositeOperation = 'difference'; ctx.fillStyle = '#ffffff'; ctx.fillRect(0, 0, W, H);
      ctx.globalCompositeOperation = 'overlay'; ctx.fillStyle = '#9a9a9a'; ctx.fillRect(0, 0, W, H);
      ctx.restore();
    }
    function spotlight(ctx, t, a, x) {
      ctx.save(); ctx.globalCompositeOperation = 'lighter';
      const g = ctx.createLinearGradient(0, 0, 0, H);
      g.addColorStop(0, `rgba(210,250,255,${(a * 0.9).toFixed(3)})`); g.addColorStop(1, 'rgba(120,220,255,0)');
      ctx.fillStyle = g; ctx.beginPath();
      const sw = 70 + Math.sin(t * 0.8) * 8;
      ctx.moveTo(x - sw, 0); ctx.lineTo(x + sw, 0); ctx.lineTo(x + 330, H); ctx.lineTo(x - 330, H); ctx.closePath(); ctx.fill();
      ctx.restore();
    }

    // ---------- Segments ----------
    function abyssPlate(ctx, fx, fy, z, dark) {
      const c = drawPlate(ctx, I.abyss, fx, fy, z);
      if (dark) grade(ctx, `rgba(${Math.round(255 - 205 * dark)},${Math.round(255 - 170 * dark)},${Math.round(255 - 90 * dark)},1)`, 'multiply');
      return c;
    }
    function causticsOverlay(ctx, t, a) {
      ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.globalAlpha = a;
      for (let i = 0; i < 26; i++) {
        const x = (rnd(i, 1) * W + t * (10 + rnd(i, 2) * 20)) % W;
        const y = rnd(i, 3) * H * 0.55;
        const w = 60 + rnd(i, 4) * 170;
        const g = ctx.createRadialGradient(x, y, 0, x, y, w);
        g.addColorStop(0, 'rgba(180,255,245,0.22)'); g.addColorStop(1, 'rgba(180,255,245,0)');
        ctx.fillStyle = g; ctx.save(); ctx.translate(x, y); ctx.scale(1, 0.22); ctx.translate(-x, -y);
        ctx.fillRect(x - w, y - w, w * 2, w * 2); ctx.restore();
      }
      ctx.restore();
    }

    function seg_abyssIntro(ctx, t) {
      const fy = kf(t, [[0, 0.80], [5.5, 0.36]]), z = kf(t, [[0, 1.65], [5.5, 1.04]]);
      const c = drawPlate(ctx, I.abyss, 0.5, fy, z);
      causticsOverlay(ctx, t, 0.9);
      godRays(ctx, t, 0.5, W * 0.5, -20, 9, 1.3, H * 1.1);
      const sx = c.X(0.5), sy = c.Y(0.80);
      glow(ctx, sx, sy, 150 * c.s, '120,240,255', 0.42 + 0.12 * Math.sin(t * 3));
      bubbles(ctx, t, 38, 5, 0.55, 1.0);
      motes(ctx, t, 50, 6, '190,250,255', 0.65, 0.5, true);
    }
    function seg_shore1(ctx, t) {
      const u = t - 5.5;
      const fx = kf(u, [[0, 0.35], [4.5, 0.62]]), z = kf(u, [[0, 1.05], [4.5, 1.28]]);
      drawPlate(ctx, I.shore, fx, 0.5, z);
      motes(ctx, t, 55, 8, '255,240,190', 0.8, 0.3, true);
      godRays(ctx, t, 0.22, W * 0.12, 60, 6, 1.0, H * 1.0);
    }
    function seg_starClose(ctx, t) {
      const u = t - 10;
      const z = kf(u, [[0, 1.2], [3.5, 2.5]]);
      const c = drawPlate(ctx, I.abyss, 0.5, kf(u, [[0, 0.62], [3.5, 0.78]]), z);
      causticsOverlay(ctx, t, 0.5);
      const sx = c.X(0.5), sy = c.Y(0.80), p = 0.5 + 0.5 * Math.sin(t * 3.2);
      glow(ctx, sx, sy, 330 * c.s, '110,235,255', 0.35 + 0.35 * p + 0.2 * sstep(u / 3.5));
      starBurst(ctx, sx, sy, 220 * c.s, 0.35 * p, 8, t * 0.2);
      bubbles(ctx, t, 30, 11, 0.6, 1.0); motes(ctx, t, 50, 12, '255,236,170', 0.8, 0.5, true);
    }
    function seg_rioluReach(ctx, t) {
      const u = t - 13.5;
      const z = kf(u, [[0, 1.2], [5.5, 2.4]]);
      const c = drawPlate(ctx, I.shore, kf(u, [[0, 0.5], [5.5, 0.37]]), kf(u, [[0, 0.55], [5.5, 0.66]]), z);
      for (let k = 0; k < 4; k++) {
        const ph = ((u * 0.5 + k * 0.25) % 1);
        ctx.save(); ctx.translate(c.X(0.355), c.Y(0.735)); ctx.scale(1, 0.38);
        ring(ctx, 0, 0, 14 + ph * 120 * c.s, 2.4, '230,255,255', 0.75 * (1 - ph)); ctx.restore();
      }
      glow(ctx, c.X(0.35), c.Y(0.735), 110 * c.s, '170,255,255', 0.35 * sstep((u - 2) / 3) * (0.7 + 0.3 * Math.sin(t * 5)));
      motes(ctx, t, 60, 14, '255,250,210', 0.9, 0.2, true);
    }
    function seg_starGlow(ctx, t) {
      const u = t - 19;
      const c = drawPlate(ctx, I.abyss, 0.5, 0.74, kf(u, [[0, 2.5], [5, 1.5]]));
      const sx = c.X(0.5), sy = c.Y(0.80);
      const k = sstep(u / 4.4);
      glow(ctx, sx, sy, lerp(300, 1100, k) * c.s, '150,245,255', 0.5 + 0.5 * k);
      starBurst(ctx, sx, sy, lerp(240, 1200, k), 0.5 + 0.4 * k, 10, t * 0.3);
      bubbles(ctx, t, 36, 15, 0.6, 1.3); motes(ctx, t, 60, 16, '255,250,200', 0.9, 0.8, true);
      flash(ctx, sstep((u - 3.9) / 1.0));
    }

    function seg_evoliDrift(ctx, t) {
      const u = t - 24;
      drawPlate(ctx, I.abyss, 0.5 + 0.05 * Math.sin(u * 0.2), 0.5, 1.15 + u * 0.003);
      grade(ctx, 'rgb(30,60,120)', 'multiply');
      spotlight(ctx, t, 0.55, W * 0.5);
      motes(ctx, t, 120, 21, '200,240,255', 0.9, 0.4, true);
      bubbles(ctx, t, 20, 22, 0.35, 0.6);
      // Vitrail du Destin dérivant en arrière-plan puis en avant-plan
      const gk = sstep((u - 5.5) / 3), gout = 1 - sstep((u - 20.5) / 1.5);
      if (gk > 0.002 && gout > 0.002) {
        const gx = kf(u, [[5.5, W * 0.88], [14, W * 0.58], [22, W * 0.30]]);
        const gy = H * 0.5 + Math.sin(u * 0.4) * 22;
        const gs = kf(u, [[5.5, 420], [14, 640], [22, 860]]);
        const lit = sstep((u - 17) / 3.4);
        glow(ctx, gx, gy, gs * 0.9, '120,200,255', 0.35 * gk * gout + 0.5 * lit * gout);
        ctx.save(); ctx.globalAlpha = gk * gout * 0.96; ctx.translate(gx, gy); ctx.rotate(u * 0.045);
        ctx.drawImage(I.stainedGlass, -gs / 2, -gs / 2, gs, gs); ctx.restore();
        if (lit > 0) { glow(ctx, gx, gy, gs * 0.7, '255,255,255', 0.75 * lit * gout); }
      }
      // Évoli en chute arrière
      const ea = sstep(u / 2.2) * (1 - sstep((u - 21.2) / 0.8));
      const ex = kf(u, [[0, W * 0.40], [10, W * 0.47], [22, W * 0.60]]) + Math.sin(u * 0.55) * 22;
      const ey = H * 0.52 + Math.sin(u * 0.7) * 26 + kf(u, [[0, -40], [22, 30]]);
      const rot = -0.28 + Math.sin(u * 0.5) * 0.07 + u * 0.004;
      glow(ctx, ex, ey, 360, '130,230,255', 0.28 * ea);
      sprite(ctx, I.evoliCutout, ex, ey, 560 + u * 3, rot, ea);
      starBurst(ctx, ex + 82, ey - 6, 110, 0.5 * ea * (0.6 + 0.4 * Math.sin(t * 4)), 6, t);
      flash(ctx, sstep((u - 20.6) / 1.4));
    }

    function seg_plunge(ctx, t) {
      const u = t - 46;
      const z = kf(u, [[0, 1.0], [6.5, 1.22]]);
      drawPlate(ctx, I.shore, 0.5, 0.5, z);
      grade(ctx, 'rgb(150,160,210)', 'multiply');
      const water = H * 0.62;
      const cols = [['#ffffff', '#9ff4ff', '#ffd45a'], ['#ffffff', '#ff9ac6', '#ffe08a'], ['#ffffff', '#9ff4ff', '#8affc8']];
      const xs = [W * 0.30, W * 0.52, W * 0.73];
      let shake = 0;
      for (let i = 0; i < 3; i++) {
        const ts = 0.4 + i * 0.75, fall = 1.7, ti = ts + fall;
        const v = u - ts;
        if (v > 0 && v < fall) {
          const y = lerp(-90, water, v / fall) ;
          const x = xs[i] + Math.sin(v * 3 + i) * 18;
          for (let k = 1; k < 9; k++) {
            const yy = y - k * 26; glow(ctx, x, yy, 40 - k * 3.5, '150,240,255', 0.32 - k * 0.032);
          }
          glow(ctx, x, y, 120, '170,245,255', 0.6);
          const img = i === 1 ? starRose() : (i === 2 ? starAmber() : starCyan());
          sprite(ctx, img, x, y, 110, v * 4 + i, 1);
        }
        const w = u - ti;
        if (w >= 0) {
          const k = Math.exp(-w * 3);
          flash(ctx, 0.5 * k, '255,255,255');
          starBurst(ctx, xs[i], water, 360 * (0.5 + k), 0.9 * k, 9, i);
          for (let r = 0; r < 3; r++) {
            const pr = clamp(w * 1.1 - r * 0.2, 0, 1.6);
            ctx.save(); ctx.translate(xs[i], water); ctx.scale(1, 0.32);
            ring(ctx, 0, 0, 20 + pr * 260, 3, '230,255,255', 0.8 * (1 - pr / 1.6)); ctx.restore();
          }
          shake += 7 * k;
          if (i < 2) shards(ctx, xs[i], water - 30, w, 26, 40 + i, cols[i], 380, 11);
          else {
            const sink = sstep(w / 1.6);
            ctx.save(); ctx.beginPath(); ctx.rect(0, 0, W, water + 6); ctx.clip();
            sprite(ctx, starAmber(), xs[i], water - 20 + sink * 90, 110, 0.2, 1 - sink); ctx.restore();
          }
        }
      }
      // Éclairs de combat lointains
      for (let k = 0; k < 6; k++) {
        const tf = 0.9 + k * 0.78, d = u - tf;
        if (d > 0 && d < 0.22) starBurst(ctx, W * (0.2 + rnd(k, 3) * 0.6), H * (0.35 + rnd(k, 4) * 0.2), 220, 1 - d / 0.22, 6, k);
      }
      motes(ctx, t, 50, 31, '255,240,200', 0.8, 0.4, true);
      if (shake > 0.4) { /* léger tremblement de caméra simulé par un voile */ flash(ctx, Math.min(0.1, shake * 0.008), '255,255,255'); }
      flash(ctx, sstep((u - 5.8) / 0.7));
    }

    function seg_sink(ctx, t) {
      const u = t - 52.5;
      const c = drawPlate(ctx, I.abyss, 0.5, kf(u, [[0, 0.26], [5.5, 0.62]]), kf(u, [[0, 1.05], [5.5, 1.5]]));
      grade(ctx, 'rgb(90,130,200)', 'multiply');
      const y = kf(u, [[0, 0.04], [5.5, 0.78]]);
      const sx = W * 0.5 + Math.sin(u * 1.4) * 40, sy = H * y + 40;
      for (let k = 1; k < 12; k++) glow(ctx, sx + Math.sin((u - k * 0.08) * 1.4) * 40, sy - k * 24, 46 - k * 3, '150,240,255', 0.3 - k * 0.024);
      glow(ctx, sx, sy, 260, '130,235,255', 0.7);
      sprite(ctx, starAmber(), sx, sy, 130, u * 1.3, 1);
      bubbles(ctx, t, 40, 41, 0.55, 1.6); motes(ctx, t, 60, 42, '190,245,255', 0.8, 0.8, true);
    }
    function seg_evoliStar(ctx, t) {
      const u = t - 58;
      drawPlate(ctx, I.abyss, 0.5, 0.65, 1.3);
      grade(ctx, 'rgb(45,85,160)', 'multiply');
      spotlight(ctx, t, 0.75, W * 0.5);
      const ey = H * 0.60 + Math.sin(u * 1.1) * 12;
      glow(ctx, W * 0.5, ey, 420, '130,230,255', 0.3);
      sprite(ctx, I.evoliCutout, W * 0.5, ey, 620, -0.18 + Math.sin(u) * 0.04, 1);
      const rise = sstep(u / 1.6);
      const sx = W * 0.5 + 106, sy = lerp(H * 0.98, ey - 6, rise);
      glow(ctx, sx, sy, 150 + 90 * Math.sin(u * 6) ** 2, '170,245,255', 0.7);
      sprite(ctx, starCyan(), sx, sy, 76, u * 2, 1);
      const comp = sstep((u - 1.6) / 1.0), vanish = sstep((u - 3.0) / 0.8);
      const stars = [[W * 0.2, H * 0.28, starRose()], [W * 0.8, H * 0.30, starAmber()]];
      for (let i = 0; i < 2; i++) {
        const [px, py, img] = stars[i];
        const yy = py + vanish * 360;
        glow(ctx, px, yy, 180, '255,255,255', 0.45 * comp * (1 - vanish));
        sprite(ctx, img, px, yy, 110, Math.sin(u * 2 + i) * 0.2, comp * (1 - vanish));
        if (vanish > 0) {
          ctx.save(); ctx.translate(0, 0);
          sprite(ctx, img, px, H * 0.9 + (H * 0.9 - yy) * 0.2 - 40, 110, 0, 0.35 * (1 - vanish)); ctx.restore();
        }
      }
      bubbles(ctx, t, 28, 51, 0.5, 0.8); motes(ctx, t, 60, 52, '190,245,255', 0.8, 0.6, true);
    }

    const PIL = [[0.2267, 0.42], [0.260, 0.39], [0.292, 0.45], [0.320, 0.34], [0.390, 0.45], [0.385, 0.31], [0.543, 0.465], [0.609, 0.465], [0.641, 0.455], [0.668, 0.30], [0.706, 0.44], [0.735, 0.35], [0.772, 0.40]];
    function pillarMask(ctx, c, ign, t, base) {
      octx.clearRect(0, 0, W, H);
      octx.globalCompositeOperation = 'source-over';
      octx.fillStyle = `rgba(2,3,18,${base})`; octx.fillRect(0, 0, W, H);
      octx.globalCompositeOperation = 'destination-out';
      for (let i = 0; i < PIL.length; i++) {
        const k = sstep(ign[i]);
        if (k <= 0) continue;
        const px = c.X(PIL[i][0]), py = c.Y(PIL[i][1]);
        for (const [dy, ry] of [[0.12, 0.36], [0.62, 0.34]]) {
          octx.save(); octx.translate(px, c.Y(dy + 0.38)); octx.scale(0.14 + 0.02 * k, 1);
          const g = octx.createRadialGradient(0, 0, 0, 0, 0, ry * c.ih);
          g.addColorStop(0, `rgba(0,0,0,${k})`); g.addColorStop(0.7, `rgba(0,0,0,${0.7 * k})`); g.addColorStop(1, 'rgba(0,0,0,0)');
          octx.fillStyle = g; octx.beginPath(); octx.arc(0, 0, ry * c.ih, 0, TAU); octx.fill(); octx.restore();
        }
      }
      ctx.drawImage(overlay, 0, 0);
    }
    function pillarFx(ctx, c, t, ign) {
      for (let i = 0; i < PIL.length; i++) {
        const k = sstep(ign[i]); if (k <= 0) continue;
        const px = c.X(PIL[i][0]), py = c.Y(PIL[i][1]);
        glow(ctx, px, py, 120 * c.s, '255,90,200', 0.4 * k * (0.7 + 0.3 * Math.sin(t * 7 + i)));
        glow(ctx, px, c.Y(0.82 + 0.0 * i), 90 * c.s, '255,90,200', 0.18 * k);
      }
      ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.globalAlpha = 0.14;
      for (let k = 0; k < 30; k++) {
        const y = c.Y(0.62) + k * 11 * c.s + Math.sin(t * 2 + k) * 3, xo = Math.sin(t * 0.9 + k * 1.3) * 60;
        ctx.fillStyle = '#b8d8ff'; ctx.fillRect(W * 0.1 + xo, y, W * 0.8 * (0.3 + rnd(k, 5) * 0.7), 1.4);
      }
      ctx.restore();
      motes(ctx, t, 50, 61, '255,120,220', 0.8, 0.6, true);
    }
    function seg_pillarsIgnite(ctx, t) {
      const u = t - 62;
      const c = drawPlate(ctx, I.mirrorPillars, 0.5, kf(u, [[0, 0.72], [6, 0.48]]), kf(u, [[0, 1.5], [6, 1.04]]));
      const ign = PIL.map((_, i) => clamp((u - (0.4 + i * 0.43)) / 0.5, 0, 1));
      const allDone = clamp((u - 5.4) / 0.6, 0, 1);
      pillarMask(ctx, c, ign, t, 0.85 * (1 - allDone));
      pillarFx(ctx, c, t, ign);
      ctx.save(); ctx.globalAlpha = 0.18 * sstep(u / 1.5); grade(ctx, 'rgb(20,10,60)', 'multiply'); ctx.restore();
    }
    function seg_pillarsPush(ctx, t) {
      const u = t - 68;
      const z = kf(u, [[0, 1.04], [8, 1.55]]);
      const c = drawPlate(ctx, I.mirrorPillars, 0.5, kf(u, [[0, 0.48], [8, 0.52]]), z);
      pillarFx(ctx, c, t, PIL.map(() => 1));
      const bl = 0.4 + 0.6 * Math.abs(Math.sin(u * 0.9));
      glow(ctx, W * 0.5, H * 0.5, 700, '150,40,220', 0.12 * bl);
      ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.strokeStyle = 'rgba(190,200,255,0.25)'; ctx.lineWidth = 1;
      for (let i = 0; i < 90; i++) {
        const x = rnd(i, 71) * W, y = ((rnd(i, 72) * H + t * 900 * (0.6 + rnd(i, 73))) % (H + 40)) - 20;
        ctx.beginPath(); ctx.moveTo(x, y); ctx.lineTo(x - 6, y + 26); ctx.stroke();
      }
      ctx.restore();
      for (let k = 0; k < 5; k++) {
        const d = u - (1.3 + k * 1.5);
        if (d > 0 && d < 0.18) flash(ctx, 0.35 * (1 - d / 0.18), '190,150,255');
      }
      flash(ctx, 0.5 * (1 - sstep(u / 0.5)), '255,255,255');
    }

    // ---------- Mêlée Sakuga ----------
    function seg_clash(ctx, t) {
      const u = t - 76;
      let sh = 0, pulse = 0;
      for (const ti of IMPACTS) { const d = t - ti; if (d >= 0 && d < 0.6) sh += Math.exp(-d * 8) * 14; }
      const ph = (t % BEAT) / BEAT; pulse = Math.exp(-ph * 6) * 0.018;
      const fx = kf(t, [[76, 0.24], [80, 0.32], [84, 0.50], [88, 0.50], [92, 0.72], [96, 0.74], [100, 0.52], [104.5, 0.5]]);
      const fy = kf(t, [[76, 0.42], [84, 0.50], [92, 0.46], [100, 0.5], [104.5, 0.5]]);
      const z = kf(t, [[76, 1.35], [80, 1.5], [84, 1.6], [88, 1.75], [92, 1.6], [96, 1.45], [100, 1.25], [104.5, 1.02]]) * (1 + pulse);
      ctx.save();
      ctx.translate(Math.sin(t * 61) * sh, Math.cos(t * 73) * sh);
      const c = drawPlate(ctx, I.sakugaClash, fx, fy, z * 1.02);
      const ix = c.X(0.555), iy = c.Y(0.475);
      const hot = Math.exp(-((t % BEAT) / BEAT) * 5);
      glow(ctx, ix, iy, 260 * c.s, '255,235,160', 0.14 + 0.3 * hot);
      starBurst(ctx, ix, iy, 380 * c.s, 0.10 + 0.4 * hot, 12, t * 0.6);
      // rubans d'énergie cyan (gauche) vs cramoisi (droite)
      ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.lineCap = 'round';
      for (let i = 0; i < 9; i++) {
        const ph2 = (t * 0.9 + i / 9) % 1, side = i % 2 === 0 ? -1 : 1;
        const sx0 = ix + side * (900 + rnd(i, 3) * 400) * c.s, sy0 = iy + (rnd(i, 4) - 0.2) * 520 * c.s;
        const px = lerp(sx0, ix, ph2), py = lerp(sy0, iy, ph2) + Math.sin(ph2 * 6 + i) * 70 * c.s;
        const qx = lerp(sx0, ix, Math.max(0, ph2 - 0.25)), qy = lerp(sy0, iy, Math.max(0, ph2 - 0.25)) + Math.sin((ph2 - 0.25) * 6 + i) * 70 * c.s;
        ctx.strokeStyle = side < 0 ? `rgba(90,230,255,${0.8 * Math.sin(ph2 * Math.PI)})` : `rgba(255,70,110,${0.8 * Math.sin(ph2 * Math.PI)})`;
        ctx.lineWidth = 3 + rnd(i, 5) * 8; ctx.beginPath(); ctx.moveTo(qx, qy); ctx.lineTo(px, py); ctx.stroke();
      }
      ctx.restore();
      // éclats du portail-vitrail
      const sd = u - 0.0;
      shards(ctx, c.X(0.10), c.Y(0.42), sd * 0.6, 34, 81, ['#4aa8ff', '#ffd45a', '#4be8a8', '#ffffff', '#6a7bff'], 760, 22);
      // gouttes
      motes(ctx, t, 90, 82, '210,240,255', 0.8, 2.2, false);
      ctx.restore();
      for (const ti of IMPACTS) {
        const d = t - ti;
        if (d >= 0 && d < 0.12) impactFrame(ctx, 1 - d / 0.13);
        if (d >= 0 && d < 0.2) flash(ctx, 0.22 * (1 - d / 0.2), '255,250,230');
      }
      speedLines(ctx, t, 36, ix, iy, '255,244,210', 0.5, 160);
      // Intro : éclat blanc à la rupture
      flash(ctx, 1 - sstep(u / 0.6));
      // Final : pull-out vers l'éclat blanc
      flash(ctx, sstep((t - 105.2) / 0.8));
    }

    // ---------- Chute céleste ----------
    function seg_skyfall(ctx, t) {
      const u = t - 106;
      let sh = 0;
      const dk = sstep((u - 12) / 3);                  // 118 → 121 : onde sombre
      if (u > 12 && u < 15) sh = 10 * Math.exp(-(u - 12) * 1.2);
      ctx.save(); ctx.translate(Math.sin(t * 59) * sh, Math.cos(t * 67) * sh);
      const c = drawPlate(ctx, I.skyfallTrio, 0.5, 0.58, kf(u, [[0, 1.45], [12, 1.05]]));
      const cx = c.X(0.50), cy = c.Y(0.62);
      glow(ctx, cx, cy, 380 * c.s, '255,235,170', 0.45 + 0.2 * Math.sin(u * 3));
      starBurst(ctx, cx, cy, 440 * c.s, 0.4 * (1 - dk), 10, u * 0.25);
      ring(ctx, cx, cy, ((u * 0.5) % 1) * 600, 3, '255,246,210', 0.5 * (1 - dk));
      speedLines(ctx, t, 60, W / 2, H / 2, '255,255,255', 0.5 * (1 - dk), 250);
      motes(ctx, t, 70, 91, '255,246,210', 0.8, 1.2, true);
      ctx.restore();
      if (dk > 0) {
        const k = sstep((u - 12) / 2.2);
        const rr = k * 1100;
        ctx.save();
        const g = ctx.createRadialGradient(W / 2, H / 2, Math.max(1, rr * 0.55), W / 2, H / 2, Math.max(2, rr));
        g.addColorStop(0, 'rgba(20,0,40,0.92)'); g.addColorStop(0.85, 'rgba(60,10,90,0.9)'); g.addColorStop(1, 'rgba(60,10,90,0)');
        ctx.fillStyle = g; ctx.fillRect(0, 0, W, H);
        ctx.restore();
        ring(ctx, W / 2, H / 2, rr, 18, '190,90,255', 0.9 * (1 - sstep((u - 14.2) / 1.8)));
        ctx.save(); ctx.fillStyle = `rgba(8,0,22,${(0.95 * sstep((u - 13.6) / 1.8)).toFixed(3)})`; ctx.fillRect(0, 0, W, H); ctx.restore();
        flash(ctx, 0.8 * Math.exp(-Math.abs(u - 12) * 7), '210,160,255');
      }
    }
    function barrierSphere(ctx, t, x, y, r, a, crop) {
      if (a <= 0.003) return;
      ctx.save(); ctx.globalAlpha = a;
      ctx.beginPath(); ctx.arc(x, y, r, 0, TAU); ctx.clip();
      const s = I.skyfallTrio, cw = r * 2.0;
      ctx.drawImage(s, crop[0] * s.width - cw * 0.5 / 1.1, crop[1] * s.height - cw * 0.5 / 1.1, cw / 1.1 * 1.0, cw / 1.1 * 1.0, x - r, y - r, r * 2, r * 2);
      const g = ctx.createRadialGradient(x - r * 0.3, y - r * 0.35, r * 0.1, x, y, r);
      g.addColorStop(0, 'rgba(210,255,255,0.35)'); g.addColorStop(0.75, 'rgba(70,200,255,0.28)'); g.addColorStop(1, 'rgba(120,255,255,0.75)');
      ctx.fillStyle = g; ctx.fillRect(x - r, y - r, r * 2, r * 2);
      ctx.strokeStyle = 'rgba(210,255,255,0.55)'; ctx.lineWidth = 1.5;
      const hr = r / 4.2;
      for (let row = -6; row <= 6; row++) for (let col = -6; col <= 6; col++) {
        const hx = x + col * hr * 1.73 + (row & 1 ? hr * 0.865 : 0), hy = y + row * hr * 1.5;
        if (Math.hypot(hx - x, hy - y) > r + hr) continue;
        ctx.beginPath(); for (let k = 0; k < 6; k++) { const an = Math.PI / 6 + k * Math.PI / 3; const px = hx + Math.cos(an) * hr, py = hy + Math.sin(an) * hr; if (k) ctx.lineTo(px, py); else ctx.moveTo(px, py); } ctx.closePath(); ctx.stroke();
      }
      ctx.restore();
      ctx.save(); ctx.globalAlpha = a; ctx.strokeStyle = 'rgba(190,255,255,0.95)'; ctx.lineWidth = 5; ctx.beginPath(); ctx.arc(x, y, r, 0, TAU); ctx.stroke(); ctx.restore();
      glow(ctx, x, y, r * 1.6, '120,240,255', 0.35 * a);
    }
    function seg_barrier(ctx, t) {
      const u = t - 122;
      drawPlate(ctx, I.skyfallTrio, 0.5, 0.58, 1.05);
      ctx.fillStyle = 'rgba(14,4,36,0.93)'; ctx.fillRect(0, 0, W, H);
      motes(ctx, t, 90, 101, '170,120,255', 0.7, 0.8, true);
      // Évoli tombe dans l'abysse
      const ey = kf(u, [[0, H * 0.62], [9.5, H * 1.15]]), ea = 1 - sstep((u - 7.5) / 2.4);
      const k1 = sstep((u - 1.5) / 1.6), up = sstep((u - 4.2) / 4.5);
      glow(ctx, W * 0.5, ey, 420, '120,230,255', 0.2 * ea);
      sprite(ctx, I.evoliCutout, W * 0.5, ey, 460, -0.35 + Math.sin(u) * 0.05, ea);
      barrierSphere(ctx, t, W * 0.27, lerp(H * 0.58, -140, up), 150, k1, [0.43, 0.40]);
      barrierSphere(ctx, t, W * 0.73, lerp(H * 0.58, -140, up), 150, k1, [0.58, 0.78]);
      if (u < 4) { ring(ctx, W * 0.27, H * 0.58, (u - 1.5) * 260, 5, '160,250,255', 0.8 * (1 - clamp((u - 1.5) / 2.5, 0, 1))); ring(ctx, W * 0.73, H * 0.58, (u - 1.5) * 260, 5, '160,250,255', 0.8 * (1 - clamp((u - 1.5) / 2.5, 0, 1))); }
      for (let i = 0; i < 18; i++) { // larmes lumineuses
        const ph = ((u * 0.4 + rnd(i, 3)) % 1); glow(ctx, W * 0.5 + (rnd(i, 4) - 0.5) * 240, ey - 60 - ph * 260, 14, '190,255,255', 0.7 * (1 - ph) * ea);
      }
    }

    // ---------- Final ----------
    function seg_abyssFloor(ctx, t) {
      const u = t - 132;
      drawPlate(ctx, I.abyss, 0.5, 0.7, kf(u, [[0, 1.2], [7, 1.6]]));
      grade(ctx, 'rgb(24,44,96)', 'multiply');
      const ra = sstep((u - 1.5) / 4);
      godRays(ctx, t, 0.9 * ra, W * 0.52, -30, 7, 0.5 + 0.7 * ra, H * 1.2);
      glow(ctx, W * 0.5, -20, 900, '255,246,210', 0.55 * ra);
      const ey = H * 0.78;
      glow(ctx, W * 0.5, ey, 300, '130,230,255', 0.25 + 0.2 * ra);
      sprite(ctx, I.evoliCutout, W * 0.5, ey + Math.sin(u * 0.8) * 5, 520, -0.04, 1);
      glow(ctx, W * 0.5 + 84, ey - 4, 90, '170,245,255', 0.5 + 0.3 * ra);
      bubbles(ctx, t, 34, 111, 0.5, 0.9); motes(ctx, t, 60, 112, '255,244,190', 0.8 * ra, 0.7, true);
    }
    function drawEye(ctx, u) {
      ctx.fillStyle = '#02040c'; ctx.fillRect(0, 0, W, H);
      const cx = W / 2, cy = H / 2;
      const open = sstep(u / 3.0);
      const ry = lerp(6, 250, open), rx = 560;
      const zoom = kf(u, [[3.6, 1.0], [5.5, 2.75]]);
      ctx.save(); ctx.translate(cx, cy); ctx.scale(zoom, zoom); ctx.translate(-cx, -cy);
      ctx.save(); ctx.beginPath(); ctx.ellipse(cx, cy, rx, ry, 0, 0, TAU); ctx.clip();
      const sg = ctx.createRadialGradient(cx, cy, 80, cx, cy, rx);
      sg.addColorStop(0, '#fff4ee'); sg.addColorStop(0.6, '#f6dcd2'); sg.addColorStop(1, '#b88a86');
      ctx.fillStyle = sg; ctx.fillRect(0, 0, W, H);
      const R = 245;
      const ig = ctx.createRadialGradient(cx, cy, 10, cx, cy, R);
      ig.addColorStop(0, '#1a0c08'); ig.addColorStop(0.55, '#5a2a14'); ig.addColorStop(0.9, '#8a4a22'); ig.addColorStop(1, '#2a1208');
      ctx.fillStyle = ig; ctx.beginPath(); ctx.arc(cx, cy, R, 0, TAU); ctx.fill();
      ctx.save(); ctx.beginPath(); ctx.arc(cx, cy, R - 6, 0, TAU); ctx.clip();
      const p = I.pawGrab, pw = (R - 6) * 2, ph = pw * p.height / p.width;
      ctx.globalAlpha = 0.96; ctx.drawImage(p, cx - pw / 2, cy - ph / 2, pw, ph); ctx.globalAlpha = 1;
      ctx.restore();
      ctx.fillStyle = 'rgba(255,255,255,0.9)'; ctx.beginPath(); ctx.ellipse(cx - 92, cy - 108, 30, 20, -0.5, 0, TAU); ctx.fill();
      ctx.beginPath(); ctx.arc(cx + 80, cy + 120, 10, 0, TAU); ctx.fill();
      ctx.restore();
      ctx.strokeStyle = '#2a1008'; ctx.lineWidth = 12; ctx.beginPath(); ctx.ellipse(cx, cy, rx, ry, 0, Math.PI * 1.04, Math.PI * 1.96); ctx.stroke();
      ctx.lineWidth = 6; ctx.beginPath(); ctx.ellipse(cx, cy, rx, ry, 0, 0.06, Math.PI - 0.06); ctx.stroke();
      ctx.restore();
      glow(ctx, cx, cy, 600, '255,246,210', 0.25 * open);
    }
    function seg_eye(ctx, t) {
      const u = t - 139;
      drawEye(ctx, u);
      motes(ctx, t, 40, 121, '255,246,210', 0.7, 0.3, true);
    }
    function seg_grab(ctx, t) {
      const u = t - 144.5;
      const c = drawPlate(ctx, I.pawGrab, kf(u, [[0, 0.5], [3.5, 0.46]]), kf(u, [[0, 0.5], [3.5, 0.66]]), kf(u, [[0, 1.0], [3.5, 1.55]]));
      godRays(ctx, t, 0.5, W * 0.62, -30, 7, 0.8, H * 1.2);
      const gx = c.X(0.47), gy = c.Y(0.67);
      const k = sstep((u - 1.2) / 2.3);
      glow(ctx, gx, gy, 380 * c.s, '255,246,210', 0.25 + 0.55 * k);
      starBurst(ctx, gx, gy, 480 * c.s, 0.5 * k, 10, t * 0.4);
      bubbles(ctx, t, 36, 131, 0.55, 1.4); motes(ctx, t, 70, 132, '255,246,200', 0.9, 0.9, true);
      flash(ctx, sstep((u - 2.6) / 0.9));
    }

    // ---------- Écran-titre ----------
    function wingAngle(dtLogo, nowSec, flapStart) {
      let d = 0;
      if (dtLogo >= 0 && dtLogo < 3.4) d += 8.2 * Math.exp(-1.55 * dtLogo) * Math.cos(TAU * 2.25 * dtLogo);
      else if (dtLogo >= 3.4) d += 0.6 * Math.sin((dtLogo - 3.4) * 1.9);
      const dm = nowSec - (flapStart == null ? -99 : flapStart);
      if (dm >= 0 && dm < 2.4) d += 8.8 * Math.exp(-1.75 * dm) * Math.sin(TAU * 2.6 * dm);
      return d;
    }
    function drawTitle(ctx, tl, theme, nowSec, flapStart) {
      const atlas = theme === 'nuit' ? I.nightSeaAtlas : I.daySeaAtlas;
      const pose = Math.floor(nowSec * 12) % 24;
      ctx.save(); ctx.imageSmoothingEnabled = false;
      ctx.drawImage(atlas, (pose % 6) * 320, Math.floor(pose / 6) * 240, 320, 240, 0, -120, W, 960);
      ctx.restore();
      const cx = W / 2, cy = H / 2;
      let out = 0;
      if (tl >= 0.04 && tl <= 0.6) {
        const fu = (tl - 0.04) / 0.56, env = Math.sin(Math.PI * clamp(fu, 0, 1));
        ctx.save(); ctx.globalCompositeOperation = 'lighter';
        const hl = W * (0.2 + 0.32 * fu);
        const g = ctx.createRadialGradient(cx, cy, 2, cx, cy, hl);
        g.addColorStop(0, `rgba(255,255,245,${(0.95 * env).toFixed(3)})`); g.addColorStop(0.4, `rgba(254,240,138,${(0.7 * env).toFixed(3)})`); g.addColorStop(1, 'rgba(254,240,138,0)');
        ctx.fillStyle = g; ctx.beginPath(); ctx.ellipse(cx, cy, hl, Math.max(6, 28 * env), 0, 0, TAU); ctx.fill(); ctx.restore();
      }
      if (tl >= 0.18) {
        const dt = tl - 0.18;
        let scale = 1, alpha = 1, wf = 0;
        if (dt < 0.6) {
          const uu = dt / 0.6, c1 = 1.70158, c3 = c1 + 1, e = 1 + c3 * Math.pow(uu - 1, 3) + c1 * Math.pow(uu - 1, 2);
          scale = 1.4 + (1 - 1.4) * e; alpha = Math.min(1, dt / 0.18); wf = Math.max(0, 1 - dt / 0.35);
        }
        const deg = wingAngle(dt, nowSec, flapStart), rad = deg * Math.PI / 180;
        out = deg;
        const k = 580 / 872, pl = [274 * k, 335 * k], pr = [598 * k, 335 * k];
        rigX.clearRect(0, 0, 580, 418);
        rigX.save(); rigX.translate(pl[0], pl[1]); rigX.rotate(rad); rigX.drawImage(I.rigLW, -pl[0], -pl[1]); rigX.restore();
        rigX.save(); rigX.translate(pr[0], pr[1]); rigX.rotate(-rad); rigX.drawImage(I.rigRW, -pr[0], -pr[1]); rigX.restore();
        rigX.drawImage(I.rigCore, 0, 0);
        tintX.clearRect(0, 0, 580, 418); tintX.globalCompositeOperation = 'source-over'; tintX.drawImage(rigC, 0, 0);
        if (wf > 0.01) { tintX.globalCompositeOperation = 'source-atop'; tintX.fillStyle = `rgba(255,255,255,${wf})`; tintX.fillRect(0, 0, 580, 418); }
        const bw = 560 * scale, bh = bw * 418 / 580;
        glow(ctx, cx, cy, 420 * scale, '255,236,160', 0.18 + 0.1 * Math.sin(nowSec * 2));
        ctx.save(); ctx.globalAlpha = alpha; ctx.imageSmoothingEnabled = true; ctx.drawImage(tintC, cx - bw / 2, cy - bh / 2, bw, bh); ctx.restore();
      }
      if (tl > 1.25) {
        const bl = 0.45 + 0.55 * (0.5 + 0.5 * Math.sin(nowSec * 5));
        ctx.save(); ctx.imageSmoothingEnabled = false; ctx.globalAlpha = bl;
        ctx.drawImage(I.enterUI, (W - 74 * 4) / 2, 590, 74 * 4, 11 * 4); ctx.restore();
      }
      return out;
    }

    const SEGS = [
      { t0: 0, t1: 5.5, fn: seg_abyssIntro, xf: 0 },
      { t0: 5.5, t1: 10, fn: seg_shore1, xf: 0.5 },
      { t0: 10, t1: 13.5, fn: seg_starClose, xf: 0.5 },
      { t0: 13.5, t1: 19, fn: seg_rioluReach, xf: 0.5 },
      { t0: 19, t1: 24, fn: seg_starGlow, xf: 0.5 },
      { t0: 24, t1: 46, fn: seg_evoliDrift, xf: 1.2 },
      { t0: 46, t1: 52.5, fn: seg_plunge, xf: 0.7 },
      { t0: 52.5, t1: 58, fn: seg_sink, xf: 0.6 },
      { t0: 58, t1: 62, fn: seg_evoliStar, xf: 0.6 },
      { t0: 62, t1: 68, fn: seg_pillarsIgnite, xf: 0.9 },
      { t0: 68, t1: 76, fn: seg_pillarsPush, xf: 0.3 },
      { t0: 76, t1: 106, fn: seg_clash, xf: 0 },
      { t0: 106, t1: 122, fn: seg_skyfall, xf: 0 },
      { t0: 122, t1: 132, fn: seg_barrier, xf: 0.8 },
      { t0: 132, t1: 139, fn: seg_abyssFloor, xf: 1.0 },
      { t0: 139, t1: 144.5, fn: seg_eye, xf: 0.8 },
      { t0: 144.5, t1: TITLE_T, fn: seg_grab, xf: 0.6 },
    ];

    function caption(ctx, t) {
      let ch = null;
      for (const c of CHAPTERS) if (t >= c.t) ch = c;
      if (!ch) return;
      const d = t - ch.t;
      let a = sstep(d / 0.8) * (1 - sstep((d - 3.6) / 0.8));
      if (ch.t === 0) a *= sstep((d - 1.2) / 0.6);
      if (a <= 0.01) return;
      ctx.save(); ctx.globalAlpha = a;
      ctx.font = '600 24px "Trebuchet MS", system-ui, sans-serif'; ctx.textBaseline = 'alphabetic';
      ctx.shadowColor = 'rgba(0,0,0,0.85)'; ctx.shadowBlur = 8;
      ctx.fillStyle = '#fde68a'; ctx.fillText(ch.name, 44, H - 54);
      ctx.fillStyle = 'rgba(253,230,138,0.85)'; ctx.fillRect(44, H - 44, 90 * a, 2);
      ctx.restore();
    }
    function introCard(ctx, t) {
      if (t < 1.5 || t > 7.2) return;
      const a = sstep((t - 1.5) / 1.2) * (1 - sstep((t - 5.6) / 1.4));
      ctx.save(); ctx.globalAlpha = a; ctx.textAlign = 'center';
      ctx.shadowColor = 'rgba(0,30,60,0.9)'; ctx.shadowBlur = 14;
      ctx.font = '700 46px "Trebuchet MS", system-ui, sans-serif'; ctx.fillStyle = '#fff6d0';
      ctx.fillText('Pokémon Mystery Dungeon', W / 2, 170);
      ctx.font = '700 64px "Trebuchet MS", system-ui, sans-serif'; ctx.fillStyle = '#fbbf24'; ctx.fillText('DESTINY', W / 2, 240);
      ctx.restore();
    }

    function render(ctx, t, opts) {
      opts = opts || {};
      t = clamp(t, 0, D);
      let wing = 0;
      ctx.save(); ctx.imageSmoothingEnabled = true; ctx.globalAlpha = 1; ctx.globalCompositeOperation = 'source-over';
      ctx.fillStyle = '#000'; ctx.fillRect(0, 0, W, H);
      if (t >= TITLE_T) {
        const tl = t - TITLE_T;
        wing = drawTitle(ctx, tl, opts.theme || 'jour', opts.nowSec || 0, opts.flapStart);
        flash(ctx, 1 - sstep(tl / 1.3));
        vignette(ctx, 0.35);
      } else {
        let i = SEGS.findIndex((s) => t >= s.t0 && t < s.t1); if (i < 0) i = SEGS.length - 1;
        const s = SEGS[i];
        if (s.xf > 0 && i > 0 && t < s.t0 + s.xf) {
          SEGS[i - 1].fn(ctx, t);
          sctx.save(); sctx.globalAlpha = 1; sctx.globalCompositeOperation = 'source-over'; sctx.clearRect(0, 0, W, H);
          s.fn(sctx, t); sctx.restore();
          ctx.globalAlpha = sstep((t - s.t0) / s.xf); ctx.drawImage(scr, 0, 0); ctx.globalAlpha = 1;
        } else s.fn(ctx, t);
        vignette(ctx, 0.55);
        introCard(ctx, t);
        caption(ctx, t);
        flash(ctx, 1 - sstep(t / 1.4), '0,0,0');
      }
      ctx.restore();
      return { wing };
    }

    function renderTitleMode(ctx, tl, theme, nowSec, flapStart) {
      ctx.save(); ctx.fillStyle = '#000'; ctx.fillRect(0, 0, W, H);
      const wing = drawTitle(ctx, tl, theme, nowSec, flapStart);
      vignette(ctx, 0.3); ctx.restore();
      return { wing };
    }
    return { render, renderTitleMode, W, H, D, CHAPTERS, TITLE_T, IMPACTS };
  }
  root.PMDDestinyCinema = { create, W, H, D, CHAPTERS, TITLE_T, IMPACTS, BEAT };
})(typeof window !== 'undefined' ? window : globalThis);
