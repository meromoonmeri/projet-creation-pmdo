#!/usr/bin/env python3
"""Localise les répliques accessibles de FutureArc en français.

Les répliques générées portent un identifiant ``-- FUT_*``. Le mode d'écriture
utilise un modèle Argos en→fr installé localement ; le mode ``--check`` ne
requiert aucune dépendance et convient à la CI. Les contrôles PMDO, variables et
noms officiels sont protégés avant traduction.

Exemple de préparation hors dépôt :
  ARGOS_TRANSLATE_PACKAGES_DIR=/tmp/argos-packages python ...
"""
from __future__ import annotations

import argparse
import json
import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARC = ROOT / "Data/Script/halcyon/future_arc"
SCENES = ARC / "scene"
CACHE_PATH = Path(os.environ.get("FUTURE_FR_CACHE", "/tmp/future_arc_fr_cache.json"))

SINGLE = re.compile(r"(?P<prefix>UI:WaitShowDialogue\()'(?P<body>(?:\\.|[^'\\])*)'(?P<suffix>\))")
DOUBLE = re.compile(r'(?P<prefix>UI:WaitShowDialogue\()"(?P<body>(?:\\.|[^"\\])*)"(?P<suffix>\))')
CONTROL = re.compile(r"\[[^\]]+\]|\{[^}]+\}|\\u[0-9A-Fa-f]{4}")

# Les formes officielles françaises sont réinjectées après la traduction.
# Les expressions les plus longues passent en premier.
GLOSSARY = [
    (r"\bthe planet's paralysis\b", "la Paralysie de la Planète"),
    (r"\bparalysis of the planet\b", "la Paralysie de la Planète"),
    (r"\bDimensional Scream\b", "Cri Dimensionnel"),
    (r"\bPrimal Dialga\b", "Dialga Primal"),
    (r"\bTime Gears\b", "Rouages du Temps"),
    (r"\bTime Gear\b", "Rouage du Temps"),
    (r"\bTemporal Tower\b", "Tour du Temps"),
    (r"\bHidden Land\b", "Terres Illusoires"),
    (r"\bDusk Forest\b", "Forêt Crépuscule"),
    (r"\bSealed Ruin\b", "Ruines Scellées"),
    (r"\bDark Hill\b", "Colline Sombre"),
    (r"\bChasm Cave\b", "Grotte Abîme"),
    (r"\bPassage of Time\b", "Passage du Temps"),
    (r"\bGrovyle\b", "Massko"),
    (r"\bDusknoir\b", "Noctunoir"),
    (r"\bSableye\b", "Ténéfix"),
    (r"\bSpiritomb\b", "Spiritomb"),
    (r"\bCelebi\b", "Celebi"),
    (r"\bNecrozma\b", "Necrozma"),
    (r"\bDialga\b", "Dialga"),
]

ENGLISH_WORDS = re.compile(
    r"\b(?:the|you|your|we|our|they|their|this|that|what|why|where|who|"
    r"have|has|had|will|would|should|could|can|cannot|are|were|is|was|"
    r"not|don't|didn't|it's|I'm|I've|we're|you're|let's|with|from|for|"
    r"and|because|about|here|there|now|then|when|how)\b",
    re.IGNORECASE,
)


def canonical_modules() -> list[str]:
    text = (ARC / "FutureArc.lua").read_text(encoding="utf-8")
    modules = set(re.findall(r"scene\('[^']+',\s*'([^']+)'", text))
    modules.update(re.findall(r"dungeon\('[^']+',\s*'[^']+',\s*'([^']+)'", text))
    return sorted(module for module in modules if module and module != "nil")


def lua_decode(body: str, quote: str) -> str:
    # Les scripts générés n'emploient que ces échappements dans les répliques.
    replacements = {
        r"\n": "\n", r"\r": "\r", r"\t": "\t",
        r"\\": "\\", "\\'": "'", '\\"': '"',
    }
    return re.sub(r"\\(?:n|r|t|\\|'|\")", lambda m: replacements[m.group(0)], body)


def lua_encode(text: str, quote: str) -> str:
    text = text.replace("\\", "\\\\").replace("\r", "")
    text = text.replace("\n\n", "[br]").replace("\n", " ")
    text = re.sub(r"[ \t]+", " ", text).strip()
    text = text.replace(quote, "\\" + quote)
    return text


TOKEN_NAMES = tuple("MARK" + name + "ZX" for name in (
    "ALPHA", "BRAVO", "CHARLIE", "DELTA", "ECHO", "FOXTROT", "GOLF",
    "HOTEL", "INDIA", "JULIET", "KILO", "LIMA", "MIKE", "NOVEMBER",
    "OSCAR", "PAPA", "QUEBEC", "ROMEO", "SIERRA", "TANGO", "UNIFORM",
    "VICTOR", "WHISKEY", "XRAY", "YANKEE", "ZULU",
))


def protect(text: str) -> tuple[str, list[str]]:
    values: list[str] = []

    def token(value: str) -> str:
        index = len(values)
        if index >= len(TOKEN_NAMES):
            raise ValueError("trop de contrôles dans une même réplique")
        values.append(value)
        # Le suffixe lexical rare ZX et les espaces de séparation empêchent
        # SentencePiece de fusionner ou supprimer la sentinelle.
        return " " + TOKEN_NAMES[index] + " "

    # Vocabulaire avant contrôles. On absorbe aussi sa coloration PMD afin de
    # ne pas envoyer trois sentinelles accolées au modèle.
    for pattern, french in GLOSSARY:
        styled = rf"(?:\[CS:N\])?{pattern}(?:\[CR\])?"
        text = re.sub(
            styled,
            lambda match, value=french: token(
                ("[CS:N]" if match.group(0).startswith("[CS:N]") else "")
                + value
                + ("[CR]" if match.group(0).endswith("[CR]") else "")
            ),
            text,
            flags=re.I,
        )
    text = CONTROL.sub(lambda match: token(match.group(0)), text)
    return text, values


def restore(text: str, values: list[str], protected_source: str) -> str:
    # SentencePiece peut exceptionnellement omettre un vocatif ou un contrôle
    # placé après des points de suspension. On le remet alors à la position
    # proportionnelle la plus proche d'une frontière de mots, sans jamais
    # perdre une variable PMDO.
    missing: list[tuple[int, str]] = []
    for index, _value in enumerate(values):
        placeholder = TOKEN_NAMES[index]
        match = re.search(re.escape(placeholder), text, flags=re.I)
        if match is not None:
            text = text[:match.start()] + placeholder + text[match.end():]
        else:
            source_pos = protected_source.find(placeholder)
            wanted = round(len(text) * source_pos / max(1, len(protected_source)))
            boundaries = [m.start() for m in re.finditer(r"(?<=\s)|(?=\s)|(?<=[.!?…])", text)]
            insert_at = min(boundaries, key=lambda pos: abs(pos - wanted)) if boundaries else wanted
            missing.append((insert_at, placeholder))
    for insert_at, placeholder in sorted(missing, reverse=True):
        text = text[:insert_at] + " " + placeholder + " " + text[insert_at:]

    for index, value in enumerate(values):
        text = text.replace(TOKEN_NAMES[index], value)
    # Contrôles sans largeur : aucune espace visible ne doit être introduite.
    text = re.sub(r"\s*(\[(?:K|br)\])\s*", r"\1", text, flags=re.I)
    text = re.sub(r"(\[CS:[^]]+\])\s+", r"\1", text)
    text = re.sub(r"\s+(\[CR\])", r"\1", text)
    text = re.sub(r"[ \t]+", " ", text).strip()
    return text


def load_cache() -> dict[str, str]:
    if not CACHE_PATH.exists():
        return {}
    try:
        return json.loads(CACHE_PATH.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return {}


def save_cache(cache: dict[str, str]) -> None:
    CACHE_PATH.parent.mkdir(parents=True, exist_ok=True)
    CACHE_PATH.write_text(json.dumps(cache, ensure_ascii=False, indent=2), encoding="utf-8")


def make_translator():
    try:
        from argostranslate import translate
    except ImportError as exc:
        raise SystemExit(
            "argostranslate est requis en mode écriture ; utilisez --check en CI"
        ) from exc
    languages = translate.get_installed_languages()
    source = next((lang for lang in languages if lang.code == "en"), None)
    target = next((lang for lang in languages if lang.code == "fr"), None)
    if source is None or target is None:
        raise SystemExit("modèle Argos en→fr non installé")
    return source.get_translation(target).translate


def polish_french(text: str) -> str:
    """Corrige les artefacts mécaniques sûrs sans réécrire la mise en scène."""
    text = re.sub(r"\s+([,.])", r"\1", text)
    text = re.sub(r"\(\s+", "(", text)
    text = re.sub(r"\s+\)", ")", text)
    replacements = (
        (r"\b(?:Fury Swipes|Swipes Fury)\b", "Combo-Griffe"),
        (r"\bTime Travel Pokémon\b", "Pokémon Temporel"),
        (r"\bTemporal Pokémon\b", "Pokémon du Temps"),
        (r"\b(?:Master|Lord) Necrozma\b", "Maître Necrozma"),
        (r"\bWigglytuff\b", "Grodoudou"),
        (r"\bChatot\b", "Pijako"),
        (r"\bBidoof\b", "Keunotor"),
        (r"\bDig\b", "Tunnel"),
        (r"\bHey\b", "Hé"),
        (r"\bWhoa\b", "Ouah"),
        (r"\bHuh\b", "Hein"),
        (r"\bwhack\b", "contrôle"),
        (r"\bbravado\b", "arrogance"),
        (r"\bflashy\b", "tape-à-l’œil"),
    )
    for pattern, replacement in replacements:
        text = re.sub(pattern, replacement, text, flags=re.I)
    text = text.replace("le Rouages du Temps", "les Rouages du Temps")
    text = text.replace("un Rouages du Temps", "un Rouage du Temps")
    text = text.replace("à Tour du Temps", "à la Tour du Temps")
    return text


def translate_text(source: str, translator, cache: dict[str, str]) -> str:
    # Les retours DS étaient imposés par sa petite fenêtre. On conserve les
    # paragraphes, mais PMDO gère lui-même le retour visuel des lignes simples.
    source = source.replace("\r", "")
    source = source.replace("\n\n", " [br] ").replace("\n", " ")
    source = re.sub(r"\s+", " ", source).strip()
    protected, values = protect(source)
    cache_key = protected
    if cache_key not in cache:
        cache[cache_key] = translator(protected)
        if len(cache) % 25 == 0:
            save_cache(cache)
    result = restore(cache[cache_key], values, protected)
    # Quelques modèles ajoutent une espace avant la ponctuation française ; le
    # moteur l'accepte et cette typographie est correcte.
    return polish_french(result.strip())


def localize_line(line: str, translator, cache: dict[str, str]) -> tuple[str, bool]:
    if "-- FUT_" not in line or "UI:WaitShowDialogue(" not in line:
        return line, False
    if "(FR)" in line and "(FR optionnel)" not in line:
        return line, False
    pattern = SINGLE if SINGLE.search(line) else DOUBLE
    match = pattern.search(line)
    if match is None:
        raise ValueError("réplique FUT non reconnue : " + line.strip())
    quote = "'" if pattern is SINGLE else '"'
    source = lua_decode(match.group("body"), quote)
    target = translate_text(source, translator, cache)
    encoded = lua_encode(target, quote)
    updated = line[:match.start("body")] + encoded + line[match.end("body"):]
    updated = updated.replace("(FR optionnel)", "(FR)")
    return updated, updated != line


def check() -> int:
    failures: list[str] = []
    checked = 0
    for module in canonical_modules():
        path = SCENES / f"{module}.lua"
        if not path.exists():
            failures.append(f"module absent : {path.relative_to(ROOT)}")
            continue
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if "-- FUT_" not in line:
                continue
            checked += 1
            if "FR optionnel" in line:
                failures.append(f"{path.relative_to(ROOT)}:{number}: non localisé")
                continue
            match = SINGLE.search(line) or DOUBLE.search(line)
            if match is None:
                failures.append(f"{path.relative_to(ROOT)}:{number}: forme illisible")
                continue
            body = lua_decode(match.group("body"), "'" if line[match.start("body") - 1] == "'" else '"')
            # Les contrôles et noms sont retirés avant le test lexical.
            visible = CONTROL.sub("", body)
            visible = re.sub(r"\b(?:Massko|Noctunoir|Ténéfix|Celebi|Necrozma|Spiritomb|Dialga)\b", "", visible)
            if ENGLISH_WORDS.search(visible):
                failures.append(f"{path.relative_to(ROOT)}:{number}: anglais probable : {visible[:70]}")
    if failures:
        print("\n".join(failures[:100]))
        if len(failures) > 100:
            print(f"... {len(failures) - 100} autre(s)")
        return 1
    print(f"OK: {checked} répliques FutureArc accessibles sont localisées")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check:
        return check()

    translator = make_translator()
    cache = load_cache()
    changed = 0
    for module in canonical_modules():
        path = SCENES / f"{module}.lua"
        lines = path.read_text(encoding="utf-8").splitlines(keepends=True)
        output: list[str] = []
        for line in lines:
            updated, did_change = localize_line(line, translator, cache)
            output.append(updated)
            changed += int(did_change)
        path.write_text("".join(output), encoding="utf-8")
    save_cache(cache)
    print(f"{changed} répliques localisées ; cache : {CACHE_PATH}")
    return check()


if __name__ == "__main__":
    raise SystemExit(main())
