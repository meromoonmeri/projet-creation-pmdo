-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m03a0502.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkyProg.set(4, 4) -- $SCENARIO_MAIN = scn[4,4] (ROM)
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 472, 216, Direction.Up, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Oh, yes sirree! Reckon you all\nare all ready!", french="Ah, sapristi! Z'avez fini d'vous\npréparer!", german="Oh, jawollja! Ich wette, ihr seid\njetzt bereit!", italian="Sissignore! Direi che potete\npartire!", spanish="¡Sí, señor! ¡Veo que ya lo tenéis\ntodo listo!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Then let's pick ourselves a\nlawbreaker for you to find.", french="Allez, on va vous choisir un\np'tit criminel à débusquer.", german="Dann suchen wir jetzt einen\nGanoven für euch aus.", italian="Forza, scegliamo un ricercato\nche vada bene per voi.", spanish="Vamos a escoger un malhechor\nadecuado para vuestro nivel."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GROUND:MoveToPosition(partner, 420, 212, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 444, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Well, you've got your pick of\nthis sorry bunch of characters.", french="Voilà, vous devez choisir parmi\nc'te bande de bandits et d'voyous.", german="Tja, ihr habt die Wahl zwischen\nall diesen erbärmlichen Typen.", italian="Bene, avete una bella scelta.\nGuardate quanti tipi loschi!", spanish="Como veis, hay un buen surtido\nde Pokémon malvados donde escoger."})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V03P01A) [décor sub chargé: Sub_v03p01a]
  -- camera2_SetPositionMark(Position<'m2', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v03p01a", 15, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's see. Which should we pick?", french=" Alors, lequel choisir?", german="Mal sehen. Welchen sollen wir\nuns aussuchen?", italian=" Vediamo un po'. Quale scegliamo?", spanish="Veamos. ¿Cuál podríamos\nelegir?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's see. Which should we pick?", french=" Alors, lequel choisir?", german="Mal sehen. Welchen sollen wir\nuns aussuchen?", italian=" Vediamo un po'. Quale scegliamo?", spanish="Veamos. ¿Cuál podríamos\nelegir?"})
  else
  SkySceneKit.say({english=" Let's see. Which should we pick?", french=" Alors, lequel choisir?", german="Mal sehen. Welchen sollen wir\nuns aussuchen?", italian=" Vediamo un po'. Quale scegliamo?", spanish="Veamos. ¿Cuál podríamos\nelegir?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Ahem.[K] As your mentor, how\nabout I do the choosing?", french="Hum hum.[K] Comme j'suis vot'\nmanteau... enfin vot' mentor, j'pourrais\np'têt' choisir?", german="Ähem.[K] Wie wäre es, wenn ich,\nals euer Mentor, einen aussuche?", italian="Ahem.[K] Cosa ne dite se lo scelgo\nio, in qualità di mentore?", spanish="Ejem.[K] Como mentor vuestro,\n¿no debería decidirlo yo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Don't pick one that looks scary!", french="Choisis-en un qui ne soit pas\ntrop effrayant!", german="Nimm keinen, der gruselig\naussieht!", italian="Non sceglierne uno che fa\ntroppa paura!", spanish="¡Procura que no sea uno\nque dé mucho miedo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Don't choose anyone too scary!", french="Choisis-en un qui ne soit pas\ntrop effrayant!", german=" Nimm keinen zu Gruseligen!", italian="Non sceglierne uno che fa\ntroppa paura!", spanish="¡Procura evitar los que den\nmucho miedo!"})
  else
  SkySceneKit.say({english=" Please don't pick anyone scary!", french="Choisis-en un qui ne soit pas\ntrop effrayant!", german=" Nimm bitte keinen Gruseligen!", italian="Non sceglierne uno che fa\ntroppa paura!", spanish="¡No escojas ninguno\nque dé mucho miedo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yes sirree, I hear you![K] Let's see.\nEenie, meenie...", french="Ouaip, pigé![K] Voyons voir!\nPlouf, plouf... Ce sera toi le hors-la-loi!", german="Jawollja, verstanden![K] Mal sehen.\nEne mene...", italian="Sissignore, va bene![K] Vediamo.\nAmbarabà...", spanish="¡Sí, señor, entendido![K] Veamos.\nPito, pito, colorito..."})
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(6415) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Stand clear! Updating listings!", french=" Reculez! Mise à jour des tableaux!", german=" Zurücktreten! Infobrett-Aktualisierung!", italian=" Allontanatevi! Aggiornamento lista!", spanish=" ¡A un lado! ¡Cambiando las listas!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Stand clear! Updating listings!", french=" Reculez! Mise à jour des tableaux!", german=" Zurücktreten! Infobrett-Aktualisierung!", italian=" Allontanatevi! Aggiornamento lista!", spanish=" ¡A un lado! ¡Cambiando las listas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- GAP: BGM BGM_EARTHQUAKE1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(15)
  pcall(function() GAME:MoveCamera(444, 212, 1, false) end)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's that? What's happening?", french="Qu'est-ce que c'est? Que se\npasse-t-il?", german=" Was ist das? Was passiert?", italian=" Cosa sta succedendo?", spanish=" ¿Qué es eso? ¿Qué pasa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What's that? What's happening?", french="Qu'est-ce que c'est? Que se\npasse-t-il?", german=" Was ist das? Was passiert?", italian=" Cosa sta succedendo?", spanish=" ¿Qué es eso? ¿Qué ocurre?"})
  else
  SkySceneKit.say({english=" What's that? What's happening?", french="Qu'est-ce que c'est? Que se\npasse-t-il?", german=" Was ist das? Was passiert?", italian=" Cosa sta succedendo?", spanish=" ¿Qué es eso? ¿Qué sucede?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Oh, the data's getting updated.", french="Oh, les infos, elles vont être\nmises à jour.", german="Oh, die Daten werden\naktualisiert.", italian=" Oh, stanno aggiornando i dati.", spanish="Ah, están colgando las listas\nmás recientes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's being...updated?", french=" Mises à jour?", german=" Sie werden... aktualisiert?", italian=" Li stanno... aggiornando?", spanish=" ¿Las listas más recientes?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's being...updated?", french=" Mises à jour?", german=" Sie werden... aktualisiert?", italian=" Li stanno... aggiornando?", spanish=" ¿Las listas más recientes?"})
  else
  SkySceneKit.say({english=" It's being...updated?", french=" Mises à jour?", german=" Sie werden... aktualisiert?", italian=" Li stanno... aggiornando?", spanish=" ¿Las listas más recientes?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(6416) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P03A1_100) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(11) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yikes! Did you see that?! The\npanel flipped over!", french="Hé! T'as vu ça?! Le\npanneau s'est retourné!", german="Oh Mann! Hast du das gesehen?\nDas Brett hat sich umgedreht!", italian="Hai visto?! Il pannello si è\ncapovolto!", spanish="¡Vaya! ¿Habéis visto?\n¡Han dado la vuelta al panel!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yikes! Did you see that?! The\npanel flipped over!", french="Hé! T'as vu ça?! Le\npanneau s'est retourné!", german="Oh Mann! Hast du das gesehen?\nDas Brett hat sich umgedreht!", italian="Hai visto?! Il pannello\nsi è capovolto!", spanish="¡Vaya! ¿Habéis visto?\n¡Han dado la vuelta al panel!"})
  else
  SkySceneKit.say({english="Yikes! Did you see that?! The\npanel flipped over!", french="Hé! T'as vu ça?! Le\npanneau s'est retourné!", german="Oh Mann! Hast du das gesehen?\nDas Brett hat sich umgedreht!", italian="Hai visto?! Il pannello\nsi è capovolto!", spanish="¡Vaya! ¿Habéis visto?\n¡Han dado la vuelta al panel!"})
  end
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V03P02A) [décor sub chargé: Sub_v03p02a]
  -- camera2_SetPositionMark(Position<'m4', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v03p02a", 15, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's going on here?", french=" Ils font quoi, là?", german=" Was passiert denn da?", italian=" Cosa sta succedendo?", spanish=" ¿Qué pasa aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What's going on here?", french=" Ils font quoi, là?", german=" Was passiert denn da?", italian=" Cosa sta succedendo?", spanish=" ¿Qué pasa aquí?"})
  else
  SkySceneKit.say({english=" What's going on here?", french=" Ils font quoi, là?", german=" Was passiert denn da?", italian=" Cosa sta succedendo?", spanish=" ¿Qué pasa aquí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="The Outlaw Notice Board and Job\nBulletin Board are set up on revolving panels.", french="L'Tableau des Missions et celui\ndes Avis d'Recherche, c'est des panneaux\nqu'on peut basculer.", german="Die Job- und Ganoven-\nInfobretter sind auf drehbaren Platten\nangebracht.", italian="La Bacheca dei ricercati e quella\ndelle missioni sono affisse a dei pannelli\nrovesciabili.", spanish="El Tablón \"Se Busca\" y el\nTablón de Anuncios son paneles giratorios."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" While the panel is flipped over...", french=" Quand ils sont basculés...", german="Das Brett wird auf die andere\nSeite gedreht...", italian=" Quando il pannello è capovolto...", spanish="Cuando se le da la vuelta\nal panel..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="A Pokémon named [CS:N]Dugtrio[CR]\nswaps out the old jobs with new ones.", french="... y'a un Pokémon appelé\n[CS:N]Triopikeur[CR] qui remplace les anciennes\nmissions par des nouvelles.", german="Dann tauscht ein Pokémon\nnamens [CS:N]Digdri[CR] die alten Jobs gegen neue aus.", italian="... un Pokémon chiamato [CS:N]Dugtrio[CR]\nsostituisce le missioni vecchie con quelle\nnuove.", spanish="Un Pokémon llamado [CS:N]Dugtrio[CR]\ncambia las misiones antiguas por las nuevas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Dugtrio[CR]?", french=" [CS:N]Triopikeur[CR]?", german=" [CS:N]Digdri[CR]?", italian=" [CS:N]Dugtrio[CR]?", spanish=" ¿[CS:N]Dugtrio[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Dugtrio[CR]?", french=" [CS:N]Triopikeur[CR]?", german=" [CS:N]Digdri[CR]?", italian=" [CS:N]Dugtrio[CR]?", spanish=" ¿[CS:N]Dugtrio[CR]?"})
  else
  SkySceneKit.say({english=" [CS:N]Dugtrio[CR]?", french=" [CS:N]Triopikeur[CR]?", german=" [CS:N]Digdri[CR]?", italian=" [CS:N]Dugtrio[CR]?", spanish=" ¿[CS:N]Dugtrio[CR]?"})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
