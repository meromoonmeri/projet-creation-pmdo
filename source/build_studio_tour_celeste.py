#!/usr/bin/env python3
"""Génère les planches filmstrip 2D compactes (`cols <= 6`, `largeur <= 4608 px << 8192 px` GPU limit)
avec cache-busting SHA-256 (`?v=<hash>`) dans `.cache/studio_layers/<MAP_ID>/` (hors Git) et le Studio
interactif HTML5 `<canvas>` 60 FPS (`index.html` + aperçus dédiés) réunissant les **14 cartes multicalques
PMDO 0.8.12.0** (140 calques) :
- **Mine Magma (Groudon)** : `MME1` (Entrée sans lave, roche noire visible) · `MMA1` (Arène, mer sombre, 8 Lames Pangéennes)
- **Forêt Givrée (Artikodin)** : `FGE1` (Entrée `H10P02` + `W03P03`) · `FGA1` (Sanctuaire d'Artikodin `h24p01`)
- **Mont Brasier (Sulfura)** : `MBE1` (Entrée `d09p01`) · `MBA1` (Cratère de Sulfura `h19p01`)
- **Mont Foudre (Électhor)** : `MFE1` (Entrée `H17P01W`) · `MFA1` (Sommet d'Électhor `H18P01` vortex 360°)
- **Mont Lointain (Ho-Oh)** : `MLE1` (Entrée `b72`) · `MLS1` (Sommet Arc-en-Ciel de Ho-Oh `b72`)
- **Tour Céleste (Rayquaza)** : `TCE1` (Entrée Tornades 3D 360°) · `STC1` (Sommet Planète Terre)
- **Faille Spatiale (Palkia)** : `FSE1` (Entrée `D46P41A`) · `FSA1` (Sanctuaire `D45P42A`)
"""

from __future__ import annotations

import hashlib
import importlib.util
import json
import math
import sys
from pathlib import Path
from typing import Dict, List

from PIL import Image

REPO_ROOT = Path(__file__).resolve().parents[1]
if str(REPO_ROOT / "source") not in sys.path:
    sys.path.insert(0, str(REPO_ROOT / "source"))

STUDIO_CACHE = REPO_ROOT / ".cache" / "studio_layers"
MAX_STRIP_COLS = 6


def _load_builder(folder_name: str):
    path = REPO_ROOT / "source" / folder_name / "build.py"
    spec = importlib.util.spec_from_file_location(f"studio_{folder_name}", path)
    mod = importlib.util.module_from_spec(spec)
    assert spec and spec.loader
    spec.loader.exec_module(mod)
    return mod


def _file_hash(rel_path: str) -> str:
    p = REPO_ROOT / rel_path.lstrip("/")
    if not p.exists():
        return "0"
    h = hashlib.sha256()
    with p.open("rb") as f:
        while True:
            chunk = f.read(131072)
            if not chunk:
                break
            h.update(chunk)
    return h.hexdigest()[:10]


def _versioned_url(rel_path: str) -> str:
    clean = "/" + rel_path.lstrip("/")
    return f"{clean}?v={_file_hash(clean)}"


def export_filmstrips() -> Dict:
    specs = [
        {
            "id": "TWE1",
            "group": "Petit Bois · Tiny Woods",
            "folder": "tiny_woods_entree_v1",
            "ref_rel": "source/tiny_woods_entree_v1/references/d01p01_tiny_woods_entry_native.png",
            "ref_label": "Référence Native 1× GBA PMD Red Rescue Team — Tiny Woods Entrée (D01P01, 432×360)",
            "zip_rel": ".cache/virtual_zips/TWE1_PMDO_0.8.12.zip",
            "bg_fill": "#0c2214",
            "subtitle": "Petit Bois — Entrée (D01P01) : Clairière ensoleillée guidée par le rip GBA natif D01P01 (#FF00FF), arche feuillue Nord, pont en rondins, ruisseau Metano 4×10t & rayons solaires Friend Area",
            "wind_summary": "Ciel & rayons solaires Friend Area PMD Red (24f @ 5t) | Ruisseau limpide & sparkles Metano #FF00FF (4×10t) | Fleurs sauvages & canopée Top | Terrain 1× statique",
        },
        {
            "id": "TWF1",
            "group": "Petit Bois · Tiny Woods",
            "folder": "tiny_woods_fin_v1",
            "ref_rel": "source/tiny_woods_fin_v1/references/h07p06_healing_forest_native.png",
            "ref_label": "Références Natives 1× GBA PMD Red — Clairière Fin (D01P02 + H07P06 Healing Forest)",
            "zip_rel": ".cache/virtual_zips/TWF1_PMDO_0.8.12.zip",
            "bg_fill": "#0d2415",
            "subtitle": "Petit Bois — Clairière Fin (D01P02 / Sauvetage de Chenipan) : Grand Chêne Ancestral H07P06, bassins de source jumeaux #FF00FF animés 4×10t, rayons dorés & pollen dans la brise",
            "wind_summary": "Ciel doré-azur & halo solaire Grand Chêne (24f @ 5t) | Bassins jumeaux & sparkles Metano #FF00FF (4×10t) | Bourgeons dorés & canopée Top | Terrain 1× statique",
        },
        {
            "id": "SWE1",
            "group": "Bois Sinistre · Sinister Woods",
            "folder": "sinister_woods_entree_v1",
            "ref_rel": "source/sinister_woods_entree_v1/references/d04p01_sinister_woods_entry_native.png",
            "ref_label": "Référence Native 1× GBA PMD Red Rescue Team — Sinister Woods Entrée (D04P01, 456×384)",
            "zip_rel": ".cache/virtual_zips/SWE1_PMDO_0.8.12.zip",
            "bg_fill": "#06161d",
            "subtitle": "Bois Sinistre — Entrée (D04P01) : Forêt bleu-sarcelle guidée par le rip GBA natif D04P01 (#FF00FF), tunnel sombre Nord, champignons écarlates, vieux pont de bois & brume spectrale H07P01",
            "wind_summary": "Ciel crépusculaire H07P08 & voiles de brume H07P01 (24f @ 5t) | Ruisseau sarcelle & sparkles #FF00FF (4×10t) | Champignons rouges & feux follets Top | Terrain 1× statique",
        },
        {
            "id": "SWF1",
            "group": "Bois Sinistre · Sinister Woods",
            "folder": "sinister_woods_fin_v1",
            "ref_rel": "source/sinister_woods_fin_v1/references/h07p08_secretive_forest_native.png",
            "ref_label": "Références Natives 1× GBA PMD Red — Arène Fin (D04P02 + H07P08 Secretive + H07P01 Mist-Rise)",
            "zip_rel": ".cache/virtual_zips/SWF1_PMDO_0.8.12.zip",
            "bg_fill": "#05131a",
            "subtitle": "Bois Sinistre — Clairière Fin (D04P02 / Boss Équipe Méchants) : Souche creuse monolithique H07P01 & toiles H07P08, champignons écarlates/indigo H07P05, mares sombres #FF00FF & brume spectrale",
            "wind_summary": "Ciel nocturne & rubans de brume spectrale H07P01 (24f @ 5t) | Mares sarcelle-jade & lueurs #FF00FF (4×10t) | Champignons rouges/indigo & spores Top | Terrain 1× statique",
        },
        {
            "id": "ZKE1",
            "group": "Duo Unys · Zekrom",
            "folder": "zekrom_montagne_entree_v1",
            "ref_rel": "source/zekrom_montagne_entree_v1/references/ref_canon_zekrom_montagne_entree.png",
            "ref_label": "Références Natives 1× Halcyon/Chunsoft — Montagne D07P11A + Clairière Sky Peak/Tiny Woods + Eau Metano Town",
            "zip_rel": ".cache/virtual_zips/ZKE1_PMDO_0.8.12.zip",
            "bg_fill": "#09101f",
            "subtitle": "Pied de Montagne & Clairière Metano (Zekrom) — Montagne rocheuse naturelle 1× D07P11A à grotte centrale, clairière Tiny Woods + Sky Peak Prairie, rivière & cascades animées style Metano Town (#FF00FF)",
            "wind_summary": "Ciel d'orage & éclairs d'horizon (24f @ 5t) | Rivière, cascades & sparkles Metano Town #FF00FF (24f @ 5t) | Fleurs Sky Peak animées & canopée Top | Terrain 1× statique",
        },
        {
            "id": "ZKA1",
            "group": "Duo Unys · Zekrom",
            "folder": "zekrom_sommet_tornade_v1",
            "ref_rel": "source/zekrom_sommet_tornade_v1/references/ref_canon_zekrom_sommet_tornade.png",
            "ref_label": "Références Natives 1× PMD — Orage Électrique V38P07A + Sommet Rocheux Mt. Thunder Summit",
            "zip_rel": ".cache/virtual_zips/ZKA1_PMDO_0.8.12.zip",
            "bg_fill": "#060b18",
            "subtitle": "Sommet du Mont Foudre & Cyclone Électrique (Zekrom) — Plateau rocheux naturel 1× style Mt. Thunder Summit centré dans le creux d'un Cyclone Cylindrique 3D 360° d'éclairs bleus (#FF00FF)",
            "wind_summary": "Cyclone Cylindrique 3D 360° #FF00FF (paroi arrière G->D + lèvre avant Top D->G, 24f @ 5t) | Arcs électriques ramifiés | Reflets crêtes | Roc Mt. Thunder 1× statique",
        },
        {
            "id": "RSE1",
            "group": "Duo Unys · Reshiram",
            "folder": "reshiram_montagne_entree_v1",
            "ref_rel": "source/reshiram_montagne_entree_v1/references/ref_canon_reshiram_montagne_entree.png",
            "ref_label": "Références Natives 1× Halcyon/Chunsoft — Montagne Solaire D07P11A + Clairière Sky Peak/Tiny Woods + Eau Metano Town",
            "zip_rel": ".cache/virtual_zips/RSE1_PMDO_0.8.12.zip",
            "bg_fill": "#1c0a0d",
            "subtitle": "Pied de Montagne & Clairière Metano (Reshiram) — Montagne solaire ivoire 1× D07P11A à grotte centrale, clairière Tiny Woods + Sky Peak Prairie, rivière & cascades animées style Metano Town (#FF00FF)",
            "wind_summary": "Aurore ardente & rubans Flamme Blanche (24f @ 5t) | Rivière, cascades & sparkles Metano Town #FF00FF (24f @ 5t) | Braises GBA W04 1× & canopée Top | Terrain 1× statique",
        },
        {
            "id": "RSA1",
            "group": "Duo Unys · Reshiram",
            "folder": "reshiram_sommet_flamme_v1",
            "ref_rel": "source/reshiram_sommet_flamme_v1/references/ref_canon_reshiram_sommet_flamme.png",
            "ref_label": "Références Natives 1× PMD — Cratère Ardent H19P01 + Sommet Solaire Mt. Thunder Summit",
            "zip_rel": ".cache/virtual_zips/RSA1_PMDO_0.8.12.zip",
            "bg_fill": "#18080b",
            "subtitle": "Sommet Solaire & Cyclone de Flamme Blanche (Reshiram) — Plateau rocheux naturel 1× style Mt. Thunder Summit centré dans le creux d'un Cyclone Cylindrique 3D 360° de Flamme Blanche sacrée (#FF00FF)",
            "wind_summary": "Cyclone Cylindrique 3D 360° de Flamme Blanche #FF00FF (paroi arrière G->D + lèvre avant Top D->G, 24f @ 5t) | Braises GBA W04 1× | Roc Mt. Thunder 1× statique",
        },
        {
            "id": "FSE1",
            "group": "Faille Spatiale · Palkia",
            "folder": "faille_spatiale_entree_v1",
            "ref_rel": "source/faille_spatiale_entree_v1/bruts/paroi_rocheuse_canyon_avant_faille.png",
            "ref_label": "Canyon Dimensionnel Rocheux Scellé (Avant Déchirure, Nuée des Zarbis & Cosmos Étoilé)",
            "zip_rel": ".cache/virtual_zips/FSE1_PMDO_0.8.12.zip",
            "bg_fill": "#120722",
            "subtitle": "Chapitre I — Entrée Canyon Dimensionnel (24 poses) : Fond rocheux complet ──▶ Fissures Spatio-Rift & Distorsion avec nuée de 132 Zarbis PMDO (A–Z, !, ?) ──▶ Rupture vers Portail Nord & Cosmos distordu étoilé",
            "wind_summary": "Fond rocheux fissuré -> rupture totale (24f @ 5t) | Distorsion & 132 Zarbis PMDO officiels BG + Top (A–Z, !, ?) | Portail Nord & Cosmos étoilé (24f) | Canyon statique",
        },
        {
            "id": "FSA0",
            "group": "Faille Spatiale · Palkia",
            "folder": "faille_spatiale_sanctuaire_avant_portail_v1",
            "ref_rel": "source/faille_spatiale_sanctuaire_avant_portail_v1/bruts/paroi_nord_scellee_avant_portail.png",
            "ref_label": "Paroi Rocheuse Nord Scellée (Couture DP 1:1 D45P42A — Avant Ouverture)",
            "zip_rel": ".cache/virtual_zips/FSA0_PMDO_0.8.12.zip",
            "bg_fill": "#140826",
            "subtitle": "Acte I Boss Palkia (Pré-Portail calé 1:1 sur FSA1) — Paroi Nord scellée se brisant en éclats de verre Spatio-Rift dans la silhouette exacte du portail + résonance du cercle central",
            "wind_summary": "Brisure de réalité en tessons de verre Spatio-Rift (24f @ 5t) | Lueur de portail sous-jacente #FF00FF (24f) | Résonance cercle central (24f) | Dalles & remparts 1:1 FSA1",
        },
        {
            "id": "FSA1",
            "group": "Faille Spatiale · Palkia",
            "folder": "faille_spatiale_sanctuaire_v1",
            "ref_rel": "source/faille_spatiale_sanctuaire_v1/references/d45p42a_deep_spatial_rift_boss_native.png",
            "ref_label": "Référence PMD Sky — Creux de la Faille Spatiale / Palkia (D45P42A 1×)",
            "zip_rel": ".cache/virtual_zips/FSA1_PMDO_0.8.12.zip",
            "bg_fill": "#140826",
            "subtitle": "Acte II Boss Palkia (Portail Ouvert calé 1:1 sur FSA0) — Pont & arène circulaire Sud-Nord, brèche Spatio-Rift blanc-magenta #FF00FF & nébuleuse cosmique",
            "wind_summary": "Nébuleuse cosmique D45P42A (24f @ 5t) | Déchirure Spatio-Rift blanc-magenta (24f @ 5t) | Anneau d'ondes spatiales (24f) | Piliers statiques",
        },
        {
            "id": "MMA1",
            "group": "Mine Magma · Groudon",
            "folder": "mine_magma_arene_v1",
            "ref_rel": "source/mine_magma_arene_v1/references/dark_crater_pit/d41p41a_preview.png",
            "ref_label": "Référence PMD Sky — Dark Crater Pit (d41p41a 1×)",
            "zip_rel": ".cache/virtual_zips/MMA1_PMDO_0.8.12.zip",
            "bg_fill": "#1a0504",
            "subtitle": "POV PMD Arène de Groudon — Roche volcanique noire sculptée bien lisible, 0 lave à l'entrée Nord, mer de magma assombrie & 8 Lames Pangéennes jaillissantes",
            "wind_summary": "8 Lames Pangéennes (24f @ 5t) | 4 colonnes ascendantes -8px/pose (24f @ 5t) | Mer magma assombrie (12f @ 10t) | Grotte Nord noire bien lisible",
        },
        {
            "id": "MME1",
            "group": "Mine Magma · Groudon",
            "folder": "mine_magma_entree_v1",
            "ref_rel": "source/mine_magma_entree_v1/references/d40p11a_dark_crater_entrance.png",
            "ref_label": "Référence PMD Sky — Dark Crater Entrance (d40p11a 1×)",
            "zip_rel": ".cache/virtual_zips/MME1_PMDO_0.8.12.zip",
            "bg_fill": "#140605",
            "subtitle": "POV PMD Mine Magma — Entrée (d40p11a) — Lacs latéraux #FF00FF de lave & magma Dark Crater Pit assombris restaurés, 0 lave sur l'arche d'entrée & roche noire sculptée",
            "wind_summary": "Lacs latéraux magma & lave assombris #FF00FF (12f @ 10t) | Rive visqueuse berges basses uniquement (15f @ 8t) | Braises W04 Top | 0 lave sur l'arche Nord",
        },
        {
            "id": "FGE1",
            "group": "Oiseaux Légendaires · Artikodin",
            "folder": "foret_givree_entree_v1",
            "ref_rel": "source/foret_givree_entree_v1/references/d10p01_frosty_forest_native.png",
            "ref_label": "Référence PMD Red — Forêt Givrée Entrée (D10P01 1×)",
            "zip_rel": ".cache/virtual_zips/FGE1_PMDO_0.8.12.zip",
            "bg_fill": "#3c5488",
            "subtitle": "1× Natif GBA Forêt Givrée — Entrée (D10P01) — Sapins enneigés, souche givrée, dalles de glace vive #FF00FF & chute de neige matérielle GBA W03P03",
            "wind_summary": "Ciel polaire & dalles de glace vive #FF00FF D10P01 (12f @ 10t) | Chute de neige GBA W03P031.bpa (12f / 15f Top) | Sapins & souche D10P01 1× statiques",
        },
        {
            "id": "FGA1",
            "group": "Oiseaux Légendaires · Artikodin",
            "folder": "foret_givree_sanctuaire_v1",
            "ref_rel": "source/foret_givree_sanctuaire_v1/references/h24p01_articuno_sanctuary_native.png",
            "ref_label": "Référence PMD Red — Sanctuaire d'Artikodin (H24P01 1×)",
            "zip_rel": ".cache/virtual_zips/FGA1_PMDO_0.8.12.zip",
            "bg_fill": "#2f4a7d",
            "subtitle": "1× Natif GBA Sanctuaire d'Artikodin (H24P01) — Grand Médaillon Flocon de Cristal #FF00FF, crevasses glaciaires, totems de neige & chute de neige W03P03",
            "wind_summary": "Médaillon Flocon 6 branches & crevasses #FF00FF H24P01 (12f @ 10t) | Neige canonique GBA W03P03 Top | Totems & corniche de glace 1× statiques",
        },
        {
            "id": "MBE1",
            "group": "Oiseaux Légendaires · Sulfura",
            "folder": "mont_brasier_entree_v1",
            "ref_rel": "source/mont_brasier_entree_v1/references/d09p01_mt_blaze_native.png",
            "ref_label": "Référence PMD Red — Mont Brasier Entrée (D09P01 1×)",
            "zip_rel": ".cache/virtual_zips/MBE1_PMDO_0.8.12.zip",
            "bg_fill": "#2b1008",
            "subtitle": "1× Natif GBA Mont Brasier — Entrée (D09P01) — Bassins de lave en fusion, cascades jumelles Nord #FF00FF (D09P01.bpl), arche caverneuse & braises W04",
            "wind_summary": "Bassins & cascades jumelles GBA D09P01.bpl #FF00FF (10f @ 12t) | Reflets thermiques sur colonnes | Flammèches GBA W04 Top (15f @ 8t)",
        },
        {
            "id": "MBA1",
            "group": "Oiseaux Légendaires · Sulfura",
            "folder": "mont_brasier_sommet_v1",
            "ref_rel": "source/mont_brasier_sommet_v1/references/h19p01_moltres_crater_native.png",
            "ref_label": "Référence PMD Red — Cime de Sulfura (H19P01 1×)",
            "zip_rel": ".cache/virtual_zips/MBA1_PMDO_0.8.12.zip",
            "bg_fill": "#361207",
            "subtitle": "1× Natif GBA Cime du Mont Brasier — Sulfura (H19P01) — Cratère concentrique en fusion #FF00FF, fumerolles H19P011.bpa, fumées H19P01W & braises W04",
            "wind_summary": "Cratère concentrique GBA H19P01.bpl #FF00FF (12f @ 10t) | Fumerolles H19P011.bpa | Panaches H19P01W | Flammèches GBA W04 Top",
        },
        {
            "id": "MFE1",
            "group": "Oiseaux Légendaires · Électhor",
            "folder": "mont_foudre_entree_v1",
            "ref_rel": "source/mont_foudre_entree_v1/references/d06p01_mt_thunder_native.png",
            "ref_label": "Référence PMD Red — Mont Foudre Entrée (D06P01 1×)",
            "zip_rel": ".cache/virtual_zips/MFE1_PMDO_0.8.12.zip",
            "bg_fill": "#221d15",
            "subtitle": "1× Natif GBA Mont Foudre — Entrée (D06P01) — Canyon sablonneux, falaises de quartz électrisées #FF00FF, arbres morts noueux, grotte Nord & arcs H17P01W",
            "wind_summary": "Crêtes de quartz électrisées & grotte d'orage #FF00FF (12f @ 10t) | Arcs & étincelles GBA H17P01W (15f @ 8t) | Canyon & arbres D06P01 1× statiques",
        },
        {
            "id": "MFA1",
            "group": "Oiseaux Légendaires · Électhor",
            "folder": "mont_foudre_sommet_v1",
            "ref_rel": "source/mont_foudre_sommet_v1/references/h17p01_thunder_meadow_native.png",
            "ref_label": "Référence PMD Red — Cime du Mont Foudre / Électhor (H17P01 1×)",
            "zip_rel": ".cache/virtual_zips/MFA1_PMDO_0.8.12.zip",
            "bg_fill": "#263638",
            "subtitle": "1× Natif GBA Cime du Mont Foudre — Électhor (H17P01) — Ciel d'orage & faille centrale #FF00FF (27 frames H17P01.bpl), arbre foudroyé & arcs H17P01W",
            "wind_summary": "Flash d'orage GBA H17P01.bpl #FF00FF (12f @ 10t) | Foudre de faille & arcs GBA H17P01W (15f @ 8t) | Arbre foudroyé & blocs ardoise 1× statiques",
        },
        {
            "id": "MLE1",
            "group": "Oiseaux Légendaires · Ho-Oh",
            "folder": "mont_lointain_entree_v1",
            "ref_rel": "source/mont_lointain_entree_v1/references/h05p02_rainbow_peak_native.png",
            "ref_label": "Référence PMD Red — Mont Lointain / Rainbow Peak (H05P02 1×)",
            "zip_rel": ".cache/virtual_zips/MLE1_PMDO_0.8.12.zip",
            "bg_fill": "#7ee0f5",
            "subtitle": "1× Natif GBA Mont Lointain — Entrée (H05P02) — Massif karstique sacré, grand escalier & portail Nord, mer de nuages dorés & 4 arcs-en-ciel #FF00FF",
            "wind_summary": "Mer de nuages dorés H05P02 #FF00FF (12f @ 10t) | Quadruple arc-en-ciel pixel-art H05P02 (12f @ 10t) | Éclats irisés Ho-Oh Top | Karst & fougères 1× statiques",
        },
        {
            "id": "MLS1",
            "group": "Oiseaux Légendaires · Ho-Oh",
            "folder": "mont_lointain_sommet_v1",
            "ref_rel": "source/mont_lointain_sommet_v1/references/b72_mt_faraway_hooh.png",
            "ref_label": "Référence PMD Red — Sommet Mont Lointain Ho-Oh (B72 1:1)",
            "zip_rel": ".cache/virtual_zips/MLS1_PMDO_0.8.12.zip",
            "bg_fill": "#7ee0f5",
            "subtitle": "1:1 Natif GBA Sommet du Mont Lointain — Ho-Oh (B72 + H05P02) — Plateau sacré d'ivoire 1:1, 12 piliers karstiques moussus, nuages dorés & arcs-en-ciel #FF00FF",
            "wind_summary": "Mer de nuages dorés B72 #FF00FF (12f @ 10t) | Arcs-en-ciel pixel-art H05P02 1:1 (12f @ 10t) | Plumes irisées Top | Plateau B72 1:1 statique",
        },
        {
            "id": "TCE1",
            "group": "Tour Céleste · Rayquaza",
            "folder": "tour_celeste_entree_v1",
            "ref_rel": "source/tour_celeste_entree_v1/references/ref_entree_tornades_user.png",
            "ref_label": "Référence Tour Céleste — Entrée (D13P01 Tornades 1×)",
            "zip_rel": ".cache/virtual_zips/TCE1_PMDO_0.8.12.zip",
            "bg_fill": "#0040e0",
            "subtitle": "POV PMD Tour Céleste — Entrée (D13P01) — Chemin de nuage continu Sud-Nord, portail Nord & 2 tornades géantes Chunsoft en rotation 3D 360° sur leur axe",
            "wind_summary": "Tornade Gauche 3D 360° (24f @ 5t) | Tornade Droite 3D 360° (24f @ 5t) | Crochets d'écume 3D Top (24f) | Nuages 100 % statiques",
        },
        {
            "id": "STC1",
            "group": "Tour Céleste · Rayquaza",
            "folder": "tour_celeste_sommet_v1",
            "ref_rel": "source/tour_celeste_sommet_v1/references/ref_sommet_planete_rayquaza.png",
            "ref_label": "Référence Sommet Planète & Couronne Nuageuse",
            "zip_rel": ".cache/virtual_zips/STC1_PMDO_0.8.12.zip",
            "bg_fill": "#040a34",
            "subtitle": "Fond Planète Terre & Cosmos étoilé + Tour cumulonimbus, cuvette d'arène, croissants, pont Sud-Nord & cumulus Top fidèles à la référence",
            "wind_summary": "Statiques (1 pose) : Planète Terre & alizés, cumulonimbus, cuvette & pont, cumulus Top | Animés : Cosmos étoilé & reflets D13P01.bpl",
        },
    ]

    manifest_maps: List[Dict] = []
    for item in specs:
        mid = item["id"]
        folder = item["folder"]
        out_dir = STUDIO_CACHE / mid
        out_dir.mkdir(parents=True, exist_ok=True)
        # Nettoie les anciens filmstrips obsolètes éventuels dans out_dir
        for old_p in out_dir.glob("*.png"):
            old_p.unlink()

        mod = _load_builder(folder)
        built = mod.build_layers_for_size()
        layers, walk_grid = built[0], built[1]
        meta = json.loads((REPO_ROOT / "renders" / folder / "metadata.json").read_text(encoding="utf-8"))

        layer_entries = []
        for idx, layer in enumerate(layers):
            n_poses = len(layer.frames)
            w, h = layer.frames[0].size
            # Grille 2D compacte (`cols <= 6` => largeur max `4608 px << 8192 px` limite GPU WebGL/Canvas !)
            cols = min(n_poses, MAX_STRIP_COLS)
            rows = max(1, math.ceil(n_poses / cols))
            strip = Image.new("RGBA", (w * cols, h * rows), (0, 0, 0, 0))
            for t, fr in enumerate(layer.frames):
                cx_t = (t % cols) * w
                cy_t = (t // cols) * h
                strip.paste(fr, (cx_t, cy_t))
            strip_path = out_dir / f"{layer.slug}.png"
            strip.save(strip_path, format="PNG", optimize=False, compress_level=6)
            sheet_key = f"{mid}_{idx:02d}_{layer.slug.upper()}"
            strip_rel = f".cache/studio_layers/{mid}/{layer.slug}.png"
            static_rel = f"renders/{folder}/layers/{layer.slug}.png"
            layer_entries.append(
                {
                    "index": idx,
                    "slug": layer.slug,
                    "name": layer.name,
                    "kind": meta["layers"][idx]["kind"],
                    "poses": n_poses,
                    "cols": cols,
                    "rows": rows,
                    "frame_length": meta["layers"][idx].get("frame_length", 5),
                    "unique_tiles": meta["unique_tiles_per_sheet"].get(sheet_key, 0),
                    "strip_url": _versioned_url(strip_rel),
                    "static_url": _versioned_url(static_rel),
                }
            )

        manifest_maps.append(
            {
                "id": mid,
                "group": item["group"],
                "title": meta["title"],
                "subtitle": item["subtitle"],
                "wind_summary": item["wind_summary"],
                "bg_fill": item["bg_fill"],
                "ref_label": item["ref_label"],
                "folder": folder,
                "width": meta["size_px"][0],
                "height": meta["size_px"][1],
                "n_frames": meta["n_frames"],
                "frame_ticks": meta["frame_ticks"],
                "fidelity": meta["fidelity_distance"],
                "walkable_tiles": meta["walkable_tiles"],
                "total_tiles": meta["total_tiles"],
                "total_unique_tiles": meta["total_unique_tiles"],
                "zip_bytes": meta["zip_bytes"],
                "zip_url": _versioned_url(item["zip_rel"]),
                "ref_url": _versioned_url(item["ref_rel"]),
                "webp_url": _versioned_url(f"renders/{folder}/animation_24frames.webp"),
                "pose0_url": _versioned_url(f"renders/{folder}/composite_pose0.png"),
                "walk_grid": walk_grid.astype(int).tolist(),
                "layers": layer_entries,
            }
        )
        print(f"[Studio] {mid}: {len(layer_entries)} filmstrips 2D écrits dans {out_dir}")

    return {"maps": manifest_maps}


def build_html(manifest: Dict, default_map_id: str = "MMA1") -> str:
    manifest_json = json.dumps(manifest, ensure_ascii=False)
    return f"""<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="utf-8" />
  <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
  <meta http-equiv="Pragma" content="no-cache" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Studio Multicalque PMDO 0.8.12.0 — 19 Maps Légendaires (190 Calques Temps Réel)</title>
  <style>
    :root {{
      --bg: #0b1020;
      --panel: #141e38;
      --panel-2: #1b294c;
      --border: #314b82;
      --accent: #ff944d;
      --accent-2: #ffd180;
      --ok: #5be39b;
      --text: #f3f6ff;
      --muted: #a6b7d8;
    }}
    * {{ box-sizing: border-box; }}
    body {{
      margin: 0;
      font-family: Inter, system-ui, -apple-system, Segoe UI, Roboto, sans-serif;
      background: radial-gradient(circle at 50% 0%, #24182c 0%, var(--bg) 68%);
      color: var(--text);
      min-height: 100vh;
    }}
    header {{
      padding: 14px 22px;
      border-bottom: 1px solid var(--border);
      background: rgba(12, 18, 36, 0.96);
      display: flex;
      flex-direction: column;
      gap: 10px;
    }}
    .header-top {{
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
    }}
    header h1 {{
      margin: 0;
      font-size: 1.15rem;
      letter-spacing: 0.01em;
    }}
    header p {{
      margin: 3px 0 0;
      color: var(--muted);
      font-size: 0.84rem;
    }}
    .map-tabs {{
      display: flex;
      gap: 6px;
      flex-wrap: wrap;
      align-items: center;
    }}
    .map-tab {{
      background: var(--panel);
      color: var(--text);
      border: 1px solid var(--border);
      border-radius: 7px;
      padding: 6px 11px;
      font-weight: 700;
      font-size: 0.79rem;
      cursor: pointer;
    }}
    .map-tab.active {{
      background: linear-gradient(180deg, #b83b14, #7a2108);
      border-color: var(--accent-2);
      color: #fff;
    }}
    main {{
      max-width: 1480px;
      margin: 0 auto;
      padding: 18px 24px 40px;
      display: grid;
      grid-template-columns: minmax(0, 1fr) 395px;
      gap: 20px;
      align-items: start;
    }}
    @media (max-width: 1120px) {{
      main {{ grid-template-columns: 1fr; }}
    }}
    .stage-card, .side-card {{
      background: rgba(20, 30, 56, 0.93);
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 16px;
    }}
    .stage-top {{
      display: flex;
      flex-wrap: wrap;
      justify-content: space-between;
      align-items: center;
      gap: 10px;
      margin-bottom: 12px;
    }}
    .wind-pill {{
      background: var(--panel-2);
      border: 1px solid var(--border);
      padding: 6px 11px;
      border-radius: 7px;
      font-size: 0.8rem;
      color: var(--accent-2);
    }}
    .warn-banner {{
      display: none;
      margin-bottom: 10px;
      padding: 7px 12px;
      border-radius: 7px;
      background: #4e2a0c;
      border: 1px solid var(--accent-2);
      color: #ffe7ba;
      font-size: 0.8rem;
      justify-content: space-between;
      align-items: center;
      gap: 10px;
    }}
    .warn-banner.visible {{ display: flex; }}
    .canvas-wrap {{
      display: flex;
      gap: 14px;
      flex-wrap: wrap;
      justify-content: center;
      align-items: center;
      background: #060912;
      border: 1px solid #243864;
      border-radius: 10px;
      padding: 12px;
      overflow-x: auto;
    }}
    canvas, .ref-preview {{
      image-rendering: pixelated;
      image-rendering: crisp-edges;
      border-radius: 4px;
      max-width: 100%;
      height: auto;
      box-shadow: 0 8px 28px rgba(0, 0, 0, 0.6);
    }}
    .ref-box {{
      display: none;
      flex-direction: column;
      align-items: center;
      gap: 6px;
    }}
    .ref-box.visible {{ display: flex; }}
    .ref-caption {{
      font-size: 0.78rem;
      color: var(--muted);
    }}
    .controls {{
      margin-top: 14px;
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      gap: 10px;
      padding-top: 12px;
      border-top: 1px solid #243c6a;
    }}
    button.ctrl {{
      background: var(--panel-2);
      color: var(--text);
      border: 1px solid var(--border);
      border-radius: 7px;
      padding: 7px 12px;
      font-size: 0.84rem;
      cursor: pointer;
    }}
    button.ctrl.active {{
      background: #9e3816;
      border-color: var(--accent-2);
    }}
    input[type="range"] {{
      flex: 1;
      min-width: 150px;
      accent-color: var(--accent);
    }}
    .metrics {{
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 8px;
      margin-bottom: 14px;
    }}
    .metric {{
      background: var(--panel-2);
      border: 1px solid #294375;
      border-radius: 8px;
      padding: 9px 11px;
    }}
    .metric .k {{ font-size: 0.74rem; color: var(--muted); }}
    .metric .v {{ font-size: 0.98rem; font-weight: 700; margin-top: 2px; color: var(--ok); }}
    .layer-list {{
      display: flex;
      flex-direction: column;
      gap: 6px;
      max-height: 430px;
      overflow-y: auto;
    }}
    .layer-row {{
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 8px;
      padding: 7px 9px;
      background: var(--panel-2);
      border: 1px solid #264070;
      border-radius: 7px;
      font-size: 0.82rem;
    }}
    .layer-row label {{
      display: flex;
      align-items: center;
      gap: 8px;
      cursor: pointer;
      flex: 1;
    }}
    .badge {{
      font-size: 0.71rem;
      padding: 2px 6px;
      border-radius: 5px;
      background: #233c6b;
      color: #cfe2ff;
      white-space: nowrap;
    }}
    .badge.anim {{
      background: #5b2512;
      color: #ffd180;
    }}
    .dl-btn {{
      display: block;
      width: 100%;
      text-align: center;
      margin-top: 14px;
      padding: 11px 14px;
      background: linear-gradient(180deg, #c24116, #842608);
      color: #fff;
      text-decoration: none;
      font-weight: 700;
      font-size: 0.88rem;
      border-radius: 8px;
      border: 1px solid var(--accent-2);
    }}
    .status-line {{
      font-size: 0.8rem;
      color: var(--muted);
    }}
  </style>
</head>
<body>
  <header>
    <div class="header-top">
      <div>
        <h1 id="headerTitle">Studio Multicalque 24 Poses · PMDO 0.8.12.0</h1>
        <p id="mapSubtitle">Chargement des planches pixel-art...</p>
      </div>
      <div class="status-line">19 Cartes · 190 Calques Temps Réel · Grille 2D GPU-Safe</div>
    </div>
    <nav class="map-tabs" id="mapTabs"></nav>
  </header>

  <main>
    <section class="stage-card">
      <div class="stage-top">
        <div class="wind-pill" id="windSummary"></div>
        <div class="status-line" id="loadStatus">Chargement des calques...</div>
      </div>

      <div class="warn-banner" id="terrainWarn">
        <span>Les calques de terrain statiques (roche/sol/grotte) sont masqués.</span>
        <button class="ctrl active" id="restoreTerrainBtn" style="padding:4px 9px; font-size:0.76rem;">Réafficher tout le terrain</button>
      </div>

      <div class="canvas-wrap">
        <canvas id="stageCanvas" width="768" height="576"></canvas>
        <div class="ref-box" id="refBox">
          <img id="refImg" class="ref-preview" width="384" height="288" alt="Référence canonique GBA" />
          <div class="ref-caption" id="refCaption">Référence canonique GBA</div>
        </div>
      </div>

      <div class="controls">
        <button class="ctrl active" id="playBtn">⏸ Pause</button>
        <span id="frameLabel" style="font-variant-numeric: tabular-nums; font-size:0.85rem; min-width:96px;">Pose 00 / 23</span>
        <input type="range" id="frameSlider" min="0" max="23" value="0" />
        <button class="ctrl" data-speed="0.5">0.5×</button>
        <button class="ctrl active" data-speed="1">1× (60 FPS / 5 ticks)</button>
        <button class="ctrl" data-speed="2">2×</button>
        <button class="ctrl" id="collBtn">Collisions Sud-Nord</button>
        <button class="ctrl" id="refBtn">Référence GBA</button>
      </div>
    </section>

    <aside class="side-card">
      <div class="metrics" id="metricsBox"></div>
      <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
        <strong style="font-size:0.9rem;">Calques natifs (10 couches)</strong>
        <div style="display:flex; gap:6px;">
          <button class="ctrl active" id="allOnBtn" style="padding:4px 8px; font-size:0.76rem;">Tout afficher</button>
          <button class="ctrl" id="animOnlyBtn" style="padding:4px 8px; font-size:0.76rem;">Isoler animés</button>
        </div>
      </div>
      <div class="layer-list" id="layerList"></div>
      <a class="dl-btn" id="zipDownload" href="#" download>Télécharger le package .rsground</a>
    </aside>
  </main>

  <script>
    const MANIFEST = {manifest_json};
    const DEFAULT_ID = "{default_map_id}";
    let m = MANIFEST.maps.find((x) => x.id === (location.hash.replace('#', '') || DEFAULT_ID)) || MANIFEST.maps[0];
    let playing = true;
    let speedMul = 1.0;
    let showCollisions = false;
    let showRef = false;
    let poseIdx = 0;
    let lastStepMs = performance.now();
    let loadToken = 0;
    const layerEnabled = new Map();

    const canvas = document.getElementById('stageCanvas');
    const ctx = canvas.getContext('2d');
    ctx.imageSmoothingEnabled = false;

    function loadImg(url) {{
      return new Promise((resolve) => {{
        const im = new Image();
        im.onload = () => resolve(im);
        im.onerror = () => resolve(null);
        im.src = url;
      }});
    }}

    function releaseInactiveMaps(activeId) {{
      MANIFEST.maps.forEach((mp) => {{
        if (mp.id === activeId) return;
        mp.layers.forEach((L) => {{
          if (L._img) {{
            L._img.src = '';
            L._img = null;
          }}
        }});
      }});
    }}

    function updateTerrainWarning() {{
      const anyStaticHidden = m.layers.some((L) => L.poses === 1 && !layerEnabled.get(`${{m.id}}:${{L.slug}}`));
      document.getElementById('terrainWarn').classList.toggle('visible', anyStaticHidden);
      document.getElementById('allOnBtn').classList.toggle('active', !anyStaticHidden);
      document.getElementById('animOnlyBtn').classList.toggle('active', anyStaticHidden);
    }}

    function buildTabs() {{
      const tabsEl = document.getElementById('mapTabs');
      tabsEl.innerHTML = '';
      MANIFEST.maps.forEach((item) => {{
        const btn = document.createElement('button');
        btn.className = 'map-tab' + (item.id === m.id ? ' active' : '');
        btn.textContent = `${{item.id}} · ${{item.title}}`;
        btn.addEventListener('click', () => selectMap(item.id));
        tabsEl.appendChild(btn);
      }});
    }}

    async function selectMap(mapId) {{
      const found = MANIFEST.maps.find((x) => x.id === mapId);
      if (!found) return;
      m = found;
      history.replaceState(null, '', '#' + m.id);
      poseIdx = 0;
      buildTabs();
      await initMap();
    }}

    async function initMap() {{
      const myToken = ++loadToken;
      releaseInactiveMaps(m.id);

      canvas.width = m.width;
      canvas.height = m.height;
      ctx.imageSmoothingEnabled = false;

      document.getElementById('headerTitle').innerHTML = `${{m.title}} (<code>${{m.id}}</code> · 10 Calques · PMDO 0.8.12.0)`;
      document.getElementById('mapSubtitle').textContent = m.subtitle;
      document.getElementById('windSummary').textContent = m.wind_summary;
      document.getElementById('refImg').src = m.ref_url;
      document.getElementById('refCaption').textContent = m.ref_label;
      const dl = document.getElementById('zipDownload');
      dl.href = m.zip_url;
      dl.textContent = `⬇ Télécharger ${{m.id}}_PMDO_0.8.12.zip (${{(m.zip_bytes / 1048576).toFixed(2)}} Mio)`;

      document.getElementById('metricsBox').innerHTML = `
        <div class="metric"><div class="k">Fidélité canonique</div><div class="v">${{m.fidelity.toFixed(2)}}</div></div>
        <div class="metric"><div class="k">Cycle sans couture</div><div class="v">${{m.n_frames}} poses (${{m.n_frames * m.frame_ticks}} ticks)</div></div>
        <div class="metric"><div class="k">Tuiles praticables</div><div class="v">${{m.walkable_tiles}} / ${{m.total_tiles}}</div></div>
        <div class="metric"><div class="k">Tuiles uniques GPU</div><div class="v">${{m.total_unique_tiles.toLocaleString('fr-FR')}}</div></div>
      `;

      const listEl = document.getElementById('layerList');
      listEl.innerHTML = '';
      m.layers.forEach((L) => {{
        const key = `${{m.id}}:${{L.slug}}`;
        if (!layerEnabled.has(key)) layerEnabled.set(key, true);
        const row = document.createElement('div');
        row.className = 'layer-row';
        const isAnim = L.poses > 1;
        row.innerHTML = `
          <label>
            <input type="checkbox" data-key="${{key}}" ${{layerEnabled.get(key) ? 'checked' : ''}} />
            <span><strong>${{String(L.index).padStart(2, '0')}}</strong> ${{L.name}}</span>
          </label>
          <span class="badge ${{isAnim ? 'anim' : ''}}">${{L.kind}} · ${{L.poses}}p@${{L.frame_length || 5}}t · ${{L.unique_tiles}}t</span>
        `;
        row.querySelector('input').addEventListener('change', (ev) => {{
          layerEnabled.set(key, ev.target.checked);
          updateTerrainWarning();
          renderCurrentFrame();
        }});
        listEl.appendChild(row);
      }});
      updateTerrainWarning();

      const statusEl = document.getElementById('loadStatus');
      // Affiche immédiatement le composite pose0 pendant le décodage des calques 2D !
      const pose0Preview = await loadImg(m.pose0_url);
      if (myToken !== loadToken) return;
      if (pose0Preview) {{
        ctx.drawImage(pose0Preview, 0, 0, m.width, m.height);
      }}

      let loaded = 0;
      await Promise.all(m.layers.map(async (L) => {{
        if (!L._img) {{
          const strip = await loadImg(L.strip_url);
          L._img = strip || await loadImg(L.static_url);
          L._isStrip = Boolean(strip);
        }}
        loaded += 1;
        if (myToken === loadToken) {{
          statusEl.textContent = `Calques chargés : ${{loaded}} / ${{m.layers.length}}`;
        }}
      }}));
      if (myToken !== loadToken) return;
      statusEl.textContent = `✓ ${{m.layers.length}} / ${{m.layers.length}} calques temps réel prêts (échelle 1:1)`;
      renderCurrentFrame();
    }}

    let hwTick = 0;

    function renderCurrentFrame() {{
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      ctx.fillStyle = m.bg_fill || '#050b18';
      ctx.fillRect(0, 0, canvas.width, canvas.height);

      for (const L of m.layers) {{
        const key = `${{m.id}}:${{L.slug}}`;
        if (!layerEnabled.get(key) || !L._img) continue;
        if (L._isStrip && L.poses > 1) {{
          const fl = L.frame_length || m.frame_ticks || 5;
          const frame = Math.floor(hwTick / fl) % L.poses;
          const cols = L.cols || 6;
          let sx = (frame % cols) * m.width;
          let sy = Math.floor(frame / cols) * m.height;
          if (sx + m.width > L._img.naturalWidth || sy + m.height > L._img.naturalHeight) {{
            sx = 0;
            sy = 0;
          }}
          ctx.drawImage(L._img, sx, sy, m.width, m.height, 0, 0, m.width, m.height);
        }} else {{
          ctx.drawImage(L._img, 0, 0, m.width, m.height);
        }}
      }}

      if (showCollisions && m.walk_grid) {{
        ctx.fillStyle = 'rgba(72, 255, 168, 0.30)';
        const gh = m.walk_grid.length;
        const gw = m.walk_grid[0].length;
        for (let gy = 0; gy < gh; gy++) {{
          for (let gx = 0; gx < gw; gx++) {{
            if (m.walk_grid[gy][gx]) ctx.fillRect(gx * 8, gy * 8, 7, 7);
          }}
        }}
      }}

      poseIdx = Math.floor(hwTick / (m.frame_ticks || 5)) % m.n_frames;
      document.getElementById('frameLabel').textContent = `Pose ${{String(poseIdx).padStart(2, '0')}} / ${{m.n_frames - 1}} (tick ${{hwTick}})`;
      document.getElementById('frameSlider').value = String(poseIdx);
    }}

    function tick(now) {{
      const intervalMs = (1000 / 60) / speedMul;
      if (playing && (now - lastStepMs) >= intervalMs) {{
        const steps = Math.max(1, Math.min(4, Math.floor((now - lastStepMs) / intervalMs)));
        hwTick = (hwTick + steps) % 34560;
        lastStepMs = now;
        renderCurrentFrame();
      }}
      requestAnimationFrame(tick);
    }}

    function setAllLayers(val) {{
      m.layers.forEach((L) => layerEnabled.set(`${{m.id}}:${{L.slug}}`, val ? true : L.poses > 1));
      document.querySelectorAll('#layerList input[type="checkbox"]').forEach((c, idx) => {{
        c.checked = val ? true : m.layers[idx].poses > 1;
      }});
      updateTerrainWarning();
      renderCurrentFrame();
    }}

    document.getElementById('playBtn').addEventListener('click', (e) => {{
      playing = !playing;
      e.target.textContent = playing ? '⏸ Pause' : '▶ Lecture';
      e.target.classList.toggle('active', playing);
    }});
    document.getElementById('frameSlider').addEventListener('input', (e) => {{
      poseIdx = Number(e.target.value);
      hwTick = poseIdx * (m.frame_ticks || 5);
      renderCurrentFrame();
    }});
    document.querySelectorAll('[data-speed]').forEach((btn) => {{
      btn.addEventListener('click', () => {{
        speedMul = Number(btn.dataset.speed);
        document.querySelectorAll('[data-speed]').forEach((b) => b.classList.toggle('active', b === btn));
      }});
    }});
    document.getElementById('collBtn').addEventListener('click', (e) => {{
      showCollisions = !showCollisions;
      e.target.classList.toggle('active', showCollisions);
      renderCurrentFrame();
    }});
    document.getElementById('refBtn').addEventListener('click', (e) => {{
      showRef = !showRef;
      e.target.classList.toggle('active', showRef);
      document.getElementById('refBox').classList.toggle('visible', showRef);
    }});
    document.getElementById('allOnBtn').addEventListener('click', () => setAllLayers(true));
    document.getElementById('restoreTerrainBtn').addEventListener('click', () => setAllLayers(true));
    document.getElementById('animOnlyBtn').addEventListener('click', () => setAllLayers(false));

    buildTabs();
    initMap().then(() => requestAnimationFrame(tick));
  </script>
</body>
</html>
"""


def main() -> None:
    manifest = export_filmstrips()
    (REPO_ROOT / "index.html").write_text(build_html(manifest, default_map_id="TWE1"), encoding="utf-8")
    (REPO_ROOT / "apercu_forets_pmd_red_pmdo.html").write_text(
        build_html(manifest, default_map_id="TWE1"), encoding="utf-8"
    )
    (REPO_ROOT / "apercu_zekrom_tornade_pmdo.html").write_text(
        build_html(manifest, default_map_id="ZKA1"), encoding="utf-8"
    )
    (REPO_ROOT / "apercu_reshiram_flamme_pmdo.html").write_text(
        build_html(manifest, default_map_id="RSA1"), encoding="utf-8"
    )
    (REPO_ROOT / "apercu_mine_magma_multicalque_pmdo.html").write_text(
        build_html(manifest, default_map_id="MMA1"), encoding="utf-8"
    )
    (REPO_ROOT / "apercu_oiseaux_legendaires_pmdo.html").write_text(
        build_html(manifest, default_map_id="FGE1"), encoding="utf-8"
    )
    (REPO_ROOT / "apercu_tour_celeste_trilogie_pmdo.html").write_text(
        build_html(manifest, default_map_id="TCE1"), encoding="utf-8"
    )
    (REPO_ROOT / "apercu_sommet_tour_celeste_stc1_pmdo.html").write_text(
        build_html(manifest, default_map_id="STC1"), encoding="utf-8"
    )
    (REPO_ROOT / "apercu_faille_spatiale_palkia_pmdo.html").write_text(
        build_html(manifest, default_map_id="FSE1"), encoding="utf-8"
    )
    print("[Studio] index.html et les aperçus dédiés générés (23 cartes, 230 calques 60 FPS, grilles 2D <= 4608px).")


if __name__ == "__main__":
    main()
