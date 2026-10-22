#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""add_plaza_strings.py — insere les cles MTP_* de la confrontation.

Ecrit dans strings.resx (defaut) ET strings.fr.resx, au format exact
deja employe par le fichier (bloc <data name=...><value>...</value>).
Insertion avant </root>, sans toucher a une seule cle existante.

Contrainte de projet : 1 a 2 phrases par boite, moins de 150 caracteres
hors balises [pause=N]. Le script le VERIFIE avant d'ecrire.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DIR = os.path.join(ROOT, 'Data', 'Script', 'halcyon', 'ground', 'metano_town')

TEXTES = {
    # ------------------------------------------------------------------
    # ACTE I — la rencontre
    # ------------------------------------------------------------------
    'MTP_001': "La Team Dazzling...[pause=20] Qu'est-ce qu'elles font en plein centre ?",
    'MTP_002': "Vous avez quand même un cœur...[pause=25] n'est-ce pas ?",
    'MTP_003': "S'il vous plaît ![pause=15] Sauvez mon enfant ![pause=20] Il a besoin d'aide !",
    'MTP_004': "Bah oui ![pause=20] Sans un cœur, on serait déjà décédées !",
    'MTP_005': "T'avais vraiment trouvé le meilleur moment pour sortir une bêtise...",
    'MTP_006': "Et puis fallait pas perdre votre gamin.[pause=25] On n'y est pour rien, nous.",
    'MTP_007': "Vous...[pause=25] vous n'avez pas le droit de lui parler comme ça !",
    'MTP_008': "ASSEZ !",
    'MTP_009': "Vous ne voyez pas que vous êtes en train de ruiner toute ma prestance ?",
    'MTP_010': "Bref...[pause=25] Nous n'avons pas que ça à faire. Nous sommes très occupées.",
    'MTP_011': "Alors...[pause=30] écartez-vous.",
    'MTP_012': "Personne n'a besoin de se disputer.[pause=25] On peut juste vous laisser passer.",
    'MTP_013': "« Juste ».[pause=25] Voilà un mot que je déteste.[pause=20] On ne fait rien « juste ».",
    'MTP_014': "Elle vous a demandé de l'aide.[pause=25] Vous auriez pu dire non poliment.",
    'MTP_015': "On a dit non poliment, non ?[pause=20] Enfin...[pause=15] on a dit non.",
    'MTP_016': "Tais-toi, Aria.[pause=25] Chaque fois que tu parles, on recule d'un pas.",
    'MTP_017': "Vous portez un badge d'explorateur.[pause=25] Montrez-moi qu'il vaut quelque chose.",
    'MTP_018': "(Elle ne cherche pas à passer.[pause=25] Elle cherche à voir.)",
    'MTP_019': "Écartez-vous,[pause=15] ou faites-moi écarter.[pause=25] L'un des deux.",
    'MTP_020': "Alors ce sera la deuxième.[pause=25] On ne bouge pas d'ici.",
    'MTP_021': "Enfin une réponse claire.[pause=30] Voyons ce qu'elle vaut.",

    # ------------------------------------------------------------------
    # ACTE III — defaite
    # ------------------------------------------------------------------
    'MTP_030': "Le sol est froid.[pause=30] Vos jambes ne répondent plus.",
    'MTP_031': "Attends...[pause=25] Attends, je me relève...[pause=20] Je me relève !",
    'MTP_032': "Vous étiez sur mon chemin.[pause=30] Vous y êtes toujours.",
    'MTP_033': "Oh ![pause=15] On fait comme ça, alors ?[pause=20] D'accord !",
    'MTP_034': "Relevez-vous avant qu'on revienne.[pause=30] Ça nous fera une surprise.",
    'MTP_035': "Des pas.[pause=25] Beaucoup de pas. Toute la place accourt vers vous.",
    'MTP_036': "(Leurs voix s'éloignent...[pause=30] non.[pause=20] C'est moi qui pars.)",
    'MTP_037': "Quelques heures plus tard...",

    # ------------------------------------------------------------------
    # ACTE III — le chevet
    # ------------------------------------------------------------------
    'MTP_040': "Des voix.[pause=30] Elles parlaient déjà avant que vous ouvriez les yeux.",
    'MTP_041': "(Le plafond de la chambre.[pause=30] Je ne me souviens pas d'être rentré.)",
    'MTP_042': "Il est réveillé ![pause=20] Wouf ![pause=15] Je vais prévenir tout le monde !",
    'MTP_043': "On a perdu, hein ?[pause=30] On a vraiment perdu.",
    'MTP_044': "Rien de cassé.[pause=25] De l'épuisement, surtout. Beaucoup d'épuisement.",
    'MTP_045': "Ce sont les habitants qui vous ont ramenés.[pause=25] À plusieurs. En courant.",
    'MTP_046': "Trois adversaires, deux défenseurs.[pause=25] Pourquoi ne pas avoir reculé ?",
    'MTP_047': "(Parce qu'il y avait quelqu'un derrière nous.[pause=25] Voilà pourquoi.)",
    'MTP_048': "Vous avez tenu devant plus fort que vous.[pause=25] Ce n'est pas une faute.",
    'MTP_049': "Mais tenir ne suffit pas.[pause=30] La prochaine fois, il faudra gagner.",
    'MTP_050': "On s'entraînera.[pause=25] Autant qu'il faudra.",
    'MTP_051': "Voilà ce que je voulais entendre.[pause=30] Reposez-vous. C'est un ordre.",

    # ------------------------------------------------------------------
    # ACTE III — victoire
    # ------------------------------------------------------------------
    'MTP_060': "Le silence dure.[pause=30] Personne, sur cette place, ne s'attendait à ça.",
    'MTP_061': "Le soleil m'a gênée ![pause=20] Enfin...[pause=15] il y avait du soleil, non ?",
    'MTP_062': "Il fait gris depuis ce matin, Aria.",
    'MTP_063': "Un jour sans.[pause=25] Ça arrive à tout le monde.[pause=20] Même à nous.",
    'MTP_064': "Non, Sonata.[pause=30] Ce n'était pas un jour sans.",
    'MTP_065': "Vous êtes plus intéressants que prévu.[pause=25] J'avais mal regardé.",
    'MTP_066': "(Elle ne s'excuse pas.[pause=25] Elle corrige. C'est pire.)",
    'MTP_067': "Ceci ne règle rien.[pause=30] Ça repousse simplement le vrai duel.",
    'MTP_068': "Elles sont parties...[pause=25] et j'ai encore les pattes qui tremblent.",

    # ------------------------------------------------------------------
    # LES TEMOINS — une replique par habitant, par issue
    # ------------------------------------------------------------------
    'MTP_T01': "J'étais juste là.[pause=25] J'aurais pu faire quelque chose.[pause=20] Je n'ai rien fait.",
    'MTP_T02': "Vous les avez battues ![pause=20] Elles ! [pause=15]Je l'ai vu de mes yeux !",
    'MTP_T03': "Elles ne vous ont pas contournés.[pause=30] Elles vous ont marché dessus.",
    'MTP_T04': "Je croyais qu'elles étaient invincibles.[pause=25] Elles ne le sont pas.",
    'MTP_T05': "...[pause=30] On vous a portés jusqu'à la guilde.[pause=20] C'était la moindre des choses.",
    'MTP_T06': "...[pause=30] La place s'en souviendra.[pause=25] Moi aussi.",
    'MTP_T07': "Vous vous êtes mis devant une mère en larmes.[pause=25] Je n'oublierai pas ça.",
    'MTP_T08': "Vous avez gagné,[pause=15] et vous n'avez pas fanfaronné.[pause=25] C'est rare.",
    'MTP_T09': "La grande verte a dit qu'on ruinait sa prestance...[pause=25] Elle l'a ruinée seule.",
    'MTP_T10': "La lapine cherchait une excuse ![pause=20] Il n'y avait même pas de soleil !",
    'MTP_T11': "Trois contre deux.[pause=30] Personne ne peut vous reprocher ça.",
    'MTP_T12': "Trois contre deux,[pause=15] et c'est vous qui êtes debout.[pause=25] Incroyable.",
    'MTP_T13': "Vous vous êtes battus pour mon enfant.[pause=30] Des inconnus. Merci.",
    'MTP_T14': "Vous avez gagné pour lui.[pause=30] Je vais le retrouver. Grâce à vous.",
}


def check():
    ok = True
    for k, v in TEXTES.items():
        plain = re.sub(r'\[pause=\d+\]', '', v)
        if len(plain) > 150:
            print(f'  TROP LONG {k}: {len(plain)} car.')
            ok = False
    return ok


def insert(path, textes):
    with open(path, encoding='utf-8') as f:
        s = f.read()
    already = [k for k in textes if f'name="{k}"' in s]
    if already:
        print(f'  {os.path.basename(path)} : {len(already)} cles deja presentes, ignorees')
    bloc = ''
    for k in sorted(textes):
        if k in already:
            continue
        v = (textes[k].replace('&', '&amp;')
                      .replace('<', '&lt;').replace('>', '&gt;'))
        bloc += (f'  <data name="{k}" xml:space="preserve">\n'
                 f'    <value>{v}</value>\n  </data>\n')
    if not bloc:
        return 0
    i = s.rindex('</root>')
    s = s[:i] + bloc + s[i:]
    with open(path, 'w', encoding='utf-8') as f:
        f.write(s)
    return bloc.count('<data ')


if __name__ == '__main__':
    if not check():
        print('ABANDON : des boites depassent 150 caracteres.')
        sys.exit(1)
    print(f'{len(TEXTES)} cles, toutes sous 150 caracteres.')
    apply = '--apply' in sys.argv
    for name in ('strings.resx', 'strings.fr.resx'):
        p = os.path.join(DIR, name)
        if not apply:
            print(f'  (essai) {name}')
            continue
        n = insert(p, TEXTES)
        print(f'  {name} : {n} cles inserees')
    if not apply:
        print('--apply pour ecrire')
