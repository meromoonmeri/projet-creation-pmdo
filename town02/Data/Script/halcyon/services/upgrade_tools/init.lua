--[[
    Example Service
    
    This is an example to demonstrate how to use the BaseService class to implement a game service.
    
    **NOTE:** After declaring you service, you have to include your package inside the main.lua file!
]]--
require 'origin.common'
require 'origin.services.baseservice'

--Declare class UpgradeTools
local UpgradeTools = Class('UpgradeTools', BaseService)


--[[---------------------------------------------------------------
    UpgradeTools:initialize()
      UpgradeTools class constructor
---------------------------------------------------------------]]
function UpgradeTools:initialize()
  BaseService.initialize(self)
  PrintInfo('UpgradeTools:initialize()')
end

--[[---------------------------------------------------------------
    UpgradeTools:__gc()
      UpgradeTools class gc method
      Essentially called when the garbage collector collects the service.
	  TODO: Currently causes issues.  debug later.
  ---------------------------------------------------------------]]
--function UpgradeTools:__gc()
--  PrintInfo('*****************UpgradeTools:__gc()')
--end

--[[---------------------------------------------------------------
    UpgradeTools:OnUpgrade()
      When a save file in an old version is loaded this is called!
---------------------------------------------------------------]]
function UpgradeTools:OnUpgrade()
  --RATTRAPAGE DES VARIABLES NEUVES SUR UNE SAUVEGARDE ANCIENNE.
  --Une table SV creee par une version anterieure ne contient pas les
  --champs ajoutes depuis. Lire un champ absent rend nil, et un test
  --`if SV.Chapter5.CampNightWatchDone` sur nil est certes faux — mais
  --l'ECRIRE dans une table Chapter5 elle-meme absente leverait une
  --erreur. Tout est donc sous pcall, et on ne touche qu'aux champs
  --reellement manquants (on n'ecrase jamais une progression existante).
  pcall(function()
    if SV.Chapter5 == nil then return end
    --Le reve du Mont Venteux, joue sur sa carte dediee hero_dream.
    if SV.Chapter5.CampNightWatchDone == nil then
      SV.Chapter5.CampNightWatchDone = false
    end
    if SV.Chapter5.DreamSceneSeen == nil then
      SV.Chapter5.DreamSceneSeen = false
    end
  end)
end

---Summary
-- Subscribe to all channels this service wants callbacks from
function UpgradeTools:Subscribe(med)
  med:Subscribe("UpgradeTools", EngineServiceEvents.UpgradeSave,        function() self.OnUpgrade(self) end )
end

---Summary
-- un-subscribe to all channels this service subscribed to
function UpgradeTools:UnSubscribe(med)
end

--Add our service
SCRIPT:AddService("UpgradeTools", UpgradeTools:new())
return UpgradeTools