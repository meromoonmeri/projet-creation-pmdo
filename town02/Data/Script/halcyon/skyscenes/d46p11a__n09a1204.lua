-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D46P11A/n09a1204.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  -- back_SetGround(LEVEL_D46P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 200, 272, Direction.Down, "NPC_YONOWAARU_N8")
  -- SetAnimation(36) [anim idle native]
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 40, 224, Direction.Right, "NPC_YAMIRAMI")
  GROUND:MoveToPosition(npc_npc_yamirami, 176, 224, false, 2)
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]S-[K]Sableye[CR]!", french=" [CS:N]T-[K]Ténéfix[CR]!", german=" [CS:N]Z-[CR][K][CS:N]Zobiris[CR]!", italian=" [CS:N]S-[CR][K][CS:N]Sableye[CR]!", spanish=" [CS:N]Sa[CR]...[K] ¡[CS:N]Sableye[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="Wheh-heh-heh!?[K]\n[CS:Y]G-Grovyle[CR]?!", french="Whé hé hé!?[K]\n[CS:Y]M-Massko[CR]?!", german="Wähähäh?!?[K]\n[CS:Y]R-Reptain[CR]?!?", italian="Meh-eh-eh!?[K]\n[CS:Y]G-[CR][K][CS:Y]Grovyle[CR]?!", spanish="¡Je, je![K] ¿Je?\n[CS:Y]Gro[CR]... ¡¿[CS:Y]Grovyle[CR]?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(-160), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]They've found me already...", french=" ...[K] Ils m'ont déjà repéré...", german="...[K]\nSie haben mich schon aufgespürt...", italian=" ...[K] Mi hanno già trovato...", spanish=" ¡No![K] Ya me han encontrado..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I've got to get out of here as\nfast as I can.", french="Je dois quitter cet endroit\nau plus vite.", german="Ich muss hier weg,\nso schnell wie möglich.", italian="Devo andarmene da qui\nil prima possibile.", spanish="Tengo que salir de aquí\nlo antes posible."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]But [CS:N]Dusknoir[CR] was still unconscious then...", french="[CN][CS:N]Noctunoir[CR] était toujours inconscient\n[CN]à ce moment-là...", german="[CN]Aber [CS:N]Zwirrfinst[CR] war zu diesem\n[CN]Zeitpunkt noch bewusstlos...", italian="[CN]Ma in quel momento [CS:N]Dusknoir[CR] era ancora\n[CN]privo di sensi...", spanish="[CN]Pero [CS:N]Dusknoir[CR] seguía inconsciente..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]I thought I was the first of\n[CN]us to wake up...", french="[CN]Je croyais avoir repris connaissance\n[CN]le premier...", german="[CN]Ich dachte, ich sei als Erster\n[CN]von uns beiden aufgewacht...", italian="[CN]Pensavo di essermi risvegliato\n[CN]per primo...", spanish="[CN]Yo creía que había sido\n[CN]el primero en despertar..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]That was incorrect...", french="[CN]J'avais tort...", german="[CN]Aber so war es nicht...", italian="[CN]Ma mi sbagliavo...", spanish="[CN]Pero no fue así..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]It was the other way around!", french="[CN]C'était l'inverse!", german="[CN]Es war vielmehr andersherum!", italian="[CN]In realtà è successo il contrario!", spanish="[CN]¡Fue al revés!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN][CS:N]Dusknoir[CR] regained consciousness before I did.", french="[CN][CS:N]Noctunoir[CR] s'est réveillé avant moi.", german="[CN][CS:N]Zwirrfinst[CR] hat vor mir das\n[CN]Bewusstsein wiedererlangt.", italian="[CN][CS:N]Dusknoir[CR] ha ripreso i sensi prima di me.", spanish="[CN][CS:N]Dusknoir[CR] recobró la consciencia antes que yo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]So he woke up first and talked to the [CS:N]Sableye[CR].", french="[CN]Il en a profité pour parler aux [CS:N]Ténéfix[CR].", german="[CN]Also stand er auf und sprach mit den [CS:N]Zobiris[CR].", italian="[CN]Quindi si è svegliato prima di me\n[CN]e ha parlato con i [CS:N]Sableye[CR].", spanish="[CN]Se despertó antes y habló con los [CS:N]Sableye[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]This...[K]plan of his...", french="[CN]Son...[K] son plan...", german="[CN]So ein...[K] perfider Plan...", italian="[CN]Questo...[K] suo piano...", spanish="[CN]Ese era...[K] su plan..."})
  -- message_Close
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
