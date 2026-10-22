require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.AudinoAssembly'
local sky_wigglytuff_guild_main={}
local D={
 Wigglytuff="Trente ans ont changé les équipes, pas la promesse de la Guilde : personne ne part seul quand le monde tremble.",
 Chatot="Bienvenue comme visiteurs. Les missions publiques sont ouvertes aux équipes étrangères ; le registre interne reste réservé aux membres.",
 Loudred="LES ANNONCES DU MATIN SONT À L'HEURE ! Même après trente ans, certaines traditions résistent !",
 Bidoof="Je ne suis plus le petit nouveau depuis longtemps… mais je vérifie encore deux fois chaque formulaire.",
 Chimecho="Notre réseau d'Assemblée est relié à celui d'Audino. Je peux vous aider à organiser votre équipe sans vous inscrire à cette Guilde.",
 Corphish="Hé hé ! Les rumeurs voyagent plus vite que les équipes. Metano Town parle beaucoup de vous.",
 Sunflora="Les fleurs du parvis ont survécu à trente hivers. La Guilde aussi !",
 Diglett="Je surveille toujours les passages. Les empreintes racontent beaucoup de choses.",
 Dugtrio="La terre relie Treasure Town à des régions que nos anciennes cartes ne connaissaient pas.",
 Croagunk="Mon vieux comptoir fonctionne encore. Les objets changent ; les bonnes affaires, jamais."
}
local function talk(c)
 UI:SetSpeaker(c);UI:WaitShowDialogue(D[c.EntName] or "La Guilde est ouverte aux visiteurs.")
end
function sky_wigglytuff_guild_main.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies();PartnerEssentials.InitializePartnerSpawn() end
function sky_wigglytuff_guild_main.Enter(map) GAME:FadeIn(20) end
-- Handlers explicites : le moteur et les audits peuvent résoudre chaque callback
-- sans dépendre d'une génération dynamique au chargement du module.
function sky_wigglytuff_guild_main.Wigglytuff_Action(c,a) talk(c) end
function sky_wigglytuff_guild_main.Chatot_Action(c,a) talk(c) end
function sky_wigglytuff_guild_main.Loudred_Action(c,a) talk(c) end
function sky_wigglytuff_guild_main.Bidoof_Action(c,a) talk(c) end
function sky_wigglytuff_guild_main.Corphish_Action(c,a) talk(c) end
function sky_wigglytuff_guild_main.Sunflora_Action(c,a) talk(c) end
function sky_wigglytuff_guild_main.Diglett_Action(c,a) talk(c) end
function sky_wigglytuff_guild_main.Dugtrio_Action(c,a) talk(c) end
function sky_wigglytuff_guild_main.Croagunk_Action(c,a) talk(c) end
function sky_wigglytuff_guild_main.Chimecho_Action(chara,activator)
 UI:SetSpeaker(chara);UI:ChoiceMenuYesNo("Souhaitez-vous accéder à l'Assemblée partagée ?",true);UI:WaitForChoice()
 if UI:ChoiceResult() then AudinoAssembly.Assembly(chara) else talk(chara) end
end
function sky_wigglytuff_guild_main.EntranceHall_Exit_Touch(obj,activator) GAME:EnterGroundMap('sky_wigglytuff_guild_entrance','From_MainHall_Marker') end
function sky_wigglytuff_guild_main.GuildmasterRoom_Entrance_Touch(obj,activator) UI:ResetSpeaker();UI:WaitShowDialogue("L'accès aux quartiers supérieurs est en cours de réouverture.") end
function sky_wigglytuff_guild_main.Exit(map) end function sky_wigglytuff_guild_main.Update(map,time) end
function sky_wigglytuff_guild_main.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function sky_wigglytuff_guild_main.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'));GAME:FadeIn(20) end
return sky_wigglytuff_guild_main
