-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D14P11A/m14a0112.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D14P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I put my faith in you that time\ntoo, [hero].", french="... Je t'ai fait confiance aussi,\n[hero].", german="Damals habe ich dir auch\nvertraut, [hero].", italian="Anche allora ho creduto in te,\n[hero].", spanish="También confié en ti,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I put my faith in you that time\ntoo, [hero].", french="... Je t'ai fait confiance aussi,\n[hero].", german="Damals habe ich dir auch\nvertraut, [hero].", italian="Anche allora ho creduto in te,\n[hero].", spanish="También confié en ti,\n[hero]."})
  else
  SkySceneKit.say({english="I put my faith in you that time\ntoo, [hero].", french="... Je t'ai fait confiance aussi,\n[hero].", german="Damals habe ich dir auch\nvertraut, [hero].", italian="Anche allora ho creduto in te,\n[hero].", spanish="También confié en ti,\n[hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I was able to go on then because\nyou helped me be brave, [hero].", french="Et c'est grâce à toi que j'ai eu\nle courage de continuer, [hero].", german="Ich habe es damals geschafft,\nweil du mir Mut gemacht hast, [hero].", italian="Sono riuscito ad andare avanti\nsolo perché mi hai aiutato ad essere\ncoraggioso, [hero].", spanish="Pude seguir adelante porque\nme ayudaste a ser valiente, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I was able to go on then because\nyou helped me be courageous, [hero].", french="Et c'est grâce à toi que j'ai eu\nle courage de continuer, [hero].", german="Ich habe es damals geschafft,\nweil du mir Mut gegeben hast, [hero].", italian="Sono riuscito ad andare avanti\nsolo perché mi hai aiutato ad essere\ncoraggioso, [hero].", spanish="Pude seguir adelante porque\nme ayudaste a ser valiente, [hero]."})
  else
  SkySceneKit.say({english="I was able to go on then because\nyou helped me be brave, [hero].", french="Et c'est grâce à toi que j'ai eu\nle courage de continuer, [hero].", german="Ich habe es damals geschafft,\nweil du mir Mut gemacht hast, [hero].", italian="Sono riuscita ad andare avanti\nsolo perché mi hai aiutato ad essere\ncoraggiosa, [hero].", spanish="Pude seguir adelante porque\nme ayudaste a ser valiente, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="My feelings haven't changed\nsince then.", french="J'ai toujours gardé confiance\ndepuis.", german="Meine Gefühle haben sich\nseitdem nicht geändert.", italian=" È tutto proprio come allora.", spanish="Mis sentimientos no han\ncambiado desde entonces."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="My feelings haven't changed\nsince then.", french="J'ai toujours gardé confiance\ndepuis.", german="Meine Gefühle haben sich\nseitdem nicht geändert.", italian=" È tutto proprio come allora.", spanish="Mis sentimientos no han\ncambiado desde entonces."})
  else
  SkySceneKit.say({english="My feelings haven't changed\nsince then.", french="J'ai toujours gardé confiance\ndepuis.", german="Meine Gefühle haben sich\nseitdem nicht geändert.", italian=" È tutto proprio come allora.", spanish="Mis sentimientos no han\ncambiado desde entonces."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So let's go for it! Let's jump into\nthat quicksand pit, [hero]!", french="Alors on fonce! Sautons les yeux\nfermés dans les sables mouvants,\n[hero]!", german="Also, lass es uns tun! Lass uns\nin den Treibsandstrudel springen, [hero]!", italian="Andiamo! Tuffiamoci nelle\nsabbie mobili, [hero]!", spanish="Entonces, adelante... ¡Saltemos\na esas arenas movedizas, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So let's go for it! Let's jump into\nthat quicksand pit, [hero]!", french="Alors on fonce! Sautons les yeux\nfermés dans les sables mouvants,\n[hero]!", german="Also, lass es uns tun! Lass uns\nin den Treibsandstrudel springen, [hero]!", italian="Andiamo! Tuffiamoci nelle\nsabbie mobili, [hero]!", spanish="Entonces, adelante... ¡Saltemos\na esas arenas movedizas, [hero]!"})
  else
  SkySceneKit.say({english="So let's go for it! Let's jump into\nthat quicksand pit, [hero]!", french="Alors on fonce! Sautons les yeux\nfermés dans les sables mouvants,\n[hero]!", german="Also, lass es uns tun! Lass uns\nin den Treibsandstrudel springen, [hero]!", italian="Andiamo! Tuffiamoci nelle\nsabbie mobili, [hero]!", spanish="Entonces, adelante... ¡Saltemos\na esas arenas movedizas, [hero]!"})
  end
  -- message_Close
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ready?!", french=" On y va?!", german=" Fertig?!?", italian=" Pronti?", spanish=" ¡Estoy listo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you ready?!", french=" On y va?!", german=" Bist du so weit?!?", italian=" Pronti?", spanish=" ¡Estoy listo!"})
  else
  SkySceneKit.say({english=" Are you ready?!", french=" On y va?!", german=" Bist du so weit?!?", italian=" Te la senti?", spanish=" ¡Estoy lista!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" One...[K]two...[K]three![K] Go!", french=" Un...[K] deux...[K] trois![K] Banzaï!", german=" Eins...[K] zwei...[K] drei![K] Los!", italian=" Uno...[K] due...[K] tre![K] Andiamo!", spanish="A la de una...[K] A la de dos...[K]\nY a la de tres...[K] ¡Allá vamos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" One...[K]two...[K]three![K] Go!", french=" Un...[K] deux...[K] trois![K] Banzaï!", german=" Eins...[K] zwei...[K] drei![K] Los!", italian=" Uno...[K] due...[K] tre![K] Andiamo!", spanish="A la de una...[K] A la de dos...[K]\nY a la de tres...[K] ¡Allá vamos!"})
  else
  SkySceneKit.say({english=" One...[K]two...[K]three![K] Go!", french=" Un...[K] deux...[K] trois![K] Banzaï!", german=" Eins...[K] zwei...[K] drei![K] Los!", italian=" Uno...[K] due...[K] tre![K] Andiamo!", spanish="A la de una...[K] A la de dos...[K]\nY a la de tres...[K] ¡Allá vamos!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 248, 180, false, 2)
  GROUND:MoveToPosition(partner, 216, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 248, 148, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 216, 148, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(7169) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(74) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(74) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaah!", german=" Waaaah!", italian=" Aaaaah!", spanish=" ¡Aaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaah!", german=" Waaaah!", italian=" Aaaaah!", spanish=" ¡Aaaah!"})
  else
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaah!", german=" Waaaah!", italian=" Aaaaah!", spanish=" ¡Aaaah!"})
  end
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(45)
  GAME:FadeOut(false, 60)
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
end
