-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/m20a0312.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's settled.", french=" Alors, c'est décidé.", german=" Das wäre geregelt.", italian=" Allora ok.", spanish=" Pues ya está decidido."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's it, then.", french=" Alors, c'est décidé.", german=" Das ist dann geklärt.", italian=" Va bene, allora.", spanish=" Pues ya está decidido."})
  else
  SkySceneKit.say({english=" That's settled.", french=" Alors, c'est décidé.", german=" Das wäre geregelt.", italian=" Siamo d'accordo.", spanish=" Pues ya está decidido."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's where we'll go![K]\nTo [CS:P]Treeshroud Forest[CR]!", french="C'est là-bas que nous allons![K]\nEn route pour la [CS:P]Forêt Linceul[CR]!", german="Dann gehen wir dorthin![K]\nZum [CS:P]Schemengehölz[CR]!", italian="Andiamoci![K]\nAlla [CS:P]Foresta Arcana[CR]!", spanish="¡Allí es donde iremos![K]\n¡Al [CS:P]Bosque Enraizado[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's where we're going![K]\nOnward to [CS:P]Treeshroud Forest[CR]!", french="C'est là-bas que nous allons![K]\nEn route pour la [CS:P]Forêt Linceul[CR]!", german="Dahin werden wir gehen![K]\nAuf zum [CS:P]Schemengehölz[CR]!", italian="Andiamoci![K]\nAlla [CS:P]Foresta Arcana[CR]!", spanish="¡Allí es donde iremos![K]\n¡Al [CS:P]Bosque Enraizado[CR]!"})
  else
  SkySceneKit.say({english="That's where we'll go![K]\nWe're off to [CS:P]Treeshroud Forest[CR]!", french="C'est là-bas que nous allons![K]\nEn route pour la [CS:P]Forêt Linceul[CR]!", german="Dahin werden wir gehen![K]\nZum [CS:P]Schemengehölz[CR]!", italian="Andiamoci![K]\nAlla [CS:P]Foresta Arcana[CR]!", spanish="¡Allí es donde iremos![K]\n¡Al [CS:P]Bosque Enraizado[CR]!"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitBgm
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[34] = 1 -- dungeon_mode(34) = DMODE_OPEN (ROM)
end
