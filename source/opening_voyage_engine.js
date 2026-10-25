/* Cinématique d'Opening « PMD : Destiny » — version VOYAGE : décors MULTICALQUES générés en parallaxe (océan → surface → prairie de roses → route de forêt, façon PMD Sky) + sprites PMDO.
   1280×720 · 60 FPS · durée EXACTE 153,0 s (02:33) = vidéo de référence « Simple and Clean -Ray of Hope MIX- ».
   • Acteurs = vrais sprites PMDCollab (AnimData.xml : durées image par image, 8 directions, ombres corrompues).
   • Décors = 10 calques générés (océan, fond, surface, plage, prairie, nuages, forêt ×3, premier plan) défilant à des vitesses différentes.
   • Caméra : grues, travellings, orbites (roulis), push-in, parallaxe, profondeur de champ, tremblements, hit-stop.
   Fonction pure du temps : render(ctx, t, opts). Aucune dépendance DOM. */
(function (root) {
  'use strict';
  const W = 1280, H = 720, D = 153.0, BEAT = 60 / 128, TAU = Math.PI * 2, TITLE_T = 148.0;
  const clamp = (x, a, b) => Math.min(b, Math.max(a, x));
  const sstep = (x) => { x = clamp(x, 0, 1); return x * x * (3 - 2 * x); };
  const lerp = (a, b, u) => a + (b - a) * u;
  const rnd = (i, s) => { const x = Math.sin(i * 127.1 + (s || 0) * 311.7) * 43758.5453; return x - Math.floor(x); };

  const CHAPTERS = [
    { t: 0.0, name: '', short: 'I' },
    { t: 31.0, name: '', short: 'II' },
    { t: 58.0, name: '', short: 'III' },
    { t: 100.0, name: '', short: 'IV' },
    { t: 128.0, name: '', short: 'V' },
  ];
  const IMPACTS = [];
  const HITSTOP = 0.075;

  // ---------- Interpolation ----------
  function lin(keys, t, i0) { // clés [t, a, b, c...] interpolation linéaire (ou douce si key.e)
    if (!keys || !keys.length) return null;
    if (t <= keys[0][0]) return keys[0].slice(1);
    for (let i = 0; i < keys.length - 1; i++) {
      const a = keys[i], b = keys[i + 1];
      if (t < b[0]) {
        let u = (t - a[0]) / (b[0] - a[0]); if (a.e) u = sstep(u);
        const out = []; for (let k = 1; k < a.length; k++) out.push(lerp(a[k], b[k] == null ? a[k] : b[k], u)); return out;
      }
    }
    return keys[keys.length - 1].slice(1);
  }
  function cr(keys, t) { // Catmull-Rom (caméra) — mouvements continus, arrêts doux aux extrémités
    const n = keys.length;
    if (t <= keys[0][0]) return keys[0].slice(1);
    if (t >= keys[n - 1][0]) return keys[n - 1].slice(1);
    let i = 0; while (i < n - 2 && t >= keys[i + 1][0]) i++;
    const k0 = keys[Math.max(0, i - 1)], k1 = keys[i], k2 = keys[i + 1], k3 = keys[Math.min(n - 1, i + 2)];
    const u = (t - k1[0]) / (k2[0] - k1[0]), u2 = u * u, u3 = u2 * u;
    const out = [];
    for (let c = 1; c < k1.length; c++) {
      const p0 = k0[c], p1 = k1[c], p2 = k2[c], p3 = k3[c];
      const m1 = (p2 - p0) * 0.5 * (i === 0 ? 0.0 : 1), m2 = (p3 - p1) * 0.5 * (i === n - 2 ? 0.0 : 1);
      out.push((2 * u3 - 3 * u2 + 1) * p1 + (u3 - 2 * u2 + u) * m1 + (-2 * u3 + 3 * u2) * p2 + (u3 - u2) * m2);
    }
    return out;
  }
  const E = (arr) => { arr.e = true; return arr; }; // clé « douce »

  function dirFromVec(dx, dy) {
    const a = Math.atan2(dy, dx) * 180 / Math.PI;
    return ((Math.round((((90 - a) % 360) + 360) % 360 / 45)) % 8 + 8) % 8;
  }

  function create(EV) {
    const I = EV.imgs, SH = EV.sheets, CAT = EV.catalog.pokemon, mk = EV.mk;
    const scr = mk(W, H), sctx = scr.getContext('2d');
    const RW = 872, RH = 629; // logo complet pleine définition : fond de rattrapage / ailes / corps (découpe propre par segmentation)
    const rigC = mk(RW, RH), rigX = rigC.getContext('2d');
    const mini = mk(256, 144), miniX = mini.getContext('2d');
    const MW = 576, MH = 320;

    // ---------- Primitives écran ----------
    const FXC = (EV.catalog && EV.catalog.vfx) || {};
    // ---- matérialisation : apparition tramée (Bayer 4×4) + points de lumière convergents ----
    const FXT = mk(128, 128), FXTX = FXT.getContext('2d'), BAYM = [[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]], BPAT = [];
    function bayerPat(L) { if (BPAT[L]) return BPAT[L]; const tc = mk(4, 4), tx = tc.getContext('2d'); tx.fillStyle = '#fff'; for (let y = 0; y < 4; y++) for (let x = 0; x < 4; x++) if (BAYM[y][x] < L) tx.fillRect(x, y, 1, 1); return (BPAT[L] = FXTX.createPattern(tc, 'repeat')); }
    function dith(ctx, im, sx, sy, sw, sh, dx, dy, dw, dh, k, tint) { // k 0→1 : l'image se matérialise pixel par pixel ; tint = teinte additionnelle
      FXTX.save(); FXTX.setTransform(1, 0, 0, 1, 0, 0); FXTX.globalAlpha = 1; FXTX.globalCompositeOperation = 'source-over'; FXTX.clearRect(0, 0, 128, 128);
      FXTX.drawImage(im, sx, sy, sw, sh, 0, 0, sw, sh);
      const L = Math.round(clamp(k, 0, 1) * 16);
      if (L < 16) { FXTX.globalCompositeOperation = 'destination-in'; FXTX.fillStyle = bayerPat(L); FXTX.fillRect(0, 0, sw, sh); }
      if (tint) { FXTX.globalCompositeOperation = 'source-atop'; FXTX.fillStyle = 'rgba(' + tint + ',0.6)'; FXTX.fillRect(0, 0, sw, sh); }
      FXTX.restore();
      ctx.drawImage(FXT, 0, 0, sw, sh, dx, dy, dw, dh);
    }
    // Sprite d'effet animé (planche d'images générée) : idx = numéro d'image, o.bottom = ancrage bas, o.add = addition, o.mat = matérialisation 0→1, o.tint = teinte
    function fx(ctx, name, idx, x, y, s, a, o) {
      const m = FXC[name], im = I['fx_' + name]; if (!m || !im || !im.width) return;
      o = o || {}; const n = m.n; let f = Math.floor(idx); f = m.loop === false ? clamp(f, 0, n - 1) : ((f % n) + n) % n;
      ctx.save(); ctx.imageSmoothingEnabled = false; if (a != null && a < 1) ctx.globalAlpha = Math.max(0, a); if (o.add) ctx.globalCompositeOperation = 'lighter';
      ctx.translate(x, y); if (o.rot) ctx.rotate(o.rot); const sc = s || 1; ctx.scale(sc, sc);
      const dx = -m.fw / 2, dy = o.bottom ? -m.fh : -m.fh / 2;
      if ((o.mat != null && o.mat < 1) || o.tint) dith(ctx, im, f * m.fw, 0, m.fw, m.fh, dx, dy, m.fw, m.fh, o.mat == null ? 1 : o.mat, o.tint);
      else ctx.drawImage(im, f * m.fw, 0, m.fw, m.fh, dx, dy, m.fw, m.fh);
      ctx.restore();
    }
    function matBurst(ctx, x, y, k, tint, s) { // points de lumière qui convergent puis éclair en croix
      if (k <= 0 || k >= 1) return; const sc = s || 0.8;
      fx(ctx, 'mat', k * 8, x, y, sc, 1, { tint: tint, add: true }); glow(ctx, x, y, 22 * sc, tint || '255,255,255', 0.5 * Math.sin(Math.PI * k));
    }
    function hitFx(ctx, ix, iy, d, ti, tint, s) { const f = d / 0.4, sc = s || 1; fx(ctx, 'hit', f * 8, ix, iy, 0.85 * sc, 1, { tint: tint }); fx(ctx, 'slash', f * 6, ix + 4, iy - 2, 0.9 * sc, 1, { rot: (rnd(ti, 3) - 0.5) * 3.0, tint: tint }); }
    // ---- attaques Pokémon : Ball'Ombre, Aurasphère, Météores, Bulles d'O — charge matérialisée → vol → impact ----
    const KIND = { shadowball: { fps: 16, s: 0.55, tint: '170,60,255', glow: '190,60,255' }, aurasphere: { fps: 16, s: 0.5, tint: '90,230,255', glow: '120,235,255' }, swift: { sheet: 'swiftstar', fps: 18, s: 0.5, tint: '255,220,90', glow: '255,230,120' }, bubble: { sheet: 'bubble', fps: 8, s: 0.35, tint: '150,230,255', glow: '150,230,255' } };
    function boltEnd(A) { return A.t0 + (A.charge || 0.55) + (A.fly || 0.45); }
    function covered(ti) { return BOLTS.some((A) => Math.abs(boltEnd(A) - ti) < 0.06); }
    function bolt(ctx, t, A) {
      const K = KIND[A.kind], u = t - A.t0, ch = A.charge || 0.55, fl = A.fly || 0.45, n = A.n || 1, sS = (A.s || 1) * K.s, st = 0.045;
      if (u < 0 || u > ch + fl + (n - 1) * st + 0.5) return;
      const x0 = A.from[0], y0 = A.from[1], x1 = A.to[0], y1 = A.to[1], dx = x1 - x0, dy = y1 - y0, L = Math.hypot(dx, dy) || 1, nx = -dy / L, ny = dx / L, sheet = K.sheet || A.kind;
      for (let i = 0; i < n; i++) {
        const ui = u - (n > 1 ? i * st : 0); if (ui < 0) continue; const spread = n > 1 ? (i - (n - 1) / 2) * 7 : 0;
        if (ui < ch) { // matérialisation au point de départ
          const k = ui / ch;
          if (i === 0) matBurst(ctx, x0, y0, k, K.tint, A.kind === 'bubble' ? 0.45 : 0.9 * (A.s || 1));
          glow(ctx, x0, y0, 30 * sS, K.glow, 0.5 * k);
          fx(ctx, sheet, A.kind === 'bubble' ? Math.floor(t * 8 + i) % 6 : t * K.fps + i, x0 + nx * spread * 0.25, y0 + ny * spread * 0.25, sS * (0.3 + 0.7 * k), 1, { mat: k });
        } else if (ui < ch + fl) {
          const k = (ui - ch) / fl, e = Math.pow(k, 1.5);
          for (let j = 3; j >= 1; j--) { const kj = Math.max(0, k - j * 0.06), ej = Math.pow(kj, 1.5); if (kj <= 0) continue; fx(ctx, sheet, A.kind === 'bubble' ? Math.floor(t * 8 + i) % 6 : t * K.fps + i, lerp(x0, x1, ej) + nx * spread * ej, lerp(y0, y1, ej) + ny * spread * ej, sS * (1 - j * 0.1), 0.2 * (4 - j) / 3, { add: true }); }
          const px = lerp(x0, x1, e) + nx * spread * e, py = lerp(y0, y1, e) + ny * spread * e - Math.sin(e * Math.PI) * (A.arc || 0);
          glow(ctx, px, py, 34 * sS, K.glow, 0.55);
          fx(ctx, sheet, A.kind === 'bubble' ? (k > 0.88 ? 6 + Math.min(3, Math.floor((k - 0.88) / 0.12 * 4)) : Math.floor(t * 8 + i) % 6) : t * K.fps + i, px, py, sS, 1);
        }
      }
      const d = u - ch - fl - (n - 1) * st;
      if (d >= 0 && d < 0.4) { const big = A.kind === 'aurasphere' || A.kind === 'shadowball'; hitFx(ctx, x1, y1, d, A.t0 * 7.3, K.tint, (A.s || 1) * (big ? 1 : 0.7)); glow(ctx, x1, y1, 38 * (A.s || 1), K.glow, 0.8 * (1 - d / 0.4)); ring(ctx, x1, y1 + 8, d * 90, 1.2, K.glow, 0.8 * (1 - d / 0.4), 0.4); }
    }
    const BOLTS = [
      // 4b : Évoli (Météores) contre les ombres de Riolu (Ball'Ombre) et de Tiplouf (Bulles d'O)
      { kind: 'swift', t0: 78.2, from: [274, 172], to: [322, 160], n: 5, charge: 0.45, fly: 0.55 },
      { kind: 'shadowball', t0: 80.0, from: [324, 154], to: [266, 180] },
      { kind: 'shadowball', t0: 82.4, from: [318, 160], to: [266, 182], s: 1.1 },
      { kind: 'bubble', t0: 84.6, from: [318, 186], to: [250, 186], n: 7, charge: 0.45, fly: 0.55 },
      { kind: 'shadowball', t0: 86.4, from: [296, 178], to: [244, 186] },
      // 4c : Lucario (Aurasphère) intervient
      { kind: 'bubble', t0: 89.4, from: [276, 188], to: [238, 186], n: 6, charge: 0.45, fly: 0.55 },
      { kind: 'shadowball', t0: 90.0, from: [270, 184], to: [238, 186] },
      { kind: 'aurasphere', t0: 91.6, from: [274, 170], to: [256, 184] },
      { kind: 'aurasphere', t0: 93.2, from: [268, 174], to: [300, 194] },
      { kind: 'aurasphere', t0: 95.0, from: [276, 176], to: [312, 182], s: 1.4 },
      // 4d : Dark Rai (Ball'Ombre) contre Lucario (Aurasphère) et Évoli (Météores)
      { kind: 'shadowball', t0: 97.2, from: [400, 150], to: [290, 176], s: 1.3 },
      { kind: 'aurasphere', t0: 99.4, from: [294, 174], to: [342, 166], s: 1.2 },
      { kind: 'swift', t0: 101.45, from: [266, 176], to: [322, 170], n: 6, charge: 0.3, fly: 0.45 },
      { kind: 'shadowball', t0: 103.0, from: [340, 160], to: [290, 176], s: 1.7 },
    ];
    function fightFx(ctx, t) { for (const A of BOLTS) bolt(ctx, t, A); }
    function glow(ctx, x, y, r, rgb, a) {
      if (a <= 0.003) return;
      ctx.save(); ctx.globalCompositeOperation = 'lighter';
      const g = ctx.createRadialGradient(x, y, 0, x, y, r);
      g.addColorStop(0, `rgba(${rgb},${clamp(a, 0, 1).toFixed(3)})`);
      g.addColorStop(0.45, `rgba(${rgb},${(clamp(a, 0, 1) * 0.35).toFixed(3)})`);
      g.addColorStop(1, `rgba(${rgb},0)`);
      ctx.fillStyle = g; ctx.fillRect(x - r, y - r, r * 2, r * 2); ctx.restore();
    }
    function flash(ctx, a, rgb) { if (a <= 0.003) return; ctx.fillStyle = `rgba(${rgb || '255,255,255'},${clamp(a, 0, 1).toFixed(3)})`; ctx.fillRect(0, 0, W, H); }
    function ring(ctx, x, y, r, w, rgb, a, sy) {
      if (a <= 0.003) return;
      ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.translate(x, y); ctx.scale(1, sy || 1);
      ctx.strokeStyle = `rgba(${rgb},${clamp(a, 0, 1).toFixed(3)})`; ctx.lineWidth = Math.max(0.3, w);
      ctx.beginPath(); ctx.arc(0, 0, Math.max(0.5, r), 0, TAU); ctx.stroke(); ctx.restore();
    }
    function starBurst(ctx, x, y, r, a, rays, rot) {
      if (a <= 0.003) return;
      ctx.save(); ctx.translate(x, y); ctx.rotate(rot || 0); ctx.globalCompositeOperation = 'lighter';
      for (let i = 0; i < rays; i++) {
        ctx.rotate(TAU / rays);
        const g = ctx.createLinearGradient(0, 0, r, 0);
        g.addColorStop(0, `rgba(255,255,255,${clamp(a, 0, 1).toFixed(3)})`); g.addColorStop(1, 'rgba(255,230,160,0)');
        ctx.fillStyle = g; ctx.beginPath(); ctx.moveTo(0, -r * 0.03); ctx.lineTo(r, 0); ctx.lineTo(0, r * 0.03); ctx.closePath(); ctx.fill();
      }
      ctx.restore();
    }
    function godRays(ctx, t, a, ox, oy, n, spread, len, rgb) {
      ctx.save(); ctx.globalCompositeOperation = 'lighter';
      for (let i = 0; i < n; i++) {
        const ang = Math.PI / 2 + (-0.5 + i / (n - 1)) * spread + Math.sin(t * 0.3 + i) * 0.035;
        const w = 22 + rnd(i, 3) * 80, dx = Math.cos(ang), dy = Math.sin(ang), x2 = ox + dx * len, y2 = oy + dy * len;
        const g = ctx.createLinearGradient(ox, oy, x2, y2);
        const aa = a * (0.45 + 0.55 * Math.sin(t * 0.8 + i * 1.7) ** 2) * 0.55;
        g.addColorStop(0, `rgba(${rgb || '255,246,206'},${aa.toFixed(3)})`); g.addColorStop(1, `rgba(${rgb || '255,246,206'},0)`);
        ctx.fillStyle = g; ctx.beginPath(); ctx.moveTo(ox - 5, oy); ctx.lineTo(ox + 5, oy); ctx.lineTo(x2 + w, y2); ctx.lineTo(x2 - w, y2); ctx.closePath(); ctx.fill();
      }
      ctx.restore();
    }
    function speedLines(ctx, t, n, cx, cy, rgb, alpha, inner, dirAng) {
      ctx.save(); ctx.globalCompositeOperation = 'lighter';
      for (let i = 0; i < n; i++) {
        const ang = dirAng == null ? rnd(i, 7) * TAU : dirAng + (rnd(i, 7) - 0.5) * 0.5;
        const ph = (t * (1.6 + rnd(i, 8) * 2.2) + rnd(i, 9)) % 1;
        const r0 = (inner || 180) + ph * 700, r1 = r0 + 70 + rnd(i, 10) * 260 * ph;
        ctx.strokeStyle = `rgba(${rgb},${(alpha * Math.sin(ph * Math.PI)).toFixed(3)})`; ctx.lineWidth = 1 + rnd(i, 11) * 2.4;
        ctx.beginPath(); ctx.moveTo(cx + Math.cos(ang) * r0, cy + Math.sin(ang) * r0); ctx.lineTo(cx + Math.cos(ang) * r1, cy + Math.sin(ang) * r1); ctx.stroke();
      }
      ctx.restore();
    }
    let vig = null;
    function vignette(ctx, k) {
      if (!vig) { vig = mk(W, H); const g = vig.getContext('2d'); const gr = g.createRadialGradient(W / 2, H / 2, H * 0.4, W / 2, H / 2, H * 1.0);
        gr.addColorStop(0, 'rgba(0,0,0,0)'); gr.addColorStop(1, 'rgba(0,0,0,0.8)'); g.fillStyle = gr; g.fillRect(0, 0, W, H); }
      ctx.globalAlpha = k; ctx.drawImage(vig, 0, 0); ctx.globalAlpha = 1;
    }
    function impactFrame(ctx, a) {
      ctx.save(); ctx.globalAlpha = a;
      ctx.globalCompositeOperation = 'saturation'; ctx.fillStyle = '#808080'; ctx.fillRect(0, 0, W, H);
      ctx.globalCompositeOperation = 'difference'; ctx.fillStyle = '#ffffff'; ctx.fillRect(0, 0, W, H);
      ctx.globalCompositeOperation = 'overlay'; ctx.fillStyle = '#9a9a9a'; ctx.fillRect(0, 0, W, H); ctx.restore();
    }
    function particlesScreen(ctx, t, o) { // poussière / bulles / pétales avec parallaxe (cx,cy = vitesse caméra)
      ctx.save(); const n = o.n || 40; ctx.globalCompositeOperation = o.add ? 'lighter' : 'source-over';
      for (let i = 0; i < n; i++) {
        const depth = 0.4 + rnd(i, 51) * 1.4;
        const px = (rnd(i, 1) * W - (o.camX || 0) * depth * 0.6 + (o.vx || 0) * t * depth * 40) % W, py = (rnd(i, 2) * H - (o.camY || 0) * depth * 0.6 + (o.vy || 0) * t * depth * 40) % H;
        const x = (px + W) % W, y = (py + H) % H;
        const r = (o.r || 2) * depth * (0.6 + rnd(i, 3));
        const tw = o.tw ? 0.4 + 0.6 * Math.abs(Math.sin(t * (1 + rnd(i, 4) * 3) + i)) : 1;
        if (o.bubble) { fx(ctx, 'bubble', Math.floor(t * 8 + i * 2) % 6, x, y, 0.8 + r * 0.3, o.a); continue; }
        if (o.tw && o.rgb.indexOf('255,120') === 0) { fx(ctx, 'flame', t * 12 + i * 3, x, y, 0.25 + r * 0.06, o.a, { bottom: true }); continue; }
        if (o.tw) { fx(ctx, 'sparkle', ((t * (0.6 + rnd(i, 4)) + rnd(i, 5)) % 1) * 8, x, y, 0.5 + r * 0.15, 1, { add: true }); continue; }
        if (o.bubble) { ctx.strokeStyle = `rgba(${o.rgb},${(o.a * tw).toFixed(3)})`; ctx.lineWidth = Math.max(1, r * 0.2); ctx.beginPath(); ctx.arc(x, y, r * 2.2, 0, TAU); ctx.stroke(); ctx.fillStyle = `rgba(255,255,255,${(o.a).toFixed(3)})`; ctx.fillRect(x - r, y - r, Math.max(1, r * 0.5), Math.max(1, r * 0.5)); }
        else { ctx.fillStyle = `rgba(${o.rgb},${(o.a * tw).toFixed(3)})`; const s = Math.max(1, Math.round(r)); ctx.fillRect(Math.round(x), Math.round(y), s, s); }
      }
      ctx.restore();
    }

    // ---------- Sprites PMD ----------
    function animInfo(pid, name) {
      const P = CAT[pid]; if (!P) return null;
      return P.anims[name] || P.anims.Idle || null;
    }
    function frameAt(info, tick, loop) {
      const d = info.durations; let total = 0; for (const x of d) total += x; total = Math.max(1, total);
      let k = loop ? ((tick % total) + total) % total : Math.min(Math.max(tick, 0), total - 1);
      let i = 0; while (i < d.length - 1 && k >= d[i]) { k -= d[i]; i++; }
      return Math.min(i, info.cols - 1);
    }
    function freezeBefore(t) { let f = 0; for (const ti of IMPACTS) if (t > ti) f += Math.min(t - ti, HITSTOP); return f; }

    function drawSprite(ctx, pid, anim, dir, tick, loop, x, y, o) {
      const info = animInfo(pid, anim); if (!info) return;
      const im = SH[info.file]; if (!im || !im.width) return;
      const col = frameAt(info, tick, loop), row = info.rows > 1 ? dir % info.rows : 0;
      const fw = info.fw, fh = info.fh;
      o = o || {};
      const z = o.z || 0, sc = o.s || 1, al = o.a == null ? 1 : o.a;
      // ombre
      if (!o.noShadow) {
        ctx.save(); ctx.globalAlpha = 0.24 * al * (1 - clamp(z / 60, 0, 0.6)); ctx.fillStyle = '#000';
        ctx.beginPath(); ctx.ellipse(x, y + 4, 9 * sc * (1 - clamp(z / 120, 0, 0.4)), 4.2 * sc, 0, 0, TAU); ctx.fill(); ctx.restore();
      }
      if (o.reflect) {
        ctx.save(); ctx.globalAlpha = 0.30 * al; ctx.translate(x, y + 4); ctx.scale(sc, -sc);
        ctx.drawImage(im, col * fw, row * fh, fw, fh, -fw / 2 + (o.wob || 0), -fh / 2 + z - 6, fw, fh); ctx.restore();
      }
      if (o.aura) glow(ctx, x, y - 8 - z, 34 * sc, o.aura, 0.35 * al);
      ctx.save(); ctx.globalAlpha = al; ctx.translate(x, y - 2 - z); if (o.rot) ctx.rotate(o.rot); ctx.scale(sc * (o.flip ? -1 : 1), sc);
      if (o.mat != null && o.mat < 1) dith(ctx, im, col * fw, row * fh, fw, fh, -fw / 2, -fh / 2, fw, fh, o.mat);
      else ctx.drawImage(im, col * fw, row * fh, fw, fh, -fw / 2, -fh / 2, fw, fh);
      if (o.tint) { ctx.globalCompositeOperation = 'source-atop'; ctx.globalAlpha = o.tint[1]; ctx.fillStyle = o.tint[0]; ctx.fillRect(-fw / 2, -fh / 2, fw, fh); }
      ctx.restore();
    }

    // ---------- Chorégraphie : helpers ----------
    // acteur : { id, pid, keys:[[t,x,y,z]], an:[[t,'Anim',dir|'auto'|{to:[x,y]}|{toId:id}, {loop,speed}]], a:[[t,alpha]], rot:[[t,r]], s, aura, reflect }
    const ACT = {};
    function posOf(def, t) { const p = lin(def.keys, t) || [0, 0, 0]; return { x: p[0], y: p[1], z: p[2] || 0 }; }
    function resolveActor(def, t, sceneActors) {
      let pos = posOf(def, t);
      if (def.attach && def._sc) { const cc = camAt(def._sc, t), ao = lin(def.attach, t); pos = { x: cc.cx + ao[0], y: cc.cy + ao[1], z: 0 }; }
      const an = def.an; let e = an[0]; for (const q of an) if (q[0] <= t) e = q; else break;
      let dir = e[2];
      if (dir === 'auto') {
        const p2 = posOf(def, t + 0.05), p1 = posOf(def, t - 0.05);
        const dx = p2.x - p1.x, dy = p2.y - p1.y; dir = (Math.abs(dx) + Math.abs(dy) < 0.02) ? (def._ld || 0) : dirFromVec(dx, dy);
      } else if (dir && typeof dir === 'object') {
        if (dir.toId) { const o = sceneActors.find((s) => s.id === dir.toId); if (o) { const q = posOf(o, t); dir = dirFromVec(q.x - pos.x, q.y - pos.y); } else dir = 0; }
        else dir = dirFromVec(dir.to[0] - pos.x, dir.to[1] - pos.y);
      }
      def._ld = dir;
      const opt = e[3] || {};
      const tAnim = Math.max(0, (t - freezeBefore(t)) - e[0]);
      const al = def.a ? lin(def.a, t)[0] : 1;
      const rot = def.rot ? lin(def.rot, t)[0] : 0;
      const sc = def.sk ? lin(def.sk, t)[0] : (def.s || 1);
      return { pos, anim: e[1], dir: dir | 0, tick: Math.min(tAnim * 60 * (opt.speed || 1), opt.hold != null ? opt.hold : 1e9), loop: opt.loop !== false, al, rot, sc };
    }

    // ---------- Décors animés ----------
    function warpBand(ctx, img, y0, y1, t, amp, freq) {
      for (let y = y0; y < y1; y++) {
        const ox = Math.round(Math.sin(y * freq + t * 2.2) * amp);
        ctx.drawImage(img, 0, y, MW, 1, ox, y, MW, 1.04);
      }
    }
    function drawMap(ctx, key, t, water) {
      const im = I[key];
      if (water) {
        ctx.drawImage(im, 0, 0, MW, water[0], 0, 0, MW, water[0]);
        warpBand(ctx, im, water[0], water[1], t, water[2] || 0.8, water[3] || 0.35);
        if (water[1] < MH) ctx.drawImage(im, 0, water[1], MW, MH - water[1], 0, water[1], MW, MH - water[1]);
      } else ctx.drawImage(im, 0, 0, MW, MH);
    }
    function sparklesWorld(ctx, t, n, seed, x0, y0, x1, y1, rgb, size) { // scintillements = sprites générés (échelle 8 images)
      const s = 0.22 * (size || 1);
      for (let i = 0; i < n; i++) {
        const ph = (t * (0.5 + rnd(i, seed + 2) * 0.8) + rnd(i, seed)) % 1;
        fx(ctx, 'sparkle', ph * 8, Math.round(lerp(x0, x1, rnd(i, seed + 1))), Math.round(lerp(y0, y1, rnd(i, seed + 3))), s, 1, { add: true });
      }
    }
    function bubblesWorld(ctx, t, n, seed, x0, x1, y0, y1, speed) { // bulles = sprites générés (6 images de flottement + 4 d'éclatement)
      for (let i = 0; i < n; i++) {
        const x = lerp(x0, x1, rnd(i, seed)) + Math.sin(t * 1.4 + i * 2.3) * 2.2;
        const k = ((t * speed * (0.5 + rnd(i, seed + 2)) * 0.05 + rnd(i, seed + 1)) % 1);
        const y = lerp(y1, y0, k), r = 0.8 + rnd(i, seed + 3) * 2.4;
        const idx = k > 0.92 ? 6 + Math.min(3, Math.floor((k - 0.92) / 0.08 * 4)) : Math.floor(t * 8 + i * 2) % 6;
        fx(ctx, 'bubble', idx, x, y, 0.1 + r / 3.2 * 0.16, 0.92);
      }
    }
    function wayfinder(ctx, key, x, y, s, t, a, rgb) { // badge étoile généré (sprite 32×32) ; a<1 = (dé)matérialisation tramée
      const im = I[key]; if (!im) return; const w = im.width, h = im.height, bob = Math.sin(t * 3 + x * 0.1) * 0.8;
      glow(ctx, x, y, 26 * s, rgb, 0.55 * Math.min(1, a * 1.6) * (0.75 + 0.25 * Math.sin(t * 4)));
      ctx.save(); ctx.translate(x, y + bob * s); ctx.scale(s, s);
      if (a < 0.999) dith(ctx, im, 0, 0, w, h, -w / 2, -h / 2, w, h, a); else ctx.drawImage(im, -w / 2, -h / 2, w, h);
      ctx.restore();
      if (a < 0.999 && a > 0.001) fx(ctx, 'mat', a * 8, x, y, 0.55 * s, 1, { tint: rgb, add: true });
      fx(ctx, 'sparkle', ((t * 1.1 + x * 0.05) % 1) * 8, x + 5 * s, y - 6 * s, 0.22 * s, a, { add: true });
    }
    function shardsW(ctx, x, y, u, n, seed, cols, speed, size) { // éclats de cristal = sprite généré (8 rotations)
      if (u < 0 || u > 1.5) return;
      for (let i = 0; i < n; i++) {
        const a = rnd(i, seed) * TAU, v = speed * (0.35 + rnd(i, seed + 1));
        fx(ctx, 'shard', u * 18 + i, x + Math.cos(a) * v * u, y + Math.sin(a) * v * u * 0.7 + 60 * u * u, 0.09 * size * (0.5 + rnd(i, seed + 3)), clamp(1 - u / 1.4, 0, 1));
      }
    }
    function barrierWorld(ctx, x, y, r, a, t) {
      if (a <= 0.003) return;
      ctx.save(); ctx.globalAlpha = a;
      const g = ctx.createRadialGradient(x - r * 0.3, y - r * 0.35, r * 0.1, x, y, r);
      g.addColorStop(0, 'rgba(210,255,255,0.25)'); g.addColorStop(0.75, 'rgba(70,200,255,0.25)'); g.addColorStop(1, 'rgba(120,255,255,0.8)');
      ctx.fillStyle = g; ctx.beginPath(); ctx.arc(x, y, r, 0, TAU); ctx.fill();
      ctx.save(); ctx.beginPath(); ctx.arc(x, y, r, 0, TAU); ctx.clip(); ctx.strokeStyle = 'rgba(220,255,255,0.65)'; ctx.lineWidth = 0.7;
      const hr = r / 3.6;
      for (let row = -5; row <= 5; row++) for (let col = -5; col <= 5; col++) {
        const hx = x + col * hr * 1.73 + (row & 1 ? hr * 0.865 : 0), hy = y + row * hr * 1.5;
        ctx.beginPath(); for (let k = 0; k < 6; k++) { const an = Math.PI / 6 + k * Math.PI / 3; const px = hx + Math.cos(an) * hr, py = hy + Math.sin(an) * hr; if (k) ctx.lineTo(px, py); else ctx.moveTo(px, py); } ctx.closePath(); ctx.stroke();
      }
      ctx.restore();
      ctx.strokeStyle = 'rgba(200,255,255,0.95)'; ctx.lineWidth = 1.4; ctx.beginPath(); ctx.arc(x, y, r, 0, TAU); ctx.stroke(); ctx.restore();
      glow(ctx, x, y, r * 1.7, '120,240,255', 0.3 * a);
    }

    // ---------- Caméra ----------
    function camAt(sc, t) {
      let [cx, cy, z, roll] = cr(sc.cam, t);
      roll = roll || 0;
      if (sc.follow) { let mx = 0, my = 0, n = 0; sc.follow.forEach((id) => { const a = sc.actors.find((q) => q.id === id); if (!a) return; if (a.vis && (t < a.vis[0] || t > a.vis[1])) return; const q = posOf(a, t); mx += q.x; my += q.y - 8; n++; });
        if (n) { cx = lerp(cx, mx / n, 0.85); cy = lerp(cy, my / n, 0.85); } }
      let sh = sc.shake ? sc.shake(t) : 0;
      for (const ti of IMPACTS) if (sc.melee) { const d = t - ti; if (d >= 0 && d < 0.5) { sh += Math.exp(-d * 9) * 3.2; z *= 1 + 0.05 * Math.exp(-d * 11); } }
      if (sh > 0) { cx += Math.sin(t * 61) * sh; cy += Math.cos(t * 73) * sh; roll += Math.sin(t * 47) * sh * 0.002; }
      const S = 4 * z;
      if (!sc.free) { // cadrage : ne jamais sortir de la map
        const m = 1 + Math.abs(roll) * 0.9, vw = W / S * m, vh = H / S * m;
        cx = vw >= MW ? MW / 2 : clamp(cx, vw / 2, MW - vw / 2); cy = vh >= MH ? MH / 2 : clamp(cy, vh / 2, MH - vh / 2);
      }
      return { cx, cy, z, S, roll };
    }
    function worldToScreen(c, x, y) {
      const dx = x - c.cx, dy = y - c.cy, cs = Math.cos(c.roll), sn = Math.sin(c.roll);
      return [W / 2 + c.S * (dx * cs - dy * sn), H / 2 + c.S * (dx * sn + dy * cs)];
    }

    // ---------- Rendu d'un plan ----------
    function renderScene(ctx, sc, t) {
      const c = camAt(sc, t);
      ctx.save();
      ctx.fillStyle = sc.bg || '#02030a'; ctx.fillRect(0, 0, W, H);
      ctx.imageSmoothingEnabled = false;
      ctx.translate(W / 2, H / 2); ctx.rotate(c.roll); ctx.scale(c.S, c.S); ctx.translate(-c.cx, -c.cy);
      if (sc.preMap) sc.preMap(ctx, t, c);
      if (sc.draw) sc.draw(ctx, t, c); else drawMap(ctx, sc.map, t, sc.water);
      if (sc.world) sc.world(ctx, t, c, 'under');
      // acteurs + props triés en profondeur
      const items = [];
      (sc.actors || []).forEach((a) => {
        a._sc = sc; const vis = a.vis || [sc.t0 - 1, sc.t1 + 1]; if (t < vis[0] || t > vis[1]) return;
        const r = resolveActor(a, t, sc.actors); if (r.al <= 0.003) return;
        items.push({ y: r.pos.y + (a.ys || 0), fn: () => drawSprite(ctx, a.pid, r.anim, r.dir, r.tick, r.loop, r.pos.x, r.pos.y, { z: r.pos.z, a: r.al, rot: r.rot, s: r.sc, aura: a.aura, reflect: a.reflect || sc.reflect, wob: Math.sin(t * 3 + (a.ph || 0)) * 0.8, noShadow: a.noShadow, flip: a.flip, tint: a.tint && a.tint(t) }) });
      });
      (sc.props || []).forEach((p) => {
        const pos = lin(p.keys, t); const al = p.a ? lin(p.a, t)[0] : 1; if (al <= 0.003) return;
        items.push({ y: pos[1] + (p.ys || 0), fn: () => wayfinder(ctx, p.img, pos[0], pos[1] - (pos[2] || 0), p.s ? (typeof p.s === 'number' ? p.s : lin(p.s, t)[0]) : 1, t, al, p.rgb || '120,235,255') });
      });
      items.sort((a, b) => a.y - b.y); items.forEach((it) => it.fn());
      if (sc.world) sc.world(ctx, t, c, 'over');
      ctx.restore();
      // grade + effets écran
      if (sc.grade) { ctx.save(); ctx.globalCompositeOperation = 'multiply'; const g = typeof sc.grade === 'function' ? sc.grade(t) : sc.grade; ctx.fillStyle = g; ctx.fillRect(0, 0, W, H); ctx.restore(); }
      if (sc.screen) sc.screen(ctx, t, c);
      if (sc.thunderT) thunderFx(ctx, sc.thunderT, t);
      return c;
    }

    // ================== PLANS « VOYAGE » — décors multicalques GÉNÉRÉS (parallaxe) + sprites PMDO image par image ==================
    const SC = [];
    const lerpC = (a, b, u) => a.map((v, i) => Math.round(lerp(v, b[i], u)));
    const rgbs = (c) => 'rgb(' + c.join(',') + ')';
    function vgrad(ctx, c0, c1) { const g = ctx.createLinearGradient(0, 0, 0, H); g.addColorStop(0, rgbs(c0)); g.addColorStop(1, rgbs(c1)); ctx.fillStyle = g; ctx.fillRect(-60, -60, W + 120, H + 120); }
    function grade(ctx, c, a) { ctx.save(); ctx.globalCompositeOperation = 'multiply'; ctx.fillStyle = rgbs(lerpC([255, 255, 255], c, a)); ctx.fillRect(0, 0, W, H); ctx.restore(); }
    function plate(ctx, key, x, y, s, a) { const im = I[key]; if (!im || !im.width) return; ctx.save(); ctx.imageSmoothingEnabled = false; if (a != null && a < 1) ctx.globalAlpha = Math.max(0, a); ctx.drawImage(im, Math.round(x), Math.round(y), im.width * s, im.height * s); ctx.restore(); }
    function tileH(ctx, key, off, y, s, a) { // couche répétée en miroir (raccord invisible) défilant horizontalement
      const im = I[key]; if (!im || !im.width) return; const w = Math.round(im.width * s), h = Math.round(im.height * s), P = 2 * w;
      let x = -(((off % P) + P) % P), i = 0; ctx.save(); ctx.imageSmoothingEnabled = false; if (a != null && a < 1) ctx.globalAlpha = Math.max(0, a);
      for (; x < W + 4; x += w, i++) { if (i % 2) { ctx.save(); ctx.translate(Math.round(x) + w, Math.round(y)); ctx.scale(-1, 1); ctx.drawImage(im, 0, 0, w, h); ctx.restore(); } else ctx.drawImage(im, Math.round(x), Math.round(y), w, h); }
      ctx.restore();
    }
    function integ(f, u) { let s = 0; const n = Math.ceil(u / 0.05); for (let i = 0; i < n; i++) { const d = Math.min(0.05, u - i * 0.05); s += f((i * 0.05) + d / 2) * d; } return s; }
    function spr(ctx, pid, anim, dir, tick, x, y, s, o) { // sprite PMDO en espace écran : y = sol (au pied) sauf o.fly (centre)
      o = o || {}; const cy = o.fly ? y : y - 4 * s;
      if (!o.fly && o.shadow !== false) { ctx.save(); ctx.globalAlpha = 0.28 * (o.a == null ? 1 : o.a); ctx.fillStyle = '#000'; ctx.beginPath(); ctx.ellipse(x, y, 9 * s, 3.4 * s, 0, 0, TAU); ctx.fill(); ctx.restore(); }
      ctx.save(); ctx.translate(x, cy); ctx.scale(s, s); ctx.imageSmoothingEnabled = false;
      drawSprite(ctx, pid, anim, dir, tick, o.loop !== false, 0, 0, { noShadow: true, a: o.a, aura: o.aura, rot: o.rot, flip: o.flip, mat: o.mat });
      ctx.restore();
    }
    function camWrap(ctx, t, t0, z0, z1, cx, cy, sway, fn) { const z = lerp(z0, z1, clamp((t - t0) / 10, 0, 1)); ctx.save(); ctx.translate(W / 2 + Math.sin(t * 0.7) * sway, H / 2 + Math.cos(t * 0.9) * sway * 0.6); ctx.scale(z, z); ctx.translate(-cx, -cy); fn(); ctx.restore(); }
    function trail(ctx, t, fn, tStart, n, gap, sc, tint) { // traînée d'étincelles derrière un vol
      for (let j = 1; j <= n; j++) { const tt = t - j * gap; if (tt < tStart) continue; const p = fn(tt); fx(ctx, 'sparkle', (t * 14 + j * 2) % 8, p[0] + Math.sin(j * 1.7) * 6, p[1] + Math.cos(j * 2.3) * 6, sc * (1 - j / (n + 3)), 1 - j / (n + 2), { add: true, tint: tint }); }
    }
    function petalWind(ctx, t, n, seed, vx, vy, sp, sc, tint) { // pétales de rose (sprite 16 images) emportés par le vent
      for (let i = 0; i < n; i++) { const ph = (t * sp * (0.6 + rnd(i, seed) * 0.8) + rnd(i, seed + 1)) % 1, x = vx < 0 ? lerp(W + 120, -120, ph) : lerp(-120, W + 120, ph), y = rnd(i, seed + 2) * (H + 100) - 50 + ph * vy + Math.sin(t * 1.8 + i * 1.3) * 30;
        fx(ctx, 'petal', t * 12 * (0.7 + rnd(i, seed + 3) * 0.6) + i * 5, x, y, sc * (0.7 + rnd(i, seed + 4) * 0.6), 1, { tint: tint }); }
    }
    function trio(ctx, t, t0, xs, gy, s, anim, dir, sp, o) { ['0393', '0447', '0133'].forEach((pid, i) => { const a = (o && o.anims && o.anims[i]) || anim; spr(ctx, pid, a, (o && o.dirs && o.dirs[i] != null) ? o.dirs[i] : dir, (t - t0) * 60 * sp + i * 7, xs[i], gy[i], s, o && o.o); }); }

    // ---- Abysse d'ouverture : nuage lumineux de bulles dans le bleu profond (comme le début d'un générique de One Piece) ----
    function abyss(ctx, t, a) {
      if (a <= 0.003) return;
      const cx0 = W / 2, cy0 = H / 2 + 10, k = 1 + 0.13 * t;
      ctx.save(); ctx.globalAlpha = a;
      const g = ctx.createRadialGradient(cx0, cy0, 20, cx0, cy0, 780); g.addColorStop(0, 'rgb(46,140,255)'); g.addColorStop(0.32, 'rgb(10,62,196)'); g.addColorStop(1, 'rgb(2,8,50)');
      ctx.fillStyle = g; ctx.fillRect(-80, -80, W + 160, H + 160); ctx.restore();
      glow(ctx, cx0, cy0, 330 + Math.sin(t * 1.3) * 18, '110,190,255', 0.5 * a);
      for (let i = 0; i < 12; i++) glow(ctx, cx0 + (rnd(i, 41) - 0.5) * 900 + Math.sin(t * 0.3 + i) * 30, cy0 + (rnd(i, 42) - 0.5) * 520, 50 + rnd(i, 43) * 70, '90,170,255', 0.14 * a); // bokeh
      for (let i = 0; i < 420; i++) { // nuage de bulles : spirale lente qui s'élargit
        const z = rnd(i, 1), r0 = 150 * Math.sqrt(-2 * Math.log(1 - rnd(i, 2) * 0.985)), ang = rnd(i, 3) * TAU + t * 0.16 / (0.4 + r0 / 200) * (i % 2 ? 1 : -0.7);
        const r = r0 * k * (1 + 0.07 * Math.sin(t * 0.7 + i)), x = cx0 + Math.cos(ang) * r * 1.2, y = cy0 + Math.sin(ang) * r * 0.9 - t * 4 * (0.3 + z);
        if (x < -60 || x > W + 60 || y < -60 || y > H + 60) continue;
        fx(ctx, 'bubble', t * 5 + i * 3, x, y, 0.2 + z * z * 0.9, a * (0.55 + 0.45 * z), { add: true });
      }
      for (let i = 0; i < 70; i++) { const ang = rnd(i, 7) * TAU + t * 0.3, r = 40 + rnd(i, 8) * 260 * k; fx(ctx, 'sparkle', t * 8 + i, cx0 + Math.cos(ang) * r * 1.2, cy0 + Math.sin(ang) * r * 0.8, 0.22 + rnd(i, 9) * 0.25, a * 0.9, { add: true }); }
    }
    function gulls(ctx, t, t0, dur, n, seed, y0, y1, a, rev) { // troupe de Goélise menée par un Bekipan
      const u = (t - t0) / dur; if (u < -0.2 || u > 1.25) return;
      for (let i = 0; i < n; i++) {
        const uu = u - (i ? 0.05 + 0.035 * i : 0) - rnd(i, seed) * 0.03, x = rev ? lerp(W + 140, -140, uu) : lerp(-140, W + 140, uu), y = lerp(y0, y1, uu) + Math.sin(uu * 13 + i * 2) * 16 + (i % 3) * 44 - 36;
        if (x < -170 || x > W + 170) continue;
        if (i === 0) spr(ctx, '0279', 'Walk', 0, t * 60 * 0.9, x, y, 4.4, { fly: true, a: a });
        else spr(ctx, '0278', 'Hover', 0, t * 60 * 0.8 + i * 5, x, y, 3.6 + rnd(i, seed + 1) * 1.0, { fly: true, a: a });
      }
    }

    // ---- Chapitre I : l'océan, la remontée, la surface ----
    const OR = (t) => 2600 * sstep((t - 4) / 16);               // altitude gagnée par la caméra (px)
    const SURF = (t) => lerp(-260, 170, sstep((t - 12) / 8));   // ligne de surface vue d'en dessous
    function bubbles(ctx, t, n, seed, spd, s0, s1, par, R, surf, alpha) { // bulles = sprite généré ; éclatent en touchant la surface
      for (let i = 0; i < n; i++) {
        const P = H + 200, ph = ((((t * spd * (0.6 + rnd(i, seed) * 0.8) - R * par + rnd(i, seed + 1) * P) % P) + P) % P), y = H + 100 - ph, x = rnd(i, seed + 2) * W + Math.sin(t * 1.3 + i * 2.1) * 14, s = lerp(s0, s1, rnd(i, seed + 3));
        let idx = Math.floor(t * 8 + i * 3) % 6; if (y < surf + 30) { const k = (surf + 30 - y) / 60; if (k >= 1) continue; idx = 6 + Math.min(3, Math.floor(k * 4)); }
        fx(ctx, 'bubble', idx, x, y, s, alpha);
      }
    }
    function fOcean(ctx, t) {
      const R = OR(t), k = sstep(t / 20), cx = t * 7, ys = SURF(t);
      vgrad(ctx, lerpC([14, 62, 102], [150, 240, 250], k), lerpC([8, 40, 74], [70, 200, 232], k));
      camWrap(ctx, t, 0, 1.06, 1.14, W / 2, H / 2, 8, () => {
        const by = -24 + R * 0.3, ba = 1 - sstep((by - 60) / 520); if (ba > 0.01) { plate(ctx, 'ocBg', -48 - cx * 0.15, by, 2, ba);
          if (by > -20) { const cc = lerpC(lerpC([14, 62, 102], [150, 240, 250], k), lerpC([8, 40, 74], [70, 200, 232], k), clamp((by + 40) / H, 0, 1)), g0 = ctx.createLinearGradient(0, by - 4, 0, by + 200); g0.addColorStop(0, 'rgba(' + cc.join(',') + ',1)'); g0.addColorStop(1, 'rgba(' + cc.join(',') + ',0)'); ctx.fillStyle = g0; ctx.fillRect(-100, by - 4, W + 200, 204); } }
        godRays(ctx, t, 0.3 + 0.45 * sstep((t - 6) / 12), W * 0.5, -40, 8, 1.1, H * 1.4, '190,245,255');
        bubbles(ctx, t, 18, 11, 38, 1.2, 2.0, 0.35, R, ys, 0.75);
        for (let i = 0; i < 40; i++) fx(ctx, 'sparkle', ((t * 0.7 + rnd(i, 3)) % 1) * 8, rnd(i, 1) * W, (rnd(i, 2) * H + t * 12 * (0.4 + rnd(i, 4)) + R * 0.5) % (H + 40), 0.2, 0.5, { add: true });
        if (t > 4.6 && t < 12.1) { const mu = (t - 4.6) / 7.5, mx = lerp(-140, W + 140, mu), my = 290 + Math.sin(t * 1.7) * 30 + R * 0.6; spr(ctx, '0490', 'Walk', 2, t * 60, mx, my, 4.2, { fly: true }); if (t % 0.4 < 0.05) fx(ctx, 'bubble', 0, mx - 70, my - 20, 1.4, 0.9); }
        tileH(ctx, 'ocFloor', cx, -48 + R, 2);
        abyss(ctx, t, 1 - sstep((t - 3.6) / 3));
        const kc = sstep((t - 8.5) / 3), ks = sstep((t - 3.8) / 3.4), bx0 = 977 - cx, by0 = 566 + R - 44 + Math.sin(t * 2) * 5;
        let bx = lerp(lerp(W / 2, bx0, ks), W / 2, kc), byy = lerp(lerp(H / 2, by0, ks), 380, kc); if (t > 16) byy = lerp(380, ys + 150, sstep((t - 16) / 4));
        if (ys > -200 && t > 16) bx = lerp(W / 2, 520, sstep((t - 16) / 4));
        const bap = sstep((t - 0.8) / 2.4); wayfinder(ctx, 'wfCyan', bx, byy, lerp(3.4, 2.3, ks), t, bap, '120,235,255'); if (t > 8.5) trail(ctx, t, (tt) => [lerp(bx0, W / 2, sstep((tt - 8.5) / 3)), lerp(by0, 380, sstep((tt - 8.5) / 3)) + 10], 8.5, 10, 0.07, 0.35, '170,245,255');
        bubbles(ctx, t, 14, 21, 70, 2.6, 4.2, 1.2, R, ys, 0.9);
        if (ys > -220) { // le plafond d'argent de la surface vu d'en dessous
          ctx.save(); ctx.beginPath(); ctx.moveTo(-200, -300); ctx.lineTo(W + 200, -300);
          for (let x = W + 200; x >= -200; x -= 20) ctx.lineTo(x, ys + Math.sin(x * 0.02 + t * 2) * 7 + Math.sin(x * 0.05 - t * 3) * 3); ctx.closePath();
          const g = ctx.createLinearGradient(0, ys - 220, 0, ys + 10); g.addColorStop(0, 'rgba(255,255,255,1)'); g.addColorStop(1, 'rgba(170,245,255,0.92)'); ctx.fillStyle = g; ctx.fill(); ctx.restore();
          ctx.save(); ctx.globalCompositeOperation = 'lighter'; for (let i = 0; i < 14; i++) { const x = rnd(i, 7) * (W + 300) - 150 + Math.sin(t * 0.8 + i) * 30; const gb = ctx.createLinearGradient(0, ys, 0, ys + 520); gb.addColorStop(0, 'rgba(210,255,255,0.22)'); gb.addColorStop(1, 'rgba(210,255,255,0)'); ctx.fillStyle = gb; ctx.beginPath(); ctx.moveTo(x, ys + 4); ctx.lineTo(x + 26, ys + 4); ctx.lineTo(x + 120 + i * 10, ys + 520); ctx.lineTo(x + 60, ys + 520); ctx.closePath(); ctx.fill(); } ctx.restore();
          const ta = sstep((t - 14.5) / 2) * 0.95;
          if (ta > 0.01) [['0393', 800], ['0133', 660], ['0447', 520]].forEach((q, i) => { const yy = ys + 110 + Math.sin(t * 1.6 + i * 2) * 8; spr(ctx, q[0], 'Float', 0, t * 60 + i * 9, q[1], yy, 4.4, { fly: true, a: ta }); if (Math.floor(t * 3 + i) % 3 === 0) fx(ctx, 'bubble', Math.floor(t * 8 + i) % 6, q[1] + 30, yy + 70, 1.6, 0.8); });
        }
      });
      flash(ctx, sstep((t - 19.2) / 0.8), '255,255,255');
    }
    SC.push({ id: 'OC1', t0: 0, t1: 20, custom: fOcean });

    function fSurface(ctx, t) {
      const u = t - 20; vgrad(ctx, [120, 200, 255], [60, 160, 230]);
      camWrap(ctx, t, 20, 1.2, 1.06, W / 2, H * 0.62, 7, () => {
        plate(ctx, 'surfaceSky', -48, -24, 2);
        const im = I.surfaceSky; if (im && im.width) { ctx.save(); ctx.imageSmoothingEnabled = false; for (let y = 460; y < 720; y += 2) { const ox = Math.round(Math.sin(y * 0.07 + t * 2.0) * 3 * (y - 460) / 260); ctx.drawImage(im, 0, (y + 24) / 2, im.width, 1, -48 + ox, y, im.width * 2, 2); } ctx.restore(); }
        glow(ctx, 1025, 414, 280, '255,240,190', 0.55); starBurst(ctx, 1025, 414, 320, 0.22, 10, t * 0.05);
        for (let i = 0; i < 30; i++) fx(ctx, 'sparkle', ((t * 0.9 + rnd(i, 3)) % 1) * 8, 300 + rnd(i, 1) * 900, 470 + rnd(i, 2) * 120, 0.28, 0.9, { add: true });
        tileH(ctx, 'beachFg', 0, 40, 2);
        const sp = Math.floor(t * 7) % 12; if (sp < 8) fx(ctx, 'splash', sp, 190, 590, 1.9, 0.85, { bottom: true });
        const xs = [840, 560, 700], gy = [640, 640, 652];
        spr(ctx, '0393', 'Idle', 6, (t - 20) * 60, xs[0], gy[0], 5.2); spr(ctx, '0133', 'Idle', 6, (t - 20) * 60 + 11, xs[2], gy[2], 5.2);
        const rp = u > 7 ? 'Pose' : 'Idle'; spr(ctx, '0447', rp, 6, u > 7 ? (u - 7) * 60 : u * 60, xs[1], gy[1], 5.2, { loop: u <= 7 });
        const kb = sstep((u - 1) / 6), bx = lerp(190, 585, kb), by = lerp(500, 500, kb) - Math.sin(kb * Math.PI) * 120 + Math.sin(t * 3) * 3 - (u > 7 ? 26 * sstep((u - 7) / 2) : 0);
        wayfinder(ctx, 'wfCyan', bx, by, 2.3, t, 1, '120,235,255'); trail(ctx, t, (tt) => { const q = sstep((tt - 21) / 6); return [lerp(190, 585, q), 500 - Math.sin(q * Math.PI) * 120]; }, 21, 12, 0.06, 0.4, '170,245,255');
        gulls(ctx, t, 21.2, 8, 6, 3, 250, 170, 1, false); gulls(ctx, t, 25.5, 8.5, 4, 11, 190, 270, 1, true);
        petalWind(ctx, t, Math.round(70 * sstep((u - 5) / 5)), 5, -1, 60, 0.07, 1.6);
      });
      godRays(ctx, t, 0.22, W * 0.8, -30, 6, 0.9, H * 1.3, '255,244,200');
      flash(ctx, 1 - sstep(u / 0.7), '255,255,255');
    }
    SC.push({ id: 'SF', t0: 20, t1: 31, custom: fSurface });

    // ---- Chapitre II : la prairie de roses, Mew s'envole vers le ciel ----
    const MEWP = (u) => { const e = sstep((u - 10.2) / 3.3); return [lerp(920, 1420, e), lerp(250, -160, e) - Math.sin(e * Math.PI) * 70]; };
    function fMeadow(ctx, t) {
      const u = t - 31, off = integ((x) => 95 * (1 - sstep((x - 3.6) / 1.2)), u), tilt = 380 * sstep((u - 11) / 3);
      vgrad(ctx, [70, 150, 240], [150, 215, 255]);
      camWrap(ctx, t, 31, 1.06, 1.12, W / 2, H / 2, 7, () => {
        ctx.save(); ctx.translate(0, tilt);
        plate(ctx, 'surfaceSky', -48, -190, 2); glow(ctx, 1040, 300, 260, '255,236,190', 0.4);
        tileH(ctx, 'clouds', u * 14, -40, 2, 0.95); tileH(ctx, 'clouds', u * 24 + 300, 60, 3, 0.8);
        tileH(ctx, 'meadow', off * 0.5, -150, 1.4, 0.9);
        tileH(ctx, 'meadow', off, -48, 2);
        const xs = [440, 560, 690], gy = [610, 602, 616], walking = u < 4.4;
        trio(ctx, t, 31, xs, gy, 5, walking ? 'Walk' : 'LookUp', 2, 0.9, { dirs: [2, 2, 2] });
        ctx.restore();
        const mm = sstep((u - 4.6) / 1.6), mp = u < 10.2 ? [920, 250 + Math.sin(t * 2.2) * 12] : MEWP(u);
        if (u > 4.6 && u < 14) { const an = u < 9 ? 'Idle' : (u < 10.2 ? 'Twirl' : 'Walk'); const dr = u < 10.2 ? 6 : 3; spr(ctx, '0151', an, dr, u < 9 ? t * 60 : (u - 9) * 60 * (u < 10.2 ? 0.9 : 1.6), mp[0], mp[1] + tilt, 4.6, { fly: true, mat: mm, aura: '255,170,230' }); if (mm < 1) matBurst(ctx, mp[0], mp[1] + tilt, mm, '255,170,235', 1.7); }
        trail(ctx, t, (tt) => { const q = MEWP(tt - 31); return [q[0], q[1] + tilt]; }, 41.2, 24, 0.045, 0.6, '255,190,240');
        petalWind(ctx, t, 70, 7, -1, 70, 0.09, 1.3); petalWind(ctx, t, 10, 17, -1, 100, 0.16, 2.4);
      });
      godRays(ctx, t, 0.2, W * 0.75, -30, 6, 0.9, H * 1.3, '255,240,200');
    }
    SC.push({ id: 'MD', t0: 31, t1: 45, custom: fMeadow });

    function fSky(ctx, t) {
      const u = t - 45, g = sstep(u / 13), sh = 380 + u * 430;
      vgrad(ctx, lerpC([70, 140, 235], [24, 56, 170], g), lerpC([140, 205, 255], [96, 160, 240], g));
      camWrap(ctx, t, 45, 1.06, 1.1, W / 2, H / 2, 8, () => {
        plate(ctx, 'surfaceSky', -48, -190 + sh * 0.9, 2, 1 - sstep(u / 7)); tileH(ctx, 'meadow', 0, -48 + sh, 2);
        const L = [[2, 240, 0.95, 20], [3, 420, 0.9, 90], [4.6, 760, 0.85, 200]];
        L.forEach((q, i) => { const hh = I.clouds ? I.clouds.height * q[0] : 760, P = H + hh; for (let r = 0; r < 2; r++) { const yy = ((((u * q[1] + r * P * 0.5 + i * 140) % P) + P) % P) - hh; tileH(ctx, 'clouds', u * q[3] + i * 300 + r * 500, yy, q[0], q[2]); } });
        const e = sstep((u - 8.5) / 4), mx = W / 2 + Math.sin(u * 1.1) * 70, my = lerp(390, -260, e) + Math.sin(u * 1.7) * 10, mm = sstep(u / 1.2);
        if (e < 1) { spr(ctx, '0151', 'Walk', 4, u * 60 * 1.4, mx, my, 6.2, { fly: true, mat: mm, aura: '255,170,230' }); if (mm < 1) matBurst(ctx, mx, my, mm, '255,170,235', 2.2); }
        trail(ctx, t, (tt) => { const uu = tt - 45, ee = sstep((uu - 8.5) / 4); return [W / 2 + Math.sin(uu * 1.1) * 70, lerp(390, -260, ee) + Math.sin(uu * 1.7) * 10]; }, 45.3, 26, 0.05, 0.7, '255,190,240');
        for (let i = 0; i < 26; i++) { const a = t * 1.4 + i * 0.7, r = 130 + (i % 9) * 22; if (e < 1) fx(ctx, 'petal', t * 12 + i * 5, mx + Math.cos(a) * r, my + 40 + Math.sin(a) * r * 0.55, 1.5, 1); }
        petalWind(ctx, t, 40, 9, 1, -200, 0.16, 1.4);
      });
      flash(ctx, 0.85 * sstep((t - 56.6) / 1.2), '255,225,240');
    }
    SC.push({ id: 'SK', t0: 45, t1: 58, custom: fSky });

    // ---- Chapitre III : la route de la forêt (comme PMD Sky), Celebi ----
    let LAYT = null;
    function fadedTile(ctx, key, off, y, sc, al, fadeH) { // calque dont le bord haut franc se fond dans le ciel (masque dégradé sur toile temporaire)
      if (!LAYT) LAYT = mk(W, H); const lx = LAYT.getContext('2d'); lx.setTransform(1, 0, 0, 1, 0, 0); lx.globalCompositeOperation = 'source-over'; lx.globalAlpha = 1; lx.clearRect(0, 0, W, H);
      tileH(lx, key, off, y, sc, al);
      const g = lx.createLinearGradient(0, y, 0, y + fadeH); g.addColorStop(0, 'rgba(0,0,0,1)'); g.addColorStop(1, 'rgba(0,0,0,0)');
      lx.globalCompositeOperation = 'destination-out'; lx.fillStyle = g; lx.fillRect(0, 0, W, Math.max(0, y + fadeH)); lx.globalCompositeOperation = 'source-over';
      ctx.drawImage(LAYT, 0, 0);
    }
    function forestBack(ctx, t, off, dy, o) { // décor en 4 calques de vitesses différentes (o.rk = part du mouvement vertical pour la route, o.fade = fondu du haut des calques quand on lève la caméra)
      o = o || {}; const rk = o.rk == null ? 1 : o.rk, f = o.fade && dy > 4;
      const L = (key, ox, y, sc, al, h) => { if (f) fadedTile(ctx, key, ox, y, sc, al, h); else tileH(ctx, key, ox, y, sc, al); };
      L('forestFar', off * 0.06, -24 + dy * 0.25, 2, 1, 320); L('forestMid', off * 0.18, 40 + dy * 0.5, 1.55, 0.55, 220);
      L('forestMid', off * 0.45, -30 + dy * 0.8, 2, 1, 260);
      tileH(ctx, 'forestRoad', off, -48 + dy * rk, 2);
    }
    function forestFront(ctx, t, off, dy, fr) { // cadre de feuillages de premier plan (calque forestFg) qui se balance : fr = [opacité, miroir]
      const im = I.forestFg; if (!im || !fr || !fr.length) return; const sw = Math.sin(t * 0.8) * 10;
      ctx.save(); ctx.imageSmoothingEnabled = false; ctx.globalAlpha = fr[0]; if (fr[1]) { ctx.translate(W, 0); ctx.scale(-1, 1); }
      ctx.drawImage(im, -40 + sw, -150 + dy + Math.cos(t * 0.6) * 6, 1360, 1015); ctx.restore();
    }
    function forestAir(ctx, t, n) { // feuilles + lucioles
      for (let i = 0; i < n; i++) { const ph = (t * 0.07 * (0.6 + rnd(i, 1)) + rnd(i, 2)) % 1; fx(ctx, 'petal', t * 10 + i * 4, lerp(W + 40, -60, ph) + Math.sin(t + i) * 40, rnd(i, 3) * H * 0.7 + ph * 120, 1.2, 1, { tint: '150,200,60' }); }
      for (let i = 0; i < 22; i++) fx(ctx, 'sparkle', ((t * 0.8 + rnd(i, 5)) % 1) * 8, rnd(i, 6) * W, 200 + rnd(i, 7) * 360 + Math.sin(t * 1.3 + i) * 18, 0.26, 0.8, { add: true, tint: '255,240,120' });
    }
    function fForest1(ctx, t) {
      const u = t - 58, off = u * 120;
      vgrad(ctx, [150, 200, 190], [60, 100, 80]);
      camWrap(ctx, t, 58, 1.05, 1.1, W / 2, H / 2, 8, () => {
        forestBack(ctx, t, off, 0); const xs = [330, 450, 570];
        trio(ctx, t, 58, xs, [626, 616, 636], 4.6, 'Walk', 2, 1.0); forestFront(ctx, t, off, 0, [0.85, 0]); forestAir(ctx, t, 26);
      });
      godRays(ctx, t, 0.3, W * 0.25, -30, 6, 0.9, H * 1.3, '255,240,190');
      flash(ctx, 0.8 * (1 - sstep(u / 1.4)), '255,225,240');
    }
    SC.push({ id: 'F1', t0: 58, t1: 72, custom: fForest1 });
    function fForest2(ctx, t) {
      const u = t - 72, off = 1700 + u * 180;
      vgrad(ctx, [150, 200, 190], [60, 100, 80]);
      camWrap(ctx, t, 72, 1.34, 1.42, 640, 420, 9, () => {
        forestBack(ctx, t, off, 0);
        const xs = [330, 530, 730];
        trio(ctx, t, 72, xs, [612, 602, 622], 6.2, 'Walk', 2, 1.1, { anims: [null, u > 8 && u < 9.4 ? 'Hop' : null, null].map((a, i) => (a ? a : (u > 6 && u < 7.2 && i === 2 ? 'Idle' : 'Walk'))), dirs: [2, 2, u > 6 && u < 7.4 ? 6 : 2], o: {} });
        forestFront(ctx, t, off, 0, [0.95, 1]); forestAir(ctx, t, 30);
      });
      godRays(ctx, t, 0.34, W * 0.2, -30, 7, 0.9, H * 1.3, '255,240,190');
    }
    SC.push({ id: 'F2', t0: 72, t1: 84, custom: fForest2 });
    function fForest3(ctx, t) {
      const u = t - 84, off = 3900 + integ((x) => 170 * (1 - sstep(x / 3)) + 170 * sstep((x - 12) / 2), u), cu = (x) => x;
      vgrad(ctx, [190, 225, 190], [80, 120, 90]);
      const lg = sstep(u / 3) * (1 - sstep((u - 13) / 3));
      camWrap(ctx, t, 84, 1.1, 1.2, W / 2, H / 2, 8, () => {
        forestBack(ctx, t, off, 0); glow(ctx, 930, 220, 520, '255,250,200', 0.5 * lg);
        const walk = u < 3.2 || u > 12.4, xs = [400, 530, 660], gy = [592, 582, 600];
        trio(ctx, t, 84, xs, gy, 5.2, walk ? 'Walk' : (u > 5 ? 'LookUp' : 'Idle'), 2, 1.0, { dirs: [2, 2, 2], anims: [walk ? 'Walk' : (u > 5.4 ? 'LookUp' : 'Idle'), walk ? 'Walk' : (u > 5.4 ? 'LookUp' : 'Idle'), walk ? 'Walk' : (u > 8 ? 'Pose' : (u > 5.4 ? 'LookUp' : 'Idle'))] });
        forestFront(ctx, t, off, 0, [0.6, 0]);
        const cm = sstep((u - 4.5) / 1.6); let cp;
        if (u < 9) cp = [930, 300 + Math.sin(t * 2.4) * 14]; else if (u < 12.4) { const a = (u - 9) * 1.9 - 0.4; cp = [600 + Math.cos(a) * 300, 360 + Math.sin(a) * 90 - 40]; } else cp = [lerp(900, 1000, sstep((u - 12.4) / 3.6)), 330 + Math.sin(t * 2) * 12];
        if (u > 4.5) { const an = u < 8 ? 'Idle' : (u < 9.4 ? 'Twirl' : (u < 12.4 ? 'Walk' : 'Walk')), dr = u < 9 ? 6 : (u < 12.4 ? (Math.cos((u - 9) * 1.9 - 0.4) > 0 ? 4 : 0) : 2);
          spr(ctx, '0251', an, dr, u < 8 ? t * 60 : (u - 8) * 60, cp[0], cp[1], 4.8, { fly: true, mat: cm, aura: '150,255,170' }); if (cm < 1) matBurst(ctx, cp[0], cp[1], cm, '170,255,190', 1.8); }
        trail(ctx, t, (tt) => { const q = tt - 84; if (q < 9) return [930, 300]; if (q < 12.4) { const a = (q - 9) * 1.9 - 0.4; return [600 + Math.cos(a) * 300, 320 + Math.sin(a) * 90]; } return [lerp(900, 1000, sstep((q - 12.4) / 3.6)), 330]; }, 93.3, 20, 0.05, 0.55, '170,255,190');
        forestAir(ctx, t, 26);
      });
      godRays(ctx, t, 0.3 + 0.35 * lg, W * 0.72, -30, 7, 0.9, H * 1.3, '255,248,200');
    }
    SC.push({ id: 'F3', t0: 84, t1: 100, custom: fForest3 });

    // ---- Chapitre IV : la suite — crépuscule, les badges guident, nuit étoilée ----
    function fDusk(ctx, t) {
      const u = t - 100, off = 5800 + u * 130;
      vgrad(ctx, [200, 160, 140], [60, 70, 90]);
      camWrap(ctx, t, 100, 1.06, 1.12, W / 2, H / 2, 8, () => {
        forestBack(ctx, t, off, 0);
        const xs = [330, 460, 600];
        trio(ctx, t, 100, xs, [614, 604, 622], 4.8, 'Walk', 2, 1.0);
        const bk = ['wfAmber', 'wfEmerald', 'wfCyan'], rg = ['255,210,100', '120,255,190', '120,235,255'];
        bk.forEach((k, i) => { const a = clamp((u - 1.2 - i * 0.7) / 1.0, 0, 1), bx = xs[2] + 130 + i * 70 + Math.sin(t * 1.6 + i) * 8, by = 330 - i * 40 + Math.sin(t * 2 + i * 2) * 14; wayfinder(ctx, k, bx, by, 2.1, t, a, rg[i]); if (a > 0.99) fx(ctx, 'sparkle', ((t * 1.2 + i * 0.3) % 1) * 8, bx + 24, by - 20, 0.3, 1, { add: true }); });
        forestFront(ctx, t, off, 0, [0.8, 1]); forestAir(ctx, t, 20);
      });
      grade(ctx, [255, 150, 130], 0.35 + 0.35 * sstep(u / 14));
      godRays(ctx, t, 0.2 * (1 - sstep(u / 12)), W * 0.8, -30, 6, 0.9, H * 1.3, '255,190,140');
    }
    SC.push({ id: 'F4', t0: 100, t1: 114, custom: fDusk });
    function fNight(ctx, t) {
      const u = t - 114, off = 7700 + integ((x) => 120 * (1 - sstep((x - 4) / 3)), u), tilt = 520 * sstep((u - 7.5) / 3.5);
      vgrad(ctx, [6, 10, 44], [24, 38, 86]);
      camWrap(ctx, t, 114, 1.05, 1.1, W / 2, H / 2, 7, () => {
        for (let i = 0; i < 90; i++) fx(ctx, 'sparkle', ((t * (0.4 + rnd(i, 1)) + rnd(i, 2)) % 1) * 8, rnd(i, 3) * W, rnd(i, 4) * (200 + tilt), 0.16 + rnd(i, 5) * 0.26, 1, { add: true });
        const rt = tilt * 0.1; forestBack(ctx, t, off, tilt * 0.8, { rk: 0.1, fade: true }); ctx.save(); ctx.translate(0, rt);
        const walking = u < 6.2, xs = [330, 460, 600];
        trio(ctx, t, 114, xs, [590, 580, 598], 4.8, walking ? 'Walk' : 'LookUp', 2, 1.0);
         ctx.restore();
        const bk = ['wfAmber', 'wfEmerald', 'wfCyan'], rg = ['255,210,100', '120,255,190', '120,235,255'], tg = [[W * 0.36, 170], [W * 0.5, 110], [W * 0.64, 170]], e = sstep((u - 7.5) / 4);
        bk.forEach((k, i) => { const bx0 = xs[2] + 130 + i * 70, by0 = 330 - i * 40 + tilt * 0.1; wayfinder(ctx, k, lerp(bx0, tg[i][0], e), lerp(by0, tg[i][1], e), lerp(2.1, 2.8, e), t, 1, rg[i]); });
        if (e > 0.3) { ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.strokeStyle = 'rgba(190,230,255,' + (0.55 * sstep((u - 11) / 1.5)).toFixed(2) + ')'; ctx.lineWidth = 3; ctx.beginPath(); ctx.moveTo(tg[0][0], tg[0][1]); ctx.lineTo(tg[1][0], tg[1][1]); ctx.lineTo(tg[2][0], tg[2][1]); ctx.lineTo(tg[0][0], tg[0][1]); ctx.stroke(); ctx.restore(); }
        const mu = (u - 9.5) / 3.5; if (mu > 0 && mu < 1) { const mx = lerp(-100, 1380, mu), my = 250 - Math.sin(mu * Math.PI) * 90; spr(ctx, '0151', 'Walk', 2, u * 60 * 1.5, mx, my, 3.6, { fly: true, aura: '255,170,230' }); }
        trail(ctx, t, (tt) => { const q = (tt - 123.5) / 3.5; return [lerp(-100, 1380, q), 250 - Math.sin(q * Math.PI) * 90]; }, 123.6, 20, 0.05, 0.5, '255,190,240');
        for (let i = 0; i < 14; i++) fx(ctx, 'sparkle', ((t * 1.1 + rnd(i, 8)) % 1) * 8, rnd(i, 9) * W, 360 + rnd(i, 10) * 280 + tilt * 0.1, 0.28, 0.9, { add: true, tint: '255,240,120' });
      });
      grade(ctx, [60, 80, 180], 0.9); glow(ctx, W * 0.82, 110, 260, '210,225,255', 0.25 * sstep((u - 7) / 3));
    }
    SC.push({ id: 'F5', t0: 114, t1: 128, custom: fNight });

    // ---- Chapitre V : l'aube sur la prairie de roses, vers le Rayon d'Espoir ----
    function fDawn(ctx, t) {
      const u = t - 128, off = 9000 + u * 250, k = sstep(u / 4);
      vgrad(ctx, lerpC([40, 50, 120], [255, 190, 150], k), lerpC([90, 90, 160], [255, 230, 190], k));
      camWrap(ctx, t, 128, 1.06, 1.12, W / 2, H / 2, 9, () => {
        plate(ctx, 'surfaceSky', -48, -270, 2, 1); glow(ctx, 924, 146, 380, '255,225,170', 0.75);
        tileH(ctx, 'clouds', u * 22, -40, 2, 0.85); gulls(ctx, t, 131, 9, 5, 7, 250, 170, 1, false); tileH(ctx, 'meadow', off * 0.5, -70, 1.4, 0.9); tileH(ctx, 'meadow', off, 24, 2);
        const xs = [440, 580, 730];
        trio(ctx, t, 128, xs, [618, 606, 624], 5.2, 'Walk', 2, 1.9);
        const hk = sstep((u - 5) / 3); if (hk > 0) fx(ctx, 'halo', u * 10, 924, 146, 5.6, 0.55 * hk * (0.9 + 0.1 * Math.sin(u * 3)), {});
        petalWind(ctx, t, 90, 13, -1, 40, 0.16, 1.4); petalWind(ctx, t, 12, 23, -1, 80, 0.26, 2.6);
        const mu = (u - 6) / 4.5; if (mu > 0 && mu < 1) { const mx = lerp(-120, 1400, mu), my = lerp(210, 120, mu) + Math.sin(mu * 9) * 20; spr(ctx, '0151', 'Walk', 2, u * 60 * 1.6, mx, my, 4.4, { fly: true, aura: '255,170,230' }); }
        trail(ctx, t, (tt) => { const q = (tt - 134) / 4.5; return [lerp(-120, 1400, q), lerp(210, 120, q) + Math.sin(q * 9) * 20]; }, 134.1, 22, 0.05, 0.55, '255,190,240');
      });
      godRays(ctx, t, 0.4, W * 0.8, -30, 7, 0.9, H * 1.3, '255,235,190'); flash(ctx, 0.9 * (1 - sstep(u / 1.4)), '40,60,130');
    }
    SC.push({ id: 'DW', t0: 128, t1: 140, custom: fDawn });
    function fHill(ctx, t) {
      const u = t - 140, z = lerp(1.1, 1.3, sstep(u / 8));
      vgrad(ctx, [255, 190, 150], [255, 235, 200]);
      camWrap(ctx, t, 140, z, z, lerp(640, 760, sstep(u / 8)), lerp(451, 340, sstep(u / 8)), 6, () => {
        plate(ctx, 'surfaceSky', -48, -270, 2); glow(ctx, 924, 146, 440, '255,230,180', 0.85);
        const hk = 1; fx(ctx, 'halo', t * 10, 924, 146, 5.8, 0.6 * (0.9 + 0.1 * Math.sin(t * 3)), {});
        tileH(ctx, 'clouds', t * 18, -40, 2, 0.8); gulls(ctx, t, 141.5, 6, 4, 9, 230, 180, 1, true); tileH(ctx, 'meadow', 0, 24, 2);
        const e = sstep((u - 1.2) / 3);
        const pose = u > 3.2, xs = [520, 660, 800];
        trio(ctx, t, 140 + 3.2, xs, [562, 550, 568], 5.6, pose ? 'Pose' : 'Idle', 0, 1.0, { o: { loop: false } });
        const bk = ['wfAmber', 'wfEmerald', 'wfCyan'], rg = ['255,210,100', '120,255,190', '120,235,255'];
        bk.forEach((k, i) => { const q = sstep((u - 3.6 - i * 0.4) / 2.2), bx = lerp(xs[i] + 10, 924, q), by = lerp(520, 146, q) - Math.sin(q * Math.PI) * 120; wayfinder(ctx, k, bx, by, 2.4 * (1 - 0.45 * q), t, clamp((u - 3.2 - i * 0.3) / 0.8, 0, 1) * (1 - sstep((q - 0.92) / 0.08)), rg[i]); });
        const mu = (u - 1.6) / 3.2; if (mu > 0 && mu < 1) { const mx = lerp(1380, -100, mu), my = lerp(160, 260, mu) + Math.sin(mu * 8) * 24; spr(ctx, '0151', 'Walk', 6, u * 60 * 1.6, mx, my, 4.2, { fly: true, aura: '255,170,230' }); }
        trail(ctx, t, (tt) => { const q = (tt - 141.6) / 3.2; return [lerp(1380, -100, q), lerp(160, 260, q) + Math.sin(q * 8) * 24]; }, 141.7, 20, 0.05, 0.5, '255,190,240');
        petalWind(ctx, t, 70, 31, -1, 50, 0.14, 1.4);
      });
      godRays(ctx, t, 0.45, W * 0.8, -30, 8, 0.9, H * 1.3, '255,235,190');
      const fl = sstep((t - 146.4) / 1.2); if (fl > 0) { glow(ctx, W * 0.8, 200, 900 * fl, '255,255,240', 0.9 * fl); flash(ctx, fl, '255,255,255'); }
    }
    SC.push({ id: 'HL', t0: 140, t1: 148, custom: fHill });

    // ---------- Écran-titre ----------
    function wingAngle(dtLogo, nowSec, flapStart) {
      let d = 0;
      if (dtLogo >= 0 && dtLogo < 3.4) d += 8.2 * Math.exp(-1.55 * dtLogo) * Math.cos(TAU * 2.25 * dtLogo); else if (dtLogo >= 3.4) d += 0.6 * Math.sin((dtLogo - 3.4) * 1.9);
      const dm = nowSec - (flapStart == null ? -99 : flapStart); if (dm >= 0 && dm < 2.4) d += 8.8 * Math.exp(-1.75 * dm) * Math.sin(TAU * 2.6 * dm);
      return d;
    }
    function drawTitle(ctx, tl, theme, nowSec, flapStart) {
      const atlas = theme === 'nuit' ? I.nightSeaAtlas : I.daySeaAtlas, pose = Math.floor(nowSec * 12) % 24;
      ctx.save(); ctx.imageSmoothingEnabled = false; ctx.drawImage(atlas, (pose % 6) * 320, Math.floor(pose / 6) * 240, 320, 240, 0, -120, W, 960); ctx.restore();
      const cx = W / 2, cy = H / 2; let out = 0;
      if (tl >= 0.04 && tl <= 0.6) { const fu = (tl - 0.04) / 0.56, env = Math.sin(Math.PI * clamp(fu, 0, 1)); ctx.save(); ctx.globalCompositeOperation = 'lighter'; const hl = W * (0.2 + 0.32 * fu);
        const g = ctx.createRadialGradient(cx, cy, 2, cx, cy, hl); g.addColorStop(0, `rgba(255,255,245,${(0.95 * env).toFixed(3)})`); g.addColorStop(0.4, `rgba(254,240,138,${(0.7 * env).toFixed(3)})`); g.addColorStop(1, 'rgba(254,240,138,0)');
        ctx.fillStyle = g; ctx.beginPath(); ctx.ellipse(cx, cy, hl, Math.max(6, 28 * env), 0, 0, TAU); ctx.fill(); ctx.restore(); }
      if (tl >= 0.18) {
        const dt = tl - 0.18; let scale = 1, alpha = 1, wf = 0;
        if (dt < 0.6) { const uu = dt / 0.6, c1 = 1.70158, c3 = c1 + 1, e = 1 + c3 * Math.pow(uu - 1, 3) + c1 * Math.pow(uu - 1, 2); scale = 1.4 + (1 - 1.4) * e; alpha = Math.min(1, dt / 0.18); wf = Math.max(0, 1 - dt / 0.35); }
        const deg = wingAngle(dt, nowSec, flapStart) * 0.55, rad = deg * Math.PI / 180; out = deg / 0.55;
        const pl = [274, 335], pr = [598, 335];
        rigX.clearRect(0, 0, RW, RH);
        if (I.rigBack) rigX.drawImage(I.rigBack, 0, 0);
        rigX.save(); rigX.translate(pl[0], pl[1]); rigX.rotate(rad); rigX.drawImage(I.rigLW, -pl[0], -pl[1]); rigX.restore();
        rigX.save(); rigX.translate(pr[0], pr[1]); rigX.rotate(-rad); rigX.drawImage(I.rigRW, -pr[0], -pr[1]); rigX.restore();
        rigX.drawImage(I.rigCore, 0, 0);
        const bw = 560 * scale, bh = bw * RH / RW;
        glow(ctx, cx, cy, 420 * scale, '255,236,160', 0.18 + 0.1 * Math.sin(nowSec * 2));
        ctx.save(); ctx.globalAlpha = alpha; ctx.imageSmoothingEnabled = true; ctx.imageSmoothingQuality = 'high'; ctx.drawImage(rigC, cx - bw / 2, cy - bh / 2, bw, bh); ctx.restore();
      }
      if (tl > 1.25) { const bl = 0.45 + 0.55 * (0.5 + 0.5 * Math.sin(nowSec * 5)); ctx.save(); ctx.imageSmoothingEnabled = false; ctx.globalAlpha = bl; ctx.drawImage(I.enterUI, (W - 74 * 4) / 2, 590, 74 * 4, 11 * 4); ctx.restore(); }
      return out;
    }

    // ---------- Compositeur ----------
    SC.sort((a, b) => a.t0 - b.t0);
    const XF = { SF: 0.5, MD: 1.0, SK: 1.0, F1: 1.0, F2: 0.8, F3: 0.9, F4: 1.0, F5: 1.2, DW: 1.2, HL: 0.8 };
    function drawShot(ctx, sc, t) { if (sc.custom) { sc.custom(ctx, t); return null; } return renderScene(ctx, sc, t); }
    function bars(ctx, t) { const k = sstep((t - 0.2) / 1.2); const h = 52 * k * (1 - sstep((t - 146.8) / 0.8)); ctx.fillStyle = '#000'; ctx.fillRect(0, 0, W, h); ctx.fillRect(0, H - h, W, h); }

    function render(ctx, t, opts) {
      opts = opts || {}; t = clamp(t, 0, D); let wing = 0;
      ctx.save(); ctx.imageSmoothingEnabled = true; ctx.globalAlpha = 1; ctx.globalCompositeOperation = 'source-over'; ctx.fillStyle = '#000'; ctx.fillRect(0, 0, W, H);
      if (t >= TITLE_T) {
        const tl = t - TITLE_T; wing = drawTitle(ctx, tl, opts.theme || 'jour', opts.nowSec || 0, opts.flapStart);
        flash(ctx, 1 - sstep(tl / 1.3)); vignette(ctx, 0.3);
      } else {
        let i = SC.findIndex((s) => t >= s.t0 && t < s.t1); if (i < 0) i = SC.length - 1; const sc = SC[i], xf = XF[sc.id] || 0;
        if (xf > 0 && i > 0 && t < sc.t0 + xf) {
          drawShot(ctx, SC[i - 1], t); sctx.save(); sctx.globalAlpha = 1; sctx.globalCompositeOperation = 'source-over'; sctx.clearRect(0, 0, W, H); drawShot(sctx, sc, t); sctx.restore();
          ctx.globalAlpha = sstep((t - sc.t0) / xf); ctx.drawImage(scr, 0, 0); ctx.globalAlpha = 1;
        } else drawShot(ctx, sc, t);
        vignette(ctx, 0.5); bars(ctx, t); flash(ctx, 1 - sstep(t / 1.4), '0,0,0');
      }
      ctx.restore(); return { wing, shot: t >= TITLE_T ? 'title' : (SC.find((s) => t >= s.t0 && t < s.t1) || SC[SC.length - 1]).id };
    }
    function renderTitleMode(ctx, tl, theme, nowSec, flapStart) { ctx.save(); ctx.fillStyle = '#000'; ctx.fillRect(0, 0, W, H); const wing = drawTitle(ctx, tl, theme, nowSec, flapStart); vignette(ctx, 0.3); ctx.restore(); return { wing }; }
    return { render, renderTitleMode, W, H, D, CHAPTERS, TITLE_T, IMPACTS, SC };
  }
  root.PMDDestinyVoyage = { create, W, H, D, CHAPTERS, TITLE_T, IMPACTS, BEAT };
})(typeof window !== 'undefined' ? window : globalThis);
