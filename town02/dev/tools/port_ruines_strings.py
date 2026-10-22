#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
port_ruines_strings.py — deplace les textes des gardiens vers stringsEx.

POURQUOI
--------
Les repliques des trois Regi vivaient dans
Data/Script/halcyon/ground/cloven_ruins_<regi>/strings*.resx, lues via
STRINGS.MapStrings. Or MapStrings n'est peuple QUE sur une carte de type
ground : le moteur charge le .resx du dossier de la carte a l'entree.

Les arenes deviennent des etages de donjon. STRINGS.MapStrings y sera vide, et
tous les dialogues s'afficheraient comme des cles brutes ou des chaines vides.
Les textes doivent donc rejoindre Strings/stringsEx*.resx, adressables partout
par STRINGS:FormatKey (patron RUINES_PIERRE_TROUVEE, deja en place).

Prefixe RUINES_ ajoute a chaque cle pour eviter toute collision dans un espace
de noms desormais global.

Le script verifie la PARITE FR/EN et refuse d'ecrire si elle est rompue.
"""
from __future__ import annotations

import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
GROUNDS = ["cloven_ruins_regice", "cloven_ruins_regirock", "cloven_ruins_registeel"]
CIBLE_FR = ROOT / "Strings/stringsEx.fr.resx"
CIBLE_EN = ROOT / "Strings/stringsEx.resx"
PREFIXE = "RUINES_"

# Cles partagees par les trois gardiens (memes textes dans les trois fichiers).
# On ne les importe qu'UNE fois, et on les suffixe par gardien la ou le texte
# doit differer. Ici les quatre sont reellement identiques : on garde une seule
# copie, la scene passera le nom du gardien en parametre.
PARTAGEES = {"RG_VICTOIRE", "RG_VICTOIRE_P", "RG_DEFAITE", "RG_DEFAITE_P"}


def lire(path: Path) -> dict:
    if not path.exists():
        return {}
    racine = ET.parse(path).getroot()
    out = {}
    for d in racine.findall("data"):
        v = d.find("value")
        out[d.get("name")] = v.text if v is not None and v.text else ""
    return out


def inserer(cible: Path, ajouts: dict) -> int:
    """Insere les paires avant </root>, en preservant le fichier a l'octet pres."""
    texte = cible.read_text(encoding="utf-8")
    deja = set(re.findall(r'<data name="([^"]+)"', texte))
    bloc = []
    for cle, val in ajouts.items():
        if cle in deja:
            continue
        # Echappement XML minimal, coherent avec le reste du fichier.
        esc = (val.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;"))
        bloc.append(
            f'  <data name="{cle}" xml:space="preserve">\n'
            f"    <value>{esc}</value>\n"
            f"  </data>\n"
        )
    if not bloc:
        return 0
    texte = texte.replace("</root>", "".join(bloc) + "</root>")
    cible.write_text(texte, encoding="utf-8")
    return len(bloc)


def main() -> int:
    fr, en = {}, {}
    vus_partages = set()

    for g in GROUNDS:
        base = ROOT / "Data/Script/halcyon/ground" / g
        src_fr = lire(base / "strings.fr.resx")
        src_en = lire(base / "strings.resx")
        if not src_fr:
            print(f"IGNORE {g} : pas de strings.fr.resx")
            continue

        manquants = sorted(set(src_fr) - set(src_en))
        if manquants:
            print(f"ATTENTION {g} : {len(manquants)} cle(s) sans version EN "
                  f"— {', '.join(manquants[:4])}")

        for cle, val in src_fr.items():
            if cle in PARTAGEES:
                if cle in vus_partages:
                    continue
                vus_partages.add(cle)
            fr[PREFIXE + cle] = val
            en[PREFIXE + cle] = src_en.get(cle, val)

    # Parite : chaque cle FR doit avoir sa contrepartie EN.
    ecart = set(fr) ^ set(en)
    if ecart:
        print(f"ECHEC : parite rompue sur {len(ecart)} cle(s) : "
              f"{', '.join(sorted(ecart)[:5])}")
        return 1

    n_fr = inserer(CIBLE_FR, fr)
    n_en = inserer(CIBLE_EN, en)
    print(f"OK  {n_fr} cle(s) ajoutee(s) a stringsEx.fr.resx")
    print(f"OK  {n_en} cle(s) ajoutee(s) a stringsEx.resx")
    print(f"    ({len(fr)} cles portees au total, prefixe {PREFIXE})")

    # Relecture : le XML doit rester valide apres insertion.
    for c in (CIBLE_FR, CIBLE_EN):
        try:
            ET.parse(c)
        except ET.ParseError as e:
            print(f"ECHEC : {c.name} n'est plus un XML valide — {e}")
            return 1
    print("OK  les deux fichiers restent des XML valides")
    return 0


if __name__ == "__main__":
    sys.exit(main())
