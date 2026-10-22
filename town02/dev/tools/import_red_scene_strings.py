#!/usr/bin/env python3
"""Importe le texte canonique des scènes PMD Red dans les Strings du mod.

Les répliques canoniques (extraites de la ROM) sont présentes dans le dépôt
sous `Data/Script/halcyon/arc_fugitif/strings*.resx`, mais le moteur ne les lit
jamais : `Text.FormatKey` interroge `Strings/strings*.resx` (voir
`RogueEssence/Text.cs::loadCulture`). Faute de ce branchement, chaque appel
`STRINGS:FormatKey("SCENE_D06P01_001")` renvoyait la clé elle-même — c'est ce
qui a poussé les passes précédentes à écrire des dialogues inventés.

Ce script recopie les clés `SCENE_D*` (scènes de donjon PMD Red, D01 à D25)
vers `Strings/strings.fr.resx` et `Strings/strings.resx`, sans rien réécrire
d'autre et sans toucher aux clés déjà définies.
"""
from __future__ import annotations

import argparse
import re
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Dict

ROOT = Path(__file__).resolve().parents[1]
SOURCES = {
    "fr": ROOT / "Data/Script/halcyon/arc_fugitif/strings.fr.resx",
    "": ROOT / "Data/Script/halcyon/arc_fugitif/strings.resx",
}
TARGETS = {
    "fr": ROOT / "Strings/strings.fr.resx",
    "": ROOT / "Strings/strings.resx",
}
SCENE_RE = re.compile(r"^SCENE_D\d+P\d+[A-Z]?_\d+$")

RESX_HEADER = """<?xml version="1.0" encoding="utf-8"?>
<root>
  <xsd:schema id="root" xmlns="" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
    <xsd:element name="root" msdata:IsDataSet="true">
      <xsd:complexType>
        <xsd:choice maxOccurs="unbounded">
          <xsd:element name="data">
            <xsd:complexType>
              <xsd:sequence>
                <xsd:element name="value" type="xsd:string" minOccurs="0" msdata:Ordinal="1" />
                <xsd:element name="comment" type="xsd:string" minOccurs="0" msdata:Ordinal="2" />
              </xsd:sequence>
              <xsd:attribute name="name" type="xsd:string" use="required" msdata:Ordinal="0" />
              <xsd:attribute name="xml:space" type="xsd:string" />
            </xsd:complexType>
          </xsd:element>
        </xsd:choice>
      </xsd:complexType>
    </xsd:element>
  </xsd:schema>
  <resheader name="resmimetype"><value>text/microsoft-resx</value></resheader>
  <resheader name="version"><value>2.0</value></resheader>
  <resheader name="reader"><value>System.Resources.ResXResourceReader</value></resheader>
  <resheader name="writer"><value>System.Resources.ResXResourceWriter</value></resheader>
"""


def read_resx(path: Path) -> Dict[str, str]:
    if not path.is_file():
        return {}
    values: Dict[str, str] = {}
    root = ET.parse(path).getroot()
    for node in root.findall("data"):
        name = node.get("name")
        value = node.findtext("value")
        if name is not None:
            values[name] = value or ""
    return values


def write_resx(path: Path, values: Dict[str, str]) -> None:
    parts = [RESX_HEADER]
    for name in sorted(values):
        text = (values[name].replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;"))
        parts.append(f'  <data name="{name}" xml:space="preserve">\n    <value>{text}</value>\n  </data>\n')
    parts.append("</root>\n")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("".join(parts), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apply", action="store_true", help="écrire les fichiers")
    args = parser.parse_args()

    total_added = 0
    for lang, source in SOURCES.items():
        canon = {k: v for k, v in read_resx(source).items() if SCENE_RE.match(k)}
        target = TARGETS[lang]
        existing = read_resx(target)
        added = {k: v for k, v in canon.items() if k not in existing}
        merged = dict(existing)
        merged.update(added)
        label = target.relative_to(ROOT)
        print(f"{label}: {len(existing)} clés existantes, {len(canon)} clés canoniques "
              f"disponibles, {len(added)} à ajouter")
        total_added += len(added)
        if args.apply and added:
            write_resx(target, merged)
    if not args.apply:
        print("(simulation : relancer avec --apply)")
    return 0 if total_added or not args.apply else 0


if __name__ == "__main__":
    raise SystemExit(main())
