--[[
    altere_pond_ch_11.lua
    Mare Altérée — Chapitre 11 : Le départ vers Treasure Town via Loaklass
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

altere_pond_ch_11 = {}

function altere_pond_ch_11.ArrivalCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- Placer le vieux Relicanth (Erleuchtet) au bord de l'eau (536, 320)
  local relicanth = CH('Relicanth')
  if relicanth == nil then
    relicanth = CharacterEssentials.MakeCharactersFromList({
      {'Relicanth', 536, 320, Direction.Down}
    })
  else
    GROUND:TeleportTo(relicanth, 536, 320, Direction.Down)
  end
  GROUND:CharSetAnim(relicanth, "Idle", true)

  -- Placer Loaklass (Lapras) dans l'eau près de la rive en (500, 310)
  local lapras = CharacterEssentials.MakeCharactersFromList({
    {'Lapras', 500, 310, Direction.Right}
  })
  GROUND:CharSetAnim(lapras, "Idle", true)

  -- Téléporter l'équipe au sud de l'étang
  GROUND:TeleportTo(hero, 520, 380, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 480, 380, Direction.Up) end
  GAME:MoveCamera(510, 340, 1, false)

  GAME:FadeIn(40)
  SOUND:PlayBGM('Star Cave.ogg', true)
  GAME:WaitFrames(30)

  -- L'équipe s'approche d'Erleuchtet
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(hero, 540, 344, false, 1)
    GROUND:CharAnimateTurnTo(hero, Direction.UpLeft, 4)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    if partner ~= nil then
      GROUND:MoveToPosition(partner, 490, 344, false, 1)
      GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
    end
  end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(20)

  -- Échange de dialogues
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Erleuchtet ! Que se passe-t-il près de la rive ? L'eau est inhabituellement agitée.")
  GAME:WaitFrames(15)

  GROUND:CharTurnToCharAnimated(relicanth, partner, 4)
  UI:SetSpeaker(relicanth)
  UI:WaitShowDialogue("Mmm...[pause=10] Vous voilà, mes petits.[pause=15] L'étang est calme, mais les vagues du large amènent une brise chaleureuse.")
  UI:WaitShowDialogue("Lugia a calmé la tempête au nord...[pause=20] et pour vous féliciter, une amie de très longue date est venue vous rendre visite.")
  GAME:WaitFrames(15)

  -- Loaklass (Lapras) s'avance légèrement vers la rive
  local coro_move = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(lapras, 500, 320, false, 1)
    GROUND:CharAnimateTurnTo(lapras, Direction.DownRight, 4)
  end)
  local coro_look = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    GROUND:CharTurnToCharAnimated(relicanth, lapras, 4)
    if partner ~= nil then GROUND:CharTurnToCharAnimated(partner, lapras, 4) end
    GROUND:CharTurnToCharAnimated(hero, lapras, 4)
  end)
  TASK:JoinCoroutines({coro_move, coro_look})
  GAME:WaitFrames(15)

  -- Salutations de Loaklass
  UI:SetSpeaker(lapras)
  UI:WaitShowDialogue("Bonjour, jeunes aventuriers.[pause=15] Je suis Loaklass. Erleuchtet m'a raconté tous vos exploits contre la corruption des Cœurs.")
  UI:WaitShowDialogue("Vous dégagez une énergie incroyable...[pause=20] Elle me rappelle beaucoup un duo d'explorateurs que j'ai eu la chance de transporter, il y a quinze ans de cela.")
  UI:WaitShowDialogue("Ils avaient cette même étincelle dans les yeux...[pause=10] avant de réparer la Tour du Temps elle-même.")
  GAME:WaitFrames(15)

  -- Réaction du partenaire (sweatdrop)
  UI:SetSpeaker(partner)
  pcall(function()
    GROUND:CharSetEmote(partner, "sweatdrop", 1)
    GROUND:CharTurnToCharAnimated(partner, hero, 4)
  end)
  GeneralFunctions.SetEmotion("Sigh")
  UI:WaitShowDialogue("(Euh...[pause=15] La Tour du Temps ?[pause=10] Réparer le temps ?[br]Je crois que je sais TRÈS bien de qui elle parle...)")
  GAME:WaitFrames(15)

  GROUND:CharTurnToCharAnimated(partner, lapras, 4)
  GROUND:CharTurnToCharAnimated(hero, lapras, 4)
  GROUND:CharTurnToCharAnimated(relicanth, lapras, 4)

  UI:SetSpeaker(lapras)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Si votre volonté est de découvrir de nouvelles terres pour continuer vos recherches... mon dos vous est grand ouvert.")
  UI:WaitShowDialogue("Je peux vous faire franchir l'océan jusqu'au mythique Bourg du Comptoir, la grande capitale historique de l'exploration !")
  GAME:WaitFrames(15)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Joyous")
  UI:WaitShowDialogue("Le Bourg du Comptoir ?! C'est incroyable ! Allez, {0}, en route !", hero:GetDisplayName())
  GAME:WaitFrames(20)

  -- Traversée
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  -- Écran noir de transition
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue("Portés par le souffle régulier et rassurant de Loaklass... nous avons fendu les vagues de l'océan, laissant la Mare Altérée derrière nous pour voguer vers de nouveaux horizons.")
  UI:SetCenter(false)
  GAME:WaitFrames(40)

  -- Treasure Town est un Ground de master_zone, pas un donjon. Appeler
  -- UnlockDungeon sur cet identifiant absent de Data/Zone faisait planter
  -- la sauvegarde Dev lors du déblocage.
  -- Le flag appartient à la scène d'arrivée du Bourg. Le poser ici sautait
  -- précisément cette scène sur la carte de destination.
  GAME:EnterGroundMap("bourg_comptoir", "Main_Entrance_Marker")
end

function altere_pond_ch_11.SetupGround()
  -- Placer le vieux Relicanth (Erleuchtet)
  local relicanth = CH('Relicanth')
  if relicanth ~= nil then
    GROUND:TeleportTo(relicanth, 536, 320, Direction.Down)
  end

  -- Placer Loaklass (Lapras) au bord de l'eau
  local lapras = CharacterEssentials.MakeCharactersFromList({
    {'Lapras', 500, 310, Direction.Right}
  })
  GROUND:CharSetAnim(lapras, "Idle", true)

  GAME:FadeIn(20)
end

function altere_pond_ch_11.Lapras_Action(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)

  UI:SetSpeaker(chara)
  UI:ChoiceMenuYesNo("Voulez-vous voyager vers le Bourg du Comptoir ?", true)
  UI:WaitForChoice()

  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    
    -- Courte transition de voyage
    UI:ResetSpeaker()
    UI:SetCenter(true)
    UI:WaitShowDialogue("Loaklass fend à nouveau les vagues, nous transportant à travers l'océan vers le Bourg du Comptoir...")
    UI:SetCenter(false)
    GAME:WaitFrames(40)
    
    -- Aller à Treasure Town
    GAME:EnterGroundMap("bourg_comptoir", "Main_Entrance_Marker")
  else
    UI:SetSpeaker(chara)
    UI:WaitShowDialogue("Prenez votre temps. L'océan ne bougera pas d'ici.")
  end

  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

function altere_pond_ch_11.Relicanth_Action(chara, activator)
  GeneralFunctions.StartConversation(chara, "Mmm...[pause=10] Loaklass est une amie de confiance. Voyagez avec elle l'esprit serein.[pause=15] L'étang veillera sur votre retour.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

return altere_pond_ch_11
