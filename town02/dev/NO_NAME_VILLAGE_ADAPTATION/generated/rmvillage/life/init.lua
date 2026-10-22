require 'origin.common'
local Life=require 'halcyon.NNVLife'
local M={}
function M.Init(map) Life.Setup() end
function M.Enter(map) Life.Setup() end
function M.Update(map) Life.Update() end
function M.Exit(map) end
function M.GameSave(map) end
function M.GameLoad(map) Life.Setup() end
function M.NNV_Carpenter_Action(chara,activator) return Life.Talk('NNV_Carpenter') end
function M.NNV_Logger_Action(chara,activator) return Life.Talk('NNV_Logger') end
function M.NNV_Hunter_Action(chara,activator) return Life.Talk('NNV_Hunter') end
function M.NNV_Herbalist_Action(chara,activator) return Life.Talk('NNV_Herbalist') end
function M.NNV_Seamstress_Action(chara,activator) return Life.Talk('NNV_Seamstress') end
for _,group in pairs(Life.GROUPS) do
 for _,name in ipairs(group.names) do local entity_name=name;M[entity_name..'_Action']=function(chara,activator)return Life.WildTalk(entity_name) end end
end
return M
