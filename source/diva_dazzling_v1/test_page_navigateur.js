/* Test « vrai navigateur » de l'aperçu des animations de diva.

   La page est rejouée dans jsdom : le script réel s'exécute, le contexte 2D est
   instrumenté et chaque data-URI est réellement décodé (signature PNG + IHDR).
   C'est ce qui attrape l'aperçu vide : une image non décodée passée à drawImage
   ne dessine rien, et une planche mal découpée se voit dans les coordonnées.

   Usage : NODE_PATH=/tmp/nc/node_modules node source/diva_dazzling_v1/test_page_navigateur.js [page.html]
   Sortie : JSON de diagnostic ; code retour 0 = OK, 1 = régression, 2 = harnais KO.
*/
'use strict';
const fs = require('fs');
const path = require('path');
const { JSDOM, VirtualConsole } = require('jsdom');

const PAGE = process.argv[2] || path.join(__dirname, '..', '..', 'apercu_diva_dazzling_v1.html');
const DIRGLYPHS = ['↓', '↘', '→', '↗', '↑', '↖', '←', '↙'];

const draws = [];
const imgCache = {};
const srcErrors = [];

function makeCtx(canvas, track) {
  const noop = () => { };
  const target = {
    canvas,
    imageSmoothingEnabled: false,
    measureText: () => ({ width: 42 }),
    createLinearGradient: () => ({ addColorStop: noop }),
    createRadialGradient: () => ({ addColorStop: noop }),
    drawImage(im, sx, sy, sw, sh, dx, dy, dw, dh) {
      track.draws++;
      if (!im || typeof im === 'string' || !(im.width > 0)) {
        track.bad.push(typeof im === 'string' ? 'STRING' : 'NODIM');
        return;
      }
      draws.push({ w: im.width, h: im.height, sx, sy, sw, sh, dx, dy, dw, dh,
                   canvasW: canvas.width, canvasH: canvas.height });
    },
    clearRect: noop, fillRect: noop, strokeRect: noop, beginPath: noop, closePath: noop,
    moveTo: noop, lineTo: noop, arc: noop, fill: noop, stroke: noop, save: noop,
    restore: noop, translate: noop, scale: noop, rotate: noop, setTransform: noop,
    fillText: noop, putImageData: noop,
    getImageData: (x, y, w, h) => ({ data: new Uint8ClampedArray(Math.max(4, w * h * 4)), width: w, height: h }),
  };
  return new Proxy(target, {
    get(o, k) { return k in o ? o[k] : noop; },
    set(o, k, v) { o[k] = v; return true; },
  });
}

const errors = [];
const vc = new VirtualConsole();
vc.on('jsdomError', e => errors.push(String((e && e.message) || e)));
vc.on('error', e => errors.push('console.error: ' + e));

const html = fs.readFileSync(PAGE, 'utf8');
const dom = new JSDOM(html, {
  runScripts: 'dangerously',
  pretendToBeVisual: true,
  virtualConsole: vc,
  beforeParse(win) {
    win.HTMLCanvasElement.prototype.getContext = function () {
      if (!this.__ctx) this.__ctx = makeCtx(this, (this.__track = { draws: 0, bad: [] }));
      return this.__ctx;
    };
    win.requestAnimationFrame = cb => setTimeout(() => cb(Date.now()), 0);
    class FakeImage {
      constructor() { this.width = 0; this.height = 0; this.onload = null; this._src = ''; }
      set src(v) {
        this._src = v;
        const m = /^data:image\/png;base64,(.*)$/s.exec(v || '');
        if (!m) { srcErrors.push('SRC_INVALIDE'); return; }
        const buf = Buffer.from(m[1], 'base64');
        if (buf.slice(0, 8).toString('hex') !== '89504e470d0a1a0a') { srcErrors.push('PAS_PNG'); return; }
        this.width = buf.readUInt32BE(16);
        this.height = buf.readUInt32BE(20);
        imgCache[this._src] = { w: this.width, h: this.height, bytes: buf.length };
        setTimeout(() => this.onload && this.onload(), 0);
      }
      get src() { return this._src; }
    }
    win.Image = FakeImage;
  },
});

const results = { page: path.basename(PAGE), ok: true, problems: [] };
function fail(msg) { results.ok = false; results.problems.push(msg); }
function finish(extra) {
  Object.assign(results, extra || {});
  if (srcErrors.length) fail('images : ' + [...new Set(srcErrors)].join(','));
  if (errors.length) fail('erreurs JS : ' + errors.slice(0, 3).join(' | '));
  console.log(JSON.stringify(results, null, 2));
  process.exit(results.harness ? 2 : (results.ok ? 0 : 1));
}

function checks() {
  const doc = dom.window.document;
  const data = dom.window.eval('JSON.parse(JSON.stringify(DATA))');
  const cards = doc.querySelectorAll('.card');
  if (cards.length !== 3) fail(`cartes attendues 3, trouvées ${cards.length}`);
  const slots = ['0428', '0763', '0303'];
  slots.forEach(slot => {
    const d = data[slot];
    if (!d) { fail(`données manquantes pour ${slot}`); return; }
    const im = imgCache[d.sheet];
    if (!im) { fail(`${slot} : planche non décodée`); return; }
    const wantW = d.fw * d.frames, wantH = d.fh * d.dirs;
    if (im.w !== wantW || im.h !== wantH) fail(`${slot} : planche ${im.w}x${im.h} au lieu de ${wantW}x${wantH}`);
    if (d.frames !== 18 || d.dirs !== 8) fail(`${slot} : ${d.frames} phases / ${d.dirs} directions`);
    if (!d.desc || d.desc.length < 60) fail(`${slot} : description du geste absente`);
  });
  if (draws.filter(x => !(x.sw > 0) || !(x.sh > 0)).length) fail('drawImage avec source vide');
  if (draws.filter(x => (x.sx || 0) >= x.w || (x.sy || 0) >= x.h).length) fail('drawImage hors planche');
  const canvasBad = [...doc.querySelectorAll('canvas')].filter(c => !c.__track || c.__track.bad.length);
  if (canvasBad.length) fail(`canvas avec image invalide : ${canvasBad.length}`);
  const vign = doc.querySelectorAll('.strip canvas').length;
  if (vign !== 54) fail(`vignettes attendues 54, trouvées ${vign}`);
  const first = doc.querySelector('.card');
  const dirs = first.querySelectorAll('button.dir');
  if (dirs.length !== 8) fail(`boutons de direction : ${dirs.length}/8`);
  if (dirs[2]) {
    dirs[2].click();
    if (!dirs[2].classList.contains('on')) fail('le clic direction ne sélectionne pas Est');
    if (!new RegExp(DIRGLYPHS[2]).test(dirs[2].textContent)) fail('glyphe de direction inattendu');
  }
  return first;
}

setTimeout(() => {
  let first;
  try {
    first = checks();
  } catch (e) {
    results.harness = true;
    finish({ problems: [...results.problems, 'harnais : ' + (e && e.message)] });
    return;
  }
  const btns = [...first.querySelectorAll('button')];
  const peak = btns.find(b => /Pose de diva/.test(b.textContent));
  if (!peak) { finish({ draws: draws.length }); return; }
  const before = draws.length;
  peak.click();
  setTimeout(() => {
    if (draws.length <= before) fail('aucun redessin après le clic « Pose de diva »');
    const tag = first.querySelector('.tag').textContent;
    if (!/phase 11\//.test(tag)) fail("la pose de diva n'affiche pas la phase 11 (" + tag + ')');
    finish({ draws: draws.length,
             planches: Object.keys(imgCache).map(k => `${imgCache[k].w}x${imgCache[k].h}`) });
  }, 250);
}, 150);
