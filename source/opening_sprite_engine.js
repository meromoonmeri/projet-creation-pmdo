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
    { t: 0.0, name: "I · Au fond de l'océan — le Wayfinder", short: 'I · Océan & Rivage' },
    { t: 24.0, name: 'II · Chute dans la lumière — le Vitrail du Destin', short: 'II · Vitrail du Destin' },
    { t: 46.0, name: 'III · Trois Wayfinders — les 13 sièges de ténèbres', short: 'III · 13 Ténèbres' },
    { t: 68.0, name: "IV · Mêlée dans l'Arène Eau-Miroir", short: 'IV · Mêlée Eau-Miroir' },
    { t: 106.0, name: 'V · Chute céleste — la barrière de lumière', short: 'V · Chute Céleste' },
    { t: 132.0, name: "VI · Le Rayon d'Espoir", short: "VI · Rayon d'Espoir" },
  ];
  const IMPACTS = [77.0, 79.2, 81.0, 83.4, 85.6, 87.4, 92.6, 94.2, 96.0, 98.2, 100.4, 102.2, 104.0];
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
    const rigC = mk(580, 418), rigX = rigC.getContext('2d');
    const tintC = mk(580, 418), tintX = tintC.getContext('2d');
    const mini = mk(256, 144), miniX = mini.getContext('2d');
    const MW = 576, MH = 320;

    // ---------- Primitives écran ----------
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
      const pos = posOf(def, t);
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
      return { pos, anim: e[1], dir: dir | 0, tick: tAnim * 60 * (opt.speed || 1), loop: opt.loop !== false, al, rot, sc };
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
    function sparklesWorld(ctx, t, n, seed, x0, y0, x1, y1, rgb, size) { // scintillement pixel 4 branches
      ctx.save(); ctx.globalCompositeOperation = 'lighter';
      for (let i = 0; i < n; i++) {
        const ph = (t * (0.5 + rnd(i, seed + 2) * 0.8) + rnd(i, seed)) % 1, a = Math.sin(ph * Math.PI);
        if (a < 0.1) continue;
        const x = Math.round(lerp(x0, x1, rnd(i, seed + 1))), y = Math.round(lerp(y0, y1, rnd(i, seed + 3)));
        ctx.fillStyle = `rgba(${rgb},${a.toFixed(2)})`; const s = size || 1;
        ctx.fillRect(x, y, s, s); if (a > 0.5) { ctx.fillRect(x - s, y, s, s); ctx.fillRect(x + s, y, s, s); ctx.fillRect(x, y - s, s, s); ctx.fillRect(x, y + s, s, s); }
      }
      ctx.restore();
    }
    function bubblesWorld(ctx, t, n, seed, x0, x1, y0, y1, speed) {
      ctx.save(); ctx.lineWidth = 0.7;
      for (let i = 0; i < n; i++) {
        const x = lerp(x0, x1, rnd(i, seed)) + Math.sin(t * 1.4 + i * 2.3) * 2.2;
        const k = ((t * speed * (0.5 + rnd(i, seed + 2)) * 0.05 + rnd(i, seed + 1)) % 1);
        const y = lerp(y1, y0, k), r = 0.8 + rnd(i, seed + 3) * 2.4;
        ctx.strokeStyle = `rgba(200,244,255,${(0.7 * Math.sin(k * Math.PI)).toFixed(2)})`; ctx.beginPath(); ctx.arc(x, y, r, 0, TAU); ctx.stroke();
        ctx.fillStyle = 'rgba(255,255,255,0.8)'; ctx.fillRect(x - r * 0.4, y - r * 0.4, 0.8, 0.8);
      }
      ctx.restore();
    }
    function wayfinder(ctx, key, x, y, s, t, a, rgb) {
      const im = I[key]; if (!im) return;
      glow(ctx, x, y, 26 * s, rgb, 0.55 * a * (0.75 + 0.25 * Math.sin(t * 4)));
      ctx.save(); ctx.globalAlpha = a; ctx.translate(x, y); ctx.scale(s, s); ctx.drawImage(im, -14, -14, 28, 28); ctx.restore();
    }
    function shardsW(ctx, x, y, u, n, seed, cols, speed, size) {
      if (u < 0 || u > 1.5) return;
      ctx.save();
      for (let i = 0; i < n; i++) {
        const a = rnd(i, seed) * TAU, v = speed * (0.35 + rnd(i, seed + 1));
        const px = x + Math.cos(a) * v * u, py = y + Math.sin(a) * v * u * 0.7 + 60 * u * u, s = size * (0.5 + rnd(i, seed + 3));
        ctx.globalAlpha = clamp(1 - u / 1.4, 0, 1); ctx.fillStyle = cols[i % cols.length];
        ctx.save(); ctx.translate(px, py); ctx.rotate(u * (rnd(i, seed + 2) - 0.5) * 16);
        ctx.beginPath(); ctx.moveTo(-s, s * 0.6); ctx.lineTo(s * 0.2, -s); ctx.lineTo(s, s * 0.5); ctx.closePath(); ctx.fill(); ctx.restore();
      }
      ctx.restore();
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
      drawMap(ctx, sc.map, t, sc.water);
      if (sc.world) sc.world(ctx, t, c, 'under');
      // acteurs + props triés en profondeur
      const items = [];
      (sc.actors || []).forEach((a) => {
        const vis = a.vis || [sc.t0 - 1, sc.t1 + 1]; if (t < vis[0] || t > vis[1]) return;
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
      return c;
    }

    // ================== PLANS ==================
    const SC = [];
    const dais = [288, 152];
    // ---- Chapitre I ----
    // 1a : fond de l'océan, grue montante, le Wayfinder gît sur la dalle
    SC.push({
      id: '1a', t0: 0, t1: 6, map: 'opm2', grade: 'rgb(150,200,255)',
      cam: [[0, 288, 205, 3.4, -0.06], [3, 288, 170, 2.4, 0.02], [6, 288, 118, 1.5, 0.0]],
      props: [{ img: 'wfCyan', keys: [[0, 288, 150, 0]], s: 1.2 }],
      actors: [{ id: 'manaphy', pid: '0490', keys: [[0, 170, 230, 0], [6, 380, 130, 0]], an: [[0, 'Walk', 'auto', { speed: 0.7 }]], noShadow: true, aura: '120,230,255', s: 0.9, a: [[0, 0], [1.5, 0.8], [5, 0.8], [6, 0]] }],
      world(ctx, t, c, ph) { if (ph !== 'over') return; bubblesWorld(ctx, t, 26, 5, 150, 430, 20, 270, 1.0); sparklesWorld(ctx, t, 40, 6, 190, 60, 390, 250, '190,250,255', 1);
        glow(ctx, 288, 150, 90, '120,240,255', 0.2 + 0.1 * Math.sin(t * 3)); },
      screen(ctx, t, c) { godRays(ctx, t, 0.5, W * 0.5, -20, 9, 1.4, H * 1.1, '210,250,255'); particlesScreen(ctx, t, { n: 24, rgb: '190,245,255', a: 0.5, r: 2, vy: -0.6, bubble: true, camY: c.cy * 4 }); },
    });
    // 1b : le trio joue sur la plage — travelling latéral bas
    const trioWalk = (pid, id, x0, y0, x1, y1, tA, tB, extra) => ({ id, pid, keys: [[tA - 6, x0, y0], [tB, x1, y1]], reflect: true, ...extra });
    SC.push({
      id: '1b', t0: 6, t1: 11, map: 'opm1', water: [112, 320, 0.7, 0.3], reflect: false,
      cam: [[6, 380, 108, 2.0, 0.03], [8.5, 320, 112, 2.2, 0.0], [11, 262, 112, 2.4, -0.03]],
      actors: [
        { id: 'riolu', pid: '0447', keys: [[6, 242, 100], [8, 250, 106], [9, 262, 112]], an: [[6, 'Walk', 'auto'], [8, 'Hop', 0, { loop: false }], [9.3, 'Idle', 0]] },
        { id: 'evoli', pid: '0133', keys: [[6, 292, 96], [11, 300, 98]], an: [[6, 'Hop', 0, { loop: false }], [7, 'Idle', 6], [8.4, 'Hop', 2, { loop: false }], [9.5, 'Idle', 2]] },
        { id: 'tiplouf', pid: '0393', keys: [[6, 336, 100], [8, 322, 104], [11, 318, 106]], an: [[6, 'Walk', 'auto'], [8, 'Swing', 6, { loop: false }], [9.5, 'Idle', 6]] },
      ],
      world(ctx, t, c, ph) { if (ph === 'over') { sparklesWorld(ctx, t, 60, 8, 0, 130, 576, 260, '255,255,230', 1); ring(ctx, 262, 118, 4 + ((t * 0.7) % 1) * 18, 0.6, '230,255,255', 0.6 * (1 - (t * 0.7) % 1), 0.4); } },
      screen(ctx, t, c) { godRays(ctx, t, 0.18, W * 0.1, 40, 6, 1.0, H, '255,236,180'); particlesScreen(ctx, t, { n: 18, rgb: '255,250,210', a: 0.8, r: 2, vx: 0.4, vy: -0.2, tw: true, add: true, camX: c.cx * 4 }); },
    });
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
      cam: [[19, 288, 150, 5.0, 0.0], [24, 288, 150, 2.2, 0.1]],
      props: [{ img: 'wfCyan', keys: [[19, 288, 150, 0]], s: [[19, 1.5], [24, 2.4]] }],
      world(ctx, t, c, ph) { if (ph !== 'over') return; const k = sstep((t - 19) / 4.4); glow(ctx, 288, 150, lerp(120, 520, k), '150,245,255', 0.5 + 0.5 * k); starBurst(ctx, 288, 150, lerp(160, 700, k), 0.5 + 0.4 * k, 10, t * 0.4); bubblesWorld(ctx, t, 26, 15, 200, 380, 40, 230, 1.6); },
      screen(ctx, t) { flash(ctx, sstep((t - 23.0) / 1.0)); },
    });

    // ---- Chapitre II : projecteur, chute arrière, vitrail ----
    const fall = (t) => 30 + (t - 24) * 6.2; // altitude de chute d'Évoli (y monde)
    SC.push({
      id: '2a', t0: 24, t1: 36, map: 'opm2', free: true, bg: '#010208', grade: 'rgb(70,110,190)',
      cam: [[24, 288, -8, 3.0, 0.1], [30, 288, 72, 2.4, -0.08], [36, 288, 150, 2.0, 0.06]],
      actors: [{ id: 'evoli', pid: '0133', keys: [[24, 288, -22], [30, 280, 70], [36, 262, 140]], an: [[24, 'Sink', 0, { loop: true, speed: 0.45 }]], rot: [[24, -0.9], [36, -0.5]], s: 1.0, a: [[24, 0], [26, 1]], aura: '120,230,255', noShadow: true },
        { id: 'celebi', pid: '0251', keys: [[30, 360, 20], [36, 330, 120]], an: [[30, 'Float', 0]], noShadow: true, aura: '120,255,160', a: [[30, 0], [31.5, 0.9]], rot: [[30, 0.3], [36, -0.2]] }],
      props: [{ img: 'wfCyan', keys: [[24, 296, -28], [36, 296, 142]], s: 0.6, a: [[24, 0], [26, 1]] }],
      world(ctx, t, c, ph) {
        if (ph === 'over') { sparklesWorld(ctx, t, 90, 21, 120, -40, 460, 330, '200,240,255', 1);
          const gk = sstep((t - 29) / 4); if (gk > 0) { ctx.save(); ctx.globalAlpha = gk; const vm = I.vitrail; ctx.drawImage(vm, 288 - 130, 150 - 118, 260, 236); ctx.restore(); glow(ctx, 288, 150, 190, '120,200,255', 0.35 * gk); } }
      },
      screen(ctx, t) { ctx.save(); ctx.globalCompositeOperation = 'lighter'; const g = ctx.createLinearGradient(0, 0, 0, H); g.addColorStop(0, 'rgba(210,250,255,0.5)'); g.addColorStop(1, 'rgba(120,220,255,0)'); ctx.fillStyle = g; ctx.beginPath(); ctx.moveTo(W * 0.43, 0); ctx.lineTo(W * 0.57, 0); ctx.lineTo(W * 0.85, H); ctx.lineTo(W * 0.15, H); ctx.closePath(); ctx.fill(); ctx.restore();
        particlesScreen(ctx, t, { n: 50, rgb: '190,245,255', a: 0.7, r: 2, vy: -1.4, bubble: true }); },
    });
    SC.push({
      id: '2b', t0: 36, t1: 46, map: 'opm2', free: true, bg: '#010208', grade: (t) => `rgb(${Math.round(lerp(80, 220, sstep((t - 40) / 5)))},${Math.round(lerp(120, 240, sstep((t - 40) / 5)))},255)`,
      cam: [[36, 288, 150, 2.0, 0.06], [41, 288, 160, 1.4, -0.04], [46, 288, 150, 1.5, 0.0]],
      actors: [{ id: 'evoli', pid: '0133', keys: [[36, 262, 130], [46, 330, 168]], an: [[36, 'Sink', 0, { speed: 0.4 }]], rot: [[36, -0.5], [46, -0.2]], s: 1.0, aura: '130,235,255', noShadow: true }],
      world(ctx, t, c, ph) { if (ph === 'under') { ctx.save(); ctx.globalAlpha = 1; ctx.drawImage(I.vitrail, 288 - 130, 150 - 118, 260, 236); ctx.restore(); const lit = sstep((t - 40) / 4.5); glow(ctx, 288, 150, 220, '255,255,255', 0.7 * lit); }
        if (ph === 'over') { sparklesWorld(ctx, t, 90, 22, 100, 20, 480, 300, '255,246,200', 1); starBurst(ctx, 288, 150, 360, 0.5 * sstep((t - 40) / 4), 12, t * 0.3); } },
      screen(ctx, t) { flash(ctx, sstep((t - 44.6) / 1.4)); },
    });

    // ---- Chapitre III : trois Wayfinders, 13 sièges de ténèbres ----
    SC.push({
      id: '3a', t0: 46, t1: 52.5, map: 'opm1', water: [112, 320, 0.7, 0.3], grade: 'rgb(170,175,220)',
      cam: [[46, 300, 150, 1.0, 0.0], [49, 286, 112, 1.5, 0.05], [52.5, 262, 118, 2.2, -0.04]],
      actors: [
        { id: 'riolu', pid: '0447', keys: [[46, 250, 104]], an: [[46, 'Pose', 0, { loop: false }], [49.2, 'Hop', 0, { loop: false }]] },
        { id: 'evoli', pid: '0133', keys: [[46, 288, 108]], an: [[46, 'Hurt', 0], [48.6, 'Idle', 0]] },
        { id: 'tiplouf', pid: '0393', keys: [[46, 326, 106]], an: [[46, 'Idle', 6], [48, 'Hop', 6, { loop: false }]] },
      ],
      props: [0, 1, 2].map((i) => ({ img: ['wfCyan', 'wfEmerald', 'wfAmber'][i], rgb: ['120,235,255', '120,255,190', '255,210,100'][i], keys: [[46 + 0.4 + i * 0.75, 200 + i * 80, -30, 0], [46 + 0.4 + i * 0.75 + 1.7, 200 + i * 80, 165, 0]], s: 1.0, a: [[46 + 0.4 + i * 0.75, 1], [46 + 0.4 + i * 0.75 + 1.69, 1], [46 + 0.4 + i * 0.75 + 1.72, i === 2 ? 1 : 0]] })),
      world(ctx, t, c, ph) { if (ph !== 'over') return; const u = t - 46;
        for (let i = 0; i < 3; i++) { const ti = 0.4 + i * 0.75 + 1.7, w = u - ti, X = 200 + i * 80;
          if (u > 0.4 + i * 0.75 && w < 0) { for (let k = 1; k < 9; k++) glow(ctx, X, lerp(-30, 165, clamp((u - 0.4 - i * 0.75) / 1.7, 0, 1)) - k * 8, 10 - k, '150,240,255', 0.3 - k * 0.03); }
          if (w >= 0) { const k = Math.exp(-w * 3); glow(ctx, X, 165, 60 * (0.5 + k), '255,255,255', 0.8 * k); starBurst(ctx, X, 165, 80 * (0.5 + k), 0.9 * k, 9, i);
            for (let r = 0; r < 3; r++) { const pr = clamp(w * 1.1 - r * 0.2, 0, 1.6); ring(ctx, X, 165, 4 + pr * 50, 0.8, '230,255,255', 0.8 * (1 - pr / 1.6), 0.35); }
            if (i < 2) shardsW(ctx, X, 160, w, 22, 40 + i, i ? ['#fff', '#ff9ac6', '#ffe08a'] : ['#fff', '#9ff4ff', '#ffd45a'], 90, 3); } }
        for (let k = 0; k < 6; k++) { const tf = 0.9 + k * 0.78, d = u - tf; if (d > 0 && d < 0.22) starBurst(ctx, 100 + rnd(k, 3) * 400, 130 + rnd(k, 4) * 40, 50, 1 - d / 0.22, 6, k); } },
      screen(ctx, t) { particlesScreen(ctx, t, { n: 30, rgb: '255,240,200', a: 0.8, r: 2, vy: -0.3, tw: true, add: true }); flash(ctx, sstep((t - 51.8) / 0.7)); },
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
    function flames(ctx, t, ign) {
      for (let i = 0; i < PIL.length; i++) {
        const k = sstep(ign[i]); if (k <= 0) continue; const x = PIL[i][0], y = PIL[i][1] - 3;
        glow(ctx, x, y - 8, 46, '255,90,200', 0.75 * k * (0.75 + 0.25 * Math.sin(t * 8 + i)));
        ctx.save(); ctx.globalCompositeOperation = 'lighter';
        for (let f = 0; f < 9; f++) {
          const ph = (t * 1.25 + f / 9 + i * 0.13) % 1, fy = y - ph * 30, a = (1 - ph) * k, w = Math.max(1, Math.round(5 * (1 - ph) + 1));
          ctx.fillStyle = `rgba(${f % 3 === 0 ? '255,230,250' : f % 2 ? '255,110,220' : '190,80,255'},${a.toFixed(2)})`;
          ctx.fillRect(Math.round(x - w / 2 + Math.sin(t * 6 + f * 1.7 + i) * 2 * ph), Math.round(fy), w, 3);
        }
        ctx.restore();
      }
    }
    SC.push({
      id: '3d', t0: 62, t1: 68, map: 'opm3', water: [60, 290, 0.5, 0.4], grade: 'rgb(200,200,240)',
      cam: [[62, 110, 160, 2.4, 0.05], [63.5, 120, 60, 2.2, -0.04], [65, 230, 45, 2.0, 0.03], [66, 390, 45, 1.8, -0.03], [67, 470, 110, 1.6, 0.03], [68, 288, 170, 1.1, 0.0]],
      world(ctx, t, c, ph) { if (ph !== 'over') return; const u = t - 62; flames(ctx, t, PIL.map((_, i) => clamp((u - (0.3 + i * 0.42)) / 0.5, 0, 1))); },
      screen(ctx, t) { particlesScreen(ctx, t, { n: 40, rgb: '255,120,220', a: 0.8, r: 2, vy: -1.0, add: true, tw: true }); },
    });

    // ---- Chapitre IV : Mêlée ----
    const HER = { x: 232, y: 178 };
    SC.push({
      id: '4a', t0: 68, t1: 77, map: 'opm3', water: [60, 290, 0.5, 0.4], melee: false, grade: 'rgb(170,170,235)',
      cam: [[68, 288, 170, 1.1, 0.0], [72, 262, 190, 1.9, 0.03], [77, 260, 175, 2.6, 0.0]],
      actors: [
        { id: 'evoli', pid: '0133', keys: [[68, 232, 205], [72, 232, 190], [76, 232, 178]], an: [[68, 'Walk', 'auto'], [73.4, 'Pose', 0, { loop: false }], [75.6, 'Idle', 2]], reflect: true, aura: '130,235,255' },
        { id: 'riolu', pid: '0447', keys: [[68, 332, 150], [76, 332, 150]], an: [[68, 'Idle', 4], [72.2, 'Rotate', 4, { loop: false }], [73.6, 'Idle', 6]], reflect: true },
        { id: 'tiplouf', pid: '0393', keys: [[68, 360, 190], [76, 360, 190]], an: [[68, 'Idle', 4], [72.6, 'Rotate', 4, { loop: false }], [73.8, 'Idle', 6]], reflect: true },
        { id: 'sriolu', pid: 'shadow_0447', keys: [[72.0, 332, 150]], an: [[72.0, 'Idle', 6]], a: [[72.0, 0], [73.6, 1]], reflect: true, aura: '190,60,255' },
        { id: 'stiplouf', pid: 'shadow_0393', keys: [[72.3, 360, 190]], an: [[72.3, 'Idle', 6]], a: [[72.3, 0], [73.8, 1]], reflect: true, aura: '190,60,255' },
      ],
      world(ctx, t, c, ph) { if (ph !== 'over') return; flames(ctx, t, PIL.map(() => 1)); ring(ctx, 232, 184, 6 + ((t * 0.6) % 1) * 30, 0.8, '230,255,255', 0.6 * (1 - (t * 0.6) % 1), 0.4); },
      screen(ctx, t) { particlesScreen(ctx, t, { n: 70, rgb: '180,190,255', a: 0.5, r: 1.4, vy: 5, vx: -1, add: true }); particlesScreen(ctx, t, { n: 30, rgb: '255,120,220', a: 0.8, r: 2, vy: -1.0, add: true, tw: true }); if (t > 75.3) flash(ctx, 0.5 * (1 - (t - 75.3) / 0.7) * (t < 76 ? 1 : 0), '255,255,255'); },
    });
    // 4b..4e : mêlée complète — l'arène, hit-stop sur chaque impact, caméras « sakuga »
    const hero = (extra) => ({ id: 'evoli', pid: '0133', reflect: true, aura: '130,235,255', ...extra });
    SC.push({
      id: '4b', t0: 77, t1: 88, map: 'opm3', water: [60, 290, 0.5, 0.4], melee: true, grade: 'rgb(180,180,235)',
      cam: [[77, 262, 176, 2.3, 0.0], [79.5, 276, 172, 2.5, 0.08], [82, 290, 166, 2.2, -0.1], [85, 276, 172, 2.6, 0.05], [88, 258, 176, 2.1, 0.0]],
      follow: ['evoli', 'sriolu', 'stiplouf'],
      actors: [
        hero({ keys: [[77, 232, 178], [77.8, 262, 176], [79.2, 292, 168], [80.6, 262, 182], [82.4, 296, 166], [83.4, 270, 176], [85.4, 250, 182], [87.4, 240, 186], [88, 236, 186]],
          an: [[77, 'Double', 'auto', { loop: false }], [78.4, 'Attack', { to: [300, 170] }, { loop: false }], [79.9, 'Walk', 'auto'], [80.6, 'Swing', { toId: 'stiplouf' }, { loop: false }], [82.0, 'Attack', { to: [320, 168] }, { loop: false }], [83.4, 'Hurt', 6, { loop: false }], [84.6, 'Pain', 6, { loop: false }], [86.2, 'Idle', 6], [87.4, 'Hurt', 6, { loop: false }]] }),
        { id: 'sriolu', pid: 'shadow_0447', keys: [[77, 332, 150], [79.0, 304, 164], [80.4, 332, 150], [82.2, 306, 162], [83.2, 296, 170], [85.2, 300, 176], [88, 270, 182]], an: [[77, 'Idle', 6], [78.6, 'Attack', { toId: 'evoli' }, { loop: false }], [80.2, 'Walk', 'auto'], [81.4, 'Strike', { toId: 'evoli' }, { loop: false }], [83.2, 'Strike', { toId: 'evoli' }, { loop: false }], [85.0, 'Double', { toId: 'evoli' }, { loop: false }], [86.6, 'Attack', { toId: 'evoli' }, { loop: false }]], reflect: true, aura: '190,60,255' },
        { id: 'stiplouf', pid: 'shadow_0393', keys: [[77, 360, 190], [80.2, 332, 184], [81.4, 316, 182], [83.4, 318, 184], [86.4, 290, 190], [88, 276, 188]], an: [[77, 'Idle', 6], [80.0, 'Walk', 'auto'], [81.5, 'Swing', { toId: 'evoli' }, { loop: false }], [83.8, 'Attack', { toId: 'evoli' }, { loop: false }], [86.2, 'Shoot', { toId: 'evoli' }, { loop: false }]], reflect: true, aura: '190,60,255' },
      ],
      world(ctx, t, c, ph) { if (ph !== 'over') return; flames(ctx, t, PIL.map(() => 1)); for (const ti of IMPACTS) { const d = t - ti; if (d >= 0 && d < 0.4) { const ix = 280 + (rnd(ti, 1) - 0.5) * 40, iy = 168 + (rnd(ti, 2) - 0.5) * 18; starBurst(ctx, ix, iy, 50 * (0.4 + d * 3), 1 - d / 0.4, 10, ti); glow(ctx, ix, iy, 34, '255,240,180', 0.8 * (1 - d / 0.4)); ring(ctx, ix, iy + 8, d * 90, 1.2, '230,255,255', 0.8 * (1 - d / 0.4), 0.4); } } },
      screen(ctx, t) { particlesScreen(ctx, t, { n: 80, rgb: '200,210,255', a: 0.5, r: 1.4, vy: 5, vx: -1.4, add: true }); speedLines(ctx, t, 18, W / 2, H / 2, '255,244,210', 0.25, 260);
        for (const ti of IMPACTS) { const d = t - ti; if (d >= 0 && d < 0.1) impactFrame(ctx, 1 - d / 0.11); } },
    });
    SC.push({
      id: '4c', t0: 88, t1: 98, map: 'opm3', water: [60, 290, 0.5, 0.4], melee: true, grade: 'rgb(180,180,235)',
      cam: [[88, 258, 176, 2.1, 0.0], [90, 288, 172, 3.0, -0.05], [92.2, 288, 168, 2.2, 0.0], [95, 300, 168, 2.1, 0.08], [98, 300, 164, 1.9, -0.04]],
      follow: ['evoli', 'sriolu', 'stiplouf', 'lucario'],
      actors: [
        hero({ keys: [[88, 236, 186], [90, 236, 186], [91, 236, 186]], an: [[88, 'Hurt', 6], [88.9, 'Pain', 6, { loop: false }], [90.6, 'Idle', 6]] }),
        { id: 'sriolu', pid: 'shadow_0447', keys: [[88, 270, 182], [91.8, 256, 184], [94.2, 296, 168], [96, 322, 160]], an: [[88, 'Idle', 6], [90.2, 'Charge', { toId: 'evoli' }, { loop: false }], [91.2, 'Hurt', 2, { loop: false }], [94.0, 'Hurt', 2, { loop: false }], [95.6, 'Pain', 2, { loop: false }]], a: [[88, 1], [96.4, 1], [97.4, 0]], reflect: true, aura: '190,60,255' },
        { id: 'stiplouf', pid: 'shadow_0393', keys: [[88, 276, 188], [92, 262, 190], [95, 330, 196]], an: [[88, 'Idle', 6], [90.4, 'Shoot', { toId: 'evoli' }, { loop: false }], [92.2, 'Hurt', 2, { loop: false }], [94.4, 'Hurt', 2]], a: [[88, 1], [96.6, 1], [97.6, 0]], reflect: true, aura: '190,60,255' },
        { id: 'lucario', pid: '0448', keys: [[91.2, 288, 150, 0], [92.4, 266, 170, 0], [93.2, 262, 176, 0], [95.4, 292, 168, 0], [98, 270, 176]], an: [[91.2, 'LeapForth', 0, { loop: false }], [92.4, 'Hop', 6, { loop: false }], [93.4, 'Strike', { toId: 'sriolu' }, { loop: false }], [94.4, 'Swing', { toId: 'stiplouf' }, { loop: false }], [96.0, 'Pose', 6, { loop: false }]], a: [[91.2, 0], [91.5, 1]], reflect: true, aura: '90,230,255', vis: [91.1, 99] },
      ],
      world(ctx, t, c, ph) {
        if (ph === 'under') { const g = sstep((t - 90.2) / 1.0) * (1 - sstep((t - 96) / 2)); if (g > 0) { glow(ctx, 288, 152, 130, '120,230,255', 0.55 * g); ctx.save(); ctx.globalAlpha = 0.9 * g; ctx.drawImage(I.vitrail, 288 - 52, 152 - 47, 104, 94); ctx.restore(); } }
        if (ph !== 'over') return; flames(ctx, t, PIL.map(() => 1));
        const s = t - 91.1; if (s > 0 && s < 2) shardsW(ctx, 288, 150, s * 0.9, 34, 81, ['#4aa8ff', '#ffd45a', '#4be8a8', '#fff', '#6a7bff'], 110, 4);
        for (const ti of IMPACTS) { const d = t - ti; if (d >= 0 && d < 0.4) { const ix = 280 + (rnd(ti, 1) - 0.5) * 50, iy = 168 + (rnd(ti, 2) - 0.5) * 18; starBurst(ctx, ix, iy, 56 * (0.4 + d * 3), 1 - d / 0.4, 10, ti); glow(ctx, ix, iy, 36, '255,240,180', 0.8 * (1 - d / 0.4)); ring(ctx, ix, iy + 8, d * 90, 1.2, '230,255,255', 0.8 * (1 - d / 0.4), 0.4); } }
        if (t > 96.4 && t < 98) { for (let i = 0; i < 40; i++) { const ph2 = ((t - 96.4) * 0.9 + rnd(i, 3)) % 1; ctx.fillStyle = `rgba(190,60,255,${(0.9 * (1 - ph2)).toFixed(2)})`; ctx.fillRect(Math.round(250 + rnd(i, 1) * 100), Math.round(170 - ph2 * 50), 2, 2); } } },
      screen(ctx, t) { particlesScreen(ctx, t, { n: 70, rgb: '200,210,255', a: 0.5, r: 1.4, vy: 5, vx: -1.4, add: true }); for (const ti of IMPACTS) { const d = t - ti; if (d >= 0 && d < 0.1) impactFrame(ctx, 1 - d / 0.11); }
        flash(ctx, 0.9 * Math.exp(-Math.abs(t - 91.2) * 6), '200,245,255'); speedLines(ctx, t, 22, W / 2, H / 2, '160,240,255', 0.3, 260); },
    });
    SC.push({
      id: '4d', t0: 98, t1: 106, map: 'opm3', water: [60, 290, 0.5, 0.4], melee: true, grade: 'rgb(170,170,235)',
      cam: [[98, 300, 164, 2.0, -0.05], [101, 330, 160, 2.1, 0.05], [104, 310, 164, 1.6, 0.0], [106, 300, 160, 1.1, 0.0]],
      follow: ['evoli', 'lucario', 'darkrai'],
      actors: [
        hero({ id: 'evoli', keys: [[98, 270, 178], [101, 262, 176]], an: [[98, 'Idle', 2], [100.0, 'Attack', 2, { loop: false }], [102.0, 'Shoot', 2, { loop: false }]] }),
        { id: 'lucario', pid: '0448', keys: [[98, 280, 184], [101, 290, 172]], an: [[98, 'Idle', 2], [99.9, 'Strike', 2, { loop: false }], [101.8, 'QuickStrike', 2, { loop: false }]], reflect: true, aura: '90,230,255' },
        { id: 'darkrai', pid: '0491', keys: [[98, 400, 150, 20], [100.2, 346, 168, 6], [106, 340, 168, 6]], an: [[98, 'Charge', 6, { loop: true }], [100.4, 'Attack', { toId: 'lucario' }, { loop: false }], [102.4, 'Shoot', { toId: 'lucario' }, { loop: false }]], a: [[98, 0], [99, 1]], reflect: true, aura: '190,40,255', s: 1.15 },
      ],
      world(ctx, t, c, ph) { if (ph !== 'over') return; flames(ctx, t, PIL.map(() => 1));
        for (const ti of IMPACTS) { const d = t - ti; if (d >= 0 && d < 0.4) { const ix = 306, iy = 170; starBurst(ctx, ix, iy, 66 * (0.4 + d * 3), 1 - d / 0.4, 12, ti); glow(ctx, ix, iy, 40, '255,240,180', 0.9 * (1 - d / 0.4)); } }
        const k = sstep((t - 102.8) / 3); glow(ctx, 340, 150, lerp(30, 360, k), '190,60,255', 0.55 * k); ring(ctx, 340, 168, k * 280, 3, '200,100,255', 0.8 * (1 - k), 0.5); },
      screen(ctx, t) { particlesScreen(ctx, t, { n: 60, rgb: '255,120,220', a: 0.8, r: 2, vy: -2.0, add: true, tw: true }); for (const ti of IMPACTS) { const d = t - ti; if (d >= 0 && d < 0.1) impactFrame(ctx, 1 - d / 0.11); }
        flash(ctx, sstep((t - 105.0) / 1.0)); },
    });

    // ---- Chapitre V : chute céleste ----
    const SKY = (cx0, cy0, cx1, cy1) => [[106, cx0, cy0, 1.0, 0.5], [112, 288, 170, 1.3, -0.2], [118, 288, 165, 1.8, 0.1], [121, 288, 165, 2.4, 0.0]];
    SC.push({
      id: '5a', t0: 106, t1: 122, map: 'opm4', free: true, bg: '#04061a',
      cam: [[106, 288, 20, 1.3, 0.5], [110, 330, 130, 1.1, -0.35], [114, 250, 210, 1.2, 0.3], [118, 288, 170, 1.9, 0.0], [122, 288, 165, 2.6, 0.0]],
      actors: [
        { id: 'riolu', pid: '0447', keys: [[106, 250, 40], [110, 262, 120], [114, 268, 160], [118, 262, 170]], an: [[106, 'Float', 0, { speed: 1.4 }]], rot: [[106, 0.6], [110, -0.4], [114, 0.5], [118, 0.0]], noShadow: true, aura: '120,200,255', vis: [105, 122] },
        { id: 'evoli', pid: '0133', keys: [[106, 300, 30], [110, 292, 110], [114, 288, 158], [118, 288, 168]], an: [[106, 'Float', 0, { speed: 1.4 }]], rot: [[106, -0.5], [110, 0.5], [114, -0.3], [118, 0.0]], noShadow: true, aura: '120,230,255', vis: [105, 122] },
        { id: 'latias', pid: '0380', keys: [[108, 150, 70], [114, 200, 200]], an: [[108, 'Idle', 0]], noShadow: true, aura: '255,120,160', a: [[108, 0], [109, 0.85], [117, 0.85], [119, 0]], rot: [[108, 0.5], [114, -0.3]], vis: [107, 120], s: 0.9 },
        { id: 'latios', pid: '0381', keys: [[108, 430, 60], [114, 380, 190]], an: [[108, 'Idle', 0]], noShadow: true, aura: '120,160,255', a: [[108, 0], [109, 0.85], [117, 0.85], [119, 0]], rot: [[108, -0.5], [114, 0.3]], vis: [107, 120], s: 0.9 },
        { id: 'tiplouf', pid: '0393', keys: [[106, 336, 50], [110, 318, 126], [114, 310, 162], [118, 314, 172]], an: [[106, 'Float', 0, { speed: 1.4 }]], rot: [[106, 0.4], [110, -0.6], [114, 0.3], [118, 0.0]], noShadow: true, aura: '255,210,120', vis: [105, 122] },
      ],
      props: [{ img: 'wfCyan', keys: [[114, 262, 150, 0], [118, 282, 164, 0]], s: 0.8, a: [[114, 0], [115, 1]] }, { img: 'wfEmerald', rgb: '120,255,190', keys: [[114, 288, 140, 0], [118, 288, 160, 0]], s: 0.8, a: [[114, 0], [115, 1]] }, { img: 'wfAmber', rgb: '255,210,100', keys: [[114, 316, 150, 0], [118, 296, 164, 0]], s: 0.8, a: [[114, 0], [115, 1]] }],
      world(ctx, t, c, ph) { if (ph !== 'over') return; const k = sstep((t - 115) / 3); const kf = k * (1 - sstep((t - 117.6) / 0.8)); glow(ctx, 288, 164, 90, '255,235,170', 0.5 * kf); starBurst(ctx, 288, 164, 140, 0.4 * kf, 10, t * 0.4); sparklesWorld(ctx, t, 90, 91, 0, 0, 576, 320, '255,246,210', 1);
        const dk = sstep((t - 118) / 2.6); if (dk > 0) { const rr = dk * 380; ring(ctx, 288, 168, rr, 5, '190,90,255', 0.9 * (1 - sstep((t - 120.4) / 1.5)), 0.7); ctx.save(); ctx.fillStyle = `rgba(14,0,34,${(0.92 * sstep((t - 119.4) / 2.2)).toFixed(3)})`; ctx.beginPath(); ctx.arc(288, 168, rr, 0, TAU); ctx.fill(); ctx.restore(); } },
      shake: (t) => (t > 118 && t < 121 ? 4 * Math.exp(-(t - 118) * 1.0) : 0),
      screen(ctx, t) { speedLines(ctx, t, 60, W / 2, H / 2, '255,255,255', 0.5 * (1 - sstep((t - 117.5) / 2.5)), 250); particlesScreen(ctx, t, { n: 40, rgb: '255,250,230', a: 0.9, r: 3, vy: -9, add: false }); flash(ctx, 0.7 * Math.exp(-Math.abs(t - 118) * 7), '210,160,255'); ctx.fillStyle = `rgba(8,0,22,${(sstep((t - 120.5) / 1.2)).toFixed(3)})`; ctx.fillRect(0, 0, W, H); },
    });
    SC.push({
      id: '5b', t0: 122, t1: 132, map: 'opm4', free: true, bg: '#04010c', grade: 'rgb(120,100,200)',
      cam: [[122, 288, 160, 2.2, 0.0], [127, 288, 180, 1.7, 0.08], [132, 288, 230, 1.3, -0.06]],
      actors: [
        { id: 'evoli', pid: '0133', keys: [[122, 288, 168], [132, 288, 330]], an: [[122, 'Sink', 0, { speed: 0.5 }]], rot: [[122, -0.3], [132, 0.2]], noShadow: true, aura: '130,235,255', a: [[122, 1], [130, 1], [132, 0]] },
        { id: 'riolu', pid: '0447', keys: [[122, 262, 170], [124, 240, 168], [132, 240, -40]], an: [[122, 'Float', 0, { speed: 0.6 }]], noShadow: true, aura: '120,200,255', vis: [121, 133] },
        { id: 'tiplouf', pid: '0393', keys: [[122, 314, 172], [124, 336, 170], [132, 336, -40]], an: [[122, 'Float', 0, { speed: 0.6 }]], noShadow: true, aura: '255,210,120', vis: [121, 133] },
      ],
      world(ctx, t, c, ph) { if (ph !== 'over') return; const k = sstep((t - 123.5) / 1.6); const up = sstep((t - 126) / 5); const by = lerp(170, -40, up);
        barrierWorld(ctx, 240, by, 24, k, t); barrierWorld(ctx, 336, by, 24, k, t); if (t < 126) { ring(ctx, 240, 170, (t - 123.5) * 40, 1.6, '160,250,255', 0.8 * (1 - clamp((t - 123.5) / 2.5, 0, 1)), 1); ring(ctx, 336, 170, (t - 123.5) * 40, 1.6, '160,250,255', 0.8 * (1 - clamp((t - 123.5) / 2.5, 0, 1)), 1); }
        for (let i = 0; i < 16; i++) { const ph2 = ((t * 0.4 + rnd(i, 3)) % 1); const ey = lerp(160, 330, sstep((t - 122) / 10)); glow(ctx, 288 + (rnd(i, 4) - 0.5) * 50, ey - 14 - ph2 * 60, 4, '190,255,255', 0.7 * (1 - ph2)); } },
      screen(ctx, t) { particlesScreen(ctx, t, { n: 70, rgb: '170,120,255', a: 0.7, r: 2, vy: -2, add: true, tw: true }); },
    });

    // ---- Chapitre VI : le Rayon d'Espoir ----
    SC.push({
      id: '6a', t0: 132, t1: 137, map: 'opm2', free: true, bg: '#010208', grade: 'rgb(80,120,200)',
      cam: [[132, 288, 130, 1.6, 0.04], [137, 288, 160, 2.8, -0.02]],
      actors: [{ id: 'evoli', pid: '0133', keys: [[132, 288, 152]], an: [[132, 'Sink', 0, { loop: false }], [134.6, 'Wake', 0, { loop: false }]], s: 1.0, aura: '130,235,255' }],
      props: [{ img: 'wfCyan', keys: [[132, 306, 150, 0]], s: 0.9 }],
      world(ctx, t, c, ph) { if (ph !== 'over') return; bubblesWorld(ctx, t, 26, 61, 200, 380, 40, 230, 1.0); sparklesWorld(ctx, t, 50, 62, 200, 40, 380, 230, '255,244,190', 1); },
      screen(ctx, t) { const ra = sstep((t - 133.4) / 3.2); godRays(ctx, t, 0.9 * ra, W * 0.52, -30, 7, 0.5 + 0.7 * ra, H * 1.2, '255,246,210'); glow(ctx, W * 0.5, -20, 900, '255,246,210', 0.55 * ra); },
    });
    SC.push({
      id: '6b', t0: 137, t1: 142, map: 'opm1', free: true, bg: '#02030a',
      cam: [[137, 288, 160, 1.0, 0.0]], screen() { },
    });
    SC.push({
      id: '6c', t0: 142, t1: 146.5, map: 'opm2', free: true, bg: '#010208', grade: 'rgb(90,150,230)',
      cam: [[142, 288, 100, 1.0, 0.1], [144.5, 288, 105, 1.5, 0.0], [146.5, 288, 108, 2.8, -0.06]],
      follow: ['riolu', 'evoli'],
      actors: [
        { id: 'riolu', pid: '0447', keys: [[142, 280, 28], [145.6, 286, 98], [146.5, 286, 100]], an: [[142, 'LeapForth', 0, { loop: false }], [143.4, 'Charge', 0, { loop: true }]], rot: [[142, 0]], noShadow: true, aura: '120,200,255' },
        { id: 'evoli', pid: '0133', keys: [[142, 298, 180], [145.6, 290, 120], [146.5, 290, 120]], an: [[142, 'Pose', 0, { loop: true }]], noShadow: true, aura: '130,235,255' },
      ],
      world(ctx, t, c, ph) { if (ph !== 'over') return; const k = sstep((t - 145) / 1.5); glow(ctx, 288, 122, 160, '255,246,210', 0.25 + 0.6 * k); starBurst(ctx, 288, 122, 260, 0.6 * k, 12, t * 0.5); bubblesWorld(ctx, t, 34, 71, 180, 400, 0, 260, 1.4); sparklesWorld(ctx, t, 80, 72, 190, 0, 390, 260, '255,246,200', 1); },
      screen(ctx, t) { godRays(ctx, t, 0.7, W * 0.62, -30, 8, 0.8, H * 1.2, '255,240,190'); },
    });
    SC.push({
      id: '6d', t0: 146.5, t1: TITLE_T, map: 'opm5', free: true, water: [0, 320, 0.8, 0.3], grade: 'rgb(235,250,255)',
      cam: [[146.5, 150, 190, 2.8, 0.0], [148, 150, 170, 2.2, 0.0]],
      actors: [
        { id: 'riolu', pid: '0447', keys: [[146.5, 150, 222, -10], [147.0, 150, 190, 24], [148, 150, 196, 0]], an: [[146.5, 'Hop', 0, { loop: false }]], reflect: false },
        { id: 'evoli', pid: '0133', keys: [[146.5, 170, 226, -10], [147.1, 170, 194, 20], [148, 170, 200, 0]], an: [[146.5, 'Hop', 0, { loop: false }]] },
      ],
      world(ctx, t, c, ph) { if (ph !== 'over') return; const u = t - 146.5; for (let r = 0; r < 3; r++) ring(ctx, 160, 206, clamp(u * 40 - r * 10, 0, 90), 1.2, '255,255,255', 0.8 * (1 - clamp((u * 40 - r * 10) / 90, 0, 1)), 0.4); sparklesWorld(ctx, t, 80, 81, 100, 150, 230, 240, '255,255,255', 1); },
      screen(ctx, t) { flash(ctx, sstep((t - 147.2) / 0.8)); },
    });

    // ---------- Œil (plan 6b) : reflet de Riolu plongeant dans la pupille d'Évoli ----------
    function miniScene(t) {
      miniX.save(); miniX.imageSmoothingEnabled = false; miniX.clearRect(0, 0, 256, 144);
      miniX.fillStyle = '#0a2a5a'; miniX.fillRect(0, 0, 256, 144);
      miniX.translate(128, 72); miniX.scale(1.4, 1.4); miniX.translate(-288, -150);
      drawMap(miniX, 'opm2', t, null);
      glow(miniX, 288, 100, 120, '255,246,210', 0.6);
      const u = clamp((t - 137) / 5, 0, 1);
      drawSprite(miniX, '0447', 'Charge', 0, (t - 137) * 60, true, 284, lerp(40, 118, sstep(u)), { noShadow: true, aura: '120,200,255' });
      drawSprite(miniX, '0133', 'Pose', 0, (t - 137) * 60, false, 292, 176, { noShadow: true });
      miniX.restore();
    }
    function drawEye(ctx, t) {
      const u = t - 137;
      ctx.fillStyle = '#02040c'; ctx.fillRect(0, 0, W, H);
      const cx = W / 2, cy = H / 2, open = sstep(u / 2.2), ry = lerp(6, 250, open), rx = 560;
      const zoom = kfz(u, 3.0, 5.0, 1.0, 5.0);
      ctx.save(); ctx.translate(cx, cy); ctx.scale(zoom, zoom); ctx.translate(-cx, -cy);
      ctx.save(); ctx.beginPath(); ctx.ellipse(cx, cy, rx, ry, 0, 0, TAU); ctx.clip();
      const sg = ctx.createRadialGradient(cx, cy, 80, cx, cy, rx); sg.addColorStop(0, '#fff4ee'); sg.addColorStop(0.6, '#f6dcd2'); sg.addColorStop(1, '#b88a86'); ctx.fillStyle = sg; ctx.fillRect(0, 0, W, H);
      const R = 245; const ig = ctx.createRadialGradient(cx, cy, 10, cx, cy, R); ig.addColorStop(0, '#1a0c08'); ig.addColorStop(0.55, '#5a2a14'); ig.addColorStop(0.9, '#8a4a22'); ig.addColorStop(1, '#2a1208');
      ctx.fillStyle = ig; ctx.beginPath(); ctx.arc(cx, cy, R, 0, TAU); ctx.fill();
      miniScene(t);
      ctx.save(); ctx.beginPath(); ctx.arc(cx, cy, R - 6, 0, TAU); ctx.clip(); ctx.imageSmoothingEnabled = false; const ph = (R - 6) * 2, pw = ph * 256 / 144; ctx.globalAlpha = 0.96; ctx.drawImage(mini, cx - pw / 2, cy - ph / 2, pw, ph); ctx.restore();
      ctx.fillStyle = 'rgba(255,255,255,0.9)'; ctx.beginPath(); ctx.ellipse(cx - 92, cy - 108, 30, 20, -0.5, 0, TAU); ctx.fill(); ctx.beginPath(); ctx.arc(cx + 80, cy + 120, 10, 0, TAU); ctx.fill();
      ctx.restore();
      ctx.strokeStyle = '#2a1008'; ctx.lineWidth = 12; ctx.beginPath(); ctx.ellipse(cx, cy, rx, ry, 0, Math.PI * 1.04, Math.PI * 1.96); ctx.stroke(); ctx.lineWidth = 6; ctx.beginPath(); ctx.ellipse(cx, cy, rx, ry, 0, 0.06, Math.PI - 0.06); ctx.stroke();
      ctx.restore();
      glow(ctx, cx, cy, 600, '255,246,210', 0.25 * open);
    }
    function kfz(u, a, b, v0, v1) { return lerp(v0, 2.8, sstep((u - a) / (b - a))); }
    SC[SC.findIndex((s) => s.id === '6b')].custom = drawEye;

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
        const deg = wingAngle(dt, nowSec, flapStart), rad = deg * Math.PI / 180; out = deg;
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
      if (tl > 1.25) { const bl = 0.45 + 0.55 * (0.5 + 0.5 * Math.sin(nowSec * 5)); ctx.save(); ctx.imageSmoothingEnabled = false; ctx.globalAlpha = bl; ctx.drawImage(I.enterUI, (W - 74 * 4) / 2, 590, 74 * 4, 11 * 4); ctx.restore(); }
      return out;
    }

    // ---------- Compositeur ----------
    const XF = { '1b': 0.5, '1c': 0.4, '1d': 0.5, '1e': 0.5, '2a': 1.0, '2b': 0.6, '3a': 0.8, '3b': 0.6, '3c': 0.6, '3d': 0.9, '4a': 0.3, '4b': 0, '4c': 0, '4d': 0, '5a': 0, '5b': 0.8, '6a': 1.0, '6b': 0.8, '6c': 0.8, '6d': 0.3 };
    function drawShot(ctx, sc, t) { if (sc.custom) { sc.custom(ctx, t); return null; } return renderScene(ctx, sc, t); }
    function caption(ctx, t) {
      let ch = null; for (const c of CHAPTERS) if (t >= c.t) ch = c; if (!ch) return;
      const d = t - ch.t; let a = sstep(d / 0.8) * (1 - sstep((d - 3.6) / 0.8)); if (ch.t === 0) a *= sstep((d - 1.2) / 0.6); if (a <= 0.01) return;
      ctx.save(); ctx.globalAlpha = a; ctx.font = '600 24px "Trebuchet MS", system-ui, sans-serif'; ctx.shadowColor = 'rgba(0,0,0,0.85)'; ctx.shadowBlur = 8;
      ctx.fillStyle = '#fde68a'; ctx.fillText(ch.name, 44, H - 74); ctx.fillStyle = 'rgba(253,230,138,0.85)'; ctx.fillRect(44, H - 64, 90 * a, 2); ctx.restore();
    }
    function introCard(ctx, t) {
      if (t < 1.5 || t > 7.2) return; const a = sstep((t - 1.5) / 1.2) * (1 - sstep((t - 5.6) / 1.4));
      ctx.save(); ctx.globalAlpha = a; ctx.textAlign = 'center'; ctx.shadowColor = 'rgba(0,30,60,0.9)'; ctx.shadowBlur = 14;
      ctx.font = '700 40px "Trebuchet MS", system-ui, sans-serif'; ctx.fillStyle = '#fff6d0'; ctx.fillText('Pokémon Mystery Dungeon', W / 2, 150);
      ctx.font = '700 58px "Trebuchet MS", system-ui, sans-serif'; ctx.fillStyle = '#fbbf24'; ctx.fillText('DESTINY', W / 2, 214); ctx.restore();
    }
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
        vignette(ctx, 0.5); bars(ctx, t); introCard(ctx, t); caption(ctx, t); flash(ctx, 1 - sstep(t / 1.4), '0,0,0');
      }
      ctx.restore(); return { wing, shot: t >= TITLE_T ? 'title' : (SC.find((s) => t >= s.t0 && t < s.t1) || SC[SC.length - 1]).id };
    }
    function renderTitleMode(ctx, tl, theme, nowSec, flapStart) { ctx.save(); ctx.fillStyle = '#000'; ctx.fillRect(0, 0, W, H); const wing = drawTitle(ctx, tl, theme, nowSec, flapStart); vignette(ctx, 0.3); ctx.restore(); return { wing }; }
    return { render, renderTitleMode, W, H, D, CHAPTERS, TITLE_T, IMPACTS, SC };
  }
  root.PMDDestinySprite = { create, W, H, D, CHAPTERS, TITLE_T, IMPACTS, BEAT };
})(typeof window !== 'undefined' ? window : globalThis);
