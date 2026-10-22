-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m01a0206.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_ON_THE_BEACH_AT_DUSK non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03B) [décor sub chargé: Sub_v01p03b]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- supervision_SpecialActing(21, 700, 0) [cadrage NDS]
  -- supervision2_SpecialActing(21, 700, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  -- SetOutputAttribute(2) [neutre/état moteur]
  SkySubScreen.Show("v01p03b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="When the weather's good, the\n[CS:N]Krabby[CR] come out at sundown to blow bubbles...", french="Quand il fait beau, les [CS:N]Krabby[CR]\nsortent au coucher du soleil pour faire\ndes bulles...", german="Wenn das Wetter schön ist,\nkommen die [CS:N]Krabby[CR] bei Sonnenuntergang\nheraus und pusten Blasen in die Luft...", italian="Quando c'è bel tempo, i\n[CS:N]Krabby[CR] escono al tramonto per\nfare le bollicine...", spanish="Cuando hace buen tiempo, los\n[CS:N]Krabby[CR] salen a la puesta de sol a soplar\npompitas..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="When the weather's good, the\n[CS:N]Krabby[CR] come out at sundown to blow bubbles...", french="Quand il fait beau, les [CS:N]Krabby[CR]\nsortent au coucher du soleil pour faire\ndes bulles...", german="Wenn das Wetter schön ist,\nkommen die [CS:N]Krabby[CR] bei Sonnenuntergang\nheraus und pusten Blasen in die Luft...", italian="Quando c'è bel tempo, i\n[CS:N]Krabby[CR] escono al tramonto per\nfare le bollicine...", spanish="Cuando hace buen tiempo, los\n[CS:N]Krabby[CR] salen con el ocaso para soplar\npompitas..."})
  else
  SkySceneKit.say({english="When the weather's good, the\n[CS:N]Krabby[CR] come out at sundown to blow bubbles...", french="Quand il fait beau, les [CS:N]Krabby[CR]\nsortent au coucher du soleil pour faire\ndes bulles...", german="Wenn das Wetter schön ist,\nkommen die [CS:N]Krabby[CR] bei Sonnenuntergang\nheraus und pusten Blasen in die Luft...", italian="Quando c'è bel tempo, i\n[CS:N]Krabby[CR] escono al tramonto per\nfare le bollicine...", spanish="Cuando hace buen tiempo, los\n[CS:N]Krabby[CR] salen con el ocaso para soplar\npompitas..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All those bubbles, catching the\nsetting sun's rays off the waves...", french="Les rayons du soleil couchant\nfrappent les vagues et toutes ces bulles...", german="Wie sich die Sonnenstrahlen in\nall diesen Blasen spiegeln...", italian="Tutte quelle bolle... sono così\nbelle quando riflettono i raggi del sole che\naccarezzano le onde...", spanish="Me gusta ver cómo las pompas\nreflejan los últimos rayos del sol\nque caen sobre las olas..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="All those bubbles, catching the\nsetting sun's rays off the waves...", french="Les rayons du soleil couchant\nfrappent les vagues et toutes ces bulles...", german="Wie sich die Sonnenstrahlen in\nall diesen Blasen spiegeln...", italian="Tutte quelle bolle... sono così\nbelle quando riflettono i raggi del sole che\naccarezzano le onde...", spanish="Me gusta ver cómo todas esas\npompas reflejan los últimos rayos del sol\nque brillan sobre las olas..."})
  else
  SkySceneKit.say({english="All those bubbles, reflecting the\nsetting sun off the waves...", french="Les rayons du soleil couchant\nfrappent les vagues et toutes ces bulles...", german="Wie sich die Sonnenstrahlen in\nall diesen Blasen spiegeln...", italian="Tutte quelle bolle... sono così\nbelle quando riflettono i raggi del sole che\naccarezzano le onde...", spanish="Me encanta ver cómo todas esas\npompas reflejan los últimos rayos del sol\nque caen sobre las olas..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's always impressive.", french="Toutes ces couleurs... Quel\nspectacle magnifique.", german=" Das beeindruckt mich jedes Mal.", italian="È sempre un panorama\nfavoloso.", spanish=" Siempre me impresiona."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's always beautiful.", french="Toutes ces couleurs... Quel\nspectacle magnifique.", german=" Es ist immer wunderschön.", italian="È sempre un panorama\nmagnifico.", spanish=" Siempre me impresiona."})
  else
  SkySceneKit.say({english=" It's always beautiful.", french="Toutes ces couleurs... Quel\nspectacle magnifique.", german=" Es ist immer wunderschön.", italian="È sempre un panorama\nincantevole.", spanish=" Me resulta tan hermoso..."})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- supervision2_SpecialActing(3, 0, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
