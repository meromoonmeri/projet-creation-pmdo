-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D04P11A/m05d0334.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D04P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK, I gotta be brave now!", french=" Il faut que je sois courageux!", german=" Okay, ich muss jetzt tapfer sein!", italian=" Ok, devo farmi coraggio adesso!", spanish=" ¡Ahora tengo que ser valiente!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK, I gotta be brave now!", french=" Il faut que je sois courageux!", german=" Okay, ich muss jetzt tapfer sein!", italian=" Ok, devo avere coraggio adesso!", spanish=" ¡Ahora tengo que ser valiente!"})
  else
  SkySceneKit.say({english=" OK, I gotta be brave now!", french="Il faut que je prenne mon\ncourage à deux mains!", german=" Okay, ich muss jetzt tapfer sein!", italian="Ok, devo essere coraggiosa\nadesso!", spanish=" ¡Ahora tengo que ser valiente!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If I get scared and fail to leap\nthrough at full speed...", french="Il faut y aller à toute vitesse.\nSi je n'y vais pas à fond parce que j'ai trop\npeur...", german="Wenn ich Angst bekomme und\nnicht mit vollem Tempo abspringe...", italian="Se ho troppa paura e non salto\na tutta velocità...", spanish="Si me asusto a mitad de carrera\ny no consigo saltar a toda velocidad..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If I get scared and fail to leap\nthrough at full speed...", french="Il faut y aller à toute vitesse.\nSi je n'y vais pas à fond parce que j'ai trop\npeur...", german="Wenn ich Angst bekomme und\nnicht mit vollem Tempo abspringe...", italian="Se mi faccio prendere dalla\npaura e non salto a tutta velocità...", spanish="Si me asusto a mitad de carrera\ny no consigo saltar a toda velocidad..."})
  else
  SkySceneKit.say({english="If I get scared and fail to leap\nthrough at full speed...", french="Il faut y aller à toute vitesse.\nSi je n'y vais pas à fond parce que j'ai trop\npeur...", german="Wenn ich Angst bekomme und\nnicht mit vollem Tempo abspringe...", italian="Se sono troppo spaventata e\nnon salto a tutta velocità...", spanish="Si me asusto a mitad de carrera\ny no consigo saltar a toda velocidad..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'll be smooshed no matter what\nI do!", french="... je me ferai balayer de toute\nfaçon!", german="Dann wird es sowieso nicht gut\num mich bestellt sein!", italian="Rimarrò schiacciato qualsiasi\ncosa faccia!", spanish=" ¡Voy a acabar hecho fosfatina!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'll be smooshed no matter what\nI do!", french="... je me ferai balayer de toute\nfaçon!", german="Dann wird es sowieso nicht gut\num mich bestellt sein!", italian="Rimarrò schiacciato qualsiasi\ncosa faccia!", spanish=" ¡Voy a acabar hecho fosfatina!"})
  else
  SkySceneKit.say({english="I'll be smooshed no matter what\nI do!", french="... je me ferai balayer de toute\nfaçon!", german="Dann wird es sowieso nicht gut\num mich bestellt sein!", italian="Rimarrò schiacciata qualsiasi\ncosa faccia!", spanish=" ¡Voy a acabar muy mal!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If I'm going for it, I have to go\nfor it without any hesitation.", french="Si je dois le faire, autant y aller\nsans hésitation.", german="Wenn ich es tue, dann darf ich\nnicht zögern.", italian="Se salto, devo farlo senza la\nminima esitazione.", spanish="Si voy a saltar, no puedo dudarlo\nni un instante."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If I'm doing it, I have to do it\nwithout hesitating.", french="Si je dois le faire, autant y aller\nsans hésitation.", german="Wenn ich es tue, dann darf ich\nkein bisschen zögern.", italian="Se salto, devo farlo senza la\nminima esitazione.", spanish="Si voy a saltar, no puedo dudarlo\nni un instante."})
  else
  SkySceneKit.say({english="If I'm going for it, it has to be\nwithout any hesitation.", french="Si je dois le faire, autant y aller\nsans hésitation.", german="Wenn ich es tue, darf ich dabei\nkein bisschen zögern.", italian="Se salto, devo farlo senza la\nminima esitazione.", spanish="Si voy a saltar, no puedo dudarlo\nni un instante."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I need to...[K]summon my courage!", french="Il faut que...[K] je prenne\nmon courage à deux mains!", german="Ich muss[K] meinen ganzen Mut\nzusammennehmen!", italian=" Devo...[K] farmi coraggio!", spanish=" Necesito...[K] ¡armarme de valor!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Be brave...[K] Be the bravest ever!", french="Il faut que...[K] je prenne\nmon courage à deux mains!", german="Sei tapfer...[K] Sei so tapfer wie\nnoch nie!", italian="Sii coraggioso...[K] Sii il più\ncoraggioso di tutti!", spanish="Debo ser valiente...[K]\n¡El más valiente!"})
  else
  SkySceneKit.say({english=" Be brave...[K] Use all your courage!", french=" Il faut que...[K] je sois courageuse!", german="Sei tapfer...[K] Nimm all deinen\nMumm zusammen!", italian="Sii coraggiosa...[K] Sii la più\ncoraggiosa di tutti!", spanish="Debo ser valiente...[K]\n¡Tengo que echarle coraje!"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
end
