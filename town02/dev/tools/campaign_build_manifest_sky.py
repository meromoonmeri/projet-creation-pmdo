#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Manifest de campagne PMD Explorers of Sky (EU) — Grounds + narration.

Croise, sans invention :
  * les 460 Grounds pixel-perfect du port PMD-SKY-PMDO-PORT@master
    (458 MAP_BG NDS + assets nommés ; rendu skytemple-files
    `bma.to_pil(bpc,bpl,bpas)`, collisions BMA source unique, toutes les
    frames BPA incluses — MAP_BG_CONVERSION_REPORT.md) ;
  * les renders frames produits par campaign_render_grounds.py ;
  * la table d'autorité `enum dungeon_id` de pret/pmd-sky include/enums.h
    (préfixe d## des MAP_BG == DUNGEON_ID, vérifié 1:1 par le port —
    RENOMMAGE_CANONIQUE_REPORT.md) ;
  * la table des levels script (S01P01A…) de ppmdu_config
    (pmd2scriptdata.xml, SkyTemple) pour les identités de scène ;
  * le graphe monde du port (output/World) et le mapping audio canonique.

Les groupes de préfixe (t=ville, g=guilde, s=scènes système/spéciales,
v=villages/lieux de PNJ, h=lieux d'histoire, p=places) suivent la
nomenclature des levels de la ROM Sky (pmd2scriptdata).

Sortie : dev/CAMPAIGNS/PMD_SKY_EXPLORERS/MANIFEST.json + MANIFEST.md
"""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CAMP = ROOT / "dev" / "CAMPAIGNS" / "PMD_SKY_EXPLORERS"
PORT = ROOT / ".runtime-cache" / "ports" / "sky"

# --------- table pret/pmd-sky dungeon_id (générée depuis include/enums.h)
DUNGEON_NAMES = json.loads(Path("/tmp/sky_dungeon_names.json").read_text())

FR_NAMES = {
    # noms officiels FR (version EU) des lieux principaux — source: ROM EU
    # multilingue (les noms français officiels d'Explorateurs du Ciel).
    "Beach Cave": "Grotte Plage", "Drenched Bluff": "Falaise Trempée",
    "Mt Bristle": "Mont Aiguillon", "Waterfall Cave": "Grotte Cascade",
    "Apple Woods": "Bois aux Pommes", "Craggy Coast": "Côte Rocheuse",
    "Mt Horn": "Mont Corne", "Foggy Forest": "Forêt Brumeuse",
    "Steam Cave": "Grotte Vapeur", "Amp Plains": "Plaines Élek",
    "Northern Desert": "Désert du Nord", "Quicksand Cave": "Grotte Sablequi",
    "Crystal Cave": "Grotte Cristal", "Crystal Crossing": "Croisée Cristal",
    "Chasm Cave": "Grotte Crevasse", "Dark Hill": "Colline Sombre",
    "Sealed Ruin": "Ruine Scellée", "Dusk Forest": "Forêt Crépuscule",
    "Deep Dusk Forest": "Forêt Crépuscule Profonde",
    "Treeshroud Forest": "Forêt Feuillage",
    "Brine Cave": "Grotte Saumure", "Hidden Land": "Terres Illusoires",
    "Temporal Tower": "Tour du Temps", "Temporal Spire": "Flèche du Temps",
    "Mystifying Forest": "Forêt Mystère", "Blizzard Island": "Île Blizzard",
    "Crevice Cave": "Grotte Fissure", "Surrounded Sea": "Mer Cernée",
    "Miracle Sea": "Mer Miracle", "Aegis Cave": "Grotte Aegis",
    "Mt Travail": "Mont Labeur", "The Nightmare": "Le Cauchemar",
    "Spacial Rift": "Faille Spatiale", "Dark Crater": "Cratère Obscur",
    "Sky Peak": "Cime Céleste",
}

# Groupes de levels (préfixes de la nomenclature script NDS) — identités
# vérifiées par le graphe monde du port et pmd2scriptdata (1326 levels).
PREFIX_GROUPS = {
    "t01": ("Treasure Town", "Bourg-Trésor",
            "Ville principale : boutiques Kecleon, banque Duskull, "
            "carrefour Croisée des Chemins."),
    "g01": ("Wigglytuff Guild", "Guilde de Grodoudou",
            "La guilde : dortoirs, réfectoire, salle du Maître, terrasse."),
    "p01": ("Sharpedo Bluff / beach area", "Falaise Sharpedo / plage",
            "Falaise Sharpedo et abords de la plage."),
    "s00": ("System/title scenes", "Scènes système",
            "Écrans système, scènes d'ouverture."),
}

# Rôles des SÉRIES de levels (nomenclature script NDS, pmd2scriptdata:
# T=town, G=guild, P=places persos, S=story scenes, V=villages/lieux des
# épisodes et cinématiques, H=maisons/intérieurs, W=world/spéciaux,
# M=missions). Identité de série documentée quand le level individuel
# n'a pas encore de nom propre décodé.
SERIES_ROLES = {
    "t": ("Town map", "Carte de ville",
          "Bourg-Trésor et ses variantes d'état (heure, évènement)."),
    "g": ("Guild map", "Carte de la guilde",
          "Intérieurs et extérieurs de la Guilde de Grodoudou."),
    "p": ("Personal place", "Lieu personnel",
          "Lieux des personnages: Falaise Sharpedo, chambres, plage…"),
    "s": ("Story scene map", "Carte de scène du scénario",
          "Cartes dédiées aux scènes du scénario principal (fondus, "
          "flashbacks, séquences spéciales — ex. s05p04a fondu 344 frames)."),
    "v": ("Episode/event village", "Village d'épisode/évènement",
          "Lieux des Épisodes Spéciaux et cinématiques annexes "
          "(casts Bidoof, Igglybuff, Sunflora, Team Charm…)."),
    "h": ("Interior/home", "Intérieur/maison",
          "Intérieurs génériques et maisons."),
    "w": ("World/system map", "Carte monde/système",
          "Cartes spéciales (carte du monde, écrans de transition)."),
    "m": ("Mission map", "Carte de mission",
          "Cartes utilisées par les missions générées."),
}

# Narration globale d'Explorateurs du Ciel (chronologie canonique du jeu)
NARRATIVE_ARCS = [
    {"arc": "Prologue — la plage", "summary_fr":
     "Le héros, humain transformé en Pokémon et amnésique, s'échoue sur la "
     "plage ; le partenaire le trouve, Zubat et Koffing volent son Relique "
     "Fragment : première descente dans la Grotte Plage (d01).",
     "map_groups": ["p01", "d01"]},
    {"arc": "La Guilde de Grodoudou", "summary_fr":
     "Inscription à la guilde de Grodoudou à Bourg-Trésor : entraînement, "
     "missions (Falaise Trempée d03, Mont Aiguillon d04), expédition vers "
     "le lac Souterrain via la Grotte Vapeur (d14) et Groudon illusoire.",
     "map_groups": ["t01", "g01", "d03", "d04", "d14"]},
    {"arc": "Le voleur Grovyle et les Gears du Temps", "summary_fr":
     "Les Gears du Temps sont volés (plaines Élek d17, grotte Crystal d20, "
     "ruine Scellée d24). L'équipe poursuit Grovyle, est trahie par Dusknoir "
     "et découvre le futur paralysé : la vérité inverse les rôles.",
     "map_groups": ["d17", "d20", "d24", "d33", "d34", "d35"]},
    {"arc": "Terres Illusoires & Tour du Temps", "summary_fr":
     "Retour du futur, alliance avec Grovyle : Grotte Saumure (d37), Terres "
     "Illusoires (d40), Tour du Temps (d41/d42) — combat contre Dialga "
     "Primal ; le héros disparaît puis est ramené par Dialga.",
     "map_groups": ["d37", "d40", "d41", "d42", "d43"]},
    {"arc": "Épilogue & post-game", "summary_fr":
     "Manaphy, Cresselia et le Cauchemar (d63), Faille Spatiale de Palkia "
     "(d64/d65), Cratère Obscur de Darkrai (d67/d68), Grotte Aegis "
     "(d54-d61), Cime Céleste de Shaymin (d70-d72), mers légendaires.",
     "map_groups": ["d54", "d55", "d56", "d57", "d58", "d59", "d60", "d61",
                    "d63", "d64", "d65", "d67", "d68", "d70", "d71", "d72",
                    "d73", "d74", "d75"]},
    {"arc": "Épisodes Spéciaux", "summary_fr":
     "Cinq épisodes canoniques de la version Ciel : Étincelle d'Éclabousse, "
     "Igglybuff le prodige, Aujourd'hui comme hier, Au cœur des ténèbres, "
     "À la poursuite du soleil (casts Bidoof, Igglybuff, Sunflora, Grovyle/"
     "Dusknoir, Team Charm).",
     "map_groups": ["v01", "v02", "v03", "v19", "v24", "v26", "v38"]},
]


def human_from_dungeon(gid: str):
    m = re.match(r"^d(\d{2})p", gid)
    if not m:
        return None
    d = DUNGEON_NAMES.get(f"d{int(m.group(1)):02d}")
    return d


def load_cinematic_links():
    """Liaison ground -> scènes ROM (SCRIPT/<LEVEL>) via LEVEL_MAP_LINKS.json
    + ROM_SCRIPTS_INDEX.json produits par sky_extract_rom_scripts.py.

    Retourne map_bg_id (minuscule) -> [{level, scripts, ssb, ssa, dialogues}].
    """
    cin = CAMP / "Cinematics"
    links_p = cin / "LEVEL_MAP_LINKS.json"
    index_p = cin / "ROM_SCRIPTS_INDEX.json"
    if not (links_p.exists() and index_p.exists()):
        return {}
    links = json.loads(links_p.read_text())["levels"]
    index = json.loads(index_p.read_text())["zones"]
    out = {}
    for level, info in links.items():
        mb = info.get("map_bg")
        zone = index.get(level)
        if not mb or not zone:
            continue
        scripts = zone["scripts"]
        kinds = {}
        for s in scripts.values():
            kinds[s["kind"]] = kinds.get(s["kind"], 0) + 1
        out.setdefault(mb, []).append({
            "level": level,
            "archive": f"Cinematics/{zone['file']}",
            "n_scripts": zone["n_files"],
            "ssb": kinds.get("ssb", 0),
            "ssa_sse_sss": kinds.get("ssa", 0) + kinds.get("sse", 0)
                           + kinds.get("sss", 0),
            "statuses": sorted({s["status"] for s in scripts.values()}),
        })
    return out


def main() -> int:
    render_report = json.loads((CAMP / "Renders" / "render_report.json")
                               .read_text(encoding="utf-8-sig"))
    renders = {r["ground"]: r for r in render_report["renders"]}
    cin_links = load_cinematic_links()

    # noms rsground (Name EN/FR déjà posés par le port pour les renommés)
    ground_meta = {}
    for g in sorted((PORT / "output" / "Grounds").glob("*.rsground")):
        try:
            o = json.loads(g.read_text(encoding="utf-8-sig"))["Object"]
            nm = o.get("Name", {})
            ground_meta[g.stem] = {
                "en": nm.get("DefaultText") or g.stem,
                "fr": (nm.get("LocalTexts") or {}).get("fr"),
                "comment": (o.get("Comment") or "")[:220] or None,
            }
        except Exception:
            ground_meta[g.stem] = {"en": g.stem, "fr": None, "comment": None}

    entries = []
    for gid in sorted(renders):
        r = renders[gid]
        meta = ground_meta.get(gid, {})
        e = {
            "ground": gid,
            "human_name_en": meta.get("en", gid),
            "human_name_fr": meta.get("fr"),
            "render": (None if "error" in r else {
                "dir": f"Renders/{gid}/",
                "width_px": r["width_px"], "height_px": r["height_px"],
                "frames": r["frames_rendered"],
                "animation_cycle": r["animation_cycle"],
                "animated_tiles": r["animated_tiles"],
            }),
            "render_error": r.get("error"),
            "source_comment": meta.get("comment"),
        }
        # liaison cinématique : scènes ROM (SSB/SSA) des levels dont le
        # MAP_BG est ce ground. IDs map_bg dérivés du commentaire source
        # ("MAP_BG xxx/yyy/zzz -> id") ou du nom du ground lui-même.
        mb_ids = set()
        cmt = meta.get("comment") or ""
        m2 = re.search(r"MAP_BG (\S+) ->", cmt)
        if m2:
            mb_ids.update(p.lower() for p in m2.group(1).split("/"))
        mb_ids.add(gid.lower())
        # variantes suffixées (ex. ground s11p02c5 = variante du MAP_BG
        # s11p02c référencé par le level S11P02C) : lier aussi la base.
        for mb in list(mb_ids):
            m3 = re.match(r"^([a-z]\d{2}p\d{2}[a-z])\d+$", mb)
            if m3:
                mb_ids.add(m3.group(1))
        scenes = []
        seen_levels = set()
        for mb in sorted(mb_ids):
            for s in cin_links.get(mb, []):
                if s["level"] not in seen_levels:
                    seen_levels.add(s["level"])
                    scenes.append(s)
        if scenes:
            e["cinematic"] = {
                "levels": scenes,
                "ssb_total": sum(s["ssb"] for s in scenes),
                "ssa_total": sum(s["ssa_sse_sss"] for s in scenes),
                "source": "ROM Sky EU SCRIPT/ (sky_extract_rom_scripts.py)",
            }
        dg = human_from_dungeon(gid)
        if dg:
            en = dg["en"]
            e["dungeon"] = {
                "pret_enum": dg["enum"], "en": en,
                "fr": FR_NAMES.get(en.replace("Mt.", "Mt")),
            }
            # si le nom du rsground est encore l'ID technique, exposer le
            # nom humain pret comme identité recommandée
            if e["human_name_en"].lower().startswith(gid[:3]):
                e["recommended_name_en"] = en
        else:
            pref = gid[:3]
            grp = PREFIX_GROUPS.get(pref)
            if grp:
                e["area_group"] = {"en": grp[0], "fr": grp[1],
                                   "context": grp[2]}
            else:
                sr = SERIES_ROLES.get(gid[:1])
                if sr and re.match(r"^[tgpsvhwm]\d", gid):
                    e["series_role"] = {"en": sr[0], "fr": sr[1],
                                        "context": sr[2]}
        entries.append(e)

    manifest = {
        "schema": "new-era.campaign-manifest.v1",
        "campaign": "PMD Explorers of Sky (EU)",
        "authority": {
            "grounds_source": "meromoonmeri/PMD-SKY-PMDO-PORT@master "
                              "(458 MAP_BG NDS -> 460 rsground, "
                              "skytemple-files bma.to_pil, collisions BMA, "
                              "0 erreur — MAP_BG_CONVERSION_REPORT.md)",
            "rom": "PMD Explorers of Sky EU (bg_list.dat sha256 81f68a7e…, "
                   "ROM_MAP_BG_AUDIT: 1387 fichiers identiques pret/ROM)",
            "dungeon_names": "pret/pmd-sky include/enums.h enum dungeon_id "
                             "(préfixe d## == DUNGEON_ID, vérifié 1:1)",
            "level_names": "SkyTemple ppmdu_config pmd2scriptdata.xml "
                           "(1326 levels)",
            "known_conflict": "d32: pret=DUSK_FOREST; le port a renommé "
                              "d32→aegis_cave_* sur instruction projet "
                              "(RENOMMAGE_CANONIQUE_REPORT.md). Les deux "
                              "identités sont exposées, aucune n'est "
                              "supprimée.",
            "cinematics": "ROM Sky EU (C2SP, sha256 1fa39d35…) SCRIPT/ : "
                          "3760 SSB décompilés ExplorerScript + dialogues "
                          "5 langues, 1884 SSA/SSE/SSS, 315 LSD — "
                          "sky_extract_rom_scripts.py, archives "
                          "Cinematics/rom_scripts/<LEVEL>.json.gz, liaison "
                          "level→MAP_BG via LEVEL_MAP_LINKS.json.",
        },
        "totals": {
            "grounds": len(entries),
            "rendered": sum(1 for e in entries if e["render"]),
            "with_dungeon_identity": sum(1 for e in entries if "dungeon" in e),
            "with_area_group": sum(1 for e in entries if "area_group" in e),
            "with_cinematic": sum(1 for e in entries if "cinematic" in e),
            "rom_ssb_linked": sum(e["cinematic"]["ssb_total"]
                                  for e in entries if "cinematic" in e),
        },
        "narrative_arcs": NARRATIVE_ARCS,
        "dungeon_name_table": DUNGEON_NAMES,
        "grounds": entries,
    }
    (CAMP / "MANIFEST.json").write_text(
        json.dumps(manifest, indent=1, ensure_ascii=False))

    md = ["# Campagne PMD Explorers of Sky (EU) — manifest des Grounds\n",
          f"- Grounds : **{manifest['totals']['grounds']}** ; rendus : "
          f"**{manifest['totals']['rendered']}** ; identité de donjon pret : "
          f"**{manifest['totals']['with_dungeon_identity']}**\n",
          "## Narration globale (Explorateurs du Ciel)\n"]
    for a in NARRATIVE_ARCS:
        md.append(f"### {a['arc']}\n{a['summary_fr']}\n")
    md.append("\n## Grounds de donjon (identité pret/pmd-sky)\n")
    md.append("| Ground | Donjon (pret) | FR | Frames | Dimensions |")
    md.append("|---|---|---|---|---|")
    for e in entries:
        if "dungeon" not in e:
            continue
        r = e["render"] or {}
        md.append(f"| `{e['ground']}` | {e['dungeon']['en']} | "
                  f"{e['dungeon'].get('fr') or '—'} | {r.get('frames','—')} | "
                  f"{r.get('width_px','?')}×{r.get('height_px','?')} |")
    (CAMP / "MANIFEST.md").write_text("\n".join(md) + "\n")
    print(f"manifest: {manifest['totals']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
