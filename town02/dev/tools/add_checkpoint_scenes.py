#!/usr/bin/env python3
"""Checkpoints romanesques — mort après le relais = réveil AU relais avec
cinématique et dialogue (patron ch3/ch6 étendu aux ch5/7/8/9/10).

1. Zones : la mort dans la 2e moitié route vers le RELAIS (plus l'entrée),
   pose <SV>.MidState = 'DeathArrival'.
2. Grounds relais : WipedCutscene — réveil près du rocher Kangourex,
   « Heartwarming », dialogue FR spécifique au donjon (« Olala, c'était dur »
   version écrite), remise en route.
"""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import re, io, json

WAKE = {
 'vast_steppe_midpoint':      (672, 224, 704, 224, 688, 216),
 'searing_tunnel_midpoint':   (192, 232, 224, 240, 208, 228),
 'mount_windswept_midpoint':  (960, 360, 992, 368, 976, 352),
 'cloven_ruins_midpoint':     (160, 320, 192, 328, 176, 312),
 'crystal_sanctuary_relay':   (400, 128, 432, 136, 416, 120),
 'forgotten_marsh_relay':     (128, 200, 160, 208, 144, 192),
 'celestial_peak_relay':      (88, 248, 116, 256, 100, 240),
}

# Dialogues de réveil — chaque donjon a sa voix. (partner emotion, lignes)
SCENES = {
 'vast_steppe_midpoint': [
   ('Pain',   "Aïe... aïe aïe aïe...[pause=20] On est... au camp ?"),
   ('Worried',"C'est Hyko et Almotz qui nous ont traînés jusqu'ici.[pause=20] Les herbes sombres, là-bas...[pause=10] elles nous ont avalés d'un coup."),
   ('Normal', "Les Profondeurs de la Steppe ne pardonnent pas.[pause=20] L'herbe y est plus haute que nous, et deux fois plus affamée."),
   ('Determined',"Bon.[pause=10] On souffle, on refait les sacs...[pause=20] et cette fois, [hero], on reste GROUPÉS."),
 ],
 'searing_tunnel_midpoint': [
   ('Pain',   "Kof... kof...[pause=20] Ça sent le poil roussi.[pause=10] C'est nous, le poil roussi."),
   ('Worried',"Les Profondeurs Incandescentes...[pause=20] la roche y FOND, [hero]. J'ai vu nos empreintes s'effacer derrière nous."),
   ('Normal', "On a eu de la chance que le rocher soit si près.[pause=20] Bois quelque chose. Non — bois TOUT."),
   ('Determined',"La prochaine fois, on longe la paroi froide.[pause=10] J'ai repéré le chemin.[pause=20] On y retourne quand tu veux."),
 ],
 'mount_windswept_midpoint': [
   ('Pain',   "Olala...[pause=20] c'était dur.[pause=10] C'était vraiment, VRAIMENT dur."),
   ('Worried',"Les Crêtes...[pause=10] le vent là-haut ne souffle pas, il MORD.[pause=20] Une rafale nous a soulevés comme des feuilles."),
   ('Normal', "Le camp de base a tenu, lui.[pause=20] Regarde, les tentes n'ont pas bougé.[pause=10] On est en sécurité ici."),
   ('Determined',"On attend que le vent tombe...[pause=20] et on reprend l'ascension.[pause=10] Le sommet ne s'éloignera pas."),
 ],
 'cloven_ruins_midpoint': [
   ('Pain',   "Ces ruines...[pause=20] même le sol semblait vouloir qu'on parte."),
   ('Worried',"Les veines dorées dans la pierre...[pause=10] elles BRILLAIENT plus fort à mesure qu'on approchait.[pause=20] Comme un avertissement."),
   ('Determined',"Le Cœur des ruines est tout près, je le sens.[pause=20] Reposons-nous — puis finissons ce qu'on a commencé."),
 ],
 'crystal_sanctuary_relay': [
   ('Pain',   "Les cristaux...[pause=20] ils chantaient encore quand tout est devenu noir."),
   ('Worried',"C'est la gardienne qui a ramené la lumière autour de nous.[pause=10] Je crois...[pause=20] je crois qu'elle nous OBSERVE, [hero]."),
   ('Determined',"Alors on va lui montrer qui nous sommes.[pause=20] Debout.[pause=10] Le Sanctuaire attend."),
 ],
 'forgotten_marsh_relay': [
   ('Pain',   "Pouah...[pause=10] j'ai de la vase JUSQUE dans les oreilles."),
   ('Worried',"Le marais nous a recrachés près du rocher.[pause=20] Comme si quelque chose, sous l'eau, avait décidé qu'on méritait une seconde chance."),
   ('Determined',"On ne la gâchera pas.[pause=20] Cette fois, on teste CHAQUE flaque avant d'y mettre une patte."),
 ],
 'celestial_peak_relay': [
   ('Pain',   "L'air...[pause=10] il n'y a presque plus d'air, là-haut..."),
   ('Worried',"On est retombés jusqu'à la corniche.[pause=20] Le Pic nous a repoussés — pas par méchanceté...[pause=10] on n'était juste pas prêts."),
   ('Determined',"Alors on se prépare.[pause=20] Respire, [hero].[pause=10] Le ciel, lui, ne bouge pas."),
 ],
}

WIPE_FN = '''

--------------------------------------------------------------------
-- Réveil après une défaite au-delà du checkpoint (vague 8).
-- Le duo revient à lui près du Terminal, ranimé par ses réserves.
--------------------------------------------------------------------
function {mod}.WipedCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  GROUND:TeleportTo(hero, {hx}, {hy}, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, {px}, {py}, Direction.Right) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  GAME:MoveCamera({cx}, {cy}, 1, false)

  GAME:FadeIn(60)
  SOUND:PlayBGM('Heartwarming.ogg', true)
  GAME:WaitFrames(110)

  local coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.DoAnimation(hero, 'Wake')
    GAME:WaitFrames(12)
    GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(14)
    if partner ~= nil then
      GeneralFunctions.DoAnimation(partner, 'Wake')
      GAME:WaitFrames(12)
      GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
    end end)
  TASK:JoinCoroutines({{coro1, coro2}})
  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
{lines}
  GAME:WaitFrames(20)
  if partner ~= nil then AI:EnableCharacterAI(partner) end
  GAME:CutsceneMode(false)
  GAME:FadeIn(1)
end
'''

def lines_block(scene):
    out = []
    for emo, txt in scene:
        out.append(f'  UI:SetSpeakerEmotion("{emo}")')
        if '[hero]' in txt:
            txt2 = txt.replace('[hero]', '{0}')
            out.append(f'  UI:WaitShowDialogue(STRINGS:Format("{txt2}", CH(\'PLAYER\'):GetDisplayName()))')
        else:
            out.append(f'  UI:WaitShowDialogue("{txt}")')
        out.append('  GAME:WaitFrames(14)')
    return '\n'.join(out)

# ---------------------------------------------------------------------------
# 1. Grounds ch5 : ajouter WipedCutscene au module _ch_5 + hook PlotScripting
# ---------------------------------------------------------------------------
CH5 = {
 'vast_steppe_midpoint':     ('vast_steppe_midpoint_ch_5',   'SV.Chapter5.SteppeMidState'),
 'searing_tunnel_midpoint':  ('searing_tunnel_midpoint_ch_5','SV.Chapter5.TunnelMidState'),
 'mount_windswept_midpoint': ('mount_windswept_midpoint_ch_5','SV.Chapter5.WindsweptMidState'),
}
for g, (mod, sv) in CH5.items():
    p = f'Data/Script/halcyon/ground/{g}/{mod}.lua'
    s = open(p, encoding='utf-8').read()
    if 'WipedCutscene' not in s:
        hx, hy, px, py, cx, cy = WAKE[g]
        fn = WIPE_FN.format(mod=mod, hx=hx, hy=hy, px=px, py=py, cx=cx, cy=cy,
                            lines=lines_block(SCENES[g]))
        s = s.rstrip()
        assert s.endswith(f'return {mod}')
        s = s[:-len(f'return {mod}')] + fn + f'\nreturn {mod}\n'
        open(p, 'w', encoding='utf-8').write(s)
    # hook dans init.lua PlotScripting
    ip = f'Data/Script/halcyon/ground/{g}/init.lua'
    t = open(ip, encoding='utf-8').read()
    if 'WipedCutscene' not in t:
        m = re.search(r'(function \w+\.PlotScripting\(\)\n)', t)
        hook = (m.group(1) +
                f"  if {sv} == 'DeathArrival' then\n"
                f"    {sv} = nil\n"
                f"    {mod}.WipedCutscene()\n"
                f"    return\n  end\n")
        t = t.replace(m.group(1), hook, 1)
        open(ip, 'w', encoding='utf-8').write(t)
    print(f'{g}: WipedCutscene + hook OK')

# ---------------------------------------------------------------------------
# 2. Zones ch5 : mort au segment 2 -> relais (au lieu de l'entrée)
# ---------------------------------------------------------------------------
def patch_zone(zone, seg_deep, relay_idx, sv):
    p = f'Data/Script/halcyon/zone/{zone}/init.lua'
    s = open(p, encoding='utf-8').read()
    if f'-- vague 8 : checkpoint {zone}' in s:
        return
    hook = f'''	elseif segmentID == {seg_deep} and SV.ChapterProgression.Chapter == 5 and result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
		-- vague 8 : checkpoint {zone} — la mort dans la 2e moitié ramène au relais,
		-- où la scène de réveil (WipedCutscene) prend le relai narratif.
		GAME:WaitFrames(20)
		{sv} = 'DeathArrival'
		if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
			GAME:EndDungeonRun(result, "master_zone", -1, {relay_idx}, 0, true, true)
			GAME:WaitFrames(20)
			GAME:EnterZone("master_zone", -1, {relay_idx}, 0)
		else
			GeneralFunctions.EndDungeonRun(result, "master_zone", -1, {relay_idx}, 0, true, true)
		end
'''
    anchor = f'\telseif segmentID == {seg_deep} and result == RogueEssence.Data.GameProgress.ResultType.Cleared and SV.ChapterProgression.Chapter == 5 then'
    assert anchor in s, zone
    s = s.replace(anchor, hook + anchor, 1)
    open(p, 'w', encoding='utf-8').write(s)
    print(f'{zone}: mort seg{seg_deep} -> relais {relay_idx}')

patch_zone('vast_steppe', 2, 62, 'SV.Chapter5.SteppeMidState')
patch_zone('mount_windswept', 2, 63, 'SV.Chapter5.WindsweptMidState')

# searing_tunnel : la mort seg1 route DÉJÀ vers le midpoint (48) — il ne
# manque que le flag pour déclencher la scène.
p = 'Data/Script/halcyon/zone/searing_tunnel/init.lua'
s = open(p, encoding='utf-8').read()
if "TunnelMidState" not in s:
    old = '''\telseif segmentID == 1 then --Searing Depths Exit Segment'''
    assert old in s
    # poser le flag dans les branches de defaite du segment 1
    s2 = s.split(old)
    seg1 = s2[1]
    seg1 = seg1.replace('GAME:EndDungeonRun(result, "master_zone", -1, 48, 0, true, true)',
        "SV.Chapter5.TunnelMidState = 'DeathArrival'\n\t\t\t\tGAME:EndDungeonRun(result, \"master_zone\", -1, 48, 0, true, true)", 1)
    seg1 = seg1.replace('GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 48, 0, true, true)',
        "SV.Chapter5.TunnelMidState = 'DeathArrival'\n\t\t\t\tGeneralFunctions.EndDungeonRun(result, \"master_zone\", -1, 48, 0, true, true)", 1)
    s = s2[0] + old + seg1
    open(p, 'w', encoding='utf-8').write(s)
    print('searing_tunnel: flag DeathArrival pose (routage 48 deja bon)')

# ---------------------------------------------------------------------------
# 3. ch7-10 : les morts post-relais renvoyaient a l'ENTREE DE LA STEPPE (46 !)
#    -> corriger vers leur relais + scene.
# ---------------------------------------------------------------------------
CH710 = {
 'cloven_ruins':      ('cloven_ruins_midpoint', 66, 'SV.Chapter7.RuinsMidState', (2, 3)),
 'crystal_sanctuary': ('crystal_sanctuary_relay', 71, 'SV.Chapter8.SanctuaryMidState', (2, 3)),
 'forgotten_marsh':   ('forgotten_marsh_relay', 73, 'SV.Chapter9.MarshMidState', (2, 3)),
 'celestial_peak':    ('celestial_peak_relay', 75, 'SV.Chapter10.PeakMidState', (2, 3, 4, 5)),
}
for zone, (relay, idx, sv, segs) in CH710.items():
    p = f'Data/Script/halcyon/zone/{zone}/init.lua'
    s = open(p, encoding='utf-8').read()
    # remplacer les retours "46" par le relais, par bloc de segment
    parts = re.split(r'(\n\s*elseif segmentID == \d+|\n\s*if segmentID == \d+)', s)
    out = [parts[0]]
    cur = None
    for i in range(1, len(parts), 2):
        m = re.search(r'segmentID == (\d+)', parts[i])
        cur = int(m.group(1)) if m else None
        seg_txt = parts[i+1] if i+1 < len(parts) else ''
        if cur in segs:
            seg_txt = seg_txt.replace('"master_zone", -1, 46, 0', f'"master_zone", -1, {idx}, 0')
            if 'DeathArrival' not in seg_txt and f'{idx}, 0, true, true' in seg_txt:
                seg_txt = seg_txt.replace(
                    f'GAME:EndDungeonRun(result, "master_zone", -1, {idx}, 0, true, true)',
                    f"{sv} = 'DeathArrival'\n              GAME:EndDungeonRun(result, \"master_zone\", -1, {idx}, 0, true, true)", 1)
        out.append(parts[i]); out.append(seg_txt)
    s = ''.join(out)
    open(p, 'w', encoding='utf-8').write(s)
    print(f'{zone}: morts post-relais -> {relay} ({idx}) + flag')
    # scene dans le relais (init.lua monolithique)
    gp = f'Data/Script/halcyon/ground/{relay}/init.lua'
    t = open(gp, encoding='utf-8').read()
    mod = relay
    if 'WipedCutscene' not in t:
        hx, hy, px, py, cx, cy = WAKE[relay]
        fn = WIPE_FN.format(mod=mod, hx=hx, hy=hy, px=px, py=py, cx=cx, cy=cy,
                            lines=lines_block(SCENES[relay]))
        t = t.rstrip()
        assert t.endswith(f'return {mod}'), relay
        t = t[:-len(f'return {mod}')] + fn + f'\nreturn {mod}\n'
        # hook au debut de Enter
        m = re.search(rf'(function {mod}\.Enter\(map\)\n)', t)
        hook = (m.group(1) +
                f"  if {sv} == 'DeathArrival' then\n"
                f"    {sv} = nil\n"
                f"    {mod}.WipedCutscene()\n"
                f"    return\n  end\n")
        t = t.replace(m.group(1), hook, 1)
        open(gp, 'w', encoding='utf-8').write(t)
        print(f'  {relay}: WipedCutscene + hook Enter OK')
print('vague 8 : checkpoints romanesques poses')
