# -*- coding: utf-8 -*-
"""Cree Data/MapStatus/falling_rain.json — pluie d'ambiance de surface.

   Base : winter_snow.json du projet (meme famille : meteo decorative de
   ground, DefaultHidden, sans effet de combat).
   Emetteur : parametres canoniques du MapStatus `rain` du jeu de base
   (PMDODump/DataGenerator/Data/MapStatusInfo.cs, ii == 1) —
       ScreenRainEmitter(AnimData("Rain", 1, 0, 0))
       HeightSpeed -360, SpeedDiff 120, BurstTime 3, ParticlesPerBurst 2
       ResultAnim AnimData("Rain", 1, 1, -1), Layer Top
   L'animation "Rain" est fournie par le moteur : elle n'a donc pas a
   etre ajoutee dans Content/Particle.

   Format preserve : BOM UTF-8, indentation 2, saut de ligne final.
   Round-trip prouve sur le modele avant ecriture.
"""
import json, os, sys

SRC = "work/winter_snow.json"
DST = "work/falling_rain.json"

def read(path):
    b = open(path, 'rb').read()
    bom = b[:3] == b'\xef\xbb\xbf'
    s = b.decode('utf-8-sig')
    o = json.loads(s)
    if json.dumps(o, ensure_ascii=False, indent=2) + "\n" != s:
        raise SystemExit(f"{path}: round-trip non reproduit, ecriture interdite")
    return o, bom

def write(path, o, bom):
    s = json.dumps(o, ensure_ascii=False, indent=2) + "\n"
    open(path, 'wb').write((('\ufeff' if bom else '') + s).encode('utf-8'))

def main():
    o, bom = read(SRC)
    ob = o["Object"]

    ob["Name"] = {"DefaultText": "Falling Rain",
                  "LocalTexts": {"fr": "Pluie battante"}}
    ob["Desc"] = {"DefaultText": "Cold rain sweeps over the town.",
                  "LocalTexts": {"fr": "Une pluie froide balaie le bourg."}}
    ob["Comment"] = ("Pluie d'ambiance de surface (ch11, fuite de Metano). "
                     "Emetteur calque sur le MapStatus `rain` du jeu de base "
                     "(MapStatusInfo.cs ii==1) : chute rapide et oblique. "
                     "Purement decoratif — aucun effet de combat, "
                     "contrairement au `rain` de donjon.")

    em = ob["Emitter"]
    em["$type"] = "RogueEssence.Content.ScreenRainEmitter, RogueEssence"
    em["Anim"] = {"AnimIndex": "Rain", "FrameTime": 1, "StartFrame": 0,
                  "EndFrame": 0, "AnimDir": -1, "Alpha": 255, "AnimFlip": 0}
    em["ResultAnim"] = {"AnimIndex": "Rain", "FrameTime": 1, "StartFrame": 1,
                        "EndFrame": -1, "AnimDir": -1, "Alpha": 255, "AnimFlip": 0}
    em["HeightSpeed"] = -360
    em["SpeedDiff"] = 120
    em["BurstTime"] = 3
    em["ParticlesPerBurst"] = 2
    em["Layer"] = 4          # DrawLayer.Top, valeur utilisee par winter_snow

    write(DST, o, bom)

    # controle : relecture + round-trip du fichier ecrit
    chk, _ = read(DST)
    e = chk["Object"]["Emitter"]
    assert e["Anim"]["AnimIndex"] == "Rain"
    assert chk["Object"]["DefaultHidden"] is True
    assert chk["Object"]["StatusStates"] == o["Object"]["StatusStates"]
    print("ecrit :", DST)
    print("  nom     :", chk["Object"]["Name"]["LocalTexts"]["fr"])
    print("  anim    :", e["Anim"]["AnimIndex"], "| vitesse", e["HeightSpeed"],
          "| diff", e["SpeedDiff"], "| salve", e["ParticlesPerBurst"], "/", e["BurstTime"], "frames")
    print("  hidden  :", chk["Object"]["DefaultHidden"])
    print("  round-trip du fichier ecrit : OK")

main()
