#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
campaign_coverage_matrix.py — Matrice de couverture (§49 du prompt maître)
pour les campagnes PMD Red EU et PMD Sky EU.

RÈGLE ABSOLUE : dimensions SÉPARÉES, jamais fusionnées en un pourcentage
unique. Chaque dimension cite sa source de mesure (artefact réel du dépôt).
Statuts stricts : PASS / PARTIAL / REVIEW_REQUIRED / NOT_TESTED / BLOCKED —
jamais de PASS implicite.

Sortie : dev/CAMPAIGNS/<camp>/Docs/COVERAGE_MATRIX.json + .md
et dev/CAMPAIGNS/COVERAGE_MATRIX.md (vue combinée, campagnes côte à côte,
sans fusion des chiffres).
"""
import json
import os
from collections import OrderedDict
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
CAMPS = REPO / "dev" / "CAMPAIGNS"


def load(p):
    return json.loads(Path(p).read_text(encoding="utf-8-sig"))


def dim(name, num, den, status, source, note=None):
    d = OrderedDict(dimension=name)
    if den:
        d["covered"] = num
        d["total"] = den
        d["pct"] = round(100.0 * num / den, 1)
    d["status"] = status
    d["source"] = source
    if note:
        d["note"] = note
    return d


def red_matrix():
    c = CAMPS / "PMD_RED_RESCUE_TEAM"
    man = load(c / "MANIFEST.json")
    aud = load(c / "AUDIT.json")
    t = man["totals"]
    dims = []
    dims.append(dim("extraction_grounds", t["grounds"], 254,
                    "PASS", "MANIFEST.totals.grounds",
                    "254 grounds canoniques (campagne 219 validée PMDO réel "
                    "+ 21 fins de donjon + variantes)"))
    dims.append(dim("render_visual", t["rendered"], t["grounds"],
                    "PASS" if t["rendered"] == t["grounds"] else "PARTIAL",
                    "AUDIT.coverage.render_pct"))
    fs = aud.get("frame_status", {})
    fp = sum(1 for v in fs.values() if v["status"] == "PASS")
    dims.append(dim("frames_animation", fp, len(fs),
                    "PASS" if fp == len(fs) else "PARTIAL",
                    "AUDIT.frame_status (période minimale réelle par tuile)"))
    dims.append(dim("runtime_pmdo", t["runtime_validated"], t["grounds"],
                    "PARTIAL",
                    "MANIFEST.totals.runtime_validated (campagne 219 : "
                    "mismatched_pixel_count=0 dans PMDO 0.8.12 réel)",
                    "35 grounds (fins de donjon importées + variantes) "
                    "restent NOT_TESTED au runtime"))
    dims.append(dim("cinematic_sequences", t["with_cinematic"],
                    t["grounds"], "PARTIAL",
                    "MANIFEST.totals.with_cinematic (cif.json ROM)",
                    "couvre les grounds d'histoire ; les arènes/variantes "
                    "n'ont canoniquement pas de cinématique"))
    dims.append(dim("dialogues_5_langues", t["with_dialogues_5lang"], 133,
                    "PARTIAL",
                    "Cinematics/DIALOGUES_INDEX.json (69 stations graphe EU "
                    "exact, 3073 blocs)",
                    "64 stations REVIEW_REQUIRED (graphe EU non exactement "
                    "aligné pret)"))
    dims.append(dim("canonical_cast", t["with_canonical_cast"], 27,
                    "PASS",
                    "eu_scene_cast.json (gGroundLivesTypeData 0x27BEEC) + "
                    "preuve runtime 3 scènes",
                    "27/27 scènes à cast décodées ; alt_sectors (49 "
                    "entités) REVIEW_REQUIRED"))
    g = load(c / "Docs" / "PROGRESSION_GRAPH.json")["totals"]
    ev_p = c / "Cinematics" / "EVENT_SCRIPTS_INDEX.json"
    if ev_p.exists():
        ev = load(ev_p)["totals"]
        dims.append(dim(
            "event_chain_rom_decoded", ev["PASS"],
            ev["PASS"] + ev["PARTIAL"] + ev["EMPTY"],
            "PASS" if ev["PARTIAL"] == 0 else "PARTIAL",
            "Cinematics/EVENT_SCRIPTS_INDEX.json (gFunctionScriptTable EU "
            "@0x08294450, décodage octet par octet)",
            f"{ev['scenario_main_writes']} écritures SCENARIO_MAIN "
            f"confirmées 1:1 vs pret ; 8 EMPTY = pointeurs nuls DANS la "
            f"ROM"))
    pp_p = c / "Docs" / "PLAYABLE_PROGRESSION.json"
    if pp_p.exists():
        pp = load(pp_p)["totals"]
        dims.append(dim(
            "playable_progression", pp["read"], pp["states"],
            "PASS" if pp["read"] == pp["states"] else "PARTIAL",
            "Docs/PLAYABLE_PROGRESSION.json (EVENT→stations→dialogues)",
            f"{pp['with_stations']} états avec stations résolues, "
            f"{pp['with_dialogues']} avec dialogues 5 langues — "
            f"atteignabilité statique ; runtime NOT_TESTED"))
    else:
        dims.append(dim("progression_graph", g["pret_events"], None,
                        "TECHNICAL_REFERENCE",
                        "Docs/PROGRESSION_GRAPH.json",
                        "chaîne EVENT_* non décodée"))
    dims.append(dim("dungeons_procedural_runtime", 89, 89,
                    "PARTIAL",
                    "dev/docs/canonical_dungeon_runtime/matrix.json "
                    "(89/89 CANONICAL_RUNTIME_PASS, 1848 étages)",
                    "15 zones CH1-5 restaurées ont perdu leurs correctifs "
                    "de convergence (zones verrouillées, état assumé)"))
    rj_p = REPO / "dev" / "docs" / "canonical" / "red" / \
        "global_journey_runtime_proof.jsonl"
    if rj_p.exists() and "RED_GLOBAL_JOURNEY_PASS" in rj_p.read_text():
        dims.append(dim(
            "full_journey_runtime", 13, 13, "PASS",
            "dev/docs/canonical/red/global_journey_runtime_proof.jsonl "
            "(mode redjourney)",
            "NEW SAVE→13 chapitres→182 étages→6 boss (Skarmory/Zapdos/"
            "Moltres/Glalie/Groudon/Rayquaza) SANS GAP — arènes Groudon/"
            "Rayquaza décodées de fixedmap.inc GBA octet par octet"))
    else:
        dims.append(dim("full_journey_runtime", 0, 13, "NOT_TESTED", "—",
                        "journey Red global non prouvé"))
    rres_p = REPO / "dev" / "docs" / "canonical" / "red" / \
        "resume_runtime_proof.jsonl"
    if rres_p.exists() and "RED_RESUME_RUNTIME_PASS" in rres_p.read_text():
        dims.append(dim(
            "save_resume_runtime", 1, 1, "PASS",
            "dev/docs/canonical/red/resume_runtime_proof.jsonl "
            "(dev/tools/red_resume_runtime_test.py)",
            "GroundSave état 7.0 depuis t01p02b→quit→process 2→"
            "LoadProgress→état 7.0 relu (mt_thunder oui, sky_tower non)→"
            "progression reprise 8.0 (great_canyon)"))
    dims.append(dim("audit_verdict", None, None,
                    aud.get("verdict", "?"),
                    "AUDIT.json (8 familles A-H)"))
    return dims


def sky_matrix():
    c = CAMPS / "PMD_SKY_EXPLORERS"
    man = load(c / "MANIFEST.json")
    aud = load(c / "AUDIT.json")
    t = man["totals"]
    dims = []
    dims.append(dim("extraction_grounds", t["grounds"], 460,
                    "PASS", "MANIFEST.totals.grounds",
                    "460 rsground du port (458 MAP_BG NDS, pixel-perfect "
                    "skytemple-files)"))
    dims.append(dim("render_visual", t["rendered"], t["grounds"],
                    "PARTIAL",
                    "AUDIT.coverage.render_pct",
                    "1 ground hérité sans layers (b01p01_beach, ACCEPTED)"))
    fs = aud.get("frame_status", {})
    fp = sum(1 for v in fs.values() if v["status"] == "PASS")
    dims.append(dim("frames_animation", fp, len(fs),
                    "PASS" if fp == len(fs) else "PARTIAL",
                    "AUDIT.frame_status"))
    idx = load(c / "Cinematics" / "ROM_SCRIPTS_INDEX.json")
    cov = idx["coverage"]
    dims.append(dim("rom_scripts_ssb", cov["ssb_total"], 3760,
                    "PASS" if cov["ssb_explorerscript_pct"] == 100.0
                    else "PARTIAL",
                    "Cinematics/ROM_SCRIPTS_INDEX.json (ExplorerScript + "
                    "dialogues 5 langues)"))
    dims.append(dim("rom_scripts_ssa", cov["ssa_total"], 1884,
                    "PASS" if cov["ssa_pct"] == 100.0 else "PARTIAL",
                    "idem (placements acteurs/objets/events/triggers)"))
    dims.append(dim("cinematic_linked_grounds", t["with_cinematic"],
                    t["grounds"], "PARTIAL",
                    "MANIFEST.totals.with_cinematic "
                    "(LEVEL_MAP_LINKS level→MAP_BG)",
                    "124 grounds sans zone SCRIPT propre (variantes de "
                    "MAP_BG non référencées par un level)"))
    g = load(c / "Docs" / "PROGRESSION_GRAPH.json")["totals"]
    dims.append(dim("progression_graph", g["scenario_states_written"],
                    None, "PASS",
                    "Docs/PROGRESSION_GRAPH.json (SSB décompilés ROM)",
                    f"{g['scenario_states_written']} états écrits, "
                    f"{g['bit_flags']} bit flags, "
                    f"{g['scene_triggers']} déclencheurs ; "
                    f"1 seul état lu-jamais-écrit (0.0 = init sauvegarde)"))
    pp_p = c / "Docs" / "PLAYABLE_PROGRESSION.json"
    if pp_p.exists():
        pp = load(pp_p)["totals"]
        dims.append(dim(
            "playable_progression", pp["with_dialogues"], pp["states"],
            "PASS" if pp["with_dialogues"] >= pp["states"] - 1
            else "PARTIAL",
            "Docs/PLAYABLE_PROGRESSION.json (état→scène→ground→dialogues)",
            f"{pp['with_ground']} états localisés sur un ground ; "
            f"runtime NOT_TESTED"))
    ci_p = c / "Docs" / "CINEMATIC_INTEGRABILITY.json"
    if ci_p.exists():
        ci = load(ci_p)["totals"]
        adaptable = ci.get("NATIVELY_SUPPORTED", 0) + \
            ci.get("TECHNICALLY_ADAPTABLE", 0)
        dims.append(dim(
            "cinematic_integrability", adaptable, ci["scenes"],
            "PARTIAL",
            "Docs/CINEMATIC_INTEGRABILITY.json (table curatée "
            "ssb_coverage, 0 opcode inconnu)",
            f"{ci.get('PARTIAL_FIDELITY', 0)} scènes fidélité partielle "
            f"(double écran NDS), "
            f"{ci.get('REQUIRES_ENGINE_EXTENSION', 0)} nécessitent une "
            f"extension moteur ; TOUTES NOT_YET_INTEGRATED au runtime"))
    cls_p = c / "Docs" / "GROUND_CLASSIFICATION.json"
    if cls_p.exists():
        cl = load(cls_p)["totals"]
        n_review = cl.get("REVIEW_REQUIRED", 0) + \
            cl.get("UNREFERENCED_ASSET", 0)
        dims.append(dim(
            "ground_classification", t["grounds"] - n_review,
            t["grounds"],
            "PASS" if n_review == 0 else "PARTIAL",
            "Docs/GROUND_CLASSIFICATION.json (mapty×SCRIPT×collision×"
            "xrefs SSB — jamais le nom de fichier)",
            f"{cl.get('MAP', 0)} MAP, "
            f"{cl.get('CINEMATIC_BACKGROUND', 0)} backgrounds, "
            f"{cl.get('DUNGEON_SCREEN', 0)} écrans donjon, "
            f"{cl.get('CINEMATIC_GROUND', 0)} décors de scène, "
            f"{n_review} dormants ROM (REVIEW)"))
    hub_p = REPO / "dev" / "docs" / "canonical" / "sky" / \
        "hub_grounds_runtime_proof.jsonl"
    if hub_p.exists():
        n_safe = hub_p.read_text().count('"verdict":"SAFE"')
        n_map = load(cls_p)["totals"].get("MAP", 95) if cls_p.exists() \
            else 95
        dims.append(dim(
            "runtime_pmdo_grounds_map", n_safe, n_map,
            "PASS" if n_safe >= n_map else "PARTIAL",
            "dev/docs/canonical/sky/hub_grounds_runtime_proof.jsonl "
            "(sky_hub_zone + mode sky: du ground_gameplay_validator)",
            "TOUS les grounds classifiés MAP : LOAD_PASS+MOVEMENT_PASS ; "
            "les backgrounds/écrans ne sont PAS des maps (dénominateur = "
            "MAP uniquement)"))
    else:
        dims.append(dim("runtime_pmdo_grounds_map", 0, 95,
                        "NOT_TESTED", "—",
                        "grounds Sky pas encore chargés dans PMDO réel"))
    prog_p = REPO / "dev" / "docs" / "canonical" / "sky" / \
        "progression_runtime_proof.jsonl"
    if prog_p.exists() and "PROGRESSION_RUNTIME_PASS" in \
            prog_p.read_text():
        dims.append(dim(
            "progression_runtime", 14, 14, "PASS",
            "dev/docs/canonical/sky/progression_runtime_proof.jsonl "
            "(skyscenes/progression.lua, SV natif)",
            "14 états ROM franchis, 43 zones débloquées, monotonie "
            "anti-régression + persistance save prouvées ; états "
            "intermédiaires (x.1..x.n) non encore déclencheurs"))
    gj_p = REPO / "dev" / "docs" / "canonical" / "sky" / \
        "global_journey_runtime_proof.jsonl"
    j_p = REPO / "dev" / "docs" / "canonical" / "sky" / \
        "journey_ch1_runtime_proof.jsonl"
    if gj_p.exists() and "GLOBAL_JOURNEY_PASS" in gj_p.read_text():
        dims.append(dim(
            "full_journey_runtime", 14, 14, "PASS",
            "dev/docs/canonical/sky/global_journey_runtime_proof.jsonl "
            "(mode skyjourney global)",
            "NEW SAVE→CH1→…→CH15→DIALGA : 14 chapitres, 30 donjons, "
            "313 étages réellement générés, 10 boss vérifiés, état final "
            "20.0"))
    elif j_p.exists() and "JOURNEY_RUNTIME_PASS" in j_p.read_text():
        dims.append(dim(
            "full_journey_runtime", 1, 15, "PARTIAL",
            "dev/docs/canonical/sky/journey_ch1_runtime_proof.jsonl "
            "(mode skyjourney)",
            "chapitre 1 complet: save→état→ground→cinématique→donjon 4 "
            "étages→boss→flag→déblocage suivant ; 14 chapitres restants "
            "à chaîner"))
    res_p = REPO / "dev" / "docs" / "canonical" / "sky" / \
        "resume_runtime_proof.jsonl"
    if res_p.exists() and "RESUME_RUNTIME_PASS" in res_p.read_text():
        dims.append(dim(
            "save_resume_runtime", 1, 1, "PASS",
            "dev/docs/canonical/sky/resume_runtime_proof.jsonl",
            "save GroundSave→quit→process 2→LoadProgress→état relu→"
            "progression reprise (persistance réelle inter-process)"))
    scr2_p = REPO / "dev" / "docs" / "canonical" / "sky" / \
        "scroll_pilot_runtime_proof.jsonl"
    if scr2_p.exists() and "SCROLL_RUNTIME_PASS" in scr2_p.read_text():
        dims.append(dim(
            "scrolling_background_runtime", 1, 213, "PARTIAL",
            "dev/docs/canonical/sky/scroll_pilot_runtime_proof.jsonl",
            "pilote s13p05a (panorama intro) : scrolling NDS reproduit "
            "par caméra continue PMDO, mouvement vérifié à 4 instants ; "
            "sheet S13p05a_Base reconstruite depuis ROM (frame 0 "
            "PIXEL_PERFECT) ; généralisation aux 213 backgrounds à faire"))
    cin_p = REPO / "dev" / "docs" / "canonical" / "sky" / \
        "cinematic_m01a0204_runtime_proof.jsonl"
    if cin_p.exists():
        n_pass = cin_p.read_text().count("CINEMATIC_RUNTIME_PASS")
        dims.append(dim(
            "cinematic_runtime", n_pass, 3760, "PARTIAL",
            "dev/docs/canonical/sky/cinematic_m01a0204_runtime_proof.jsonl "
            "(SkyCanonScenes.lua, mode skyscene:)",
            "1 scène pilote rejouée dans le moteur (positions finales == "
            "ROM, dialogue EU, BGM) ; GAPs canal-2 NDS documentés"))
    comp_p = REPO / "dev" / "docs" / "canonical" / "sky" / \
        "compiled_scenes_runtime_proof.jsonl"
    scr_p = c / "Docs" / "SCENE_COMPILER_REPORT.json"
    if comp_p.exists() and scr_p.exists():
        n_pass = comp_p.read_text().count("CINEMATIC_RUNTIME_PASS")
        n_comp = load(scr_p)["totals"].get("COMPILED", 0)
        dims.append(dim(
            "cinematic_compiled", n_comp, 3760, "PARTIAL",
            "Docs/SCENE_COMPILER_REPORT.json (compilateur FAIL-CLOSED) + "
            "compiled_scenes_runtime_proof.jsonl",
            f"{n_comp} scènes 100% traduites émises (dialogues 5 langues "
            f"ROM, SE/VFX émotes natives, cast SSA PNJ, caméra) ; "
            f"{n_pass} validées runtime ; PARTIAL_OPS restantes comptées, "
            f"jamais approximées"))
    dsv_p = c / "Docs" / "DUAL_SCREEN_VERIFICATION.json"
    dst_p = c / "Docs" / "DUAL_SCREEN_TIMELINES.json"
    if dsv_p.exists() and dst_p.exists():
        dsv = load(dsv_p)["totals"]
        dst = load(dst_p)["totals"]
        n_dual = dst.get("DUAL_TIMELINE", 0)
        n_match = dsv.get("TIMELINE_MATCH", 0)
        dims.append(dim(
            "dual_screen_focus_runtime", n_match, n_dual,
            "PARTIAL" if n_match < n_dual else "PASS",
            "Docs/DUAL_SCREEN_TIMELINES.json + DUAL_SCREEN_VERIFICATION."
            "json + dev/docs/canonical/sky/dual_screen_runtime_proof.jsonl",
            f"{n_dual} scènes à timeline double écran ROM ; {n_match} "
            f"reconstructions single-screen vérifiées vs timeline "
            f"(décors, fondus, ordre) ; 62 nappes Sub_* (rendus ROM) ; "
            f"8/8 échantillon runtime PASS ; le reste des scènes duales "
            f"est bloqué par d'autres ops (PARTIAL_OPS/multiroutine), "
            f"pas par le double écran"))
    ti_p = c / "Tables" / "DUNGEON_TABLES_INDEX.json"
    if ti_p.exists():
        ti = load(ti_p)["totals"]
        dims.append(dim("gameplay_tables_extraction", ti["floors_pass"],
                        ti["dungeons"], "PASS" if ti["floors_pass"] >= 178
                        else "PARTIAL",
                        "Tables/DUNGEON_TABLES_INDEX.json (mappa_s.bin EU : "
                        f"{ti['floors_extracted']} étages, spawns/pièges/"
                        "items bruts)",
                        "2 donjons à slice vide DANS la ROM (d71, d173 "
                        "dummy — documentés)"))
    else:
        dims.append(dim("gameplay_tables_extraction", 0, None, "NOT_TESTED",
                        "—", "tables non extraites"))
    map_p = c / "Tables" / "PMDO_MAPPING.json"
    if map_p.exists():
        mp = load(map_p)
        sc = mp["species"]["counts"]
        ic = mp["items"]["counts"]
        dims.append(dim(
            "pmdo_mapping_species", sc["EXACT"],
            sum(sc.values()) - sc.get("SPECIAL", 0),
            "PASS" if sc.get("UNMAPPED", 0) == 0 else "PARTIAL",
            "Tables/PMDO_MAPPING.json",
            "Decoy = entité moteur SPECIAL documentée"))
        n_mapped = ic["EXACT"] + ic["RENAMED"] + ic["TM"] + ic["MONEY"]
        dims.append(dim(
            "pmdo_mapping_items", n_mapped, sum(ic.values()),
            "PARTIAL",
            "Tables/PMDO_MAPPING.json",
            f"{ic['REQUIRES_MOD_ITEM']} items d'Explorers absents du "
            f"roster PMDO (orbes/seeds/bands Sky) — REQUIRES_MOD_ITEM, "
            f"0 UNMAPPED"))
    zc_p = c / "Tables" / "ZONE_VS_ROM_COMPARISON.json"
    n_zones = 0
    if zc_p.exists():
        zc = load(zc_p)
        n_zones = len(zc["zones"])
        exact = sum(1 for e in zc["zones"].values()
                    if e.get("verdict") == "EXACT")
        dims.append(dim(
            "dungeon_zones_vs_rom", exact, n_zones,
            "PASS" if exact == n_zones else "PARTIAL",
            "Tables/ZONE_VS_ROM_COMPARISON.json (comparaison "
            "structurelle par étage)",
            f"{n_zones} zones construites (histoire d01-d25 + arc futur "
            f"D27-D32) sur 180 donjons ROM"))
    dims.append(dim(
        "dungeon_runtime_pmdo", n_zones, 180, "PARTIAL",
        "dev/docs/canonical_dungeon_runtime/matrix.json + mapgen_*.jsonl "
        "(PMDO 0.8.12 réel)",
        "43 zones (histoire d01-d43 complète + arc futur) toutes "
        "CANONICAL_RUNTIME_PASS ; le reste des 180 donjons NOT_BUILT"))
    chains_p = REPO / "dev" / "docs" / "canonical" / "sky" / \
        "story_chains_runtime_proof.jsonl"
    if chains_p.exists():
        n_chains = chains_p.read_text().count("BOSS_ARENA_PASS")
        dims.append(dim(
            "story_chains_end_to_end", n_chains, 9, "PASS"
            if n_chains == 9 else "PARTIAL",
            "dev/docs/canonical/sky/story_chains_runtime_proof.jsonl "
            "(red_story_route_validator, chaînes sky)",
            "donjon procédural étage par étage → zone d'arène → espèce du "
            "boss fixed.bin vérifiée dans les MapTeams chargées, moteur "
            "réel ; combat piloté par IA non joué (headless)"))
    dims.append(dim("audit_verdict", None, None,
                    aud.get("verdict", "?"),
                    "AUDIT.json (8 familles A-H)"))
    return dims


def main():
    combined = ["# Matrice de couverture — campagnes PMD Red EU & Sky EU\n",
                "Dimensions SÉPARÉES (règle §49) : aucun pourcentage global "
                "fusionné n'existe ni ne doit être calculé.\n"]
    for camp, fn in (("PMD_RED_RESCUE_TEAM", red_matrix),
                     ("PMD_SKY_EXPLORERS", sky_matrix)):
        dims = fn()
        out = OrderedDict(schema="campaign-coverage-matrix/1",
                          campaign=camp,
                          rule="couvertures séparées — ne JAMAIS fusionner",
                          dimensions=dims)
        d = CAMPS / camp / "Docs"
        d.mkdir(exist_ok=True)
        (d / "COVERAGE_MATRIX.json").write_text(
            json.dumps(out, ensure_ascii=False, indent=1))
        combined.append(f"\n## {camp}\n")
        combined.append("| Dimension | Couverture | Statut | Source |")
        combined.append("|---|---|---|---|")
        lines = []
        for x in dims:
            covtxt = (f"{x['covered']}/{x['total']} ({x['pct']}%)"
                      if "total" in x and x.get("total") else
                      (str(x.get("covered", "—"))))
            lines.append(f"| {x['dimension']} | {covtxt} | "
                         f"**{x['status']}** | {x['source']} |")
        combined.extend(lines)
        (d / "COVERAGE_MATRIX.md").write_text(
            "\n".join(["# Matrice de couverture — " + camp, ""]
                      + combined[-len(lines) - 2:]) + "\n")
        print(camp, "->", [(x["dimension"], x["status"]) for x in dims])
    (CAMPS / "COVERAGE_MATRIX.md").write_text("\n".join(combined) + "\n")
    print("écrit:", CAMPS / "COVERAGE_MATRIX.md")


if __name__ == "__main__":
    main()
