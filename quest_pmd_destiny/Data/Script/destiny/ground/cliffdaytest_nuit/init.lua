--[[ init.lua — Scène du partenaire (map cliffdaytest — version nuit)
     Enchaînement : fin du quiz → la faille du rêve → cette map, la nuit.
     Le partenaire (celui choisi et nommé dans le quiz) hésite à devenir
     explorateur au croisement, puis se décide et part tenter le donjon le
     plus proche : Lost Wood (7 étages).
     Le héros, lui, est toujours allongé et inconscient ailleurs (il est
     masqué ici) — la suite se joue au dernier étage de Lost Wood, sur la
     map reveil_nuit. Dialogues originaux PMD Destiny.
     Honnêteté : runtime_tested false.
]]

require 'common'

local cliffdaytest_nuit = {}

-- ------------------------------------------------------------- map callbacks

function cliffdaytest_nuit.Init(map)
end

function cliffdaytest_nuit.Enter(map)
  cliffdaytest_nuit.PlotScripting()
end

function cliffdaytest_nuit.Exit(map)
end

function cliffdaytest_nuit.Update(map)
end

function cliffdaytest_nuit.GameSave(map)
end

function cliffdaytest_nuit.GameLoad(map)
  cliffdaytest_nuit.PlotScripting()
end

function cliffdaytest_nuit.PlotScripting()
  if SV.Destiny ~= nil and SV.Destiny.PartenaireParti then
    -- déjà parti vers Lost Wood : pas de rediffusion
    return
  end
  cliffdaytest_nuit.ScenePartenaire()
end

-- ------------------------------------------------------- scène (hésitation)

function cliffdaytest_nuit.ScenePartenaire()
  GAME:CutsceneMode(true)
  UI:ResetSpeaker()
  SOUND:PlayBGM("Welcome to the World of Pokémon!.ogg", true)

  -- le héros est allongé, inconscient, ailleurs : seul le partenaire est ici
  local hero = CH('PLAYER')
  GROUND:Hide(hero)

  -- le partenaire apparaît au croisement (spawn réutilisé de la map)
  local partenaire = GAME:GetPlayerPartyMember(1)
  GROUND:SpawnerSetSpawn('Adagio', partenaire)
  partenaire = GROUND:SpawnerDoSpawn('Adagio')
  AI:DisableCharacterAI(partenaire)
  local croisement = MRKR('Pichu_Crossroads')
  GROUND:TeleportTo(partenaire, croisement.Position.X, croisement.Position.Y, Direction.Up)
  GAME:MoveCamera(croisement.Position.X, croisement.Position.Y, 1, false)
  GAME:WaitFrames(30)

  UI:SetSpeaker(partenaire)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Bon... le voilà, le croisement.\n Plus loin, c'est le donjon le plus proche : Lost Wood.")
  UI:WaitShowDialogue("Devenir explorateur...\n est-ce que je suis vraiment prêt pour ça ?")
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Si j'y vais seul et que ça tourne mal...\n personne ne saura même que je suis parti.")
  SOUND:PlayBattleSE('EVT_Emote_Confused')
  GROUND:CharSetEmote(partenaire, "question", 1)
  GAME:WaitFrames(30)
  UI:WaitShowDialogue("...Mais si je ne tente rien...\n je le regretterai toute ma vie, c'est certain.")

  SOUND:PlayBattleSE('EVT_Emote_Exclaim')
  GROUND:CharSetEmote(partenaire, "exclaim", 1)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("C'est décidé ! Je traverserai Lost Wood —\n et je sortirai de là en vrai explorateur !")
  UI:WaitShowDialogue("En route ! La nuit est à moi !")

  -- le partenaire s'engage dans le chemin du donjon
  GROUND:CharAnimateTurnTo(partenaire, Direction.Down, 8)
  GAME:WaitFrames(20)
  SV.Destiny = SV.Destiny or {}
  SV.Destiny.PartenaireParti = true
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  GAME:CutsceneMode(false)
  GAME:EnterDungeon('lost_wood', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

return cliffdaytest_nuit
