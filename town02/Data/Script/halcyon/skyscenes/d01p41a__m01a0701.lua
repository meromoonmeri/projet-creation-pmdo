-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P41A/m01a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D01P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 248, 160, Direction.Down, "NPC_ZUBATTO")
  -- SetAnimation(24) [anim idle native]
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 216, 160, Direction.Down, "NPC_DOGAASU")
  -- SetAnimation(24) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Owowow...", french=" Aïe aïe aïe...", german=" Auauau...", italian=" Ahiahiahi...", spanish=" Ay, ay, ay..."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_zubatto, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Ugh...[K] We got roughed up...", french="Argh...[K] On s'est pris une belle\nraclée...", german="Umpf...[K] Sie haben uns\ngeschlagen...", italian=" Ugh...[K] Che batosta...", spanish=" Uf...[K] Nos han dado una buena..."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(45)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="B-blast it... How'd we get wiped\nout by wimps like them?", french="C'est pas vrai... Comment on a\npu se faire battre par ces poules mouillées?", german="V-verflixt... Wie haben diese\nSchwächlinge es geschafft, uns zu schlagen?", italian="M-Maledizione... Come hanno\nfatto a batterci queste due nullità?", spanish="¿Cómo...? ¿Cómo han podido con\nnosotros? ¡Pero si no tienen ni media torta!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Bah![K] Here you go. Take it, then!", french="Bah![K] Tiens, le voilà.\nReprends-le!", german=" Bah![K] Hier, dann nehmt es halt!", italian=" Bah![K] Ecco qua. Tienitelo!", spanish=" ¡Bah![K] Ahí tenéis. ¡Quedáoslo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_zubatto, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6406) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetHeight(10) [neutre/état moteur]
  -- Move2PositionMark<object OBJECT_G01P01A1_93> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P01A1_93) [routine d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2)
  -- MoveHeight(2, 6) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho![K] Don't think you're so\nawesome. Your victory was a fluke!", french="Mouarf![K] Te prends pas trop\nau sérieux. C'était un coup de chance!", german="Whoaho![K] Bildet euch nichts\ndarauf ein! Ihr hattet nur Anfängerglück!", italian="Ah ah![K] Ma non montatevi la\ntesta, adesso! La vostra vittoria è stata solo\nun caso!", spanish="Y...[K] No os creáis que ha sido\npara tanto. ¡Habéis ganado de chiripa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Yeah, you just remember that!", french=" Ouais, oublie jamais ça!", german=" Genau, merkt euch das!", italian=" Sì, vedete di non scordarvelo!", spanish=" ¡Eso! ¡Que no se os olvide!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  GROUND:MoveToPosition(npc_npc_dogaasu, 184, 188, false, 2)
  GAME:WaitFrames(10)
  -- SetAnimation(768) [anim idle native]
  GROUND:MoveToPosition(npc_npc_zubatto, 268, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 176, 316, false, 2)
  GROUND:MoveToPosition(npc_npc_zubatto, 272, 316, false, 2)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh! It's my Relic Fragment!", french="Oh! C'est mon Fragment de\nRelique!", german=" Oh! Mein Reliktfragment!", italian=" Oh! È il mio Frammento Antico!", spanish="¡Mi Reliquia de Piedra!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! It's my Relic Fragment!", french="Oh! C'est mon Fragment de\nRelique!", german=" Oh! Mein Reliktfragment!", italian=" Oh! È il mio Frammento Antico!", spanish="¡Mi Reliquia de Piedra!"})
  else
  SkySceneKit.say({english=" Oh! It's my Relic Fragment!", french="Oh! C'est mon Fragment de\nRelique!", german=" Oh! Mein Reliktfragment!", italian=" Oh! È il mio Frammento Antico!", spanish="¡Mi Reliquia de Piedra!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitSe
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Am I ever glad...[K] I actually\nmanaged to get it back.", french="Je suis si content...[K] J'ai\nvraiment réussi à le récupérer.", german="Ich bin so froh...[K] Ich habe es\ntatsächlich zurückbekommen.", italian="Sono così felice...[K] Sono\nriuscito a riaverlo.", spanish="¡Menos mal! [K]\nHe podido recuperarla."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Am I ever glad...[K] I actually did\nmanage to get it back.", french="Je suis si content...[K] J'ai\nvraiment réussi à le récupérer.", german="Ich bin so froh...[K] Ich habe es\ntatsächlich zurückbekommen.", italian="Sono così felice...[K] Sono\nriuscito a riaverlo.", spanish="¡Menos mal! [K]\nAl fin la he recuperado."})
  else
  SkySceneKit.say({english="Thank goodness...[K] I actually\nmanaged to get it back.", french="Je suis si contente...[K] J'ai\nvraiment réussi à le récupérer.", german="Ich bin so erleichtert...[K] Ich habe\nes tatsächlich zurückbekommen.", italian="Sono così felice...[K] Sono\nriuscita a riaverlo.", spanish="¡Menos mal! [K]\nMe alegro de recuperarla."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's because you were there to\nhelp me, [hero].", french="C'est grâce à ton aide,\n[hero].", german="Und das liegt daran, dass du mir\ngeholfen hast, [hero].", italian="È stato merito tuo,\n[hero].", spanish="Y ha sido gracias a tu ayuda,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's only because you agreed to\nhelp me, [hero].", french="C'est grâce à ton aide,\n[hero].", german="Und das liegt daran, dass du mir\ngeholfen hast, [hero].", italian="È tutto merito tuo,\n[hero].", spanish="Y lo he logrado gracias a tu\nayuda, [hero]."})
  else
  SkySceneKit.say({english="This happened only because you\nhelped me, [hero].", french="C'est grâce à ton aide,\n[hero].", german="Und das liegt daran, dass du mir\ngeholfen hast, [hero].", italian="È tutto merito tuo,\n[hero].", spanish="Y lo he conseguido gracias a tu\nayuda, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Thanks, [hero]!", french=" Merci, [hero]!", german=" Danke, [hero]!", italian=" Grazie, [hero]!", spanish=" ¡Gracias, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Thank you, [hero]!", french=" Merci, [hero]!", german=" Vielen Dank, [hero]!", italian=" Grazie, [hero]!", spanish=" ¡Gracias, [hero]!"})
  else
  SkySceneKit.say({english=" Thank you, [hero]!", french=" Merci, [hero]!", german=" Vielen Dank, [hero]!", italian=" Grazie, [hero]!", spanish=" ¡Gracias, [hero]!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
