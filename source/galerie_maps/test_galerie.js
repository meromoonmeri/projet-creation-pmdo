/* Contrôle navigateur de la galerie exhaustive des maps (`galerie_maps.html`).

   Rejoue la page dans jsdom avec un DOM réel : vérifie que chaque carte est construite,
   que le filtre par famille, la recherche, le masquage, le chargement d'images et la
   visionneuse fonctionnent, et qu'aucune image référencée ne manque sur le disque.

   Usage : NODE_PATH=/tmp/nc/node_modules node source/galerie_maps/test_galerie.js [page.html]
   Code retour 0 = OK, 1 = régression, 2 = harnais KO. */
'use strict';
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');

const PAGE = process.argv[2] || path.join(__dirname, '..', '..', 'apercu_galerie_maps.html');
const RACINE = path.join(__dirname, '..', '..');

let echecs = 0;
function verifie(nom, condition, detail) {
  if (condition) { console.log('  PASS ' + nom); return; }
  echecs++; console.log('  FAIL ' + nom + (detail ? ' — ' + detail : ''));
}

const html = fs.readFileSync(PAGE, 'utf8');
const dom = new JSDOM(html, { runScripts: 'dangerously', pretendToBeVisual: true, url: 'https://exemple.test/galerie_maps.html' });
const d = dom.window.document;

// état initial : aucune image chargée (case décochée) mais toutes les cartes présentes
const donnees = (dom.window.__GALERIE__ || {}).DONNEES;
verifie('données embarquées', Array.isArray(donnees) && donnees.length === 290, donnees && donnees.length);
if (!Array.isArray(donnees)) { console.log('harnais KO : la page n\'a pas exposé ses données'); process.exit(2); }
const cartes = d.querySelectorAll('article.carte');
verifie('une carte par map', cartes.length === donnees.length, cartes.length);
verifie('familles affichées', d.querySelectorAll('h2.famille').length >= 8, d.querySelectorAll('h2.famille').length);
verifie('titre de la page', /Aperçu exhaustif des maps/.test(d.title), d.title);

// aucune image chargée par défaut → alléger
verifie('images non chargées par défaut', d.querySelectorAll('.vue img').length === 0);

// toutes les vignettes existent sur le disque
const manquantes = donnees.filter(u => u.vignette && !fs.existsSync(path.join(RACINE, u.vignette)));
verifie('vignettes présentes sur disque', manquantes.length === 0, manquantes.slice(0, 3).map(u => u.vignette).join(', '));

// charger les images
const cbImages = d.getElementById('images');
cbImages.checked = true; cbImages.onchange();
const nbImages = donnees.filter(u => u.present).length;
verifie('images chargées après bascule', d.querySelectorAll('.vue img').length === nbImages, d.querySelectorAll('.vue img').length + ' vs ' + nbImages);
const premiere = d.querySelector('.vue img');
verifie('lien de vignette relatif', /^apercus\/galerie_maps\//.test(premiere.getAttribute('src')), premiere.getAttribute('src'));
verifie('chargement différé', premiere.getAttribute('loading') === 'lazy', premiere.getAttribute('loading'));

// filtre par famille
const boutonEntree = [...d.querySelectorAll('button.filtre')].find(b => b.dataset.cle === 'entree');
boutonEntree.click();
const apresFiltre = d.querySelectorAll('article.carte').length;
const attendu = donnees.filter(u => u.categorie === 'entree').length;
verifie('filtre « Entrées de donjon »', apresFiltre === attendu && attendu > 0, apresFiltre + ' vs ' + attendu);
verifie('un seul groupe affiché', d.querySelectorAll('h2.famille').length === 1);
verifie('bouton actif', boutonEntree.classList.contains('actif'));

// recherche (sur toutes les familles)
[...d.querySelectorAll('button.filtre')].find(b => b.dataset.cle === 'toutes').click();
const rech = d.getElementById('recherche');
rech.value = 'caverne';
rech.oninput();
const cible = d.querySelectorAll('article.carte').length;
verifie('recherche « caverne »', cible === 2 && cible < donnees.length, cible);
rech.value = 'mont_lointain';
rech.oninput();
verifie('recherche « mont_lointain »', d.querySelectorAll('article.carte').length === 2,
        d.querySelectorAll('article.carte').length);
rech.value = 'zzzz-inexistant';
rech.oninput();
verifie('recherche vide → message', d.querySelectorAll('article.carte').length === 0 && d.getElementById('vide').style.display === 'block');
rech.value = ''; rech.oninput();

// masquage des vignettes
const cbVoile = d.getElementById('voile');
cbVoile.checked = true; cbVoile.onchange();
verifie('masquage des vignettes', d.querySelectorAll('.vue.masquee').length === donnees.length, d.querySelectorAll('.vue.masquee').length);
cbVoile.checked = false; cbVoile.onchange();

// visionneuse
d.querySelector('.vue img').dispatchEvent(new dom.window.MouseEvent('click', { bubbles: true }));
const vis = d.getElementById('visionneuse');
verifie('visionneuse ouverte', vis.classList.contains('open'));
verifie('visionneuse : image', /galerie_maps/.test(vis.querySelector('img').getAttribute('src')));
verifie('visionneuse : lien source GitHub', /github\.com\/meromoonmeri\/projet-pmdo\/blob\//.test(vis.querySelector('.inf').innerHTML));
vis.querySelector('.fermer').click();
verifie('visionneuse refermée', !vis.classList.contains('open'));

// lots sans image : cartes présentes, honnêtement signalées
rech.value = ''; rech.oninput();
const avecImage = d.getElementById('avecimg');
avecImage.checked = false; avecImage.onchange();
const total = d.querySelectorAll('article.carte').length;
verifie('tous les lots affichés sans le filtre', total === donnees.length, total);
const absentes = d.querySelectorAll('article.carte.absente').length;
verifie('58 lots sans image signalés', absentes === 58, absentes);
verifie('badge « sans image »', d.querySelectorAll('.badge.absent').length === absentes);
verifie('raison donnée pour chaque lot sans image',
        [...d.querySelectorAll('article.carte.absente .raison')].every(e => e.textContent.length > 10));
const badgesNature = [...d.querySelectorAll('.badge.nat')].map(e => e.textContent);
verifie('badges de nature (rendu / référence)', badgesNature.includes('rendu') && badgesNature.includes('référence'),
        [...new Set(badgesNature)].join(', '));
avecImage.checked = true; avecImage.onchange();
verifie('filtre « masquer les lots sans image »', d.querySelectorAll('article.carte').length === total - absentes,
        d.querySelectorAll('article.carte').length);
verifie('vignettes : 232 attendues', total - absentes === 232, total - absentes);

// fichiers natifs rapatriés (maps/)
const cbLoc = d.getElementById('local');
cbLoc.checked = true; cbLoc.onchange();
const avecLocal = donnees.filter(u => u.local);
verifie('cartes avec fichier natif', d.querySelectorAll('article.carte').length === avecLocal.length,
        d.querySelectorAll('article.carte').length + ' vs ' + avecLocal.length);
verifie('au moins 83 fichiers natifs', avecLocal.length >= 83, avecLocal.length);
verifie('tous les fichiers natifs existent', avecLocal.every(u => fs.existsSync(path.join(RACINE, u.local))));
verifie('sha256 du manifeste conforme',
        avecLocal.every(u => require('crypto').createHash('sha256')
          .update(fs.readFileSync(path.join(RACINE, u.local))).digest('hex') === u.local_sha256));
verifie('dimensions natives conservées',
        avecLocal.every(u => !u.source_taille || !u.vignette_taille || u.source_taille[0] >= u.vignette_taille[0]));
const liens = [...d.querySelectorAll('a.local')];
verifie('lien « PNG natif » sur chaque carte concernée', liens.length === avecLocal.length, liens.length);
verifie('lien « PNG natif » pointe maps/', liens.every(a => a.getAttribute('href').startsWith('maps/')));
cbLoc.checked = false; cbLoc.onchange();

// cohérence des métadonnées
const sansSource = donnees.filter(u => u.present && !u.source);
verifie('chaque vignette a son chemin source', sansSource.length === 0, sansSource.length);
const familleInconnue = donnees.filter(u => !u.categorie_label);
verifie('chaque map a une famille', familleInconnue.length === 0);

console.log(echecs ? '\n' + echecs + ' échec(s)' : '\nGalerie OK — ' + donnees.length + ' maps recensées, ' + (donnees.length - absentes) + ' avec vignette');
process.exit(echecs ? 1 : 0);
