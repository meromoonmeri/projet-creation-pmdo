/* Cinématique d'Opening « PMD : Destiny » — version SPRITES PMDO ANIMÉS IMAGE PAR IMAGE + CAMÉRA IMMERSIVE.
   1280×720 · 60 FPS · durée EXACTE 153,0 s (02:33) = vidéo de référence « Simple and Clean -Ray of Hope MIX- ».
   • Acteurs = vrais sprites PMDCollab (AnimData.xml : durées image par image, 8 directions, ombres corrompues).
   • Décors = les 5 Maps d'Opening PMD 3/4 pixel-art (OPM1..OPM5) + vitrail + Wayfinders.
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
    { t: 24.0, name: '', short: 'II' },
    { t: 46.0, name: '', short: 'III' },
    { t: 68.0, name: '', short: 'IV' },
    { t: 106.0, name: '', short: 'V' },
    { t: 132.0, name: '', short: 'VI' },
  ];
  const IMPACTS = [74.0, 75.4, 78.6, 79.0, 80.4, 81.9, 82.4, 84.0, 85.6, 86.2, 92.2, 101.0, 103.3];
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
      // 4a : Darkrai bombarde les trois héros
      { kind: 'shadowball', t0: 73.0, from: [352, 126], to: [238, 190], s: 1.2 },
      { kind: 'shadowball', t0: 74.4, from: [352, 128], to: [232, 194], s: 1.4 },
      // 4b : mêlée — Météores d'Évoli, Bulles d'O de Tiplouf, Ball'Ombre de Darkrai
      { kind: 'swift', t0: 77.6, from: [262, 186], to: [306, 174], n: 5, charge: 0.45, fly: 0.55 },
      { kind: 'shadowball', t0: 79.4, from: [348, 132], to: [266, 182] },
      { kind: 'bubble', t0: 80.9, from: [278, 204], to: [318, 194], n: 7, charge: 0.45, fly: 0.55 },
      { kind: 'shadowball', t0: 83.0, from: [344, 134], to: [250, 184], s: 1.3 },
      { kind: 'shadowball', t0: 84.6, from: [342, 136], to: [236, 186], s: 1.6 },
      // 4c : Darkrai tente d'interrompre l'évolution
      { kind: 'shadowball', t0: 91.2, from: [336, 130], to: [222, 172], s: 1.8 },
      // 4d : Aurasphère du Méga-Lucario contre Ball'Ombre de Darkrai — les deux sphères se percutent
      { kind: 'aurasphere', t0: 99.6, from: [226, 184], to: [302, 160], s: 2.0, charge: 0.8, fly: 0.6 },
      { kind: 'shadowball', t0: 99.6, from: [338, 134], to: [302, 160], s: 2.2, charge: 0.8, fly: 0.6 },
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
    // rayons de lumière : planche de faisceaux de PMD Rouge (image-1) teintée, balancée en éventail ; repli procédural si la planche manque
    function godRays(ctx, t, a, ox, oy, n, spread, len, rgb) {
      const im = tintRays(rgb || '255,246,206'); if (!im) return godRaysProc(ctx, t, a, ox, oy, n, spread, len, rgb);
      ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.imageSmoothingEnabled = true;
      for (let i = 0; i < 3; i++) {
        const ang = (i - 1) * spread * 0.3 + Math.sin(t * 0.3 + i * 2.1) * 0.05, sx = (W / 212) * (0.5 + 0.22 * i) * (0.6 + 0.5 * spread), al = clamp(a * (0.5 + 0.5 * Math.sin(t * 0.8 + i * 1.7) ** 2) * 1.15, 0, 1);
        if (al < 0.01) continue; ctx.globalAlpha = al;
        for (let k = 0; k < 2; k++) { ctx.save(); ctx.translate(ox + (i - 1) * W * 0.16, oy); ctx.rotate(-ang); ctx.scale(sx, len / 200); ctx.drawImage(im, -106, 0); ctx.restore(); }
      }
      ctx.restore();
    }
    function godRaysProc(ctx, t, a, ox, oy, n, spread, len, rgb) {
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
      ctx.drawImage(im, col * fw, row * fh, fw, fh, -fw / 2, -fh / 2, fw, fh);
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

    // ================== PLANS ==================
    const SC = [];
    const dais = [288, 152];
    // ---- Chapitre I ----
    // 1b : le trio joue sur la plage — travelling latéral bas
    const trioWalk = (pid, id, x0, y0, x1, y1, tA, tB, extra) => ({ id, pid, keys: [[tA - 6, x0, y0], [tB, x1, y1]], reflect: true, ...extra });
    // 1c : très gros plan sur le Wayfinder — le cœur de l'étoile bat
    SC.push({
      id: '1c', t0: 11, t1: 14.5, map: 'opm2', grade: 'rgb(140,195,255)',
      cam: [[11, 288, 140, 2.2, 0.04], [14.5, 288, 150, 5.2, -0.02]],
      props: [{ img: 'wfCyan', keys: [[11, 288, 150, 0]], s: [[11, 1.2], [14.5, 1.5]] }],
      world(ctx, t, c, ph) { if (ph !== 'over') return; const p = 0.5 + 0.5 * Math.sin(t * 5); glow(ctx, 288, 150, 120, '110,235,255', 0.25 + 0.3 * p); starBurst(ctx, 288, 150, 160, 0.25 * p, 8, t * 0.3); bubblesWorld(ctx, t, 22, 11, 240, 340, 60, 190, 1.2); sparklesWorld(ctx, t, 40, 12, 230, 100, 350, 190, '255,236,170', 1); },
      screen(ctx, t) { godRays(ctx, t, 0.55, W * 0.5, -20, 8, 1.2, H, '210,250,255'); },
    });
    // 1d : Riolu sent le Wayfinder et tend la patte vers l'eau
    SC.push({
      id: '1d', t0: 14.5, t1: 19, map: 'opm1', water: [112, 320, 0.7, 0.3],
      cam: [[14.5, 300, 100, 2.4, -0.03], [17, 268, 108, 3.2, 0.02], [19, 262, 112, 3.6, 0.0]],
      actors: [
        { id: 'riolu', pid: '0447', keys: [[14.5, 262, 108], [19, 262, 112]], an: [[14.5, 'Idle', 0], [15.6, 'LookUp', 0, { loop: false }], [16.8, 'Pose', 0, { loop: false }], [17.7, 'Pull', 0, { loop: false }]] },
        { id: 'evoli', pid: '0133', keys: [[14.5, 296, 100]], an: [[14.5, 'Idle', 6], [16.2, 'Idle', 6]] },
        { id: 'tiplouf', pid: '0393', keys: [[14.5, 322, 106]], an: [[14.5, 'Idle', 6]] },
      ],
      world(ctx, t, c, ph) { if (ph !== 'over') return; const u = t - 14.5; for (let k = 0; k < 4; k++) { const p = ((u * 0.5 + k * 0.25) % 1); ring(ctx, 262, 124, 3 + p * 24, 0.7, '230,255,255', 0.8 * (1 - p), 0.38); }
        glow(ctx, 262, 126, 30, '170,255,255', 0.5 * sstep((u - 2.0) / 2.5)); sparklesWorld(ctx, t, 50, 14, 200, 110, 330, 170, '255,255,235', 1); },
      screen(ctx, t) { godRays(ctx, t, 0.2, W * 0.1, 40, 5, 1.0, H, '255,236,180'); },
    });
    // 1e : le Wayfinder s'embrase
    SC.push({
      id: '1e', t0: 19, t1: 24, map: 'opm2', grade: 'rgb(150,205,255)',
      cam: [[19, 288, 150, 2.3, 0.0], [24, 288, 150, 1.6, 0.1]],
      props: [{ img: 'wfCyan', keys: [[19, 288, 150, 0]], s: [[19, 1.0], [24, 1.5]] }],
      world(ctx, t, c, ph) { if (ph !== 'over') return; const k = sstep((t - 21.8) / 2.2); glow(ctx, 288, 150, lerp(120, 520, k), '150,245,255', 0.5 + 0.12 * Math.sin(t * 5) + 0.4 * k); starBurst(ctx, 288, 150, lerp(70, 500, k), 0.1 + 0.08 * Math.sin(t * 3) ** 2 + 0.5 * k, 10, t * 0.4); for (let r = 0; r < 4; r++) { const pr = ((t - 19) * 0.6 + r * 0.25) % 1; ring(ctx, 288, 150, 10 + pr * 120, 1.2, '210,255,255', 0.7 * (1 - pr), 0.8); } bubblesWorld(ctx, t, 26, 15, 200, 380, 40, 230, 1.6); },
      screen(ctx, t) { godRays(ctx, t, 0.16, W * 0.5, -20, 8, 1.2, H, '210,250,255'); flash(ctx, sstep((t - 23.0) / 1.0)); },
    });

    // ---- Chapitre II : projecteur, chute arrière, vitrail ----
    const fall = (t) => 30 + (t - 24) * 6.2; // altitude de chute d'Évoli (y monde)
    SC.push({
      id: '2b', t0: 36, t1: 46, map: 'opm2', free: true, bg: '#010208', grade: (t) => `rgb(${Math.round(lerp(80, 220, sstep((t - 40) / 5)))},${Math.round(lerp(120, 240, sstep((t - 40) / 5)))},255)`,
      cam: [[36, 288, 30, 1.7, 0.06], [41, 288, 150, 1.35, -0.05], [46, 288, 250, 1.6, 0.04]],
      actors: [{ id: 'evoli', pid: '0133', keys: [[36, 288, 150]], attach: [[36, 0, -6], [41, 6, 0], [46, -4, 2]], an: [[36, 'Sink', 0, { loop: false, hold: 21, speed: 0.5 }]], rot: [[36, -0.5], [41, 0.3], [46, -0.3]], s: 1.5, aura: '130,235,255', noShadow: true }],
      world(ctx, t, c, ph) { if (ph === 'under') { ctx.save(); ctx.globalAlpha = 1; ctx.drawImage(I.vitrail, 288 - 130, 150 - 118, 260, 236); ctx.restore(); const lit = sstep((t - 40) / 4.5); glow(ctx, 288, 150, 220, '255,255,255', 0.7 * lit); }
        if (ph === 'over') { sparklesWorld(ctx, t, 90, 22, 100, 20, 480, 300, '255,246,200', 1); starBurst(ctx, 288, 150, 360, 0.5 * sstep((t - 40) / 4), 12, t * 0.3); } },
      screen(ctx, t) { flash(ctx, sstep((t - 44.6) / 1.4)); },
    });

    SC.push({
      id: '3b', t0: 52.5, t1: 58, map: 'opm2', free: true, bg: '#010208', grade: 'rgb(110,150,220)',
      cam: [[52.5, 288, 20, 2.2, 0.08], [55, 288, 90, 2.6, -0.04], [58, 288, 150, 3.0, 0.0]],
      props: [{ img: 'wfAmber', rgb: '255,210,100', keys: [[52.5, 288, -10, 0], [58, 288, 150, 0]], s: 1.2 }],
      world(ctx, t, c, ph) { if (ph !== 'over') return; const y = lerp(-10, 150, sstep((t - 52.5) / 5.5)); for (let k = 1; k < 12; k++) glow(ctx, 288, y - k * 7, 12 - k * 0.8, '255,210,100', 0.3 - k * 0.024); bubblesWorld(ctx, t, 28, 41, 200, 380, 0, 250, 1.8); sparklesWorld(ctx, t, 60, 42, 190, -20, 390, 250, '190,245,255', 1); },
      screen(ctx, t) { godRays(ctx, t, 0.35, W * 0.5, -20, 7, 1.0, H, '210,250,255'); },
    });
    SC.push({
      id: '3c', t0: 58, t1: 62, map: 'opm2', grade: 'rgb(130,170,235)',
      cam: [[58, 288, 150, 3.4, 0.05], [62, 288, 140, 2.4, -0.03]],
      actors: [
        { id: 'evoli', pid: '0133', keys: [[58, 288, 156]], an: [[58, 'Float', 0], [59.4, 'Pose', 0, { loop: false }]], s: 1.0, aura: '150,235,255' },
        { id: 'riolu', pid: '0447', keys: [[60.4, 238, 150], [61.9, 238, 168]], an: [[60.4, 'Idle', 2]], a: [[60.4, 0], [60.9, 0.7], [61.6, 0.5], [61.9, 0]], rot: [[60.4, 0]], vis: [60.3, 62] },
        { id: 'tiplouf', pid: '0393', keys: [[60.4, 338, 150], [61.9, 338, 168]], an: [[60.4, 'Idle', 6]], a: [[60.4, 0], [60.9, 0.7], [61.6, 0.5], [61.9, 0]], vis: [60.3, 62] },
      ],
      props: [{ img: 'wfAmber', rgb: '255,210,100', keys: [[58, 288, 190, 0], [59.6, 306, 148, 0]], s: 0.9 }, { img: 'wfCyan', keys: [[60.4, 238, 134, 0]], s: 0.9, a: [[60.4, 0], [60.9, 1], [61.6, 1], [61.9, 0]] }, { img: 'wfEmerald', rgb: '120,255,190', keys: [[60.4, 338, 134, 0]], s: 0.9, a: [[60.4, 0], [60.9, 1], [61.6, 1], [61.9, 0]] }],
      world(ctx, t, c, ph) { if (ph !== 'over') return; const p = sstep((t - 59.4) / 1.0); glow(ctx, 306, 148, 70, '255,230,150', 0.5 * p); bubblesWorld(ctx, t, 26, 51, 200, 380, 60, 230, 1.0); sparklesWorld(ctx, t, 50, 52, 200, 60, 380, 230, '190,245,255', 1); },
      screen(ctx, t) { godRays(ctx, t, 0.4, W * 0.5, -20, 7, 0.9, H, '210,250,255'); },
    });
    // 13 sièges
    const PIL = [[107, 168], [106, 68], [136, 46], [174, 21], [212, 7], [249, 7], [327, 7], [364, 7], [402, 21], [440, 44], [470, 66], [469, 168], [288, 160]]; // 13 sièges (haut des piliers d'OPM3)
    function flames(ctx, t, ign) { // flammes sombres des 13 sièges = sprite généré (8 images de flicker)
      for (let i = 0; i < PIL.length; i++) {
        const k = sstep(ign[i]); if (k <= 0) continue; const x = PIL[i][0], y = PIL[i][1] - 3, sc = 0.62 * (0.4 + 0.6 * k);
        glow(ctx, x, y - 8, 46, '255,90,200', 0.6 * k * (0.75 + 0.25 * Math.sin(t * 8 + i)));
        fx(ctx, 'flame', t * 12 + i * 3, x, y, sc, 1, { bottom: true, mat: Math.min(1, k * 1.25) }); if (k < 0.97) matBurst(ctx, x, y - 14, k, '255,120,230', 0.7);
        fx(ctx, 'flame', t * 12 + i * 3 + 4, x, y - 2, sc * 1.05, 0.35 * k, { bottom: true, add: true });
      }
    }
    SC.push({
      id: '3d', t0: 62, t1: 68, map: 'opm3', water: [60, 290, 0.5, 0.4], grade: 'rgb(200,200,240)',
      cam: [[62, 110, 160, 2.4, 0.05], [63.5, 120, 60, 2.2, -0.04], [65, 230, 45, 2.0, 0.03], [66, 390, 45, 1.8, -0.03], [67, 470, 110, 1.6, 0.03], [68, 288, 170, 1.1, 0.0]],
      world(ctx, t, c, ph) { if (ph !== 'over') return; const u = t - 62; flames(ctx, t, PIL.map((_, i) => clamp((u - (0.3 + i * 0.42)) / 0.5, 0, 1))); },
      screen(ctx, t) { particlesScreen(ctx, t, { n: 40, rgb: '255,120,220', a: 0.8, r: 2, vy: -1.0, add: true, tw: true }); },
    });

    // ---- Chapitre IV : le combat de l'arène (décor peint animé, Méga-Évolution, explosion) ----
    const AR = (EV.catalog && EV.catalog.arena) || null, AKX = MW / (AR ? AR.dw : 1376), AKY = MH / (AR ? AR.dh : 768);
    const ARC = { x: 288, y: 170, a: 215, b: 106 }; // dais : centre et demi-axes en unités du monde
    const EYE = AR ? [AR.eye[0] * AKX, AR.eye[1] * AKY] : [288, 155];
    const mistK = (t) => (t < 91.4 ? 1 : t < 98 ? 1 - 0.85 * sstep((t - 91.4) / 1.0) : 0.15 + 0.85 * sstep((t - 98) / 4));
    function arImg(ctx, key, x, y, s, a, o) { // image seule (anneau, orbe, boules du soleil RRT) centrée en (x,y)
      const im = I[key]; if (!im || !im.width || a <= 0.003) return; o = o || {};
      ctx.save(); ctx.globalAlpha = clamp(a, 0, 1); if (o.add !== false) ctx.globalCompositeOperation = 'lighter'; ctx.imageSmoothingEnabled = false;
      ctx.translate(x, y); if (o.rot) ctx.rotate(o.rot); ctx.scale(s * (o.sx || 1), s * (o.sy || 1)); ctx.drawImage(im, -im.width / 2, -im.height / 2); ctx.restore();
    }
    const ROCKS = AR ? AR.rocks.map((r, i) => ({ r, ph: rnd(i, 91) * TAU, w: 0.07 + rnd(i, 92) * 0.05, ka: 1 + rnd(i, 93) * 0.1, sc: 0.3 + rnd(i, 94) * 0.1, tilt: (rnd(i, 95) - 0.5) * 0.5 })) : [];
    function rockPos(R, t) { const ph = R.ph + t * R.w, a = 262 * R.ka, b = 134 * R.ka; return { x: ARC.x + a * Math.cos(ph), y: ARC.y + 4 + b * Math.sin(ph) + Math.sin(t * 0.9 + R.ph) * 4, d: Math.sin(ph) }; }
    function rocks(ctx, t, front) { // les roches dérivent en orbite autour de l'arène, sans jamais la toucher
      const im = I.arRocks; if (!im || !im.width) return;
      for (const R of ROCKS) {
        const p = rockPos(R, t); if ((p.d > 0) !== front) continue;
        const s = R.sc * (0.82 + 0.3 * p.d) * (MW / (AR.rw || 1364)) * 2.2, [sx, sy, sw, sh] = R.r;
        ctx.save(); ctx.imageSmoothingEnabled = true; ctx.translate(p.x, p.y); ctx.rotate(R.tilt + Math.sin(t * 0.6 + R.ph) * 0.08); ctx.scale(s, s);
        ctx.globalAlpha = 0.9 + 0.1 * p.d; ctx.drawImage(im, sx, sy, sw, sh, -sw / 2, -sh / 2, sw, sh);
        ctx.restore();
      }
    }
    function arenaBack(ctx, t) { // vortex de nuages en spirale autour de l'arène + roches du fond + dais
      const v = I.arVortex, d = I.arDais; if (!v || !d) { drawMap(ctx, 'opm3', t); return; }
      ctx.fillStyle = '#120c26'; ctx.fillRect(-300, -200, MW + 600, MH + 400);
      ctx.save(); ctx.imageSmoothingEnabled = true; ctx.translate(EYE[0], EYE[1]); ctx.scale(1, 0.55); ctx.rotate(t * 0.14); ctx.scale(1, 1 / 0.55); ctx.scale(1.5, 1.5); ctx.translate(-EYE[0], -EYE[1]);
      ctx.drawImage(v, 0, 0, MW, MH); ctx.restore();
      ctx.save(); ctx.imageSmoothingEnabled = true; ctx.translate(EYE[0], EYE[1]); ctx.scale(1, 0.55); ctx.rotate(-t * 0.05 + 1.3); ctx.scale(1, 1 / 0.55); ctx.scale(1.9, 1.9); ctx.translate(-EYE[0], -EYE[1]);
      ctx.globalAlpha = 0.22; ctx.globalCompositeOperation = 'screen'; ctx.drawImage(v, 0, 0, MW, MH); ctx.restore(); // seconde couche à contre-sens : profondeur
      rocks(ctx, t, false);
      ctx.save(); ctx.imageSmoothingEnabled = true; ctx.drawImage(d, 0, 0, MW, MH); ctx.restore();
    }
    function mistLayer(ctx, t, lo) { // brume noire qui imprègne l'arène : elle rampe des bords vers le cercle en spirale
      const im = I.arMist; if (!im || !im.width) return; const k = mistK(t);
      for (let i = 0; i < 16; i++) {
        if ((i & 1) !== (lo ? 1 : 0)) continue;
        const u = (t * (0.035 + rnd(i, 3) * 0.03) + rnd(i, 1)) % 1, rf = 1.3 - 1.15 * u, ph = rnd(i, 2) * TAU + t * 0.22 - u * 2.6, al = Math.sin(Math.PI * u) * (lo ? 0.8 : 0.55) * k;
        const x = ARC.x + rf * ARC.a * Math.cos(ph), y = ARC.y + 8 + rf * ARC.b * Math.sin(ph), w = (110 + rnd(i, 4) * 120) * (lo ? 1 : 0.8);
        ctx.save(); ctx.globalAlpha = clamp(al, 0, 1); ctx.imageSmoothingEnabled = true; ctx.translate(x, y); ctx.rotate(Math.sin(t * 0.3 + i) * 0.15); ctx.drawImage(im, -w / 2, -w / 4, w, w / 2); ctx.restore();
      }
    }
    function crystalsAndRune(ctx, t, runeRgb, runeK) { // cristaux qui palpitent + cercle magique qui bat au tempo
      if (!AR) return; runeRgb = runeRgb || '200,90,255'; const bt = 0.5 + 0.5 * Math.cos(((t % BEAT) / BEAT) * TAU), rk = runeK == null ? 1 : runeK;
      AR.crystals.forEach((c, i) => {
        const x = c[0] * AKX, y = c[1] * AKY, p = 0.55 + 0.45 * Math.sin(t * (2.2 + rnd(i, 7)) + i * 1.9);
        glow(ctx, x, y, c[2] * AKX * 2.4, '190,90,255', 0.38 * p);
        const sp = ((t * (0.5 + rnd(i, 8) * 0.4) + rnd(i, 9)) % 1);
        fx(ctx, 'sparkle', sp * 8, x + (rnd(i, 10) - 0.5) * 8, y - sp * 16, 0.28, 1 - sp, { add: true, tint: '220,150,255' });
      });
      const cx = AR.rune[0] * AKX, cy = AR.rune[1] * AKY, rx = AR.rune[2] * AKX;
      ctx.save(); ctx.translate(cx, cy); ctx.scale(1, 0.53); glow(ctx, 0, 0, rx * (1.2 + 0.2 * bt), runeRgb, (0.14 + 0.12 * bt) * rk); ctx.restore();
      const u = (t * 0.6) % 1; ring(ctx, cx, cy, rx * (0.9 + u * 1.1), 1.2, runeRgb, 0.4 * (1 - u) * rk, 0.53);
      ctx.save(); ctx.translate(cx, cy); ctx.scale(1, 0.53); ctx.rotate(t * 0.5); starBurst(ctx, 0, 0, rx * 1.1, 0.1 * rk * (0.6 + 0.4 * bt), 6, 0); ctx.restore();
    }
    function boltShape(s, x0, y0, x1, y1, n, jag) { // éclair déchiqueté, forme fixée par la graine
      const pts = [[x0, y0]]; const dx = x1 - x0, dy = y1 - y0, L = Math.hypot(dx, dy) || 1, nx = -dy / L, ny = dx / L;
      for (let i = 1; i < n; i++) { const u = i / n, o = (rnd(s, 20 + i) - 0.5) * jag * (1 - Math.abs(u - 0.5) * 0.6); pts.push([x0 + dx * u + nx * o, y0 + dy * u + ny * o]); }
      pts.push([x1, y1]); return pts;
    }
    function strokeBolt(ctx, pts, a, w) {
      ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.lineJoin = 'round'; ctx.lineCap = 'round';
      for (const [lw, col] of [[w * 3.2, `rgba(150,70,255,${(a * 0.38).toFixed(3)})`], [w * 1.5, `rgba(205,150,255,${(a * 0.6).toFixed(3)})`], [w * 0.6, `rgba(255,248,255,${a.toFixed(3)})`]]) {
        ctx.strokeStyle = col; ctx.lineWidth = lw; ctx.beginPath(); pts.forEach((p, i) => (i ? ctx.lineTo(p[0], p[1]) : ctx.moveTo(p[0], p[1]))); ctx.stroke();
      }
      ctx.restore();
    }
    const BSLOT = 0.34;
    function skyBolts(ctx, t, sc, n) { // éclairs un peu partout dans les nuages et sur les roches
      let fl = 0;
      for (let k = Math.floor(t / BSLOT) - 1; k <= Math.floor(t / BSLOT); k++) for (let j = 0; j < (n || 3); j++) {
        const s = k * 11 + j * 3, tb = (k + rnd(s, 1) * 0.85) * BSLOT, d = t - tb; if (d < 0 || d > 0.24) continue;
        const cc = cr(sc.cam, clamp(tb, sc.t0, sc.t1)), x0 = cc[0] + (rnd(s, 2) - 0.5) * 330 / cc[2], y0 = cc[1] - 105 / cc[2], x1 = x0 + (rnd(s, 3) - 0.5) * 110, y1 = cc[1] + (rnd(s, 4) - 0.55) * 120 / cc[2];
        const a = (1 - d / 0.24) * (0.55 + 0.45 * (Math.floor(d * 60) % 2)); fl = Math.max(fl, a);
        const pts = boltShape(s, x0, y0, x1, y1, 9, 22 / Math.sqrt(cc[2])); strokeBolt(ctx, pts, a, 0.9);
        const m = pts[4], f = boltShape(s + 1, m[0], m[1], m[0] + (rnd(s, 5) - 0.5) * 70, m[1] + 40, 5, 12); strokeBolt(ctx, f, a * 0.7, 0.6);
        glow(ctx, x1, y1, 46, '190,120,255', 0.55 * a);
      }
      return fl;
    }
    function boltFlash(t, n) { let fl = 0; for (let k = Math.floor(t / BSLOT) - 1; k <= Math.floor(t / BSLOT); k++) for (let j = 0; j < (n || 3); j++) { const s = k * 11 + j * 3, d = t - (k + rnd(s, 1) * 0.85) * BSLOT; if (d >= 0 && d < 0.24) fl = Math.max(fl, (1 - d / 0.24) * (0.55 + 0.45 * (Math.floor(d * 60) % 2))); } return fl; }
    function arenaOver(ctx, t, sc) { mistLayer(ctx, t, false); rocks(ctx, t, true); const f = skyBolts(ctx, t, sc, 3); if (f > 0.05) { ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.fillStyle = `rgba(120,70,200,${(0.1 * f).toFixed(3)})`; ctx.fillRect(-300, -200, MW + 600, MH + 400); ctx.restore(); } }
    // ---- Méga-Évolution : hélices de lumière, anneau et orbes du soleil RRT, piliers de rayons ----
    function pillarBeams(ctx, t, x, y, w, h, a, rgb) { const im = tintRays(rgb); if (!im || a <= 0.003) return;
      ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.imageSmoothingEnabled = true;
      for (let i = 0; i < 3; i++) { ctx.globalAlpha = clamp(a * 0.75 * (0.55 + 0.45 * Math.sin(t * (1.5 + i) + i * 2)), 0, 1); ctx.save(); ctx.translate(x + (i - 1) * w * 0.12, y); ctx.scale(w / 212 * (1 - i * 0.18), -h / 200); ctx.drawImage(im, -106, 0); ctx.restore(); }
      ctx.restore(); }
    function megaFx(ctx, t, x, y, k, u) { // k 0→1 : montée de l'énergie ; u = secondes depuis la libération
      const hue = (i) => ['255,90,120', '255,200,90', '120,255,170', '110,200,255', '210,130,255'][i % 5];
      if (k > 0 && k < 1.001) for (let i = 0; i < 44; i++) {
        const ph = ((t * 0.8 + i / 44) % 1), r = (1 - ph) * (80 - 20 * k), an = (i % 2 ? 1 : -1) * (ph * 8.5) + i * 0.6, px = x + Math.cos(an) * r, py = y - 22 + Math.sin(an) * r * 0.55 - (1 - ph) * 12 * (i % 2 ? 1 : -1);
        fx(ctx, 'sparkle', ph * 8, px, py, 0.3 + 0.2 * k, k * (0.4 + 0.6 * ph), { add: true, tint: hue(i) });
      }
      if (k > 0) {
        const p = 0.5 + 0.5 * Math.sin(t * 9); arImg(ctx, 'sunOrb', x, y - 24, (0.14 + 0.26 * k) * (0.9 + 0.15 * p), 0.7 * Math.min(1, k * 1.4), { add: true });
        glow(ctx, x, y - 24, 22 + 42 * k, '255,236,150', 0.34 * k);
        for (let i = 0; i < 5; i++) { const an = t * 4.5 * (i % 2 ? 1 : -1) + i * 1.26, r = (60 - 28 * k) * (0.7 + 0.3 * Math.sin(t * 3 + i)); arImg(ctx, i % 2 ? 'sunBallA' : 'sunBallB', x + Math.cos(an) * r, y - 22 + Math.sin(an) * r * 0.5, 0.22 + 0.14 * k, 0.9 * k, { add: true }); }
        arImg(ctx, 'sunRing', x, y - 4, 0.32 + 0.3 * k + 0.05 * Math.sin(t * 6), 0.6 * k, { sy: 0.45 });
        arImg(ctx, 'sunRing', x, y - 26, 0.22 + 0.25 * k, 0.5 * k, { rot: t * 1.3 });
        pillarBeams(ctx, t, x, y - 2, 34 + 26 * k, 110 + 70 * k, 0.4 * k, '255,236,170');
      }
      if (u != null && u >= 0) {
        const e = sstep(u / 1.3);
        arImg(ctx, 'sunRing', x, y - 24, 0.3 + 2.4 * e, 0.9 * (1 - e), { rot: u });
        arImg(ctx, 'sunRing', x, y - 4, 0.4 + 3.2 * sstep(u / 1.6), 0.9 * (1 - sstep(u / 1.6)), { sy: 0.45 });
        ring(ctx, x, y - 6, u * 140, 2.2, '255,246,200', 0.8 * Math.exp(-u * 1.6), 0.5);
        starBurst(ctx, x, y - 24, 30 + 90 * e, 0.8 * (1 - e), 12, u * 0.4);
        glow(ctx, x, y - 24, 40 + 110 * e, '255,240,170', 0.6 * (1 - e));
        pillarBeams(ctx, t, x, y - 2, 60, 200, 0.5 * (1 - sstep(u / 2.2)), '255,246,200');
      }
    }
    const TINTR = {};
    function tintRays(rgb) { const im = I.rrRays; if (!im || !im.width) return null; if (TINTR[rgb]) return TINTR[rgb];
      const c = mk(im.width, im.height), g = c.getContext('2d'); g.drawImage(im, 0, 0); g.globalCompositeOperation = 'multiply'; g.fillStyle = `rgb(${rgb})`; g.fillRect(0, 0, c.width, c.height); return (TINTR[rgb] = c); }
    const HER = { x: 232, y: 178 };
    const PAL_ARENA = 'rgb(236,226,255)';
    // 4a — Darkrai surgit des nuées, les trois héros lèvent les yeux
    SC.push({
      id: '4a', t0: 68, t1: 77, map: 'opm3', melee: false, grade: PAL_ARENA,
      cam: [[68, 250, 150, 0.85, 0.0], [71.5, 288, 150, 1.15, 0.02], [74.5, 300, 150, 1.4, -0.02], [77, 296, 150, 1.5, 0.0]],
      actors: [
        { id: 'evoli', pid: '0133', keys: [[68, 130, 200], [71.3, 232, 198]], an: [[68, 'Walk', 'auto'], [71.4, 'Idle', 2], [72.4, 'LookUp', 2, { loop: false }], [74.3, 'Hop', 2, { loop: false }], [75.4, 'Hurt', 2, { loop: false }]], reflect: false, aura: '130,235,255' },
        { id: 'riolu', pid: '0447', keys: [[68, 108, 186], [71.0, 204, 182]], an: [[68, 'Walk', 'auto'], [71.1, 'Idle', 2], [72.4, 'LookUp', 2, { loop: false }], [75.4, 'Hurt', 2, { loop: false }]] },
        { id: 'tiplouf', pid: '0393', keys: [[68, 120, 212], [71.5, 260, 208]], an: [[68, 'Walk', 'auto'], [71.6, 'Idle', 2], [72.6, 'LookUp', 2, { loop: false }], [74.4, 'Hop', 2, { loop: false }], [75.5, 'Hurt', 2, { loop: false }]] },
        { id: 'darkrai', pid: '0491', keys: [[68, 350, 50, 90], [72.6, 346, 158, 8], [77, 346, 158, 6]], an: [[68, 'Charge', 6], [72.8, 'Attack', { toId: 'evoli' }, { loop: false }], [74.0, 'Charge', { toId: 'evoli' }]], a: [[68, 0], [70, 1]], aura: '190,40,255', s: 1.1 },
      ],
      draw(ctx, t) { arenaBack(ctx, t); },
      world(ctx, t, c, ph) {
        if (ph === 'under') { crystalsAndRune(ctx, t); mistLayer(ctx, t, true); return; }
        const u = t - 72.6; if (u > 0 && u < 1.3) { ring(ctx, 346, 158, u * 120, 3, '170,70,255', 0.8 * (1 - u / 1.3), 0.5); glow(ctx, 346, 130, 60 * (1 - u / 1.3), '150,60,230', 0.5); }
        arenaOver(ctx, t, this); fightFx(ctx, t);
      },
      screen(ctx, t) { particlesScreen(ctx, t, { n: 28, rgb: '190,150,255', a: 0.7, r: 1.8, vy: -0.8, vx: -0.6, add: true, tw: true }); flash(ctx, 0.07 * boltFlash(t, 3), '170,120,255'); flash(ctx, 0.5 * Math.exp(-Math.abs(t - 72.6) * 7), '210,160,255'); flash(ctx, 0.6 * (1 - sstep((t - 68) / 0.7)), '255,255,255'); },
    });
    // 4b — mêlée : Évoli, Riolu et Tiplouf contre les ombres, Darkrai bombarde
    const SHD = (id, pid, keys, an, a) => ({ id, pid, keys, an, a, aura: '190,60,255' });
    SC.push({
      id: '4b', t0: 77, t1: 88, map: 'opm3', melee: true, grade: PAL_ARENA,
      cam: [[77, 296, 150, 1.5, 0.0], [79.5, 290, 156, 1.7, 0.05], [82, 288, 160, 1.9, -0.05], [85, 270, 160, 1.7, 0.04], [88, 252, 166, 1.6, 0.0]],
      actors: [
        { id: 'evoli', pid: '0133', keys: [[77, 232, 198], [78.0, 262, 188], [79.0, 292, 176], [80.6, 262, 190], [82.4, 298, 178], [83.4, 252, 196], [86, 238, 200], [88, 238, 200]],
          an: [[77, 'Double', 'auto', { loop: false }], [78.0, 'Attack', { to: [302, 174] }, { loop: false }], [79.6, 'Walk', 'auto'], [80.8, 'Swing', { to: [316, 196] }, { loop: false }], [82.2, 'Attack', { to: [322, 176] }, { loop: false }], [83.4, 'Hurt', 6, { loop: false }], [84.6, 'Pain', 6, { loop: false }], [86.2, 'Idle', 6]], aura: '130,235,255' },
        { id: 'riolu', pid: '0447', keys: [[77, 204, 182], [79, 238, 178], [80.6, 214, 180], [82.2, 262, 176], [84, 240, 184], [85.6, 190, 190], [88, 170, 194]],
          an: [[77, 'Idle', 2], [78.8, 'Attack', { to: [300, 172] }, { loop: false }], [80.6, 'Walk', 'auto'], [82.0, 'Strike', { to: [310, 176] }, { loop: false }], [84.0, 'Hurt', 2, { loop: false }], [85.6, 'Pain', 2, { loop: false }], [87.0, 'Hurt', 2]] },
        { id: 'tiplouf', pid: '0393', keys: [[77, 260, 208], [80, 276, 202], [82, 282, 200], [85.4, 268, 208], [88, 250, 210]],
          an: [[77, 'Idle', 2], [80.7, 'Shoot', { to: [320, 190] }, { loop: false }], [83.2, 'Hurt', 2, { loop: false }], [85.4, 'Hurt', 2, { loop: false }], [87, 'Idle', 6]] },
        SHD('sriolu', 'shadow_0447', [[77, 306, 172], [80.4, 314, 172], [83, 300, 178], [87.2, 300, 178]], [[77, 'Idle', 6], [79.0, 'Hurt', 6, { loop: false }], [81.6, 'Attack', { toId: 'evoli' }, { loop: false }], [86.2, 'Hurt', 6, { loop: false }]], [[77, 1], [86.6, 1], [87.8, 0]]),
        SHD('stiplouf', 'shadow_0393', [[77, 320, 198], [81, 322, 194], [84, 306, 196], [87.2, 306, 196]], [[77, 'Idle', 6], [79.4, 'Swing', { toId: 'evoli' }, { loop: false }], [82.6, 'Hurt', 6, { loop: false }], [84.6, 'Attack', { toId: 'tiplouf' }, { loop: false }]], [[77, 1], [86.6, 1], [87.8, 0]]),
        { id: 'darkrai', pid: '0491', keys: [[77, 346, 158, 6], [84, 336, 160, 8], [88, 336, 160, 6]], an: [[77, 'Idle', 6], [79.0, 'Attack', { toId: 'evoli' }, { loop: false }], [82.6, 'Shoot', { toId: 'riolu' }, { loop: false }], [84.4, 'Attack', { toId: 'riolu' }, { loop: false }], [86.0, 'Charge', 6]], aura: '190,40,255', s: 1.1 },
      ],
      draw(ctx, t) { arenaBack(ctx, t); },
      world(ctx, t, c, ph) {
        if (ph === 'under') { crystalsAndRune(ctx, t); mistLayer(ctx, t, true); return; }
        arenaOver(ctx, t, this); fightFx(ctx, t);
        for (const ti of IMPACTS) { const d = t - ti; if (ti >= 77 && ti < 88 && d >= 0 && d < 0.4 && !covered(ti)) { const ix = 292 + (rnd(ti, 1) - 0.5) * 40, iy = 176 + (rnd(ti, 2) - 0.5) * 18; hitFx(ctx, ix, iy, d, ti); glow(ctx, ix, iy, 34, '255,240,180', 0.8 * (1 - d / 0.4)); ring(ctx, ix, iy + 8, d * 90, 1.2, '230,255,255', 0.8 * (1 - d / 0.4), 0.4); } }
        const dsp = sstep((t - 86.6) / 1.2); if (dsp > 0 && dsp < 1) for (let i = 0; i < 24; i++) { const ph2 = ((t - 86.6) * 0.8 + rnd(i, 3)) % 1; fx(ctx, 'sparkle', ph2 * 8, 300 + (rnd(i, 1) - 0.5) * 40, 190 - ph2 * 50, 0.3, 0.8 * (1 - ph2), { add: true, tint: '190,60,255' }); }
      },
      screen(ctx, t) { particlesScreen(ctx, t, { n: 28, rgb: '190,150,255', a: 0.6, r: 1.6, vy: -0.8, vx: -1.2, add: true, tw: true }); speedLines(ctx, t, 14, W / 2, H / 2, '230,210,255', 0.2, 280); flash(ctx, 0.07 * boltFlash(t, 3), '170,120,255');
        for (const ti of IMPACTS) { const d = t - ti; if (ti >= 77 && ti < 88 && d >= 0 && d < 0.1) impactFrame(ctx, 1 - d / 0.11); } },
    });
    // 4c — Riolu se relève : Lucario, puis Méga-Lucario dans un déluge de lumière
    const LUX = 214, LUY = 178;
    SC.push({
      id: '4c', t0: 88, t1: 98, map: 'opm3', melee: false, grade: PAL_ARENA,
      cam: [[88, 232, 172, 1.9, 0.0], [90.5, 218, 168, 2.2, 0.0], [92.6, 214, 166, 2.4, 0.02], [94.2, 214, 166, 2.4, 0.0], [95.5, 214, 164, 2.2, 0.0], [96.4, 220, 160, 1.9, -0.03], [98, 250, 160, 1.5, 0.0]],
      actors: [
        { id: 'evoli', pid: '0133', keys: [[88, 238, 200], [98, 246, 202]], an: [[88, 'Pain', 6, { loop: false }], [92.0, 'LookUp', 2, { loop: false }], [95.6, 'Hop', 2, { loop: false }]], aura: '130,235,255' },
        { id: 'tiplouf', pid: '0393', keys: [[88, 250, 210], [98, 262, 212]], an: [[88, 'Hurt', 2, { loop: false }], [92.4, 'LookUp', 2, { loop: false }], [95.8, 'Hop', 2, { loop: false }]] },
        { id: 'riolu', pid: '0447', keys: [[88, 170, 194], [90.0, 176, 190], [91.5, LUX, LUY]], an: [[88, 'Hurt', 2, { loop: false }], [89.6, 'Pain', 2, { loop: false }], [90.4, 'Charge', 2]], a: [[88, 1], [91.4, 1], [91.6, 0]], aura: '120,230,255' },
        { id: 'lucario', pid: '0448', keys: [[91.4, LUX, LUY], [95.6, LUX, LUY]], an: [[91.4, 'Charge', 2], [93.0, 'Idle', 2], [94.2, 'Charge', 2]], a: [[91.4, 0], [91.7, 1], [95.4, 1], [95.7, 0]], aura: '110,230,255' },
        { id: 'mega', pid: '9448', keys: [[95.4, LUX, LUY], [98, LUX + 6, LUY + 2]], an: [[95.4, 'Charge', 2], [96.4, 'RearUp', 2, { loop: false }], [97.4, 'Idle', 2]], a: [[95.4, 0], [95.8, 1]], aura: '255,226,120' },
        { id: 'darkrai', pid: '0491', keys: [[88, 336, 160, 6], [98, 336, 160, 6]], an: [[88, 'Idle', 6], [92.2, 'Shoot', { to: [222, 176] }, { loop: false }], [94.0, 'Charge', 6]], aura: '190,40,255', s: 1.1 },
      ],
      draw(ctx, t) { arenaBack(ctx, t); },
      world(ctx, t, c, ph) {
        const k1 = sstep((t - 89.2) / 2.2) * (t < 91.6 ? 1 : 0), k2 = sstep((t - 93.0) / 2.5) * (t < 95.6 ? 1 : 0), u = t - 95.6;
        if (ph === 'under') { crystalsAndRune(ctx, t, t < 91.5 ? '200,90,255' : '255,226,120', 0.6 + 0.8 * sstep((t - 91.4) / 2)); mistLayer(ctx, t, true);
          if (k1 > 0) { glow(ctx, 176, 190, 30 * k1 + 12, '200,245,255', 0.4 * k1); pillarBeams(ctx, t, 176, 190, 34, 120 * k1, 0.4 * k1, '180,240,255'); }
          return; }
        arenaOver(ctx, t, this);
        const ev = t - 91.5; if (ev > 0 && ev < 1.4) { const e = sstep(ev / 1.4); starBurst(ctx, LUX, LUY - 22, 26 + 80 * e, 0.8 * (1 - e), 10, ev); ring(ctx, LUX, LUY - 4, ev * 90, 2, '200,250,255', 0.8 * (1 - e), 0.5); glow(ctx, LUX, LUY - 22, 50 * (1 - e) + 14, '210,250,255', 0.6 * (1 - e)); pillarBeams(ctx, t, LUX, LUY - 2, 44, 150 * (1 - e * 0.4), 0.5 * (1 - e), '200,248,255'); }
        if (t >= 91.6 && t < 95.7) megaFx(ctx, t, LUX, LUY, k2, null); else if (t >= 95.7) megaFx(ctx, t, LUX + 3, LUY, 0, u);
      },
      screen(ctx, t) {
        particlesScreen(ctx, t, { n: 28, rgb: '255,230,150', a: 0.8, r: 1.8, vy: -1.0, add: true, tw: true });
        flash(ctx, 0.07 * boltFlash(t, 3), '170,120,255');
        flash(ctx, 0.7 * Math.exp(-Math.abs(t - 91.5) * 8), '220,252,255');
        const f2 = t - 95.55; flash(ctx, f2 > -0.35 && f2 < 0 ? 0.1 * (1 + f2 / 0.35) : 0.8 * Math.exp(-Math.max(0, f2) * 5) * (f2 >= 0 ? 1 : 0), '255,248,210');
        const sf = t - 95.7; if (sf > 0 && sf < 2.4) { const a = Math.sin(Math.PI * clamp(sf / 2.4, 0, 1)); fx(ctx, 'sunfl', sf * 8, W * 0.28, H * 0.12, 4.2, 0.9 * a, { add: true }); }
        if (t > 95.6 && t < 97.4) speedLines(ctx, t, 26, W * 0.5, H * 0.55, '255,240,190', 0.35 * (1 - (t - 95.6) / 1.8), 220);
      },
    });
    // 4d — Méga-Lucario au premier plan face à Darkrai : choc des sphères, explosion, retour au plan suivant
    const CLX = 302, CLY = 160, TEXP = 103.3;
    SC.push({
      id: '4d', t0: 98, t1: 106, map: 'opm3', melee: true, grade: PAL_ARENA,
      cam: [[98, 272, 160, 1.45, 0.0], [99.4, 268, 166, 1.55, 0.03], [101.0, 272, 164, 1.65, -0.04], [102.6, 276, 162, 1.8, 0.0], [103.3, 282, 162, 1.7, 0.05], [104.4, 296, 162, 1.1, 0.0], [106, 296, 162, 0.9, 0.0]],
      shake: (t) => (t > 101 && t < TEXP ? 0.8 + (t - 101) * 1.5 : t >= TEXP && t < TEXP + 0.9 ? 6 * Math.exp(-(t - TEXP) * 3) : 0),
      actors: [
        { id: 'mega', pid: '9448', keys: [[98, 208, 206], [106, 208, 206]], sk: [[98, 1.55], [106, 1.7]], an: [[98, 'Idle', { toId: 'darkrai' }], [99.1, 'Charge', { toId: 'darkrai' }], [100.2, 'Attack', { toId: 'darkrai' }, { loop: false }], [101.6, 'Charge', { toId: 'darkrai' }]], aura: '255,226,120' },
        { id: 'darkrai', pid: '0491', keys: [[98, 340, 158, 8], [106, 340, 158, 8]], s: 1.0, an: [[98, 'Idle', { toId: 'mega' }], [99.0, 'Charge', { toId: 'mega' }], [100.1, 'Attack', { toId: 'mega' }, { loop: false }], [101.6, 'Charge', { toId: 'mega' }]], aura: '190,40,255' },
      ],
      draw(ctx, t) { arenaBack(ctx, t); },
      world(ctx, t, c, ph) {
        const ex = t - TEXP;
        if (ph === 'under') { crystalsAndRune(ctx, t, '255,226,120', 1.2 + (ex > 0 ? 1.5 * Math.exp(-ex * 2) : 0)); mistLayer(ctx, t, true); return; }
        arenaOver(ctx, t, this); fightFx(ctx, t);
        const cl = t - 101.0;
        if (cl > 0 && ex < 0) { // choc des deux sphères : elle grossit, se tord et crache des arcs
          const g = clamp(cl / 2.3, 0, 1), r = lerp(12, 62, g * g), a = 0.55 + 0.45 * Math.sin(t * 60);
          glow(ctx, CLX, CLY, r * 2.4, '255,236,170', 0.16 + 0.16 * g); glow(ctx, CLX, CLY, r * 1.8, '180,90,255', 0.3 + 0.2 * g);
          fx(ctx, 'aurasphere', t * 16, CLX - 4 - 4 * g, CLY, 0.5 * (1 + 2.0 * g), 1, {}); fx(ctx, 'shadowball', t * 16, CLX + 4 + 4 * g, CLY, 0.5 * (1 + 2.0 * g), 0.95, {});
          arImg(ctx, 'sunRing', CLX, CLY, 0.25 + 0.7 * g, 0.55, { sy: 0.8 });
          for (let i = 0; i < 4; i++) { const s = Math.floor(t * 30) * 5 + i, ang = rnd(s, 1) * TAU, L = r * (1 + rnd(s, 2) * 1.6); strokeBolt(ctx, boltShape(s, CLX, CLY, CLX + Math.cos(ang) * L, CLY + Math.sin(ang) * L * 0.7, 6, 10), 0.7 * a, 0.8); }
          strokeBolt(ctx, boltShape(Math.floor(t * 30), 222, 176, CLX, CLY, 7, 8), 0.7, 0.7); strokeBolt(ctx, boltShape(Math.floor(t * 30) + 9, 336, 150, CLX, CLY, 7, 8), 0.7, 0.7);
          ring(ctx, CLX, CLY, r * (1 + 0.3 * Math.sin(t * 20)), 1.6, '255,246,210', 0.7, 0.8);
        }
        if (ex > 0) { // explosion : la boule de feu du météore RRT, ondes de choc, éclats, flammes
          const e = clamp(ex / 1.6, 0, 1), ee = 1 - Math.pow(1 - e, 2.4);
          glow(ctx, CLX, CLY, 40 + 420 * ee, '255,180,70', 0.9 * (1 - e * 0.5)); glow(ctx, CLX, CLY, 30 + 230 * ee, '255,246,200', 0.95 * (1 - e * 0.3));
          fx(ctx, 'rrmet', ex * 12, CLX, CLY + 10, 0.25 + 1.5 * ee, 1 - 0.35 * e, {});
          fx(ctx, 'rrmet', ex * 12 + 4, CLX, CLY, 0.15 + 1.05 * ee, 0.9, { add: true });
          for (let i = 0; i < 3; i++) ring(ctx, CLX, CLY + 8, Math.max(0.5, ex - i * 0.12) * (260 + i * 60), 4 - i, i === 1 ? '255,230,160' : '255,250,230', 0.9 * Math.exp(-ex * 1.1), 0.5);
          starBurst(ctx, CLX, CLY, 60 + 300 * ee, 0.9 * (1 - e), 14, ex * 0.5);
          shardsW(ctx, CLX, CLY, ex * 1.4, 40, 77, ['#ffd45a', '#fff', '#ff8a3a', '#b46bff', '#6ae8ff'], 150, 4);
          for (let i = 0; i < 9; i++) { const an = rnd(i, 5) * TAU, d = ee * (60 + rnd(i, 6) * 110); fx(ctx, 'flame', ex * 14 + i * 3, CLX + Math.cos(an) * d, CLY + Math.sin(an) * d * 0.55 + 12, 0.35 + 0.5 * ee, 0.9 * (1 - e * 0.8), { bottom: true }); }
          if (ex < 0.4) hitFx(ctx, CLX, CLY, ex, 5, '255,240,180', 1.8);
        }
      },
      screen(ctx, t) {
        particlesScreen(ctx, t, { n: 28, rgb: '255,230,150', a: 0.8, r: 1.8, vy: -1.0, add: true, tw: true });
        flash(ctx, 0.06 * boltFlash(t, 3), '170,120,255');
        const cl = t - 101; if (cl > 0 && t < TEXP) { speedLines(ctx, t, 30, W * 0.55, H * 0.5, '255,246,200', 0.12 + 0.3 * (cl / 2.3), 200 - 80 * (cl / 2.3)); flash(ctx, 0.12 * (cl / 2.3) * (0.5 + 0.5 * Math.sin(t * 40)), '255,240,200'); }
        const ex = t - TEXP; if (ex >= 0 && ex < 0.12) impactFrame(ctx, 1 - ex / 0.12);
        flash(ctx, ex > 0 ? clamp(0.6 * Math.exp(-ex * 6) + 0.99 * sstep((t - 104.5) / 0.9), 0, 1) : 0, '255,250,235');
      },
    });

    // ---- Chapitre V : chute céleste ----
    const SKY = (cx0, cy0, cx1, cy1) => [[106, cx0, cy0, 1.0, 0.5], [112, 288, 170, 1.3, -0.2], [118, 288, 165, 1.8, 0.1], [121, 288, 165, 2.4, 0.0]];
    SC.push({
      id: '5a', t0: 106, t1: 122, map: 'opm4', free: true, bg: '#04061a',
      cam: [[106, 288, 20, 1.3, 0.5], [110, 330, 130, 1.1, -0.35], [114, 250, 210, 1.2, 0.3], [118, 288, 170, 1.9, 0.0], [122, 288, 165, 2.6, 0.0]],
      actors: [
        { id: 'riolu', pid: '0447', keys: [[106, 0, 0]], attach: [[106, -30, 2], [118, -30, 4]], an: [[106, 'Sink', 0, { loop: false, hold: 21, speed: 0.6 }]], rot: [[106, 0.6], [110, -0.4], [114, 0.5], [118, 0.0]], s: 1.25, noShadow: true, aura: '120,200,255', vis: [105, 122] },
        { id: 'evoli', pid: '0133', keys: [[106, 0, 0]], attach: [[106, 0, -4], [118, 0, -2]], an: [[106, 'Sink', 0, { loop: false, hold: 21, speed: 0.6 }]], rot: [[106, -0.5], [110, 0.5], [114, -0.3], [118, 0.0]], s: 1.25, noShadow: true, aura: '120,230,255', vis: [105, 122] },
        { id: 'latias', pid: '0380', keys: [[108, 150, 70], [114, 200, 200]], an: [[108, 'Idle', 0]], noShadow: true, aura: '255,120,160', a: [[108, 0], [109, 0.85], [117, 0.85], [119, 0]], rot: [[108, 0.5], [114, -0.3]], vis: [107, 120], s: 0.9 },
        { id: 'latios', pid: '0381', keys: [[108, 430, 60], [114, 380, 190]], an: [[108, 'Idle', 0]], noShadow: true, aura: '120,160,255', a: [[108, 0], [109, 0.85], [117, 0.85], [119, 0]], rot: [[108, -0.5], [114, 0.3]], vis: [107, 120], s: 0.9 },
        { id: 'tiplouf', pid: '0393', keys: [[106, 0, 0]], attach: [[106, 30, 4], [118, 30, 6]], an: [[106, 'Sink', 0, { loop: false, hold: 21, speed: 0.6 }]], rot: [[106, 0.4], [110, -0.6], [114, 0.3], [118, 0.0]], s: 1.25, noShadow: true, aura: '255,210,120', vis: [105, 122] },
      ],
      props: [{ img: 'wfCyan', keys: [[114, 262, 150, 0], [118, 282, 164, 0]], s: 0.8, a: [[114, 0], [115, 1]] }, { img: 'wfEmerald', rgb: '120,255,190', keys: [[114, 288, 140, 0], [118, 288, 160, 0]], s: 0.8, a: [[114, 0], [115, 1]] }, { img: 'wfAmber', rgb: '255,210,100', keys: [[114, 316, 150, 0], [118, 296, 164, 0]], s: 0.8, a: [[114, 0], [115, 1]] }],
      world(ctx, t, c, ph) { if (ph !== 'over') return; const k = sstep((t - 115) / 3); const kf = k * (1 - sstep((t - 117.6) / 0.8)); glow(ctx, 288, 164, 90, '255,235,170', 0.5 * kf); starBurst(ctx, 288, 164, 140, 0.4 * kf, 10, t * 0.4); sparklesWorld(ctx, t, 90, 91, 0, 0, 576, 320, '255,246,210', 1);
        const dk = sstep((t - 118) / 2.6); if (dk > 0) { const rr = dk * 380; ring(ctx, 288, 168, rr, 5, '190,90,255', 0.9 * (1 - sstep((t - 120.4) / 1.5)), 0.7); ctx.save(); ctx.fillStyle = `rgba(14,0,34,${(0.92 * sstep((t - 119.4) / 2.2)).toFixed(3)})`; ctx.beginPath(); ctx.arc(288, 168, rr, 0, TAU); ctx.fill(); ctx.restore(); } },
      shake: (t) => (t > 118 && t < 121 ? 4 * Math.exp(-(t - 118) * 1.0) : 0),
      screen(ctx, t) { speedLines(ctx, t, 60, W / 2, H / 2, '255,255,255', 0.5 * (1 - sstep((t - 117.5) / 2.5)), 250); particlesScreen(ctx, t, { n: 40, rgb: '255,250,230', a: 0.9, r: 3, vy: -9, add: false }); flash(ctx, 0.7 * Math.exp(-Math.abs(t - 118) * 7), '210,160,255'); ctx.fillStyle = `rgba(8,0,22,${(sstep((t - 120.5) / 1.2)).toFixed(3)})`; ctx.fillRect(0, 0, W, H); },
    });
    SC.push({
      id: '5b', t0: 122, t1: 132, map: 'opm4', free: true, bg: '#04010c', grade: 'rgb(120,100,200)',
      free: true, cam: [[122, 288, 168, 2.2, 0.0], [127, 288, 250, 1.7, 0.06], [132, 288, 340, 1.3, -0.05]],
      actors: [
        { id: 'evoli', pid: '0133', keys: [[122, 288, 168]], attach: [[122, 0, 0], [132, 0, 0]], an: [[122, 'Sink', 0, { loop: false, hold: 21, speed: 0.5 }]], rot: [[122, -0.3], [127, 0.15], [132, -0.2]], s: 1.5, noShadow: true, aura: '130,235,255', a: [[122, 1], [130, 1], [132, 0]] },
        { id: 'riolu', pid: '0447', keys: [[122, 262, 171], [124, 240, 168]].concat(Array.from({ length: 11 }, (_, i) => [126 + i * 0.5, 240, lerp(170, -40, sstep(i / 10))])), an: [[122, 'Float', 0, { speed: 0.6 }]], noShadow: true, aura: '120,200,255', vis: [121, 133] },
        { id: 'tiplouf', pid: '0393', keys: [[122, 314, 171], [124, 336, 168]].concat(Array.from({ length: 11 }, (_, i) => [126 + i * 0.5, 336, lerp(170, -40, sstep(i / 10))])), an: [[122, 'Float', 0, { speed: 0.6 }]], noShadow: true, aura: '255,210,120', vis: [121, 133] },
      ],
      world(ctx, t, c, ph) { if (ph !== 'over') return; const k = sstep((t - 123.5) / 1.6); const up = sstep((t - 126) / 5); const by = lerp(170, -40, up);
        barrierWorld(ctx, 240, by, 24, k, t); barrierWorld(ctx, 336, by, 24, k, t); if (t < 126) { ring(ctx, 240, 170, (t - 123.5) * 40, 1.6, '160,250,255', 0.8 * (1 - clamp((t - 123.5) / 2.5, 0, 1)), 1); ring(ctx, 336, 170, (t - 123.5) * 40, 1.6, '160,250,255', 0.8 * (1 - clamp((t - 123.5) / 2.5, 0, 1)), 1); }
        for (let i = 0; i < 16; i++) { const ph2 = ((t * 0.4 + rnd(i, 3)) % 1); const ey = lerp(160, 330, sstep((t - 122) / 10)); glow(ctx, 288 + (rnd(i, 4) - 0.5) * 50, ey - 14 - ph2 * 60, 4, '190,255,255', 0.7 * (1 - ph2)); } },
      screen(ctx, t) { particlesScreen(ctx, t, { n: 70, rgb: '170,120,255', a: 0.7, r: 2, vy: -2, add: true, tw: true }); },
    });

    SC.find((q) => q.id === '5b').custom = (ctx, t) => drawFall(ctx, t, { t0: 122, t1: 132, s0: 6.0, s1: 2.0, haloT: 0.9, fadeIn: 1.0, end: 'black',
      friends: [{ pid: '0447', side: -1, t0: 1.6, dur: 6.5, aura: '120,200,255' }, { pid: '0393', side: 1, t0: 1.6, dur: 6.5, aura: '255,210,120' }] });
    // ---- Chapitre VI : le Rayon d'Espoir ----
    SC.push({
      id: '6a', t0: 132, t1: 137, map: 'opm2', free: true, bg: '#010208', grade: 'rgb(80,120,200)',
      cam: [[132, 288, 130, 1.6, 0.04], [137, 288, 160, 2.8, -0.02]],
      actors: [{ id: 'evoli', pid: '0133', keys: [[132, 288, 152]], an: [[132, 'Sink', 0, { loop: false }], [134.6, 'Wake', 0, { loop: false }]], s: 1.0, aura: '130,235,255' }],
      props: [{ img: 'wfCyan', keys: [[132, 306, 150, 0]], s: 0.9 }],
      world(ctx, t, c, ph) { if (ph !== 'over') return; bubblesWorld(ctx, t, 26, 61, 200, 380, 40, 230, 1.0); sparklesWorld(ctx, t, 50, 62, 200, 40, 380, 230, '255,244,190', 1); },
      screen(ctx, t) { const ra = sstep((t - 133.4) / 3.2); godRays(ctx, t, 0.9 * ra, W * 0.52, -30, 7, 0.5 + 0.7 * ra, H * 1.2, '255,246,210'); glow(ctx, W * 0.5, -20, 900, '255,246,210', 0.55 * ra); fx(ctx, 'sunfl', t * 8, W * 0.5, 40, 5.0, 0.7 * ra, { add: true }); },
    });
    SC.push({ // 6b : remontée — les 3 badges étoile se matérialisent, tournent autour d'Évoli, Riolu lui tend la main
      id: '6b', t0: 137, t1: 142, map: 'opm2', free: true, bg: '#010208', grade: 'rgb(110,160,235)',
      cam: [[137, 288, 262, 1.5, 0.0], [142, 288, 40, 1.3, 0.0]],
      actors: [
        { id: 'evoli', pid: '0133', keys: [[137, 0, 0]], attach: [[137, 0, 14], [142, 0, 0]], an: [[137, 'Pose', 0, { loop: false, hold: 18 }], [140.6, 'Idle', 0]], noShadow: true, aura: '150,235,255', s: 1.3 },
        { id: 'riolu', pid: '0447', keys: [[137, 0, 0]], attach: [[137, 6, -170], [140.1, 14, -40], [142, 14, -36]], an: [[137, 'Float', 0, { speed: 0.6 }], [139.6, 'Pull', 0, { loop: false }]], noShadow: true, aura: '120,200,255', s: 1.2, a: [[137, 0], [137.8, 1]] },
      ],
      world(ctx, t, c, ph) {
        if (ph !== 'over') return; const ex = c.cx, ey = c.cy + lerp(14, 0, sstep((t - 137) / 5));
        bubblesWorld(ctx, t, 30, 81, ex - 110, ex + 110, c.cy - 90, c.cy + 90, 1.4); sparklesWorld(ctx, t, 60, 82, ex - 120, c.cy - 90, ex + 120, c.cy + 90, '255,246,200', 1);
        const keys = ['wfCyan', 'wfEmerald', 'wfAmber'], rgb = ['120,235,255', '120,255,190', '255,210,100'];
        const join = sstep((t - 140.6) / 0.9), R = lerp(38, 0, join);
        for (let i = 0; i < 3; i++) { const a = clamp((t - 137.4 - i * 0.5) / 0.9, 0, 1), an = t * 2.4 + i * TAU / 3; if (a <= 0 || join >= 1) continue;
          wayfinder(ctx, keys[i], ex + Math.cos(an) * R, ey - 6 + Math.sin(an) * R * 0.38, 0.95, t, a * (1 - join), rgb[i]); }
        if (t > 140.6) { const k = clamp((t - 140.6) / 1.4, 0, 1); glow(ctx, ex, ey - 6, 130 * k + 20, '255,246,210', 0.7 * (1 - k * 0.5)); ring(ctx, ex, ey - 6, k * 90, 2.2, '255,246,210', 0.8 * (1 - k), 0.5); fx(ctx, 'hit', Math.min(7, k * 8), ex, ey - 6, 0.7, 1 - k * 0.6, { tint: '255,246,210' }); }
      },
      screen(ctx, t) { const ra = sstep((t - 138) / 3); godRays(ctx, t, 0.7 * ra, W * 0.5, -30, 7, 0.8, H * 1.2, '255,246,210'); fx(ctx, 'sunfl', t * 8, W * 0.5, 40, 5.0, 0.6 * ra, { add: true }); flash(ctx, 0.6 * Math.exp(-Math.abs(t - 140.7) * 6), '255,246,210'); },
    });
    SC.push({
      id: '6c', t0: 142, t1: 145.2, map: 'opm2', free: true, bg: '#010208', grade: 'rgb(90,150,230)',
      cam: [[142, 288, 100, 1.0, 0.1], [144.5, 288, 105, 1.5, 0.0], [146.5, 288, 108, 2.8, -0.06]],
      follow: ['riolu', 'evoli'],
      actors: [
        { id: 'riolu', pid: '0447', keys: [[142, 280, 28], [145.0, 286, 98], [146.5, 286, 100]], an: [[142, 'LeapForth', 0, { loop: false }], [143.4, 'Charge', 0, { loop: true }]], rot: [[142, 0]], noShadow: true, aura: '120,200,255' },
        { id: 'evoli', pid: '0133', keys: [[142, 298, 180], [145.0, 290, 120], [146.5, 290, 120]], an: [[142, 'Pose', 0, { loop: true }]], noShadow: true, aura: '130,235,255' },
      ],
      world(ctx, t, c, ph) { if (ph !== 'over') return; const k = sstep((t - 145) / 1.5); glow(ctx, 288, 122, 160, '255,246,210', 0.25 + 0.6 * k); starBurst(ctx, 288, 122, 260, 0.6 * k, 12, t * 0.5); bubblesWorld(ctx, t, 34, 71, 180, 400, 0, 260, 1.4); sparklesWorld(ctx, t, 80, 72, 190, 0, 390, 260, '255,246,200', 1); },
      screen(ctx, t) { godRays(ctx, t, 0.7, W * 0.62, -30, 8, 0.8, H * 1.2, '255,240,190'); },
    });

    // ================== PLANCHES « PMD EXPLORERS OF SKY » (méthode d'intro de la série) ==================
    // Couches 256×192 superposées, défilement indépendant par couche (parallaxe), échelle de zoom du Shaymin,
    // tunnel Time Travel en boucle, nuages d'orage additifs, mer en tuile — + sprites PMDO image par image.
    const ANTIC = (EV.catalog && EV.catalog.antic) || [];
    function layer(ctx, k, x, y, a) { const im = I[k]; if (!im || !im.width) return; if (a != null) { ctx.save(); ctx.globalAlpha = a; ctx.drawImage(im, x, y); ctx.restore(); } else ctx.drawImage(im, x, y); }
    const par = (ctx, k, c, kf, ref, y) => layer(ctx, k, (1 - kf) * (c.cx - ref), y);
    function petals(ctx, t, n, x0, x1, y0, y1, seed) { // pétales = sprite généré (rotation 3D en 16 images)
      for (let i = 0; i < n; i++) {
        const ph = (t * (0.08 + rnd(i, seed + 2) * 0.08) + rnd(i, seed)) % 1, x = lerp(x0, x1, rnd(i, seed + 1)) + Math.sin(t * 1.6 + i) * 6 + ph * 30, y = lerp(y0, y1, ph);
        fx(ctx, 'petal', t * 12 * (0.7 + rnd(i, seed + 3) * 0.6) + i * 5, x, y, 0.38, 1);
      }
    }
    // --- A1 : le mur antique (Antic Wall) — les objets surgissent, le Wayfinder s'éveille
    const AI = [[2, 0.2], [4, 0.5], [1, 0.8], [5, 1.1], [3, 1.5], [0, 1.9]]; // [index objet, instant d'apparition]
    SC.push({
      id: 'A1', t0: 0, t1: 3, map: 'opm2', free: true, bg: '#120a05',
      cam: [[0, 180, 235, 1.5, 0.0], [1.5, 180, 190, 1.1, 0.0], [3, 180, 128, 0.95, 0.0]],
      draw(ctx, t, c) {
        layer(ctx, 'anticWall', 0, 0);
        glow(ctx, 180, 192, 130, '255,190,90', 0.22 + 0.12 * Math.sin(t * 3));
        AI.forEach(([k, ti]) => {
          const b = ANTIC[k]; const im = I['it' + k]; if (!b || !im || !im.width) return; const u = clamp((t - ti) / 0.42, 0, 1); if (u <= 0) return;
          const e = 1 + 2.7 * Math.pow(u - 1, 3) + 1.7 * Math.pow(u - 1, 2); const cx = b[0] + b[2] / 2, cy = b[1] + b[3] / 2;
          ctx.save(); ctx.globalAlpha = Math.min(1, u * 2); ctx.translate(cx, cy + (1 - u) * -14); ctx.scale(e, e); ctx.drawImage(im, -b[2] / 2, -b[3] / 2); ctx.restore();
          if (u < 1) glow(ctx, cx, cy, 60 * (1 - u * 0.5), '255,240,190', 0.6 * (1 - u));
        });
        const w = sstep((t - 1.1) / 1.6);
        glow(ctx, 180, 192, 90 + 70 * w, '150,235,255', 0.55 * w);
        wayfinder(ctx, 'wfCyan', 180, 192 - 12 * w, 0.4 + 1.1 * w, t, w, '120,235,255');
        starBurst(ctx, 180, 192, 120 * w, 0.35 * w, 8, t * 0.4);
      },
      screen(ctx, t) { particlesScreen(ctx, t, { n: 30, rgb: '255,220,150', a: 0.7, r: 2, vy: -0.3, tw: true, add: true }); },
    });
    // --- A2 : plaque verticale — panoramique du ciel vers la côte, le Shaymin approche (échelle de zoom en images)
    SC.push({
      id: 'A2', t0: 3, t1: 6, map: 'opm1', free: true, bg: '#2a6fd0',
      cam: [[3, 128, 74, 1.27, 0.0], [4, 128, 150, 1.27, 0.0], [5, 128, 330, 1.27, 0.0], [6, 128, 430, 1.27, 0.0]],
      draw(ctx, t, c) {
        layer(ctx, 'ttSky', 0, 0);
        glow(ctx, 130, 82, 90, '255,250,220', 0.6 + 0.2 * Math.sin(t * 2)); starBurst(ctx, 130, 82, 90, 0.55, 8, t * 0.15);
        const u = clamp((t - 3.1) / 2.7, 0, 1), LAD = [0.4, 0.5, 0.62, 0.75, 0.9, 1.05, 1.25, 1.5, 1.8, 2.1], si = Math.min(LAD.length - 1, Math.floor(u * LAD.length));
        { const sx = lerp(30, 200, u) + Math.sin(u * 7) * 14, sy = c.cy - 16 + Math.sin(u * 4) * 10; ctx.save(); ctx.globalAlpha = Math.min(1, u * 6); drawSprite(ctx, '0492', 'Walk', 1, (t - 3.1) * 60, true, sx, sy, { s: LAD[si], noShadow: true, aura: '255,250,200' }); ctx.restore(); }
        petals(ctx, t, 26, 20, 240, c.cy - 90, c.cy + 90, 3);
      },
      screen(ctx, t) { godRays(ctx, t, 0.35, W * 0.5, -20, 7, 1.1, H, '255,246,206'); },
    });
    // --- P1 : les Plaines — les trois amis courent, deux plans de parallaxe (plan lointain + arbres)
    SC.push({
      id: 'P1', t0: 6, t1: 11, map: 'opm1', free: true, bg: '#6ab4f0',
      cam: [[6, 150, 130, 1.25, 0.02], [8.5, 200, 130, 1.35, -0.02], [11, 250, 130, 1.45, 0.02]],
      actors: [
        { id: 'riolu', pid: '0447', keys: [[6, 132, 170], [8, 190, 168], [11, 290, 172]], an: [[6, 'Walk', 'auto', { speed: 1.2 }]], reflect: false },
        { id: 'evoli', pid: '0133', keys: [[6, 168, 176], [8, 226, 178], [11, 318, 176]], an: [[6, 'Walk', 'auto', { speed: 1.2 }], [8.4, 'Hop', 2, { loop: false }], [9.4, 'Walk', 'auto', { speed: 1.2 }]] },
        { id: 'tiplouf', pid: '0393', keys: [[6, 104, 180], [8, 164, 178], [11, 262, 180]], an: [[6, 'Walk', 'auto', { speed: 1.2 }]] },
      ],
      draw(ctx, t, c) { ctx.fillStyle = '#7cc0f4'; ctx.fillRect(-100, -100, 700, 120); par(ctx, 'plainsFar', c, 0.55, 192, 0); par(ctx, 'plainsTree', c, 0.85, 192, 0); },
      world(ctx, t, c, ph) { if (ph === 'over') { sparklesWorld(ctx, t, 40, 91, c.cx - 128, 120, c.cx + 128, 200, '255,255,230', 1); } },
      screen(ctx, t) { godRays(ctx, t, 0.16, W * 0.1, 30, 5, 1.0, H, '255,236,180'); },
    });
    // --- MN : chute arrière au clair de lune (couches Moonlight défilant à des vitesses différentes)
    SC.push({
      id: 'MN', t0: 24, t1: 31, map: 'opm2', free: true, bg: '#001040',
      cam: [[24, 156, 120, 1.1, 0.08], [28, 156, 118, 1.4, -0.08], [31, 156, 120, 1.7, 0.05]],
      actors: [{ id: 'evoli', pid: '0133', keys: [[24, 156, 112]], attach: [[24, 0, -8], [27, -6, -2], [31, 6, -6]], an: [[24, 'Sink', 0, { loop: false, hold: 21, speed: 0.5 }]], rot: [[24, -0.9], [27, -0.55], [31, -0.7]], s: 1.5, aura: '120,230,255', noShadow: true, a: [[24, 0], [25.5, 1]] }],
      props: [{ img: 'wfCyan', keys: [[24, 176, 100, 0], [31, 184, 104, 0]], s: 0.7, a: [[24, 0], [25.5, 1]] }],
      draw(ctx, t, c) {
        const u = t - 24; ctx.fillStyle = '#001040'; ctx.fillRect(-200, -300, 900, 900);
        const off = (u * 70) % 240; for (let k = -1; k <= 2; k++) layer(ctx, 'moonBg', 0, -off + k * 240 - 120);
        const f = 1 - sstep((u - 2.5) / 2.5); layer(ctx, 'moonFg', 0, -u * 40, f);
        if (f > 0) glow(ctx, 156, 100 - u * 40, 150, '255,244,200', 0.25 * f);
      },
      screen(ctx, t) { speedLines(ctx, t, 26, W / 2, H / 2, '190,230,255', 0.28, 220, -Math.PI / 2); ctx.save(); ctx.globalCompositeOperation = 'lighter'; const g = ctx.createLinearGradient(0, 0, 0, H); g.addColorStop(0, 'rgba(210,250,255,0.35)'); g.addColorStop(1, 'rgba(120,220,255,0)'); ctx.fillStyle = g; ctx.beginPath(); ctx.moveTo(W * 0.43, 0); ctx.lineTo(W * 0.57, 0); ctx.lineTo(W * 0.85, H); ctx.lineTo(W * 0.15, H); ctx.closePath(); ctx.fill(); ctx.restore(); },
    });
    // --- TT : tunnel Time Travel (13 images en boucle, fenêtres blanches = souvenirs du monde)

    // ---------- Chute en vue plongeante : la caméra est AU-DESSUS, on les voit tomber en contrebas dans un portail de nuages, de nuit ----------
    function drawFall(ctx, t, C) {
      const u = t - C.t0, dur = C.t1 - C.t0, k = clamp(u / dur, 0, 1);
      ctx.fillStyle = '#070320'; ctx.fillRect(0, 0, W, H);
      const P = I.cloudPortal;
      if (P && P.width) { // portail de nuages : zoom infini + lente rotation (deux couches en fondu)
        const ph = (u * 0.16) % 1, rot = u * 0.07, b = 1.9;
        ctx.save(); ctx.imageSmoothingEnabled = true; ctx.translate(W / 2, H / 2); ctx.rotate(rot);
        for (const L of [[b * Math.pow(2, ph - 1), 1], [b * Math.pow(2, ph), 1 - ph]]) { ctx.save(); ctx.globalAlpha = L[1]; ctx.scale(L[0], L[0]); ctx.drawImage(P, -P.width / 2, -P.height / 2); ctx.restore(); }
        ctx.restore();
      }
      glow(ctx, W / 2, H / 2, 300, '190,225,255', 0.1 + 0.05 * Math.sin(u * 2));
      for (let i = 0; i < 64; i++) { // étoiles qui jaillissent du centre vers la caméra
        const ph = (u * 0.42 * (0.6 + rnd(i, 2) * 0.8) + rnd(i, 1)) % 1, r = Math.pow(ph, 1.7) * 760, an = rnd(i, 3) * TAU;
        fx(ctx, 'sparkle', ph * 8, W / 2 + Math.cos(an) * r, H / 2 + Math.sin(an) * r * 0.62, 0.35 + ph * 1.5, 1, { add: true });
      }
      speedLines(ctx, t, 26, W / 2, H / 2, '205,225,255', 0.16, 320);
      const sc = lerp(C.s0, C.s1, sstep(k)), ex = W / 2 + Math.sin(u * 1.1) * 38 * (1 - 0.5 * k), ey = H / 2 + 18 + Math.sin(u * 0.8) * 16 + 26 * k;
      if (C.friends) for (const F of C.friends) { // les amis, protégés par une barrière, remontent vers la caméra
        const e = sstep((u - F.t0) / F.dur); if (u < F.t0 - 0.2) continue; const kb = sstep((u - F.t0 + 0.2) / 0.9);
        const fxp = ex + F.side * (150 + 560 * e), fyp = ey + 30 - 640 * e, fs = 2.6 + e * 4.2;
        ctx.save(); ctx.translate(fxp, fyp); ctx.scale(fs, fs); ctx.imageSmoothingEnabled = false;
        drawSprite(ctx, F.pid, 'Idle', 0, u * 60, true, 0, 0, { noShadow: true, aura: F.aura, a: 1 }); barrierWorld(ctx, 0, 0, 24, kb, t); ctx.restore();
        if (kb < 1) matBurst(ctx, fxp, fyp, kb, F.aura, fs * 0.5);
      }
      if (u >= C.haloT) { // halo arc-en-ciel : se matérialise puis reste jusqu'à la fin
        const kh = clamp((u - C.haloT) / 1.0, 0, 1), pulse = 0.88 + 0.12 * Math.sin(u * 3);
        glow(ctx, ex, ey, sc * 62, '255,235,255', 0.28 * kh);
        fx(ctx, 'halo', u * 10, ex, ey, sc * 0.6, 0.95 * pulse, { mat: kh });
        if (kh < 1) matBurst(ctx, ex, ey, kh, null, sc * 0.6);
      }
      ctx.save(); ctx.translate(ex, ey); ctx.rotate(Math.sin(u * 0.8) * 0.3 + u * 0.1); ctx.scale(sc, sc); ctx.imageSmoothingEnabled = false;
      drawSprite(ctx, '0133', 'Pose', 4, Math.min(u * 60, 18), false, 0, 0, { noShadow: true, aura: '170,235,255' }); ctx.restore();
      particlesScreen(ctx, t, { n: 36, rgb: '255,250,230', a: 0.8, r: 2, vy: -4, add: true, tw: true });
      if (C.fadeIn) { ctx.fillStyle = 'rgba(0,0,0,' + (1 - sstep(u / C.fadeIn)).toFixed(3) + ')'; ctx.fillRect(0, 0, W, H); }
      if (C.end === 'white') flash(ctx, sstep((t - (C.t1 - 0.8)) / 0.8)); else if (C.end === 'black') { ctx.fillStyle = 'rgba(0,0,0,' + sstep((t - (C.t1 - 1.2)) / 1.2).toFixed(3) + ')'; ctx.fillRect(0, 0, W, H); }
    }
    SC.push({ id: 'TT', t0: 31, t1: 36, map: 'opm2', free: true, cam: [[31, 288, 150, 1, 0]], custom: (ctx, t) => drawFall(ctx, t, { t0: 31, t1: 36, s0: 7.2, s1: 4.6, haloT: 0.9, end: 'white' }) });
    // --- OC : l'océan de Lapras — trois Wayfinders tombent du ciel dans la mer
    SC.push({
      id: 'OC', t0: 46, t1: 52.5, map: 'opm1', free: true, bg: '#1d6cc8',
      cam: [[46, 144, 62, 1.2, 0.0], [47.5, 144, 150, 1.2, 0.0], [49, 144, 215, 1.3, 0.0], [52.5, 144, 262, 1.45, 0.0]],
      props: [0, 1, 2].map((i) => { const t0 = 46.4 + i * 0.75, ti = t0 + 1.7; return { img: ['wfCyan', 'wfEmerald', 'wfAmber'][i], rgb: ['120,235,255', '120,255,190', '255,210,100'][i], keys: [[t0, 100 + i * 44, -10, 0], [ti, 100 + i * 44, 240, 0], [ti + 2, 100 + i * 44, 320, 0]], s: 1.0, a: [[t0, 1], [ti - 0.01, 1], [ti + 0.02, i === 2 ? 1 : 0], [ti + 1.8, i === 2 ? 0.1 : 0]] }; }),
      draw(ctx, t, c) {
        layer(ctx, 'laprasSky', 0, 0); layer(ctx, 'laprasSea', 0, 264);
        const o = (t * 14) % 288; ctx.save(); ctx.globalAlpha = 0.28; for (let k = -1; k <= 1; k++) ctx.drawImage(I.laprasSea, k * 288 + o, 176, 288, 90); ctx.restore();
        const lw = I['lap' + (Math.floor(t * 5) % 3)]; if (lw && lw.width) { const lx = lerp(330, -90, (t - 46) / 6.5), ly = 232 + Math.sin(t * 2.4) * 2.5; ctx.drawImage(lw, Math.round(lx), Math.round(ly)); }
      },
      world(ctx, t, c, ph) {
        if (ph !== 'over') return; const u = t - 46;
        for (let i = 0; i < 3; i++) { const ti = 0.4 + i * 0.75 + 1.7, w = u - ti, X = 100 + i * 44;
          if (w >= 0) { const k = Math.exp(-w * 3); glow(ctx, X, 240, 50 * (0.5 + k), '255,255,255', 0.8 * k); fx(ctx, 'splash', w * 14, X, 246, 0.9, 1, { bottom: true }); fx(ctx, 'hit', w * 14, X, 230, 0.32, 0.9);
            for (let r = 0; r < 3; r++) { const pr = clamp(w * 1.1 - r * 0.2, 0, 1.6); ring(ctx, X, 244, 4 + pr * 46, 0.9, '235,255,255', 0.8 * (1 - pr / 1.6), 0.35); }
            if (i < 2) shardsW(ctx, X, 236, w, 22, 40 + i, i ? ['#fff', '#ff9ac6', '#ffe08a'] : ['#fff', '#9ff4ff', '#ffd45a'], 80, 3); } }
        for (let k = 0; k < 6; k++) { const d = u - (0.9 + k * 0.78); if (d > 0 && d < 0.22) starBurst(ctx, 60 + rnd(k, 3) * 190, 40 + rnd(k, 4) * 40, 40, 1 - d / 0.22, 6, k); }
      },
      screen(ctx, t) { godRays(ctx, t, 0.28, W * 0.5, -20, 7, 1.0, H, '255,246,206'); flash(ctx, sstep((t - 51.9) / 0.6)); },
    });
    // --- SP : sommet fleuri (Sky Peak Summit) — Riolu et Évoli, la caméra se redresse vers le soleil → écran-titre
    SC.push({
      id: 'SP', t0: 145.2, t1: TITLE_T, map: 'opm5', free: true, bg: '#2c70e0',
      cam: [[145.2, 128, 494, 1.7, 0.0], [146.5, 128, 486, 1.6, 0.0], [147.3, 128, 270, 1.35, 0.0], [148, 128, 110, 1.27, 0.0]],
      actors: [
        { id: 'riolu', pid: '0447', keys: [[145.2, 108, 484]], an: [[145.2, 'LookUp', 4, { loop: false }]], ys: 0 },
        { id: 'evoli', pid: '0133', keys: [[145.2, 142, 490]], an: [[145.2, 'LookUp', 4, { loop: false }]] },
      ],
      draw(ctx, t, c) { layer(ctx, 'skyPeak', 0, 0); glow(ctx, 128, 70, 120, '255,250,220', 0.5); starBurst(ctx, 128, 70, 140, 0.5, 8, t * 0.2); },
      world(ctx, t, c, ph) { if (ph === 'over') petals(ctx, t, 40, 30, 230, c.cy - 80, c.cy + 80, 9); },
      screen(ctx, t) { godRays(ctx, t, 0.35 * sstep((t - 146.5) / 1.2), W * 0.5, -20, 7, 1.1, H, '255,246,206'); flash(ctx, sstep((t - 147.4) / 0.6)); },
    });
    // --- Orage (Thunderclouds) : images brutes en addition, synchronisées sur les impacts
    function thunderFx(ctx, times, t) {
      let idx = 0, a = 0;
      for (const ti of times) { const d = t - ti; if (d >= 0 && d < 0.6) { idx = Math.min(6, 1 + Math.floor(d * 16)); a = Math.exp(-d * 2.4) * 0.85; } }
      if (a < 0.02) return; const im = I['th' + idx]; if (!im || !im.width) return;
      ctx.save(); ctx.globalCompositeOperation = 'lighter'; ctx.globalAlpha = a; const dw = W, dh = W * 240 / 335; ctx.drawImage(im, 0, (H - dh) / 2, dw, dh); ctx.restore();
    }


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
    SC.find((q) => q.id === '5a').thunderT = [118.0, 119.1, 120.2];
    const XF = { A2: 0.6, P1: 0.7, MN: 1.0, TT: 0.6, OC: 0.8, SP: 0.5, '1c': 0.4, '1d': 0.5, '1e': 0.5, '2b': 0.6, '3b': 0.6, '3c': 0.6, '3d': 0.9, '4a': 0.3, '4b': 0, '4c': 0, '4d': 0, '5a': 0, '5b': 0.8, '6a': 1.0, '6b': 0.8, '6c': 0.8 };
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
  root.PMDDestinySprite = { create, W, H, D, CHAPTERS, TITLE_T, IMPACTS, BEAT };
})(typeof window !== 'undefined' ? window : globalThis);
