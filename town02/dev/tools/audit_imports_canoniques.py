#!/usr/bin/env python3
"""Contrôle les contrats de provenance des imports Rescue Team / EoS.

Un asset canonique peut garder un identifiant technique historique pour les
sauvegardes, mais ne doit pas être détourné vers un autre lieu/légendaire.
"""
from __future__ import annotations
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def load(path: Path):
    with path.open(encoding="utf-8-sig") as fh:
        return json.load(fh)["Object"]

errors: list[str] = []
warns: list[str] = []

def require_file(rel: str):
    if not (ROOT / rel).exists():
        errors.append(f"fichier canonique absent: {rel}")

# Aegis Cave : ID technique conservé, identité publique et place Ch5 imposées.
aegis = load(ROOT / "Data/Zone/cloven_ruins.json")
if aegis["Name"].get("DefaultText") != "Aegis Cave":
    errors.append("cloven_ruins: nom public différent de Aegis Cave")
for map_id in ("cloven_ruins_regice", "cloven_ruins_regirock", "cloven_ruins_registeel", "sanctuaire_titans"):
    require_file(f"Data/Map/{map_id}.rsmap")
for expected, segment in (("cloven_ruins_regice", 1), ("cloven_ruins_regirock", 3),
                          ("cloven_ruins_registeel", 5), ("sanctuaire_titans", 7)):
    text = json.dumps(aegis["Segments"][segment], ensure_ascii=False)
    if f'"MapID": "{expected}"' not in text:
        errors.append(f"Aegis Cave segment {segment}: arène attendue {expected} absente")

# Sky Tower Rescue Team : triptyque D13P01/02/03 et Rayquaza.
sky = load(ROOT / "Data/Zone/sky_tower.json")
for ground in ("parvis_celeste", "palier_celeste", "tour_ciel_sommet"):
    require_file(f"Data/Ground/{ground}.rsground")
    if ground not in sky.get("GroundMaps", []):
        errors.append(f"sky_tower: ground canonique non déclaré: {ground}")
for map_id in ("parvis_celeste", "palier_celeste", "tour_ciel_sommet"):
    require_file(f"Data/Map/{map_id}.rsmap")

# Treasure Town complète existe en réserve mais n'est pas encore restituée.
require_file("RESERVE/sky_grounds/sky_t01p01a.rsground")
require_file("RESERVE/sky_tiles/sky_t01p01a_Base.tile")
bourg = load(ROOT / "Data/Ground/bourg_comptoir.rsground")
if len(bourg.get("obstacles", [])) != 84:
    warns.append("Treasure Town: bourg_comptoir est encore la carte partielle, pas sky_t01p01a 84x63")

# Un Ground canonique et son donjon forment un paquet indivisible.
# Ces branchements croisés sont mesurés dans les métadonnées du dépôt.
waterfall = load(ROOT / "Data/Zone/waterfall_pond.json")
if "sanctuaire_voeu" in json.dumps(waterfall, ensure_ascii=False):
    errors.append("détournement canonique: Wish Cave/Jirachi D23P01 est branché dans waterfall_pond/Diancie")

gloomy = load(ROOT / "Data/Zone/gloomy_forest.json")
if "gloomy_forest_entrance" in gloomy.get("GroundMaps", []):
    ground = load(ROOT / "Data/Ground/gloomy_forest_entrance.rsground")
    if "D04P01" in (ground.get("Comment") or ""):
        errors.append("détournement canonique: Sinister Woods D04P01 est l'entrée de gloomy_forest/Zeraora")

mount = load(ROOT / "Data/Zone/mount_windswept.json")
if "mount_windswept_guardian" in mount.get("GroundMaps", []):
    ground = load(ROOT / "Data/Ground/mount_windswept_guardian.rsground")
    if "D18P01" in (ground.get("Comment") or ""):
        errors.append("détournement canonique: Northwind Field/Articuno D18P01 sert d'arène à Tornadus")

poison = load(ROOT / "Data/Zone/poisonous_forest.json")
if "poisonous_forest_boss" in poison.get("GroundMaps", []):
    ground = load(ROOT / "Data/Ground/poisonous_forest_boss.rsground")
    if "H12P01" in (ground.get("Comment") or ""):
        errors.append("détournement canonique: Poison Swamp Friend Area H12P01 sert de boss ground à poisonous_forest")

print("AUDIT IMPORTS CANONIQUES RED/SKY")
for msg in errors:
    print("ERREUR:", msg)
for msg in warns:
    print("AVERTISSEMENT:", msg)
print(f"RESULTAT: {len(errors)} erreur(s), {len(warns)} avertissement(s)")
raise SystemExit(1 if errors else 0)
