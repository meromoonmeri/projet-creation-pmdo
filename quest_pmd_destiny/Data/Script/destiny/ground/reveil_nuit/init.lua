--[[ init.lua — Cinématique : le réveil de nuit (map reveil_nuit)
     Enchaînement : dernier étage de Lost Wood → cette clairière nocturne
     où le héros est allongé, inconscient. Le partenaire (qui vient de
     traverser le donjon) arrive par le chemin, le voit, se précipite et le
     réveille ; le héros n'a aucun souvenir. Ils décident de rester
     ensemble. Dialogues originaux PMD Destiny.
     Fin de la cinématique : contrôle rendu sur la map (pas de warp).
     Honnêteté : runtime_tested false.
]]

require 'common'

local reveil_nuit = {}

-- ------------------------------------------------------------- map callbacks

function reveil_nuit.Init(map)
  -- héros (leader) + partenaire apparaissent sur la map
  COMMON.RespawnAllies()
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
    -- fail-safe : cinématique déjà jouée → libre exploration
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

  -- le partenaire arrive du donjon, fier de sa traversée
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Je l'ai fait... J'ai traversé Lost Wood !\n Tout seul !")
  UI:WaitShowDialogue("Alors comme ça, je suis un vrai explorateur\n maintenant !")
  SOUND:PlayBattleSE('EVT_Emote_Exclaim')
  GROUND:CharSetEmote(partner, "exclaim", 1)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Attends... qu'est-ce que c'est que ça ?\n Quelqu'un est allongé là, dans l'herbe ?!")

  -- il se précipite vers le héros
  GROUND:TeleportTo(partner, 160, 176, Direction.Up)
  GROUND:CharAnimateTurnTo(partner, Direction.Up, 8)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Hé ! Tu m'entends ?!\n Tu m'as fait une de ces peurs, là !")
  UI:WaitShowDialogue("Réveille-toi, s'il te plaît !")
  GAME:WaitFrames(20)

  -- le héros se réveille, sans aucun souvenir
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

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Phew ! Tu m'as fait peur !\n Tu étais inconscient depuis tout ce temps ?")
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Tiens, " .. hero:GetDisplayName() .. ", ça te va ?\n C'est le premier nom qui me vient.")
  UI:SetSpeaker(hero)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Je... ne sais pas. Je ne me souviens de rien.")
  UI:WaitShowDialogue("Et... cette voix ? Quelqu'un m'a parlé,\n dans mon rêve...")
  UI:WaitShowDialogue("« Trouve-moi... et ensemble, nous rétablirons\n ce qui a dévié. »")

  -- le héros découvre ce qu'il est devenu
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Une voix dans ton sommeil... ça, c'est étrange.")
  UI:SetSpeaker(hero)
  UI:SetSpeakerEmotion("Worried")
  SOUND:PlayBattleSE('EVT_Emote_Shock')
  GROUND:CharSetEmote(hero, "shock", 1)
  UI:WaitShowDialogue("Attendez... vous me parlez ?\n Et vous êtes un Pokémon, non ?")
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Et toi aussi tu en es un ! Regarde-toi !")
  UI:SetSpeaker(hero)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Quoi ?! Mais... c'est vrai...\n je suis... un Pokémon ?")

  -- ils décident de rester ensemble
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Écoute : tu n'as pas de souvenirs, tu es au milieu\n de nulle part, et la nuit est longue.")
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Moi je viens de devenir explorateur, alors...\n c'est écrit : on reste ensemble !")
  UI:SetSpeaker(hero)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("...Ensemble ? ...Oui. Ensemble.")
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("C'est décidé ! " .. partner:GetDisplayName() .. " et " ..
    hero:GetDisplayName() .. " —\n la meilleure équipe du monde !")
  UI:WaitShowDialogue("Viens, on va se mettre en route.\n L'aventure commence maintenant !")

  -- fin de la cinématique : contrôle rendu sur la map (pas de warp)
  SV.Destiny = SV.Destiny or {}
  SV.Destiny.ReveilFait = true
  if SV.Chapter1 == nil then SV.Chapter1 = {} end
  SV.Chapter1.PlayedIntroCutscene = true
  GAME:WaitFrames(20)
  COMMON.RespawnAllies()   -- alliés restaurés avec leur IA normale
  GAME:CutsceneMode(false)
end

return reveil_nuit
