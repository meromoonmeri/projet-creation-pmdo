-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s03p0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 43) -- $SCENARIO_MAIN = scn[29,43] (ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Am nächsten Morgen...", italian="[CN]La mattina dopo...", spanish="[CN]Al día siguiente..."})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DO_YOUR_BEST_AS_ALWAYS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Morning, [hero]!", french=" Bonjour, [hero]!", german=" Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  else
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Manaphy[CR] is waiting for us at the\nguild. The poor little guy's hungry.", french="[CS:N]Manaphy[CR] nous attend à la Guilde.\nCe pauvre petit a faim.", german="[CS:N]Manaphy[CR] wartet auf uns in der\nGilde. Das arme kleine Kerlchen hat Hunger.", italian="[CS:N]Manaphy[CR] ci aspetta alla Gilda.\nIl piccolo sarà affamato.", spanish="[CS:N]Manaphy[CR] nos espera en el\n[CS:N]Pokégremio[CR]. El pobre está hambriento."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Manaphy[CR] is waiting for us at the\nguild. The poor little guy's hungry.", french="[CS:N]Manaphy[CR] nous attend à la Guilde.\nCe pauvre petit a faim.", german="[CS:N]Manaphy[CR] wartet auf uns in der\nGilde. Das arme kleine Kerlchen hat Hunger.", italian="[CS:N]Manaphy[CR] ci aspetta alla Gilda.\nIl piccolo sarà affamato.", spanish="[CS:N]Manaphy[CR] nos espera en el\n[CS:N]Pokégremio[CR]. El pobre está hambriento."})
  else
  SkySceneKit.say({english="[CS:N]Manaphy[CR] is waiting for us at the\nguild. The poor little guy's hungry.", french="[CS:N]Manaphy[CR] nous attend à la Guilde.\nCe pauvre petit a faim.", german="[CS:N]Manaphy[CR] wartet auf uns in der\nGilde. Das arme kleine Kerlchen hat Hunger.", italian="[CS:N]Manaphy[CR] ci aspetta alla Gilda.\nIl piccolo sarà affamato.", spanish="[CS:N]Manaphy[CR] nos espera en el\n[CS:N]Pokégremio[CR]. El pobre está hambriento."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go give a [CS:I]Blue Gummi[CR] to\n[CS:N]Manaphy[CR].", french="Allons offrir une [CS:I]Gelée Bleue[CR]\nà [CS:N]Manaphy[CR].", german="Los, gehen wir zu [CS:N]Manaphy[CR] und\ngeben ihm ein [CS:I]Blaugummi[CR].", italian="Andiamo a dare una [CS:I]Gommablu[CR] a\n[CS:N]Manaphy[CR].", spanish="Vamos a darle una [CS:I]Gomi Azul[CR]\na [CS:N]Manaphy[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go to the guild and give\na [CS:I]Blue Gummi[CR] to [CS:N]Manaphy[CR].", french="Allons offrir une [CS:I]Gelée Bleue[CR]\nà [CS:N]Manaphy[CR].", german="Lass uns zur Gilde gehen und\n[CS:N]Manaphy[CR] ein [CS:I]Blaugummi[CR] geben.", italian="Andiamo a dare una [CS:I]Gommablu[CR] a\n[CS:N]Manaphy[CR].", spanish="Vamos a darle una [CS:I]Gomi Azul[CR]\na [CS:N]Manaphy[CR]."})
  else
  SkySceneKit.say({english="Let's go to the guild and give\na [CS:I]Blue Gummi[CR] to [CS:N]Manaphy[CR].", french="Allons offrir une [CS:I]Gelée Bleue[CR]\nà [CS:N]Manaphy[CR].", german="Lass uns zur Gilde gehen und\n[CS:N]Manaphy[CR] ein [CS:I]Blaugummi[CR] geben.", italian="Andiamo a dare una [CS:I]Gommablu[CR] a\n[CS:N]Manaphy[CR].", spanish="Vamos a darle una [CS:I]Gomi Azul[CR]\na [CS:N]Manaphy[CR]."})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
