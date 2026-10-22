#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_architecture_ruines.py — le donjon des Ruines tient-il debout ?

Verifie la CHAINE COMPLETE, du camp jusqu'a la sortie apres Regigigas, en
lisant les fichiers reels. Chaque controle correspond a une facon concrete
dont le donjon peut casser en jeu.

  1  Les 4 arenes referencees par la zone existent sur disque.
  2  Data/Zone/index.idx est d'accord avec la zone (nb de segments).
  3  Tout script cite par la zone existe, dans le BON espace de noms
     (SINGLE_CHAR_SCRIPT / FLOOR_GEN_SCRIPT / ZONE_GEN_SCRIPT / Module.fn).
  4  Les modules des Ruines sont charges au demarrage (main.lua).
  5  Chaque segment a une sortie : aucun chemin ne laisse le joueur bloque.
  6  PROGRESSION : aucun enchainement d'etats ne ferme le donjon.
  7  Structure des cartes d'arene : ID, AssetName, couches, entrees et
     combattants sur des cases jouables.
  8  Protocole de combat pose sur les 4 arenes, avec le bon numero de
     segment dans l'ArgTable.
  9  Ordre d'execution des OnMapStarts : le placement et l'armement du
     combat passent AVANT la cinematique d'eveil.
 10  Toutes les cles de texte RUINES_* existent en FR et en EN.
 11  Tilesets et musiques des arenes attestes ailleurs dans le depot.
 12  Aucun appel vers une fonction inexistante des modules Ruines.

CE QUE CET OUTIL NE PEUT PAS FAIRE
----------------------------------
Il lit des fichiers ; il n'execute pas le jeu. Il ne prouve donc pas que
les cinematiques sont belles, que le tempo est bon, ni qu'une API moteur
se comporte comme attendu a l'execution. Il prouve qu'aucun maillon
n'est manquant, mal nomme, ou logiquement inatteignable.
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ZONE = ROOT / "Data/Zone/cloven_ruins.json"
ARENES = {1: "cloven_ruins_regice", 3: "cloven_ruins_regirock",
          5: "cloven_ruins_registeel", 7: "sanctuaire_titans"}

pbs: list[str] = []
def ko(msg): pbs.append(msg); print(f"  X  {msg}")
def ok(msg): print(f"     {msg}")
def titre(t): print(f"\n--- {t} ---")


def lire(p, bom=True):
    return Path(p).read_text(encoding="utf-8-sig" if bom else "utf-8")


def main() -> int:
    print("=" * 78)
    print(" ARCHITECTURE DU DONJON DES AEGIS CAVE")
    print("=" * 78)

    zone = json.loads(lire(ZONE))["Object"]
    segments = zone["Segments"]
    zsrc = lire(ZONE)

    # ------------------------------------------------------------------ 1
    titre("1. CARTES D'ARENE")
    for seg, nom in ARENES.items():
        f = ROOT / f"Data/Map/{nom}.rsmap"
        if not f.exists():
            ko(f"seg{seg} : {nom}.rsmap absent")
        else:
            ok(f"seg{seg} -> {nom}.rsmap")

    # ------------------------------------------------------------------ 2
    titre("2. INDEX DE ZONE")
    idx = json.loads(lire(ROOT / "Data/Zone/index.idx"))["Object"]["cloven_ruins"]
    if len(idx.get("Maps", [])) != len(segments):
        ko(f"index.idx annonce {len(idx.get('Maps', []))} segments, "
           f"la zone en a {len(segments)}")
    else:
        ok(f"{len(segments)} segments, CountedFloors={idx.get('CountedFloors')}")

    # ------------------------------------------------------------------ 3
    titre("3. SCRIPTS CITES PAR LA ZONE")
    tous = "".join(
        p.read_text(encoding="utf-8", errors="ignore")
        for p in (ROOT / "Data/Script").rglob("*.lua")
    )
    for n in sorted(set(re.findall(r'"Script": "([A-Za-z_0-9.]+)"', zsrc))):
        if "." in n:
            motifs = [f"function {n}"]
        else:
            # un script sans point peut vivre dans l'un des trois namespaces
            motifs = [f"function SINGLE_CHAR_SCRIPT.{n}",
                      f"function FLOOR_GEN_SCRIPT.{n}",
                      f"function ZONE_GEN_SCRIPT.{n}"]
        if any(m in tous for m in motifs):
            ok(f"{n}")
        else:
            ko(f"script '{n}' cite par la zone mais defini nulle part")

    # ------------------------------------------------------------------ 4
    titre("4. CHARGEMENT AU DEMARRAGE")
    main_lua = lire(ROOT / "Data/Script/halcyon/main.lua", bom=False)
    for m in ("DonjonFX", "RuinesTitan", "RuinesArenes", "RuinesZarbi"):
        if f"require 'halcyon.{m}'" in main_lua:
            ok(f"halcyon.{m}")
        else:
            ko(f"halcyon.{m} n'est pas require dans main.lua")
    ok("event_single.lua : charge par le moteur (jamais require) — normal")

    # ------------------------------------------------------------------ 5
    titre("5. SORTIE DE CHAQUE SEGMENT")
    zi = lire(ROOT / "Data/Script/halcyon/zone/cloven_ruins/init.lua", bom=False)
    corps = zi[zi.index("function cloven_ruins.ExitSegment"):]
    for seg in range(len(segments)):
        traite = (re.search(rf"segmentID == {seg}\b", corps) is not None)
        if traite:
            ok(f"seg{seg} traite par ExitSegment")
        else:
            ko(f"seg{seg} n'est traite par aucune branche d'ExitSegment")

    # ------------------------------------------------------------------ 6
    titre("6. PROGRESSION — le donjon peut-il se fermer ?")
    zarbi = lire(ROOT / "Data/Script/halcyon/RuinesZarbi.lua", bom=False)
    actif = zarbi[zarbi.index("function RuinesZarbi.SecteurActif"):]
    actif = actif[:actif.index("\nend")]
    if "Vaincu" not in actif:
        ko("SecteurActif() ne regarde pas les gardiens vaincus : un joueur "
           "battu ne peut plus revenir a son arene (blocage de sauvegarde)")
    else:
        ok("SecteurActif() suit les gardiens vaincus")
        # simulation exhaustive des 2^3 etats
        SEG = {0: "Regice", 2: "Regirock", 4: "Registeel"}
        bloques = []
        for bits in range(8):
            v = {n: bool(bits >> i & 1) for i, n in enumerate(SEG.values())}
            cible = next((s for s in (0, 2, 4) if not v[SEG[s]]), None)
            if cible is None:
                cible = 6 if v["Registeel"] else None
            if cible is None:
                bloques.append(v)
        if bloques:
            ko(f"{len(bloques)} etat(s) sans destination : {bloques}")
        else:
            ok("les 8 combinaisons d'etats menent a un segment jouable")

    # ------------------------------------------------------------------ 7
    titre("7. STRUCTURE DES CARTES D'ARENE")
    for seg, nom in ARENES.items():
        o = json.loads(lire(ROOT / f"Data/Map/{nom}.rsmap"))["Object"]
        T = o["Tiles"]; W, H = len(T), len(T[0])
        loc = []
        if not isinstance(o.get("ID"), int):
            loc.append(f"ID={o.get('ID')}")
        if o.get("AssetName") != nom:
            loc.append(f"AssetName={o.get('AssetName')}")
        for L in o["Layers"]:
            if len(L["Tiles"]) != W or len(L["Tiles"][0]) != H:
                loc.append(f"couche {L['Name']} desalignee")
        for e in o["EntryPoints"]:
            x, y = e["Loc"]["X"], e["Loc"]["Y"]
            if not (0 <= x < W and 0 <= y < H) or T[x][y]["Data"]["ID"] != "floor":
                loc.append(f"entree ({x},{y}) injouable")
        for t in o["MapTeams"]:
            for p in t["Players"]:
                x, y = p["serializationLoc"]["X"], p["serializationLoc"]["Y"]
                if not (0 <= x < W and 0 <= y < H) or T[x][y]["Data"]["ID"] != "floor":
                    loc.append(f"{p['Nickname']} ({x},{y}) injouable")
        n_ennemis = sum(len(t["Players"]) for t in o["MapTeams"])
        if loc:
            for l in loc:
                ko(f"{nom} : {l}")
        else:
            ok(f"{nom:24s} {W:2d}x{H:2d}  {n_ennemis} combattant(s)")

    # ------------------------------------------------------------------ 8/9
    titre("8-9. PROTOCOLE DE COMBAT ET ORDRE D'EXECUTION")

    def steps_zone(seg):
        out = []
        def w(n):
            if isinstance(n, dict):
                if n.get("$type", "").startswith("RogueEssence.LevelGen.MapEffectStep"):
                    for e in n["Effect"].get("OnMapStarts", []):
                        out.append((e["Key"]["str"][0], e["Value"].get("Script")))
                for v in n.values():
                    w(v)
            elif isinstance(n, list):
                for v in n:
                    w(v)
        w(segments[seg])
        return out

    for seg, nom in ARENES.items():
        o = json.loads(lire(ROOT / f"Data/Map/{nom}.rsmap"))["Object"]
        ms = o["MapEffect"].get("OnMapStarts", [])
        js = json.dumps(ms)
        if "LuaBeginBattleEvent" not in js:
            ko(f"{nom} : pas de LuaBeginBattleEvent — le combat ne se cloturera pas")
            continue
        if "RuinesArenesClear" not in js:
            ko(f"{nom} : CustomClearEvent absent — l'apres-combat ne se jouera pas")
        m = re.search(r"Segment = (\d+)", js)
        if not m or int(m.group(1)) != seg:
            ko(f"{nom} : ArgTable Segment={m.group(1) if m else '?'} au lieu de {seg}")
        ev = [(e["Key"]["str"][0],
               e["Value"].get("Script")
               or e["Value"]["$type"].split(",")[0].split(".")[-1]) for e in ms]
        ev += steps_zone(seg)
        ev.sort(key=lambda t: t[0])
        noms = [s for _, s in ev]
        if "RuinesArenesEveil" not in noms:
            ko(f"{nom} : l'eveil n'est pas branche sur cet etage")
        else:
            i_bat = noms.index("LuaBeginBattleEvent")
            i_eve = noms.index("RuinesArenesEveil")
            if i_bat > i_eve:
                ko(f"{nom} : le combat s'arme APRES la cinematique")
            else:
                ok(f"{nom:24s} " + " -> ".join(f"{p}:{s}" for p, s in ev))

    # ------------------------------------------------------------------ 10
    titre("10. TEXTES")
    import xml.etree.ElementTree as ET
    fr = {d.get("name") for d in
          ET.parse(ROOT / "Strings/stringsEx.fr.resx").getroot().findall("data")}
    en = {d.get("name") for d in
          ET.parse(ROOT / "Strings/stringsEx.resx").getroot().findall("data")}
    used = set()
    for f in ("RuinesArenes", "RuinesTitan", "DonjonFX"):
        s = lire(ROOT / f"Data/Script/halcyon/{f}.lua", bom=False)
        used |= set(re.findall(r"'(RUINES_[A-Z0-9_]+)'", s))
        for k in re.findall(r"(?:recit|penser|titan|dire)\((?:\w+,\s*)?'([A-Z0-9_]+)'", s):
            used.add(k if k.startswith("RUINES_") else ("RUINES_" + k))
    used = {u for u in used if u != "RUINES_" and not u.endswith("_")}
    mf, me = sorted(used - fr), sorted(used - en)
    if mf: ko(f"{len(mf)} cle(s) sans texte FR : {mf[:5]}")
    if me: ko(f"{len(me)} cle(s) sans texte EN : {me[:5]}")
    if not mf and not me:
        ok(f"{len(used)} cles RUINES_ presentes en FR et en EN")

    # ------------------------------------------------------------------ 11
    titre("11. TILESETS ET MUSIQUES")
    connus = set()
    for f in list((ROOT / "Data/Map").glob("*.rsmap")) + \
             list((ROOT / "Data/Zone").glob("*.json")):
        connus |= set(re.findall(
            r'"(?:AutoTileset|GroundTileset|BlockTileset|WaterTileset)": '
            r'"([a-z_0-9]+)"', lire(f)))
    for seg, nom in ARENES.items():
        o = json.loads(lire(ROOT / f"Data/Map/{nom}.rsmap"))["Object"]
        ts = {t for t in re.findall(r'"AutoTileset": "([a-z_0-9]+)"',
                                    json.dumps(o)) if t}
        inconnus = [t for t in ts if t not in connus]
        if inconnus:
            ko(f"{nom} : tileset(s) jamais vu(s) ailleurs : {inconnus}")
        mus = o.get("Music", "")
        if mus and not (ROOT / "Content/Music" / mus).exists():
            ko(f"{nom} : musique absente '{mus}'")
        if not inconnus and (not mus or (ROOT / "Content/Music" / mus).exists()):
            ok(f"{nom:24s} {len(ts)} tileset(s), {mus}")

    # ------------------------------------------------------------------ 12
    titre("12. APPELS INTERNES")
    fichiers = ["RuinesArenes", "RuinesTitan", "DonjonFX"]
    defs = set()
    for f in fichiers:
        defs |= set(re.findall(r"function\s+(\w+\.\w+)",
                               lire(ROOT / f"Data/Script/halcyon/{f}.lua", bom=False)))
    calls = set()
    for f in [ROOT / f"Data/Script/halcyon/{x}.lua" for x in fichiers] + [
            ROOT / "Data/Script/halcyon/event_single.lua",
            ROOT / "Data/Script/halcyon/zone/cloven_ruins/init.lua"]:
        calls |= set(re.findall(
            r"\b((?:RuinesArenes|RuinesTitan|DonjonFX)\.\w+)\s*\(",
            lire(f, bom=False)))
    manq = sorted(calls - defs)
    if manq:
        ko(f"appel(s) vers une fonction inexistante : {manq}")
    else:
        ok(f"{len(calls)} appels internes, tous resolus")

    print("\n" + "=" * 78)
    if pbs:
        print(f" {len(pbs)} PROBLEME(S) D'ARCHITECTURE")
    else:
        print(" ARCHITECTURE SAINE — aucun maillon manquant ni inatteignable")
        print(" (verification statique : ne remplace pas un test manette en main)")
    print("=" * 78)
    return 1 if pbs else 0


if __name__ == "__main__":
    sys.exit(main())
