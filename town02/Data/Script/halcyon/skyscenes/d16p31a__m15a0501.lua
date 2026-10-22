-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P31A/m15a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I guess you really are onto\nsomething.", french=" On dirait que tu es sur une piste.", german="Du scheinst einen echten\nGeistesblitz zu haben!", italian="Sono sicuro che sai già cosa\nfare.", spanish="Veo que has dado con algo\ninteresante."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I guess you really have an idea\nabout what to do.", french=" On dirait que tu es sur une piste.", german="Du bist wohl wirklich auf einen\nguten Gedanken gekommen, was?", italian="Sono sicuro che sai già cosa\nfare.", spanish=" Veo que tienes las cosas claras."})
  else
  SkySceneKit.say({english="I guess you're really\nconvinced now.", french=" On dirait que tu es sur une piste.", german="Du scheinst dir deiner Sache\nsicher zu sein!", italian="Sono sicura che sai già cosa\nfare.", spanish="Veo que tienes claro lo que\ndebemos hacer."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right. This is your call,\n[hero].", french="D'accord. Je te laisse faire,\n[hero].", german="Okay. Jetzt bist du dran,\n[hero].", italian=" Mi affido a te, [hero].", spanish="Muy bien. En tus manos queda,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK. I'll leave it up to you,\n[hero].", french="D'accord. Je te laisse faire,\n[hero].", german="Okay. Ich überlasse es dir,\n[hero].", italian=" Mi affido a te, [hero].", spanish="Muy bien. Lo dejo en tus manos,\n[hero]."})
  else
  SkySceneKit.say({english="OK. You should do whatever you\nneed to, [hero].", french="D'accord. Je te laisse faire,\n[hero].", german="Okay. Tu, was du tun musst,\n[hero].", italian=" Mi affido a te, [hero].", spanish="Muy bien. Haz lo que debas,\n[hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Go on and solve the secret of\nthe three crystals!", french="A toi de jouer, résous l'énigme\ndes trois cristaux!", german=" Löse das Rätsel dieser Kristalle!", italian="Vai e risolvi il mistero dei tre\ncristalli!", spanish="¡Intenta resolver el secreto de\nlos tres cristales!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="See if you can solve the secret\nof the three crystals!", french="A toi de jouer, résous l'énigme\ndes trois cristaux!", german="Mal sehen, ob du das Rätsel der\nKristalle lösen kannst!", italian="Vai e risolvi il mistero dei tre\ncristalli!", spanish="¡A ver si puedes desvelar el\nsecreto de los tres cristales!"})
  else
  SkySceneKit.say({english="Try solving the secret of the\nthree crystals!", french="A toi de jouer, résous l'énigme\ndes trois cristaux!", german="Versuche das Rätsel der\nKristalle zu lösen!", italian="Vai e risolvi il mistero dei tre\ncristalli!", spanish="¡Intenta resolver el secreto de\nlos tres cristales!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Each of these three crystals changes color\nevery time it's touched.)", french="(Chacun de ces cristaux change de couleur\nau moindre contact.)", german="(Jedes Mal, wenn man einen der Kristalle\nberührt, ändert er die Farbe.)", italian="(Ogni cristallo cambia colore quando viene\ntoccato.)", spanish="(Cada uno de estos tres cristales cambia de\ncolor cuando se tocan.)"})
  else
  SkySceneKit.say({english="(Each of these three crystals changes color\nevery time it's touched.)", french="(Chacun de ces cristaux change de couleur\nau moindre contact.)", german="(Jedes Mal, wenn man einen der Kristalle\nberührt, ändert er die Farbe.)", italian="(Ogni cristallo cambia colore quando viene\ntoccato.)", spanish="(Cada uno de estos tres cristales cambia de\ncolor cuando se tocan.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(These three crystals should be changed to the\nsame color.)", french="(Il faut qu'ils prennent tous les trois\nla même couleur.)", german="(Alle drei Kristalle sollen die gleiche\nFarbe haben.)", italian="(Devo fare in modo che siano tutti dello\nstesso colore.)", spanish="(Habrá que hacer que los tres cristales tengan\nel mismo color.)"})
  else
  SkySceneKit.say({english="(These three crystals should be changed to the\nsame color.)", french="(Il faut qu'ils prennent tous les trois\nla même couleur.)", german="(Alle drei Kristalle sollen die gleiche\nFarbe haben.)", italian="(Devo fare in modo che siano tutti dello\nstesso colore.)", spanish="(Habrá que hacer que los tres cristales tengan\nel mismo color.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And that color is...?)", french="(Et cette couleur est...?)", german="(Und diese Farbe ist?)", italian="(Ma quale colore sarà...?)", spanish="(¿Pero cuál será ese color?)"})
  else
  SkySceneKit.say({english="(And that color is...?)", french="(Et cette couleur est...?)", german="(Und diese Farbe ist?)", italian="(Ma quale colore sarà...?)", spanish="(¿Pero cuál será ese color?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Let's give it a try!)", french="(Faisons un essai!)", german="(Versuchen wir es mal!)", italian="(Proviamo!)", spanish="(¡Probemos!)"})
  else
  SkySceneKit.say({english="(Let's give it a try!)", french="(Faisons un essai!)", german="(Versuchen wir es mal!)", italian="(Proviamo!)", spanish="(¡Probemos!)"})
  end
  -- message_Close
end
