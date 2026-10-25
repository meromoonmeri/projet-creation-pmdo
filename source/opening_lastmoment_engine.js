/* Cinématique d'Opening « PMD : Destiny » — version LAST MOMENT : mêmes plans que l'ED 25 de Bleach (« Last Moment », SPYAIR, 1:36), transposés dans un univers Pokémon Mystery Dungeon.
   1280×720 · 60 FPS · durée EXACTE 96,0 s (01:36). Décors = textures canoniques des intros de PMD Explorers of Sky (Lapras, Plains, Moonlight, Sky Peak Summit).
   Acteurs = vrais sprites + portraits PMDCollab. Plans : crépuscule sur la mer → héros au centre, caméra qui orbite à 360° puis s'éloigne → course de nuit, gros plan du visage,
   arrêts sur image des compagnons → course vers l'aube, souvenirs des compagnons en arrière-plan, Shaymin triste, élan final → écran-titre.
   Fonction pure du temps : render(ctx, t, opts). Aucune dépendance DOM. */
(function (root) {
  'use strict';
  const W = 1280, H = 720, D = 96.0, BEAT = 60 / 128, TAU = Math.PI * 2, TITLE_T = 91.0;
  const clamp = (x, a, b) => Math.min(b, Math.max(a, x));
  const sstep = (x) => { x = clamp(x, 0, 1); return x * x * (3 - 2 * x); };
  const lerp = (a, b, u) => a + (b - a) * u;
  const rnd = (i, s) => { const x = Math.sin(i * 127.1 + (s || 0) * 311.7) * 43758.5453; return x - Math.floor(x); };

  const CHAPTERS = [
    { t: 0.0, name: '', short: 'I' },
    { t: 9.0, name: '', short: 'II' },
    { t: 25.0, name: '', short: 'III' },
    { t: 52.0, name: '', short: 'IV' },
    { t: 78.0, name: '', short: 'V' },
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
    const BOLTS = [];

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
      let x = -(((off % P) + P) % P) - P, i = 0; ctx.save(); ctx.imageSmoothingEnabled = false; if (a != null && a < 1) ctx.globalAlpha = Math.max(0, a);
      for (; x < W + 420; x += w, i++) { if (i % 2) { ctx.save(); ctx.translate(Math.round(x) + w, Math.round(y)); ctx.scale(-1, 1); ctx.drawImage(im, 0, 0, w, h); ctx.restore(); } else ctx.drawImage(im, Math.round(x), Math.round(y), w, h); }
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

    // ================== PLANS « LAST MOMENT » — mêmes plans que l'ED 25 de Bleach, transposés dans l'univers PMD ==================
    // Décors = TEXTURES CANONIQUES des intros de PMD Explorers of Sky (rips fournis) : Lapras (ciel + mer), Plains (montagnes + arbres + chemin),
    // Moonlight (nuit étoilée + lune), Sky Peak Summit (prairie fleurie). Aucun village, aucun bateau.
    const HERO = '0447'; // Riolu = le héros qui court vers l'avenir
    function sub(ctx, key, sx, sy, sw, sh, x, y, s, a) { const im = I[key]; if (!im || !im.width) return; ctx.save(); ctx.imageSmoothingEnabled = false; if (a != null && a < 1) ctx.globalAlpha = Math.max(0, a); ctx.drawImage(im, sx, sy, sw, sh, Math.round(x), Math.round(y), Math.round(sw * s), Math.round(sh * s)); ctx.restore(); }
    function tileSub(ctx, key, sy, sh, off, y, s, a) { // bande de rangées [sy, sy+sh) répétée en miroir, défilante
      const im = I[key]; if (!im || !im.width) return; const w = Math.round(im.width * s), h = Math.round(sh * s), P = 2 * w; let x = -(((off % P) + P) % P) - P, i = 0;
      ctx.save(); ctx.imageSmoothingEnabled = false; if (a != null && a < 1) ctx.globalAlpha = Math.max(0, a);
      for (; x < W + 420; x += w, i++) { if (i % 2) { ctx.save(); ctx.translate(Math.round(x) + w, Math.round(y)); ctx.scale(-1, 1); ctx.drawImage(im, 0, sy, im.width, sh, 0, 0, w, h); ctx.restore(); } else ctx.drawImage(im, 0, sy, im.width, sh, Math.round(x), Math.round(y), w, h); }
      ctx.restore();
    }
    function cam(ctx, z, px, py, ox, oy, fn) { ctx.save(); ctx.translate(px + ox, py + oy); ctx.scale(z, z); ctx.translate(-px, -py); fn(); ctx.restore(); }
    function duskGrade(ctx, a) { ctx.save(); ctx.globalCompositeOperation = 'multiply'; ctx.globalAlpha = a; let g = ctx.createLinearGradient(0, 0, 0, H); g.addColorStop(0, 'rgb(185,130,235)'); g.addColorStop(0.5, 'rgb(255,172,125)'); g.addColorStop(1, 'rgb(255,190,140)'); ctx.fillStyle = g; ctx.fillRect(0, 0, W, H);
      ctx.globalCompositeOperation = 'source-over'; ctx.globalAlpha = 0.22 * a; g = ctx.createLinearGradient(0, 0, 0, H); g.addColorStop(0, 'rgb(150,60,190)'); g.addColorStop(0.55, 'rgb(255,120,60)'); g.addColorStop(1, 'rgb(255,150,60)'); ctx.fillStyle = g; ctx.fillRect(0, 0, W, H); ctx.restore(); }
    function sunDisc(ctx, x, yc, r, yClip, a) { ctx.save(); ctx.beginPath(); ctx.rect(0, 0, W, yClip); ctx.clip(); const g = ctx.createRadialGradient(x, yc, r * 0.15, x, yc, r); g.addColorStop(0, 'rgb(255,252,225)'); g.addColorStop(0.7, 'rgb(255,214,125)'); g.addColorStop(1, 'rgb(255,165,75)'); ctx.globalAlpha = a; ctx.fillStyle = g; ctx.beginPath(); ctx.arc(x, yc, r, 0, TAU); ctx.fill(); ctx.restore(); }
    // plan fixe « image statique » d'un personnage (portrait PMD officiel) : coupe flash, rayons, cadre — comme les arrêts sur image de l'ED
    function still(ctx, t, t0, t1, pid, emo, o) {
      o = o || {}; const u = t - t0, d = t1 - t0; if (u < 0 || u > d) return false;
      const g = ctx.createRadialGradient(W / 2, H / 2, 40, W / 2, H / 2, 860); g.addColorStop(0, o.c0 || 'rgb(80,112,215)'); g.addColorStop(1, o.c1 || 'rgb(4,8,38)'); ctx.fillStyle = g; ctx.fillRect(0, 0, W, H);
      starBurst(ctx, W / 2, H / 2, 980, 0.30, 18, u * 0.06); speedLines(ctx, t, 46, W / 2, H / 2, o.rgb || '200,225,255', 0.32, 340);
      const im = I['pt_' + pid + '_' + emo]; const s = lerp(11.2, 12.4, u / d);
      if (im && im.width) {
        const pw = im.width * s, ph = im.height * s, x = W / 2 - pw / 2 + (o.dx || 0), y = H / 2 - ph / 2 - 6;
        ctx.save(); ctx.translate(W / 2, H / 2); ctx.rotate(o.rot || 0); ctx.translate(-W / 2, -H / 2);
        glow(ctx, W / 2 + (o.dx || 0), H / 2, 420, o.rgb || '170,210,255', 0.35);
        ctx.fillStyle = 'rgba(0,0,0,0.5)'; ctx.fillRect(x + 12, y + 14, pw, ph);
        ctx.fillStyle = '#fff'; ctx.fillRect(x - 8, y - 8, pw + 16, ph + 16); ctx.fillStyle = '#0b1530'; ctx.fillRect(x - 3, y - 3, pw + 6, ph + 6);
        ctx.imageSmoothingEnabled = false; ctx.drawImage(im, x, y, pw, ph); ctx.restore();
      }
      if (o.sprite) spr(ctx, pid, o.sprite, 0, u * 60, W / 2 + 450, 640, 6.4, { loop: true });
      for (let i = 0; i < 26; i++) fx(ctx, 'sparkle', ((t * (0.6 + rnd(i, 4)) + rnd(i, 5)) % 1) * 8, rnd(i, 6) * W, rnd(i, 7) * H, 0.3 + rnd(i, 8) * 0.3, 0.9, { add: true });
      flash(ctx, 0.95 * (1 - sstep(u / 0.28)), '255,255,255'); flash(ctx, sstep((u - (d - 0.2)) / 0.2), o.out || '255,255,255');
      return true;
    }

    // ---- Plan 1 : crépuscule sur la mer (textures Lapras) — panoramique vertical lent, Goélise / Bekipan dans le ciel (plan d’ouverture : la ville au couchant devient l’horizon marin) ----
    function fSunset(ctx, t) {
      const S = 4.5, tilt = sstep(t / 8.6), top = lerp(38, 104, tilt), py = -top * S, hz = py + 177 * S, z = lerp(1.0, 1.1, sstep(t / 9));
      vgrad(ctx, [70, 50, 130], [255, 165, 95]);
      cam(ctx, z, 700, hz, 0, 0, () => {
        plate(ctx, 'laprasSky', -8, py, S);
        sunDisc(ctx, 700, hz - 36 + 16 * tilt, 78, hz + 1, 1); glow(ctx, 700, hz - 20, 420, '255,205,120', 0.8);
        const im = I.laprasSea, y0 = py + 264 * S; // la mer : rangées décalées (vagues)
        if (im && im.width) { ctx.save(); ctx.imageSmoothingEnabled = false; for (let r = 0; r < 192; r++) { const ox = Math.round(Math.sin(r * 0.33 + t * 1.8) * (0.4 + r * 0.012) * S); ctx.drawImage(im, 0, r, 288, 1, -8 + ox, y0 + r * S, 288 * S, S + 1); } ctx.restore(); }
        ctx.save(); ctx.globalCompositeOperation = 'lighter'; for (let i = 0; i < 26; i++) { const y = hz + 6 + i * 11 + Math.sin(t * 2 + i) * 2, w = (200 - i * 5.5) * (0.5 + 0.5 * Math.abs(Math.sin(t * 1.3 + i * 1.9))); ctx.fillStyle = 'rgba(255,205,120,' + (0.5 - i * 0.017).toFixed(3) + ')'; ctx.fillRect(700 - w / 2, y, w, 4); } ctx.restore();
        for (let i = 0; i < 40; i++) fx(ctx, 'sparkle', ((t * 0.9 + rnd(i, 2)) % 1) * 8, 700 + (rnd(i, 3) - 0.5) * 520, hz + 10 + rnd(i, 4) * 300, 0.2, 0.9, { add: true, tint: '255,225,150' });
        gulls(ctx, t, 2.0, 7.4, 5, 4, hz - 40, hz - 150, 1, false);
      });
      duskGrade(ctx, 0.9); godRays(ctx, t, 0.28, 700, -30, 7, 0.9, H * 1.3, '255,200,140');
    }
    SC.push({ id: 'LS', t0: 0, t1: 9, custom: fSunset });

    // ---- Plan 2 : le héros immobile au centre, la caméra tourne à 360° autour de lui (fond = Plains, raccord parfait) puis s'éloigne ----
    function fOrbit(ctx, t) {
      const u = t - 9, th = sstep((u - 1.6) / 6.4), S = 4.4, w = Math.round(384 * S), P = 2 * w, offFar = th * P, offTree = th * P * 2;
      const idx = Math.floor(th * 8 + 0.5) % 8, dir = [0, 7, 6, 5, 4, 3, 2, 1][idx];
      const z = u < 8 ? lerp(1.0, 1.1, sstep(u / 8)) : lerp(1.1, 0.78, sstep((u - 8.6) / 7.2));
      vgrad(ctx, [120, 90, 190], [255, 170, 110]);
      cam(ctx, z, 640, 658, Math.sin(t * 0.7) * 5, 0, () => {
        const py = -200; tileH(ctx, 'plainsFar', offFar, py, S);
        const sx = (((1030 - offFar) % P) + P) % P; [sx, sx - P].forEach((x) => glow(ctx, x, 330, 380, '255,170,90', 0.75));
        tileH(ctx, 'plainsTree', offTree, py, S);
        petalWind(ctx, t, 26, 41, -1, 30, 0.12, 1.0, '255,170,70');
        for (let i = 0; i < 18; i++) fx(ctx, 'sparkle', ((t * 0.7 + rnd(i, 8)) % 1) * 8, rnd(i, 9) * W, 330 + rnd(i, 10) * 330, 0.26, 0.85, { add: true, tint: '255,225,140' });
      });
      duskGrade(ctx, 0.85); godRays(ctx, t, 0.22, W * 0.78, -30, 6, 0.9, H * 1.3, '255,190,130');
      cam(ctx, z, 640, 658, Math.sin(t * 0.7) * 5, 0, () => { glow(ctx, 640, 560, 150, '255,190,120', 0.22); spr(ctx, HERO, 'Idle', dir, (t - 9) * 60 * 0.9, 640, 658, 8, {}); }); // le héros garde ses vraies couleurs
    }
    SC.push({ id: 'OR', t0: 9, t1: 25, custom: fOrbit });

    // ---- Plan 3 : course de nuit (Moonlight + arbres des Plains), la tête du héros se rapproche, arrêts sur image des compagnons, gros plan ----
    const STILLS = [
      { t0: 38.0, t1: 40.4, pid: '0447', emo: 'Determined', sprite: 'Idle', rot: -0.03 },
      { t0: 40.4, t1: 42.8, pid: '0393', emo: 'Determined', sprite: 'Idle', rot: 0.025, c0: 'rgb(60,130,210)', rgb: '150,225,255' },
      { t0: 42.8, t1: 45.2, pid: '0253', emo: 'Determined', sprite: 'Idle', rot: -0.02, c0: 'rgb(60,170,110)', rgb: '170,255,190' },
    ];
    const NSPD = (x) => (x < 13 ? 700 : x < 20.2 ? 0 : 900);
    function nightBack(ctx, t, off, k) {
      plate(ctx, 'moonBg', -15, -250, 4.2); for (let i = 0; i < 70; i++) fx(ctx, 'sparkle', ((t * (0.4 + rnd(i, 1)) + rnd(i, 2)) % 1) * 8, rnd(i, 3) * W, rnd(i, 4) * 400, 0.14 + rnd(i, 5) * 0.2, 0.9, { add: true });
      plate(ctx, 'moonFg', -30 - off * 0.01, -330, 4.2);
      ctx.save(); tileH(ctx, 'plainsTree', off * 0.4, -60, 3.2, 1); ctx.globalCompositeOperation = 'multiply'; const gb = ctx.createLinearGradient(0, 240, 0, 420); gb.addColorStop(0, 'rgba(30,45,110,0)'); gb.addColorStop(1, 'rgba(30,45,110,0.6)'); ctx.fillStyle = gb; ctx.fillRect(-300, 240, W + 600, 480); ctx.restore();
    }
    function fNight(ctx, t) {
      const u = t - 25, off = integ(NSPD, u) , run = u < 13 || u > 20.2;
      vgrad(ctx, [6, 10, 44], [24, 38, 86]);
      const big = t >= 45.2, push = sstep((u - 8) / 5), zz = 1 + 1.7 * push;
      cam(ctx, big ? 1 : zz, 470, 520, 170 * push * (big ? 0 : 1), -60 * push * (big ? 0 : 1), () => {
        nightBack(ctx, t, off, 0);
        tileH(ctx, 'plainsTree', off, -200, 4.4);
        ctx.save(); ctx.globalCompositeOperation = 'multiply'; ctx.fillStyle = 'rgba(70,92,190,' + (0.85 * (1 - sstep((t - 45.2) / 6.8) * 0.35)).toFixed(3) + ')'; ctx.fillRect(-200, 250, W + 400, 520); ctx.restore();
        if (big) { spr(ctx, HERO, 'Walk', 2, (t - 25) * 60 * 2.4, 600, 666, 15, {}); }
        else spr(ctx, HERO, 'Walk', 2, (t - 25) * 60 * 2.4, 470, 650, 6.2, {});
        for (let i = 0; i < 22; i++) fx(ctx, 'sparkle', ((t * 0.8 + rnd(i, 5)) % 1) * 8, rnd(i, 6) * W, 300 + rnd(i, 7) * 340 + Math.sin(t * 1.3 + i) * 16, 0.28, 0.85, { add: true, tint: '255,240,120' });
      });
      if (run) speedLines(ctx, t, 18, W * 0.5, H * 0.5, '170,200,255', 0.22, 420, Math.PI);
      const dk = sstep((t - 45.2) / 6.8); glow(ctx, W * 0.9, 470, 520 * dk, '255,140,120', 0.55 * dk);
      for (const S0 of STILLS) if (still(ctx, t, S0.t0, S0.t1, S0.pid, S0.emo, S0)) return;
    }
    SC.push({ id: 'NT', t0: 25, t1: 52, custom: fNight });

    // ---- Plan 4 : course vers l'aube (prairie fleurie de Sky Peak Summit) ; les compagnons apparaissent en souvenirs derrière lui ; Shaymin triste ; élan final ----
    const ALLIES = [ // Manaphy, Tiplouf, Mew, Massko, Zoroark, Celebi, Darkrai, Lucario, Évoli
      ['0490', 'Float', 0, '120,235,255', 5.2], ['0393', 'Hover', 0, '140,200,255', 5.0], ['0151', 'Float', 0, '255,170,230', 5.0],
      ['0253', 'Idle', 0, '150,255,170', 5.4], ['0571', 'Idle', 0, '255,150,120', 5.0], ['0251', 'Float', 0, '150,255,160', 5.2],
      ['0491', 'Idle', 0, '170,90,255', 5.0], ['0448', 'Idle', 0, '110,200,255', 5.2], ['0133', 'Hop', 0, '255,200,130', 5.4],
    ];
    const DSPD = (x) => 700 * (x < 26 ? 1 : x < 33.5 ? 1 - sstep((x - 26) / 2.5) : sstep((x - 33.5) / 2));
    function fRun(ctx, t) {
      const u = t - 52, off = 400 + integ(DSPD, u), spd = DSPD(u) / 700, k = sstep(u / 3), hzn = 300, py = -875;
      vgrad(ctx, lerpC([30, 40, 110], [255, 190, 150], k), lerpC([90, 90, 160], [255, 230, 190], k));
      const zr = 1 + 0.12 * sstep((u - 33.5) / 4.5);
      cam(ctx, zr, 1000, 300, 0, 0, () => {
        tileSub(ctx, 'skyPeak', 0, 235, off * 0.03, py, 5);
        const sy = lerp(hzn + 90, hzn - 70, sstep(u / 30)); sunDisc(ctx, 1000, sy, 70, hzn + 2, 1); glow(ctx, 1000, sy, 460, '255,225,170', 0.42); ring(ctx, 1000, sy, 110 + 10 * Math.sin(u * 2), 3, '255,235,170', 0.35, 1); ring(ctx, 1000, sy, 160 + 14 * Math.sin(u * 1.6), 2, '255,220,150', 0.2, 1);
        tileSub(ctx, 'skyPeak', 235, 341, off, py + 235 * 5, 5);
        ALLIES.forEach((A, i) => { // souvenir : se matérialise (trame), flotte, se dissout
          const a0 = 0.4 + i * 2.6, q = u - a0; if (q < 0 || q > 2.9) return; const m = sstep(q / 0.6), o = 1 - sstep((q - 2.3) / 0.6), x = [900, 760, 1040, 820, 980, 740, 900, 1020, 800][i] - q * 22, y = [240, 205, 270, 225, 255, 215, 235, 265, 225][i] + Math.sin(q * 2 + i) * 8;
          glow(ctx, x, y, 150, A[3], 0.38 * m * o); spr(ctx, A[0], A[1], A[2], q * 60 * 0.9, x, y, A[4], { fly: true, a: 0.78 * o, mat: m, aura: A[3] });
          fx(ctx, 'sparkle', (q * 12) % 8, x + 36, y - 52, 0.4, o, { add: true, tint: A[3] }); if (q < 0.7) fx(ctx, 'mat', (q / 0.7) * 8, x, y, 1.2, 1, { tint: A[3], add: true });
        });
        const run = spd > 0.04, hp = 11, hx = 540; if (!(u > 28.5 && u < 33.5)) spr(ctx, HERO, run ? 'Walk' : 'Idle', 2, run ? t * 60 * 2.4 * Math.max(0.5, spd) : u * 60 * 0.8, hx, 676, hp, {});
        tileSub(ctx, 'skyPeak', 452, 9, off * 1.9, 648, 8, 0.92);
        petalWind(ctx, t, 60, 13, -1, 40, 0.16, 1.4); petalWind(ctx, t, 8, 23, -1, 80, 0.26, 2.6);
      });
      const gk = sstep(u / 26); grade(ctx, lerpC([175, 150, 215], [255, 218, 195], gk), 0.9); godRays(ctx, t, 0.3, W * 0.78, -30, 7, 0.9, H * 1.3, '255,235,190');
      // Shaymin (Orihime) : arrêt sur image, triste, pétales — puis élan final vers le soleil et flash blanc
      if (still(ctx, t, 80.5, 85.5, '0492', 'Sad', { c0: 'rgb(120,150,200)', c1: 'rgb(14,22,60)', rgb: '255,205,225', rot: 0.0, out: '255,240,230' })) { petalWind(ctx, t, 40, 77, -1, 70, 0.1, 1.5); petalWind(ctx, t, 6, 79, -1, 90, 0.16, 3.0); }
      const fl = sstep((t - 88.6) / 2.4); if (fl > 0) { glow(ctx, 1000, 300, 900 * fl, '255,255,240', 0.9 * fl); flash(ctx, fl, '255,255,255'); }
    }
    SC.push({ id: 'DW', t0: 52, t1: 91, custom: fRun });

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
    const XF = { LS: 0, OR: 1.2, NT: 1.0, DW: 1.0 };
    function drawShot(ctx, sc, t) { if (sc.custom) { sc.custom(ctx, t); return null; } return renderScene(ctx, sc, t); }
    function bars(ctx, t) { const k = sstep((t - 0.2) / 1.2); const h = 52 * k * (1 - sstep((t - 89.8) / 0.8)); ctx.fillStyle = '#000'; ctx.fillRect(0, 0, W, h); ctx.fillRect(0, H - h, W, h); }

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
  root.PMDDestinyLastMoment = { create, W, H, D, CHAPTERS, TITLE_T, IMPACTS, BEAT };
})(typeof window !== 'undefined' ? window : globalThis);
