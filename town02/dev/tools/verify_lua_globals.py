#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verify_lua_globals.py — detecte les FONCTIONS GLOBALES APPELEES MAIS JAMAIS
DEFINIES.

LE BUG QUE CET OUTIL EMPECHE DE REVENIR
=======================================
`PrintInfo` etait appelee 600 fois dans 381 fichiers du mod. Elle n'etait
definie NULLE PART : ni dans Data/Script, ni dans RogueEssence, ni dans
Halcyon d'origine.

Pourquoi ca ne se voyait pas, et pourquoi c'etait devastateur :

  En Lua, appeler une globale nil leve une erreur. Le moteur enveloppe chaque
  callback de script dans un xpcall (LuaEngine.cs:895) :
      local co = coroutine.create(function() xpcall(fun, PrintStack, ...) end)
  Le jeu ne plante donc pas. Il AVORTE SILENCIEUSEMENT la fonction en cours,
  a la ligne de l'appel. Tout ce qui suit n'est jamais execute.

  Consequence concrete, verifiee : la transition Creuset -> Mont Venteux.
      zone/searing_tunnel/init.lua:209   PrintInfo(...)  <-- meurt ici
                                          EndDungeonRun  <-- jamais atteint
      searing_crucible_ch_5.DefeatedBoss  PrintInfo(...) <-- meurt ici
                                          GAME:FadeOut   <-- jamais atteint
                                          EnterGroundMap <-- jamais atteint
  Quatre correctifs successifs du fondu n'ont rien change, pour une raison
  simple : le code corrige n'etait jamais execute.

  Signature dans les logs : la premiere ligne attendue de main.lua etait
  ABSENTE. Une fonction fantome appelee tot tue le fichier qui l'appelle.

REGLE APPLIQUEE
===============
Toute fonction appelee sous la forme `Nom(` ou `Nom.Sous(`, dont la racine
est une globale, doit etre definie quelque part dans Data/Script, ou bien
etre une globale connue du moteur / de la bibliotheque standard Lua.

Les globales du moteur sont listees explicitement ci-dessous plutot que
devinees : une liste blanche fausse rendrait l'outil aveugle.

Sortie : 0 si aucune fonction fantome, 1 sinon.
"""
import os
import re
import sys
import glob

# Bibliotheque standard Lua + globales exposees par RogueEssence.
# Verifiees dans RogueEssence/Lua/LuaEngine.cs (ExposeInterface, SetupGlobals)
# et dans les scripts d'origine du moteur.
CONNUES = {
    # Lua standard
    'print', 'pairs', 'ipairs', 'type', 'tostring', 'tonumber', 'pcall',
    'xpcall', 'error', 'assert', 'select', 'next', 'rawget', 'rawset',
    'rawequal', 'rawlen', 'setmetatable', 'getmetatable', 'require',
    'collectgarbage', 'unpack', 'load', 'loadstring', 'dofile', 'loadfile',
    'string', 'table', 'math', 'os', 'io', 'coroutine', 'debug', 'utf8',
    'bit32', '_ENV', '_G',
    # Interfaces RogueEssence exposees a Lua
    'GAME', 'GROUND', 'UI', 'SOUND', 'TASK', 'AI', 'DUNGEON', '_DUNGEON',
    'STRINGS', 'DEBUG', 'COMMON', 'SV', 'LUA_ENGINE', 'RogueEssence',
    'RogueElements', 'luanet', 'PathMod', 'Direction', 'Gender', 'Color',
    '_DATA', '_ZONE', '_MENU', 'MRKR', 'CH', 'LTBL', 'PrintStack',
    'BGAnimData', 'ObjAnimData',
    # Tables de constantes du moteur
    'EngineServiceEvents', 'GraphicsManager', 'DrawEffect', 'FrameInput',
    # Globales creees par le moteur via RunString, verifiees une par une
    # dans RogueEssence/Lua/LuaEngine.cs :
    'OBJ',        # l.772  OBJ = function(name)
    'IDX',        # l.811  IDX = function(id, ...)
    'MonsterID',  # l.820  employee comme globale par le moteur lui-meme
    'SPWN',       # l.836  SPWN = function(spawnername)
    'CHName',     # l.795  CHName function init
    # Fournie par les scripts de base du jeu (origin.ai.base_state), qui ne
    # sont pas versionnes dans ce depot : PMDO les livre avec le moteur.
    # Verifie : ground_default.lua fait require 'origin.ai.base_state' avant
    # tout appel a Class().
    'Class',
}

# CALIBRAGE — une premiere version a ete REJETEE (110 faux positifs).
# Elle capturait `obj:Get(...)`, `x.Elements(...)`, `self:Think(...)` : des
# METHODES sur des objets, pas des globales. Une methode inconnue de l'outil
# n'est pas une fonction fantome, c'est du code parfaitement valide.
#
# On ne retient donc QUE l'appel d'une globale nue en debut d'expression :
#   PrintInfo(...)        -> candidat
#   obj:PrintInfo(...)    -> methode, ignore
#   obj.PrintInfo(...)    -> champ, ignore
#   a = Truc(...)         -> candidat (Truc est bien une globale)
# Le nom ne doit etre precede ni d'un point, ni de deux-points, ni d'un
# caractere de mot.
APPEL = re.compile(r'(?<![\w.:])([A-Za-z_][\w]*)\s*\(')
DEF_FONCTION = re.compile(
    r'^\s*(?:local\s+)?function\s+([A-Za-z_][\w]*)', re.MULTILINE)
DEF_AFFECT = re.compile(
    r'^\s*(?:local\s+)?([A-Za-z_][\w]*)\s*=', re.MULTILINE)
DEF_TABLE = re.compile(
    r'^\s*(?:local\s+)?([A-Za-z_][\w]*)\s*=\s*\{', re.MULTILINE)


def sans_commentaires_ni_chaines(texte):
    """Neutralise commentaires et chaines SANS changer le nombre de lignes.

    La premiere version supprimait les lignes de commentaire et ecrasait les
    blocs --[[ ]] : la numerotation etait alors DECALEE et l'outil pointait
    des lignes qui n'avaient rien a voir. Un outil qui designe le mauvais
    endroit fait perdre plus de temps qu'il n'en gagne.
    """
    # Blocs --[[ ]] : on remplace le contenu en gardant les sauts de ligne.
    def vider(m):
        return re.sub(r'[^\n]', ' ', m.group(0))
    texte = re.sub(r'--\[\[.*?\]\]', vider, texte, flags=re.DOTALL)
    lignes = []
    for l in texte.split('\n'):
        if l.strip().startswith('--'):
            lignes.append('')          # ligne videe, mais CONSERVEE
            continue
        l = re.sub(r'--.*$', '', l)
        l = re.sub(r'"[^"]*"', '""', l)
        l = re.sub(r"'[^']*'", "''", l)
        lignes.append(l)
    return '\n'.join(lignes)


def audit(racine):
    fichiers = sorted(glob.glob(
        os.path.join(racine, 'Data/Script/**/*.lua'), recursive=True))

    definies = set(CONNUES)
    textes = {}
    for f in fichiers:
        try:
            brut = open(f, encoding='utf-8').read()
        except OSError:
            continue
        t = sans_commentaires_ni_chaines(brut)
        textes[f] = t
        for m in DEF_FONCTION.finditer(t):
            definies.add(m.group(1))
        for m in DEF_AFFECT.finditer(t):
            definies.add(m.group(1))
        for m in DEF_TABLE.finditer(t):
            definies.add(m.group(1))

    fantomes = {}
    for f, t in textes.items():
        # Variables locales du fichier : elles ne sont pas des fantomes.
        locales = set(re.findall(r'\blocal\s+([A-Za-z_][\w]*)', t))
        # Les PARAMETRES de fonction non plus. common.lua:479 declare
        # `function COMMON.ShowTeamAssemblyMenu(init_fun)` puis appelle
        # `init_fun()` : parfaitement valide, ce n'est pas une globale.
        for params in re.findall(r'function[^(]*\(([^)]*)\)', t):
            for nom_param in params.split(','):
                nom_param = nom_param.strip()
                if re.fullmatch(r'[A-Za-z_][\w]*', nom_param):
                    locales.add(nom_param)
        for i, ligne in enumerate(t.split('\n'), 1):
            for m in APPEL.finditer(ligne):
                nom = m.group(1)
                if nom in definies or nom in locales:
                    continue
                # Mots-cles Lua suivis d'une parenthese.
                if nom in ('if', 'while', 'for', 'return', 'and', 'or',
                           'not', 'then', 'do', 'end', 'elseif', 'else',
                           'function', 'local', 'in', 'repeat', 'until'):
                    continue
                fantomes.setdefault(nom, []).append(
                    (os.path.relpath(f, racine), i))
    return fantomes


def main():
    racine = sys.argv[1] if len(sys.argv) > 1 else '.'
    fantomes = audit(racine)

    print('verify_lua_globals : %d fonction(s) globale(s) jamais definie(s)'
          % len(fantomes))
    print()
    if not fantomes:
        print('RESULTAT : AUCUNE FONCTION FANTOME')
        return 0

    for nom in sorted(fantomes, key=lambda n: -len(fantomes[n])):
        lieux = fantomes[nom]
        print('  %s  — %d appel(s), jamais definie' % (nom, len(lieux)))
        for chemin, ligne in lieux[:3]:
            print('      %s:%d' % (chemin, ligne))
        if len(lieux) > 3:
            print('      ... et %d autre(s)' % (len(lieux) - 3))
        print()
    print('RESULTAT : %d fonction(s) fantome(s)' % len(fantomes))
    return 1


if __name__ == '__main__':
    sys.exit(main())
