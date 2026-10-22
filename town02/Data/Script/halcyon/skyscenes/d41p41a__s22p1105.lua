-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D41P41A/s22p1105.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_D41P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_daakurai = SkySceneKit.spawn_npc("darkrai", 280, 152, Direction.Down, "NPC_DAAKURAI")
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Has it not occurred to you...[K]\nhow odd that accident was?", french="Ça ne t'a jamais effleuré\nl'esprit...[K] que cet accident était fort étrange?", german="Ist dir nie aufgefallen,[K] wie\nseltsam dieser Unfall war?", italian="Non hai mai pensato a quanto\nsia stato strano...[K] quell'incidente?", spanish="¿No has pensado nunca...?[K]\n¿Que fue un accidente muy raro?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(How...[K]odd...?)", french="(Comment ça...[K] étrange...?)", german="(Wie...[K] seltsam?)", italian="(Quanto sia stato...[K] strano?)", spanish="(¿Cómo?[K] ¿A qué te refieres?)"})
  else
  SkySceneKit.say({english="(How...[K]odd...?)", french="(Comment ça...[K] étrange...?)", german="(Wie...[K] seltsam?)", italian="(Quanto sia stato...[K] strano?)", spanish="(¿Cómo?[K] ¿A qué te refieres?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Yes.[K] Think of how the accident\noccurred...", french="Oui, étrange.[K] Pense à la manière\ndont c'est arrivé...", german="Ja.[K] Denk daran, wie der Unfall\nzustande kam...", italian="Sì.[K] Pensa a come ha avuto\nluogo...", spanish="Sí.[K] Piensa en cómo sucedió\nel accidente..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Precisely when you and [CS:N]Grovyle[CR]\nwere traveling through time...", french="Comme par hasard, c'était\nau moment où toi et [CS:N]Massko[CR] étiez en plein\nvoyage dans le temps...", german="Genau dann, als [CS:N]Reptain[CR] und du\ndurch die Zeit gereist seid...", italian="Proprio mentre tu e [CS:N]Grovyle[CR]\nstavate viaggiando nel tempo...", spanish="Justo cuando [CS:N]Grovyle[CR] y tú\nestabais viajando en el tiempo..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" That fails to strike you as odd?", french=" Tu ne trouves pas ça étrange?", german="Das springt dir nicht als seltsam\nins Auge?", italian=" Non ti sembra un po' strano?", spanish=" ¿No te parece raro?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(180) end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]D-Darkrai[CR]...[K] [CS:N]Darkrai[CR], you know\nsomething about it?", french="[CS:N]D-Darkrai[CR]...[K] [CS:N]Darkrai[CR], tu nous\ncaches quelque chose!", german="[CS:N]D-Darkrai[CR]...[K] [CS:N]Darkrai[CR], weißt du\netwas darüber?", italian="[CS:N]D-Darkrai[CR]...[K] [CS:N]Darkrai[CR], ne sai\nqualcosa?", spanish="[CS:N]Da[CR]... [CS:N]Darkrai[CR]...[K] [CS:N]Darkrai[CR], ¿tú\nsabes algo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]D-Darkrai[CR]...[K] [CS:N]Darkrai[CR], you know\nsomething about it?", french="[CS:N]D-Darkrai[CR]...[K] [CS:N]Darkrai[CR], tu nous\ncaches quelque chose!", german="[CS:N]D-Darkrai[CR]...[K] [CS:N]Darkrai[CR], weißt du\netwas darüber?", italian="[CS:N]D-Darkrai[CR]...[K] [CS:N]Darkrai[CR], ne sai\nqualcosa?", spanish="[CS:N]Da[CR]... [CS:N]Darkrai[CR]...[K] [CS:N]Darkrai[CR], ¿tú\nsabes algo?"})
  else
  SkySceneKit.say({english="[CS:N]D-Darkrai[CR]...[K] [CS:N]Darkrai[CR], you know\nsomething about it?", french="[CS:N]D-Darkrai[CR]...[K] [CS:N]Darkrai[CR], tu nous\ncaches quelque chose!", german="[CS:N]D-Darkrai[CR]...[K] [CS:N]Darkrai[CR], weißt du\netwas darüber?", italian="[CS:N]D-Darkrai[CR]...[K] [CS:N]Darkrai[CR], ne sai\nqualcosa?", spanish="[CS:N]Da[CR]... [CS:N]Darkrai[CR]...[K] [CS:N]Darkrai[CR], ¿tú\nsabes algo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Naturally.", french=" Naturellement.", german=" Natürlich.", italian=" Naturalmente.", spanish=" Naturalmente."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="That very accident was caused\nby...[K]none other than myself.", french="Cet accident n'avait rien d'un\nmalencontreux hasard. Il a été provoqué...[K]\npar nul autre que moi!", german="Dieser Unfall wurde von niemand\nanderem als...[K] mir selbst eingefädelt.", italian="Quell'incidente è stato causato\ndal...[K] sottoscritto.", spanish=" Ese accidente...[K] lo provoqué yo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What...?)", french="(Quoi...?)", german="(Was?)", italian="(Cosa...?)", spanish="(¿Qué?)"})
  else
  SkySceneKit.say({english="(What...?)", french="(Quoi...?)", german="(Was?)", italian="(Cosa...?)", spanish="(¿Qué?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What did you say?!", french=" Qu'est-ce que tu dis?!", german=" Was sagst du da?!?", italian=" Cosa hai detto?!", spanish=" ¿Cómo has dicho?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What did you say?!", french=" Qu'est-ce que tu dis?!", german=" Was sagst du da?!?", italian=" Cosa hai detto?!", spanish=" ¿Cómo has dicho?"})
  else
  SkySceneKit.say({english=" What did you say?!", french=" Qu'est-ce que tu dis?!", german=" Was sagst du da?!?", italian=" Cosa hai detto?!", spanish=" ¿Cómo has dicho?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="My wish is...[K]to engulf this\nworld in darkness.", french="Mon but est...[K] de plonger\nce monde dans une ombre éternelle.", german="Mein Wunsch ist es,[K] diese Welt\nin Dunkelheit zu hüllen.", italian="Il mio desiderio è...[K] avvolgere\nquesto mondo nell'oscurità.", spanish="Mi objetivo era, y aún es, sumir\neste mundo...[K] en una oscuridad total."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
