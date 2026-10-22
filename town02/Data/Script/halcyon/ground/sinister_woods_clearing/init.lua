-- D04P02 — canonical Sinister Woods final Ground and battle gateway.
-- Geometry is Data/Ground/sinister_woods_clearing.rsground.  The following
-- dungeon segment loads a pixel-exact .rsmap counterpart of this same space;
-- it is not an unrelated dedicated arena.
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.CharacterEssentials'
require 'halcyon.RedCanonScene'

local sinister_woods_clearing = {}
local SCENE = 'd04p02'
local EVENTS = {
  {t='bgm', track='In the Depths of the Pit'},
  {t='anim', id='2'},
  {t='msg', key='SCENE_D04P02_001'},
  {t='msg', key='SCENE_D04P02_002'},
  {t='msg', key='SCENE_D04P02_003'},
  {t='msg', key='SCENE_D04P02_004'},
  {t='msg', key='SCENE_D04P02_005'},
  {t='msg', key='SCENE_D04P02_006'},
  {t='msg', key='SCENE_D04P02_007'},
  {t='msg', key='SCENE_D04P02_008'},
  {t='msg', key='SCENE_D04P02_009'},
  {t='anim', id='2'}, {t='anim', id='2'}, {t='anim', id='2'},
  {t='anim', id='2'}, {t='anim', id='2'}, {t='anim', id='2'},
  {t='anim', id='2'}, {t='anim', id='2'}, {t='anim', id='2'},
}

local function ContinueToCanonicalBattle()
  GAME:CutsceneMode(false)
  if os.getenv('PMDO_SINISTER_ROUTE_VALIDATOR') ~= '1' then
    GAME:FadeOut(false, 30)
  end
  GAME:ContinueDungeon('gloomy_forest', 2, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function sinister_woods_clearing.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo('[SINISTER_ROUTE] D04P02 Init before RespawnAllies')
  COMMON.RespawnAllies(true)
  PrintInfo('[SINISTER_ROUTE] D04P02 Init after RespawnAllies')
  PartnerEssentials.InitializePartnerSpawn()
  PrintInfo('[SINISTER_ROUTE] D04P02 Init after InitializePartnerSpawn')
end

function sinister_woods_clearing.Enter(map)
  DEBUG.EnableDbgCoro()
  PrintInfo('[SINISTER_ROUTE] D04P02 Enter begin')
  local ok, err = pcall(function()
    SV.CanonicalDungeons = SV.CanonicalDungeons or {}
    if not SV.CanonicalDungeons.SinisterWoodsD04P02Seen then
      if os.getenv('PMDO_SINISTER_ROUTE_VALIDATOR') == '1' then
        RogueEssence.GameManager.Instance:SetFade(true, false)
        PrintInfo('[SINISTER_ROUTE] D04P02 visual fade-out completed headless')
      else
        GAME:FadeOut(false, 1)
      end
      local hero, partner = CH('PLAYER'), CH('Teammate1')
      GROUND:TeleportTo(hero, 208, 248, Direction.Up)
      PrintInfo('[SINISTER_ROUTE] D04P02 hero positioned')
      if partner ~= nil then GROUND:TeleportTo(partner, 280, 248, Direction.Up) end
      PrintInfo('[SINISTER_ROUTE] D04P02 partner positioned')
      if os.getenv('PMDO_SINISTER_ROUTE_VALIDATOR') ~= '1' then
        GAME:MoveCamera(240, 176, 1, false)
      else
        PrintInfo('[SINISTER_ROUTE] D04P02 camera tween skipped headless')
      end
      if os.getenv('PMDO_SINISTER_ROUTE_VALIDATOR') == '1' then
        RogueEssence.GameManager.Instance:SetFade(false, false)
        PrintInfo('[SINISTER_ROUTE] D04P02 visual fade completed headless')
      else
        GAME:FadeIn(30)
      end
      -- Dialogue/order are the extracted D04P02 sequence. Unknown animation
      -- opcodes remain no-ops instead of being replaced with invented actions.
      RedCanonScene.Play(SCENE, EVENTS)
      PrintInfo('[SINISTER_ROUTE] D04P02 canonical scene complete')
      SV.CanonicalDungeons.SinisterWoodsD04P02Seen = true
    end
    GAME:CutsceneMode(false)
    if os.getenv('PMDO_SINISTER_ROUTE_VALIDATOR') ~= '1' then
      ContinueToCanonicalBattle()
    end
  end)
  if not ok then
    PrintInfo('[sinister_woods_clearing] canonical scene error: '..tostring(err))
    pcall(function() ContinueToCanonicalBattle() end)
  end
end

function sinister_woods_clearing.Update(map) end
function sinister_woods_clearing.GameSave(map) end
function sinister_woods_clearing.GameLoad(map)
  GAME:FadeIn(20)
end

return sinister_woods_clearing
