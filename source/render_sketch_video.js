// Rend un traitement de l'opening ULTIME en vidéo : [ENGINE=source/opening_spyrook_engine.js GLOBAL=PMDDestinySpyrook] node render_sketch_video.js <page.html> <début s> <fin s> <fps> <sortie.mp4> <ffmpeg>
// (par défaut : le traitement STUDIO SKETCH embarqué dans la page)
// Chaque image est dessinée (mode exact) puis envoyée en brut (RGBA) à ffmpeg → H.264 yuv420p. Aucun son (la musique est celle de 2aafI3XvKxo).
const fs = require('fs'), { spawn } = require('child_process');
const { createCanvas, loadImage } = require(process.env.NAPI || '/tmp/nc/node_modules/@napi-rs/canvas');
(async () => {
  const [html, a, b, fps, outp, ff] = [process.argv[2], +process.argv[3], +process.argv[4], +process.argv[5], process.argv[6], process.argv[7]];
  const h = fs.readFileSync(html, 'utf8'), i0 = h.indexOf('const ASSETS = ') + 15, i1 = h.indexOf(';\n</script>', i0), A = JSON.parse(h.slice(i0, i1));
  const IM = {}, SH = {}; for (const k in A.imgs) IM[k] = await loadImage(A.imgs[k]); for (const k in A.sheets) SH[k] = await loadImage(A.sheets[k]);
  const s0 = h.indexOf('<script>\n') + 9, s1 = h.indexOf('\n</script>', s0); (0, eval)(h.slice(s0, s1));
  if (process.env.ENGINE) (0, eval)(fs.readFileSync(process.env.ENGINE, 'utf8'));
  const HIRES = {}; if (process.env.HIRES) for (const k in IM) { const f = process.env.HIRES + '/' + k + '.png'; if (fs.existsSync(f)) HIRES[k] = await loadImage(f); }
  const cin = globalThis[process.env.GLOBAL || 'PMDDestinySketch'].create({ imgs: IM, sheets: SH, catalog: A.catalog, hires: HIRES, mk: (w, hh) => createCanvas(w, hh) });
  const VW = cin.W || 1280, VH = cin.H || 720, c = createCanvas(VW, VH), x = c.getContext('2d');
  const enc = spawn(ff, ['-y', '-loglevel', 'error', '-f', 'rawvideo', '-pix_fmt', 'rgba', '-s', VW + 'x' + VH, '-r', String(fps), '-i', '-',
    '-c:v', 'libx264', '-preset', process.env.PRESET || 'medium', '-crf', process.env.CRF || '24', '-maxrate', process.env.MAXRATE || '2200k', '-bufsize', process.env.BUFSIZE || '5000k', '-pix_fmt', 'yuv420p', '-movflags', '+faststart', outp], { stdio: ['pipe', 'inherit', 'inherit'] });
  const n = Math.round((b - a) * fps); const t0 = Date.now();
  for (let i = 0; i < n; i++) {
    const t = a + i / fps; cin.render(x, t, { theme: 'jour', nowSec: t, exact: true });
    const buf = Buffer.from(c.data ? c.data() : x.getImageData(0, 0, VW, VH).data.buffer);
    if (!enc.stdin.write(buf)) await new Promise((r) => enc.stdin.once('drain', r));
    if (i % 300 === 0) console.log(outp, i + '/' + n, ((Date.now() - t0) / 1000).toFixed(0) + 's');
  }
  enc.stdin.end(); await new Promise((r) => enc.on('close', r)); console.log('fini', outp, ((Date.now() - t0) / 1000).toFixed(0) + 's');
})().catch((e) => { console.error(e); process.exit(1); });
