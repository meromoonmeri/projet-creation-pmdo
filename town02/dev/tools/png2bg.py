#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
png2bg.py — fabrique un Content/BG/<nom>.dir a partir d'un PNG.

A QUOI CA SERT
--------------
Content/BG contient les nappes plein ecran du moteur : celles qu'on passe a
RogueEssence.Content.BGAnimData(nom, frameTime) puis a un
FiniteOverlayEmitter. C'est le seul moyen d'afficher une IMAGE ENTIERE
par-dessus la scene (plan large, voile, brume), par opposition aux tuiles
de Content/Tile qui composent le decor.

FORMAT, MESURE SUR LES FICHIERS EXISTANTS
-----------------------------------------
Un .dir n'est ni une archive ni un dossier malgre son extension. C'est :

    [8 octets]   longueur du PNG, entier non signe little-endian (<Q)
    [N octets]   le PNG brut, tel quel
    [16 octets]  quatre entiers <I : largeur, hauteur, frameTime, frames

  * largeur/hauteur = taille d'UNE image, pas de l'atlas ;
  * frames = nombre d'images ; si > 1, le PNG est un atlas en grille et
    l'entete decrit la case, pas la planche entiere ;
  * frameTime = 0 pour une image fixe.

Verifie sur les 22 fichiers de Content/BG. Exemples :
    Chapter_10.dir  PNG 320x240   entete (320, 240, 0, 1)     fixe
    Steam.dir       PNG 128x128   entete (128, 128, 0, 1)     fixe
    Dream_Back.dir  PNG 1536x1920 entete (192, 240, 0, 63)    atlas 8x8

Cinq fichiers (Genesis_*) n'ont PAS les 16 octets de queue : ils sont
lus autrement par le moteur. On ne touche pas a ce cas, et ce script ne
produit que la forme complete, la seule attestee pour un overlay.

USAGE
    python3 tools/png2bg.py <source.png> <NomDeSortie> [--frames N] [--frametime T]

Refuse d'ecraser un .dir existant sans --force, et relit toujours le
fichier produit pour verifier qu'il se redecode a l'identique.
"""
from __future__ import annotations

import argparse
import io
import struct
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
BGDIR = ROOT / "Content" / "BG"


def lire_dir(path: Path):
    """Redecode un .dir. Rend (image, largeur, hauteur, frameTime, frames)."""
    raw = path.read_bytes()
    ln = struct.unpack_from("<Q", raw, 0)[0]
    png = raw[8:8 + ln]
    queue = raw[8 + ln:]
    if len(queue) != 16:
        raise ValueError(f"{path.name} : queue de {len(queue)} octets, 16 attendus")
    w, h, ft, fr = struct.unpack("<IIII", queue)
    return Image.open(io.BytesIO(png)), w, h, ft, fr


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("source")
    ap.add_argument("nom", help="nom sans extension, ex: Sky_Tower_Reveal")
    ap.add_argument("--frames", type=int, default=1)
    ap.add_argument("--frametime", type=int, default=0)
    ap.add_argument("--force", action="store_true")
    args = ap.parse_args()

    src = Path(args.source)
    if not src.exists():
        print(f"ERREUR : {src} introuvable")
        return 1

    dest = BGDIR / f"{args.nom}.dir"
    if dest.exists() and not args.force:
        print(f"REFUS : {dest.name} existe deja (utiliser --force)")
        return 1

    im = Image.open(src)
    # RGBA systematique : un overlay a besoin de son canal alpha, et c'est le
    # mode de tous les BG existants qui servent de nappe (Steam, White...).
    if im.mode != "RGBA":
        im = im.convert("RGBA")

    if args.frames < 1:
        print("ERREUR : --frames doit valoir au moins 1")
        return 1
    if im.width % args.frames != 0:
        print(f"ERREUR : largeur {im.width} non divisible par {args.frames} images")
        return 1

    # Taille d'UNE image. Pour un atlas horizontal simple, on divise la
    # largeur ; les grilles 2D (cf. Dream_Back) ne sont pas produites ici,
    # faute d'un cas d'usage a reproduire fidelement.
    fw = im.width // args.frames
    fh = im.height

    buf = io.BytesIO()
    im.save(buf, format="PNG")
    png = buf.getvalue()

    dest.write_bytes(
        struct.pack("<Q", len(png)) + png
        + struct.pack("<IIII", fw, fh, args.frametime, args.frames)
    )

    # Relecture : le fichier doit se redecoder exactement.
    im2, w2, h2, ft2, fr2 = lire_dir(dest)
    ok = (im2.size == im.size and (w2, h2, ft2, fr2)
          == (fw, fh, args.frametime, args.frames))
    print(f"{'OK   ' if ok else 'ECHEC'} {dest.relative_to(ROOT)}")
    print(f"      PNG {im.size} {im.mode} | image {fw}x{fh} "
          f"| frameTime={args.frametime} | frames={args.frames}")
    print(f"      {dest.stat().st_size} octets, relecture "
          f"{'conforme' if ok else 'DIVERGENTE'}")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
