"""Tests -> ZIP projet PMDO + ZIP calques PNG -> aperçu autonome racine, pour une route fleurie.
.venv/bin/python source/zone_zero_v2/package.py raf1|raf2   (après build.py)
"""
from pathlib import Path
import base64, json, subprocess, sys, zipfile

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
ANIM = ('brume_profonde', 'brume_haute', 'lueurs', 'eau', 'herbes', 'fleurs', 'cascades', 'ecume', 'embruns', 'papillons')
LOTS = {
    'raf1': dict(apercu='apercu_route_zone_zero_fleurie_1.html', titre='Route Zone Zéro 1 fleurie — lèvre du cratère (RAF1, 768×576)',
                 texte=("<p>Nouvelle version de <strong>RAZ1</strong> (gardée) pour le réseau de la Zone Zéro : herbe et falaises "
                        "<strong>Sky Peak</strong>, <strong>fleurs de plusieurs couleurs</strong> qui se balancent comme dans le GIF Sky Peak, "
                        "<strong>arbres PMD</strong> (Apple Woods) en lisière, six <strong>cascades</strong> gardées, et deux gouffres qui "
                        "descendent vraiment : dégradé vers le bleu nuit, brume profonde et brume haute en parallaxe, éclats lointains.</p>"
                        "<p>On arrive au sud, un chemin monte vers l'arête entre les deux gouffres et mène au nord (<code>sortie</code>, vers RAF2). "
                        "Marqueur <code>belvedere</code> au bord du gouffre de gauche.</p>")),
    'raf2': dict(apercu='apercu_route_zone_zero_fleurie_2.html', titre='Route Zone Zéro 2 fleurie — terrasses aux cascades (RAF2, 768×576)',
                 texte=("<p>Nouvelle version de <strong>RAZ2</strong> (gardée) : deux terrasses d'herbe <strong>Sky Peak</strong> reliées par "
                        "un escalier de pierre, cinq <strong>cascades</strong> et leurs bassins, massifs de <strong>fleurs de cinq couleurs</strong> "
                        "animés, <strong>arbres PMD</strong> sur la gauche, et à l'est un <strong>gouffre</strong> profond : dégradé vers le bleu nuit, "
                        "voiles de brume qui passent devant les parois, brume du fond tramée, éclats lointains.</p>"
                        "<p>On arrive au sud, on monte l'escalier puis le chemin de corniche jusqu'aux marches du nord-est (<code>sortie</code>). "
                        "Marqueur <code>belvedere</code> près du bord du gouffre.</p>")),
    'raf3': dict(apercu='apercu_route_zone_zero_fleurie_3.html', titre='Route Zone Zéro 3 fleurie — fond du cratère et tunnel (RAF3, 768×576)',
                 texte=("<p>Nouvelle version de <strong>RAZ3</strong> (gardée) : le fond du cratère devient une longue prairie "
                        "<strong>Sky Peak</strong> fleurie (<strong>six couleurs</strong> de fleurs animées), bordée d'<strong>arbres PMD</strong>, "
                        "entre <strong>deux gouffres</strong> profonds (dégradé vers le bleu nuit, brume du fond, voiles en parallaxe, éclats). "
                        "Les deux <strong>cascades</strong> tombent dans des bassins sur la terrasse haute ; quelques cristaux rappellent la Zone Zéro.</p>"
                        "<p>On arrive au sud, on remonte le chemin, on passe le pavage entre les piliers de cristal et on atteint le tunnel nord "
                        "(<code>sortie</code>, vers EAZ1). Marqueur <code>belvedere</code> au bord du gouffre de gauche.</p>")),
    'eaf1': dict(apercu='apercu_entree_zone_zero_fleurie.html', titre='Entrée Zone Zéro fleurie — la géode du donjon (EAF1, 768×576)',
                 texte=("<p>Suite du réseau fleuri : <strong>EAF1</strong> remplace, dans le réseau fleuri, l'entrée EAZ1 (grotte de cristal sombre, gardée). "
                        "Une chaussée d'herbe <strong>Sky Peak</strong> fleurie monte entre <strong>deux gouffres</strong> profonds "
                        "(dégradé vers le bleu nuit, brume du fond, voiles en parallaxe, éclats) vers la <strong>géode de cristal</strong> "
                        "qui ouvre le donjon de la Zone Zéro. Deux <strong>cascades</strong> tombent de la falaise nord dans des bassins ; "
                        "un plateau de cristaux domine l'ouest.</p>"
                        "<p>On arrive au sud, on monte la chaussée et on atteint la bouche de la géode (<code>sortie</code>, entrée du donjon). "
                        "Marqueur <code>belvedere</code> au bord du gouffre de droite.</p>")),
}
HQ = ("<p><strong>Passe haute qualité</strong> : herbe Sky Peak en aplat franc (ton dominant du GIF), touffes en étoile qui se balancent "
      "(A B A C), fleurs nettes de 7 px en <strong>huit couleurs</strong>, <strong>embruns</strong> au pied des cascades et "
      "<strong>papillons</strong> sur des boucles fermées. Pixels calculés, pas des tuiles natives.</p>")
CRISTAUX = ("<p><strong>Cristaux Zone Zéro</strong> : les cristaux menthe du décor deviennent <strong>blancs</strong> (5 tons qui gardent les facettes, "
            "calque <code>cristaux</code>) et un calque <code>reflets</code> les traverse d'une <strong>bande arc-en-ciel</strong> nacrée "
            "(rouge, orange, jaune, vert, cyan, bleu, mauve, rose) dont la couleur tourne au fil de la boucle, avec des éclats qui scintillent. "
            "Pixels calculés (recoloration du rendu généré), pas des tuiles natives.</p>")
NOTE = ("Le décor, le gouffre et les arbres sont des rendus générés à partir des références Sky Peak et Apple Woods, pas des tuiles natives "
        "(seules la loi et la palette de la cascade viennent de la ROM, via P03P01A). Marqueurs : jaune = <code>entrance</code>, "
        "bleu = <code>sortie</code>, rose = <code>belvedere</code>. Aucun warp : les raccords restent à scripter. Aucun test PMDO en jeu.")


def zipdir(path, items):
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for src, arc in items:
            z.write(src, arc)


def main(lot):
    PFX = lot.upper(); L = LOTS[lot]
    O = R / 'renders/zone_zero_v2' / PFX
    M = json.loads((O / 'manifest.json').read_text())
    S = R / '.cache/zone_zero_v2' / M['pmdo']['namespace']
    subprocess.run([sys.executable, '-m', 'unittest', f'source.zone_zero_v2.{lot}.test_build'], cwd=R, check=True)
    (O / 'README.md').write_text((HERE / lot / 'README_PACK.md').read_text())
    zipdir(O / f'{PFX}_projet_pmdo_0812.zip',
           [(p, M['pmdo']['namespace'] + '/' + p.relative_to(S).as_posix()) for p in sorted(S.rglob('*')) if p.is_file()])
    items = [(p, 'calques/' + p.name) for p in sorted((O / 'calques').glob('*.png'))]
    for sub in ANIM:
        items += [(p, f'animation/{sub}/' + p.name) for p in sorted((O / 'animation' / sub).glob('*.png'))]
    items += [(p, 'masques/' + p.name) for p in sorted((O / 'masques').glob('*.png'))]
    for ref in ('skypeak_gif_f0.png', 'Apple_Woods_entrance_TDS.png'):
        items.append((HERE / 'reference' / ref, 'reference/' + ref))
    items += [(O / f'{PFX}_route_fleurie_calques.ora', f'{PFX}_route_fleurie_calques.ora'), (O / 'manifest.json', 'manifest.json'),
              (O / 'README.md', 'README.md')]
    for rv in ('scene_t000.png', 'scene_animee.webp', 'collisions_marqueurs.png', 'zoom_gouffre.png'):
        items.append((O / 'review' / f'{PFX}_{rv}', f'apercu/{PFX}_{rv}'))
    zipdir(O / f'{PFX}_calques_png_8px.zip', items)

    def uri(p):
        return 'data:image/png;base64,' + base64.b64encode(Path(p).read_bytes()).decode()
    stack = []
    for p in M['layer_order_bottom_to_top']:
        nm = Path(p).stem.split('_', 2)[2].replace('_fNN', '')
        if 'fNN' in p:
            a = M['animations'][nm]
            stack.append({'id': nm, 'ticks': a['frame_length_ticks'],
                          'frames': [uri(O / p.replace('fNN', f'f{t:02d}')) for t in range(a['phases'])]})
        else:
            stack.append({'id': nm, 'ticks': 60, 'frames': [uri(O / p)]})
    data = {'size': M['size_px'], 'loop': M['scene_loop_ticks'], 'stack': stack, 'poses': [],
            'collisions': uri(O / f'review/{PFX}_collisions_marqueurs.png'), 'entry': M['access']['markers']['entrance']}
    anims = '<br>'.join(f"• <strong>{k}</strong> : {v['phases']} × {v['frame_length_ticks']} ticks" for k, v in M['animations'].items())
    texte = L['texte'] + HQ + (CRISTAUX if M.get('cristaux') else '') + f"<p>Animations, toutes en boucle fermée sur {M['scene_loop_ticks']} ticks ({M['scene_loop_ticks'] // 60} s) :<br>{anims}</p>"
    page = ((HERE / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data)).replace('__TITRE__', L['titre'])
            .replace('__TEXTE__', texte).replace('__NOTE__', NOTE).replace('__PFX__', PFX))
    (R / L['apercu']).write_text(page)
    for p in [O / f'{PFX}_projet_pmdo_0812.zip', O / f'{PFX}_calques_png_8px.zip', R / L['apercu']]:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')


if __name__ == '__main__':
    main(sys.argv[1] if len(sys.argv) > 1 else 'raf1')
