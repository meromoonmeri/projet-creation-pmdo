# -*- coding: utf-8 -*-
"""Genere les MapStatus meteo manquants de New Era.

   Aucun asset graphique nouveau : on reutilise les animations deja
   presentes (Rain fournie par le moteur, Snow_Fall, Ash_Fall, Steam,
   SE5_Wind_Background) en jouant sur les parametres des emetteurs.

   Deux familles de modeles, tous deux presents dans le projet :
     * ScreenRainEmitter  (winter_snow, falling_ash)  -> chutes
     * OverlayEmitter     (steam, blowing_wind)       -> nappes teintees

   Format : BOM UTF-8, indentation 2, saut de ligne final.
   Le round-trip est prouve sur le modele AVANT toute ecriture, et le
   fichier produit est relu pour controle.
"""
import json, os, copy

W = "work"

def read(path):
    b = open(path, 'rb').read()
    bom = b[:3] == b'\xef\xbb\xbf'
    s = b.decode('utf-8-sig')
    o = json.loads(s)
    if json.dumps(o, ensure_ascii=False, indent=2) + "\n" != s:
        raise SystemExit(f"{path} : round-trip non reproduit, ecriture interdite")
    return o, bom

def write(path, o, bom):
    s = json.dumps(o, ensure_ascii=False, indent=2) + "\n"
    open(path, 'wb').write((('\ufeff' if bom else '') + s).encode('utf-8'))

# ---- chutes (ScreenRainEmitter) : modele winter_snow -----------------
# nom            fr                   anim        vitesse diff burst n  commentaire
CHUTES = [
 ("light_rain",  "Pluie fine",        "Rain",      -300, 60,  6, 1,
  "Bruine. Chute lente, peu dense : ambiance melancolique sans masquer le decor."),
 ("heavy_rain",  "Pluie torrentielle","Rain",      -420, 200, 2, 4,
  "Averse violente, fortement oblique. A coupler avec un overlay sombre."),
 ("blizzard",    "Blizzard",          "Snow_Fall", -200, 260, 3, 4,
  "Neige chassee a l'horizontale par le vent. Base winter_snow, SpeedDiff x14."),
 ("sandstorm",   "Tempete de sable",  "Ash_Fall",  -120, 300, 3, 4,
  "Sable pousse au ras du sol. Base falling_ash, teinte ocre par l'overlay."),
]

# ---- nappes (OverlayEmitter) : modele steam --------------------------
# nom        fr            anim     mouvement      couleur RGBA          commentaire
NAPPES = [
 ("fog",     "Brouillard", "Steam", (-8, 0),  "190, 195, 205, 110",
  "Nappe grise derivant lentement. Reutilise la texture Steam, retentee froide."),
 ("gloom",   "Ciel d'orage","Steam", (-14, 0), "60, 60, 90, 130",
  "Assombrissement bleute. Se superpose a une pluie pour faire l'orage."),
]

def build_chutes():
    base, bom = read(f"{W}/winter_snow.json")
    for name, fr, anim, speed, diff, burst, per, comment in CHUTES:
        o = copy.deepcopy(base)
        ob = o["Object"]
        ob["Name"] = {"DefaultText": fr, "LocalTexts": {"fr": fr}}
        ob["Desc"] = {"DefaultText": comment[:60], "LocalTexts": {"fr": comment[:60]}}
        ob["Comment"] = comment
        em = ob["Emitter"]
        em["$type"] = "RogueEssence.Content.ScreenRainEmitter, RogueEssence"
        em["Anim"] = {"AnimIndex": anim, "FrameTime": 1 if anim == "Rain" else 4,
                      "StartFrame": 0, "EndFrame": 0 if anim == "Rain" else 7,
                      "AnimDir": -1, "Alpha": 255, "AnimFlip": 0}
        em["ResultAnim"] = {"AnimIndex": anim, "FrameTime": 1 if anim == "Rain" else 4,
                            "StartFrame": 1 if anim == "Rain" else 8,
                            "EndFrame": -1 if anim == "Rain" else 11,
                            "AnimDir": -1, "Alpha": 255, "AnimFlip": 0}
        em["HeightSpeed"] = speed
        em["SpeedDiff"] = diff
        em["BurstTime"] = burst
        em["ParticlesPerBurst"] = per
        em["Layer"] = 4
        write(f"{W}/{name}.json", o, bom)
        yield name, fr

def build_nappes():
    base, bom = read(f"{W}/steam.json")
    for name, fr, anim, mv, col, comment in NAPPES:
        o = copy.deepcopy(base)
        ob = o["Object"]
        ob["Name"] = {"DefaultText": fr, "LocalTexts": {"fr": fr}}
        ob["Desc"] = {"DefaultText": comment[:60], "LocalTexts": {"fr": comment[:60]}}
        ob["Comment"] = comment
        em = ob["Emitter"]
        em["Anim"]["AnimIndex"] = anim
        em["Movement"] = {"X": mv[0], "Y": mv[1]}
        em["Color"] = col
        em["Layer"] = 4
        write(f"{W}/{name}.json", o, bom)
        yield name, fr

def main():
    made = []
    for n, fr in build_chutes(): made.append((n, fr, "chute"))
    for n, fr in build_nappes(): made.append((n, fr, "nappe"))

    # index
    ip = f"{W}/mapstatus_index.idx"
    o, bom = read(ip)
    D = o["Object"]
    for n, fr, _ in made:
        ms = json.loads(open(f"{W}/{n}.json", encoding='utf-8-sig').read())["Object"]
        D[n] = {"Name": {"DefaultText": ms["Name"]["DefaultText"],
                         "LocalTexts": ms["Name"]["LocalTexts"]},
                "Released": ms["Released"], "Comment": "", "SortOrder": 0}
    write(ip, o, bom)

    # controle : relecture de chaque fichier produit
    for n, fr, kind in made:
        chk, _ = read(f"{W}/{n}.json")
        em = chk["Object"]["Emitter"]
        t = em["$type"].split(",")[0].split(".")[-1]
        print(f"  {n:12} {fr:22} {kind:6} {t}")
    idx, _ = read(ip)
    print("\nindex :", len([k for k in idx["Object"] if not k.startswith('$')]), "entrees")

main()
