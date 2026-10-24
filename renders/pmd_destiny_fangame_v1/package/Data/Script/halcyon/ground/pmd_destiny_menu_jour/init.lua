require 'origin.common'
local pmd_destiny_menu_jour = {}
function pmd_destiny_menu_jour.Init(map) DEBUG.EnableDbgCoro() end
function pmd_destiny_menu_jour.Enter(map)
  UI:WaitShowBG('Title_Screen_Background_Jour', 10, 20)
  GAME:FadeIn(20)
end
function pmd_destiny_menu_jour.Exit(map) end
function pmd_destiny_menu_jour.Update(map) end
function pmd_destiny_menu_jour.GameSave(map) end
function pmd_destiny_menu_jour.GameLoad(map) GAME:FadeIn(20) end
return pmd_destiny_menu_jour
