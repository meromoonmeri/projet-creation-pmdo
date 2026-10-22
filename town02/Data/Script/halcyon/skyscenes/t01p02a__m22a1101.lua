-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/m22a1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, right, [hero]!", french=" Au fait, [hero]!", german=" Oh, richtig, [hero]!", italian=" Ah, [hero]!", spanish=" Por cierto, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, right, [hero]!", french=" Au fait, [hero]!", german=" Oh, richtig, [hero]!", italian=" Ah, [hero]!", spanish=" Por cierto, [hero]."})
  else
  SkySceneKit.say({english=" Oh, right, [hero]!", french=" Au fait, [hero]!", german=" Oh, richtig, [hero]!", italian=" Ah, [hero]!", spanish=" Por cierto, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's check out Sharpedo Bluff\nbefore we go back to the guild.", french="Passons par la Falaise Sharpedo\navant de retourner à la Guilde.", german="Sehen wir noch einmal bei der\nTohaido-Klippe vorbei, bevor wir zurück zur\nGilde gehen.", italian="Facciamo un salto al Promontorio\nSharpedo prima di tornare alla Gilda.", spanish="Tenemos que pasar por el Risco\nSharpedo antes de regresar al [CS:N]Pokégremio[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We should go over to Sharpedo\nBluff before we go back to the guild.", french="Passons par la Falaise Sharpedo\navant de retourner à la Guilde.", german="Wir sollten noch einmal zur\nTohaido-Klippe, bevor wir zurück zur Gilde\ngehen.", italian="Facciamo un salto al Promontorio\nSharpedo prima di tornare alla Gilda.", spanish="Tenemos que pasar por el Risco\nSharpedo antes de regresar al [CS:N]Pokégremio[CR]."})
  else
  SkySceneKit.say({english="We should go over to Sharpedo\nBluff before we go back to the guild.", french="Passons par la Falaise Sharpedo\navant de retourner à la Guilde.", german="Wir sollten noch einmal zur\nTohaido-Klippe, bevor wir zurück zur Gilde\ngehen.", italian="Facciamo un salto al Promontorio\nSharpedo prima di tornare alla Gilda.", spanish="Tenemos que pasar por el Risco\nSharpedo antes de regresar al [CS:N]Pokégremio[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Maybe [CS:N]Grovyle[CR] has come back.", french="Peut-être que [CS:N]Massko[CR]\nest revenu.", german="Vielleicht ist [CS:N]Reptain[CR]\nzurückgekehrt.", italian=" Magari [CS:N]Grovyle[CR] è tornato.", spanish=" Tal vez [CS:N]Grovyle[CR] haya vuelto ya."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Just in case [CS:N]Grovyle[CR] has\ncome back.", french="Peut-être que [CS:N]Massko[CR]\nest revenu.", german="Nur für den Fall, dass [CS:N]Reptain[CR]\nzurückgekehrt ist.", italian="Giusto per vedere se è tornato\n[CS:N]Grovyle[CR].", spanish=" Tal vez [CS:N]Grovyle[CR] haya vuelto ya."})
  else
  SkySceneKit.say({english="Just in case [CS:N]Grovyle[CR] has\ncome back.", french="Peut-être que [CS:N]Massko[CR]\nest revenu.", german="Nur für den Fall, dass [CS:N]Reptain[CR]\nzurückgekehrt ist.", italian="Giusto per vedere se è tornato\n[CS:N]Grovyle[CR].", spanish=" Tal vez [CS:N]Grovyle[CR] haya vuelto ya."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go check out Sharpedo\nBluff, [hero]!", french="En route pour la Falaise\nSharpedo, [hero]!", german="Lass uns bei der Tohaido-Klippe\nnachsehen, [hero]!", italian="Andiamo a controllare al\nPromontorio Sharpedo, [hero]!", spanish="¡Echemos un vistazo en el Risco\nSharpedo, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go check out Sharpedo\nBluff, [hero]!", french="En route pour la Falaise\nSharpedo, [hero]!", german="Lass uns bei der Tohaido-Klippe\nnachsehen, [hero]!", italian="Andiamo a controllare al\nPromontorio Sharpedo, [hero]!", spanish="¡Vamos a echar un vistazo\nal Risco Sharpedo, [hero]!"})
  else
  SkySceneKit.say({english="Let's go check out Sharpedo\nBluff, [hero]!", french="En route pour la Falaise\nSharpedo, [hero]!", german="Lass uns bei der Tohaido-Klippe\nnachsehen, [hero]!", italian="Andiamo a controllare al\nPromontorio Sharpedo, [hero]!", spanish="¡Echemos un vistazo en el Risco\nSharpedo, [hero]!"})
  end
  -- message_Close
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[121] = 1 -- $SCENARIO_TALK_BIT_FLAG[121] = 1 (ROM)
  -- supervision_RemoveCommon(15) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
