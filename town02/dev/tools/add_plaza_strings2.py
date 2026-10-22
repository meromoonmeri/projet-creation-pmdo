#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""add_plaza_strings2.py — cles de la scene d'arrivee revisee.

MTP_070..074  Papilusion supplie AVANT l'arrivee : elle nomme la Team
              Dazzling la premiere.
MTP_075..077  Les deux Kecleon, depuis leur stand, expliquent qui elles
              sont : une equipe reputee.
MTP_078       La question du partenaire, qui appelle la reponse.
MTP_079..082  Les quatre repliques d'entree, dites HORS CHAMP depuis le
              haut du chemin de terre nord. Texte fourni par
              l'utilisateur, repris a la lettre (ponctuation normalisee).
MTP_090..093  Le pretexte du rendez-vous avec Penticus (branche defaite).
MTP_094..096  Le meme pretexte apres une victoire — il ne sonne plus
              pareil.

Meme format que add_plaza_strings.py : insertion avant </root> dans
strings.resx ET strings.fr.resx, aucune cle existante touchee.
Controle : moins de 150 caracteres par boite, hors balises [pause=N].
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DIR = os.path.join(ROOT, 'Data', 'Script', 'halcyon', 'ground', 'metano_town')

TEXTES = {
    # ---- Papilusion, AVANT l'arrivee ------------------------------
    'MTP_070': "Excusez-moi ![pause=20] Vous êtes de la guilde, n'est-ce pas ?",
    'MTP_071': "Mon petit n'est pas rentré.[pause=25] Il est parti vers les bois ce matin.",
    'MTP_072': "On peut y aller tout de suite ![pause=20] Dites-nous seulement où.",
    'MTP_073': "C'est que...[pause=25] on m'a conseillé une équipe. Une vraie. Des habitués.",
    'MTP_074': "La Team Dazzling.[pause=30] On dit qu'elles ne reviennent jamais bredouilles.",

    # ---- Les deux Kecleon, depuis leur stand -----------------------
    'MTP_075': "La Team Dazzling ?[pause=25] Ça, madame, c'est du sérieux.",
    'MTP_076': "Trois donjons de rang supérieur cette saison.[pause=20] Trois.",
    'MTP_077': "Elles passent ici entre deux missions.[pause=25] Jamais plus de deux jours.",

    # ---- La question du partenaire ---------------------------------
    'MTP_078': "La Team Dazzling...[pause=20] ? Qui sont-ils ?",

    # ---- L'entree, dite hors champ depuis le chemin nord -----------
    'MTP_079': "Hello darling...[pause=20] Bonjour, bienvenue, bonsoir !",
    'MTP_080': "Qui sommes-nous ?[pause=25] Voyons, boya, tu vis dans une grotte ou quoi ?",
    'MTP_081': "Peut-être qu'il est juste bête, vous savez.",
    'MTP_082': "ORRH, la ferme ![pause=20] Tu vas gâcher notre entrée !",

    # ---- Le pretexte : rendez-vous avec Penticus (defaite) ---------
    'MTP_090': "Bien.[pause=25] Nous avons assez donné de notre temps.",
    'MTP_091': "On nous attend à la guilde.[pause=25] J'ai exigé un entretien avec Penticus.",
    'MTP_092': "Exigé ![pause=20] C'est comme demander, mais en plus joli !",
    'MTP_093': "Ce n'est pas du tout ça.[pause=25] Avance.",

    # ---- Le meme pretexte, apres une victoire ----------------------
    'MTP_094': "Nous sommes attendues.[pause=25] Penticus m'a accordé un entretien.",
    'MTP_095': "« Accordé ».[pause=30] Tu l'as réclamé trois fois par courrier.",
    'MTP_096': "On part parce qu'on a gagné, hein ?[pause=25] ...On a gagné, non ?",
}


def check():
    ok = True
    for k, v in TEXTES.items():
        plain = re.sub(r'\[pause=\d+\]', '', v)
        if len(plain) > 150:
            print(f'  TROP LONG {k}: {len(plain)}')
            ok = False
    return ok


def insert(path, textes):
    with open(path, encoding='utf-8') as f:
        s = f.read()
    deja = [k for k in textes if f'name="{k}"' in s]
    if deja:
        print(f'  {os.path.basename(path)} : {len(deja)} deja presentes, ignorees')
    bloc = ''
    for k in sorted(textes):
        if k in deja:
            continue
        v = (textes[k].replace('&', '&amp;')
                      .replace('<', '&lt;').replace('>', '&gt;'))
        bloc += (f'  <data name="{k}" xml:space="preserve">\n'
                 f'    <value>{v}</value>\n  </data>\n')
    if not bloc:
        return 0
    i = s.rindex('</root>')
    with open(path, 'w', encoding='utf-8') as f:
        f.write(s[:i] + bloc + s[i:])
    return bloc.count('<data ')


if __name__ == '__main__':
    if not check():
        sys.exit(1)
    print(f'{len(TEXTES)} cles, toutes sous 150 caracteres.')
    if '--apply' not in sys.argv:
        print('--apply pour ecrire')
        sys.exit(0)
    for name in ('strings.resx', 'strings.fr.resx'):
        n = insert(os.path.join(DIR, name), TEXTES)
        print(f'  {name} : {n} cles inserees')
