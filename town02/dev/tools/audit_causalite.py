#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_causalite.py — un personnage introduit dans une scene y reste-t-il ?

POURQUOI CET OUTIL
------------------
Retour utilisateur du 2026-07-30, mot pour mot :

    « chaque nouvel element dans une cinematique doit avoir une causalite
      rien ne doit etre mis en retrait, par exemple je t'ai demande
      d'inclure plum tu as fais sa cinematique mais rien d'autre, elle
      s'inscrit plus dans la narration en cours, elle a pas de paillasse
      reagis pas aux cauchemar de zigzaton »

Le defaut est structurel, pas ponctuel : on ecrit le beat d'introduction
d'un personnage avec soin, puis on continue la scene comme s'il n'existait
plus. Le corriger a la main une fois ne garantit rien pour la prochaine
scene — c'est exactement le cas ou la directive demande d'ameliorer
l'OUTIL plutot que de se contenter du correctif.

CE QUE L'OUTIL MESURE
---------------------
Pour chaque fonction de cinematique du depot, il decoupe le corps en
« beats » (les sections numerotees en commentaire : « -- 4. LE DINER »,
« -- 8bis. ... », sinon des tranches de taille fixe), puis :

  1. il releve tous les personnages MANIPULES dans chaque beat — un
     personnage est « present » des qu'un appel moteur le prend pour
     cible (CharTurnToCharAnimated, MoveToPosition, SetSpeaker, Listen,
     TeleportTo, CharSetAnim, EmoteAndPause, Speak, ...) ;

  2. il repere le beat ou chaque personnage APPARAIT pour la premiere
     fois (creation par MakeCharactersFromList, ou premiere manipulation) ;

  3. il signale tout personnage qui, apres son beat d'introduction,
     DISPARAIT pendant N beats consecutifs alors que la scene continue —
     sans qu'aucune sortie explicite (Hide, EnterGroundMap, RemoveTempChar,
     commentaire de depart) n'ait ete jouee.

C'est une heuristique, pas une preuve : un personnage peut legitimement
sortir du champ. L'outil ne juge donc pas, il DEMANDE une justification,
et il cite le beat exact — meme esprit de preuve que les autres audits du
projet (fichier + ligne, jamais un ressenti).

LIMITES ASSUMEES
----------------
  * Il ne lit pas la geometrie : un personnage present mais hors camera
    ne sera pas signale (c'est le role de verify_scene_positions).
  * Il ne juge pas la qualite de la reaction, seulement son existence.
  * Une variable de personnage rangee dans une table (t.plum) et une
    variable locale (plum) sont traitees comme deux noms distincts si le
    script melange les deux ; c'est volontaire, ca revele justement les
    scenes ou le passage de relais entre fonctions a ete oublie.

USAGE
    python3 tools/audit_causalite.py .
    python3 tools/audit_causalite.py . --trou 3        # seuil de tolerance
    python3 tools/audit_causalite.py . --scene CampNightfall
"""
import argparse
import os
import re
import sys

# Appels moteur qui prennent un personnage en PREMIER argument.
CIBLE_ARG1 = [
    'CharTurnToCharAnimated', 'CharAnimateTurnTo', 'CharSetEmote',
    'CharSetAnim', 'CharEndAnim', 'CharSetAction', 'MoveToPosition',
    'TeleportTo', 'EntTurn', 'CharTurnToChar', 'AnimateToPosition',
    'EightWayMove', 'EightWayMoveRS', 'EmoteAndPause', 'DoAnimation',
    'Shake', 'ShakeHead', 'Hop', 'Complain', 'LookAround', 'Recoil',
    'FaceMovingCharacter', 'Speak', 'HeroDialogue', 'StartConversation',
    'EndConversation', 'Nausea', 'Recover', 'Listen', 'Says', 'SaysA',
    'ListenA', 'DisableCharacterAI', 'EnableCharacterAI',
]
RE_CIBLE = re.compile(
    r'\b(?:%s)\s*\(\s*([A-Za-z_][\w.]*)' % '|'.join(CIBLE_ARG1))

# Un personnage peut aussi etre cible en 2e argument (le regarde).
RE_CIBLE2 = re.compile(
    r'\b(?:CharTurnToCharAnimated|CharTurnToChar|FaceMovingCharacter)'
    r'\s*\(\s*[A-Za-z_][\w.]*\s*,\s*([A-Za-z_][\w.]*)')

RE_SPEAKER = re.compile(r'UI:SetSpeaker\s*\(\s*([A-Za-z_][\w.]*)')
# Listes d'auditeurs : Listen(x, {a, b, c}) / Says(x, "e", 'K', {a, b})
RE_TABLE = re.compile(r'\{([^{}]*)\}')

# Creation d'un personnage.
RE_CREATION = re.compile(
    r'(?:local\s+)?([\w,\s]+?)\s*=\s*'
    r'(?:CharacterEssentials\.MakeCharactersFromList|'
    r'GROUND:CreateCharacter|GROUND:SpawnerDoSpawn|CH)\s*\(')

# Sortie explicite : on ne reproche rien apres ca.
RE_SORTIE = re.compile(
    r'GROUND:Hide\s*\(\s*([A-Za-z_][\w.]*)|'
    r'RemoveTempChar\s*\(\s*([A-Za-z_][\w.]*)')

# S'ENDORMIR EST UNE SORTIE LEGITIME. Un dormeur n'a plus rien a jouer
# jusqu'a ce qu'on le reveille : le signaler serait un faux positif
# systematique sur toutes les scenes de bivouac du projet (il y en a
# quatre). CharEndAnim / Wake le remettent en scene.
RE_DORT = re.compile(
    r'CharSetAnim\s*\(\s*([A-Za-z_][\w.]*)\s*,\s*[\'"](?:Event)?Sleep')

# Debut de fonction de scene.
RE_FUNC = re.compile(r'^\s*function\s+([\w.]+)\s*\(([^)]*)\)')
# Titre de beat : « \t-- 4. LE DINER » ou « \t-- 8bis. LES HISTOIRES ».
# UN SEUL NIVEAU D'INDENTATION, ET UN ESPACE APRES LES TIRETS : c'est la
# convention reelle du depot pour les sections de haut niveau. Sans ces
# deux contraintes, les sous-etapes commentees a l'interieur d'une section
# (« \t\t--1. LE CALME », « \t\t--3. LA CHUTE ») etaient prises pour des
# beats a part entiere et decoupaient une scene de 16 sections en 40 —
# chaque personnage semblait alors absent la moitie du temps.
# Le titre doit en outre COMMENCER PAR UNE MAJUSCULE OU UN CHIFFRE et
# comporter au moins deux mots en capitales : c'est la convention du
# depot (« -- 6. L'ORDRE DU SOIR »). Les enumerations en minuscules a
# l'interieur d'un commentaire d'entete (« -- 4. l'escalade, puis
# Penticus qui tranche ») ne sont PAS des sections : elles decrivent le
# plan d'une seule section, et les compter en doublait le nombre.
# EXACTEMENT UN ESPACE apres les tirets, et une seule tabulation devant :
# les listes numerotees a l'interieur d'un commentaire d'entete sont
# indentees de trois espaces (« \t--   1. le duo remarque... »), ce qui
# les exclut. Verifie sur les 40 occurrences du fichier de reference.
# Accepte aussi la numerotation a deux niveaux « 1.3. » utilisee par
# les scenes decoupees d'apres le plan (acte.beat).
RE_BEAT = re.compile(r'^\t?--+ (\d+(?:\.\d+)?(?:bis|ter)?)\. ?(\S.*)$')
RE_TITRE_SECTION = re.compile(r'[A-ZÉÈÀÊÎÔÛ]{3,}')

# Noms a ignorer : ce ne sont pas des personnages.
IGNORE = {
    'true', 'false', 'nil', 'self', 'i', 'j', 'k', 'x', 'y', 'who', 'chara',
    'activator', 'obj', 'map', 'r', 's', 'm', 'b', 'c', 'p', 'target',
    'speaker', 'listeners', 'STRINGS', 'UI', 'GAME', 'GROUND', 'SOUND',
    'TASK', 'AI', 'SV', 'math', 'table', 'string', 'ipairs', 'pairs',
    'function', 'local', 'end', 'GeneralFunctions', 'CharacterEssentials',
    'BossFX', 'VoiceVisions', 'COMMON', 'PartnerEssentials', 'tostring',
    'emote', 'emotion', 'key', 'dir', 'route', 'anim', 'bed', 'delay',
    'name', 'nickname', 'monster', 'result', 'ground', 'food', 'blocker',
}


def noms(txt):
    """Tous les identifiants de personnage manipules dans ce texte."""
    out = set()
    for rx in (RE_CIBLE, RE_CIBLE2, RE_SPEAKER):
        out |= set(rx.findall(txt))
    # Les tables d'auditeurs de Listen/Says, ecrites en clair...
    for appel in re.finditer(r'\b(?:Listen|ListenA|Says|SaysA)\s*\(', txt):
        reste = txt[appel.end():appel.end() + 400]
        tbl = RE_TABLE.search(reste)
        if tbl:
            for n in tbl.group(1).split(','):
                n = n.strip()
                if re.fullmatch(r'[A-Za-z_][\w.]*', n or ''):
                    out.add(n)
    # ...ou rangees dans une variable juste avant l'appel. Patron reel du
    # depot : « local listeners = {partner, hero, t.rin, ...} » puis
    # « Listen(t.penticus, listeners) ». Sans ce cas, tous les auditeurs
    # d'une adresse collective passaient pour absents du beat.
    # ...ou passees par une VARIABLE, y compris declaree loin de l'appel.
    # Patrons reels du depot :
    #   local listeners = {partner, hero, ...}   puis  Listen(x, listeners)
    #   local ecoutants = {hero, partner, ...}   puis  SaysA(x, e, k, ecoutants)
    # On resout donc les tables locales du beat, et on developpe toute
    # variable citee en argument d'auditeurs. Sans cela, un groupe qui
    # ecoute via une variable passait pour absent du beat — faux positif
    # constate sur les six accueils d'ArrivalCutscene.
    tables = {}
    for m in re.finditer(r'local\s+(\w+)\s*=\s*\{([^{}]*)\}', txt):
        noms_tbl = set()
        for n in m.group(2).split(','):
            n = n.strip()
            if re.fullmatch(r'[A-Za-z_][\w.]*', n or '') and n not in IGNORE:
                noms_tbl.add(n)
        if noms_tbl:
            tables[m.group(1)] = noms_tbl
    for m in re.finditer(
            r'\b(?:Listen|ListenA)\s*\([^,()]+,\s*(\w+)\s*[,)]|'
            r'\b(?:Says|SaysA)\s*\((?:[^,()]+,){3}\s*(\w+)\s*[,)]', txt):
        var = m.group(1) or m.group(2)
        if var in tables:
            out |= tables[var]
    return {n for n in out
            if n not in IGNORE
            and not n.startswith(('coro', 'RogueEssence', 'RogueElements',
                                  '_DATA', '_ZONE', 'STRINGS'))}


def creations(txt):
    out = set()
    for m in RE_CREATION.finditer(txt):
        for n in m.group(1).split(','):
            n = n.strip()
            if re.fullmatch(r'[A-Za-z_]\w*', n or '') and n not in IGNORE:
                out.add(n)
    return out


RE_ENTREE = re.compile(r'GROUND:Unhide\s*\(\s*([A-Za-z_][\w.]*)')


def _porteur(n):
    n = (n or '').strip()
    return n[:-len('.EntName')] if n.endswith('.EntName') else n


def sorties(txt):
    """Sorties de scene REELLES du beat.

    PIEGE VERIFIE, et c'est lui qui rendait l'outil aveugle au bug qu'il
    est cense attraper : le patron courant du depot est
        GROUND:Hide(plum.EntName)   -- on la cache le temps de la placer
        ...
        GROUND:Unhide(plum.EntName) -- on la revele
    Le Hide etait compte comme une sortie definitive dans le beat meme de
    l'introduction ; la verification s'arretait donc aussitot et Plum
    n'etait jamais signalee. Un Hide annule par un Unhide dans le MEME
    beat n'est pas une sortie, c'est une mise en place.
    """
    caches = {_porteur(m.group(1) or m.group(2)) for m in RE_SORTIE.finditer(txt)}
    reveles = {_porteur(n) for n in RE_ENTREE.findall(txt)}
    return {n for n in caches - reveles if n and n not in IGNORE}


def decoupe_beats(corps, depart):
    """Rend [(numero, titre, ligne_debut, texte)]. Sans titre : tranches."""
    lignes = corps.split('\n')
    marques = []
    for i, l in enumerate(lignes):
        m = RE_BEAT.match(l)
        if m and RE_TITRE_SECTION.search(m.group(2)):
            marques.append((i, m.group(1), m.group(2).strip()))
    if len(marques) < 2:
        # Pas de sections nommees : tranches de 60 lignes.
        TAILLE = 60
        return [(str(1 + i // TAILLE), '(tranche)', depart + i,
                 '\n'.join(lignes[i:i + TAILLE]))
                for i in range(0, len(lignes), TAILLE)]
    beats = []
    if marques[0][0] > 0:
        beats.append(('0', '(ouverture)', depart,
                      '\n'.join(lignes[:marques[0][0]])))
    for idx, (i, num, titre) in enumerate(marques):
        fin = marques[idx + 1][0] if idx + 1 < len(marques) else len(lignes)
        beats.append((num, titre, depart + i, '\n'.join(lignes[i:fin])))
    return beats


def scan_fichier(path, seuil, filtre):
    src = open(path, encoding='utf-8-sig').read()
    lignes = src.split('\n')
    # Decoupage en fonctions.
    debuts = [(i, m.group(1)) for i, l in enumerate(lignes)
              for m in [RE_FUNC.match(l)] if m]
    signalements = []
    for idx, (i, nom) in enumerate(debuts):
        fin = debuts[idx + 1][0] if idx + 1 < len(debuts) else len(lignes)
        corps = '\n'.join(lignes[i:fin])
        if filtre and filtre.lower() not in nom.lower():
            continue
        # On ne s'interesse qu'aux vraies cinematiques.
        if corps.count('WaitShowDialogue') < 6:
            continue
        beats = decoupe_beats(corps, i + 1)
        if len(beats) < 3:
            continue
        presence = [noms(b[3]) for b in beats]
        creee = [creations(b[3]) for b in beats]
        partie = [sorties(b[3]) for b in beats]
        reveil = [{a or b for a, b in re.findall(
            r'CharEndAnim\s*\(\s*([A-Za-z_][\w.]*)|'
            r"DoAnimation\s*\(\s*([A-Za-z_][\w.]*)\s*,\s*'Wake'", b[3])}
            for b in beats]
        # UN SOMMEIL ANNULE DANS LE MEME BEAT N'EST PAS UN SOMMEIL —
        # MAIS UN SOMMEIL REPOSE APRES COUP EN EST UN.
        # Piege verifie sur la scene de Plum, qui contient les deux cas
        # dans le meme beat :
        #     CharSetAnim(plum, "Sleep")  -- elle est assommee par sa chute
        #     CharEndAnim(plum)           -- elle se releve pour sa tirade
        # (donc PAS endormie a la fin du beat), et plus loin
        #     CharEndAnim(plum) ... CharSetAnim(plum, "Sleep")
        # (elle veille avec les jeunes, PUIS se rendort pour de bon).
        # Un simple « Sleep moins EndAnim » se trompait dans un cas sur
        # deux. On compare donc les POSITIONS : seule compte la derniere
        # instruction du beat qui concerne ce personnage.
        def _endormi_a_la_fin(txt):
            fin = {}
            for m in re.finditer(
                    r'CharSetAnim\s*\(\s*([A-Za-z_][\w.]*)\s*,\s*'
                    r'[\'"](?:Event)?Sleep', txt):
                fin[m.group(1)] = ('dort', m.start())
            for m in re.finditer(
                    r'CharEndAnim\s*\(\s*([A-Za-z_][\w.]*)|'
                    r"DoAnimation\s*\(\s*([A-Za-z_][\w.]*)\s*,\s*'Wake'",
                    txt):
                n = m.group(1) or m.group(2)
                if n not in fin or m.start() > fin[n][1]:
                    fin[n] = ('debout', m.start())
            return {n for n, (etat, _) in fin.items() if etat == 'dort'}

        dort = [_endormi_a_la_fin(b[3]) for b in beats]
        # CAST REEL DE LA SCENE.
        # Deux portes d'entree, et la seconde est celle qui attrape le bug
        # d'origine (« Plum, sa cinematique, et rien d'autre ») :
        #   * vu dans au moins DEUX beats — un habitue de la scene ;
        #   * OU manipule au moins QUATRE fois EN TOUT, meme concentre dans
        #     un seul beat. C'est la signature exacte d'un personnage qu'on
        #     introduit avec soin puis qu'on laisse tomber : sur la version
        #     precedente de ce fichier, Plum totalisait 24 manipulations
        #     dans le seul beat « 4bis » et zero partout ailleurs. Le
        #     critere « deux beats » la laissait passer ; celui-ci la
        #     signale, et c'est tout l'interet de l'outil.
        compte_beats, compte_total = {}, {}
        for bi, s in enumerate(presence):
            for n in s:
                compte_beats[n] = compte_beats.get(n, 0) + 1
        for bi, b in enumerate(beats):
            for n in noms(b[3]):
                # densite reelle : combien d'appels le visent dans ce beat
                compte_total[n] = compte_total.get(n, 0) + len(
                    re.findall(r'\b%s\b' % re.escape(n), b[3]))
        cast = {n for n in compte_beats
                if compte_beats[n] >= 2 or compte_total.get(n, 0) >= 4}
        for perso in sorted(cast):
            # Beat d'introduction.
            intro = None
            for bi, s in enumerate(presence):
                if perso in s or perso in creee[bi]:
                    intro = bi
                    break
            if intro is None:
                continue
            # Beat de sortie explicite.
            sortie = None
            for bi in range(intro, len(beats)):
                if perso in partie[bi]:
                    sortie = bi
                    break
            derniere = intro
            endormi = False
            for bi in range(intro + 1, len(beats)):
                if sortie is not None and bi > sortie:
                    break
                # Il dort : on ne lui reproche pas son inaction, et on
                # repousse le point de reference tant qu'il n'est pas
                # reveille.
                if perso in dort[bi - 1] or perso in dort[bi]:
                    endormi = True
                if endormi:
                    if perso in reveil[bi]:
                        endormi = False
                    derniere = bi
                    continue
                if perso in presence[bi]:
                    if bi - derniere - 1 >= seuil:
                        signalements.append((
                            path, nom, perso,
                            beats[derniere][0], beats[derniere][1],
                            beats[bi][0], beats[bi][1],
                            beats[derniere + 1][2], bi - derniere - 1))
                    derniere = bi
            # Trou en fin de scene (il disparait et ne revient jamais).
            fin_utile = sortie if sortie is not None else len(beats) - 1
            if endormi:
                continue
            if fin_utile - derniere >= seuil:
                signalements.append((
                    path, nom, perso,
                    beats[derniere][0], beats[derniere][1],
                    'FIN', 'jamais revu',
                    beats[derniere + 1][2], fin_utile - derniere))
    return signalements


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('racine', nargs='?', default='.')
    ap.add_argument('--trou', type=int, default=3,
                    help='nombre de beats consecutifs sans le personnage '
                         'avant de signaler (defaut 3)')
    ap.add_argument('--scene', default=None,
                    help='ne verifier que les fonctions dont le nom contient '
                         'cette chaine')
    a = ap.parse_args()

    base = os.path.join(a.racine, 'Data', 'Script')
    tous = []
    for dossier, _, fichiers in os.walk(base):
        for f in fichiers:
            if f.endswith('.lua'):
                try:
                    tous += scan_fichier(os.path.join(dossier, f),
                                         a.trou, a.scene)
                except Exception as e:                      # noqa: BLE001
                    print('  ! lecture impossible %s : %s' % (f, e))

    print('=' * 78)
    print('AUDIT DE CAUSALITE — personnages mis en retrait au milieu d une scene')
    print('seuil : %d beat(s) consecutif(s) sans manipulation' % a.trou)
    print('=' * 78)
    if not tous:
        print('\nRESULTAT : AUCUN PERSONNAGE MIS EN RETRAIT')
        return 0
    par_fichier = {}
    for s in tous:
        par_fichier.setdefault((s[0], s[1]), []).append(s)
    for (path, fonc), lst in sorted(par_fichier.items()):
        print('\n%s' % path)
        print('  %s()' % fonc)
        for (_, _, perso, b1, t1, b2, t2, ligne, trou) in lst:
            print('    %-14s absent de %d beat(s) : apres « %s. %s » '
                  '(l.%d) -> reapparait « %s. %s »'
                  % (perso, trou, b1, t1[:34], ligne, b2, t2[:34]))
    print('\n' + '=' * 78)
    print('TOTAL : %d mise(s) en retrait a justifier' % len(tous))
    print('=' * 78)
    return 0


if __name__ == '__main__':
    sys.exit(main())
