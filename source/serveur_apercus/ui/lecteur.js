/* Lecteur d'un pack ZIP : animations natives + reconstitution fidèle des calques/frames. */
(() => {
  'use strict';
  const $ = s => document.querySelector(s);
  const enc = p => String(p).split('/').map(encodeURIComponent).join('/');
  const esc = s => String(s ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
  const fmt = n => n >= 1e6 ? (n / 1e6).toFixed(1) + ' Mo' : n >= 1e3 ? Math.round(n / 1e3) + ' Ko' : n + ' o';

  const params = new URLSearchParams(location.search);
  const m = location.pathname.match(/\/pack\/([a-z0-9]+)/);
  const ID = params.get('id') || (m && m[1]);
  if (!ID) { document.body.innerHTML = '<p style="padding:40px">Pack introuvable. <a href="/">Retour à la galerie</a></p>'; return; }

  let P = null, APERCU = null;
  const url = f => `/pack/${ID}/f/${enc(f)}`;
  const canvas = $('#c'), ctx = canvas.getContext('2d');

  // état du studio
  let scene = null, couches = [], images = new Map(), dernier = [];
  let temps = 0, lecture = true, vitesse = 1, cadence = 100, zoom = 1, grille = false;
  let dernierPrechargement = 0;

  function charger(u) {
    if (!images.has(u)) { const im = new Image(); im.src = u; images.set(u, im); }
    return images.get(u);
  }

  function dessinerGrille(W, H) {
    ctx.save();
    ctx.strokeStyle = 'rgba(255,255,255,.17)'; ctx.lineWidth = 1;
    ctx.beginPath();
    for (let x = 0; x <= W; x += 8) { ctx.moveTo(x + .5, 0); ctx.lineTo(x + .5, H); }
    for (let y = 0; y <= H; y += 8) { ctx.moveTo(0, y + .5); ctx.lineTo(W, y + .5); }
    ctx.stroke(); ctx.restore();
  }

  function dessiner() {
    if (!scene) return;
    const W = scene.largeur || 800, H = scene.hauteur || 600;
    if (canvas.width !== W || canvas.height !== H) { canvas.width = W; canvas.height = H; appliquerZoom(); }
    ctx.clearRect(0, 0, W, H);
    const phase = Math.floor(temps / cadence);
    for (let i = 0; i < couches.length; i++) {
      const c = couches[i];
      if (!c.visible) continue;
      const f = c.type === 'anime' ? c.f[((phase % c.f.length) + c.f.length) % c.f.length] : c.f[0];
      const im = charger(url(f));
      if (im.complete && im.naturalWidth > 0) dernier[i] = im;
      if (dernier[i]) ctx.drawImage(dernier[i], 0, 0);
    }
    if (grille) dessinerGrille(W, H);
    const total = scene.nb_frames || 1;
    $('#chrono').textContent = `frame ${phase % total} / ${total - 1} · ${cadence} ms`;
    if (document.activeElement !== $('#curseur')) $('#curseur').value = phase % total;
  }

  function boucle(now) {
    if (lecture) {
      const precedent = boucle.last || now;
      boucle.last = now;
      temps += (now - precedent) * vitesse;
    } else { boucle.last = now; }
    dessiner();
    if (scene && now - dernierPrechargement > 120) {
      dernierPrechargement = now;
      const phase = Math.floor(temps / cadence);
      for (const c of couches) if (c.type === 'anime' && c.visible) {
        for (let k = 1; k <= 3; k++) charger(url(c.f[(phase + k) % c.f.length]));
      }
    }
    requestAnimationFrame(boucle);
  }

  function appliquerZoom() {
    if (!scene) return;
    const W = scene.largeur || 800, H = scene.hauteur || 600;
    canvas.style.width = Math.round(W * zoom) + 'px';
    canvas.style.height = Math.round(H * zoom) + 'px';
    document.querySelectorAll('button.zoom').forEach(b => b.classList.toggle('on', +b.dataset.z === zoom));
  }

  function ajuster() {
    if (!scene) return;
    const W = scene.largeur || 800;
    const largeur = Math.max(300, $('.cadre').clientWidth - 24);
    zoom = Math.min(3, Math.max(.25, largeur / W));
    appliquerZoom();
  }

  function listeCalques() {
    $('#nb-calques').textContent = couches.length + ' calque' + (couches.length > 1 ? 's' : '');
    $('#liste-calques').innerHTML = couches.map((c, i) =>
      `<label class="calque"><input type="checkbox" data-i="${i}" ${c.visible ? 'checked' : ''}>
       <span class="nom">${esc(String(c.ordre ?? i + 1).padStart(2, '0'))} · ${esc(c.nom)}</span>
       <span class="type ${c.type === 'anime' ? 'anime' : ''}">${c.type === 'anime' ? c.f.length + ' frames' : 'fixe'}</span></label>`).join('');
    $('#liste-calques').querySelectorAll('input').forEach(ch => ch.onchange = () => {
      couches[+ch.dataset.i].visible = ch.checked; dessiner();
    });
  }

  function choisirScene(i) {
    scene = P.scenes[i];
    couches = scene.calques.map(c => ({ ...c, visible: true }));
    dernier = []; temps = 0; cadence = scene.cadence_ms || P.cadence_ms || 100;
    $('#cadence').value = cadence;
    $('#source-cadence').textContent = 'relevée : ' + (P.cadence_source || 'inconnue');
    $('#curseur').max = Math.max(0, (scene.nb_frames || 1) - 1);
    $('#curseur').value = 0;
    $('#details-scene').textContent = `${scene.largeur} × ${scene.hauteur} px · ${couches.length} calques · ` +
      `${scene.nb_frames} frames · cadence ${cadence} ms (${P.cadence_source || 'choisie'}). ` +
      `Les calques sont dessinés du bas vers le haut, sans rééchantillonnage.`;
    document.querySelectorAll('#scenes button').forEach((b, j) => b.classList.toggle('on', i === j));
    listeCalques(); ajuster(); dessiner();
  }

  function installerControles() {
    $('#play').onclick = e => { lecture = !lecture; e.target.textContent = lecture ? '⏸ Pause' : '▶ Lecture'; };
    $('#prec').onclick = () => { temps = Math.max(0, temps - cadence); dessiner(); };
    $('#suiv').onclick = () => { temps += cadence; dessiner(); };
    $('#reset').onclick = () => { temps = 0; dessiner(); };
    $('#vitesse').onchange = e => vitesse = +e.target.value;
    $('#cadence').onchange = e => { cadence = Math.max(16, Math.min(2000, +e.target.value || 100)); $('#source-cadence').textContent = 'cadence réglée à la main'; };
    $('#curseur').oninput = e => { lecture = false; $('#play').textContent = '▶ Lecture'; temps = +e.target.value * cadence; dessiner(); };
    $('#grille').onchange = e => { grille = e.target.checked; dessiner(); };
    document.querySelectorAll('button.zoom').forEach(b => b.onclick = () => { zoom = +b.dataset.z; appliquerZoom(); });
    $('#fit').onclick = ajuster;
    $('#tout').onclick = () => { couches.forEach(c => c.visible = true); listeCalques(); dessiner(); };
    $('#rien').onclick = () => { couches.forEach(c => c.visible = !c.visible); listeCalques(); dessiner(); };
    $('#png').onclick = () => {
      dessiner();
      const a = document.createElement('a');
      a.download = `${ID}_${scene ? scene.id : 'vue'}_frame${Math.floor(temps / cadence)}.png`;
      a.href = canvas.toDataURL('image/png'); a.click();
    };
    window.addEventListener('resize', () => { if (zoom > 3) ajuster(); });
  }

  async function fichiersEtInfos() {
    const r = await fetch(`/api/pack/${ID}/fichiers`).then(x => x.json());
    const liste = r.fichiers || [];
    $('#nb-fichiers').textContent = `${liste.length} fichiers · ${fmt(liste.reduce((n, f) => n + f.taille, 0))} décompressés`;
    let limite = 160, filtre = '';
    const rendreListe = () => {
      const v = liste.filter(f => f.f.toLowerCase().includes(filtre));
      $('#fichiers').innerHTML = v.slice(0, limite).map(f =>
        `<a href="${url(f.f)}" download title="${esc(f.f)}"><span>${esc(f.f)}</span><span>${fmt(f.taille)}</span></a>`).join('') ||
        '<p class="note">Aucun fichier.</p>';
      $('#plus-fichiers').hidden = v.length <= limite;
      $('#plus-fichiers').textContent = `Afficher 160 de plus (${Math.max(0, v.length - limite)} restants)`;
    };
    $('#cherche-fichier').oninput = e => { filtre = e.target.value.toLowerCase(); limite = 160; rendreListe(); };
    $('#plus-fichiers').onclick = () => { limite += 160; rendreListe(); };
    rendreListe();

    const manifeste = liste.find(f => /(^|\/)manifest\.json$/i.test(f.f)) ||
                      liste.find(f => /\.md$/i.test(f.f)) ||
                      liste.find(f => /verification\.json$/i.test(f.f));
    if (manifeste) {
      try {
        const t = await fetch(`/api/pack/${ID}/texte?f=${encodeURIComponent(manifeste.f)}`).then(x => x.text());
        $('#infos-texte').textContent = `// ${manifeste.f}\n\n` + t;
        $('#sec-infos').hidden = false;
      } catch (e) { /* silencieux */ }
    }
  }

  async function demarrer() {
    let reponse;
    try { reponse = await fetch(`/api/catalogue`).then(x => x.json()); } catch (e) { /* non bloquant */ }
    if (reponse) APERCU = Object.fromEntries(reponse.catalogue.apercus.map(a => [a.id, a]));

    const { pack } = await fetch(`/api/pack/${ID}`).then(x => x.json());
    if (!pack) { $('#titre').textContent = 'Pack introuvable'; return; }
    P = pack;
    document.title = pack.titre + ' — Aperçus des maps PMDO';
    $('#titre').textContent = pack.titre;
    $('#chemin').textContent = pack.fichier;
    $('#zip').href = `/pack/${ID}/zip`;
    $('#pied').textContent = `${pack.nb_fichiers} fichiers · ${fmt(pack.taille)} · ${pack.extensions['.png'] || 0} PNG · ` +
      `${pack.animations.length} animations natives · ${pack.grounds.length} Grounds`;

    const scenesNb = pack.scenes.length;
    const frames = scenesNb ? pack.scenes.reduce((n, s) => n + s.calques.reduce((m, c) => m + c.f.length, 0), 0) : 0;
    $('#resume').innerHTML = [
      ['vert', `${pack.nb_fichiers} fichiers`],
      ['vert', `${scenesNb} scène${scenesNb > 1 ? 's' : ''} reconstituée${scenesNb > 1 ? 's' : ''}`],
      frames ? ['vert', `${frames.toLocaleString('fr-FR')} frames PNG`] : null,
      ['or', `${pack.animations.length} WebP/GIF animés`],
      ['or', `${pack.grounds.length} maps PMDO`],
      ['', `cadence ${pack.cadence_ms} ms`],
      pack.mod ? ['', 'mod PMDO natif'] : null,
    ].filter(Boolean).map(([c, t]) => `<span class="puce ${c}">${esc(t)}</span>`).join('');

    // Aperçus HTML d'origine
    const liens = [];
    if (pack.apercu_lie && APERCU && APERCU[pack.apercu_lie]) {
      const a = APERCU[pack.apercu_lie];
      liens.push(`<a class="origine" href="/${enc(a.fichier)}" target="_blank" rel="noopener"><strong>${esc(a.titre)}</strong><small>aperçu autonome de la racine · ${fmt(a.taille)}</small></a>`);
    }
    for (const h of pack.html) {
      liens.push(`<a href="${url(h.f)}" target="_blank" rel="noopener"><strong>${esc(h.titre)}</strong><small>${esc(h.f)} · ${fmt(h.taille)}</small></a>`);
    }
    if (liens.length) { $('#origine').innerHTML = liens.join(''); $('#sec-origine').hidden = false; }

    // Animations natives
    if (pack.animations.length) {
      let limite = 24;
      const rendre = () => {
        $('#animations').innerHTML = pack.animations.slice(0, limite).map(a =>
          `<article><div class="visu"><img src="${url(a.f)}" loading="lazy" alt="${esc(a.f)}"></div>
           <p>${esc(a.f)}<br>${fmt(a.taille)}</p></article>`).join('') +
          (pack.animations.length > limite ? `<button class="ctrl" id="plus-anim">Afficher ${Math.min(24, pack.animations.length - limite)} de plus</button>` : '');
        const b = $('#plus-anim'); if (b) b.onclick = () => { limite += 24; rendre(); };
      };
      rendre(); $('#sec-anim').hidden = false;
    }

    // Studio calques
    if (scenesNb) {
      $('#scenes').innerHTML = pack.scenes.map((s, i) =>
        `<button data-i="${i}">${esc(s.label)} <small>· ${s.nb_frames}f · ${s.calques.length}c</small></button>`).join('');
      $('#scenes').querySelectorAll('button').forEach(b => b.onclick = () => choisirScene(+b.dataset.i));
      installerControles(); choisirScene(0); requestAnimationFrame(boucle);
      $('#sec-studio').hidden = false;
    } else {
      $('#sec-studio').hidden = false;
      $('#sec-studio').innerHTML = '<h2>Reconstitution des calques</h2><p class="note">Ce pack ne contient que des données PMDO natives (.rsground/.tile/.lua) : ' +
        'aucun calque image à reconstituer. Les cartes sont listées ci-dessous et un aperçu HTML autonome est proposé quand il existe.</p>';
    }

    // Grounds
    if (pack.grounds.length) {
      const a = pack.apercu_lie && APERCU && APERCU[pack.apercu_lie];
      $('#grounds').innerHTML = pack.grounds.map(g =>
        `<a href="${a ? '/' + enc(a.fichier) : '#'}" ${a ? 'target="_blank" rel="noopener"' : ''} title="${esc(g.f)}">${esc(g.nom)}</a>`).join('');
      $('#sec-grounds').hidden = false;
    }

    fichiersEtInfos();
  }

  demarrer().catch(e => { $('#titre').textContent = 'Erreur'; $('#chemin').textContent = String(e); });
})();
