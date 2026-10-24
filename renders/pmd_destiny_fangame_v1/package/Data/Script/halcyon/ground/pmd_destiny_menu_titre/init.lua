require 'origin.common'
local pmd_destiny_menu_titre = {}
function pmd_destiny_menu_titre.Init(map) DEBUG.EnableDbgCoro() end
function pmd_destiny_menu_titre.Enter(map)
  UI:WaitShowBG('Title_Screen_Background', 12, 20)
  GAME:FadeIn(20)
end
function pmd_destiny_menu_titre.Exit(map) end
function pmd_destiny_menu_titre.Update(map) end
function pmd_destiny_menu_titre.GameSave(map) end
function pmd_destiny_menu_titre.GameLoad(map) GAME:FadeIn(20) end
return pmd_destiny_menu_titre
