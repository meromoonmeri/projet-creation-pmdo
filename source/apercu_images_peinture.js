// Planche-contact de contrôle : node source/apercu_images_peinture.js <page.html> <moteur.js|-> <GLOBAL> <sortie.png> <t1,t2,..> [colonnes] [échelle] [LARGEUR]
// ou, pour lister les plans : ... <sortie> shots
const fs = require('fs');
const { createCanvas, loadImage } = require(process.env.NAPI || '/tmp/nc/node_modules/@napi-rs/canvas');
(async () => {
  const [html, eng, glob, outp, tl, cols0, sc0, wid] = process.argv.slice(2);
  const h = fs.readFileSync(html, 'utf8'), i0 = h.indexOf('const ASSETS = ') + 15, i1 = h.indexOf(';\n</script>', i0), A = JSON.parse(h.slice(i0, i1));
  const IM = {}, SH = {}; for (const k in A.imgs) IM[k] = await loadImage(A.imgs[k]); for (const k in A.sheets) SH[k] = await loadImage(A.sheets[k]);
  const s0 = h.indexOf('<script>\n') + 9, s1 = h.indexOf('\n</script>', s0); (0, eval)(h.slice(s0, s1));
  if (eng !== '-') (0, eval)(fs.readFileSync(eng, 'utf8'));
  const HIRES = {}; if (process.env.HIRES) for (const k in IM) { const f = process.env.HIRES + '/' + k + '.png'; if (fs.existsSync(f)) HIRES[k] = await loadImage(f); }
  const cin = globalThis[glob].create({ imgs: IM, sheets: SH, catalog: A.catalog, hires: HIRES, mk: (w, hh) => createCanvas(w, hh) });
  if (tl === 'shots') { console.log(JSON.stringify(cin.SHOTS || cin.SC.map((q) => [q.id, q.t0, q.t1]))); return; }
  const times = tl.split(',').map(Number), cols = +cols0 || 3, sc = +sc0 || 0.5, W = cin.W, H = cin.H, w = Math.round(W * sc), hh = Math.round(H * sc), rows = Math.ceil(times.length / cols);
  const out = createCanvas(w * cols, hh * rows), o = out.getContext('2d'); o.fillStyle = '#222'; o.fillRect(0, 0, out.width, out.height);
  const c = createCanvas(W, H), x = c.getContext('2d');
  times.forEach((t, i) => { const a = Date.now(); cin.render(x, t, { theme: 'jour', nowSec: t, exact: true }); const ms = Date.now() - a; o.drawImage(c, (i % cols) * w, Math.floor(i / cols) * hh, w, hh); o.fillStyle = '#ff0'; o.font = '16px sans-serif'; o.fillText(t + 's ' + ms + 'ms', (i % cols) * w + 6, Math.floor(i / cols) * hh + 18); });
  fs.writeFileSync(outp, out.toBuffer('image/png'));
})().catch((e) => { console.error(e); process.exit(1); });
