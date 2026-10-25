/* Cinématique d'Opening « PMD : Destiny » — version ULTIME (153 s, « Simple and Clean -Ray of Hope MIX- ») : assemble les 31 premières secondes de l'opening VOYAGE (abysse → surface),
   une COURSE LUNAIRE (Riolu, Évoli, Tiplouf dans le décor Moonlight des intros de PMD Sky) où les personnages de l'histoire se matérialisent puis disparaissent en GROS PLAN
   (comme à 52 s de « Last Moment »), puis l'opening sprites à partir de 46 s (passage 46 s → 1:08 conservé à l'identique, mêlée, chute, remontée, écran-titre).
   1280×720 · 60 FPS · durée EXACTE 153,0 s (02:33). Fonction pure du temps : render(ctx, t, opts). Aucune dépendance DOM. */
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
    { t: 46.0, name: '', short: 'III' },
    { t: 68.0, name: '', short: 'IV' },
    { t: 106.0, name: '', short: 'V' },
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

    // ================== PLANS « ULTIME » ==================
    // Ce moteur assemble : le VOYAGE (0 → 31 s, abysse puis surface), la COURSE LUNAIRE (31 → 46 s : Riolu, Évoli et Tiplouf courent dans le décor Moonlight
    // des intros de PMD Sky, les personnages de l'histoire se matérialisent puis disparaissent en GROS PLAN, comme à 52 s de « Last Moment »),
    // puis l'opening sprites (46 → 153 s : passage 46 s → 1:08 conservé, mêlée, chute, remontée, écran-titre) — le tout calé sur « Ray of Hope MIX ».
    const HERO = '0447';
    function cam(ctx, z, px, py, ox, oy, fn) { ctx.save(); ctx.translate(px + ox, py + oy); ctx.scale(z, z); ctx.translate(-px, -py); fn(); ctx.restore(); }
    const bump = (t, a, b, f) => sstep((t - a) / f) * (1 - sstep((t - (b - f)) / f)); // enveloppe 0 → 1 → 0
    const BT0 = 20.0, MT0 = 31.0, MT1 = 46.0, MSPD = 780;
    function nightBack(ctx, t, off) {
      plate(ctx, 'moonBg', -15, -250, 4.2);
      for (let i = 0; i < 70; i++) fx(ctx, 'sparkle', ((t * (0.4 + rnd(i, 1)) + rnd(i, 2)) % 1) * 8, rnd(i, 3) * W, rnd(i, 4) * 400, 0.14 + rnd(i, 5) * 0.2, 0.9, { add: true });
      plate(ctx, 'moonFg', -30 - off * 0.01, -330, 4.2);
      ctx.save(); tileH(ctx, 'plainsTree', off * 0.4, -60, 3.2, 1); ctx.globalCompositeOperation = 'multiply';
      const gb = ctx.createLinearGradient(0, 240, 0, 420); gb.addColorStop(0, 'rgba(30,45,110,0)'); gb.addColorStop(1, 'rgba(30,45,110,0.6)'); ctx.fillStyle = gb; ctx.fillRect(-300, 240, W + 600, 480); ctx.restore();
    }
    // Les personnages de l'histoire : [pid, animation, direction, aura, x, pieds, échelle, vol]. Gros plan (échelle 6 → 11) : ils se matérialisent (trame + points de lumière) puis se dissolvent.
    const MEM_DUR = 2.6;
    const MEMORIES = [
      { t0: 33.3, rgb: '255,170,235', m: [['0151', 'Twirl', 0, '255,160,230', 300, 548, 7.4, 0], ['0251', 'Twirl', 0, '150,255,170', 650, 560, 8.4, 0], ['0490', 'Idle', 0, '120,235,255', 990, 566, 9.2, 0]] },
      { t0: 35.9, rgb: '120,190,255', m: [['0448', 'Pose', 0, '110,200,255', 290, 560, 10.5, 0], ['0571', 'Idle', 0, '255,150,120', 660, 566, 9.4, 0], ['0491', 'Idle', 0, '170,90,255', 1010, 574, 6.8, 0]] },
      { t0: 38.5, rgb: '255,205,225', m: [['0380', 'Idle', 0, '255,120,160', 300, 300, 8.0, 1], ['0492', 'Appeal', 0, '255,205,225', 650, 560, 10.5, 0], ['0381', 'Idle', 0, '120,160,255', 1000, 290, 7.2, 1]] },
      { t0: 41.1, rgb: '255,225,150', m: [['0282', 'Appeal', 0, '255,190,230', 250, 566, 11, 0], ['0040', 'Hop', 0, '255,175,215', 600, 575, 6.6, 0], ['0253', 'Pose', 0, '150,255,170', 930, 566, 11, 0], ['0441', 'Float', 0, '255,200,120', 1140, 190, 5.0, 1]] },
    ];
    function memories(ctx, t) {
      const env = MEMORIES.reduce((s, g) => Math.max(s, bump(t, g.t0, g.t0 + MEM_DUR + 0.5, 0.35)), 0);
      if (env > 0.003) { ctx.save(); ctx.fillStyle = 'rgba(4,8,36,' + (0.42 * env).toFixed(3) + ')'; ctx.fillRect(0, 0, W, H); ctx.restore(); }
      MEMORIES.forEach((g, gi) => {
        const qg = t - g.t0; if (qg < -0.05 || qg > MEM_DUR + 0.6) return;
        const ge = bump(t, g.t0, g.t0 + MEM_DUR + 0.5, 0.3);
        starBurst(ctx, W / 2, 330, 1000, 0.11 * ge, 16, qg * 0.08 + gi); glow(ctx, W / 2, 330, 560, g.rgb, 0.16 * ge);
        
        g.m.forEach((M, i) => { // plus de fondu : le personnage traverse le champ avec le mouvement de caméra (panoramique rapide, comme le plan de Lapras), il glisse jusqu'à sa pose puis repart de l'autre côté
          const q = qg - i * 0.2; if (q < -0.1 || q > MEM_DUR + 0.1) return;
          const TIN = 0.62, TOUT = 0.62, shAt = (qq) => 1750 * Math.pow(1 - clamp(qq / TIN, 0, 1), 3) - 1750 * Math.pow(clamp((qq - (MEM_DUR - TOUT)) / TOUT, 0, 1), 3);
          const sh = shAt(q), vx = (sh - shAt(q - 0.03)) / 0.03, sp = Math.min(1, Math.abs(vx) / 1500);
          const info = animInfo(M[0], M[1]), h = info ? info.fh * M[6] : 300, fly = !!M[7];
          const y = fly ? M[5] + Math.sin(t * 2.1 + i * 1.7) * 12 - q * 6 : M[5] - q * 5, x = M[4] + sh + Math.sin(t * 0.9 + i) * 5, cyy = fly ? y : y - h * 0.5;
          if (x < -320 || x > W + 320) return;
          glow(ctx, x, cyy, 120 + M[6] * 20, M[3], 0.42);
          if (sp > 0.05) { for (let gI = 4; gI >= 1; gI--) { const gx = x - vx * 0.013 * gI; ctx.save(); ctx.globalAlpha = 0.3 * sp / gI * 1.6; if (fly) spr(ctx, M[0], M[1], M[2], q * 60 * 0.9, gx, y, M[6], { fly: true, a: 0.5 * sp }); else spr(ctx, M[0], M[1], M[2], q * 60 * 0.9, gx, y, M[6], { a: 0.5 * sp, shadow: false }); ctx.restore(); } speedLines(ctx, t, Math.round(12 * sp), x, cyy, M[3], 0.5 * sp, 90, vx > 0 ? 0 : Math.PI); }
          if (fly) spr(ctx, M[0], M[1], M[2], q * 60 * 0.9, x, y, M[6], { fly: true, aura: M[3] });
          else spr(ctx, M[0], M[1], M[2], q * 60 * 0.9, x, y, M[6], { aura: M[3] });
          for (let s2 = 0; s2 < 6; s2++) fx(ctx, 'sparkle', ((t * (0.7 + rnd(s2, i)) + rnd(s2, 5 + i)) % 1) * 8, x + (rnd(s2, 3 + i) - 0.5) * M[6] * 34, cyy + (rnd(s2, 4 + i) - 0.5) * h, 0.34, 0.9, { add: true, tint: M[3] });
        });
      });
    }
    // ---- Course lunaire : Riolu, Évoli et Tiplouf (sprites PMDO animés) dans le décor de nuit (Moonlight + arbres des Plains) ----
    const RUN = [ // [pid, x d'arrivée, pieds, échelle, retard de pas, retard d'entrée]
      ['0393', 270, 640, 6.2, 5, 0.5], ['0133', 450, 668, 6.0, 0, 0.25], ['0447', 650, 652, 6.5, 3, 0],
    ];
    function fMoon(ctx, t) {
      const u = t - MT0, off = integ((x) => MSPD * (1 + 0.25 * sstep((x - 12) / 2)), u);
      const zz = 1 + 0.16 * sstep((u - 2) / 8) + 1.8 * sstep((t - 43.2) / 2.0), big = sstep((t - 43.2) / 2.0);
      const px = 650, py = 560, oxx = -60 * big;
      vgrad(ctx, [6, 10, 44], [24, 38, 86]);
      cam(ctx, zz, px, py, oxx, 0, () => {
        nightBack(ctx, t, off);
        tileH(ctx, 'plainsTree', off, -200, 4.4);
        ctx.save(); ctx.globalCompositeOperation = 'multiply'; ctx.fillStyle = 'rgba(70,92,190,0.85)'; ctx.fillRect(-300, 250, W + 600, 520); ctx.restore();
      });
      memories(ctx, t);
      cam(ctx, zz, px, py, oxx, 0, () => {
        RUN.forEach((R) => {
          const e = sstep((u - R[5]) / 2.1), x = lerp(-260, R[1], e), tick = u * 60 * 2.5 + R[4] * 7, moving = e < 0.999;
          glow(ctx, x, R[2] - 90, 150, '150,190,255', 0.16);
          spr(ctx, R[0], 'Walk', 2, tick, x, R[2], R[3], {});
        });
        for (let i = 0; i < 22; i++) fx(ctx, 'sparkle', ((t * 0.8 + rnd(i, 5)) % 1) * 8, rnd(i, 6) * W, 300 + rnd(i, 7) * 340 + Math.sin(t * 1.3 + i) * 16, 0.28, 0.85, { add: true, tint: '255,240,120' });
      });
      speedLines(ctx, t, 18, W * 0.5, H * 0.5, '170,200,255', 0.22 + 0.2 * big, 420, Math.PI);
      const dk = sstep((t - 44.0) / 1.6); glow(ctx, W * 0.9, 470, 520 * dk, '255,140,120', 0.45 * dk);
    }
    SC.push({ id: 'MR', t0: MT0, t1: MT1, custom: fMoon });

    // ---------- Plage de PMD Sky : textures canoniques (mer au soleil couchant + sable, écume et rochers) · caméra qui s'incline du ciel vers la plage ----------
    const SEA_S = 2.581, SAND_S = 5.254, SEA_OV = 120, TILT0 = 23.6, TILT1 = 27.4;
    const LGS = 1.7, LGY = 58, LGPAD = 90, LGSTRIP = 5; // logo généré (448×241 px) affiché ×1,7 ; marge haute pour la chute des bandes
    let LG2 = null, LG2X = null;
    const BUBBLES = [[66, 30, 15], [252, 62, 32], [462, 50, 21], [198, 115, 15], [248, 230, 22], [95, 350, 16], [472, 330, 15], [85, 440, 38], [404, 428, 31], [295, 485, 16], [160, 555, 49], [323, 603, 37], [4, 587, 14], [418, 542, 16], [188, 718, 22], [355, 705, 16]]; // [x, y, rayon] dans la texture
    const lgDim = () => { const L = I.pmdLogo; return L && L.width ? [L.width, L.height] : [448, 241]; };
    const LGX = () => (W - lgDim()[0] * LGS) / 2;
    const LX = () => LGX() + 0.84 * lgDim()[0] * LGS, LY = () => LGY + 0.2 * lgDim()[1] * LGS, TL = 30.0; // l'étoile-badge atterrit sur le logo à la mesure 64 (30,0 s)
    const IR0 = 30.4688, IR1 = 31.55; // l'étoile s'ouvre sur la course lunaire (mesure 65 → 31,5 s)
    let SANDC = null;
    function sandPlate() { // sable : le haut est fondu avec le bas de la mer du couchant (dégradé tramé)
      if (SANDC) return SANDC; const im = I.beachSand; if (!im || !im.width) return null;
      const w = Math.round(im.width * SAND_S), h = Math.round(im.height * SAND_S); SANDC = mk(w, h); const c = SANDC.getContext('2d'); c.imageSmoothingEnabled = false; c.drawImage(im, 0, 0, w, h);
      c.globalCompositeOperation = 'destination-in'; const g = c.createLinearGradient(0, 0, 0, 170); g.addColorStop(0, 'rgba(0,0,0,0)'); g.addColorStop(1, 'rgba(0,0,0,1)'); c.fillStyle = g; c.fillRect(0, 0, w, h); return SANDC;
    }
    const easeBack = (k) => { const c1 = 2.2, c3 = c1 + 1; return 1 + c3 * Math.pow(k - 1, 3) + c1 * Math.pow(k - 1, 2); };
    function logoDraw(ctx, t) { // le logo se construit en vague (bandes verticales qui retombent avec rebond, de gauche à droite), puis un reflet le balaie et des étincelles dansent sur le ruban
      const L = I.pmdLogo; if (!L || !L.width) return; const w = L.width, h = L.height, T0 = 27.66;
      if (t < T0) return; if (!LG2) { LG2 = mk(w, h + LGPAD); LG2X = LG2.getContext('2d'); }
      const c = LG2X; c.save(); c.setTransform(1, 0, 0, 1, 0, 0); c.globalAlpha = 1; c.globalCompositeOperation = 'source-over'; c.clearRect(0, 0, w, h + LGPAD);
      for (let x = 0; x < w; x += LGSTRIP) { const k = clamp((t - T0 - (x / w) * 0.85) / 0.55, 0, 1); if (k <= 0) continue; c.globalAlpha = Math.min(1, k * 3); c.drawImage(L, x, 0, LGSTRIP, h, x, LGPAD - (1 - easeBack(k)) * 70, LGSTRIP, h); }
      const sh = clamp((t - 29.0) / 0.8, 0, 1);
      if (sh > 0 && sh < 1) { c.globalAlpha = 1; c.globalCompositeOperation = 'source-atop'; const gx = lerp(-60, w + 60, sh), g = c.createLinearGradient(gx - 26, 0, gx + 26, 60); g.addColorStop(0, 'rgba(255,255,255,0)'); g.addColorStop(0.5, 'rgba(255,255,255,0.8)'); g.addColorStop(1, 'rgba(255,255,255,0)'); c.fillStyle = g; c.fillRect(0, 0, w, h + LGPAD); }
      c.restore();
      const kk = clamp((t - T0) / 1.4, 0, 1); glow(ctx, W / 2, LGY + h * LGS / 2, 560, '255,230,150', 0.34 * Math.sin(Math.PI * kk));
      ctx.save(); ctx.imageSmoothingEnabled = false; ctx.drawImage(LG2, 0, 0, w, h + LGPAD, LGX(), LGY - LGPAD * LGS, w * LGS, (h + LGPAD) * LGS); ctx.restore();
      if (t > T0 + 1.2) for (let j = 0; j < 4; j++) { const P = [[0.2, 0.86], [0.8, 0.86], [0.5, 0.12], [0.36, 0.5]][j]; fx(ctx, 'sparkle', ((t * 1.1 + j * 0.27) % 1) * 8, LGX() + P[0] * w * LGS, LGY + P[1] * h * LGS, 0.55, 0.95, { add: true, tint: '255,240,170' }); }
    }
    function wfPos(t) { // trajet du badge-étoile (espace écran) : il arrive en volant, se tient au-dessus de Riolu, s'élève hors champ, puis TOMBE sur le logo en dernier
      if (t < 23.3) return null;
      if (t < 27.0) { const q = sstep((t - 23.3) / 3.7); return [lerp(-80, 585, q), lerp(150, 430, q) - Math.sin(q * Math.PI) * 80, 3.0]; }
      if (t < 27.4) return [585, 430 + Math.sin(t * 3) * 4, 3.0];
      if (t < 28.5) { const w = (t - 27.4) / 1.1; return [585 + Math.sin(w * 6) * 10, 430 - 760 * w * w, 3.0]; }
      if (t < 29.0) return null;
      if (t < TL) { const q = (t - 29.0) / (TL - 29.0); return [LX() + 120 * (1 - q), lerp(-150, LY(), q * q), 4.8]; }
      return [LX(), LY() + Math.sin((t - TL) * 7) * 2, 4.8 + 1.0 * Math.max(0, 1 - (t - TL) / 0.3)];
    }
    // UN SEUL groupe — un Bekipan (sprite PMDO de profil) mène cinq Goélise (sprites PMDO) — qui voyage au loin vers la droite en rapetissant
    const FLOCK = [[-110, -38, 3.9, 0], [-126, 46, 3.8, 4], [-224, -82, 4.0, 8], [-242, 88, 3.7, 2], [-346, -120, 3.9, 6]]; // [dx, dy, échelle, phase]
    function flock(ctx, t, dyScroll) {
      const u = t - 20.2, sc = 1 - 0.03 * Math.max(0, u), fx0 = -230 + u * 190, fy0 = 300 + Math.sin(t * 0.9) * 5 - dyScroll;
      if (u < 0 || fx0 - 300 > W + 100 || fy0 < -200) return;
      spr(ctx, '0279', 'Walk', 2, t * 60 * 0.8, fx0, fy0 + Math.sin(t * 3.6) * 3, 4.4 * sc, { fly: true });
      FLOCK.forEach((F, i) => spr(ctx, '0278', 'Hover', 2, t * 60 * 0.8 + F[3] * 3, fx0 + F[0] * sc, fy0 + F[1] * sc + Math.sin(t * 2.2 + i * 1.9) * 4, F[2] * sc, { fly: true }));
    }
    function fBeach(ctx, t) {
      const u = t - 20, sea = I.beachSea, sandI = I.beachSand; if (!sea || !sandI) return;
      const SEA_H = sea.height * SEA_S, seaTop = -SEA_H + SEA_OV, Y0 = seaTop + 514, Y1 = 150, e = sstep((t - TILT0) / (TILT1 - TILT0)), Yc = lerp(Y0, Y1, e);
      const shk = (t >= TL && t < TL + 0.3) ? (1 - (t - TL) / 0.3) * 12 : 0;
      ctx.save(); if (shk) ctx.translate((rnd(Math.floor(t * 60), 1) - 0.5) * shk, (rnd(Math.floor(t * 60), 2) - 0.5) * shk);
      ctx.fillStyle = '#0a7fd0'; ctx.fillRect(-20, -20, W + 40, H + 40);
      ctx.save(); ctx.translate(0, -Yc); ctx.imageSmoothingEnabled = false;
      const sw = sea.width * SEA_S; ctx.drawImage(sea, 0, 0, sea.width, 330, -10, seaTop, sw + 20, 330 * SEA_S);
      for (let r = 330; r < sea.height; r += 2) { const y = seaTop + r * SEA_S; if (y > Yc + H + 10 || y + 2 * SEA_S < Yc - 10) continue; const ox = Math.round(Math.sin(r * 0.21 + t * 1.6) * (0.3 + (r - 330) / 420 * 1.3) * SEA_S * 0.5); ctx.drawImage(sea, 0, r, sea.width, 2, -30 + ox, y, sw + 60, 2 * SEA_S + 1); }
      glow(ctx, 645, seaTop + 282 * SEA_S, 300, '255,236,170', 0.4 + 0.05 * Math.sin(t * 2));
      for (let i = 0; i < 40; i++) fx(ctx, 'sparkle', ((t * 0.9 + rnd(i, 3)) % 1) * 8, 90 + rnd(i, 1) * 1100, seaTop + (345 + rnd(i, 2) * 330) * SEA_S, 0.26, 0.9, { add: true });
      const bb = I.beachBubbles; // bulles de la texture, animées : remontée + balancement + bouclage (elles ressortent en bas après avoir quitté le haut)
      if (bb && bb.width) {
        ctx.save(); ctx.imageSmoothingEnabled = false; const per = bb.height + 110;
        BUBBLES.forEach((B, i) => {
          const r = B[2] + 3, sp = 9 + (i % 5) * 4.5, sc = SEA_S * (0.8 + 0.3 * ((i * 7) % 5) / 4);
          let row = (((B[1] - u * sp) % per) + per) % per; if (row > bb.height + 55) row -= per;
          const sx = Math.max(0, B[0] - r), sy = Math.max(0, B[1] - r), sw2 = Math.min(bb.width, B[0] + r) - sx, sh2 = Math.min(bb.height, B[1] + r) - sy;
          const cx = B[0] * SEA_S + Math.sin(u * 0.8 + i * 1.7) * 14, cy = seaTop + row * SEA_S;
          ctx.drawImage(bb, sx, sy, sw2, sh2, cx + (sx - B[0]) * sc, cy + (sy - B[1]) * sc, sw2 * sc, sh2 * sc);
        });
        ctx.restore();
      }
      const sp = sandPlate(); if (sp) {
        ctx.drawImage(sp, -1, 0);
        const fr = 58, fh = 22; for (let b = 0; b < 2; b++) { const ox = Math.round(Math.sin(t * 1.4 + b * 2) * 1.6 + Math.sin(t * 0.7) * 1.2); ctx.save(); ctx.globalAlpha = 0.5; ctx.drawImage(sandI, 0, fr, 150, fh, -1 + ox * SAND_S, fr * SAND_S + b * 3, 150 * SAND_S, fh * SAND_S); ctx.restore(); }
        [[300, 0.0], [1010, 0.5], [640, 0.9]].forEach((q) => { const sf = Math.floor((t + q[1]) * 7) % 16; if (sf < 8) fx(ctx, 'splash', sf, q[0], 392, 1.3, 0.8, { bottom: true }); });
        for (let i = 0; i < 16; i++) fx(ctx, 'sparkle', ((t * 0.8 + rnd(i, 13)) % 1) * 8, 60 + rnd(i, 11) * 1160, 60 + rnd(i, 12) * 220, 0.24, 0.85, { add: true });
      }
      const xs = [840, 560, 700], gy = [770, 766, 780];
      spr(ctx, '0393', 'Idle', 6, (t - 20) * 60, xs[0], gy[0], 5.2); spr(ctx, '0133', 'Idle', 6, (t - 20) * 60 + 11, xs[2], gy[2], 5.2);
      const rp = u > 8 ? 'Pose' : 'Idle'; spr(ctx, '0447', rp, 6, u > 8 ? (u - 8) * 60 : u * 60, xs[1], gy[1], 5.2, { loop: u <= 8 });
      ctx.restore();
      flock(ctx, t, 0.2 * (Yc - Y0));
      petalWind(ctx, t, Math.round(60 * sstep((t - 24) / 4)), 5, -1, 60, 0.07, 1.6);
      godRays(ctx, t, 0.2, W * 0.5, -30, 6, 0.9, H * 1.3, '255,214,150');
      const env = sstep((t - 27.2) / 0.8); if (env > 0.003) { ctx.save(); ctx.fillStyle = 'rgba(10,20,60,' + (0.34 * env).toFixed(3) + ')'; ctx.fillRect(0, 0, W, H); ctx.restore(); }
      const pul = 1 + 0.045 * Math.max(0, 1 - (t - TL) / 0.28) * (t >= TL ? 1 : 0);
      ctx.save(); ctx.translate(W / 2, LGY + lgDim()[1] * LGS / 2); ctx.scale(pul, pul); ctx.translate(-W / 2, -(LGY + lgDim()[1] * LGS / 2));
      logoDraw(ctx, t);
      ctx.restore();
      const wp = wfPos(t);
      if (wp) { wayfinder(ctx, 'wfCyan', wp[0], wp[1], wp[2], t, 1, '120,235,255'); trail(ctx, t, (tt) => { const p = wfPos(tt); return p ? [p[0], p[1]] : [-999, -999]; }, 23.3, 12, 0.05, 0.4, '170,245,255'); }
      const d = t - TL; // impact de l'étoile sur le logo
      if (d >= 0 && d < 0.7) {
        flash(ctx, 0.45 * Math.max(0, 1 - d / 0.22), '255,245,200'); ring(ctx, LX(), LY(), d * 520, 2.5, '255,230,140', 0.9 * (1 - d / 0.7), 1); ring(ctx, LX(), LY(), d * 300, 1.5, '170,245,255', 0.8 * (1 - d / 0.7), 1);
        fx(ctx, 'hit', d / 0.4 * 8, LX(), LY(), 1.6, 1, { tint: '255,235,150' });
        for (let j = 0; j < 20; j++) { const a = j / 20 * TAU, r = d * (260 + rnd(j, 1) * 260); fx(ctx, 'sparkle', (d * 16 + j) % 8, LX() + Math.cos(a) * r, LY() + Math.sin(a) * r * 0.8, 0.5, 1 - d / 0.7, { add: true, tint: '255,240,160' }); }
      }
      if (t >= 29.0 && t < TL) glow(ctx, LX(), LY() - 60, 120, '170,245,255', 0.4);
      flash(ctx, 1 - sstep(u / 0.7), '255,255,255');
      ctx.restore();
    }
    function starPath(ctx, cx, cy, R, rot) { ctx.beginPath(); for (let i = 0; i < 10; i++) { const a = rot - Math.PI / 2 + i * Math.PI / 5, r = i % 2 ? R * 0.46 : R; if (i) ctx.lineTo(cx + Math.cos(a) * r, cy + Math.sin(a) * r); else ctx.moveTo(cx + Math.cos(a) * r, cy + Math.sin(a) * r); } ctx.closePath(); }
    function irisR(t) { const k = clamp((t - IR0) / (IR1 - IR0), 0, 1); return 52 * Math.pow(3200 / 52, Math.pow(k, 1.6)); }

    // ---------- Compositeur : Voyage (0 → 31) · Course lunaire (31 → 46) · Opening sprites (46 → 153) ----------
    const V = root.PMDDestinyVoyage.create(EV), S = root.PMDDestinySprite.create(EV);
    function bars(ctx, t) { const k = sstep((t - 0.2) / 1.2); const h = 52 * k * (1 - sstep((t - 146.8) / 0.8)); ctx.fillStyle = '#000'; ctx.fillRect(0, 0, W, h); ctx.fillRect(0, H - h, W, h); }
    const OC1 = V.SC.find((q) => q.id === 'OC1');
    function frameBeach(ctx, t) { fBeach(ctx, t); vignette(ctx, 0.5); bars(ctx, t); }
    function render(ctx, t, opts) {
      opts = opts || {}; t = clamp(t, 0, D);
      if (t < BT0) return V.render(ctx, t, opts);
      if (t >= MT1) {
        const r = S.render(ctx, t, opts), f = 1 - sstep((t - MT1) / 0.7);
        if (f > 0.003) { ctx.save(); flash(ctx, f, '255,255,255'); ctx.restore(); }
        return r;
      }
      ctx.save(); ctx.imageSmoothingEnabled = true; ctx.globalAlpha = 1; ctx.globalCompositeOperation = 'source-over'; ctx.fillStyle = '#000'; ctx.fillRect(0, 0, W, H);
      const blend = (drawA, drawB, k) => { // fondu : A dans l'écran, B dans le tampon
        drawA(ctx); sctx.save(); sctx.globalAlpha = 1; sctx.globalCompositeOperation = 'source-over'; sctx.clearRect(0, 0, W, H); drawB(sctx); sctx.restore();
        ctx.globalAlpha = k; ctx.drawImage(scr, 0, 0); ctx.globalAlpha = 1;
      };
      if (t < BT0 + 0.5) blend((c) => { OC1.custom(c, t); vignette(c, 0.5); bars(c, t); }, (c) => frameBeach(c, t), sstep((t - BT0) / 0.5));
      else if (t < IR0) frameBeach(ctx, t);
      else if (t < IR1) { // l'étoile-badge s'ouvre : la course lunaire apparaît à l'intérieur de l'étoile qui grandit
        fBeach(ctx, t); const R = irisR(t), rot = (t - IR0) * 1.6;
        ctx.save(); starPath(ctx, LX(), LY(), R, rot); ctx.clip(); fMoon(ctx, Math.max(t, MT0)); ctx.restore();
        ctx.save(); starPath(ctx, LX(), LY(), R, rot); ctx.lineJoin = 'round'; ctx.strokeStyle = 'rgba(255,238,160,' + (1 - sstep((t - IR0) / (IR1 - IR0))).toFixed(3) + ')'; ctx.lineWidth = 7; ctx.stroke(); ctx.restore();
        vignette(ctx, 0.5); bars(ctx, t);
      } else { fMoon(ctx, t); vignette(ctx, 0.5); bars(ctx, t); }
      const wf = sstep((t - 45.1) / 0.9); if (wf > 0.003 && t >= MT0) flash(ctx, wf, '255,255,255');
      ctx.restore(); return { wing: 0, shot: t < IR0 ? 'SF' : 'MR' };
    }
    function renderTitleMode(ctx, tl, theme, nowSec, flapStart) { return S.renderTitleMode(ctx, tl, theme, nowSec, flapStart); }
    return { render, renderTitleMode, W, H, D, CHAPTERS, TITLE_T, IMPACTS: S.IMPACTS, SC };
  }
  root.PMDDestinyUltime = { create, W, H, D, CHAPTERS, TITLE_T, IMPACTS, BEAT };
})(typeof window !== 'undefined' ? window : globalThis);
