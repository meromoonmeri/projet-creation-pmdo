-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D19P11A/m18a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [hero]. Are you\nall ready?", french="Eh, [hero]. On peut y\naller?", german="Hey, [hero]. Bist du\nso weit?", italian="Ehi, [hero]. È tutto\npronto?", spanish=" Oye, [hero]. ¿Nos vamos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey, [hero].\nAre you ready?", french="Eh, [hero]. On peut y\naller?", german="Hey, [hero]. Bist du\nso weit?", italian="Ehi, [hero]. È tutto\npronto?", spanish=" Oye, [hero]. ¿Nos vamos?"})
  else
  SkySceneKit.say({english="Hey, [hero].\nAre you ready?", french="Eh, [hero]. On peut y\naller?", german="Hey, [hero]. Bist du\nso weit?", italian="Ehi, [hero]. È tutto\npronto?", spanish=" Oye, [hero]. ¿Nos vamos?"})
  end
  do local __choice = SkySceneKit.ask({{english="I'm ready!", french="C'est bon!", german="Ich bin so weit!", italian="Tutto pronto!", spanish="¡Ahora mismo!"}, {english="Not yet...", french="Pas encore...", german="Noch nicht...", italian="Non ancora...", spanish="Todavía no..."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We'll go when you're ready.", french="Préviens-moi quand tu veux\ny aller.", german=" Wir gehen, wenn du so weit bist.", italian=" Quando è tutto pronto andiamo.", spanish=" Nos iremos en cuanto digas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go when you're ready.", french="Préviens-moi quand tu veux\ny aller.", german=" Gehen wir, wenn du so weit bist.", italian=" Quando è tutto pronto andiamo.", spanish=" Nos iremos en cuanto digas."})
  else
  SkySceneKit.say({english=" Let's go when you're ready.", french="Préviens-moi quand tu veux\ny aller.", german=" Gehen wir, wenn du so weit bist.", italian=" Quando è tutto pronto andiamo.", spanish=" Nos iremos en cuanto digas."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go before those [CS:N]Sableye[CR]\ncatch up.", french="Partons avant que les [CS:N]Ténéfix[CR]\nnous rattrapent.", german="Gehen wir, bevor die [CS:N]Zobiris[CR]\nuns einholen.", italian="Andiamo prima che quei [CS:N]Sableye[CR]\nci siano addosso.", spanish="Vámonos antes de que esos\n[CS:N]Sableye[CR] nos alcancen."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We need to go before those\n[CS:N]Sableye[CR] catch up.", french="Partons avant que les [CS:N]Ténéfix[CR]\nnous rattrapent.", german="Wir müssen los, bevor die\n[CS:N]Zobiris[CR] uns einholen.", italian="Dobbiamo andare prima che quei\n[CS:N]Sableye[CR] ci raggiungano.", spanish="Vámonos antes de que esos\n[CS:N]Sableye[CR] nos alcancen."})
  else
  SkySceneKit.say({english="Let's go before those [CS:N]Sableye[CR]\ncatch up.", french="Partons avant que les [CS:N]Ténéfix[CR]\nnous rattrapent.", german="Gehen wir, bevor die [CS:N]Zobiris[CR]\nuns einholen.", italian="Andiamo prima che quei [CS:N]Sableye[CR]\nci raggiungano.", spanish="Vámonos antes de que esos\n[CS:N]Sableye[CR] nos alcancen."})
  end
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right![K] Let's roll on out!", french=" D'accord![K] On décampe!", german=" Okay![K] Nichts wie los!", italian=" Va bene![K] Muoviamoci!", spanish=" ¡De acuerdo![K] ¡Vámonos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK![K] Let's go!", french=" D'accord![K] On décampe!", german=" Okay![K] Gehen wir!", italian=" Ok![K] Andiamo!", spanish=" ¡De acuerdo![K] ¡Vámonos!"})
  else
  SkySceneKit.say({english=" OK![K] Let's go!", french=" D'accord![K] On décampe!", german=" Okay![K] Gehen wir!", italian=" Ok![K] Andiamo!", spanish=" ¡De acuerdo![K] ¡Vámonos!"})
  end
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(80), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(80), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(28, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
end
