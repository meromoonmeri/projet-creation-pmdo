require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.LivingWorld'
local treasure_spinda_cafe={}
local function say(c,e,t) UI:SetSpeaker(c);GeneralFunctions.SetEmotion(e);UI:WaitShowDialogue(t) end
function treasure_spinda_cafe.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies();PartnerEssentials.InitializePartnerSpawn();pcall(function() LivingWorld.SyncStory() end) end
function treasure_spinda_cafe.Enter(map)
 SV.TreasureTown=SV.TreasureTown or {};SV.TreasureTown.SpindaCafe=SV.TreasureTown.SpindaCafe or {}
 if not SV.TreasureTown.SpindaCafe.FirstVisit then
  SV.TreasureTown.SpindaCafe.FirstVisit=true;GAME:CutsceneMode(true);GAME:FadeIn(20)
  local hero,partner,spinda=CH('PLAYER'),CH('Teammate1'),CH('Spinda')
  GROUND:CharTurnToCharAnimated(spinda,hero,4);GROUND:CharSetEmote(spinda,'notice',1);GAME:WaitFrames(20)
  say(spinda,'Inspired',"Oh ![pause=12] Deux visages que je ne reconnais pas.[pause=18] Et je reconnais presque tout le monde qui franchit cet escalier.")
  GROUND:MoveToPosition(spinda,35*8,23*8,false,1);GROUND:CharTurnToCharAnimated(spinda,hero,4)
  say(spinda,'Normal',"Vous ne venez pas du Bourg du Trésor.[pause=15] Vos badges, votre poussière de route…[pause=12] Metano Town, peut-être ?")
  if partner then say(partner,'Surprised',"Ça se voit à ce point ?[pause=12] Nous sommes seulement venus visiter.") end
  GeneralFunctions.HeroDialogue(hero,"(Les voyageurs sont remarqués vite, ici. Cette ville garde la mémoire de ceux qui la traversent.)",'Normal')
  say(spinda,'Happy',"Alors bienvenue ![pause=12] Ici, les nouvelles arrivent avec les voyageurs, les explorateurs et les Bekipan.[pause=15] Prenez une table : vous entendrez bientôt tout ce que le monde raconte.")
  SV.TreasureTown.SpindaCafe.RumorState=SV.TreasureTown.SpindaCafe.RumorState or 0
  GROUND:MoveToPosition(spinda,31*8,18*8,false,1);GROUND:CharAnimateTurnTo(spinda,Direction.Down,4)
  GAME:CutsceneMode(false)
 else GAME:FadeIn(20) end
end
function treasure_spinda_cafe.Spinda_Action(c,a)
 local ch=SV.ChapterProgression and SV.ChapterProgression.Chapter or 0
 local ctx=LivingWorld.Context('treasure','treasure_spinda_cafe')
 if ctx.Weather=='orage' then say(c,'Worried',"Les Bekipan restent au perchoir pendant l'orage.[pause=15] Pour une fois, les nouvelles devront attendre.")
 elseif ctx.Season=='hiver' then say(c,'Happy',"Le café ne désemplit pas quand il neige.[pause=15] Les voyageurs apportent le froid et repartent avec une rumeur chaude.")
 elseif (ctx.Raid.Repelled or 0)>0 and LivingWorld.Knows('treasure','metano_raid_repelled_'..tostring(ctx.Raid.Repelled)) then say(c,'Worried',"Un courrier parle d'une attaque nocturne à Metano.[pause=15] Votre garde l'a repoussée, mais cette nouvelle voyage vite.")
 elseif ch>=10 then say(c,'Normal',"Les Bekipan parlent de remous jusque dans le ciel.[pause=15] Votre équipe apparaît dans beaucoup trop de dépêches pour de simples touristes.")
 elseif ch>=7 then say(c,'Worried',"Les courriers venus de Metano mentionnent des ruines et des secousses.[pause=15] Les rumeurs courent plus vite que les fissures.")
 else say(c,'Happy',"Alors, voyageurs de Metano : quelles nouvelles apportez-vous aujourd'hui ?") end
end
function treasure_spinda_cafe.Wynaut_Action(c,a) say(c,'Happy',"Le comptoir de recyclage est ouvert ![pause=10] Enfin… dès que l'inventaire du jour sera arrivé.") end
function treasure_spinda_cafe.Wobbuffet_Action(c,a) say(c,'Inspired',"C'EST EXACT !") end
function treasure_spinda_cafe.Kangaskhan_Action(c,a) say(c,'Normal',"Je garde les réserves du café. Les voyageurs oublient souvent de préparer le retour.") end
function treasure_spinda_cafe.CafeExit_Touch(o,a) GAME:FadeOut(false,20);GAME:EnterGroundMap('carrefour_assemblee','SpindaCafeReturnMarker') end
function treasure_spinda_cafe.Exit(map) end function treasure_spinda_cafe.Update(map,time) end
function treasure_spinda_cafe.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function treasure_spinda_cafe.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'));GAME:FadeIn(20) end
return treasure_spinda_cafe
