-- Luluby Town — adaptation jouable du Ground OVERW1 de Waves of Nostalgia.
-- Les positions des résidents proviennent de SCRIPT/OVERW1/enter.sse du ROM hack.
require 'origin.common'
require 'halcyon.PartnerEssentials'
local L = {}
local PERIOD = {luluby_town_morning='morning',luluby_town_evening='evening',luluby_town_night='night'}
local RESIDENTS = {
  -- instance, species, x/y PMD Sky (case*8 + offset), direction
  {'Luluby_Dragonair','dragonair',138,138,Direction.Right},
  {'Luluby_Gourgeist','gourgeist',176,138,Direction.Left},
  {'Luluby_Eldegoss','eldegoss',256,384,Direction.Right},
  {'Luluby_Cinccino','cinccino',296,192,Direction.Down},
  {'Luluby_Stantler_North','stantler',440,162,Direction.DownLeft},
  {'Luluby_Stantler_Plaza','stantler',378,250,Direction.Left},
  {'Luluby_Sableye','sableye',272,312,Direction.UpRight},
  {'Luluby_Comfey','comfey',304,314,Direction.UpLeft},
  {'Luluby_Lycanroc','lycanroc',288,282,Direction.Down},
  {'Luluby_Anorith','anorith',544,368,Direction.Down},
}
local LINES = {
 morning={
  Luluby_Dragonair="La brise du matin est idéale pour accueillir les guildes. Le tournoi va remplir toute la place.",
  Luluby_Gourgeist="J'accroche les fanions avant que le soleil ne soit trop haut. Aucun nœud ne doit céder !",
  Luluby_Eldegoss="Les équipes arrivent de très loin. Luluby leur offrira de l'ombre, de l'eau et un terrain loyal.",
  Luluby_Cinccino="Chaque pavé a été nettoyé deux fois. Une troisième ne ferait pas de mal.",
  Luluby_Stantler_North="Bienvenue à Luluby Town. La Fédération a réservé la ville au Tournoi Multiguilde.",
  Luluby_Stantler_Plaza="Les inscriptions se feront ici. Gardez le passage central libre.",
  Luluby_Sableye="Je surveille les trophées. Je les surveille seulement. Inutile de me regarder comme ça.",
  Luluby_Comfey="Les couronnes des finalistes doivent être fraîches au moment de la cérémonie.",
  Luluby_Lycanroc="Le sable révèle les appuis hésitants. C'est un excellent terrain d'entraînement.",
  Luluby_Anorith="Les équipes maritimes ont déjà accosté. Elles sont rapides, même avec leurs caisses."
 },
 evening={
  Luluby_Dragonair="La lumière baisse. Les dernières délégations devraient atteindre le port avant la nuit.",
  Luluby_Gourgeist="Les lanternes sont prêtes. Ce soir, même les chemins secondaires resteront visibles.",
  Luluby_Eldegoss="Une bonne soirée avant les épreuves vaut parfois davantage qu'un entraînement de plus.",
  Luluby_Cinccino="La place était impeccable ce matin. Puis les guildes sont arrivées.",
  Luluby_Stantler_North="Les épreuves du jour sont terminées. Les arbitres publient les résultats demain matin.",
  Luluby_Stantler_Plaza="Pas de duel improvisé sur la place. Même amical. Surtout amical.",
  Luluby_Sableye="Les trophées brillent mieux au coucher du soleil. Je constate un fait, voilà tout.",
  Luluby_Comfey="Les concurrents blessés passent avant les décorations. Venez me voir au moindre doute.",
  Luluby_Lycanroc="Le soleil rasant gêne la vue. Un explorateur apprend aussi à lire les ombres.",
  Luluby_Anorith="La marée remonte. Les bateaux seront prêts pour les départs de demain."
 },
 night={
  Luluby_Dragonair="La mer est calme. On entend pourtant les équipes répéter leurs stratégies derrière chaque porte.",
  Luluby_Gourgeist="Les lanternes tiennent bon. Luluby ne s'endormira pas tout à fait cette nuit.",
  Luluby_Eldegoss="Parlez doucement. Certains concurrents découvrent enfin le repos.",
  Luluby_Cinccino="J'avais fini de nettoyer. Puis quelqu'un a traversé la place avec des pattes pleines de sable.",
  Luluby_Stantler_North="La circulation est réduite la nuit, mais le retour vers Métano reste disponible.",
  Luluby_Stantler_Plaza="Le tableau des épreuves est scellé jusqu'au matin. Aucune exception.",
  Luluby_Sableye="Je ne dors pas. Les trophées non plus. Nous avons beaucoup en commun.",
  Luluby_Comfey="Une tisane, une respiration lente, et au lit. Le tournoi continuera demain.",
  Luluby_Lycanroc="La nuit masque les repères inutiles. Elle révèle les bons réflexes.",
  Luluby_Anorith="Les quais sont fermés, sauf urgence. La mer mérite aussi son silence."
 }
}
local function spawn(name,species,x,y,dir)
 local c=RogueEssence.Ground.GroundChar(RogueEssence.Dungeon.MonsterID(species,0,'normal',Gender.Unknown),RogueElements.Loc(x,y),dir,name,name)
 c:ReloadEvents();GAME:GetCurrentGround():AddTempChar(c);return c
end
function L.Init(map)
 COMMON.RespawnAllies(true);PartnerEssentials.InitializePartnerSpawn()
end
function L.Enter(map)
 local id=GAME:GetCurrentGround().AssetName;local period=PERIOD[id] or 'morning'
 SV.LulubyTown=SV.LulubyTown or {};SV.LulubyTown.Period=period;SV.LulubyTown.Visited=true
 for _,v in ipairs(RESIDENTS) do spawn(v[1],v[2],v[3],v[4],v[5]) end
 PrintInfo('[LULUBY_RUNTIME] LOAD='..id..' period='..period..' residents='..tostring(#RESIDENTS)..' source=OVERW1')
 SOUND:PlayBGM('Treasure Town.ogg',true);GAME:FadeIn(20)
end
function L.Teammate1_Action(chara,activator) PartnerEssentials.GetPartnerDialogue(chara) end
function L.Teammate2_Action(chara,activator) PartnerEssentials.GetPartnerDialogue(chara) end
function L.Teammate3_Action(chara,activator) PartnerEssentials.GetPartnerDialogue(chara) end
local function talk(chara)
 local period=(SV.LulubyTown and SV.LulubyTown.Period) or 'morning';UI:SetSpeaker(chara);UI:WaitShowDialogue(LINES[period][chara.EntName])
end
for _,v in ipairs(RESIDENTS) do local n=v[1];L[n..'_Action']=function(chara,activator)talk(chara)end end
function L.Luluby_Stantler_North_Action(chara,activator)
 UI:SetSpeaker(chara);UI:ChoiceMenuYesNo("Retourner à Métano ?");UI:WaitForChoice()
 if UI:ChoiceResult() then SOUND:FadeOutBGM(30);GAME:FadeOut(false,30);GAME:EnterGroundMap('metano_town','Main_Entrance_Marker') else talk(chara) end
end
function L.Exit(map) end
function L.Update(map,time) end
function L.GameSave(map) end
function L.GameLoad(map) GAME:FadeIn(20) end
return L
