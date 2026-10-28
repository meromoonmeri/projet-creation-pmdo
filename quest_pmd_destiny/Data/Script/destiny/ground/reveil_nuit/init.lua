--[[ init.lua — Cinématique : le réveil de nuit (map reveil_nuit)
     Enchaînement (fin du quiz de personnalité) : héros + partenaire choisis
     et nommés → cette map, la nuit, une clairière. Le héros se réveille sans
     souvenirs ; le partenaire le trouve, comprend qu'il a perdu la mémoire
     et lui propose de partir à la ville ensemble. Dialogues originaux
     PMD Destiny. Honnêteté : runtime_tested false.
]]

require 'common'

local reveil_nuit = {}

-- ------------------------------------------------------------- map callbacks

function reveil_nuit.Init(map)
  -- héros + partenaire apparaissent sur la map (équipe du joueur)
  COMMON.RespawnAllies(true)
end

function reveil_nuit.Enter(map)
  reveil_nuit.PlotScripting()
end

function reveil_nuit.Exit(map)
end

function reveil_nuit.Update(map)
end

function reveil_nuit.GameSave(map)
end

function reveil_nuit.GameLoad(map)
  reveil_nuit.PlotScripting()
end

function reveil_nuit.PlotScripting()
  if SV.Destiny ~= nil and SV.Destiny.ReveilFait then
    -- fail-safe : cinématique déjà jouée → la ville
    GROUND:EnterGroundMap('metano_town', 'Main_Entrance_Marker')
    return
  end
  reveil_nuit.Cinematique()
end

-- ------------------------------------------------------------- cinématique

function reveil_nuit.Cinematique()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  UI:ResetSpeaker()
  SOUND:StopBGM()
  AI:DisableCharacterAI(hero)
  AI:DisableCharacterAI(partner)

  -- le héros gît dans l'herbe, la nuit ; le partenaire attend hors champ
  GROUND:CharSetAnim(hero, 'Laying', true)
  GROUND:TeleportTo(hero, 160, 132, Direction.Down)
  GROUND:TeleportTo(partner, 160, 236, Direction.Up)
  GAME:MoveCamera(160, 132, 1, false)
  GAME:WaitFrames(30)

  -- voix du rêve (celle du halo arc-en-ciel)
  UI:WaitShowVoiceOver("……", -1)
  UI:WaitShowVoiceOver("La nuit t'a déposé ici,\ncomme une lettre que personne n'a envoyée…", -1)
  UI:WaitShowVoiceOver("Réveille-toi.", -1)

  -- la clairière de nuit se révèle
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:FadeIn(120)
  GAME:WaitFrames(30)
  UI:WaitHideTitle(20)
  SOUND:PlayBGM("Welcome to the World of Pokémon!.ogg", true)
  GAME:WaitFrames(30)

  -- le héros se réveille, seul, sans souvenirs
  UI:SetSpeaker(hero)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("...Mmh... Ça cogne fort dans ma tête...")
  GROUND:CharSetAnim(hero, 'Wake', false)
  GROUND:CharSetAnim(hero, 'None', true)
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("Où... suis-je ? Tout est si sombre...")
  UI:WaitShowDialogue("Je ne me souviens de rien. Ni d'où je viens,\n ni de ce que je fais ici.")
  SOUND:PlayBattleSE('EVT_Emote_Confused')
  GROUND:CharSetEmote(hero, "question", 1)
  GAME:WaitFrames(30)
  UI:WaitShowDialogue("Et... cette voix ? Quelqu'un m'a parlé,\n dans mon rêve...")

  -- le partenaire arrive en courant
  SOUND:PlayBattleSE('EVT_Emote_Exclaim')
  GROUND:CharSetEmote(hero, "exclaim", 1)
  GROUND:TeleportTo(partner, 160, 176, Direction.Up)
  GROUND:CharAnimateTurnTo(partner, Direction.Up, 8)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Hé ! Tu m'entends ?!")
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Tu m'as fait une de ces peurs ! Tu étais là,\n allongé dans l'herbe, sans bouger...")
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Je commençais à croire que tu n'allais jamais\n te réveiller !")
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Ça va ? Tu peux te lever ?")

  -- le héros découvre ce qu'il est devenu
  UI:SetSpeaker(hero)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Vous... vous me parlez ? Vous êtes un Pokémon, non ?")
  SOUND:PlayBattleSE('EVT_Emote_Confused')
  GROUND:CharSetEmote(hero, "question", 1)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Et toi aussi tu en es un ! Regarde-toi !")
  UI:SetSpeaker(hero)
  UI:SetSpeakerEmotion("Worried")
  SOUND:PlayBattleSE('EVT_Emote_Shock')
  GROUND:CharSetEmote(hero, "shock", 1)
  UI:WaitShowDialogue("Quoi ?! Mais... c'est vrai... ce sont des pattes ?!")
  UI:WaitShowDialogue("Je suis... un Pokémon ?")

  -- présentations
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Tu ne sais même pas ce que tu es ?\n Tu t'es cogné la tête ou quoi ?")
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Au fait, moi c'est " .. partner:GetDisplayName() .. " !\n Et toi, c'est quoi ton nom ?")
  UI:SetSpeaker(hero)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Je... ne sais pas. Je ne me souviens de rien.")
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Pas de problème ! En attendant que ta mémoire\n revienne, on va bien trouver un truc à t'appeler.")
  UI:WaitShowDialogue("Tiens, " .. hero:GetDisplayName() .. ", ça te va ?\n C'est déjà ça de pris !")

  -- la voix du rêve
  UI:SetSpeaker(hero)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("...La voix de mon rêve... elle m'a dit :\n « Trouve-moi... et ensemble, nous rétablirons\n ce qui a dévié. »")
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Une voix qui te parle dans ton sommeil...\n ça, c'est étrange.")
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Mais tu sais quoi ? Personne ne reste allongé\n toute la nuit dans ma clairière !")

  -- départ vers la ville
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("La ville n'est pas loin. On y va ensemble —\n tu ne peux pas rester seul !")
  UI:SetSpeaker(hero)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("...Ensemble ? ...Oui. Ensemble.")
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("C'est décidé ! " .. partner:GetDisplayName() .. " et " ..
    hero:GetDisplayName() .. " —\n la meilleure équipe du monde !")
  UI:WaitShowDialogue("En route, partenaire ! La nuit est encore longue,\n et l'aventure commence maintenant !")

  -- fin de la cinématique
  SV.Destiny = SV.Destiny or {}
  SV.Destiny.ReveilFait = true
  if SV.Chapter1 == nil then SV.Chapter1 = {} end
  SV.Chapter1.PlayedIntroCutscene = true
  SOUND:FadeOutBGM(120)
  GAME:FadeOut(false, 120)
  GAME:WaitFrames(60)
  GAME:CutsceneMode(false)
  GROUND:EnterGroundMap('metano_town', 'Main_Entrance_Marker')
end

return reveil_nuit
