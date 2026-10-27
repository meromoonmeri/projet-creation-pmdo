/* Galerie de toutes les cartes : aperçus HTML, packs ZIP, HTML embarqués, Grounds, chantiers. */
(() => {
  'use strict';
  const $ = s => document.querySelector(s);
  const enc = p => p.split('/').map(encodeURIComponent).join('/');
  const fmt = n => n >= 1e6 ? (n / 1e6).toFixed(1) + ' Mo' : n >= 1e3 ? Math.round(n / 1e3) + ' Ko' : n + ' o';
  const esc = s => String(s ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));

  let DATA = null, TOUT = [], FILTRE = [], LIMITE = 120;
  const state = { q: '', type: 'tous', categorie: 'Toutes' };

  const TYPES = [
    ['tous', 'Tout'], ['apercu', 'Aperçus HTML'], ['pack', 'Packs ZIP'],
    ['html-zip', 'HTML dans ZIP'], ['ground', 'Maps natives'], ['chantier', 'Chantiers'], ['anime', 'Animations'],
  ];

  function urlPack(p, f) { return `/pack/${p.id}/f/${enc(f)}`; }

  function construire(cat, etat) {
    const A = Object.fromEntries(cat.apercus.map(a => [a.id, a]));
    const P = Object.fromEntries(cat.packs.map(p => [p.id, p]));
    const out = [];

    for (const a of cat.apercus) {
      const acts = [{ t: 'Ouvrir l’aperçu', u: '/' + enc(a.fichier), p: true }];
      if (a.pack && P[a.pack]) acts.push({ t: 'Pack ZIP', u: `/pack/${a.pack}/` });
      out.push({
        id: a.id, type: 'apercu', titre: a.titre, categorie: a.categorie,
        mots: a.mots + ' ' + a.fichier, url: '/' + enc(a.fichier), thumb: `/thumb/${a.id}.webp`,
        anime: !!a.anime, poids: a.taille,
        badges: [a.anime ? 'Animé' : null, a.images ? a.images + ' images' : null, a.canvas ? 'Canvas' : null,
                 a.redirect ? 'Redirection' : null, fmt(a.taille)],
        acts,
      });
    }

    for (const p of cat.packs) {
      const frames = p.scenes.reduce((n, s) => n + s.calques.reduce((m, c) => m + c.f.length, 0), 0);
      const acts = [{ t: 'Lecteur du pack', u: `/pack/${p.id}/`, p: true }];
      if (p.apercu_lie && A[p.apercu_lie]) acts.push({ t: 'Aperçu d’origine', u: '/' + enc(A[p.apercu_lie].fichier) });
      if (p.html.length) acts.push({ t: `HTML interne (${p.html.length})`, u: urlPack(p, p.html[0].f) });
      acts.push({ t: 'Télécharger ZIP', u: `/pack/${p.id}/zip` });
      out.push({
        id: p.id, type: 'pack', titre: p.titre, categorie: p.categorie,
        mots: p.mots + ' ' + p.fichier, url: `/pack/${p.id}/`, thumb: `/thumb/${p.id}.webp`,
        anime: p.animations.length > 0 || frames > p.scenes.length, poids: p.taille,
        badges: ['ZIP', p.nb_fichiers + ' fichiers', p.scenes.length ? p.scenes.length + ' scènes' : null,
                 frames ? frames + ' frames' : null, p.animations.length ? p.animations.length + ' WebP/GIF' : null,
                 p.grounds.length ? p.grounds.length + ' Grounds' : null, p.mod ? 'Mod PMDO' : null, fmt(p.taille)],
        acts,
      });
    }

    // Aperçus HTML qui n'existent qu'à l'intérieur d'un ZIP
    for (const p of cat.packs) for (const h of p.html) {
      out.push({
        id: p.id + ':' + h.f, type: 'html-zip', titre: h.titre, categorie: p.categorie,
        mots: h.f + ' ' + p.mots, url: urlPack(p, h.f), thumb: `/thumb/${p.id}.webp`,
        anime: true, poids: h.taille,
        badges: ['HTML dans ZIP', 'Animations', fmt(h.taille)],
        acts: [{ t: 'Ouvrir l’aperçu', u: urlPack(p, h.f), p: true },
               { t: 'Lecteur du pack', u: `/pack/${p.id}/` }],
      });
    }

    // Chaque .rsground = une map native livrée dans un ZIP
    for (const p of cat.packs) for (const g of p.grounds) {
      const lie = p.apercu_lie && A[p.apercu_lie];
      const u = lie ? '/' + enc(lie.fichier) : `/pack/${p.id}/#grounds`;
      out.push({
        id: p.id + ':' + g.f, type: 'ground', titre: g.nom.replace(/_/g, ' '), categorie: p.categorie,
        mots: g.nom + ' ' + p.mots, url: u, thumb: `/thumb/${p.id}.webp`, anime: !!lie, poids: 0,
        badges: ['Map PMDO', p.titre.slice(0, 30), lie ? 'Aperçu lié' : 'Données natives'],
        acts: [{ t: 'Voir la map', u, p: true }, { t: 'Pack', u: `/pack/${p.id}/` }],
      });
    }

    for (const c of cat.chantiers) {
      const a = c.apercu && A[c.apercu], p = c.pack && P[c.pack];
      const u = a ? '/' + enc(a.fichier) : p ? `/pack/${p.id}/` : null;
      out.push({
        id: 'src:' + c.id, type: 'chantier', titre: c.titre, categorie: c.categorie,
        mots: c.mots, url: u, thumb: a ? `/thumb/${a.id}.webp` : p ? `/thumb/${p.id}.webp` : null,
        anime: !!(a && a.anime), poids: 0,
        badges: ['Chantier source', a ? 'Aperçu lié' : p ? 'Pack lié' : 'Méthode seule'],
        acts: u ? [{ t: a ? 'Ouvrir l’aperçu' : 'Ouvrir le pack', u, p: true }] : [],
      });
    }
    return out;
  }

  function chiffres(cat, etat) {
    const s = cat.stats;
    const cellules = [
      [s.apercus, 'aperçus HTML'], [s.packs, 'packs ZIP'], [s.chantiers, 'chantiers source'],
      [s.scenes, 'scènes reconstituées'], [s.frames_png, 'frames PNG'], [s.grounds, 'maps PMDO natives'],
    ];
    $('#chiffres').innerHTML = cellules.map(([n, l]) =>
      `<div class="chiffre"><b>${n.toLocaleString('fr-FR')}</b><span>${l}</span></div>`).join('');
    const complet = etat.fichiers_presents === etat.fichiers_attendus;
    $('#etat-texte').innerHTML = complet
      ? `<strong style="color:var(--vert)">Restauration complète</strong> — ${etat.fichiers_presents}/${etat.fichiers_attendus} fichiers d'origine (${etat.volume_mo} Mo), ${etat.packs_extraits} ZIP extraits, ${etat.fichiers_extraits.toLocaleString('fr-FR')} médias disponibles, ${etat.vignettes} vignettes.`
      : `<strong style="color:var(--rouge)">Restauration partielle</strong> — ${etat.fichiers_presents}/${etat.fichiers_attendus} fichiers. Lancez <code>restaurer.py</code>.`;
    $('.point').style.background = complet ? 'var(--vert)' : 'var(--rouge)';
  }

  function barreTypes() {
    $('#types').innerHTML = TYPES.map(([id, label]) => {
      const n = id === 'tous' ? TOUT.length : TOUT.filter(e => id === 'anime' ? e.anime : e.type === id).length;
      return `<button data-type="${id}" class="${state.type === id ? 'actif' : ''}">${esc(label)}<small>${n}</small></button>`;
    }).join('');
    $('#types').querySelectorAll('button').forEach(b => b.onclick = () => {
      state.type = b.dataset.type; LIMITE = 120; barreTypes(); categories(); rendre();
    });
  }

  function categories() {
    const compte = new Map();
    for (const e of TOUT) {
      if (state.type !== 'tous' && !(state.type === 'anime' ? e.anime : e.type === state.type)) continue;
      compte.set(e.categorie, (compte.get(e.categorie) || 0) + 1);
    }
    const noms = ['Toutes', ...[...compte.keys()].sort((a, b) => compte.get(b) - compte.get(a))];
    $('#categories').innerHTML = noms.map(n =>
      `<button data-cat="${esc(n)}" class="${state.categorie === n ? 'actif' : ''}">${esc(n)} <small>${n === 'Toutes' ? [...compte.values()].reduce((a, b) => a + b, 0) : compte.get(n)}</small></button>`).join('');
    $('#categories').querySelectorAll('button').forEach(b => b.onclick = () => {
      state.categorie = b.dataset.cat; LIMITE = 120; categories(); rendre();
    });
  }

  function filtrer() {
    const q = state.q.trim().toLowerCase();
    return TOUT.filter(e => {
      if (state.type === 'anime' ? !e.anime : state.type !== 'tous' && e.type !== state.type) return false;
      if (state.categorie !== 'Toutes' && e.categorie !== state.categorie) return false;
      if (!q) return true;
      return (e.titre + ' ' + e.mots + ' ' + e.categorie).toLowerCase().includes(q);
    }).sort((a, b) => {
      const ordre = { apercu: 0, 'html-zip': 1, pack: 2, ground: 3, chantier: 4 };
      if (q) {
        const ra = a.titre.toLowerCase().startsWith(q) ? 0 : 1, rb = b.titre.toLowerCase().startsWith(q) ? 0 : 1;
        if (ra !== rb) return ra - rb;
      }
      return (ordre[a.type] - ordre[b.type]) || a.titre.localeCompare(b.titre, 'fr');
    });
  }

  function carte(e) {
    const img = e.thumb
      ? `<img src="${esc(e.thumb)}" alt="" loading="lazy" onerror="this.style.display='none'">`
      : `<div style="width:100%;height:100%;display:grid;place-items:center;color:var(--doux);font-size:12px">source /</div>`;
    const badges = e.badges.filter(Boolean).slice(0, 6).map((b, i) =>
      `<span class="badge ${i === 0 ? (e.type === 'ground' ? 'ground' : e.type === 'pack' ? 'zip' : '') : ''}">${esc(b)}</span>`).join('');
    const acts = e.acts.filter(a => a.u).slice(0, 4).map(a =>
      `<a class="${a.p ? 'principal' : ''}" href="${esc(a.u)}" ${a.u.startsWith('/pack/') && a.u.endsWith('zip') ? '' : 'target="_blank" rel="noopener"'}>${esc(a.t)}</a>`).join('');
    return `<article class="carte">
      <div class="image">${img}<span class="type">${{apercu:'Aperçu',pack:'Pack ZIP','html-zip':'HTML ZIP',ground:'Map native',chantier:'Chantier'}[e.type]}</span></div>
      <div class="corps"><span class="categorie">${esc(e.categorie)}</span><h3 title="${esc(e.titre)}">${esc(e.titre)}</h3>
      <div class="meta">${badges}</div></div>
      <div class="actions">${acts || '<a href="#" onclick="return false">Aucun aperçu</a>'}</div>
    </article>`;
  }

  function rendre() {
    FILTRE = filtrer();
    const visibles = FILTRE.slice(0, LIMITE);
    $('#grille').innerHTML = visibles.map(carte).join('');
    $('#compte').textContent = `${FILTRE.length.toLocaleString('fr-FR')} carte${FILTRE.length > 1 ? 's' : ''}` +
      (FILTRE.length > LIMITE ? ` — ${visibles.length} affichées` : '');
    $('#titre-section').textContent = state.categorie === 'Toutes' ? 'Toutes les cartes' : state.categorie;
    $('#plus').hidden = FILTRE.length <= LIMITE;
    $('#plus').textContent = `Afficher ${Math.min(120, FILTRE.length - LIMITE)} cartes de plus`;
    $('#vide').hidden = FILTRE.length > 0;
  }

  $('#plus').onclick = () => { LIMITE += 120; rendre(); };
  $('#q').addEventListener('input', e => { state.q = e.target.value; LIMITE = 120; rendre(); });
  document.addEventListener('keydown', e => {
    if (e.key === '/' && document.activeElement !== $('#q')) { e.preventDefault(); $('#q').focus(); }
    if (e.key === 'Escape') { $('#q').value = ''; state.q = ''; rendre(); $('#q').blur(); }
  });

  fetch('/api/catalogue').then(r => r.json()).then(({ catalogue, etat }) => {
    DATA = catalogue; TOUT = construire(catalogue, etat);
    chiffres(catalogue, etat); barreTypes(); categories(); rendre();
  }).catch(e => { $('#etat-texte').textContent = 'Erreur de chargement du catalogue : ' + e; });
})();
