-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/enter03.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  -- @label_0 [étiquette de flux ExplorerScript]
  if (SkyProg.cmp_side(40, 2) < 0) then -- if ROM: scn($SCENARIO_SIDE) < [40, 2]
  -- @label_4 [étiquette de flux ExplorerScript]
  -- debug_Print('BGM_FADEOUT') [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterGround(LEVEL_T01P03A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  -- @label_3 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]There's a notice posted here.[K]\n[CN]Something's written on it...", french="[CN]Il y a une affiche ici.[K]\n[CN]Quelque chose y est écrit...", german="[CN]Hier hängt ein Notizzettel.[K]\n[CN]Etwas steht darauf geschrieben.", italian="[CN]C'è un biglietto.[K]\n[CN]E c'è scritto qualcosa...", spanish="[CN]Aquí hay una nota.[K]\n[CN]A ver qué pone..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"[CS:K]Marowak[CR] Dojo has collapsed.[K] But it will rise\nfrom the rubble again!\"", french="\"Le [CS:K]Dojo Ossatueur[CR] s'est effondré.[K]\nMais il renaîtra de ses cendres!", german="Das [CS:K]Knogga-Dojo[CR] ist eingestürzt.[K] Aber es wird\nsich wieder aus seinen Trümmern erheben!", italian="\"Il Dojo [CS:K]Marowak[CR] è crollato.[K] Ma risorgerà\ndalle macerie!\"", spanish="\"El [CS:K]Dojo Marowak[CR] se ha hundido...[K] ¡pero\nresurgirá de sus cenizas!\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"Yes! The Dojo will be resurrected to its\nformer glory![K]\n- [CS:K]Marowak[CR] Dojo's Sensei -\"", french="Oui! Le Dojo retrouvera sa grandeur passée![K]\n- [CS:K]Ossatueur[CR], sensei du dojo -\"", german="Jawohl! Das Dojo wird seine frühere Pracht\nzurückerlangen![K]\n- Meister des [CS:K]Knogga-Dojos[CR] -", italian="\"Sì! Il Dojo tornerà alla\nsua antica gloria!\"[K]\n- [CS:K]Marowak[CR], maestro del Dojo -", spanish="\"¡Sí! ¡El dojo recuperará la gloria de antaño!\"[K]\n-Maestro [CS:K]Marowak[CR]"})
  -- message_Close
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  elseif __sw == 2 then
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'd like to do some training at\n[CS:K]Marowak[CR] Dojo...", french="J'aimerais m'entraîner un peu\nau [CS:K]Dojo Ossatueur[CR]...", german="Ich würde gerne etwas im\n[CS:K]Knogga-Dojo[CR] trainieren.", italian="Mi piacerebbe allenarmi un po'\nal Dojo [CS:K]Marowak[CR]...", spanish="Me gustaría entrenar un poco\nen el [CS:K]Dojo Marowak[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But if I do that, [CS:N]Haunter[CR] will\nget away!", french="... mais si je fais ça, [CS:N]Spectrum[CR]\nva filer!", german="Aber wenn ich das tue, wird\n[CS:N]Alpollo[CR] entkommen!", italian="Ma se lo faccio, [CS:N]Haunter[CR]\nmi sfuggirà!", spanish="¡Pero es que, si lo hago, [CS:N]Haunter[CR]\nse escapará!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I should hold off for now and go\ncatch [CS:N]Haunter[CR]!", french="Je ferais mieux de me\nconcentrer sur la capture de\n[CS:N]Spectrum[CR] pour l'instant!", german="Ich sollte mich also erst einmal\nzurückhalten und [CS:N]Alpollo[CR] fangen!", italian="Per il momento è meglio che\nlasci perdere e mi metta alla ricerca\ndi [CS:N]Haunter[CR]!", spanish="Mejor me aguanto un poquito y\nvoy a atrapar a [CS:N]Haunter[CR]."})
  -- message_Close
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  if (SkyProg.cmp(6, 0) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [6, 0]
  if ((SV.SkyScenarioBitFlags or {})[12] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[12]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- debug_Print('BGM_FADEOUT') [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false,  30)
  -- screen2_FadeOut [sub déjà caché]
  GAME:WaitFrames(2) -- join WaitScreenFade
  GAME:WaitFrames(2) -- join WaitScreenFadeAll
  GAME:FadeOut(false, 0)
  GAME:FadeIn(0)
  -- supervision_ExecuteCommon(CORO_EVENT_M00_05) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  else
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
end
