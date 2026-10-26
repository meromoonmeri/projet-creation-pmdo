/* Test « vrai navigateur » de la page de la cinématique.

   La page est rejouée dans jsdom : les <script> sont exécutés dans l'ordre réel, le
   contexte 2D est instrumenté et les data-URIs sont réellement décodées (signature PNG +
   dimensions IHDR). C'est ce qui attrape l'ÉCRAN NOIR : si BOOT passe des chaînes
   data-URI à drawImage au lieu d'objets Image décodés, le canvas ne dessine rien.

   Usage : NODE_PATH=/tmp/nc/node_modules node source/cine_pichu_dazzling/test_page_navigateur.js [page.html]
   Sortie : JSON de diagnostic ; code retour 0 = OK, 1 = régression, 2 = harness KO.     */
'use strict';
const fs = require('fs');
const path = require('path');
const { JSDOM, VirtualConsole } = require('jsdom');

const PAGE = process.argv[2] || path.join(__dirname, '..', '..', 'apercu_cine_pichu_team_dazzling.html');

/* ---- contexte 2D instrumenté ---- */
function makeTrack() {
  return { drawImage: 0, drawImageBad: [], fillText: [], gradientStops: 0, ops: 0, lastFillStyle: null, fillRectGrad: 0, instrumented: true };
}
function makeCtx(track) {
  const grad = { addColorStop: () => { track.gradientStops++; } };
  const noop = () => { track.ops++; };
  const target = {
    canvas: { width: 1280, height: 720 },
    measureText: () => ({ width: 42 }),
    createLinearGradient: () => grad,
    createRadialGradient: () => grad,
    createPattern: () => null,
    getImageData: (x, y, w, h) => ({ data: new Uint8ClampedArray(Math.max(4, w * h * 4)), width: w, height: h }),
    putImageData: noop,
    drawImage: (im) => {
      track.drawImage++;
      if (typeof im === 'string' || im == null || !(im.width > 0)) {
        if (track.drawImageBad.length < 6) {
          track.drawImageBad.push(typeof im === 'string' ? 'STRING(data-URI)' : 'INCOMPLETE(' + (im && im.width) + ')');
        }
      }
    },
    fillText: (s) => { track.fillText.push(String(s).slice(0, 60)); },
    strokeText: noop,
    fillRect: () => { track.ops++; if (track.lastFillStyle === 'GRAD') track.fillRectGrad++; },
  };
  return new Proxy(target, {
    get(o, k) {
      if (k in o) return o[k];
      if (k === 'fillStyle' || k === 'strokeStyle') return track.lastFillStyle;
      return noop;
    },
    set(o, k, v) {
      if (k === 'fillStyle' || k === 'strokeStyle') track.lastFillStyle = (v && typeof v === 'object' && v.addColorStop) ? 'GRAD' : String(v);
      else o[k] = v;
      return true;
    },
  });
}

/* ---- polyfills injectés AVANT les scripts de la page ---- */
const TRACK = { n: 0 };
function polyfillSrc(track) {
  return `
  (function () {
    var W = window;
    W.__ctxTrack = ${JSON.stringify({}) };
    W.HTMLCanvasElement.prototype.getContext = function () { return W.__mkCtx(); };
    var PNGSIG = [137, 80, 78, 71, 13, 10, 26, 10];
    function Img() { this.complete = false; this.naturalWidth = 0; this.naturalHeight = 0; this.width = 0; this.height = 0; this._src = ''; }
    Object.defineProperty(Img.prototype, 'src', {
      get: function () { return this._src; },
      set: function (v) {
        this._src = v; var self = this;
        setTimeout(function () {
          W.__assetsSeen = (W.__assetsSeen || 0) + 1;
          var ok = false, w = 0, h = 0;
          var m = /^data:image\\/png;base64,([A-Za-z0-9+/=]+)$/.exec(String(v));
          if (m) {
            var b = Buffer.from(m[1], 'base64');
            W.__assetsBytes = (W.__assetsBytes || 0) + b.length;
            ok = b.length > 24;
            for (var i = 0; ok && i < 8; i++) if (b[i] !== PNGSIG[i]) ok = false;
            if (ok) { w = b.readUInt32BE(16); h = b.readUInt32BE(20); ok = w > 0 && h > 0; }
            if (ok) { W.__pngOk = (W.__pngOk || 0) + 1; } else { W.__pngKo = (W.__pngKo || 0) + 1; }
          }
          if (ok) { self.complete = true; self.naturalWidth = w; self.naturalHeight = h; self.width = w; self.height = h; }
          if (ok && self.onload) self.onload(); else if (!ok && self.onerror) self.onerror();
        }, 0);
      }
    });
    W.Image = Img;
    W.__decodeFail = 0;
  })();`;
}

(async () => {
  const html = fs.readFileSync(PAGE, 'utf8');
  const errs = [];
  const vc = new VirtualConsole();
  vc.on('jsdomError', (e) => errs.push('jsdomError: ' + (e && e.message)));
  vc.on('error', (...a) => errs.push('console.error: ' + a.map(String).join(' ').slice(0, 200)));

  const track = makeTrack();
  // injection du harness juste après <body> : il s'exécute avant le moteur et le BOOT
  const patched = html.replace('<body>', '<body>\n<script>\n' + polyfillSrc(track) + '\n</script>\n');
  if (patched === html) throw new Error('balise <body> introuvable');

  const dom = new JSDOM(patched, {
    runScripts: 'dangerously', pretendToBeVisual: true, virtualConsole: vc,
    url: 'http://localhost:8000/' + path.basename(PAGE),
    beforeParse(win) { win.__mkCtx = () => makeCtx(track); win.Buffer = Buffer; },
  });
  const win = dom.window, doc = win.document;
  await new Promise((r) => setTimeout(r, 15000));   // chargement des data-URIs + boucle rAF

  const seek = doc.getElementById('seek');
  const ovl = doc.getElementById('ovl');
  const eng = win.PMDDestinyDazzling;
  const iA = html.indexOf('const ASSETS = ') + 15;
  const A = JSON.parse(html.slice(iA, html.indexOf(';\n</script>', iA)));
  const nAssets = Object.keys(A.imgs).length + Object.keys(A.sheets).length;

  // moteur seul : rendu de secours (aucune image décodée) ne doit JAMAIS être noir
  let fallbackNeverBlack = null, endOfTimelineRendered = null, shots = null;
  if (eng) {
    const c0 = eng.create({ imgs: {}, sheets: {}, catalog: A.catalog, mk: () => null });
    const t0 = makeTrack();
    const r0 = c0.render(makeCtx(t0), 5, { game: true });
    fallbackNeverBlack = !!r0.bg && t0.gradientStops > 0 && t0.drawImage === 0;
    const t1 = makeTrack();
    const r1 = c0.render(makeCtx(t1), eng.D - 0.5, { game: true });
    endOfTimelineRendered = !!r1 && !!r1.bg;
    shots = (r0.shot || '') + '/' + (r1.shot || '');
  }

  // ---- bascule NUIT cliquée comme un utilisateur : le rendu doit continuer à dessiner ----
  const drawsBefore = track.drawImage;
  const thBtn = doc.getElementById('theme');
  let themeSwitchDraws = 0, themeLabel = '';
  if (thBtn) {
    thBtn.click();
    await new Promise((r) => setTimeout(r, 900));
    themeSwitchDraws = track.drawImage - drawsBefore;
    themeLabel = doc.getElementById('time') ? doc.getElementById('time').textContent : '';
  }

  const res = {
    page: path.basename(PAGE),
    themeSwitchDraws, themeLabel,
    enginePresent: !!eng,
    assetsInPage: nAssets,
    imagesRequestedByBoot: win.__assetsSeen || 0,
    pngDecodedOk: win.__pngOk || 0,
    pngDecodedKo: win.__pngKo || 0,
    decodedBytes: Math.round((win.__assetsBytes || 0) / 1024) + ' Ko',
    drawImageCalls: track.drawImage,
    drawImageBad: track.drawImageBad,
    fillTextSamples: Array.from(new Set(track.fillText)).slice(0, 5),
    gradientPainted: track.gradientStops > 0,
    fallbackNeverBlack, endOfTimelineRendered, shots,
    overlayHidden: ovl ? (ovl.style.display === 'none' || ovl.style.opacity === '0') : null,
    overlayText: doc.getElementById('loadTxt') ? doc.getElementById('loadTxt').textContent : null,
    seekAdvanced: seek ? Number(seek.value) : null,
    timeLabel: doc.getElementById('time') ? doc.getElementById('time').textContent : null,
    plans: doc.getElementById('plans') ? doc.getElementById('plans').children.length : 0,
    errors: errs.slice(0, 8),
  };
  res.OK = res.enginePresent
    && res.imagesRequestedByBoot >= nAssets && res.pngDecodedKo === 0 && res.pngDecodedOk >= nAssets
    && res.drawImageCalls > 50 && res.drawImageBad.length === 0
    && res.gradientPainted && res.fallbackNeverBlack === true && res.endOfTimelineRendered === true
    && res.overlayHidden === true && res.seekAdvanced > 0 && res.plans >= 10 && res.errors.length === 0
    && res.themeSwitchDraws > 10 && /nuit/.test(res.themeLabel);
  console.log(JSON.stringify(res, null, 1));
  dom.window.close();
  process.exit(res.OK ? 0 : 1);
})().catch((e) => { console.error('HARNESS KO', e); process.exit(2); });
