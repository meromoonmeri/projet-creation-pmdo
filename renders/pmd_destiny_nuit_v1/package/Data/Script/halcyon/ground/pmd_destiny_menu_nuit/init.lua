require 'origin.common'
local pmd_destiny_menu_nuit = {}
function pmd_destiny_menu_nuit.Init(map) DEBUG.EnableDbgCoro() end
function pmd_destiny_menu_nuit.Enter(map)
  UI:WaitShowBG('Title_Screen_Background_Nuit', 10, 20)
  GAME:FadeIn(20)
end
function pmd_destiny_menu_nuit.Exit(map) end
function pmd_destiny_menu_nuit.Update(map) end
function pmd_destiny_menu_nuit.GameSave(map) end
function pmd_destiny_menu_nuit.GameLoad(map) GAME:FadeIn(20) end
return pmd_destiny_menu_nuit
