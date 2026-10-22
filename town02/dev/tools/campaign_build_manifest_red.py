#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Manifest de campagne PMD Red Rescue Team (EU) — Grounds + cinématiques + narration.

Croise, sans invention :
  * les 428 Grounds pixel-perfect du port (commit réserve 0ec8129, campagne
    219/219 validée runtime PMDO 0.8.12, mismatched_pixel_count=0) ;
  * les renders produits par campaign_render_grounds.py (frames incluses) ;
  * les cinématiques .cif.json du port (séquences extraites de la ROM :
    musiques, dialogues, animations, flashes, caméra) ;
  * le casting canonique ROM EU (dev/docs/canonical/red/scene_cast/
    eu_scene_cast.json : entités, espèces, positions pixel, directions) ;
  * MAP_DATABASE.md / CINEMATICS_DATABASE.md du port (rôles, contexte) ;
  * l'inventaire projet INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md
    (donjon <-> grounds, boss) ;
  * la table gDungeonMusic déjà auditée (musiques par donjon).

Sortie : dev/CAMPAIGNS/PMD_RED_RESCUE_TEAM/MANIFEST.json + MANIFEST.md
"""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CAMP = ROOT / "dev" / "CAMPAIGNS" / "PMD_RED_RESCUE_TEAM"
PORT = ROOT / ".runtime-cache" / "ports" / "red" / "PMDRed_PMDO_Framework"
SRC = ROOT / ".runtime-cache" / "campaigns" / "red_src"

# ---------------------------------------------------------------- autorités

# Rôle des préfixes de la table de conversion GBA (MAP_DATABASE.md du port)
PREFIX_ROLES = {
    "t0": "rescue_team_base", "t1": "town_hub",
    "a0": "story_cutscene_map", "b0": "boss_arena_legacy",
    "d0": "dungeon_ground", "d1": "dungeon_ground", "d2": "dungeon_ground",
    "h0": "friend_area", "h1": "friend_area", "h2": "friend_area",
    "h3": "friend_area",
    "s0": "system_screen",
}

# Donjon (D01-D25) -> nom humain EN/FR + boss + grounds par ID SOURCE GBA.
# La campagne n'utilise QUE les IDs de la table de conversion de la ROM
# (dXXpYY) — les noms français (foret_tendre_oree…) sont l'identité du MOD
# New Era, exposée en alias, jamais mélangée au contenu de campagne.
DUNGEONS = {
    "D01": ("Tiny Woods", "Petit Bois", None, ["d01p01", "d01p02"]),
    "D02": ("Thunderwave Cave", "Grotte Statique", None,
            ["d02p01", "d02p02"]),
    "D03": ("Mt. Steel", "Mont Ferreux", "Skarmory", ["d03p01", "d03p02"]),
    "D04": ("Sinister Woods", "Bois Sinistres", "Gengar (Team Meanies)",
            ["d04p01", "d04p02"]),
    "D05": ("Silent Chasm", "Gouffre Muet", "Zubat/Grimer ambush",
            ["d05p01", "d05p02"]),
    "D06": ("Mt. Thunder", "Mont Foudre", "Zapdos",
            ["d06p01", "d06p02", "d06p03"]),
    "D07": ("Great Canyon", "Grand Canyon", None, ["d07p01", "d07p02"]),
    "D08": ("Lapis Cave", "Grotte Lazuli", None, ["d08p01", "d08p02"]),
    "D09": ("Mt. Blaze", "Mont Brasier", "Moltres",
            ["d09p01", "d09p02", "d09p03"]),
    "D10": ("Frosty Forest", "Forêt Givrée", "Articuno",
            ["d10p01", "d10p02", "d10p03"]),
    "D11": ("Mt. Freeze", "Mont Gel", "Ninetales (révélation)",
            ["d11p01", "d11p02", "d11p03"]),
    "D12": ("Magma Cavern", "Caverne Magma", "Groudon",
            ["d12p01", "d12p02", "d12p04"]),
    "D13": ("Sky Tower", "Tour Céleste", "Rayquaza",
            ["d13p01", "d13p02", "d13p03"]),
    "D14": ("Stormy Sea", "Mer Houleuse", "Kyogre", ["d14p01"]),
    "D15": ("Silver Trench", "Fosse Argentée", "Lugia", ["d15p01"]),
    "D16": ("Fiery Field", "Champ Brûlant", "Moltres", ["d16p01"]),
    "D17": ("Lightning Field", "Champ Éclair", "Raikou", ["d17p01"]),
    "D18": ("Northwind Field", "Champ Borée", "Articuno", ["d18p01"]),
    "D19": ("Mt. Faraway", "Mont Lointain", "Ho-Oh", ["d19p01"]),
    "D20": ("Western Cave", "Grotte Occidentale", "Mewtwo", ["d20p01"]),
    "D21": ("Northern Range", "Crêtes Boréales", "Latios/Latias",
            ["d21p01"]),
    "D22": ("Pitfall Valley", "Vallée Perdue", None, ["d22p01"]),
    "D23": ("Wish Cave", "Grotte du Vœu", "Jirachi", ["d23p01"]),
    "D24": ("Murky Cave", "Caverne Trouble", None, ["d24p01", "d24p02"]),
    "D25": ("Howling Forest", "Bois des Plaintes", "Suicune", ["d25p01"]),
}

# Alias : ID source GBA -> nom du Ground homologue dans le MOD New Era
# (INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md) — traçabilité, pas contenu.
MOD_ALIASES = {
    "d01p01": "foret_tendre_oree", "d02p01": "grotte_statique_seuil",
    "d03p01": "pic_ferreux_pied", "d04p01": "bois_sombres_oree",
    "d04p02": "bois_sombres_fond/sinister_woods_clearing",
    "d05p01": "gouffre_muet_bord", "d06p01": "mont_grondant_pied",
    "d07p01": "grand_canyon_porte", "d08p01": "grotte_lazuli_seuil",
    "d08p02": "grotte_lazuli_fond", "d09p01": "mont_cendre_pied",
    "d10p01": "foret_givree_oree", "d11p01": "mont_gele_pied",
    "d12p01": "gorge_ardente_porte", "d12p02": "gorge_ardente_coeur",
    "d12p04": "fosse_ardente", "d13p01": "parvis_celeste",
    "d13p02": "palier_celeste", "d13p03": "tour_ciel_sommet",
    "d14p01": "abime_tempetes", "d15p01": "fosse_argentee",
    "d16p01": "champ_braises", "d17p01": "champ_foudre",
    "d18p01": "champ_vent_boreal", "d19p01": "sommet_aurore",
    "d20p01": "antre_occident", "d21p01": "cretes_boreales",
    "d22p01": "vallon_perdu", "d23p01": "sanctuaire_voeu",
    "d24p01": "caverne_trouble_fond", "d24p02": "caverne_trouble_autel",
    "d25p01": "bois_des_plaintes",
}

# Noms humains des cartes non-donjon (MAP_DATABASE.md du port — les 245
# cartes documentées) + rôles des séries.
STATION_NAMES = {
    "t00p01": ("Rescue Team Base", "Base de l'Équipe de Secours"),
    "t01p01": ("Pokémon Square", "Place Pokémon"),
    "t01p02a": ("Whiscash Pond", "Étang Barbicha"),
    "t01p02b": ("Whiscash Pond (event)", "Étang Barbicha (évènement)"),
    "t01p03": ("Pelipper Post Office (outside)", "Poste Bekipan (extérieur)"),
    "t01p04": ("Pelipper Post Office (inside)", "Poste Bekipan (intérieur)"),
    "t01p05": ("Makuhita Dojo (outside)", "Dojo Makuhita (extérieur)"),
    "t01p07": ("Team Base cinematic", "Base d'équipe (cinématique)"),
}
SERIES_ROLES = {
    "a": ("Story cutscene map", "Carte de cinématique du scénario",
          "Scènes du scénario principal (aXXpYY: réveil, conseil, "
          "évènements de la Place, épilogue…)"),
    "b": ("Legacy boss arena", "Arène de boss (table GBA)",
          "Arènes de combat de la table de conversion (bXXpYYa/b/c: "
          "variantes d'éclairage jour/crépuscule/nuit)"),
    "h": ("Friend Area", "Zone d'Accueil",
          "58 cartes environnementales de recrutement (Plaines, Jungles, "
          "Volcans, Fonds Marins…)"),
    "s": ("System screen", "Écran système",
          "Écrans/scènes système multilingues (s02_ger = allemand…)"),
}

# Trame narrative globale (MAP_DATABASE + CINEMATICS_DATABASE + audit projet
# NARRATIVE_AUDIT — chronologie canonique de Rescue Team)
NARRATIVE_ARCS = [
    {"arc": "Prologue", "summary_fr":
     "Le héros se réveille transformé en Pokémon, rencontre son partenaire "
     "et fonde l'équipe de secours. Premiers sauvetages : Petit Bois "
     "(Chenipan), Grotte Statique, Mont Ferreux (Rondoudou/Airmure).",
     "grounds": ["t00p01", "t01p01", "d01p01", "d01p02",
                 "d02p01", "d02p02", "d03p01", "d03p02"]},
    {"arc": "Bois Sinistres & Gouffre Muet", "summary_fr":
     "La Team Meanies (Gengar/Ekans/Medicham) manigance. Sauvetage de "
     "Métamorph aux Bois Sinistres ; Grosdoudou au Gouffre Muet.",
     "grounds": ["d04p01", "d04p02", "d05p01", "d05p02"]},
    {"arc": "Mont Foudre & la légende de Feunard", "summary_fr":
     "Traversée du Mont Foudre jusqu'à Zapdos ; Xatu révèle sur la Colline "
     "des Anciens (D07P02) que la chute de l'étoile menace le monde. Le "
     "rêve de Gardevoir introduit la légende de Feunard.",
     "grounds": ["d06p01", "d06p02", "d06p03", "d07p01", "d07p02"]},
    {"arc": "Arc Fugitif", "summary_fr":
     "Accusé d'être l'humain maudit de la légende, le héros fuit par la "
     "Grotte Lazuli, le Mont Brasier (Sulfura), la Forêt Givrée (Artikodin, "
     "intervention d'Absol) jusqu'à l'autel du Mont Gel où Feunard révèle "
     "la vérité et innocente le héros.",
     "grounds": ["d08p01", "d08p02", "d09p01", "d09p02", "d09p03",
                 "d10p01", "d10p02", "d10p03", "d11p01", "d11p02", "d11p03"]},
    {"arc": "Crise de la Météorite", "summary_fr":
     "Xatu observe la météorite ; panique sur la Place Pokémon. L'équipe "
     "réveille Groudon dans la Caverne Magma puis monte à la Tour Céleste : "
     "Rayquaza détruit la météorite. Adieux du héros (fin du scénario "
     "principal).",
     "grounds": ["t01p01", "d12p01", "d12p02", "d12p04",
                 "d13p01", "d13p02", "d13p03"]},
    {"arc": "Post-game", "summary_fr":
     "Retour du héros ; donjons légendaires : Mer Houleuse (Kyogre), Fosse "
     "Argentée (Lugia), champs élémentaires (Sulfura/Raikou/Artikodin), "
     "Mont Lointain (Ho-Oh), Grotte Occidentale (Mewtwo), Grotte du Vœu "
     "(Jirachi), Bois des Plaintes (Suicune), etc.",
     "grounds": [g for d in ("D14", "D15", "D16", "D17", "D18", "D19",
                             "D20", "D21", "D22", "D23", "D24", "D25")
                 for g in DUNGEONS[d][3]]},
]


def load_json(p: Path):
    return json.loads(p.read_text(encoding="utf-8-sig"))


def main() -> int:
    render_report = load_json(CAMP / "Renders" / "render_report.json")
    renders = {r["ground"]: r for r in render_report["renders"]}
    validated = set((Path("/tmp/red_219.txt").read_text().split())
                    if Path("/tmp/red_219.txt").exists() else [])

    # cinématiques du port : id de scène -> résumé de séquence
    cines = {}
    for cif in sorted((PORT / "Data" / "Cinematics").glob("*.cif.json")):
        d = load_json(cif)
        seq = d.get("raw_sequence", [])
        from collections import Counter
        kinds = Counter(e.get("type") for e in seq)
        tracks = [e.get("track") for e in seq if e.get("track")]
        cines[d.get("scene", cif.stem.split(".")[0])] = {
            "events_total": len(seq),
            "dialog_boxes": kinds.get("Dialog", 0),
            "animations": kinds.get("Animation", 0),
            "audio_events": kinds.get("Audio", 0),
            "music_tracks": sorted(set(tracks)),
        }

    # dialogues canoniques 5 langues (ROM EU, red_extract_dialogue_texts.py)
    dlg_idx_p = CAMP / "Cinematics" / "DIALOGUES_INDEX.json"
    dialogues = (load_json(dlg_idx_p).get("stations", {})
                 if dlg_idx_p.exists() else {})

    # casting canonique ROM (27 scènes décodées)
    cast_p = ROOT / "dev" / "docs" / "canonical" / "red" / "scene_cast" / "eu_scene_cast.json"
    cast = load_json(cast_p)["scenes"] if cast_p.exists() else {}

    # nom humain par ground : depuis Name du rsground + inventaire donjons
    ground_names = {}
    for g in sorted(SRC.glob("Grounds/*.rsground")):
        try:
            o = load_json(g)["Object"]
            nm = o.get("Name", {})
            ground_names[g.stem] = {
                "en": nm.get("DefaultText") or g.stem,
                "fr": (nm.get("LocalTexts") or {}).get("fr"),
                "music": o.get("Music") or None,
                "comment": (o.get("Comment") or "")[:220] or None,
            }
        except Exception:
            ground_names[g.stem] = {"en": g.stem, "fr": None}

    ground_to_dungeon = {}
    for did, (en, fr, boss, grounds) in DUNGEONS.items():
        for i, g in enumerate(grounds):
            role = ("entrance" if i == 0 and len(grounds) > 1 else
                    "midpoint" if 0 < i < len(grounds) - 1 else
                    "end_or_arena" if len(grounds) > 1 else "arena")
            ground_to_dungeon[g] = {"dungeon": did, "dungeon_en": en,
                                    "dungeon_fr": fr, "boss": boss,
                                    "role": role}

    entries = []
    for gid in sorted(renders):
        r = renders[gid]
        nm_en = ground_names.get(gid, {}).get("en", gid)
        nm_fr = ground_names.get(gid, {}).get("fr")
        # noms humains des stations documentées + identité de donjon
        if gid in STATION_NAMES:
            nm_en, nm_fr = STATION_NAMES[gid]
        elif (nm_en == gid or nm_en.upper() == gid.upper()):
            dj = ground_to_dungeon.get(gid)
            if dj:
                nm_en = f"{dj['dungeon_en']} ({dj['role']})"
                nm_fr = f"{dj['dungeon_fr']} ({dj['role']})"
        e = {
            "ground": gid,
            "human_name_en": nm_en,
            "human_name_fr": nm_fr,
            "render": (None if "error" in r else {
                "dir": f"Renders/{gid}/",
                "width_px": r["width_px"], "height_px": r["height_px"],
                "frames": r["frames_rendered"],
                "animation_cycle": r["animation_cycle"],
                "animated_tiles": r["animated_tiles"],
            }),
            "render_error": r.get("error"),
            "runtime_validated_219": gid in validated,
            "music": ground_names.get(gid, {}).get("music"),
            "source_comment": ground_names.get(gid, {}).get("comment"),
        }
        d = ground_to_dungeon.get(gid)
        if d:
            e["dungeon"] = d
        else:
            sr = SERIES_ROLES.get(gid[:1])
            if sr and re.match(r"^[abhs]\d", gid):
                e["series_role"] = {"en": sr[0], "fr": sr[1],
                                    "context": sr[2]}
        if gid in MOD_ALIASES:
            e["new_era_mod_alias"] = MOD_ALIASES[gid]
        c = cines.get(gid)
        if c:
            e["cinematic"] = c
        dl = dialogues.get(gid)
        if dl:
            e["dialogues"] = {
                "status": dl["status"],
                "file": (f"Cinematics/{dl['file']}" if dl.get("file")
                         else None),
                "text_blocks_5lang": dl.get("text_blocks"),
                "dialogue_ops": dl.get("dialogue_ops"),
            }
        cc = cast.get(gid)
        if cc:
            ents = [x for x in cc.get("entities", []) if x.get("category") == "live"]
            e["canonical_cast"] = [
                {"role": x.get("actor_type"), "species": x.get("species"),
                 "pixel": [x.get("pixel_x"), x.get("pixel_y")],
                 "direction": x.get("direction")} for x in ents]
        entries.append(e)

    manifest = {
        "schema": "new-era.campaign-manifest.v1",
        "campaign": "PMD Red Rescue Team (EU)",
        "authority": {
            "grounds_source": "meromoonmeri/new-era-abyss-to-ascension-V4@0ec8129 "
                              "(campagne 219/219 Grounds validés PMDO 0.8.12 réel, "
                              "0 pixel mismatch)",
            "rom": "PMD Red EU sha256 0f9d125d…cbcd",
            "cinematics": "PMDRed_PMDO_Framework/Data/Cinematics/*.cif.json "
                          "(séquences extraites de la ROM)",
            "cast": "dev/docs/canonical/red/scene_cast/eu_scene_cast.json "
                    "(gMapScriptTable EU + gGroundLivesTypeData 0x27BEEC)",
            "naming": "rsground Name + INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md",
            "dialogues": "ROM Red EU (audit_pmdred_eu_all_ground_scripts.py "
                         "--all-stations) : 69 stations au graphe EU exact, "
                         "3073 blocs de texte 5 langues (en/fr/de/es/it), "
                         "adresses ROM + raw_hex préservés — "
                         "Cinematics/dialogues/<asset>.json.gz. Les 64 "
                         "stations restantes sont REVIEW_REQUIRED "
                         "(graphe EU non exactement aligné pret).",
        },
        "totals": {
            "grounds": len(entries),
            "rendered": sum(1 for e in entries if e["render"]),
            "runtime_validated": sum(1 for e in entries if e["runtime_validated_219"]),
            "with_cinematic": sum(1 for e in entries if "cinematic" in e),
            "with_canonical_cast": sum(1 for e in entries if "canonical_cast" in e),
            "with_dialogues_5lang": sum(
                1 for e in entries
                if e.get("dialogues", {}).get("status") == "PASS"),
            "dialogues_review_required": sum(
                1 for e in entries
                if e.get("dialogues", {}).get("status") == "REVIEW_REQUIRED"),
        },
        "narrative_arcs": NARRATIVE_ARCS,
        "dungeons": {k: {"en": v[0], "fr": v[1], "boss": v[2], "grounds": v[3]}
                     for k, v in DUNGEONS.items()},
        "grounds": entries,
    }
    (CAMP / "MANIFEST.json").write_text(
        json.dumps(manifest, indent=1, ensure_ascii=False))

    # MANIFEST.md lisible
    md = ["# Campagne PMD Red Rescue Team (EU) — manifest des Grounds\n",
          f"- Grounds : **{manifest['totals']['grounds']}** ; rendus : "
          f"**{manifest['totals']['rendered']}** ; validés runtime (campagne 219) : "
          f"**{manifest['totals']['runtime_validated']}**",
          f"- Avec cinématique extraite : **{manifest['totals']['with_cinematic']}** ; "
          f"avec casting canonique ROM : **{manifest['totals']['with_canonical_cast']}**\n",
          "## Narration globale\n"]
    for a in NARRATIVE_ARCS:
        md.append(f"### {a['arc']}\n{a['summary_fr']}\n")
    md.append("\n## Donjons\n")
    md.append("| Donjon | EN | FR | Boss | Grounds |")
    md.append("|---|---|---|---|---|")
    for k, v in DUNGEONS.items():
        md.append(f"| {k} | {v[0]} | {v[1]} | {v[2] or '—'} | "
                  f"{', '.join('`'+g+'`' for g in v[3])} |")
    md.append("\n## Grounds (extrait: donjons + scènes à cinématique)\n")
    md.append("| Ground | Nom | Donjon/Rôle | Frames | Cinématique | Cast ROM |")
    md.append("|---|---|---|---|---|---|")
    for e in entries:
        if "dungeon" not in e and "cinematic" not in e:
            continue
        d = e.get("dungeon", {})
        c = e.get("cinematic", {})
        md.append(
            f"| `{e['ground']}` | {e['human_name_en']} | "
            f"{d.get('dungeon_en','—')} {('('+d['role']+')') if d else ''} | "
            f"{(e['render'] or {}).get('frames','—')} | "
            f"{(str(c['dialog_boxes'])+' dlg / '+', '.join(c['music_tracks'][:2])) if c else '—'} | "
            f"{len(e.get('canonical_cast', [])) or '—'} |")
    (CAMP / "MANIFEST.md").write_text("\n".join(md) + "\n")
    print(f"manifest: {manifest['totals']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
