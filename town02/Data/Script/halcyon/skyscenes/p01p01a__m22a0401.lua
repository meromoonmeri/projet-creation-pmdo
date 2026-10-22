-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/m22a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We can't go off on our own\nnow. We have to get ready for tomorrow's\nmission.", french="On ne peut pas partir\nà l'aventure maintenant. On doit se préparer\npour la mission de demain.", german="Wir können jetzt nicht allein\nlosgehen. Wir müssen uns auf morgen\nvorbereiten.", italian="Adesso non possiamo andare lì.\nDobbiamo prepararci per la missione di domani.", spanish="No podemos marcharnos por ahí\nen este momento. Hay que prepararse para\nla importantísima misión de mañana."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to get ready for\ntomorrow's mission. We shouldn't be going off\non an adventure.", french="On ne peut pas partir\nà l'aventure maintenant. On doit se préparer\npour la mission de demain.", german="Wir müssen uns für die morgige\nMission bereit machen. Wir sollten jetzt kein\nAbenteuer suchen.", italian="Dobbiamo prepararci per la\nmissione di domani. Ora non possiamo andare\na esplorare.", spanish="Hay que prepararse para\nla misión de mañana. No es momento\npara irse por ahí de aventuras."})
  else
  SkySceneKit.say({english="We have to get ready for\ntomorrow's mission. We shouldn't be going off\non an adventure.", french="On ne peut pas partir\nà l'aventure maintenant. On doit se préparer\npour la mission de demain.", german="Wir müssen uns für die morgige\nMission bereit machen. Wir sollten jetzt kein\nAbenteuer suchen.", italian="Dobbiamo prepararci per la\nmissione di domani. Ora non possiamo andare\na esplorare.", spanish="No podemos marcharnos por ahí\nen este momento. Hay que prepararse para\nla importantísima misión de mañana."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go to Treasure Town.", french=" Allez, on va à Bourg-Trésor.", german=" Gehen wir nach Schatzstadt.", italian=" Andiamo a Borgo Tesoro.", spanish=" Vamos a Aldea Tesoro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go to Treasure Town.", french=" Allez, on va à Bourg-Trésor.", german=" Gehen wir nach Schatzstadt.", italian=" Andiamo a Borgo Tesoro.", spanish=" Vamos a Aldea Tesoro."})
  else
  SkySceneKit.say({english=" Let's go to Treasure Town.", french=" Allez, on va à Bourg-Trésor.", german=" Gehen wir nach Schatzstadt.", italian=" Andiamo a Borgo Tesoro.", spanish=" Vamos a Aldea Tesoro."})
  end
  -- message_Close
end
