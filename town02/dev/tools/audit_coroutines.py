#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_coroutines.py — detecte les appels a TASK:BranchCoroutine mal formes.

LE DEFAUT
---------
BranchCoroutine attend une FONCTION a executer plus tard. Ecrire :

    coro1 = TASK:BranchCoroutine(GAME:MoveCamera(544, 328, 112, false))

execute MoveCamera immediatement, puis passe son RESULTAT (un objet moteur,
ou nil) a BranchCoroutine. Le moteur leve alors :

    NLua.Exceptions.LuaScriptException:
      Invalid arguments to method: ScriptTask.BranchCoroutine: 18100201

et la cinematique s'arrete net. Le joueur reste bloque, souvent sur un
ecran noir, parce que le FadeIn qui suit n'est jamais atteint.

La forme correcte enveloppe l'appel :

    coro1 = TASK:BranchCoroutine(function() GAME:MoveCamera(...) end)

TROIS FORMES SONT VALIDES, et l'outil ne doit pas les confondre :
  1. BranchCoroutine(function() ... end)      lambda      -> OK
  2. BranchCoroutine(module.MaFonction)       reference   -> OK
  3. BranchCoroutine(MaFonction)              reference   -> OK
Seule la forme "appel immediat" — un identifiant suivi d'une parenthese
ouvrante — est fautive.

DEUX AUTRES CAS DETECTES
------------------------
A. TASK:BranchCoroutine({coro1, coro2, ...})
   Passer une LISTE de coroutines a Branch n'a pas de sens : c'est
   JoinCoroutines qui prend une liste, pour attendre la fin de toutes.
   Ecrit avec Branch, le code n'attend rien et la suite se joue par-dessus.

B. APPEL BLOQUANT DANS UNE BOUCLE SUR PLUSIEURS PERSONNAGES
   Une fonction qui contient TASK:WaitTask(chara:StartAnim(...)) attend la
   fin de l'animation. L'appeler dans une boucle `for ... ipairs` fait donc
   jouer les personnages CHACUN LEUR TOUR au lieu d'ensemble : un souffle
   qui repousse l'equipe devient une file d'attente, huit gardes qui se
   levent « a la fois » s'etalent sur deux secondes.
   La forme correcte lance chaque personnage dans sa propre coroutine et
   place le decalage A L'INTERIEUR de la branche :
       local co = {}
       for i, c in ipairs(equipe) do
         co[#co+1] = TASK:BranchCoroutine(function()
           GAME:WaitFrames((i-1) * 5)
           Action(c)
         end)
       end
       TASK:JoinCoroutines(co)
   Patron atteste en donjon : event_single.lua:1392 (chute des rochers).

USAGE
    python3 tools/audit_coroutines.py          # tout Data/Script
    python3 tools/audit_coroutines.py <chemin>
Sortie 1 si au moins un defaut reel est trouve.
"""
from __future__ import annotations

import glob
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# identifiant (avec . ou :) immediatement suivi d'une parenthese => appel
APPEL = re.compile(r"^\s*[A-Za-z_][\w.:]*\s*\(")
LISTE = re.compile(r"^\s*\{")


def main() -> int:
    cible = sys.argv[1] if len(sys.argv) > 1 else str(ROOT / "Data/Script")
    fichiers = sorted(glob.glob(f"{cible}/**/*.lua", recursive=True))

    appels_immediats, listes, refs, commentes = [], [], 0, 0

    for f in fichiers:
        for i, ligne in enumerate(open(f, encoding="utf-8", errors="ignore"), 1):
            if "BranchCoroutine(" not in ligne:
                continue
            if "BranchCoroutine(function" in ligne:
                continue
            if ligne.strip().startswith("--"):
                commentes += 1
                continue
            arg = ligne.split("BranchCoroutine(", 1)[1]
            rel = f.replace(str(ROOT) + "/", "").replace("Data/Script/halcyon/", "")
            if APPEL.match(arg):
                appels_immediats.append((rel, i, ligne.strip()))
            elif LISTE.match(arg):
                listes.append((rel, i, ligne.strip()))
            else:
                refs += 1

    print("=" * 78)
    print(" AUDIT DES COROUTINES — TASK:BranchCoroutine")
    print("=" * 78)
    print(f"\n  {len(fichiers)} fichier(s) Lua analyses\n")

    if appels_immediats:
        print(f"### APPEL IMMEDIAT AU LIEU D'UNE FONCTION : {len(appels_immediats)}")
        print("    (leve « Invalid arguments to method: ScriptTask.BranchCoroutine »)")
        for f, i, s in appels_immediats:
            print(f"\n  {f}:{i}")
            print(f"      {s[:110]}")
            inner = s.split("BranchCoroutine(", 1)[1].rstrip()
            if inner.endswith(")"):
                inner = inner[:-1]
            print(f"    corriger en : TASK:BranchCoroutine(function() {inner[:70]} end)")
        print()

    if listes:
        print(f"### LISTE PASSEE A BRANCH AU LIEU DE JOIN : {len(listes)}")
        print("    (n'attend rien : la suite de la scene se joue par-dessus)")
        for f, i, s in listes:
            print(f"  {f}:{i}")
            print(f"      {s[:110]}")
            print("    corriger en : TASK:JoinCoroutines({...})")
        print()

    # --- C. appels bloquants dans une boucle sur plusieurs personnages ---
    bloquantes = set()
    for f in fichiers:
        src = Path(f).read_text(encoding="utf-8", errors="ignore")
        for m in re.finditer(r"function\s+(\w+\.\w+)\(.*?\n(?=end\b)", src, re.S):
            if "TASK:WaitTask" in m.group(0):
                bloquantes.add(m.group(1))
    seq = []
    for f in fichiers:
        lignes = Path(f).read_text(encoding="utf-8", errors="ignore").split("\n")
        pile = []
        for i, l in enumerate(lignes, 1):
            s = l.strip()
            if not s or s.startswith("--"):
                continue
            ind = len(l) - len(l.lstrip())
            # boucle multi-lignes uniquement (une boucle inline ne seque rien)
            if re.search(r"\bfor\b.*\bdo\b", s) and not re.search(r"\bend\b", s):
                pile.append([ind, False])
            elif re.match(r"^(end|until)\b", s) and pile and ind <= pile[-1][0]:
                pile.pop()
            if pile and "BranchCoroutine" in s:
                pile[-1][1] = True
            if pile and not pile[-1][1]:
                for b in bloquantes:
                    if b + "(" in s:
                        rel = f.replace(str(ROOT) + "/", "").replace("Data/Script/halcyon/", "")
                        seq.append((rel, i, b, s))
    if seq:
        print(f"### APPEL BLOQUANT DANS UNE BOUCLE : {len(seq)}")
        print("    (les personnages jouent chacun leur tour au lieu d'ensemble)")
        for f, i, b, s in seq:
            print(f"  {f}:{i}  {b}()")
            print(f"      {s[:100]}")
        print()

    print(f"  formes valides  : {refs} reference(s) de fonction")
    print(f"  en commentaire  : {commentes} (inertes)")

    total = len(appels_immediats) + len(listes) + len(seq)
    print("\n" + "=" * 78)
    if total:
        print(f" {total} DEFAUT(S) — cinematique interrompue a l'execution")
    else:
        print(" AUCUN DEFAUT DE COROUTINE")
    print("=" * 78)
    return 1 if total else 0


if __name__ == "__main__":
    sys.exit(main())
