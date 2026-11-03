#!/usr/bin/env python3
"""Noyau des animations de diva « Team Dazzling » — gestes dessinés sur mesure.

Trois espèces, trois gestes différents (aucun rebond générique commun) :

  * Lopunny (`0428`) — « Réverence à l'éventail » : elle lève un pompon-main devant
    le visage comme un éventail, le fait claquer, puis s'incline en révérence ;
  * Tsareena (`0763`) — « Éclosion royale » : les deux fleurs des hanches montent en
    éventail au-dessus de la couronne, la robe ondule, la botte frappe au sol ;
  * Mawile (`0303`) — « Clac de la diva » : les cornes-mâchoires s'ouvrent, claquent
    avec un éclat, la tête se renverse et elle salue.

Règles respectées (voir AGENTS.md) :

  * chaque phase part d'une **vraie image native** de la direction concernée
    (`Idle-Anim.png` de SpriteCollab épinglé) : pas de sprite de face pivoté, pas de
    miroir automatique entre directions ;
  * les parties déplacées sont **détectées par couleur et connexité** dans la vue
    native (pompons, fleurs, cornes), puis déplacées ; le vide laissé est rebouché
    par extension des colonnes du corps, jamais par un aplat inventé ;
  * les pixels ajoutés (éclats, pétales, éclat du clac) n'emploient **que des
    couleurs déjà présentes** dans la planche native de l'espèce ;
  * les repères `Offsets` (tête, corps, main droite, main gauche) suivent les
    transformations ; l'ombre native n'est pas modifiée.

Sortie : `(*-Anim.png, *-Offsets.png, *-Shadow.png, AnimData.xml)` pour 8
directions et 18 phases, plus `verification.json`.
"""
from __future__ import annotations

import json
import math
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
REF = HERE / "references"
SPECIES = {"0428": "lopunny", "0303": "mawile", "0763": "tsareena"}
PHASES = 18
MARKERS = {  # couleurs des repères Offsets de SpriteCollab
    "head": (0, 0, 0),
    "body": (0, 255, 0),
    "right": (255, 0, 0),
    "left": (0, 0, 255),
}
TICK = 3  # durée d'une phase, en ticks moteur (≈ 30 ticks/s → 18 phases ≈ 1,8 s)


# --------------------------------------------------------------------------- outils
def _masks(a: np.ndarray) -> dict[str, np.ndarray]:
    return {k: np.all(a[:, :, :3] == np.array(v), axis=2) & (a[:, :, 3] > 0) for k, v in MARKERS.items()}


def blob(img: np.ndarray, seed: tuple[int, int], tol: int = 0) -> np.ndarray:
    """Composante connexe (4-voisinage) de même couleur que `seed`, pixels opaques."""
    h, w = img.shape[:2]
    out = np.zeros((h, w), bool)
    x0, y0 = seed
    if not (0 <= x0 < w and 0 <= y0 < h) or img[y0, x0, 3] == 0:
        return out
    ref = img[y0, x0].astype(int)
    ok = (img[:, :, 3] > 0) & (np.abs(img[:, :, :3].astype(int) - ref).sum(axis=2) <= tol)
    stack = [(y0, x0)]
    while stack:
        y, x = stack.pop()
        if out[y, x] or not ok[y, x]:
            continue
        out[y, x] = True
        for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            ny, nx = y + dy, x + dx
            if 0 <= ny < h and 0 <= nx < w and not out[ny, nx] and ok[ny, nx]:
                stack.append((ny, nx))
    # on ajoute le liseré sombre collé (contour du pompon / de la fleur)
    grow = out.copy()
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            grow |= np.roll(np.roll(out, dy, 0), dx, 1)
    dark = (img[:, :, 3] > 0) & (img[:, :, :3].astype(int).sum(axis=2) < 150)
    return out | (grow & dark)


def lift_region(img: np.ndarray, region: np.ndarray, dx: int, dy: int,
                refill: str = "columns") -> np.ndarray:
    """Déplace `region` de (dx, dy) dans `img` en rebouchant le vide laissé.

    `refill='columns'` : chaque colonne vidée reprend ses pixels du bas du corps
    (le premier pixel opaque rencontré sous la zone) — extension verticale, pas
    d'aplat inventé ; `refill='none'` : le vide devient transparent.
    """
    h, w = img.shape[:2]
    out = img.copy()
    src = out[region].copy()
    # trou
    if refill == "columns":
        base = img.copy()
        for x in range(w):
            col = np.nonzero(region[:, x])[0]
            if len(col) == 0:
                continue
            top, bot = col.min(), col.max()
            donor = None
            for y in range(bot + 1, h):
                if img[y, x, 3] > 0 and not region[y, x]:
                    donor = img[y, x]
                    break
            if donor is None:
                for y in range(top - 1, -1, -1):
                    if img[y, x, 3] > 0 and not region[y, x]:
                        donor = img[y, x]
                        break
            if donor is None:
                base[col, x] = 0
            else:
                base[col, x] = donor
        out = base
    else:
        out[region] = 0
    # dépôt
    ys, xs = np.nonzero(region)
    ty, tx = ys + dy, xs + dx
    keep = (ty >= 0) & (ty < h) & (tx >= 0) & (tx < w)
    out[ty[keep], tx[keep]] = src[ys[keep], xs[keep]]
    return out


def shear(img: np.ndarray, rows: slice, k: float, pivot: int = 0) -> np.ndarray:
    """Cisaille horizontale progressive (inclinaison du buste / de la robe)."""
    out = img.copy()
    h = img.shape[0]
    for y in range(h):
        if y not in range(*rows.indices(h)):
            continue
        off = int(round(k * (y - pivot)))
        if off:
            out[y] = np.roll(img[y], off, axis=0)
            if off > 0:
                out[y, :off] = 0
            else:
                out[y, off:] = 0
    return out


def shift_region(img: np.ndarray, region: np.ndarray, dy: int) -> np.ndarray:
    out = img.copy()
    src = img.copy()
    out[region] = 0
    ys, xs = np.nonzero(region)
    ty = ys + dy
    keep = (ty >= 0) & (ty < img.shape[0])
    out[ty[keep], xs[keep]] = src[ys[keep], xs[keep]]
    return out


def palette(img: np.ndarray) -> set[tuple[int, int, int]]:
    a = img[img[:, :, 3] > 0][:, :3]
    return {tuple(int(v) for v in c) for c in np.unique(a, axis=0)}


class Palette:
    """Palette native de l'espèce : aucune couleur inventée n'est autorisée."""

    def __init__(self, imgs: list[np.ndarray]) -> None:
        cols: dict[tuple[int, int, int], int] = {}
        for im in imgs:
            a = im[im[:, :, 3] > 0][:, :3]
            for c in np.unique(a, axis=0):
                k = tuple(int(v) for v in c)
                cols[k] = cols.get(k, 0) + 1
        self.cols = sorted(cols, key=lambda c: cols[c], reverse=True)
        self.keys = set(self.cols)
        self.light = max(self.cols, key=lambda c: sum(c))
        self.dark = min(self.cols, key=lambda c: sum(c))

    def near(self, rgb: tuple[int, int, int]) -> tuple[int, int, int]:
        if tuple(rgb) in self.keys:
            return tuple(rgb)
        best = min(self.cols, key=lambda c: sum((a - b) ** 2 for a, b in zip(c, rgb)))
        return best

    def check(self, img: np.ndarray, native: set[tuple[int, int, int]]) -> int:
        a = img[img[:, :, 3] > 0][:, :3]
        return int(sum(1 for c in set(map(tuple, np.unique(a, axis=0))) if tuple(int(v) for v in c) not in native))


# --------------------------------------------------------------------------- sprite
@dataclass
class View:
    """Une direction native : image, repères, ombre."""
    img: np.ndarray
    shadow: np.ndarray
    markers: dict[str, tuple[int, int]]


@dataclass
class Sprite:
    slot: str
    name: str
    fw: int
    fh: int
    views: list[View] = field(default_factory=list)
    pal: Palette | None = None
    native_cols: set[tuple[int, int, int]] = field(default_factory=set)

    @property
    def dirs(self) -> int:
        return len(self.views)


def load(slot: str) -> Sprite:
    """Charge `Idle` (8 directions) depuis les références SpriteCollab épinglées."""
    name = SPECIES[slot]
    d = REF / f"{slot}_{name}"
    root = ET.parse(d / "AnimData.xml").getroot()
    node = next(a for a in root.findall("./Anims/Anim") if a.findtext("Name") == "Idle")
    fw, fh = int(node.findtext("FrameWidth")), int(node.findtext("FrameHeight"))
    anim = np.array(Image.open(d / "Idle-Anim.png").convert("RGBA"))
    off = np.array(Image.open(d / "Idle-Offsets.png").convert("RGBA"))
    shadow = np.array(Image.open(d / "Idle-Shadow.png").convert("RGBA"))
    sp = Sprite(slot=slot, name=name, fw=fw, fh=fh)
    imgs = []
    for k in range(8):
        img = anim[k * fh:(k + 1) * fh, :fw].copy()
        o = off[k * fh:(k + 1) * fh, :fw]
        m = {}
        for key, mask in _masks(o).items():
            ys, xs = np.nonzero(mask)
            if len(ys):
                m[key] = (int(xs[0]), int(ys[0]))
        sp.views.append(View(img=img, shadow=shadow[k * fh:(k + 1) * fh, :fw].copy(), markers=m))
        imgs.append(img)
    sp.pal = Palette(imgs)
    sp.native_cols = set(sp.pal.keys)
    return sp


# --------------------------------------------------------------------------- export
def write_pack(sp: Sprite, frames: list[list[np.ndarray]], offsets: list[list[dict[str, tuple[int, int]]]],
               anim_name: str, out_dir: Path, dur: list[int] | None = None) -> dict:
    """Écrit `Anim-*.png`, `Offsets-*.png`, `Shadow-*.png` (18 phases × 8 directions)."""
    out_dir.mkdir(parents=True, exist_ok=True)
    n = len(frames[0])
    anim = Image.new("RGBA", (sp.fw * n, sp.fh * sp.dirs))
    offi = Image.new("RGBA", (sp.fw * n, sp.fh * sp.dirs))
    shadow = Image.new("RGBA", (sp.fw * n, sp.fh * sp.dirs))
    for d in range(sp.dirs):
        for f in range(n):
            anim.paste(Image.fromarray(frames[d][f]), (f * sp.fw, d * sp.fh))
            o = np.zeros((sp.fh, sp.fw, 4), np.uint8)
            for key, (x, y) in offsets[d][f].items():
                if 0 <= x < sp.fw and 0 <= y < sp.fh:
                    o[y, x] = (*MARKERS[key], 255)
            offi.paste(Image.fromarray(o), (f * sp.fw, d * sp.fh))
            shadow.paste(Image.fromarray(sp.views[d].shadow), (f * sp.fw, d * sp.fh))
    anim.save(out_dir / f"{anim_name}-Anim.png")
    offi.save(out_dir / f"{anim_name}-Offsets.png")
    shadow.save(out_dir / f"{anim_name}-Shadow.png")
    return {"anim": anim_name, "frames": n, "dirs": sp.dirs,
            "frame": [sp.fw, sp.fh], "ticks": dur or [TICK] * n,
            "bytes": (out_dir / f"{anim_name}-Anim.png").stat().st_size}


def patch_animdata(src_xml: Path, dst_xml: Path, anims: list[dict]) -> None:
    """Ajoute les animations de diva à un `AnimData.xml` natif, sans toucher au reste.

    Le XML d'origine est conservé tel quel (indentation et contenu) : le bloc de
    l'animation est inséré avant `</Anims>`. Une animation de même nom serait
    remplacée, jamais dupliquée.
    """
    import re

    text = src_xml.read_text(encoding="utf-8-sig")
    root = ET.parse(src_xml).getroot()
    idx = max(int(a.findtext("Index") or 0) for a in root.findall("./Anims/Anim"))
    for spec in anims:
        idx += 1
        block = (
            "\t\t<Anim>\n"
            f"\t\t\t<Name>{spec['anim']}</Name>\n"
            f"\t\t\t<Index>{idx}</Index>\n"
            f"\t\t\t<FrameWidth>{spec['frame'][0]}</FrameWidth>\n"
            f"\t\t\t<FrameHeight>{spec['frame'][1]}</FrameHeight>\n"
            "\t\t\t<Durations>\n"
            + "".join(f"\t\t\t\t<Duration>{t}</Duration>\n" for t in spec["ticks"])
            + "\t\t\t</Durations>\n"
            "\t\t</Anim>\n"
        )
        text = re.sub(r"\t\t<Anim>\s*<Name>%s</Name>.*?</Anim>\n?" % re.escape(spec["anim"]),
                      "", text, flags=re.S)
        m = re.search(r"^([ \t]*)</Anims>", text, flags=re.M)
        close = m.group(0)
        text = text[:m.start()] + block + close + text[m.end():]
    dst_xml.write_text(text, encoding="utf-8")


def rot2(x: float, y: float, cx: float, cy: float, ang: float) -> tuple[int, int]:
    a = math.radians(ang)
    dx, dy = x - cx, y - cy
    return (int(round(cx + dx * math.cos(a) - dy * math.sin(a))),
            int(round(cy + dx * math.sin(a) + dy * math.cos(a))))


def ease(t: float) -> float:
    """Adoucissement symétrique (départ/arrivée doux, milieu rapide)."""
    t = min(1.0, max(0.0, t))
    return t * t * (3 - 2 * t)


def curve(n: int, keys: list[tuple[float, float]]) -> list[float]:
    """Interpole une suite de valeurs clés (t ∈ [0,1]) sur `n` phases."""
    out = []
    for i in range(n):
        t = i / (n - 1)
        for j in range(len(keys) - 1):
            t0, v0 = keys[j]
            t1, v1 = keys[j + 1]
            if t0 <= t <= t1:
                u = 0 if t1 == t0 else (t - t0) / (t1 - t0)
                out.append(v0 + (v1 - v0) * u)
                break
        else:
            out.append(keys[-1][1])
    return out


def sparkle(img: np.ndarray, cx: int, cy: int, r: int, color: tuple[int, int, int], a: float) -> None:
    """Éclat à quatre branches continues + cœur 2×2 : jamais peint sur l'art natif.

    Seuls les pixels transparents reçoivent l'éclat ; la couleur vient de la
    palette native de l'espèce.
    """
    if a <= 0.05:
        return
    h, w = img.shape[:2]
    alpha = int(255 * min(1.0, a))

    def put(x: int, y: int) -> None:
        if 0 <= x < w and 0 <= y < h and img[y, x, 3] == 0:
            img[y, x] = (*color, alpha)

    for dx, dy in ((0, 0), (1, 0), (0, 1), (1, 1)):      # cœur
        put(cx + dx, cy + dy)
    for i in range(1, max(2, r)):                        # branches continues
        put(cx, cy - i)
        put(cx + 1, cy + 1 + i)
        put(cx - i, cy)
        put(cx + 1 + i, cy + 1)


def bloom(img: np.ndarray, cx: int, cy: int, r: int, colors: tuple[tuple[int, int, int], tuple[int, int, int]],
          a: float) -> None:
    """Pétale stylisé (losange), dessiné avec deux couleurs natives."""
    if a <= 0.05:
        return
    edge, core = colors
    h, w = img.shape[:2]
    for dy in range(-r, r + 1):
        span = r - abs(dy)
        for dx in range(-span, span + 1):
            x, y = cx + dx, cy + dy
            if 0 <= x < w and 0 <= y < h:
                inner = abs(dx) + abs(dy) <= max(1, r - 2)
                img[y, x] = (*(core if inner else edge), 255)
