-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D30P32A/m26a0803.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Restored.ogg", true) end)
  -- back_SetGround(LEVEL_D30P32A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  local npc_npc_diaruga = SkySceneKit.spawn_npc("dialga", 280, 280, Direction.Up, "NPC_DIARUGA")
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" [partner].", french=" [partner].", german=" [partner].", italian=" [partner].", spanish=" [partner]..."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" WHEN YOU LEFT HERE...", french="QUAND TU AS QUITTE\nCET ENDROIT...", german=" ALS DU VON HIER WEGGINGST...", italian="DA QUANDO HAI LASCIATO\nQUESTO LUOGO...", spanish=" CUANDO TE MARCHASTE..."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="WHEN YOU BID FAREWELL TO\nTHIS PLACE FROM THE RAINBOW STONESHIP...", french="ET QUE TU LUI AS FAIT\nTES ADIEUX DEPUIS LE VAISSEAU\nARC-EN-CIEL...", german="ALS DU DIESEM ORT AUF DEM\nREGENBOGEN-STEINSCHIFF LEBEWOHL\nSAGTEST...", italian="DA QUANDO HAI DETTO ADDIO A\nQUESTO LUOGO DAL VASCELLO ARCOBALENO...", spanish="CUANDO DIJISTE ADIÓS A\nESTE LUGAR DESDE LA BARCA ARCOIRIS..."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="YOUR SORROW...[K] I FELT ITS\nINTENSITY EVEN HERE.", french="TON CHAGRIN...[K] J'AI SENTI\nSON INTENSITE D'ICI.", german="DEIN SCHMERZ...[K] ICH FÜHLTE\nIHN SOGAR HIER, SO INTENSIV WAR ER.", italian="HO PERCEPITO DI CONTINUO...[K]\nLA TUA INTENSA TRISTEZZA.", spanish="PUDE NOTAR...[K] TODO TU\nPESAR."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="AND IF THAT IS HOW YOU FEEL\nEVEN NOW...", french="ET SI TA PEINE EST TOUJOURS\nINTACTE APRES TOUT CE TEMPS...", german="UND WENN DU SOGAR JETZT\nNOCH SO FÜHLST...", italian="E SE TI SENTI COSÌ ANCORA\nADESSO...", spanish="SI ESO ES LO QUE TODAVÍA\nSIENTES..."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="AND IF [hero] WERE TO\nSHARE THOSE FEELINGS...", french="... ET QUE CE SENTIMENT\nEST RECIPROQUE...", german="UND WENN [hero] DIESE\nGEFÜHLE TEILT...", italian="... E SE [hero] CONDIVIDE\nQUESTI STESSI SENTIMENTI...", spanish="Y SI [hero] SINTIERA\nLO MISMO..."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" I WILL GRANT YOUR WISH.", french=" JE VAIS EXAUCER TON VŒU.", german="WERDE ICH DEINEN WUNSCH\nERFÜLLEN.", italian="ESAUDIRÒ IL VOSTRO\nDESIDERIO.", spanish=" TE CONCEDERÉ TU DESEO."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" THE WORLD NEEDS YOU BOTH.", french="LE MONDE A BESOIN DE VOUS\nDEUX.", german="DIE WELT BRAUCHT EUCH\nBEIDE.", italian="IL MONDO HA BISOGNO DI VOI\nDUE.", spanish=" ESTE MUNDO OS NECESITA."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="THAT IS WHY...[K] I WILL TRUST\nYOU WITH A GIFT.", french="C'EST POURQUOI...[K] JE VAIS\nTE FAIRE UN PRESENT.", german="DARUM WERDE ICH[K] EUCH EIN\nGESCHENK MACHEN.", italian="È PER QUESTO CHE...[K] VOGLIO\nFARVI UN DONO.", spanish="POR ESO...[K] VOY A ENTREGARTE\nALGO MUY ESPECIAL."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" I LEAVE TO YOU...[K]THE FUTURE!", french=" JE TE DONNE...[K] LE FUTUR!", german="ICH ÜBERGEBE EUCH[K] DIE\nZUKUNFT!", italian=" VOGLIO DONARVI...[K] IL FUTURO!", spanish=" TE OFREZCO...[K] ¡EL FUTURO!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_diaruga, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
