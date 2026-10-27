#!/usr/bin/env python3
"""Restaure les aperçus de maps (et leurs archives ZIP) depuis meromoonmeri/projet-pmdo.

Le dépôt de travail ne contient que les méthodes : les aperçus HTML autonomes
(779 Mo, animations incluses), les archives ZIP livrées (112 Mo) et les médias
qu'ils référencent sont restés dans le dépôt d'origine (MANIFESTE_EXTRACTION.md).
Cet outil les récupère sans cloner les 6 Go de rendus :

1. clone *blobless* de ``meromoonmeri/projet-pmdo`` (Git ne tire que les blobs demandés) ;
2. ``sparse-checkout`` limité aux aperçus racine, aux ZIP et aux fichiers
   réellement référencés par les pages (galeries, GIF, images de revue) ;
3. copie dans l'arbre de travail aux mêmes chemins, pour que tous les liens
   relatifs des pages fonctionnent.

Les fichiers lourds sont ignorés par ``.gitignore`` ; ils restent locaux et se
re-récupèrent avec cet outil. Idempotent : relancer ne re-télécharge pas ce qui
existe déjà dans le clone cache.

Usage : ``python3 OUTILS/restaurer_apercus.py``   (nécessite git + réseau vers github.com)
"""
from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPO_URL = 'https://github.com/meromoonmeri/projet-pmdo.git'
DEFAULT_REF = '6cca4a09380211e510ab1bea454a1b1926ef4b5a'  # main à l'extraction

# Motifs sparse-checkout (mode non-cone : type .gitignore).
# Les aperçus racine et les archives ; puis les seuls dossiers/fichiers que les
# pages chargent réellement (vérifié avec l'analyse src/href/url des HTML).
PATTERNS = [
    '/apercu_*.html',
    '/*.zip',
    '/renders/beach_layers_v1/',
    '/renders/beach_network_v1/',
    '/renders/beach_sky_gradient_v3/',
    '/renders/cafe_halcyon_agrandi_v1/',
    '/renders/cafe_spinda_reseau_v4/',
    '/renders/cafe_spinda_revisite_v6/',
    '/renders/cafe_spinda_revisite_v7/',
    '/renders/cafe_spinda_revisite_v8/',
    '/renders/spinda_torches_v1/',
    '/renders/mega_evolution_v1/',
    '/renders/mega_evolution_v2/',
    '/renders/mod_guilde_entrees_v1/',
    '/exports/pokemon_custom/tirtouga_v2/review/',
    '/exports/pokemon_custom/tirtouga_v4/review/',
    '/exports/pokemon_custom/tirtouga_v4/carapagos_v4_22_actions_candidate.zip',
    '/exports/pokemon_custom/tirtouga_v4/carapagos_v4_22_gifs.zip',
    '/exports/pokemon_custom/tirtouga_v5/review/gifs/',
    '/exports/pokemon_custom/tirtouga_portraits_v3/portrait_sheet/',
    '/exports/pokemon_custom/tirtouga_portraits_v3/review/',
    '/exports/pokemon_custom/tirtouga_portraits_v4/portraits_individual/',
    '/exports/tera_v2/',
    '/exports/transformations_v1/',
    '/exports/crown_attachment_v1/',
    '/source/mega_evolution_v1/README.md',
    '/source/mega_evolution_v2/recovery_carapagos.md',
    '/source/pokemon_custom/next_species/references/mega_raichu_x/Normal.png',
    '/source/pokemon_custom/next_species/references/mega_raichu_y/Normal.png',
    '/source/pokemon_custom/next_species/references/terapagos_stellar/Normal.png',
    '/source/pokemon_custom/next_species/references/zarude/Normal.png',
    '/source/pokemon_custom/tirtouga_v2/README.md',
    '/source/pokemon_custom/tirtouga_v2/generated_magenta.png',
    '/source/pokemon_custom/tirtouga_v4/README.md',
    '/source/sprite_audit_v2/README.md',
    '/source/transformations_v1/crown_attachment/profiles.json',
]
# vignettes de scène des pages « mod_guilde_entrees_v1 » (un fichier par lot)
SCENES = [
    'entree_bristle_sud_nord_v1/review/EBN1_scene_t000.png',
    'entree_clairiere_tropicale_sud_nord_v1/review/ETC1_scene_t000.png',
    'entree_couloir_violet_sud_nord_v1/review/ECV1_scene_t000.png',
    'entree_cratere_sud_nord_v1/review/ECN1_scene_t000.png',
    'entree_givre_sud_nord_v1/review/EGN1_scene_t000.png',
    'entree_jardin_secret_sud_nord_v1/review/EJS1_scene_t000.png',
    'entree_jardin_secret_sud_nord_v2/review/EJS2_scene_t000.png',
    'entree_jungle_sud_nord_v1/review/EJN1_scene_t000.png',
    'entree_mt_thunder_sud_nord_v1/review/EMT1_scene_t000.png',
    'entree_mystifying_forest_sud_nord_v1/review/EMF1_scene_t000.png',
    'entree_ruine_sud_nord_v1/review/ERN1_scene_t000.png',
    'entree_sables_mouvants_sud_nord_v1/review/EQS1_scene_t000.png',
    'entree_star_cave_sud_nord_v1/review/ESC1_scene_t000.png',
    'entree_underground_lake_sud_nord_v1/review/EUL1_scene_t000.png',
    'entree_vapeur_sud_nord_v1/review/ESN1_scene_phase00.png',
    'entree_vapeur_sud_nord_v2/review/ESN2_scene_t000.png',
    'entree_waterfall_cave_sud_nord_v1/review/EWC1_scene_t000.png',
    'entree_waterfall_cave_sud_nord_v2/review/EWC2_scene_fermee_t000.png',
    'entree_waterfall_cave_sud_nord_v3/review/EWC3_scene_fermee_t000.png',
]


def run(cmd, cwd=None, check=True):
    return subprocess.run(cmd, cwd=cwd, check=check, text=True)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--cache', default='/tmp/pmdo-src',
                    help='clone blobless cache (hors dépôt)')
    ap.add_argument('--ref', default=DEFAULT_REF)
    ap.add_argument('--seulement-liste', action='store_true',
                    help='affiche les motifs sans rien télécharger')
    args = ap.parse_args()

    patterns = PATTERNS + [f'/renders/{p}' for p in SCENES]
    if args.seulement_liste:
        print('\n'.join(patterns))
        return

    cache = Path(args.cache)
    if not (cache / '.git').exists():
        print(f'clone blobless de {REPO_URL} …')
        cache.parent.mkdir(parents=True, exist_ok=True)
        run(['git', 'clone', '--filter=blob:none', '--no-checkout', REPO_URL, str(cache)])
    run(['git', '-C', str(cache), 'fetch', '--depth=1', 'origin', args.ref])
    run(['git', '-C', str(cache), 'sparse-checkout', 'init', '--no-cone'])
    run(['git', '-C', str(cache), 'sparse-checkout', 'set'] + patterns)
    run(['git', '-C', str(cache), 'checkout', '-q', args.ref])

    count = 0
    for src in sorted(cache.glob('apercu_*.html')) + sorted(cache.glob('*.zip')):
        dst = ROOT / src.name
        if not dst.exists():
            shutil.copy2(src, dst)
            count += 1
    for top in ('renders', 'exports', 'source'):
        s_root = cache / top
        if not s_root.exists():
            continue
        for src in s_root.rglob('*'):
            if not src.is_file():
                continue
            rel = src.relative_to(cache)
            dst = ROOT / rel
            if not dst.exists():
                dst.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(src, dst)
                count += 1
    print(f'{count} fichiers copiés vers {ROOT}')
    print('Ensuite : .venv/bin/python OUTILS/restaurer_maps_zip.py pour les maps des ZIP.')


if __name__ == '__main__':
    main()
