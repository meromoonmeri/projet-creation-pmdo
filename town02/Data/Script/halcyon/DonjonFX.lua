--[[
    DonjonFX.lua — mise en scene A L'INTERIEUR d'un etage de donjon.

    ==================================================================
    POURQUOI CE FICHIER EXISTE
    ==================================================================
    BossFX.lua est integralement ecrit en API GROUND: (PlayVFX, MoveScreen,
    CharSetEmote, CharSetAnim, CharSetDrawEffect, Hide/Unhide). Cette API
    n'existe QUE sur une carte de type ground. Appeler BossFX depuis un etage
    de donjon leve « attempt to index a nil value (global 'GROUND') ».

    Les arenes des Regi sont devenues des etages de zone. Il fallait donc le
    strict equivalent, ecrit contre l'API DUNGEON:, qui est celle disponible
    en combat.

    ==================================================================
    CORRESPONDANCE DES DEUX API (relevee sur la source du moteur,
    RogueEssence/Lua/ScriptDungeon.cs — pas devinee)
    ==================================================================
      GROUND:PlayVFX(e, x, y)            -> DUNGEON:PlayVFX(e, x, y)
      GROUND:MoveScreen(mover)           -> DUNGEON:MoveScreen(mover)
      GROUND:CharSetEmote(c, id, cyc)    -> DUNGEON:CharSetEmote(c, id, cyc)
      GROUND:CharSetAnim(c, anim, loop)  -> DUNGEON:CharStartAnim(c, anim, loop)
                                            DUNGEON:CharEndAnim(c)
      GROUND:CharAnimateTurnTo(c, dir)   -> DUNGEON:CharTurnToChar(c, autre)
      GROUND:Hide / Unhide               -> AUCUN EQUIVALENT (voir plus bas)

    DIFFERENCE DE COORDONNEES, source d'erreur classique :
      * en ground, un personnage porte .Position (deja en pixels) ;
      * en donjon, il porte .CharLoc (en TUILES) et .MapLoc (en pixels).
    Les emetteurs de VFX attendent des PIXELS. On passe donc toujours par
    DonjonFX.Pixel(chara), jamais par CharLoc directement.
    Patron atteste : event_battle.lua:736 utilise target.MapLoc.X/Y.

    ==================================================================
    CE QU'ON NE PEUT PAS FAIRE EN DONJON, ET CE QU'ON FAIT A LA PLACE
    ==================================================================
    Il n'existe pas de DUNGEON:Hide. Pour faire disparaitre un combattant on
    dispose de _DUNGEON:RemoveChar(chara), atteste event_single.lua:549 (la
    fuite d'un hors-la-loi) — c'est un retrait definitif, pas un masquage
    temporaire. C'est exactement ce qu'il faut pour les Regi qui redeviennent
    statues : ils quittent la carte apres leur derniere replique.

    Toutes les animations nommees utilisees ici ("Hurt", "Charge", "Idle") et
    tous les SE sont deja employes ailleurs dans le depot. Aucun nom nouveau.
]]--
require 'origin.common'

DonjonFX = {}

--------------------------------------------------------------------
-- Conversions et acces surs
--------------------------------------------------------------------

--Pixels d'un personnage de donjon. MapLoc est le champ pixel atteste
--(event_battle.lua:736) ; on retombe sur CharLoc*24 si jamais il manque.
function DonjonFX.Pixel(chara)
    if chara == nil then return 0, 0 end
    local ok, x, y = pcall(function()
        return chara.MapLoc.X, chara.MapLoc.Y
    end)
    if ok and x ~= nil then return x, y end
    return chara.CharLoc.X * 24 + 12, chara.CharLoc.Y * 24 + 12
end

--Le chef d'equipe. En donjon on passe par GAME:GetPlayerPartyMember,
--jamais par CH() qui est un helper de ground.
function DonjonFX.Hero()
    local ok, c = pcall(function() return GAME:GetPlayerPartyMember(0) end)
    if ok then return c end
    return nil
end

function DonjonFX.Partner()
    local ok, c = pcall(function()
        if GAME:GetPlayerPartyCount() > 1 then
            return GAME:GetPlayerPartyMember(1)
        end
        return nil
    end)
    if ok then return c end
    return nil
end

--Toute l'equipe presente et debout.
function DonjonFX.Equipe()
    local out = {}
    pcall(function()
        for i = 0, GAME:GetPlayerPartyCount() - 1, 1 do
            local c = GAME:GetPlayerPartyMember(i)
            if c ~= nil and not c.Dead then table.insert(out, c) end
        end
    end)
    return out
end

--Le premier ennemi vivant de la carte : le gardien, dans nos arenes.
--Sert a recuperer le boss sans le nommer en dur.
function DonjonFX.Gardien()
    local trouve = nil
    pcall(function()
        for i = 0, _ZONE.CurrentMap.MapTeams.Count - 1, 1 do
            local team = _ZONE.CurrentMap.MapTeams[i].Players
            for j = 0, team.Count - 1, 1 do
                if not team[j].Dead and trouve == nil then
                    trouve = team[j]
                end
            end
        end
    end)
    return trouve
end

--Tous les ennemis vivants, dans l'ordre de la carte.
function DonjonFX.Ennemis()
    local out = {}
    pcall(function()
        for i = 0, _ZONE.CurrentMap.MapTeams.Count - 1, 1 do
            local team = _ZONE.CurrentMap.MapTeams[i].Players
            for j = 0, team.Count - 1, 1 do
                if not team[j].Dead then table.insert(out, team[j]) end
            end
        end
    end)
    return out
end

--------------------------------------------------------------------
-- Briques de base
--------------------------------------------------------------------

--Tremblement d'ecran. ScreenMover(min, max, duree), forme attestee
--event_single.lua:1182.
function DonjonFX.Secousse(puissance, duree)
    puissance = puissance or 6
    duree = duree or 30
    pcall(function()
        DUNGEON:MoveScreen(
            RogueEssence.Content.ScreenMover(0, puissance, duree))
    end)
end

--Flash plein ecran. Emetteur monte comme event_battle.lua:721-728.
function DonjonFX.Flash(chara, teinte, tenue)
    pcall(function()
        local e = RogueEssence.Content.FlashEmitter()
        e.FadeInTime = 2
        e.HoldTime = tenue or 4
        e.FadeOutTime = 24
        e.StartColor = teinte or Color(255, 255, 255, 0)
        e.Layer = DrawLayer.Top
        e.Anim = RogueEssence.Content.BGAnimData("White", 0)
        local x, y = DonjonFX.Pixel(chara or DonjonFX.Hero())
        DUNGEON:PlayVFX(e, x, y)
    end)
    SOUND:PlayBattleSE("EVT_Battle_Flash")
end

--Emote au-dessus de la tete. DUNGEON:CharSetEmote(c, id, cycles).
function DonjonFX.Emote(chara, id, cycles)
    if chara == nil then return end
    pcall(function() DUNGEON:CharSetEmote(chara, id or "", cycles or 1) end)
end

--Animation nommee. CharStartAnim boucle, CharEndAnim rend la main.
function DonjonFX.Anim(chara, nom, boucle)
    if chara == nil then return end
    pcall(function() DUNGEON:CharStartAnim(chara, nom, boucle == true) end)
end

function DonjonFX.FinAnim(chara)
    if chara == nil then return end
    pcall(function() DUNGEON:CharEndAnim(chara) end)
end

--Sursaut de douleur : l'anim Hurt jouee sur place, patron
--beginner_lesson_evt.lua:69-73 (BaseFrameType 4 = hurt).
function DonjonFX.Sursaut(chara)
    if chara == nil then return end
    pcall(function()
        local a = RogueEssence.Dungeon.CharAnimAction()
        a.BaseFrameType = 4
        a.AnimLoc = chara.CharLoc
        a.CharDir = chara.CharDir
        TASK:WaitTask(chara:StartAnim(a))
    end)
end

--Bond sur place. BaseFrameType 43 = hop, atteste event_battle.lua:730-733.
function DonjonFX.Bond(chara)
    if chara == nil then return end
    pcall(function()
        local a = RogueEssence.Dungeon.CharAnimAction()
        a.BaseFrameType = 43
        a.AnimLoc = chara.CharLoc
        a.CharDir = chara.CharDir
        TASK:WaitTask(chara:StartAnim(a))
    end)
end

--Toute l'equipe se tourne vers une cible. Chacun se reoriente selon SA
--position (CharTurnToChar calcule la direction depuis la geometrie), avec
--un decalage de quelques frames : jamais une rotation de groupe d'un bloc.
function DonjonFX.RegarderVers(cible, decalage)
    if cible == nil then return end
    decalage = decalage or 6
    -- CHACUN TOURNE LA TETE A SON RYTHME, EN PARALLELE.
    -- L'ancienne version bouclait en sequence avec un WaitFrames entre
    -- deux : le decalage etait juste, mais il fallait attendre la fin du
    -- precedent avant de lancer le suivant. Avec des coroutines, tout part
    -- ensemble et le decalage vit A L'INTERIEUR de chaque branche —
    -- patron atteste en donjon (event_single.lua:1392, chute des rochers).
    local co = {}
    for i, c in ipairs(DonjonFX.Equipe()) do
        co[#co + 1] = TASK:BranchCoroutine(function()
            GAME:WaitFrames((i - 1) * decalage)
            pcall(function() DUNGEON:CharTurnToChar(c, cible) end)
        end)
    end
    if #co > 0 then pcall(function() TASK:JoinCoroutines(co) end) end
end

--Souffle d'impact : l'ecran encaisse, puis chaque membre de l'equipe
--recule a son tour. Equivalent donjon de BossFX.Impact.
function DonjonFX.Impact(puissance)
    puissance = puissance or 8
    DonjonFX.Secousse(math.max(4, puissance), 28)
    SOUND:PlayBattleSE("EVT_Emote_Startled")
    local equipe = DonjonFX.Equipe()

    -- UN SOUFFLE REPOUSSE TOUT LE MONDE EN MEME TEMPS.
    -- Defaut corrige : la boucle appelait DonjonFX.Sursaut, qui fait un
    -- TASK:WaitTask(chara:StartAnim(...)) — donc BLOQUANT. Chaque membre
    -- attendait la fin de l'animation du precedent : au lieu d'un impact,
    -- on voyait une file d'attente de personnages qui reculent chacun leur
    -- tour. Avec quatre equipiers, l'effet s'etalait sur pres d'une
    -- seconde et ne se lisait plus comme un souffle.
    -- Chaque recul part maintenant dans sa propre coroutine ; le decalage
    -- de 5 frames est conserve, mais il se joue DANS la branche.
    local co = {}
    for i, c in ipairs(equipe) do
        co[#co + 1] = TASK:BranchCoroutine(function()
            GAME:WaitFrames((i - 1) * 5)
            DonjonFX.Emote(c, "shock", 1)
            DonjonFX.Sursaut(c)
        end)
    end
    if #co > 0 then pcall(function() TASK:JoinCoroutines(co) end) end

    GAME:WaitFrames(16)
    for _, c in ipairs(equipe) do DonjonFX.Emote(c, "", 0) end
end

--Grondement montant : plusieurs secousses breves qui se rapprochent.
--Le sol previent avant que quoi que ce soit ne bouge.
function DonjonFX.Grondement(cycles)
    cycles = cycles or 3
    for i = 1, cycles do
        DonjonFX.Secousse(2 + i, 14)
        SOUND:PlayBattleSE("EVT_Tower_Quake")
        GAME:WaitFrames(20 - i * 2)
    end
end

--------------------------------------------------------------------
-- Dialogue
--------------------------------------------------------------------

--Recit centre, sans locuteur. Ouverture et cloture d'acte uniquement.
function DonjonFX.Recit(cle)
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue(STRINGS:FormatKey(cle))
    UI:SetCenter(false)
    UI:ResetSpeaker()
end

--Replique d'un personnage de l'equipe.
function DonjonFX.Dire(chara, cle, emotion)
    if chara == nil then return DonjonFX.Recit(cle) end
    UI:SetSpeaker(chara)
    if emotion ~= nil then
        pcall(function() GeneralFunctions.SetEmotion(emotion) end)
    end
    UI:WaitShowDialogue(STRINGS:FormatKey(cle))
    UI:ResetSpeaker()
end

--Pensee du heros. Le heros NE PARLE JAMAIS a voix haute : le texte est
--deja entre parentheses dans le .resx, on ne fait que le presenter sans
--bulle de locuteur nomme.
function DonjonFX.Penser(cle, emotion)
    local hero = DonjonFX.Hero()
    if hero == nil then return DonjonFX.Recit(cle) end
    UI:SetSpeaker(hero)
    pcall(function() GeneralFunctions.SetEmotion(emotion or "Worried") end)
    UI:WaitShowDialogue(STRINGS:FormatKey(cle))
    UI:ResetSpeaker()
end

--Un GARDIEN parle. Equivalent donjon de BossFX.GuardianVoice : nom masque
--(\uE040) mais portrait et espece bien a lui — quelqu'un de reel, situe
--dans le decor, pas un oracle desincarne. Patron du clan Limagma.
function DonjonFX.VoixGardien(chara, cle)
    if chara == nil then return DonjonFX.Recit(cle) end
    SOUND:PlayBattleSE('EVT_Emote_Exclaim')
    UI:SetSpeaker(STRINGS:Format("\\uE040"), true,
                  chara.CurrentForm.Species, chara.CurrentForm.Form,
                  chara.CurrentForm.Skin, chara.CurrentForm.Gender)
    UI:WaitShowDialogue(STRINGS:FormatKey(cle))
    UI:ResetSpeaker()
end

--------------------------------------------------------------------
-- Signatures d'eveil — une par gardien, jamais interchangeables
--------------------------------------------------------------------

--REGICE : le froid arrive AVANT lui. L'air se givre, l'equipe le sent sur
--la peau, puis la glace se fend. Pas de secousse : le froid ne fait pas de
--bruit, il s'installe.
function DonjonFX.EveilGlace(gardien)
    local x, y = DonjonFX.Pixel(gardien)
    SOUND:FadeOutBGM(40)
    GAME:WaitFrames(50)

    -- Le froid gagne l'equipe avant que le gardien ne bouge.
    for _, c in ipairs(DonjonFX.Equipe()) do
        DonjonFX.Emote(c, "sweating", 1)
        GAME:WaitFrames(7)
    end
    GAME:WaitFrames(30)

    -- Trois pulsations glacees de plus en plus rapprochees.
    for i = 1, 3 do
        pcall(function()
            local e = RogueEssence.Content.SingleEmitter(
                RogueEssence.Content.AnimData("Wave_Circle_Blue", 3))
            e.Layer = DrawLayer.Front
            DUNGEON:PlayVFX(e, x, y)
        end)
        SOUND:PlayBattleSE("DUN_Icy_Wind")
        GAME:WaitFrames(30 - i * 6)
    end

    -- La glace cede.
    DonjonFX.Flash(gardien, Color(200, 235, 255, 0), 6)
    DonjonFX.Secousse(5, 24)
    SOUND:PlayBattleSE("DUN_Ice_Shard")
    DonjonFX.Bond(gardien)
    GAME:WaitFrames(30)
    for _, c in ipairs(DonjonFX.Equipe()) do DonjonFX.Emote(c, "", 0) end
end

--REGIROCK : la pierre s'ebroue. Une secousse d'abord, des eclats qui
--tombent, puis la masse se redresse. Tout en poids et en bruit — l'exact
--oppose du silence de Regice.
function DonjonFX.EveilRoche(gardien)
    local x, y = DonjonFX.Pixel(gardien)
    SOUND:FadeOutBGM(30)
    GAME:WaitFrames(40)

    -- Le grondement monte : trois secousses qui se rapprochent.
    DonjonFX.Grondement(3)

    -- Les eclats tombent autour du gardien.
    for i = 1, 4 do
        pcall(function()
            local e = RogueEssence.Content.SingleEmitter(
                RogueEssence.Content.AnimData("Rock_Pieces", 3))
            e.Layer = DrawLayer.Front
            DUNGEON:PlayVFX(e, x + (i % 2 == 0 and 32 or -32), y - 16)
        end)
        SOUND:PlayBattleSE("DUN_Rock_Slide")
        GAME:WaitFrames(12)
    end
    GAME:WaitFrames(20)

    -- La masse se redresse : l'impact met tout le monde a terre.
    DonjonFX.Impact(10)
    DonjonFX.Bond(gardien)
    GAME:WaitFrames(30)
end

--REGISTEEL : il ne s'eveille pas. Il etait deja debout, immobile, depuis le
--debut — c'est la LUMIERE qui le revele. Aucune secousse, aucun bruit :
--juste un ecran qui s'eclaire sur une silhouette qui n'a jamais bouge. Le
--plus inquietant des trois, par soustraction.
function DonjonFX.EveilAcier(gardien)
    local x, y = DonjonFX.Pixel(gardien)
    SOUND:FadeOutBGM(60)
    GAME:WaitFrames(80)   -- le silence, tenu plus longtemps que partout ailleurs

    -- Une seule lueur, froide, qui monte lentement.
    pcall(function()
        local e = RogueEssence.Content.FlashEmitter()
        e.FadeInTime = 40
        e.HoldTime = 30
        e.FadeOutTime = 50
        e.StartColor = Color(220, 230, 245, 0)
        e.Layer = DrawLayer.Top
        e.Anim = RogueEssence.Content.BGAnimData("White", 0)
        DUNGEON:PlayVFX(e, x, y)
    end)
    GAME:WaitFrames(60)

    -- L'equipe comprend en meme temps que le joueur : il etait la.
    for _, c in ipairs(DonjonFX.Equipe()) do
        DonjonFX.Emote(c, "shock", 1)
        GAME:WaitFrames(9)
    end
    SOUND:PlayBattleSE("EVT_Emote_Startled")
    GAME:WaitFrames(50)
    for _, c in ipairs(DonjonFX.Equipe()) do DonjonFX.Emote(c, "", 0) end
end

--REGIGIGAS : les trois autres reunis, et quelque chose de plus. Le sol
--tremble sans discontinuer, la lumiere ET la secousse ET le froid — c'est
--la seule scene ou l'on cumule, parce que c'est lui que les trois gardaient.
function DonjonFX.EveilTitan(gardien)
    local x, y = DonjonFX.Pixel(gardien)
    SOUND:FadeOutBGM(40)
    GAME:WaitFrames(60)

    -- Un grondement plus long que tous les precedents.
    for i = 1, 5 do
        DonjonFX.Secousse(2 + i, 18)
        SOUND:PlayBattleSE("EVT_Tower_Quake")
        GAME:WaitFrames(22 - i * 2)
    end

    -- Les trois signatures rejouees en cascade, une par gardien vaincu.
    pcall(function()
        local e = RogueEssence.Content.SingleEmitter(
            RogueEssence.Content.AnimData("Wave_Circle_Blue", 3))
        e.Layer = DrawLayer.Front
        DUNGEON:PlayVFX(e, x, y)
    end)
    GAME:WaitFrames(18)
    pcall(function()
        local e = RogueEssence.Content.SingleEmitter(
            RogueEssence.Content.AnimData("Rock_Pieces", 3))
        e.Layer = DrawLayer.Front
        DUNGEON:PlayVFX(e, x, y)
    end)
    GAME:WaitFrames(18)
    DonjonFX.Flash(gardien, Color(255, 250, 230, 0), 10)
    GAME:WaitFrames(24)

    -- Le reveil proprement dit.
    DonjonFX.Impact(12)
    DonjonFX.Bond(gardien)
    GAME:WaitFrames(36)
end

--------------------------------------------------------------------
-- Retrait : le gardien redevient statue
--------------------------------------------------------------------
-- Demande explicite : « je veux qu'ils disparaissent, ils seront recrutables
-- plus tard. L'ideal serait qu'ils redeviennent des statues. »
--
-- Il n'existe pas de DUNGEON:Hide. Le retrait se fait en deux temps :
--   1. le gardien se fige — anim Charge tenue, qui donne la raideur d'une
--      statue bien mieux qu'un sommeil ;
--   2. _DUNGEON:RemoveChar le sort de la carte (atteste event_single.lua:549).
-- Entre les deux, une lueur qui s'eteint : on VOIT la pierre reprendre.
function DonjonFX.RedevenirStatue(gardien)
    if gardien == nil then return end
    local x, y = DonjonFX.Pixel(gardien)

    DonjonFX.Anim(gardien, "Charge", true)
    SOUND:PlayBattleSE("DUN_Harden")
    GAME:WaitFrames(40)

    -- La lueur se retire lentement : longue disparition, pas de coupure nette.
    pcall(function()
        local e = RogueEssence.Content.FlashEmitter()
        e.FadeInTime = 10
        e.HoldTime = 20
        e.FadeOutTime = 60
        e.StartColor = Color(200, 200, 210, 0)
        e.Layer = DrawLayer.Top
        e.Anim = RogueEssence.Content.BGAnimData("White", 0)
        DUNGEON:PlayVFX(e, x, y)
    end)
    GAME:WaitFrames(70)

    DonjonFX.Secousse(3, 20)
    SOUND:PlayBattleSE("DUN_Rock_Slide")
    GAME:WaitFrames(20)

    pcall(function() _DUNGEON:RemoveChar(gardien) end)
    GAME:WaitFrames(30)
end

return DonjonFX
