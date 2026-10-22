require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.CharacterEssentials'
local NDSScenes=require 'halcyon.ClovenNDSScenes'
local C={}
local CFG={
 cloven_ruin_regice_chamber_sky={name='Regice',seg=1,next=2,species='Regice'},
 cloven_ruin_regirock_chamber_sky={name='Regirock',seg=3,next=4,species='Regirock'},
 cloven_ruin_registeel_chamber_sky={name='Registeel',seg=5,next=6,species='Registeel'},
 cloven_ruin_regigigas_chamber_sky={name='Regigigas',seg=7,next=nil,species='Regigigas'},
}
local function cfg() return CFG[GAME:GetCurrentGround().AssetName] end
function C.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies(true);PartnerEssentials.InitializePartnerSpawn() end
function C.Enter(map)
 local c=cfg();if not c then error('Unknown canonical Cloven chamber Ground') end
 SV.Ruines=SV.Ruines or {};GAME:CutsceneMode(true);GAME:FadeIn(25)
 local boss=CharacterEssentials.MakeCharactersFromList({{c.species,224,144,Direction.Down}})
 local defeated=SV.Ruines['Vaincu'..c.name]==true
 local pre={Regice='s04p0501',Regirock='s04p1001',Registeel='s04p1301'}
 local post={Regice='s04p0601',Regirock='s04p1101',Registeel='s04p1501'}
 if not defeated then
  if c.name=='Regigigas' then NDSScenes.RegigigasIntro() else NDSScenes.Begin(pre[c.name]) end
  GAME:MoveCamera(224,176,35,false);GROUND:CharSetEmote(boss,'notice',1);GAME:WaitFrames(18)
  GAME:FadeOut(false,30);GAME:CutsceneMode(false)
  GAME:EnterDungeon('cloven_ruins',c.seg,0,0,RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,false)
  return
 end
 GAME:WaitFrames(20)
 if c.next then
  NDSScenes.Begin(post[c.name])
  GROUND:CharAnimateTurnTo(boss,Direction.Down,4);UI:SetSpeaker(boss);UI:WaitShowDialogue('JE SUIS '..string.upper(c.name)..'.[pause=20] JE VOUS JURE FIDÉLITÉ.')
  NDSScenes.Complete(post[c.name])
  GAME:FadeOut(false,30);GAME:CutsceneMode(false)
  GAME:EnterDungeon('cloven_ruins',c.next,0,0,RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,false)
 else
  NDSScenes.Begin('s04p2001');GROUND:CharAnimateTurnTo(boss,Direction.Down,4);UI:SetSpeaker(boss);UI:WaitShowDialogue('JE SUIS REGIGIGAS.[pause=20] JE RECONNAIS VOTRE VALEUR.');NDSScenes.Complete('s04p2001')
  GAME:FadeOut(false,30);GAME:CutsceneMode(false);GAME:EnterGroundMap('cloven_ruins_entrance','Main_Entrance_Marker')
 end
end
function C.Exit(map) end
function C.Update(map,time) end
function C.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function C.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'));GAME:CutsceneMode(false);GAME:FadeIn(20) end
function C.Teammate1_Action(c,a) PartnerEssentials.GetPartnerDialogue(c) end
function C.Teammate2_Action(c,a) PartnerEssentials.GetPartnerDialogue(c) end
function C.Teammate3_Action(c,a) PartnerEssentials.GetPartnerDialogue(c) end
return C
