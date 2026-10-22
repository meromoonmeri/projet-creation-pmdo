-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D08P11A/m09a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Are you ready to get going,\n[hero]?", french=" On peut y aller, [hero]?", german="Bist du bereit, zu gehen,\n[hero]?", italian="Tutto pronto per la partenza,\n[hero]?", spanish=" ¿Nos vamos, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" On peut y aller, [hero]?", german=" Bist du so weit, [hero]?", italian="Tutto pronto per la partenza,\n[hero]?", spanish="¿Seguimos adelante,\n[hero]?"})
  else
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" On peut y aller, [hero]?", german=" Bist du so weit, [hero]?", italian="Tutto pronto per la partenza,\n[hero]?", spanish=" ¿Vamos, [hero]?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="Not yet", french="Pas encore", german="Noch nicht", italian="Aspetta", spanish="Aún no"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Tell me when you're set.", french=" Dis-moi quand on peut y aller.", german=" Sag mir, wenn du fertig bist.", italian=" Dimmi quando è tutto pronto.", spanish="Avísame cuando quieras\ncontinuar."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Tell me when you're\nready.", french=" Dis-moi quand on peut y aller.", german=" Sag mir, wenn du so weit bist.", italian=" Dimmi quando è tutto pronto.", spanish="Avísame cuando quieras\ncontinuar."})
  else
  SkySceneKit.say({english="Tell me when you're\nready.", french=" Dis-moi quand on peut y aller.", german=" Sag mir, wenn du so weit bist.", italian=" Dimmi quando è tutto pronto.", spanish="Avísame cuando quieras\ncontinuar."})
  end
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Which way should we go?", french=" On prend quel chemin?", german=" Welchen Weg nehmen wir?", italian=" Da che parte dobbiamo andare?", spanish=" ¿Por dónde vamos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Which way should we go?", french=" On prend quel chemin?", german=" Welchen Weg nehmen wir?", italian=" Da che parte dobbiamo andare?", spanish=" ¿Por dónde vamos?"})
  else
  SkySceneKit.say({english=" Which way should we go?", french=" On prend quel chemin?", german=" Welchen Weg nehmen wir?", italian=" Da che parte dobbiamo andare?", spanish=" ¿Por dónde vamos?"})
  end
  do local __choice = SkySceneKit.ask({{english="[CS:P]Foggy Forest[CR]", french="Par la [CS:P]Forêt Brumeuse[CR]", german="[CS:P]Nebelwald[CR]", italian="[CS:P]Foresta Bruma[CR]", spanish="[CS:P]Bosque Niebla[CR]"}, {english="[CS:P]Forest Path[CR]", french="Par le [CS:P]Chemin Sylvestre[CR]", german="[CS:P]Waldpfad[CR]", italian="[CS:P]Pista Silvestre[CR]", spanish="[CS:P]Paso Boscoso[CR]"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[5] = 1 -- $SCENARIO_MAIN_BIT_FLAG[5] = 1 (ROM)
  -- message_Close
  GAME:FadeOut(false,  30)
  GAME:WaitFrames(10)
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:TeleportTo(hero, 316, 308, Direction.Down)
  GROUND:TeleportTo(partner, 284, 308, Direction.Down)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:FadeIn(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right. [CS:P]Forest Path[CR] it is.", french="D'accord, passons par le [CS:P]Chemin\nSylvestre[CR].", german=" Gut. Wir nehmen den [CS:P]Waldpfad[CR].", italian="D'accordo. Andiamo verso la\n[CS:P]Pista Silvestre[CR].", spanish=" De acuerdo. ¡Al [CS:P]Paso Boscoso[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" All right. [CS:P]Forest Path[CR] it is.", french="D'accord, passons par le [CS:P]Chemin\nSylvestre[CR].", german=" Gut. Wir nehmen den [CS:P]Waldpfad[CR].", italian="D'accordo. Andiamo verso la\n[CS:P]Pista Silvestre[CR].", spanish=" De acuerdo. ¡Al [CS:P]Paso Boscoso[CR]!"})
  else
  SkySceneKit.say({english=" All right. [CS:P]Forest Path[CR] it is.", french="D'accord, passons par le [CS:P]Chemin\nSylvestre[CR].", german=" Gut. Wir nehmen den [CS:P]Waldpfad[CR].", italian="D'accordo. Andiamo verso la\n[CS:P]Pista Silvestre[CR].", spanish=" De acuerdo. ¡Al [CS:P]Paso Boscoso[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allons-y! En route!", german=" Okay! Nichts wie los!", italian=" Forza! Muoviamoci!", spanish=" Está bien. ¡Adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allons-y! En route!", german=" Okay! Nichts wie los!", italian=" Forza! Muoviamoci!", spanish=" Está bien. ¡Adelante!"})
  else
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allons-y! En route!", german=" Okay! Nichts wie los!", italian=" Forza! Muoviamoci!", spanish=" Está bien. ¡Adelante!"})
  end
  -- message_Close
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[5] = 0 -- $SCENARIO_MAIN_BIT_FLAG[5] = 0 (ROM)
  -- message_Close
  GAME:FadeOut(false,  30)
  GAME:WaitFrames(10)
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:TeleportTo(hero, 316, 308, Direction.Down)
  GROUND:TeleportTo(partner, 284, 308, Direction.Down)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right. [CS:P]Foggy Forest[CR] it is.", french="D'accord. Allons dans la [CS:P]Forêt\nBrumeuse[CR].", german="Gut. Wir gehen durch den\n[CS:P]Nebelwald[CR].", italian="D'accordo. Andiamo verso la\n[CS:P]Foresta Bruma[CR].", spanish=" De acuerdo. ¡Al [CS:P]Bosque Niebla[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" All right. [CS:P]Foggy Forest[CR] it is.", french="D'accord. Allons dans la [CS:P]Forêt\nBrumeuse[CR].", german="Gut. Wir gehen durch den\n[CS:P]Nebelwald[CR].", italian="D'accordo. Andiamo verso la\n[CS:P]Foresta Bruma[CR].", spanish=" De acuerdo. ¡Al [CS:P]Bosque Niebla[CR]!"})
  else
  SkySceneKit.say({english=" All right. [CS:P]Foggy Forest[CR] it is.", french="D'accord. Allons dans la [CS:P]Forêt\nBrumeuse[CR].", german="Gut. Wir gehen durch den\n[CS:P]Nebelwald[CR].", italian="D'accordo. Andiamo verso la\n[CS:P]Foresta Bruma[CR].", spanish=" De acuerdo. ¡Al [CS:P]Bosque Niebla[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allons-y! En route!", german=" Okay! Nichts wie los!", italian=" Forza! Muoviamoci!", spanish=" Está bien. ¡Adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allons-y! En route!", german=" Okay! Nichts wie los!", italian=" Forza! Muoviamoci!", spanish=" Está bien. ¡Adelante!"})
  else
  SkySceneKit.say({english=" All right! Let's roll out!", french=" Allons-y! En route!", german=" Okay! Nichts wie los!", italian=" Forza! Muoviamoci!", spanish=" Está bien. ¡Adelante!"})
  end
  -- message_Close
  -- @label_4 [étiquette de flux ExplorerScript]
  GROUND:MoveToPosition(partner, 300, 100, false, 2)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() GAME:MoveCamera(300, 228, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 300, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Anyway...)", french="(Après tout...)", german="(Wie auch immer...)", italian="(Ad ogni modo...)", spanish="(Bueno...)"})
  else
  SkySceneKit.say({english="(Anyway...)", french="(Après tout...)", german="(Wie auch immer...)", italian="(Ad ogni modo...)", spanish="(Bueno...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Maybe the keys to unlocking my memory\nare here...)", french="(Peut-être que c'est là-bas que je pourrai\nretrouver la mémoire...)", german="(Vielleicht liegt hier der Schlüssel zu meinem\nverlorenen Gedächtnis.)", italian="(... forse la chiave per sbloccare la mia\nmemoria si trova qui...)", spanish="(Tal vez la clave para recuperar mi memoria\nse encuentre aquí...)"})
  else
  SkySceneKit.say({english="(Maybe the keys to unlocking my memory\nare here...)", french="(Peut-être que c'est là-bas que je pourrai\nretrouver la mémoire...)", german="(Vielleicht liegt hier der Schlüssel zu meinem\nverlorenen Gedächtnis.)", italian="(... forse la chiave per sbloccare la mia\nmemoria si trova qui...)", spanish="(Tal vez la clave para recuperar mi memoria\nse encuentre aquí...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:P]Fogbound Lake[CR]...)", french="(Le [CS:P]Lac des Brumes[CR]...)", german="([CS:P]Nebelsee[CR]...)", italian="([CS:P]Lago Foschia[CR]...)", spanish="(En el [CS:P]Lago Velado[CR].)"})
  else
  SkySceneKit.say({english="([CS:P]Fogbound Lake[CR]...)", french="(Le [CS:P]Lac des Brumes[CR]...)", german="([CS:P]Nebelsee[CR]...)", italian="([CS:P]Lago Foschia[CR]...)", spanish="(En el [CS:P]Lago Velado[CR].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I may find some answers if [CS:P]Fogbound Lake[CR]\ncan be found...)", french="(Peut-être que je trouverai des réponses au\n[CS:P]Lac des Brumes[CR]...)", german="(Vielleicht erhalte ich ein paar Antworten,\nwenn wir den [CS:P]Nebelsee[CR] finden.)", italian="(... potrei ottenere delle risposte se riusciamo\na trovare il [CS:P]Lago Foschia[CR]...)", spanish="(Tal vez encuentre alguna respuesta\nsi doy con el [CS:P]Lago Velado[CR]...)"})
  else
  SkySceneKit.say({english="(I may find some answers if [CS:P]Fogbound Lake[CR]\ncan be found...)", french="(Peut-être que je trouverai des réponses au\n[CS:P]Lac des Brumes[CR]...)", german="(Vielleicht erhalte ich ein paar Antworten,\nwenn wir den [CS:P]Nebelsee[CR] finden.)", italian="(... potrei ottenere delle risposte se riusciamo\na trovare il [CS:P]Lago Foschia[CR]...)", spanish="(Tal vez encuentre alguna respuesta\nsi doy con el [CS:P]Lago Velado[CR]...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? What is this?", french=" Hein? Qu'est-ce que c'est?", german=" Huch? Was ist das?", italian=" Eh? E questa cos'è?", spanish=" ¿Eh? ¿Qué es esto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh? What is this?", french=" Hein? Qu'est-ce que c'est?", german=" Huch? Was ist das?", italian=" Eh? E questa cos'è?", spanish=" ¿Eh? ¿Qué es esto?"})
  else
  SkySceneKit.say({english=" Huh? What is this?", french=" Hein? Qu'est-ce que c'est?", german=" Huch? Was ist das?", italian=" Eh? E questa cos'è?", spanish=" ¿Eh? ¿Qué es esto?"})
  end
  -- message_Close
  GROUND:EntTurn(partner, Direction.Left)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GAME:MoveCamera(300, 132, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 300, 132, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It looks like some kind of stone,\nI guess.", french=" On dirait une sorte de pierre.", german="Sieht aus wie eine Art Stein,\nwürde ich sagen.", italian=" Sembra una pietra.", spanish=" Parece algún tipo de piedra."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It looks like some kind of stone,\nI guess.", french=" On dirait une sorte de pierre.", german="Sieht aus wie eine Art Stein,\nwürde ich sagen.", italian=" Sembra una pietra.", spanish=" Parece algún tipo de piedra."})
  else
  SkySceneKit.say({english="It looks like some kind of stone,\nI guess.", french=" On dirait une sorte de pierre.", german="Sieht aus wie eine Art Stein,\nwürde ich sagen.", italian=" Sembra una pietra.", spanish="Supongo que es algún tipo de\npiedra."})
  end
  -- message_KeyWait
  GROUND:EntTurn(hero, Direction.UpLeft)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's red and pretty. It's kind of\nlike a gem, actually.", french="Elle est rouge, et plutôt jolie\navec ça. En fait, c'est une sorte de gemme.", german="Er ist rot und wunderschön.\nEs ist eher eine Art Edelstein.", italian="È rossa e graziosa. Assomiglia\npiù a una gemma.", spanish="Es roja y hermosa. Más bien\ndebe de ser una piedra preciosa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's red and pretty. It's kind of\nlike a gem, actually.", french="Elle est rouge, et plutôt jolie\navec ça. En fait, c'est une sorte de gemme.", german="Er ist rot und wunderschön.\nEs ist eher eine Art Edelstein.", italian="È rossa e graziosa. Assomiglia\npiù a una gemma.", spanish="Es roja y hermosa. Más bien\ndebe de ser una piedra preciosa."})
  else
  SkySceneKit.say({english="It's red and pretty. It's kind of\nlike a gem, actually.", french="Elle est rouge, et plutôt jolie\navec ça. En fait, c'est une sorte de gemme.", german="Er ist rot und wunderschön.\nEs ist eher eine Art Edelstein.", italian="È rossa e graziosa. Assomiglia\npiù a una gemma.", spanish="Es roja y hermosa. Más bien\ndebe de ser una piedra preciosa."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-16), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][partner] picked\n[CN]up the red stone.", french="[CN][partner] ramasse\n[CN]la pierre rouge.", german="[CN][partner] hebt\n[CN]den roten Stein auf.", italian="[CN][partner] raccoglie\n[CN]la pietra rossa.", spanish="[CN][partner] cogió\n[CN]la piedra roja."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! This stone feels warm!", french=" Hé! Cette pierre est chaude!", german=" Hey! Der Stein ist ganz warm!", italian=" Ehi! Questa pietra è calda!", spanish=" ¡Oye! ¡Esta piedra está caliente!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wow! This stone feels warm!", french=" Hé! Cette pierre est chaude!", german=" Wow! Der Stein ist ganz warm!", italian=" Ehi! Questa pietra è calda!", spanish="¡Vaya! ¡Esta piedra está caliente\nal tacto!"})
  else
  SkySceneKit.say({english=" Wow! It feels warm!", french=" Hé! Cette pierre est chaude!", german=" Wow! Er fühlt sich warm an!", italian=" Ehi! Questa pietra è calda!", spanish=" ¡Vaya! ¡Está caliente!"})
  end
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's like heat is coming from\ninside the stone. It's weird.", french="C'est comme si la chaleur venait\nde l'intérieur de la pierre. C'est bizarre.", german="Als würde aus dem Inneren des\nSteins Hitze kommen. Wie seltsam.", italian="È come se il calore provenisse\nda dentro la pietra. Molto strano.", spanish="¡Es como si emitiera calor!\n¡Qué raro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's like heat is coming from\ninside the stone. It's weird.", french="C'est comme si la chaleur venait\nde l'intérieur de la pierre. C'est bizarre.", german="Als würde aus dem Inneren des\nSteins Hitze kommen. Wie seltsam.", italian="È come se il calore provenisse\nda dentro la pietra. Molto strano.", spanish="¡Es como si emitiera calor!\n¡Qué raro!"})
  else
  SkySceneKit.say({english="It's like heat is coming from\ninside the stone. It's weird.", french="C'est comme si la chaleur venait\nde l'intérieur de la pierre. C'est bizarre.", german="Als würde aus dem Inneren des\nSteins Hitze kommen. Wie seltsam.", italian="È come se il calore provenisse\nda dentro la pietra. Molto strano.", spanish="¡Es como si emitiera calor!\n¡Qué raro!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It doesn't seem to be lava. What\ncould it be?", french="On dirait que ce n'est pas une\nroche ordinaire. Qu'est-ce que c'est?", german="Lava scheint es nicht zu sein.\nAber was könnte es sein?", italian="Non sembra lava. Cosa potrebbe\nessere?", spanish="No parece ser lava. ¿De qué se\ntratará?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It doesn't seem to be lava. What\ncould it be?", french="On dirait que ce n'est pas une\nroche ordinaire. Qu'est-ce que c'est?", german="Lava scheint es nicht zu sein.\nAber was könnte es sein?", italian="Non sembra lava. Cosa potrebbe\nessere?", spanish="No parece ser lava. ¿De qué se\ntratará?"})
  else
  SkySceneKit.say({english="It doesn't seem to be lava. What\ncould it be?", french="On dirait que ce n'est pas une\nroche ordinaire. Qu'est-ce que c'est?", german="Lava scheint es nicht zu sein.\nAber was könnte es sein?", italian="Non sembra lava. Cosa potrebbe\nessere?", spanish="No parece ser lava. ¿De qué se\ntratará?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It might be rare. I'll keep it.", french="C'est sûrement un objet rare.\nJe vais le garder.", german="Vielleicht ist er selten.\nIch nehme ihn mit.", italian="Potrebbe essere rara. La terrò\ncon me.", spanish="Tal vez sea algo valioso.\nLo guardaré."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It might be rare. I'll keep it.", french="C'est sûrement un objet rare.\nJe vais le garder.", german="Vielleicht ist er selten.\nIch nehme ihn mit.", italian="Potrebbe essere rara. La terrò\ncon me.", spanish="Tal vez sea algo valioso.\nLo guardaré."})
  else
  SkySceneKit.say({english=" This could be rare. I'll keep it.", french="C'est sûrement un objet rare.\nJe vais le garder.", german="Er könnte selten sein.\nIch nehme ihn mit.", italian="Potrebbe essere rara. La terrò\ncon me.", spanish="Tal vez sea algo valioso.\nLo guardaré."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right, let's roll,\n[hero]!", french=" Allez, en avant, [hero]!", german=" Okay, gehen wir, [hero]!", italian="Forza, andiamo,\n[hero]!", spanish="Ahora sí, ¡adelante,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="All right, let's roll,\n[hero]!", french=" Allez, en avant, [hero]!", german=" Okay, gehen wir, [hero]!", italian="Forza, andiamo,\n[hero]!", spanish="Ahora sí, ¡adelante,\n[hero]!"})
  else
  SkySceneKit.say({english="All right, let's roll,\n[hero]!", french=" Allez, en avant, [hero]!", german=" Okay, gehen wir, [hero]!", italian="Forza, andiamo,\n[hero]!", spanish="Ahora sí, ¡adelante,\n[hero]!"})
  end
  -- message_Close
  GROUND:MoveToPosition(partner, 300, 12, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 300, 12, false, 2)
  GAME:WaitFrames(45)
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkyProg.set(10, 2) -- $SCENARIO_MAIN = scn[10,2] (ROM)
  if ((SV.SkyScenarioBitFlags or {})[5] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[5]
  -- main_EnterDungeon(13, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  -- main_EnterDungeon(12, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  end
  end
end
