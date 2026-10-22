#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Refonte du rêve du Mont Venteux (chap. 5) — réassemblage de
mount_windswept_entrance_ch_5.lua (voir docs/CONCEPTION_songe_source.md).

  * CampNightfall       : sections 1-9 conservées ; section 10 remplacée
                          par un renvoi vers la map songe_source ;
  * DreamWakeAndMorning : NOUVELLE fonction (réveil agité + veille de
                          Phileas + sections 11-16 déplacées + queue de
                          l'ancienne ArrivalCutscene) ;
  * ArrivalCutscene     : fin remplacée par la transition vers le songe.

Bornes vérifiées par assertions sur le texte d'origine avant toute
écriture. UN SEUL PASSAGE : le script refuse de rejouer sur son propre
résultat.
"""
import io, sys

P = 'Data/Script/halcyon/ground/mount_windswept_entrance/mount_windswept_entrance_ch_5.lua'

txt = io.open(P, encoding='utf-8').read()
if 'DreamWakeAndMorning' in txt:
    sys.exit('deja applique — on ne rejoue pas la refonte')

lines = txt.split('\n')
head     = lines[0:608]
sections = lines[664:1271]
middle   = lines[1272:1914]
tail     = lines[1942:]

assert lines[606].strip() == 'GAME:WaitFrames(60)', lines[606]
assert '11. LE MATIN' in sections[1], sections[1]
assert sections[-1].strip() == 'GAME:WaitFrames(30)', sections[-1]
assert middle[-2].strip() == 'reinier = girafarig, kino = breloom})', middle[-2]
assert middle[-1].strip() == '', repr(middle[-1])
assert tail[0].startswith('--Ganlon hasn'), tail[0][:40]

CAMP_CLOSE = '''\t---------------------------------------------------------------
\t-- 10. LE SONGE — DEPLACE sur sa propre carte
\t---------------------------------------------------------------
\t--Regle 6 du mode operatoire (docs/CARTE_BLANCHE_CUTSCENES.md) : un
\t--heros qui dort et reve est PHYSIQUEMENT present dans son reve —
\t--jamais un ecran noir. L'ancien reve (planche Genesis_Void sur
\t--fondu) a ete demoli ; le songe se joue sur la map 'songe_source'
\t--(docs/CONCEPTION_songe_source.md). ArrivalCutscene enchaine sur
\t--EnterGroundMap ; la nuit se termine au retour, dans
\t--DreamWakeAndMorning ci-dessous.
end'''

PROLOGUE = '''--------------------------------------------------------------------
-- LA NUIT, DEUXIEME PARTIE — retour du songe
--------------------------------------------------------------------
--Jouee au retour de 'songe_source' (route : init.PlotScripting). La
--carte arrive FRAICHE : tout le camp de nuit est reconstruit sous le
--noir, a L'ETAT EXACT ou CampNightfall l'a laisse (qui dort ou, quel
--plan, dans quelle posture), puis :
--  a. LE REVEIL AGITE   le reve colle a la peau, le heros sursaute
--  b. LA VEILLE         Phileas a entendu : il quitte son poste,
--                       s'approche a distance credible, rassure, puis
--                       retourne veiller (trajet BFS prouve :
--                       corridor ouest, ~26 px des dormeurs max)
--  c. LE MATIN          reveil, rassemblement, cordees, departs,
--                       scene finale — reprises a l'identique de la
--                       veillee d'origine.
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.DreamWakeAndMorning()
\tlocal hero = CH('PLAYER')
\tlocal partner = CH('Teammate1')
\tlocal B = mount_windswept_entrance_ch_5.BEDS
\tlocal mountain = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('mount_windswept')
\tlocal ruins = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('cloven_ruins')
\tlocal function seatX(i) return B[i][1] + 13 end
\tlocal function seatY(i) return B[i][2] + 10 end

\tGAME:CutsceneMode(true)
\tAI:DisableCharacterAI(partner)
\tSOUND:StopBGM()
\tGAME:FadeOut(false, 1)

\t--Mise en place sous le noir : paillasses + feu (constructeur
\t--partage), nuit noire, et CHAQUE dormeur a SA couche dans SA
\t--posture de fin de section 9 (Sleep / EventSleep identiques).
\t--Phileas, lui, est a son poste de veille (256,148).
\tmount_windswept_entrance_ch_5.DeployBeds()
\tGROUND:AddMapStatus("darkness")

\tlocal tropius, noctowl, audino, snubbull, girafarig, breloom, growlithe, zigzagoon, mareep, cranidos =
\t\tCharacterEssentials.MakeCharactersFromList({
\t\t\t{'Tropius',   seatX(1),  seatY(1),  Direction.Down},
\t\t\t{'Audino',    seatX(10), seatY(10), Direction.Down},
\t\t\t{'Snubbull',  seatX(12), seatY(12), Direction.Down},
\t\t\t{'Girafarig', seatX(3),  seatY(3),  Direction.Left},
\t\t\t{'Breloom',   seatX(11), seatY(11), Direction.Left},
\t\t\t{'Growlithe', seatX(8),  seatY(8),  Direction.Up},
\t\t\t{'Zigzagoon', seatX(9),  seatY(9),  Direction.Right},
\t\t\t{'Mareep',    seatX(5),  seatY(5),  Direction.Up},
\t\t\t{'Cranidos',  seatX(4),  seatY(4),  Direction.Up},
\t\t\t{'Noctowl',   256, 148, Direction.Down}
\t\t})
\tlocal t = {penticus = tropius, phileas = noctowl,
\t           rin = audino,      coco = snubbull,
\t           shuca = mareep,    ganlon = cranidos,
\t           hyko = growlithe,  almotz = zigzagoon,
\t           reinier = girafarig, kino = breloom}

\tGROUND:CharSetAnim(t.penticus, "Sleep", true)
\tGROUND:CharSetAnim(t.rin, "Sleep", true)
\tGROUND:CharSetAnim(t.coco, "Sleep", true)
\tGROUND:CharSetAnim(t.reinier, "Sleep", true)
\tGROUND:CharSetAnim(t.kino, "Sleep", true)
\tGROUND:CharSetAnim(t.hyko, "Sleep", true)
\tGROUND:CharSetAnim(t.almotz, "EventSleep", true)
\tGROUND:CharSetAnim(t.shuca, "Sleep", true)
\tGROUND:CharSetAnim(t.ganlon, "Sleep", true)
\tGROUND:TeleportTo(partner, seatX(6), seatY(6), Direction.Up)
\tGROUND:CharSetAnim(partner, "EventSleep", true)
\tGROUND:TeleportTo(hero, seatX(7), seatY(7), Direction.Up)
\tGROUND:CharSetAnim(hero, "EventSleep", true)

\tGAME:MoveCamera(256, 230, 1, false)
\tGAME:FadeIn(60)
\tGAME:WaitFrames(50)

\t---------------------------------------------------------------
\t-- a. LE REVEIL AGITE — le reve colle a la peau
\t---------------------------------------------------------------
\t--Patron du reveil de la DiedCutscene du Tunnel : sursauts, Wake,
\t--regard perdu. Personne d'autre ne bouge : il est seul a l'avoir vu.
\tGeneralFunctions.Shake(hero)
\tGAME:WaitFrames(10)
\tGeneralFunctions.Shake(hero)
\tGAME:WaitFrames(16)
\tGeneralFunctions.DoAnimation(hero, 'Wake')
\tGAME:WaitFrames(24)
\tGeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Up)
\tGAME:WaitFrames(14)
\tGAME:MoveCamera(232, 262, 70, false)
\tGAME:WaitFrames(10)

\t--Ses pensees dans la nuit : ce sont les anciennes MWE5_085/086,
\t--qui ont plus de poids ICI, au pied du lit, que sur le fondu noir
\t--de l'ancien reve.
\tUI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
\tUI:SetSpeakerEmotion("Shouting")
\tUI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_085']))
\tGAME:WaitFrames(18)
\tUI:SetSpeakerEmotion("Worried")
\tUI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_086']))
\tUI:ResetSpeaker()
\tGAME:WaitFrames(26)

\t---------------------------------------------------------------
\t-- b. LA VEILLE — Phileas ne peut pas rester passif
\t---------------------------------------------------------------
\t--Le heros s'est reveille en sursaut sous sa fenetre : le veilleur a
\t--ENTENDU. Un battement, puis il quitte son poste. Trajet verifie
\t--BFS sur la grille du .rsground : corridor a l'ouest du maitre de
\t--guilde, jamais a moins de 26 px d'un dormeur ; arret a deux cases
\t--du lit (distance credible), tourne vers le heros.
\tGROUND:CharSetEmote(t.phileas, "notice", 1)
\tGAME:WaitFrames(22)
\tGeneralFunctions.EightWayMove(t.phileas, 244, 156, false, 1)
\tGeneralFunctions.EightWayMove(t.phileas, 244, 204, false, 1)
\tGeneralFunctions.EightWayMove(t.phileas, 236, 268, false, 1)
\tGROUND:CharTurnToCharAnimated(t.phileas, hero, 4)
\tGAME:WaitFrames(12)

\tUI:SetSpeaker(t.phileas)
\tUI:SetSpeakerEmotion("Normal")
\tUI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_090']))
\tGAME:WaitFrames(12)

\t--Le heros sursaute : il croyait la nuit vide.
\tGROUND:CharSetEmote(hero, "shock", 1)
\tGROUND:CharTurnToCharAnimated(hero, t.phileas, 4)
\tGAME:WaitFrames(10)
\tUI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
\tUI:SetSpeakerEmotion("Surprised")
\tUI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_091']))
\tUI:ResetSpeaker()
\tGAME:WaitFrames(14)

\tUI:SetSpeaker(t.phileas)
\tUI:SetSpeakerEmotion("Normal")
\tUI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_118']))
\tGAME:WaitFrames(12)
\tUI:SetSpeakerEmotion("Happy")
\tUI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_119']))
\tGAME:WaitFrames(18)

\t--Le heros rend les armes a la nuit ; Phileas le regarde se
\t--recoucher, PUIS repart — on ne quitte jamais le plan avant la
\t--fin du geste. Retour par le meme corridor, reposture de veille.
\tGROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
\tGROUND:CharSetAnim(hero, "EventSleep", true)
\tGAME:WaitFrames(24)
\tGeneralFunctions.EightWayMove(t.phileas, 244, 204, false, 1)
\tGeneralFunctions.EightWayMove(t.phileas, 244, 156, false, 1)
\tGeneralFunctions.EightWayMove(t.phileas, 256, 148, false, 1)
\tGROUND:CharAnimateTurnTo(t.phileas, Direction.Down, 4)
\tGAME:WaitFrames(20)
\tGAME:MoveCamera(256, 230, 80, false)
\tGAME:WaitFrames(30)

\tGAME:FadeOut(false, 60)
\tGAME:WaitFrames(60)'''

EPILOGUE = '''
\tGAME:FadeOut(false, 40)
\tGAME:WaitFrames(40)
\tfor _, chara in ipairs({audino, snubbull, girafarig, breloom, growlithe, zigzagoon, tropius, noctowl, mareep, cranidos}) do
\t\tGAME:GetCurrentGround():RemoveTempChar(chara)
\tend

\t--L'EQUIPE DU DONJON = LA CORDEE DU SOMMET. SetParty retire Hyko et
\t--Almotz (restes du Tunnel) et cree Ganlon et Shuca en Teammate2/3 :
\t--la narration et l'equipe de jeu racontent la meme chose.
\tmount_windswept_entrance_ch_5.SetParty()
\thero = CH('PLAYER')
\tpartner = CH('Teammate1')

\tSV.Chapter5.MountDreamDone = false
\tSV.Chapter5.FinishedMountWindsweptIntro = true
\tGAME:CutsceneMode(false)
\tAI:EnableCharacterAI(partner)
\tAI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
\t--LA CAMERA REVIENT AU JOUEUR (forme attestee : searing_tunnel:1480).
\tGAME:MoveCamera(0, 0, 1, true)
\tSOUND:PlayBGM('Sky Peak Prairie.ogg', true)
\tGAME:FadeIn(40)
end'''

ARRIVAL_TAIL = '''
\t--------------------------------------------------------------------
\t-- LA NUIT CONTINUE DANS LE SONGE
\t--------------------------------------------------------------------
\t--Le camp dort. Le heros est emporte sur la carte dediee au reve
\t--(regle 6 du mode operatoire : physiquement present, jamais un
\t--ecran noir ; docs/CONCEPTION_songe_source.md). Le drapeau est pose
\t--AVANT le changement de carte : un rechargement en plein songe le
\t--relance proprement (filet de songe_source.init). Au retour,
\t--PlotScripting enchaine sur DreamWakeAndMorning (reveil, veille,
\t--matin) : c'est elle qui termine l'ancienne queue de cette fonction
\t--(nettoyage, SetParty, passage de relais au joueur).
\tSV.Chapter5.MountDreamPending = true
\tGAME:CutsceneMode(false)
\tGAME:EnterGroundMap('songe_source', 'Main_Entrance_Marker')
end '''

out = []
out += head
out += CAMP_CLOSE.split('\n')
out += ['', '']
out += PROLOGUE.split('\n')
out += ['']
out += sections
out += EPILOGUE.split('\n')
out += ['']
out += middle
out += ARRIVAL_TAIL.split('\n')
out += tail

io.open(P, 'w', encoding='utf-8').write('\n'.join(out))
print('OK —', len(out), 'lignes ecrites')
