-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D54P11A/enter06.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_metamon_kireihana = SkySceneKit.spawn_npc("bellossom", 256, 200, Direction.Down, "NPC_METAMON_KIREIHANA")
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english="Well...[K] If you're set on going,\nI won't stop you...", french="Hé bien...[K] Si tu es décidée,\nje ne vais pas t'en empêcher...", german="Nun...[K] Du scheinst dir ja sicher\nzu sein. Und ich werde dich nicht aufhalten...", italian="Beh...[K] Non sarò certo io\na fermarvi, ma...", spanish="Bueno...[K] Pareces tan segura que\nno seré yo quien te detenga..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english="But don't you think it might be\nbetter to leave it alone?", french="... mais tu ne penses pas qu'il\nserait préférable de laisser tomber?", german="Aber glaubst du nicht, dass es\nbesser wäre, es gut sein zu lassen?", italian="... non credi che sarebbe meglio\nlasciar perdere?", spanish="Pero ¿no crees que sería mejor\nque os olvidarais del tema?"})
  pcall(function() UI:SetSpeaker(npc_npc_metamon_kireihana) end)
  SkySceneKit.say({english="It's useless to spend\ntime looking for something that's not there.", french="Inutile de perdre du temps\nà chercher quelque chose qui n'est pas là.", german="Es ist reine Zeitverschwendung,\nnach etwas Ausschau zu halten, was nicht\nda ist.", italian="Non ha senso sprecare tempo per\ncercare qualcosa che non c'è.", spanish="Es una pérdida de tiempo\nbuscar algo que no existe."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Thanks, [CS:N]Bellossom[CR].", french=" Merci, [CS:N]Joliflor[CR].", german=" Danke, [CS:N]Blubella[CR].", italian=" Grazie, [CS:N]Bellossom[CR].", spanish=" Gracias, [CS:N]Bellossom[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But making the impossible\npossible...", french=" Mais réaliser l'impossible...", german="Aber das Unmögliche möglich\nzu machen...", italian="Ma rendere possibile\nl'impossibile...", spanish=" Pero hacer posible lo imposible..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="That's what Team [CS:X]Charm[CR]\ndoes best.", french="... c'est ce que l'Equipe [CS:X]Charme[CR]\nfait le mieux.", german="Das ist es, was Team [CS:X]Charme[CR]\nam besten kann.", italian="È per questo che il Team [CS:X]Malia[CR]\nè famoso.", spanish="Es lo que se le da mejor al\n[CS:X]Equipo Carisma[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" So don't worry. [M:H8]", french=" Alors ne t'inquiète pas. [M:H8]", german="Mach dir keine\nSorgen. [M:H8]", italian=" Quindi non preoccuparti. [M:H8]", spanish=" Así que no te preocupes. [M:H8]"})
  -- message_Close
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
