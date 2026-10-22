-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/s03p1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Chatot[CR]'s going to search inside\nfor us, [hero].", french="[CS:N]Pijako[CR] va inspecter\nla Guilde pour nous, [hero].", german="[CS:N]Plaudagei[CR] sucht drinnen für uns,\n[hero].", italian="[CS:N]Chatot[CR] condurrà le ricerche\nall'interno della Gilda, [hero].", spanish="[CS:N]Chatot[CR] mirará en el [CS:N]Pokégremio[CR],\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Chatot[CR]'s going to search inside\nfor us, [hero].", french="[CS:N]Pijako[CR] va inspecter\nla Guilde pour nous, [hero].", german="[CS:N]Plaudagei[CR] sucht drinnen für uns,\n[hero].", italian="[CS:N]Chatot[CR] condurrà le ricerche\nall'interno della Gilda, [hero].", spanish="[CS:N]Chatot[CR] mirará en el [CS:N]Pokégremio[CR],\n[hero]."})
  else
  SkySceneKit.say({english="[CS:N]Chatot[CR]'s going to search inside\nfor us, [hero].", french="[CS:N]Pijako[CR] va inspecter\nla Guilde pour nous, [hero].", german="[CS:N]Plaudagei[CR] sucht drinnen für uns,\n[hero].", italian="[CS:N]Chatot[CR] condurrà le ricerche\nall'interno della Gilda, [hero].", spanish="[CS:N]Chatot[CR] mirará en el [CS:N]Pokégremio[CR],\n[hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We have to look outside!", french="Nous devons chercher aux\nalentours!", german=" Wir müssen draußen suchen!", italian=" Noi dobbiamo cercare fuori!", spanish="¡Busquemos nosotros por\nlos alrededores!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We should be looking outside!", french="Nous devons chercher aux\nalentours!", german=" Wir sollten draußen suchen!", italian=" Noi dobbiamo cercare fuori!", spanish="¡Busquemos nosotros por\nlos alrededores!"})
  else
  SkySceneKit.say({english=" We should be searching outside!", french="Nous devons chercher aux\nalentours!", german=" Wir sollten draußen suchen!", italian=" Noi dobbiamo cercare fuori!", spanish=" ¡Busquemos por los alrededores!"})
  end
  -- message_Close
end
