#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_heritage.py — defauts silencieux legues par les passes precedentes.

Cible les erreurs qui ne cassent NI la syntaxe Lua, NI le chargement, mais
qui produisent en jeu un comportement faux : une emote qui n'est pas celle
voulue, un PNJ qu'on ne peut pas atteindre, une musique qui n'existe pas.
Ce sont celles que les audits classiques laissent passer.

CE QUI EST CONTROLE
-------------------
1. EMOTES DE BULLE
   GeneralFunctions.EmoteAndPause ne connait que 9 noms, et sa derniere
   branche est un `else` : tout nom inconnu retombe EN SILENCE sur
   'sweatdrop'. Une goutte de sueur la ou le script voulait de la joie ou
   de la colere. La casse compte : "notice" n'est pas "Notice".

2. PNJ INJOIGNABLES
   Une entite laissee au collider (0,0) se retrouve dans le coin haut-gauche
   de la carte, presque toujours dans un mur. Si elle porte en plus un
   handler <Nom>_Action, le joueur est cense pouvoir lui parler : le
   contenu est ecrit mais inatteignable.
   Nuance importante, verifiee avant de conclure : certaines entites sont
   VOLONTAIREMENT en (0,0) parce qu'un script les teleporte avant de les
   montrer (patron atteste : Relicanth dans altere_pond_ch_11.lua:29).
   L'outil ne signale donc que celles qui ne sont jamais deplacees.

3. MUSIQUES INEXISTANTES
   SOUND:PlayBGM sur un fichier absent de Content/Music : silence complet
   la ou une piste etait prevue.

CE QUI N'EST PAS SIGNALE, ET POURQUOI
-------------------------------------
* Les entites collees au bord bas de la carte. Le moteur ancre le
  personnage sur le COIN du collider, pas sur son centre : un collider en
  y=328 sur une carte de 336 px est legitime. Tester le centre produisait
  220 faux positifs.
* Les assets 'White', 'Rock_Pieces', 'Wave_Circle_Blue'... : ils viennent
  du pack de base, pas de Content/ du mod. Seuls les assets ajoutes par le
  mod sont verifiables ici.
"""
from __future__ import annotations

import glob
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
EMOTES_GEREES = {"Happy", "Notice", "Exclaim", "Glowing", "Sweating",
                 "Question", "Angry", "Shock", "Sweatdrop"}

pbs = 0


def section(t):
    print(f"\n--- {t} ---")


def main() -> int:
    global pbs
    print("=" * 78)
    print(" AUDIT D'HERITAGE — defauts silencieux des passes precedentes")
    print("=" * 78)

    # ---------------------------------------------------------------- 1
    section("1. EMOTES DE BULLE NON GEREES")
    bad = []
    for f in glob.glob(str(ROOT / "Data/Script/**/*.lua"), recursive=True):
        for i, l in enumerate(open(f, encoding="utf-8", errors="ignore"), 1):
            if "EmoteAndPause(" not in l or l.strip().startswith("--"):
                continue
            m = re.search(r"EmoteAndPause\([^,]+,\s*['\"]([^'\"]+)['\"]", l)
            if m and m.group(1) not in EMOTES_GEREES:
                rel = f.replace(str(ROOT) + "/", "").replace("Data/Script/halcyon/", "")
                bad.append((rel, i, m.group(1)))
    for r, i, e in bad:
        print(f"  X  {r}:{i}  '{e}' -> retombe sur 'sweatdrop'")
    pbs += len(bad)
    if not bad:
        print("     aucune : tous les appels utilisent un nom gere")

    # ---------------------------------------------------------------- 2
    section("2. PNJ INTERACTIF LAISSE EN (0,0)")
    trouves = []
    for g in sorted(glob.glob(str(ROOT / "Data/Ground/*.rsground"))):
        nom = Path(g).stem
        d = ROOT / f"Data/Script/halcyon/ground/{nom}"
        if not d.exists():
            continue
        src = "".join(p.read_text(encoding="utf-8", errors="ignore")
                      for p in d.glob("*.lua"))
        try:
            o = json.loads(Path(g).read_text(encoding="utf-8-sig"))["Object"]
        except Exception:
            continue
        for lay in o.get("Entities", []):
            for e in lay.get("MapChars", []):
                c = e.get("Collider") or {}
                n = e.get("EntName") or ""
                if not n or (c.get("X"), c.get("Y")) != (0, 0):
                    continue
                # deplace par script ? alors c'est volontaire
                if re.search(rf"TeleportTo\(\s*\w*{re.escape(n.lower())}", src, re.I):
                    continue
                if re.search(rf"CH\(['\"]{re.escape(n)}['\"]\)", src) and \
                   "TeleportTo" in src:
                    continue
                interactif = f"{n}_Action" in src or f"{n}_Touch" in src
                trouves.append((nom, n, interactif))
    reels = [t for t in trouves if t[2]]
    for nom, n, _ in reels:
        print(f"  X  {nom}/{n} : handler present mais entite dans le mur (0,0)")
    pbs += len(reels)
    decor = [t for t in trouves if not t[2]]
    if decor:
        print(f"     ({len(decor)} autre(s) en (0,0) SANS handler : "
              f"decor jamais place, non bloquant)")
    if not reels:
        print("     aucun PNJ interactif injoignable")

    # ---------------------------------------------------------------- 3
    section("3. MUSIQUES REFERENCEES MAIS ABSENTES")
    mus = {p.name for p in (ROOT / "Content/Music").glob("*")}
    badm = []
    for f in glob.glob(str(ROOT / "Data/Script/**/*.lua"), recursive=True):
        for i, l in enumerate(open(f, encoding="utf-8", errors="ignore"), 1):
            if "PlayBGM(" not in l or l.strip().startswith("--"):
                continue
            for m in re.findall(r"PlayBGM\(\s*['\"](.+?\.ogg)['\"]", l):
                # \\' est un echappement Lua valide : on le resout
                reel = m.replace("\\'", "'").replace('\\"', '"')
                if reel not in mus:
                    rel = f.replace(str(ROOT) + "/", "").replace("Data/Script/halcyon/", "")
                    badm.append((rel, i, reel))
    for r, i, m in badm:
        print(f"  X  {r}:{i}  '{m}'")
    pbs += len(badm)
    if not badm:
        print(f"     aucune : toutes presentes dans Content/Music "
              f"({len(mus)} fichiers)")

    print("\n" + "=" * 78)
    print(f" {pbs} DEFAUT(S)" if pbs else " AUCUN DEFAUT D'HERITAGE")
    print("=" * 78)
    return 1 if pbs else 0


if __name__ == "__main__":
    sys.exit(main())
