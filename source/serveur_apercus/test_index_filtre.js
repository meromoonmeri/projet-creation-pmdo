/* Contrôle du filtre de la page d'accueil du serveur d'aperçus (`/`).

   La page est d'abord générée par Python puis rejouée dans jsdom : le champ `#qm` doit
   filtrer les 290 lignes de maps, masquer les familles devenues vides et tenir le compteur.

   Usage : python3 source/serveur_apercus/test_index.py --page /tmp/index.html
           NODE_PATH=/tmp/nc/node_modules node source/serveur_apercus/test_index_filtre.js /tmp/index.html
   Code retour 0 = OK, 1 = régression. */
'use strict';
const fs = require('fs');
const { JSDOM } = require('jsdom');

const PAGE = process.argv[2];
if (!PAGE) { console.log('usage : node test_index_filtre.js <page.html>'); process.exit(2); }

let echecs = 0;
function verifie(nom, ok, detail) {
  if (ok) console.log('  PASS ' + nom);
  else { echecs++; console.log('  FAIL ' + nom + (detail ? ' — ' + detail : '')); }
}

const dom = new JSDOM(fs.readFileSync(PAGE, 'utf8'), { runScripts: 'dangerously', pretendToBeVisual: true, url: 'https://exemple.test/' });
const d = dom.window.document;
const q = d.getElementById('qm'), n = d.getElementById('qn');
const lignes = [...d.querySelectorAll('li[data-mots]')];

verifie('champ de filtre présent', !!q);
verifie('290 lignes de maps', lignes.length === 290, lignes.length);
verifie('toutes visibles au départ', lignes.every(li => li.style.display !== 'none'));
verifie('compteur initial', /290 \/ 290/.test(n.textContent), n.textContent);

function filtre(v) { q.value = v; q.dispatchEvent(new dom.window.Event('input')); }

filtre('mont_lointain');
const visibles = lignes.filter(li => li.style.display !== 'none');
verifie('filtre par dossier', visibles.length === 2, visibles.length);
verifie('familles vides masquées',
  [...d.querySelectorAll('section.famille')].filter(s => s.style.display !== 'none').length === 1);
verifie('compteur après filtre', /2 \/ 290/.test(n.textContent), n.textContent);

filtre('ekr1');
verifie('filtre par code de map', lignes.filter(li => li.style.display !== 'none').length === 1,
  lignes.filter(li => li.style.display !== 'none').length);

filtre('zarbi');
verifie('filtre accentué/majuscule', lignes.filter(li => li.style.display !== 'none').length >= 1);

filtre('zzz-introuvable');
verifie('aucun résultat', lignes.every(li => li.style.display === 'none'));
verifie('aucune famille affichée',
  [...d.querySelectorAll('section.famille')].every(s => s.style.display === 'none'));

filtre('');
verifie('réinitialisation', lignes.every(li => li.style.display !== 'none') && /290 \/ 290/.test(n.textContent));

verifie('lien vers la galerie', !!d.querySelector('a[href="apercu_galerie_maps.html"]'));
verifie('liens profonds vers la galerie', d.querySelectorAll('a[href^="apercu_galerie_maps.html#"]').length >= 232,
  d.querySelectorAll('a[href^="apercu_galerie_maps.html#"]').length);

console.log(echecs ? '\n' + echecs + ' échec(s)' : '\nFiltre de la page d\'accueil OK');
process.exit(echecs ? 1 : 0);
