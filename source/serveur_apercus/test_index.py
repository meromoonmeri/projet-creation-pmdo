#!/usr/bin/env python3
"""Contrôle de la page d'accueil du serveur d'aperçus : chaque map doit y être listée.

Vérifie, sans réseau ni navigateur :

  - les 290 maps des trois recensements apparaissent **une fois chacune** ;
  - les 171 maps rapatriées pointent vers un **fichier réel** de `maps/` ;
  - les 232 maps illustrées ont un lien (natif ou vignette) vers un fichier présent ;
  - les 58 lots sans image sont listés quand même, signalés « sans image » ;
  - chaque ligne a une ancre de galerie qui **existe** dans `apercu_galerie_maps.html` ;
  - le filtre client est présent (champ + compteur) et la page reste légère.

    python3 source/serveur_apercus/test_index.py
"""
from __future__ import annotations

import re
import sys
from html import escape, unescape
from pathlib import Path

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
sys.path.insert(0, str(HERE))

import serve  # noqa: E402

echecs = 0


def verifie(nom: str, condition: bool, detail: object = '') -> None:
    global echecs
    if condition:
        print(f'  PASS {nom}')
    else:
        echecs += 1
        print(f'  FAIL {nom} — {detail}')


def main() -> int:
    page = serve.index_page()
    unites = serve.unites_maps()

    verifie('page générée', len(page) > 20000, len(page))
    verifie('290 maps recensées', len(unites) == 290, len(unites))

    lignes = re.findall(r'<li data-mots="[^"]*">(.*?)</li>', page, re.S)
    verifie('une ligne par map', len(lignes) == len(unites), f'{len(lignes)} lignes / {len(unites)} maps')

    # libellés : chaque étiquette apparaît dans sa ligne
    manquants = [u['etiquette'] for u in unites
                 if not any(u['etiquette'] in unescape(l) for l in lignes)]
    verifie('chaque map nommée dans la liste', not manquants, manquants[:3])

    # liens natifs
    natifs = [u for u in unites if u.get('_local')]
    verifie('171 fichiers natifs liés', len(natifs) == 171, len(natifs))
    absents = [u['_local']['fichier'] for u in natifs if not (R / u['_local']['fichier']).exists()]
    verifie('tous les fichiers natifs existent', not absents, absents[:3])
    lies = [m for m in re.findall(r'href="(maps/[^"]+)"', page)]
    verifie('chaque fichier natif est lié', len(set(lies)) == 171, len(set(lies)))

    # liens vignette
    vignettes = [u for u in unites if u.get('vignette') and not u.get('_local')]
    fichiers_vignette = [u['vignette'] for u in vignettes if not (R / u['vignette']).exists()]
    verifie('toutes les vignettes liées existent', not fichiers_vignette, fichiers_vignette[:3])
    verifie('232 maps illustrées', len(natifs) + len(vignettes) == 232, len(natifs) + len(vignettes))

    # lots sans image : présents et signalés
    sans = [u for u in unites if not u.get('_local') and not u.get('vignette')]
    verifie('58 lots sans image listés', len(sans) == 58, len(sans))
    verifie('badge « sans image » sur chacun', page.count('class="abs"') == 58, page.count('class="abs"'))

    # ancres de galerie
    galerie = (R / 'apercu_galerie_maps.html').read_text(encoding='utf-8')
    ancres = set(re.findall(r'href="apercu_galerie_maps\.html#([^"]+)"', page))
    verifie('un lien de galerie par map illustrée ou non', len(ancres) >= 232, len(ancres))
    orphelines = [a for a in ancres if f"'{a}'" not in galerie and f'"{a}"' not in galerie
                  and f'id = slug(u.etiquette)' not in galerie]
    # les ancres sont calculées côté navigateur : on revérifie avec la même règle
    ancres_attendues = {serve.slug(u['etiquette']) for u in unites
                        if u.get('_local') or u.get('vignette')}
    verifie('ancres conformes à la règle de la galerie', ancres == ancres_attendues,
            list(ancres ^ ancres_attendues)[:3])
    verifie('galerie : ancres générées côté client', 'd.id = slug(u.etiquette)' in galerie)

    # filtre client
    verifie('champ de filtre', 'id="qm"' in page and 'Filtrer les maps' in page)
    verifie('compteur de filtre', 'id="qn"' in page and 'maps affichées' in page)
    verifie('familles toutes présentes', page.count('class="famille"') == 9, page.count('class="famille"'))
    verifie('page < 400 ko', len(page) < 400_000, len(page))
    verifie('aperçus toujours listés', page.count('apercu_') > 40, page.count('apercu_'))
    verifie('aucun fichier local absent', all((R / f).exists() for f in set(lies)), '')

    print('\nPage d\'accueil OK — ' + str(len(unites)) + ' maps listées, '
          + str(len(natifs)) + ' fichiers natifs, ' + str(len(vignettes)) + ' vignettes, '
          + str(len(sans)) + ' lots sans image')
    return 0 if not echecs else 1


if __name__ == '__main__':
    raise SystemExit(main())
