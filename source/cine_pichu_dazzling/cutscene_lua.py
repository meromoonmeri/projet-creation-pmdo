#!/usr/bin/env python3
"""Génère la VRAIE cutscene in-game de la cinématique « Pichu & la Team Dazzling ».

Deux livrables, tous deux dérivés du scénario unique (SHOTS/LINES/EMOTES de build.py) :

  1. `generate_lua()`  → script de ground PMDO/Halcyon (`init.lua`) qui rejoue la
     cinématique DANS le moteur : GAME:CutsceneMode, GAME:_MoveCamera, GROUND:MoveToPosition,
     GROUND:CharSetAnim, GROUND:CharSetEmote + SOUND:PlayBattleSE, UI:SetSpeaker /
     UI:SetSpeakerEmotion / UI:WaitShowDialogue, GAME:WaitFrames, fades… (grammaire
     relevée sur les cutscenes de Halcyon, ex. ground/altere_pond/altere_pond_ch_1.lua).
  2. `inject_mapchars()` → copie de `cliffdaytest.rsground` avec les 4 personnages
     posés en entités MapChars (AIEnabled=false), comme les PNJ de cutscene Halcyon.

    .venv/bin/python -m source.cine_pichu_dazzling.cutscene_lua
"""
from __future__ import annotations

import copy
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent

# noms d'entités des personnages sur la map de cutscene
ENTS = {"0172": "Pichu_Cine", "0428": "Lopunny_Cine", "0763": "Tsareena_Cine", "0303": "Mawile_Cine"}
SPECIES = {"0172": "pichu", "0428": "lopunny", "0763": "tsareena", "0303": "mawile"}
DIRS = {0: "Down", 2: "Right", 4: "Up", 6: "Left"}
# émotes moteur PMDO (relevées dans Halcyon : GeneralFunctions/PartnerEssentials)
EMOTE_LUA = {"sweat": "sweatdrop", "cry": "sweatdrop", "note": "happy", "anger": "angry",
             "heart": "glowing", "exclaim": "exclaim", "question": "question",
             "dots": "notice", "sparkle": "glowing"}
SFX_LUA = {"exclaim": "EVT_Emote_Exclaim_2", "sweat": "EVT_Emote_Sweatdrop", "cry": "EVT_Emote_Sweatdrop"}
FPS = 60


def _fr(dt: float) -> int:
    return max(1, round(dt * FPS))


def generate_lua(shots: list, lines: list, emotes: list) -> str:
    """Concatène le scénario en une cutscene Halcyon séquentielle (événements triés par t)."""
    ev: list[tuple[float, int, str]] = []  # (t, ordre, code lua)
    for sc in shots:
        cam = sc["cam"]
        for i, k in enumerate(cam):
            if i == 0:
                ev.append((k[0], 0, f"\tGAME:_MoveCamera({int(k[1])}, {int(k[2])}, 24, false)"))
            else:
                prev = cam[i - 1]
                ev.append((prev[0], 0, f"\tGAME:_MoveCamera({int(k[1])}, {int(k[2])}, {_fr(k[0] - prev[0])}, false)"))
        for a in sc.get("actors", []):
            ent = ENTS[a["pid"]]
            keys = a["keys"]
            for i in range(1, len(keys)):
                t0, x0, y0 = keys[i - 1]
                t1, x1, y1 = keys[i]
                if abs(x1 - x0) + abs(y1 - y0) < 2:
                    continue
                ev.append((t0, 1, f"\tGROUND:MoveToPosition({ent}, {int(x1)}, {int(y1)}, false, 1)"
                                  f"  -- {a['id']} marche ({t0:.1f}s → {t1:.1f}s)"))
            for e in a["an"]:
                loop = "true" if not (len(e) > 3 and e[3].get("loop") is False) else "false"
                d = e[2]
                turn = f"\tGROUND:CharTurn({ent}, Direction.{DIRS[d]}, false)\n" if d in DIRS else ""
                ev.append((e[0], 2, turn + f"\tGROUND:CharSetAnim({ent}, '{e[1]}', {loop})"))
            if a.get("a"):
                ev.append((a["a"][0][0], 3, f"\tGROUND:Hide('{ent}')"))
                ev.append((a["a"][-1][0] + 0.2, 3, f"\tGROUND:Show('{ent}')"))
    for t0, t1, pid, emo, txt in lines:
        ent = ENTS[pid]
        safe = txt.replace("\\", "\\\\").replace('"', '\\"')
        ev.append((t0, 4, f'\tUI:SetSpeaker({ent})\n\tUI:SetSpeakerEmotion("{emo}")\n'
                          f'\tUI:WaitShowDialogue("{safe}")'))
    for t0, t1, pid, kind in emotes:
        ent = ENTS[pid]
        lua_em = EMOTE_LUA.get(kind, "notice")
        sfx = SFX_LUA.get(kind)
        code = f"\tGROUND:CharSetEmote({ent}, \"{lua_em}\", 1)"
        if sfx:
            code += f"\n\tSOUND:PlayBattleSE('{sfx}')"
        ev.append((t0, 5, code))
        ev.append((t1, 6, f"\tGROUND:CharSetEmote({ent}, \"\", 0)"))
    # larmes de Pichu (fenêtres longues) : émote maintenue
    ev.append((220.5, 5, f"\tGROUND:CharSetEmote({ENTS['0172']}, \"sweatdrop\", 0)"))
    ev.append((252.0, 6, f"\tGROUND:CharSetEmote({ENTS['0172']}, \"\", 0)"))
    ev.append((262.0, 5, f"\tGROUND:CharSetEmote({ENTS['0172']}, \"sweatdrop\", 0)"))
    ev.append((286.0, 6, f"\tGROUND:CharSetEmote({ENTS['0172']}, \"\", 0)"))
    ev.sort(key=lambda e: (e[0], e[1]))

    body: list[str] = []
    cur = 0.0
    for t, _ord, code in ev:
        gap = t - cur
        if gap > 0.02:
            body.append(f"\tGAME:WaitFrames({_fr(gap)})")
        body.append(code)
        cur = t

    head = f"""--[[
    init.lua — ground `cliffdaytest` : cutscene « Pichu & la Team Dazzling » (5 min).
    Généré depuis le scénario unique source/cine_pichu_dazzling/build.py — NE PAS éditer à la main.
    Grammaire de cutscene conforme aux cutscenes Halcyon (GAME:CutsceneMode, GAME:_MoveCamera,
    GROUND:MoveToPosition / CharSetAnim / CharSetEmote, UI:SetSpeaker / SetSpeakerEmotion /
    WaitShowDialogue, GAME:WaitFrames, GAME:FadeIn/FadeOut).
    Personnages : entités MapChars Pichu_Cine / Lopunny_Cine / Tsareena_Cine / Mawile_Cine
    (voir cliffdaytest_cine.rsground généré à côté de ce script).
    OST de l'entrée team : référence « Beta's Theme » (youtu.be/iV04Wl5DLJo) — déposer le fichier
    audio dans Content/BGM puis décommenter la ligne PlayBGM ci-dessous.
]]--
require 'common'
require 'GeneralFunctions'

local cliffdaytest_cine = {{}}

local PICHU, LOP, SUC, MYS = '{ENTS['0172']}', '{ENTS['0428']}', '{ENTS['0763']}', '{ENTS['0303']}'

function cliffdaytest_cine.Init(map, time)
\tDEBUG.EnableDbgCoro()
end

function cliffdaytest_cine.Enter(map, time)
\tif _G.DESTINY_DAZZLING_CINE_PLAYED then return end
\t_G.DESTINY_DAZZLING_CINE_PLAYED = true
\tcliffdaytest_cine.Cutscene()
end

function cliffdaytest_cine.Cutscene()
\tlocal Pichu_Cine, Lopunny_Cine, Tsareena_Cine, Mawile_Cine =
\t\tCH(PICHU), CH(LOP), CH(SUC), CH(MYS)
\tGAME:CutsceneMode(true)
\tUI:ResetSpeaker()
\tAI:DisableCharacterAI(CH(PICHU))
\tAI:DisableCharacterAI(CH(LOP))
\tAI:DisableCharacterAI(CH(SUC))
\tAI:DisableCharacterAI(CH(MYS))
\t-- SOUND:PlayBGM("Team Dazzling - Beta's Theme.ogg", false)
\tGAME:FadeIn(40)
"""
    tail = """\tGAME:WaitFrames(60)
\tGAME:FadeOut(false, 40)
\tUI:ResetSpeaker()
\tGAME:CutsceneMode(false)
end

function cliffdaytest_cine.Exit(map, time) end
function cliffdaytest_cine.Update(map, time) end
function cliffdaytest_cine.GameSave(map) end
function cliffdaytest_cine.GameLoad(map) GAME:FadeIn(20) end

return cliffdaytest_cine
"""
    return head + "\n".join(body) + "\n" + tail


def inject_mapchars(src: Path, dst: Path) -> dict:
    """Copie le rsground native en y posant les 4 personnages de la cutscene (MapChars)."""
    obj = json.loads(src.read_text(encoding="utf-8-sig"))
    o = obj["Object"]
    tmpl = None
    for ref in (ROOT / "source" / "antre_harmonie_v3" / "references" / "altere_pond.rsground",):
        if ref.is_file():
            r = json.loads(ref.read_text(encoding="utf-8-sig"))["Object"]
            for e in r.get("Entities", []):
                if e.get("MapChars"):
                    tmpl = copy.deepcopy(e["MapChars"][0])
                    break
        if tmpl:
            break
    assert tmpl is not None, "gabarit MapChars introuvable"
    poses = {"0172": (605, 470, 0), "0428": (612, 800, 4), "0763": (634, 806, 4), "0303": (656, 812, 4)}
    chars = []
    for pid, (x, y, d) in poses.items():
        c = copy.deepcopy(tmpl)
        c["EntName"] = ENTS[pid]
        c["AIEnabled"] = False
        c["Direction"] = d
        c["serializationDir"] = d
        c["serializationLoc"] = {"X": x, "Y": y}
        c["Data"]["Nickname"] = ""
        c["Data"]["BaseForm"] = {"Species": SPECIES[pid], "Form": 0, "Skin": "normal", "Gender": 0}
        chars.append(c)
    ent = o["Entities"][0]
    ent["MapChars"] = chars
    dst.write_text(json.dumps(obj, ensure_ascii=False), encoding="utf-8")
    return {"ents": [ENTS[k] for k in poses], "size": dst.stat().st_size}


if __name__ == "__main__":
    import sys
    sys.path.insert(0, str(HERE))
    from build import SHOTS, LINES, EMOTES  # type: ignore
    lua = generate_lua(SHOTS, LINES, EMOTES)
    print(f"cutscene lua : {len(lua) / 1024:.0f} Ko, {lua.count(chr(10))} lignes")
