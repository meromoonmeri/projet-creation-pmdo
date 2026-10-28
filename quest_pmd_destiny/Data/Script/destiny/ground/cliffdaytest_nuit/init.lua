--[[ init.lua — Scène du partenaire (map cliffdaytest — version nuit)
     Enchaînement : fin du quiz → la faille du rêve → cette map, la nuit.
     Le partenaire (celui choisi et nommé dans le quiz) hésite à devenir
     explorateur au croisement, puis se décide et part seul dans Lost Wood
     (7 étages). Après la rencontre et la longue discussion sous la montagne,
     ils retraversent le donjon ensemble ; le retour aboutit sur cette map.
     Le héros reste allongé jusqu'à la rencontre. Dialogues originaux Destiny.
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
  if SV.Destiny ~= nil and SV.Destiny.RetourAccompli then
    cliffdaytest_nuit.SceneRetour()
    return
  end
  if SV.Destiny ~= nil and SV.Destiny.PartenaireParti then
    -- déjà engagé dans Lost Wood : pas de rediffusion de la scène d'aller
    return
  end
  cliffdaytest_nuit.ScenePartenaire()
end

-- -------------------------------------------------------- retour en duo

function cliffdaytest_nuit.SceneRetour()
  COMMON.RespawnAllies()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  UI:ResetSpeaker()
  GROUND:TeleportTo(hero, 648, 516, Direction.Up)
  GROUND:TeleportTo(partner, 666, 516, Direction.Up)
  GAME:MoveCamera(666, 516, 1, false)
  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("On est revenus au croisement ! Et cette fois, on a traversé Lost Wood ensemble.")
  UI:WaitShowDialogue("Regarde la montagne, là-bas. Elle n'a pas bougé… mais moi, j'ai l'impression d'avoir fait un grand pas vers elle.")
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Un jour, on suivra ce chemin jusqu'au pied de cette montagne. On ira secourir ceux qui en ont besoin et découvrir ce qui se cache au-delà.")
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Et si on trouve un trésor en route, on le partagera avec toute l'équipe !")
  UI:SetSpeaker(hero)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Alors, explorateur… on continue ensemble ?")
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Ensemble. Notre aventure ne fait que commencer.")
  SV.Destiny.FinaleDestiny = true
  GAME:WaitFrames(30)
  GAME:CutsceneMode(false)
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

  -- tutoriel du donjon à son entrée : explications intégrées au récit,
  -- commandes abstraites pour respecter la configuration du joueur
  SV.Destiny = SV.Destiny or {}
  if not SV.Destiny.LostWoodTutorialDone then
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Avant d'entrer, je dois me rappeler les règles d'un donjon.")
    UI:WaitShowDialogue("Lost Wood compte sept étages. À chaque étage, il faut trouver l'escalier qui descend ; le septième mène au fond de la forêt.")
    UI:WaitShowDialogue("Les déplacements se font avec les commandes de direction. Chaque pas prend un tour : les Pokémon autour de moi peuvent bouger et agir pendant ce temps.")
    UI:WaitShowDialogue("La commande d'attaque permet de frapper tout près. Dans le menu des capacités, je choisis une attaque à distance ou un pouvoir spécial — mais chaque capacité consomme des PP.")
    UI:WaitShowDialogue("Le sac contient des objets utiles : soins, baies et autres outils. Je peux les sélectionner dans le menu des objets ; certains peuvent aussi servir contre les obstacles ou les adversaires.")
    UI:WaitShowDialogue("Je dois surveiller mon ventre : avancer longtemps sans manger épuise. Si je trouve de la nourriture, je la garde pour les moments où j'en aurai besoin.")
    UI:WaitShowDialogue("Je n'ai pas besoin de combattre tout le monde. Je peux contourner un adversaire, utiliser un objet, ou économiser mes PP pour un passage difficile.")
    UI:WaitShowDialogue("Quand j'aurai trouvé l'escalier du septième étage, je sortirai dans la clairière. Alors… en avant !")
    SV.Destiny.LostWoodTutorialDone = true
  end
  UI:WaitShowDialogue("En route ! La nuit est à moi !")

  -- le partenaire part seul : le héros est gardé hors de l'équipe jusqu'au réveil
  local heros = GAME:GetPlayerPartyMember(0)
  SV.Destiny.HeroAssemblyIndex = GAME:GetPlayerAssemblyCount()
  GAME:RemovePlayerTeam(0)
  GAME:AddPlayerAssembly(heros)
  GAME:SetTeamLeaderIndex(0)

  -- le partenaire s'engage dans le chemin du donjon
  GROUND:CharAnimateTurnTo(partenaire, Direction.Down, 8)
  GAME:WaitFrames(20)
  SV.Destiny.PartenaireParti = true
  SV.Destiny.LostWoodTrip = 'aller'
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  GAME:CutsceneMode(false)
  GAME:EnterDungeon('lost_wood', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

return cliffdaytest_nuit
