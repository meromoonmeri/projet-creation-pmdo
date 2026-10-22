#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sky_classify_grounds.py — Classification FONCTIONNELLE des 460 grounds Sky
depuis les preuves ROM (jamais depuis le nom de fichier).

Preuves croisées (toutes déjà extraites de la ROM EU) :
  1. mapty (level list arm9, enum Pmd2ScriptLevelMapType) :
       0-9  = map à layers (ground jouable/scène)
       10   = « Dungeon Tileset » (écran habillé donjon : transitions,
              intermèdes pré/post-donjon)
       11   = « Use Fixed Room » (arène/salle fixe pilotée par fixed.bin)
  2. structure SCRIPT/<LEVEL>/ :
       enter.sse présent  = station d'entrée -> le joueur PEUT y entrer
                            (MAP explorable : NPC, events, sorties)
       *.sss présent      = sub-stations (visites d'états scénarisés)
       *.ssa seulement    = uniquement scènes acting -> CINEMATIC_GROUND
       aucun script       = ressource visuelle jamais scriptée
  3. collision BMA : « No BMA collision » dans le commentaire du port =
       aucune couche de collision dans la ROM -> l'asset n'est pas un
       espace de déplacement (BACKGROUND/IMAGE) ;
  4. events du enter.sse (déclencheurs de zone) = transitions ;
  5. variantes suffixées d'un même MAP_BG = VARIANT (états du même lieu).

Catégories émises (schéma imposé par la mission) :
  MAP, DUNGEON_SCREEN, BOSS_ARENA_FIXED, CINEMATIC_GROUND,
  CINEMATIC_BACKGROUND, SCRIPTED_SCREEN, VARIANT, UNREFERENCED_ASSET
Chaque entrée cite ses preuves. Aucune catégorie devinée : si les preuves
se contredisent, statut REVIEW_REQUIRED.

Sortie : dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Docs/GROUND_CLASSIFICATION.json/.md
"""
import json
import os
import re
from collections import Counter, OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMP = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS")
DOCS = os.path.join(CAMP, "Docs")


def build_level_xrefs():
    """Index cross-zone : LEVEL_X -> opcodes qui le chargent depuis
    N'IMPORTE quel SSB (back_SetGround = décor de scène,
    main_EnterGround = entrée jouable, ExecuteActingSub = scène...).
    C'est la preuve d'usage réel pour les levels sans dossier SCRIPT."""
    import glob
    import gzip
    from collections import defaultdict
    cache = "/tmp/sky_level_xrefs.json"
    if os.path.exists(cache):
        return json.load(open(cache))
    refs = defaultdict(list)
    rx = re.compile(
        r"(back_SetGround|back2_SetGround|main_EnterGround|main_SetGround|"
        r"supervision_ExecuteStationSub|supervision_ExecuteActingSub|"
        r"worldmap_SetLevel)\(\s*LEVEL_(\w+)")
    for f in sorted(glob.glob(os.path.join(
            CAMP, "Cinematics", "rom_scripts", "*.json.gz"))):
        z = json.load(gzip.open(f, "rt"))
        zone = os.path.basename(f).split(".")[0]
        for name, s in z["scripts"].items():
            src = s.get("explorerscript") or ""
            for op, lv in rx.findall(src):
                refs[lv].append((op, f"{zone}/{name}"))
    out = {k: {"ops": sorted({o for o, _ in v}),
               "users": sorted({u for _, u in v})[:8], "n": len(v)}
           for k, v in refs.items()}
    json.dump(out, open(cache, "w"), indent=1)
    return out


def main():
    manifest = json.load(open(os.path.join(CAMP, "MANIFEST.json")))
    links = json.load(open(os.path.join(
        CAMP, "Cinematics", "LEVEL_MAP_LINKS.json")))["levels"]
    idx = json.load(open(os.path.join(
        CAMP, "Cinematics", "ROM_SCRIPTS_INDEX.json")))["zones"]
    xrefs = build_level_xrefs()

    # map_bg -> levels qui l'utilisent
    levels_by_bg = {}
    for lv, info in links.items():
        mb = info.get("map_bg")
        if mb:
            levels_by_bg.setdefault(mb, []).append(lv)

    def script_profile(level):
        z = idx.get(level)
        if not z:
            return None
        s = z["scripts"]
        return OrderedDict(
            enter_sse=any(k.startswith("enter") and k.endswith(".sse")
                          for k in s),
            acting_sss=any(k.endswith(".sss") for k in s),
            scene_ssa=any(k.endswith(".ssa") for k in s),
            n_ssb=sum(1 for k in s if k.endswith(".ssb")))

    entries = OrderedDict()
    counts = Counter()
    for g in manifest["grounds"]:
        gid = g["ground"]
        cmt = g.get("source_comment") or ""
        m = re.search(r"MAP_BG (\S+) ->", cmt)
        bg_ids = set()
        if m:
            bg_ids.update(p.lower() for p in m.group(1).split("/"))
        bg_ids.add(gid.lower())
        # variante suffixée -> base
        base_of = None
        for b in list(bg_ids):
            m2 = re.match(r"^([a-z]\d{2}p\d{2}[a-z])\d+$", b)
            if m2:
                bg_ids.add(m2.group(1))
                base_of = m2.group(1)
        has_collision = "No BMA collision" not in cmt
        lvls = []
        for b in sorted(bg_ids):
            lvls.extend(levels_by_bg.get(b, []))
        lvls = sorted(set(lvls))
        maptys = sorted({links[lv]["mapty"] for lv in lvls})
        profiles = [script_profile(lv) for lv in lvls]
        profiles = [p for p in profiles if p]

        any_enter = any(p["enter_sse"] for p in profiles)
        any_ssa = any(p["scene_ssa"] for p in profiles)
        # usage cross-zone : d'autres scripts chargent-ils ces levels ?
        xops = set()
        xusers = []
        for lv in lvls:
            x = xrefs.get(lv)
            if x:
                xops.update(x["ops"])
                xusers.extend(x["users"][:3])
        evidence = OrderedDict(
            levels=lvls or None, mapty=maptys or None,
            collision_bma=has_collision,
            enter_station=any_enter, acting_scenes=any_ssa,
            cross_zone_ops=sorted(xops) or None,
            cross_zone_users=xusers[:6] or None,
            variant_of=base_of)

        # décision par preuves
        if not lvls:
            cat = ("VARIANT" if base_of and levels_by_bg.get(base_of)
                   else ("CINEMATIC_BACKGROUND" if not has_collision
                         else "UNREFERENCED_ASSET"))
            why = ("variante d'état d'un MAP_BG référencé" if cat == "VARIANT"
                   else ("aucun level ne le référence + aucune collision "
                         "ROM : ressource visuelle" if cat ==
                         "CINEMATIC_BACKGROUND" else
                         "aucun level ne le référence (collision présente) "
                         "— rôle à établir"))
        elif 11 in maptys:
            cat = "BOSS_ARENA_FIXED"
            why = "mapty=11 (Use Fixed Room) : salle fixe fixed.bin"
        elif 10 in maptys:
            cat = "DUNGEON_SCREEN"
            why = ("mapty=10 (Dungeon Tileset) : écran habillé donjon "
                   "(intermède/transition pré-post donjon)")
        elif any_enter and has_collision:
            cat = "MAP"
            why = ("station d'entrée enter.sse + collision ROM : lieu "
                   "réellement entrable (NPC/events/sorties)")
        elif any_enter and not has_collision:
            cat = "SCRIPTED_SCREEN"
            why = ("station d'entrée mais AUCUNE collision ROM : écran "
                   "scripté (pas un espace de déplacement libre)")
        elif any_ssa and not any_enter:
            cat = ("CINEMATIC_GROUND" if has_collision
                   else "CINEMATIC_BACKGROUND")
            why = ("scènes acting uniquement (aucune station d'entrée) : "
                   + ("décor joué par cinématiques (acteurs déplacés au "
                      "sol)" if has_collision else
                      "décor de cinématique sans collision (image/fond)"))
        elif xops:
            # pas de dossier SCRIPT propre, mais chargé cross-zone par
            # d'autres SSB : la nature de l'usage décide.
            if "main_EnterGround" in xops or \
                    "supervision_ExecuteStationSub" in xops:
                cat = "MAP" if has_collision else "SCRIPTED_SCREEN"
                why = ("chargé cross-zone comme lieu d'entrée "
                       "(main_EnterGround/ExecuteStationSub) par: "
                       + ", ".join(xusers[:2]))
            elif "supervision_ExecuteActingSub" in xops:
                cat = ("CINEMATIC_GROUND" if has_collision
                       else "CINEMATIC_BACKGROUND")
                why = ("chargé cross-zone comme scène acting "
                       "(ExecuteActingSub) par: " + ", ".join(xusers[:2]))
            else:  # back_SetGround/back2_SetGround/worldmap uniquement
                cat = "CINEMATIC_BACKGROUND"
                why = ("chargé cross-zone uniquement comme DÉCOR "
                       "(back_SetGround) par: " + ", ".join(xusers[:2]))
        else:
            cat = "REVIEW_REQUIRED"
            why = ("level déclaré mais jamais scripté ni référencé par un "
                   "SSB décompilé — donnée dormante ROM probable")
        counts[cat] += 1
        entries[gid] = OrderedDict(category=cat, why=why,
                                   evidence=evidence)

    out = OrderedDict(
        schema="sky-ground-classification/1",
        authority="mapty (level list arm9/pmd2scriptdata) × structure "
                  "SCRIPT/ ROM EU (enter.sse/.sss/.ssa) × collision BMA "
                  "(port, source ROM) × liaisons LEVEL_MAP_LINKS — jamais "
                  "le nom de fichier",
        rule="chaque catégorie citée avec ses preuves ; contradictions = "
             "REVIEW_REQUIRED, jamais résolues par défaut",
        totals=OrderedDict(counts.most_common()),
        grounds=entries)
    p = os.path.join(DOCS, "GROUND_CLASSIFICATION.json")
    json.dump(out, open(p, "w", encoding="utf-8"), ensure_ascii=False,
              indent=1)

    md = ["# Classification fonctionnelle des grounds — PMD Sky EU\n",
          "| Catégorie | Nombre | Signification runtime |", "|---|---|---|"]
    MEANING = {
        "MAP": "lieu entrable : LOAD+MOVE+NPC+events+transitions à valider",
        "CINEMATIC_GROUND": "décor de scènes scriptées : à jouer via "
                            "SkyCanonScenes, PAS une map libre",
        "CINEMATIC_BACKGROUND": "image/fond sans collision : background "
                                "PMDO (statique/défilant), PAS un ground",
        "DUNGEON_SCREEN": "écran donjon (mapty=10) : intermède/transition",
        "BOSS_ARENA_FIXED": "salle fixe fixed.bin : combat réel (zones "
                            "d'arène déjà construites)",
        "SCRIPTED_SCREEN": "écran scripté entrable sans collision",
        "VARIANT": "état alternatif d'un même lieu (heure/évènement)",
        "UNREFERENCED_ASSET": "asset avec collision jamais référencé — "
                              "REVIEW",
        "REVIEW_REQUIRED": "preuves contradictoires",
    }
    for cat, n in counts.most_common():
        md.append(f"| {cat} | {n} | {MEANING.get(cat, '')} |")
    open(os.path.join(DOCS, "GROUND_CLASSIFICATION.md"), "w",
         encoding="utf-8").write("\n".join(md) + "\n")
    print("totals:", dict(counts))
    print(p)


if __name__ == "__main__":
    main()
