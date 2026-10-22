-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V05P02A/m05a0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_V05P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_PERAPPU) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Dewdrops on leaves won't fall...\nThey just hang there, suspended.", french="Les gouttes de rosée ne tombent\nplus des feuilles... Elles y restent suspendues.", german="Tautropfen fallen nicht von\nihren Blättern, sondern bleiben einfach wie\nschwerelos hängen.", italian="Le gocce di rugiada non cadono\ndalle foglie... Rimangono lì, sospese.", spanish="El rocío ya no cae de las hojas.\nSe queda ahí quieto, suspendido en el aire."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="In [CS:P]Treeshroud Forest[CR], time itself\nhas truly stopped.", french="Dans la [CS:P]Forêt Linceul[CR],\nle temps s'est réellement arrêté.", german="Im [CS:P]Schemengehölz[CR] ist\ntatsächlich die Zeit stehen geblieben.", italian="Nella [CS:P]Foresta Arcana[CR], il tempo\nsi è completamente fermato.", spanish="Sí, todo apunta a que el tiempo\nse ha detenido en el [CS:P]Bosque Enraizado[CR]."})
  -- message_Close
  GAME:FadeOut(false, 30)
end
