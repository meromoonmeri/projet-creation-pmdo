-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P15P01A/n01a0502.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_P15P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Sympathy.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Th-this[K] money...!?", french=" C-cet[K] argent...!?", german=" S-so[K] viel Geld?!?", italian=" M-Ma...[K] questi soldi...?!", spanish=" Pero...[K] ¿¡y este dinero...!?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_biidaru = SkySceneKit.spawn_npc("bibarel", 312, 168, Direction.Left, "NPC_BIIDARU")
  pcall(function() UI:SetSpeaker(npc_npc_biidaru) end)
  SkySceneKit.say({english="Take this with you.[K]\nIt's a farewell gift.", french="Prends ça, fiston.[K]\nC'est un cadeau d'adieu.", german="Nimm es mit dir.[K]\nAls Abschiedsgeschenk.", italian="Prendili.[K] Sono un regalo\ndi addio.", spanish="Llévatelo.[K]\nEs un regalo de despedida."})
  pcall(function() UI:SetSpeaker(npc_npc_biidaru) end)
  SkySceneKit.say({english="I always knew this day would\ncome...[K]so I've been saving up, little by little.", french="J'savais bien qu'ce jour\nviendrait... [K]alors j'ai fait des\np'tites économies.", german="Ich wusste immer, dass\ndieser Tag einmal kommen würde...[K]\nDaher habe ich für dich gespart.", italian="Sapevo che questo giorno\nsarebbe arrivato...[K] e così li ho messi\nda parte poco a poco.", spanish="Siempre supe que llegaría\neste día,[K] así que he ido ahorrando poco a poco."})
  pcall(function() UI:SetSpeaker(npc_npc_biidaru) end)
  SkySceneKit.say({english="Please use it in case of\nan emergency.", french=" Utilise ça en cas d'pépin.", german="Ich möchte, dass du es\nfür den Notfall dabei hast.\nMan kann nie wissen!", italian="Per favore, usali solo\nin caso di emergenza.", spanish=" Úsalo en caso de emergencia."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(3) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(1)
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff...[K] M-Mama...", french=" Snif...[K] M-M'man...", german=" Schnüff...[K] M-mama...", italian=" Sniff...[K] Mamma...", spanish=" Buaa...[K] Ma... mamá..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_biidaru) end)
  SkySceneKit.say({english="There, there.[K]\nYou always were a bit of a crybaby.", french="Allons, allons.[K]\nT'as toujours été un peu pleurnichard,\nmon fils.", german="Ach, komm schon.[K]\nMeine kleine Heulsuse...", italian="Su, su.[K]\nAsciugati quelle lacrime.", spanish="Anda, anda.[K]\nNo me seas llorica, pequeñín."})
  pcall(function() UI:SetSpeaker(npc_npc_biidaru) end)
  SkySceneKit.say({english=" Your Mama's rooting for you!", french="Ta maman est fière\nde toi!", german=" Deine Mama unterstützt dich!", italian="La tua mamma pensa sempre\na te!", spanish="¡Tienes todo el apoyo\nde tu mamá!"})
  pcall(function() UI:SetSpeaker(npc_npc_biidaru) end)
  SkySceneKit.say({english="Even though you're going far\naway, you always do your best, you hear?", french="Même si tu t'en vas loin\nd'ici, promets-moi d'faire de ton mieux,\ntoujours, compris?", german="Auch wenn du weit weggehst,\nversuche immer dein Bestes zu geben, ja?", italian="Anche se te ne vai lontano,\nfai sempre del tuo meglio... Hai capito?", spanish="Aunque te vayas lejos,\nesfuérzate siempre al máximo, ¿me oyes?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff... Mama...[K]\nThank you...[K]Mama...", french="Snif... M'man...[K]\nMerci...[K] M'man...", german="Schnief... Mama...[K]\nDanke schön...[K] Mama...", italian="Sniff... Mammina...[K]\nGrazie...[K] mamma...", spanish="Snif... Mamá...[K]\nGracias...[K] Muchas gracias, mamá..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
