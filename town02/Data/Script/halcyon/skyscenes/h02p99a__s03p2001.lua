-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s03p2001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_manafi = SkySceneKit.spawn_npc("manaphy", 312, 184, Direction.Down, "NPC_MANAFI")
  -- SetAnimation(46) [anim idle native]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 280, 184, Direction.DownRight, "NPC_PERAPPU")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ah! You obtained a Phione Dew!", french="Ah! Vous avez trouvé une Rosée\nPhione!", german=" Ah! Du hast Phione-Tau erhalten!", italian="Ah! Avete trovato la\nBrina Phione!", spanish="¡Ah! ¡Habéis conseguido un\nRocío Phione!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Quick! Give it to [CS:N]Manaphy[CR]!", french=" Vite! Donnez-la à [CS:N]Manaphy[CR]!", german=" Schnell! Gib ihn [CS:N]Manaphy[CR]!", italian=" Forza! Datela a [CS:N]Manaphy[CR]!", spanish=" ¡Deprisa! ¡Dáselo a [CS:N]Manaphy[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK!", french=" Oui!", german=" Okay!", italian=" Ok!", spanish=" ¡De acuerdo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK!", french=" Oui!", german=" Okay!", italian=" Ok!", spanish=" ¡De acuerdo!"})
  else
  SkySceneKit.say({english=" OK!", french=" Oui!", german=" Okay!", italian=" Ok!", spanish=" ¡De acuerdo!"})
  end
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.Right)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Here you go, [CS:N]Manaphy[CR].[K]\nIt's a Phione Dew.", french="Et voilà, [CS:N]Manaphy[CR].[K]\nC'est une Rosée Phione.", german="Bitte schön, [CS:N]Manaphy[CR].[K]\nDas ist Phione-Tau.", italian="Ecco, [CS:N]Manaphy[CR].[K]\nÈ la Brina Phione.", spanish="Tómate esto, [CS:N]Manaphy[CR].[K]\nEs un Rocío Phione."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Here, take this, [CS:N]Manaphy[CR].[K]\nIt's a Phione Dew.", french="Et voilà, [CS:N]Manaphy[CR].[K]\nC'est une Rosée Phione.", german="Hier, nimm das, [CS:N]Manaphy[CR].[K]\nDas ist Phione-Tau.", italian="Ecco, [CS:N]Manaphy[CR].[K]\nÈ la Brina Phione.", spanish="Tómate esto, [CS:N]Manaphy[CR].[K]\nEs un Rocío Phione."})
  else
  SkySceneKit.say({english="Here, take this, [CS:N]Manaphy[CR].[K]\nIt's a Phione Dew.", french="Et voilà, [CS:N]Manaphy[CR].[K]\nC'est une Rosée Phione.", german="Hier, nimm das, [CS:N]Manaphy[CR].[K]\nDas ist Phione-Tau.", italian="Ecco, [CS:N]Manaphy[CR].[K]\nÈ la Brina Phione.", spanish="Tómate esto, [CS:N]Manaphy[CR].[K]\nEs un Rocío Phione."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(-8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" ...[K]Urf...", french=" ...[K] Arf...", german=" ...[K]Uff...", italian=" ...[K] Uff...", spanish=" Glup...[K] Uf..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="...[K]Thanks...[K] [hero]...[K]\n[partner]...", french="... [K]Merci...[K] [hero]...[K]\n[partner]...", german="...[K]Danke...[K] [hero]...[K]\n[partner]...", italian="...[K] Grazie...[K] [hero]...[K]\n[partner]...", spanish="Gracias...[K] Gracias...[K]\n[hero]...[K] [partner]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_AT_THE_END_OF_THE_DAY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whew, am I glad!", french=" Ouf, je suis si content!", german=" Puh, bin ich froh!", italian=" Fiuuu, come sono contento!", spanish=" ¡Uf, qué alegría!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Whew, am I glad!", french=" Ouf, je suis si content!", german=" Puh, bin ich froh!", italian=" Fiuuu, come sono contento!", spanish=" ¡Uf, qué alegría!"})
  else
  SkySceneKit.say({english=" Whew, thank goodness!", french=" Ouf, je suis si contente!", german=" Puh, ein Glück!", italian=" Fiuuu, come sono contenta!", spanish=" ¡Uf, qué alegría!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" It seems to be working.", french=" On dirait que ça marche.", german=" Er scheint zu wirken.", italian=" Sembra che funzioni.", spanish=" Parece que funciona."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="He should be fine, given two or\nthree days of rest.", french="Il devrait aller mieux après\ndeux ou trois jours de repos.", german="[CS:N]Manaphy[CR] sollte nach ein paar\nTagen Ruhe wieder auf die Beine kommen.", italian="Dovrebbe guarire senza\nproblemi dopo un paio di giorni di riposo.", spanish="Con dos o tres días de descanso\nse pondrá bien."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's great...[K] Am I ever glad...", french=" Tant mieux...[K] Quel soulagement...", german="Das ist großartig...[K]\nIch bin so froh!", italian="È fantastico...[K] Sono così\nfelice...", spanish=" Estupendo...[K] ¡Qué alivio!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's great...[K] Am I ever glad...", french=" Tant mieux...[K] Quel soulagement...", german="Das ist großartig...[K]\nIch bin so froh!", italian="È fantastico...[K] Sono così\nfelice...", spanish=" Estupendo...[K] ¡Qué alivio!"})
  else
  SkySceneKit.say({english=" That's great...[K] Am I ever glad...", french=" Tant mieux...[K] Quel soulagement...", german="Das ist großartig...[K]\nIch bin so froh!", italian="È fantastico...[K] Sono così\nfelice...", spanish=" Estupendo...[K] ¡Qué alivio!"})
  end
  -- message_Close
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
