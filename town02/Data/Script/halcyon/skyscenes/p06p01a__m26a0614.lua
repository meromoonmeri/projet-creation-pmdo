-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P06P01A/m26a0614.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_MEMORIES_RETURNED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(S04P01A) [décor sub chargé: Sub_s04p01a]
  -- back_SetGround(LEVEL_P06P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  SkySubScreen.Show("s04p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [hero], thanks.", french=" Merci, [hero].", german=" [hero], danke.", italian=" [hero], grazie.", spanish=" Gracias, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [hero], thank you.", french=" Merci, [hero].", german=" [hero], danke.", italian=" [hero], grazie.", spanish=" Gracias, [hero]."})
  else
  SkySceneKit.say({english=" [hero], thank you.", french=" Merci, [hero].", german=" [hero], danke.", italian=" [hero], grazie.", spanish=" Gracias, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You were worried about me for\nbeing so down.", french="Tu as fait ce que tu as pu pour\nme remonter le moral.", german="Du hast dir Sorgen gemacht,\nweil ich mich hängen ließ.", italian="Eri in ansia per me perché\nero giù di corda.", spanish="Has visto que estaba deprimido\ny me has animado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You tried to pick me up because\nI was feeling down.", french="Tu as fait ce que tu as pu pour\nme remonter le moral.", german="Du wolltest mich aufmuntern,\nweil ich so niedergeschlagen war.", italian="Hai provato a tirarmi su perché\nnon stavo bene.", spanish="Has visto que estaba deprimido\ny me has animado."})
  else
  SkySceneKit.say({english="You tried to cheer me up\nbecause I was feeling down.", french="Tu as fait ce que tu as pu pour\nme remonter le moral.", german="Du wolltest mich aufmuntern,\nweil ich so niedergeschlagen war.", italian="Hai provato a tirarmi su il\nmorale perché ero giù di corda.", spanish="Has visto que estaba deprimida\ny me has animado."})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
