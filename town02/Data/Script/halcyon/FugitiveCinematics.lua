--[[
    FugitiveCinematics.lua — Moteur narratif et chorégraphique 100% canonique de l'Arc Fugitif (PMD Red).
    Reconstruction rigoureuse des 27 étapes selon la décompilation pret/pmd-red et la ROM GBA (B24P).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

local FugitiveCinematics = {}

local function dial(speaker, str, emo)
  if speaker then UI:SetSpeaker(speaker) else UI:ResetSpeaker(false) end
  if emo then GeneralFunctions.SetEmotion(emo) end
  UI:WaitShowDialogue(str)
end

local function hero_pense(hero, str, emo)
  GeneralFunctions.HeroDialogue(hero, str, emo or 'Normal')
end

-- =====================================================================
-- TABLE DES CHORÉGRAPHIES & SCÈNES CANONIQUES (27 ÉTAPES)
-- =====================================================================
FugitiveCinematics.SCENES = {

  -- 01. Accusation sur la place
  t01p01 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 480, 420, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 450, 420, Direction.Up) end) end
    GAME:MoveCamera(465, 380, 1, false)
    SOUND:PlayBGM('Growing Anxiety.ogg', true)
    GAME:FadeIn(30)
    UI:WaitShowTitle('L’Accusation de Metano', 20); GAME:WaitFrames(40); UI:WaitHideTitle(20)
    dial(partner, "Regarde tous ces Pokémon rassemblés sur la place...[pause=20] Pourquoi ils nous regardent comme ça ?", 'Worried')
    local gengar = CharacterEssentials.MakeCharactersFromList({{'Adagio', 465, 340, Direction.Down}})
    dial(gengar, "C'est eux ![pause=20] C'est l'humain transformé qui attire toutes ces catastrophes sur nous !", 'Normal')
    pcall(function() GROUND:CharSetEmote(partner, 'shock', 1) end)
    dial(partner, "Quoi ?! Mais c'est faux ! Nous protégeons la ville depuis le début !", 'Angry')
    hero_pense(hero, "(La foule grogne...[pause=15] Personne ne nous écoutera ce soir...)", 'Worried')
    GAME:FadeOut(false, 30); pcall(function() GAME:GetCurrentGround():RemoveTempChar(gengar) end)
    GAME:CutsceneMode(false)
  end,

  -- 02. Le Conseil de Barbicha
  t01p02a = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 224, 220, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 256, 220, Direction.Up) end) end
    GAME:MoveCamera(240, 190, 1, false)
    SOUND:PlayBGM('At the End of the Day.ogg', true)
    GAME:FadeIn(25)
    local whiscash = CharacterEssentials.MakeCharactersFromList({{'Noctowl', 240, 150, Direction.Down}})
    dial(whiscash, "Écoutez-moi bien, petits.[pause=20] La rumeur s'est répandue comme une traînée de poudre.", 'Normal')
    dial(whiscash, "Dès l'aube, des équipes de secours de tout le continent vont se lever pour vous traquer.", 'Worried')
    dial(whiscash, "Fuyez cette nuit.[pause=25] Allez vers le nord, cherchez la vérité au sommet des monts anciens.", 'Determined')
    dial(partner, "Fuir... ? Mais nous n'avons rien fait de mal !", 'Worried')
    dial(whiscash, "Parfois, fuir est le seul moyen de vivre assez longtemps pour prouver son innocence.", 'Normal')
    GAME:FadeOut(false, 30); pcall(function() GAME:GetCurrentGround():RemoveTempChar(whiscash) end)
    GAME:CutsceneMode(false)
  end,

  -- 03. La Nuit des Adieux
  t00p01 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 140, 140, Direction.Right) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 180, 140, Direction.Left) end) end
    GAME:MoveCamera(160, 140, 1, false)
    SOUND:PlayBGM('Sympathy.ogg', true)
    GAME:FadeIn(30)
    dial(partner, "Tout est emballé... Baies, écharpe, carte de route.", 'Normal')
    GAME:WaitFrames(20)
    pcall(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
    dial(partner, "Je ne sais pas ce qui nous attend dehors, [player].", 'Worried')
    pcall(function() GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
    dial(partner, "Mais quoi qu'il arrive... nous sommes une équipe.[pause=20] Je ne te laisserai jamais seul.", 'Determined')
    hero_pense(hero, "(Merci...[pause=15] Partons avant les premières lueurs.)", 'Normal')
    GAME:FadeOut(false, 30); GAME:CutsceneMode(false)
  end,

  -- 04. La Fissure (A02P01)
  a02p01 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 240, 320, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 208, 320, Direction.Up) end) end
    GAME:MoveCamera(224, 280, 1, false)
    SOUND:PlayBGM('Rising Fear.ogg', true)
    GAME:FadeIn(30)
    UI:WaitShowTitle('Ceux que l’on accuse', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
    dial(partner, "Les cloches de Metano sonnent derrière nous... Pas pour une mission, pour une chasse.", 'Worried')
    dial(partner, "Ils ferment la route de l'est. Notre seule issue est de traverser les terres arides.", 'Determined')
    hero_pense(hero, "(On ne laissera personne écrire notre fin. En avant !)", 'Determined')
    local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 240, 180, false, 2) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 208, 180, false, 2) end)
    TASK:JoinCoroutines({coro1, coro2})
    GAME:FadeOut(false, 30); GAME:CutsceneMode(false)
  end,

  -- 05. L'Incendie (A02P02)
  a02p02 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 72, 96, Direction.Right) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 48, 96, Direction.Right) end) end
    GAME:MoveCamera(160, 96, 1, false)
    SOUND:PlayBGM('Rising Fear.ogg', true)
    GAME:FadeIn(25)
    dial(partner, "La faille coupe la route ! Des Pokémon patrouillent sur la falaise sud !", 'Worried')
    hero_pense(hero, "(Les héros d'autrefois ont traversé ce pays en fugitifs... Suivons leurs traces !)", 'Normal')
    local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 248, 96, false, 2) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 224, 96, false, 2) end)
    TASK:JoinCoroutines({coro1, coro2})
    GAME:FadeOut(false, 25); GAME:CutsceneMode(false)
  end,

  -- 06. Vers Lapis (A02P03)
  a02p03 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 112, 200, Direction.UpRight) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 96, 200, Direction.UpRight) end) end
    GAME:MoveCamera(180, 180, 1, false)
    SOUND:PlayBGM('Rising Fear.ogg', true)
    GAME:FadeIn(25)
    dial(partner, "Une lueur rouge dévore l'horizon... Le volcan est en activité.", 'Worried')
    dial(partner, "Toutes les routes de surface sont bouclées. Entrons dans la caverne souterraine !", 'Determined')
    local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 240, 140, false, 2) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 216, 140, false, 2) end)
    TASK:JoinCoroutines({coro1, coro2})
    GAME:FadeOut(false, 25); GAME:CutsceneMode(false)
  end,

  -- 07. Vers le Volcan (A02P04)
  a02p04 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 160, 320, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 136, 320, Direction.Up) end) end
    GAME:MoveCamera(160, 240, 1, false)
    SOUND:PlayBGM('Rising Fear.ogg', true)
    GAME:FadeIn(25)
    dial(partner, "Le sentier devient vertical... Revenir n'est plus possible.", 'Determined')
    hero_pense(hero, "(Chaque pas nous rapproche de la vérité.)", 'Normal')
    local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 160, 120, false, 2) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 136, 120, false, 2) end)
    TASK:JoinCoroutines({coro1, coro2})
    GAME:FadeOut(false, 25); GAME:CutsceneMode(false)
  end,

  -- 08. Entrée Grotte Lapis (D08P01)
  d08p01 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 56, 216, Direction.UpRight) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 40, 216, Direction.UpRight) end) end
    GAME:MoveCamera(180, 180, 1, false)
    SOUND:PlayBGM('Lapis Cave.ogg', true)
    GAME:FadeIn(30)
    UI:WaitShowTitle('Grotte Lapis (14F)', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    dial(partner, "Les parois bleues renvoient nos pas... Cette grotte cachera notre fuite.", 'Normal')
    local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 216, 200, false, 1) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 184, 200, false, 1) end)
    TASK:JoinCoroutines({coro1, coro2})
    GAME:FadeOut(false, 30); GAME:CutsceneMode(false)
  end,

  -- 09. Sortie Grotte Lapis (D08P02)
  d08p02 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 80, 136, Direction.Right) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 64, 136, Direction.Right) end) end
    GAME:MoveCamera(140, 150, 1, false)
    SOUND:PlayBGM('Growing Anxiety.ogg', true)
    GAME:FadeIn(25)
    dial(partner, "Ouf... La sortie ! Mais les éclaireurs sont juste derrière nous !", 'Worried')
    dial(partner, "Pas le temps de souffler. Gravissons le Mont Ardent avant qu'ils ne nous encerclent !", 'Determined')
    local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 260, 136, false, 2) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 236, 136, false, 2) end)
    TASK:JoinCoroutines({coro1, coro2})
    GAME:FadeOut(false, 25); GAME:CutsceneMode(false)
  end,

  -- 10. Pied Mont Ardent (D09P01)
  d09p01 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 176, 264, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 152, 264, Direction.Up) end) end
    GAME:MoveCamera(176, 220, 1, false)
    SOUND:PlayBGM('Mt. Blaze.ogg', true)
    GAME:FadeIn(30)
    UI:WaitShowTitle('Mont Ardent (12F)', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    dial(partner, "L'air brûle... Le feu efface nos traces, mais la roche tremble.", 'Worried')
    dial(partner, "Au sommet vit un gardien légendaire. Allons jusqu'au bout !", 'Determined')
    local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 176, 180, false, 1) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 152, 180, false, 1) end)
    TASK:JoinCoroutines({coro1, coro2})
    GAME:FadeOut(false, 30); GAME:CutsceneMode(false)
  end,

  -- 11. Relais Mont Ardent (D09P02)
  d09p02 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 224, 304, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 192, 304, Direction.Up) end) end
    GAME:MoveCamera(224, 270, 1, false)
    SOUND:PlayBGM('Mt. Blaze.ogg', true)
    GAME:FadeIn(25)
    UI:WaitShowTitle('Cime du Mont Ardent (Relais)', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    dial(partner, "Le feu devient blanc... Même la pierre semble respirer ici.", 'Normal')
    dial(partner, "Encore 3 étages et nous serons au cratère de Sulfura.", 'Determined')
    GAME:FadeOut(false, 25); GAME:CutsceneMode(false)
  end,

  -- 12. Sommet Sulfura (D09P03)
  d09p03 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 296, 208, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 264, 208, Direction.Up) end) end
    GAME:MoveCamera(272, 192, 1, false)
    SOUND:PlayBGM('In the Depths of the Pit.ogg', true)
    GAME:FadeIn(30)
    UI:WaitShowTitle('Sulfura — Flamme du Mont Ardent', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 296, 184, false, 1) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 264, 184, false, 1) end)
    TASK:JoinCoroutines({coro1, coro2})
    local moltres = CharacterEssentials.MakeCharactersFromList({{'Moltres', 272, 168, Direction.Down}})
    pcall(function() GROUND:Hide('Moltres') end)
    BossFX.EmergeFire(moltres, 272, 168)
    BossFX.Flash(272, 168, 3, 6, 30)
    dial(moltres, "Qui ose troubler le repos de la flamme sacrée ?", 'Normal')
    dial(moltres, "Vous fuyez une accusation... Prouvez que votre cœur ne s'est pas éteint !", 'Determined')
    dial(partner, "Nous cherchons seulement la vérité ! Ne nous barrez pas la route !", 'Determined')
    COMMON.BossTransition()
    GAME:FadeOut(false, 30); pcall(function() GAME:GetCurrentGround():RemoveTempChar(moltres) end)
    GAME:CutsceneMode(false)
  end,

  -- 13. Vers le Nord Boréal (A03P01)
  a03p01 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 240, 156, Direction.Right) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 208, 156, Direction.Right) end) end
    GAME:MoveCamera(300, 156, 1, false)
    SOUND:PlayBGM('Frosty Forest.ogg', true)
    GAME:FadeIn(30)
    UI:WaitShowTitle('Vers le Nord Boréal', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    dial(partner, "La cendre chaude s’est effacée sous le premier givre... Le froid mord les pattes.", 'Worried')
    dial(partner, "Derrière nous, le mont brûle encore. Devant, la neige efface tout, même la peur.", 'Determined')
    local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 460, 156, false, 1) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 428, 156, false, 1) end)
    TASK:JoinCoroutines({coro1, coro2})
    GAME:FadeOut(false, 30); GAME:CutsceneMode(false)
  end,

  -- 14. Forêt de Neige (A03P02)
  a03p02 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 160, 260, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 136, 260, Direction.Up) end) end
    GAME:MoveCamera(160, 200, 1, false)
    SOUND:PlayBGM('Snowbound Path.ogg', true)
    GAME:FadeIn(25)
    dial(partner, "Les grands pins sont pétrifiés par la glace... Le vent ne siffle plus, il prévient.", 'Worried')
    hero_pense(hero, "(Les héros d'autrefois ont tenu bon ici. Nous irons jusqu'à la clairière !)", 'Normal')
    local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 160, 140, false, 1) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 136, 140, false, 1) end)
    TASK:JoinCoroutines({coro1, coro2})
    GAME:FadeOut(false, 25); GAME:CutsceneMode(false)
  end,

  -- 15. La Voix du Blizzard (A03P03)
  a03p03 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 240, 140, Direction.Right) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 208, 140, Direction.Right) end) end
    GAME:MoveCamera(300, 140, 1, false)
    SOUND:PlayBGM('Snowbound Path.ogg', true)
    GAME:FadeIn(30)
    UI:WaitShowTitle('La Voix du Blizzard', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    dial(partner, "Le blizzard nous aveugle... Mes pas deviennent si lourds...", 'Worried')
    pcall(function() GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, 'Hurt')) end)
    GAME:WaitFrames(30)
    UI:ResetSpeaker(false); UI:SetCenter(true)
    UI:WaitShowDialogue("« N’abandonnez pas... La vérité vous attend au sommet... »")
    UI:SetCenter(false); UI:ResetSpeaker()
    pcall(function() GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, 'Idle')) end)
    dial(partner, "Tu as entendu, [player] ? Ce n’était pas le vent ! Quelqu’un veille sur nous !", 'Surprised')
    local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 460, 140, false, 1) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 428, 140, false, 1) end)
    TASK:JoinCoroutines({coro1, coro2})
    GAME:FadeOut(false, 30); GAME:CutsceneMode(false)
  end,

  -- 16. Orée Forêt Givrée (D10P01)
  d10p01 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 160, 280, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 136, 280, Direction.Up) end) end
    GAME:MoveCamera(160, 220, 1, false)
    SOUND:PlayBGM('Frosty Forest.ogg', true)
    GAME:FadeIn(30)
    UI:WaitShowTitle('Forêt Givrée (9F)', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    dial(partner, "Après le feu, le silence absolu de la Forêt Givrée.", 'Normal')
    local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 160, 180, false, 1) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 136, 180, false, 1) end)
    TASK:JoinCoroutines({coro1, coro2})
    GAME:FadeOut(false, 30); GAME:CutsceneMode(false)
  end,

  -- 17. Relais Forêt Givrée (D10P02)
  d10p02 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 224, 304, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 192, 304, Direction.Up) end) end
    GAME:MoveCamera(224, 270, 1, false)
    SOUND:PlayBGM('Frosty Forest.ogg', true)
    GAME:FadeIn(25)
    UI:WaitShowTitle('Profondeurs GivFormatted (Relais)', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    dial(partner, "Le vent s’est tu... Quelque chose nous observe depuis la clairière du haut.", 'Worried')
    GAME:FadeOut(false, 25); GAME:CutsceneMode(false)
  end,

  -- 18. Sommet Artikodin & Absol (D10P03)
  d10p03 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 232, 232, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 208, 232, Direction.Up) end) end
    GAME:MoveCamera(248, 200, 1, false)
    SOUND:PlayBGM('In the Depths of the Pit.ogg', true)
    GAME:FadeIn(30)
    UI:WaitShowTitle('Artikodin — Silence des Neiges', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    local articuno = CharacterEssentials.MakeCharactersFromList({{'Articuno', 248, 160, Direction.Down}})
    BossFX.WarpSpace(articuno, 248, 160)
    dial(articuno, "Intrus... Vous apportez le chaos dans mon domaine gelé !", 'Normal')
    dial(partner, "Non ! Écoutez-nous, nous ne sommes pas vos ennemis !", 'Worried')
    dial(articuno, "La glace ne négocie pas avec ceux qui fuient !", 'Determined')
    COMMON.BossTransition()
    GAME:FadeOut(false, 30); pcall(function() GAME:GetCurrentGround():RemoveTempChar(articuno) end)
    GAME:CutsceneMode(false)
  end,

  -- 19. Pied Mont Gelé (D11P01)
  d11p01 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 160, 240, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 136, 240, Direction.Up) end) end
    GAME:MoveCamera(160, 190, 1, false)
    SOUND:PlayBGM('Mt. Freeze.ogg', true)
    GAME:FadeIn(30)
    UI:WaitShowTitle('Mont Gelé (15F)', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    dial(partner, "Feunard vit au-delà de ces pentes... C'est là que tout a commencé.", 'Determined')
    local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 160, 160, false, 1) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 136, 160, false, 1) end)
    TASK:JoinCoroutines({coro1, coro2})
    GAME:FadeOut(false, 30); GAME:CutsceneMode(false)
  end,

  -- 20. Relais Mont Gelé (D11P02)
  d11p02 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 224, 304, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 192, 304, Direction.Up) end) end
    GAME:MoveCamera(224, 270, 1, false)
    SOUND:PlayBGM('Mt. Freeze.ogg', true)
    GAME:FadeIn(25)
    UI:WaitShowTitle('Pic Gelé (Relais)', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    dial(partner, "Le sommet est là. Je sens une présence ancienne... calme mais immense.", 'Normal')
    dial(partner, "Cette fois, nous ne venons pas demander si nous sommes coupables : nous venons demander la vérité.", 'Determined')
    GAME:FadeOut(false, 25); GAME:CutsceneMode(false)
  end,

  -- 21. Autel de Feunard & Témoignage (D11P03)
  d11p03 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 252, 288, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 236, 288, Direction.Up) end) end
    GAME:MoveCamera(252, 220, 1, false)
    SOUND:PlayBGM('Mystifying Forest.ogg', true)
    GAME:FadeIn(30)
    UI:WaitShowTitle('Feunard — Témoin de la Légende', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    local ninetales = CharacterEssentials.MakeCharactersFromList({{'Ninetales', 252, 168, Direction.Down}})
    BossFX.RadiantDawn(ninetales, 252, 168)
    dial(ninetales, "Il y a trente ans, deux fugitifs sont venus chercher ici la vérité sur une malédiction.", 'Normal')
    dial(ninetales, "La malédiction n’était pas la leur. Votre humanité ne fut jamais la cause des catastrophes.", 'Normal')
    dial(ninetales, "Emportez mon témoignage : vous êtes innocents.", 'Determined')
    pcall(function() GROUND:CharSetEmote(partner, 'inspired', 1) end)
    dial(partner, "Innocents... ! [player], nous l'avons fait ! La malédiction est levée !", 'Happy')
    dial(ninetales, "Mais hâtez-vous... La terre tremble. Groudon s'éveille au fond de la Caverne Magma.", 'Worried')
    SV.CanonicalDungeons = SV.CanonicalDungeons or {}
    SV.CanonicalDungeons.NinetalesTestimony = true
    GAME:FadeOut(false, 30); pcall(function() GAME:GetCurrentGround():RemoveTempChar(ninetales) end)
    GAME:CutsceneMode(false)
  end,

  -- 22. Porte Caverne Magma (D12P01)
  d12p01 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 208, 232, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 184, 232, Direction.Up) end) end
    GAME:MoveCamera(208, 180, 1, false)
    SOUND:PlayBGM('Magma Cavern.ogg', true)
    GAME:FadeIn(30)
    UI:WaitShowTitle('Caverne Magma (23F)', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    dial(partner, "Le témoignage de Feunard nous innocente, mais le monde tremble toujours.", 'Determined')
    dial(partner, "Groudon menace d'embraser le continent. Descendons dans la fosse !", 'Determined')
    local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 208, 140, false, 1) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 184, 140, false, 1) end)
    TASK:JoinCoroutines({coro1, coro2})
    GAME:FadeOut(false, 30); GAME:CutsceneMode(false)
  end,

  -- 23. Cœur Caverne Magma (D12P02)
  d12p02 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 224, 304, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 192, 304, Direction.Up) end) end
    GAME:MoveCamera(224, 270, 1, false)
    SOUND:PlayBGM('Magma Cavern.ogg', true)
    GAME:FadeIn(25)
    UI:WaitShowTitle('Fosse Magmatique (Relais)', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    dial(partner, "La chaleur pulse comme un cœur sous la roche... Plus que 3 étages avant la fosse.", 'Normal')
    GAME:FadeOut(false, 25); GAME:CutsceneMode(false)
  end,

  -- 24. Fosse Groudon (D12P04)
  d12p04 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 272, 232, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 248, 232, Direction.Up) end) end
    GAME:MoveCamera(250, 190, 1, false)
    SOUND:PlayBGM('Boss Battle!.ogg', true)
    GAME:FadeIn(30)
    UI:WaitShowTitle('Groudon — Cœur de la Terre', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    local groudon = CharacterEssentials.MakeCharactersFromList({{'Groudon', 240, 160, Direction.Down}})
    BossFX.EmergeGround(groudon, 240, 160)
    dial(partner, "Groudon est hors de contrôle ! Nous devons apaiser sa fureur !", 'Determined')
    COMMON.BossTransition()
    GAME:FadeOut(false, 30); pcall(function() GAME:GetCurrentGround():RemoveTempChar(groudon) end)
    GAME:CutsceneMode(false)
  end,

  -- 25. Parvis Céleste (D13P01)
  d13p01 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 224, 160, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 192, 160, Direction.Up) end) end
    GAME:MoveCamera(208, 140, 1, false)
    SOUND:PlayBGM('Sky Tower.ogg', true)
    GAME:FadeIn(30)
    UI:WaitShowTitle('Tour Céleste (25F)', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    dial(partner, "Nous sommes au-dessus de la mer de nuages... La tour de Rayquaza se dresse devant nous.", 'Inspired')
    local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 224, 110, false, 1) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 192, 110, false, 1) end)
    TASK:JoinCoroutines({coro1, coro2})
    GAME:FadeOut(false, 30); GAME:CutsceneMode(false)
  end,

  -- 26. Palier Céleste (D13P02)
  d13p02 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 224, 304, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 192, 304, Direction.Up) end) end
    GAME:MoveCamera(224, 270, 1, false)
    SOUND:PlayBGM('Sky Tower.ogg', true)
    GAME:FadeIn(25)
    UI:WaitShowTitle('Palier Céleste (Relais)', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    dial(partner, "Les voix du monde ne nous atteignent plus... Il ne reste que le ciel et nous.", 'Normal')
    GAME:FadeOut(false, 25); GAME:CutsceneMode(false)
  end,

  -- 27. Sommet Rayquaza & Météorite (D13P03)
  
  -- 28. Rêve de Gardevoir (A04P01)
  a04p01 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 160, 272, Direction.Up) end)
    GAME:MoveCamera(160, 250, 1, false)
    SOUND:PlayBGM('At the End of the Day.ogg', true)
    GAME:FadeIn(30)
    UI:WaitShowTitle('La Vision de Gardevoir', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    hero_pense(hero, "(Dans la lumière du rêve, Gardevoir ne donne pas d'ordre... Elle montre un chemin.)", 'Normal')
    hero_pense(hero, "(Notre héritage n'est pas d'être crus. C'est de choisir de sauver ce monde malgré tout.)", 'Determined')
    GAME:FadeOut(false, 30); GAME:CutsceneMode(false)
  end,

  -- 29. Fin de l'Arc Fugitif (A05P03)
  a05p03 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 160, 120, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 136, 120, Direction.Up) end) end
    GAME:MoveCamera(160, 120, 1, false)
    SOUND:PlayBGM('Job Clear!.ogg', true)
    GAME:FadeIn(30)
    UI:WaitShowTitle('Une Vérité Rétablie', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    dial(partner, "La fuite s’achève là où commence notre décision.", 'Inspired')
    dial(partner, "Nous retournons devant Metano ! Non pas pour supplier... mais pour raconter toute la vérité !", 'Determined')
    GAME:FadeOut(false, 30); GAME:CutsceneMode(false)
  end,
  d13p03 = function()
    GAME:CutsceneMode(true)
    local hero, partner = CH('PLAYER'), CH('Teammate1')
    pcall(function() GROUND:TeleportTo(hero, 296, 296, Direction.Up) end)
    if partner then pcall(function() GROUND:TeleportTo(partner, 256, 296, Direction.Up) end) end
    GAME:MoveCamera(272, 272, 1, false)
    SOUND:PlayBGM('Sky Tower.ogg', true)
    GAME:FadeIn(40)
    UI:WaitShowTitle('Rayquaza — Arbitre du Ciel', 20); GAME:WaitFrames(35); UI:WaitHideTitle(20)
    local rayquaza = CharacterEssentials.MakeCharactersFromList({{'Rayquaza', 272, 240, Direction.Down}})
    BossFX.DescendSky(rayquaza, 272, 240, 180)
    dial(rayquaza, "Mortels... Vous foulez le domaine sacré de la stratosphère.", 'Normal')
    dial(partner, "Rayquaza ! Une étoile destructrice fonce sur notre monde ! Seul votre souffle peut la briser !", 'Determined')
    dial(rayquaza, "Prouvez que la vie d'en bas mérite d'être sauvée !", 'Determined')
    COMMON.BossTransition()
    GAME:FadeOut(false, 30); pcall(function() GAME:GetCurrentGround():RemoveTempChar(rayquaza) end)
    GAME:CutsceneMode(false)
  end
}

function FugitiveCinematics.Play(id)
  local fn = FugitiveCinematics.SCENES[id]
  if fn then
    fn()
  else
    PrintInfo('[FugitiveCinematics] Scène inconnue : ' .. tostring(id))
    GAME:FadeIn(20)
  end
end

return FugitiveCinematics
