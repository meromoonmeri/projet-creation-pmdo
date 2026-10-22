--[[
  main.lua
  
  This file is loaded persistently.
  Its main purpose is to include anything that needs to stay persistently in the lua state.
  Things like services.
]]--

-------
-- PrintInfo — LA FONCTION DE TRACE DU MOD. ELLE N'EXISTAIT PAS.
--------------------------------------------------------------------------------------------------------------
-- BUG MAJEUR, ET IL EXPLIQUE UNE LONGUE SERIE DE SYMPTOMES.
--
-- `PrintInfo` est appelee 600 fois dans 381 fichiers du mod. Elle n'etait
-- definie NULLE PART : ni dans Data/Script, ni dans le moteur
-- (aucune occurrence dans RogueEssence/Lua/*.cs), ni dans Halcyon d'origine.
--
-- En Lua, appeler une globale nil leve une erreur. Le moteur enveloppe
-- chaque callback dans un xpcall (LuaEngine.cs:895), donc le jeu ne plante
-- pas : il AVORTE SILENCIEUSEMENT la fonction en cours, a la ligne de
-- l'appel. Verifie par reproduction du patron moteur :
--     "attempt to call a nil value (global 'PrintInfo')"
--     -> les instructions suivantes ne s'executent jamais.
--
-- Consequence sur le bug de fondu signale quatre fois (« on voit toujours
-- un apercu de l'ancienne zone avant d'arriver au Mont Venteux ») :
--
--   zone/searing_tunnel/init.lua:209  ExitSegment du Creuset
--       PrintInfo("=>> ExitSegment_searing_crucible ...")   <-- MEURT ICI
--       ...
--       GeneralFunctions.EndDungeonRun(...)                 <-- JAMAIS ATTEINT
--
--   ground/searing_crucible/searing_crucible_ch_5.lua  DefeatedBoss()
--       PrintInfo("[BossSeq] ... cutscene start")           <-- MEURT ICI
--       ...
--       GAME:FadeOut(false, 1)                              <-- JAMAIS ATTEINT
--       GAME:EnterGroundMap('mount_windswept_entrance', ...) <-- JAMAIS ATTEINT
--
-- Aucun de mes correctifs de fondu ne pouvait donc agir : le code corrige
-- n'etait jamais execute. Le changement de carte se faisait par la voie de
-- repli du moteur, sans qu'aucun ecran noir n'ait ete pose — d'ou l'apercu.
--
-- PREUVE DANS LE LOG DU JOUEUR (build N) : la ligne
-- « [NREPROBE] build ... charge (main.lua) » est ABSENTE, alors que c'est
-- le premier PrintInfo du jeu. main.lua mourait sur son propre appel, et
-- math.randomseed juste apres n'etait jamais execute non plus.
--
-- On la definit donc ici, en TOUTE PREMIERE instruction du fichier
-- persistant, avant le moindre require. `print` est la fonction de sortie
-- standard du moteur : c'est elle qui produit les lignes « =>> Init_... »
-- visibles dans les logs.
function PrintInfo(msg)
  print(tostring(msg))
end
--------------------------------------------------------------------------------------------------------------
-- Service Packages
--------------------------------------------------------------------------------------------------------------
require 'halcyon.services.debug_tools'
require 'halcyon.services.menu_tools'
require 'halcyon.services.upgrade_tools'
require 'halcyon.services.config_tools'
require 'halcyon.services.nre_probe'--sonde runtime NRE IsGameOver (audit 2026-07-27, retirable)
require 'halcyon.services.ground_gameplay_validator'--opt-in: PMDO_GROUND_VALIDATOR=1 uniquement
require 'halcyon.services.mapgen_validator'--opt-in: PMDO_MAPGEN_VALIDATOR (generation moteur des 51 donjons)
require 'halcyon.SceneDebug'--armement des scenes pour test en jeu (outil de dev, sans effet sur le jeu)
require 'halcyon.RuinesZarbi'--puzzle des Zarbi des Aegis Cave (portage Aegis Cave)
require 'halcyon.DonjonFX'--mise en scene a l'interieur d'un etage de donjon (API DUNGEON:)
require 'halcyon.RuinesTitan'--Regigigas : eveil, renversement, fuite (etage-arene segment 7)
require 'halcyon.RuinesArenes'--eveil des trois scelles, joue dans leurs etages-arenes
require 'halcyon.RuinesRenforts'--renforts de la guilde + revelation de la Tour (camp)
require 'halcyon.Ch6_10Scenes'--cinematiques d'etage ch8-10 (relais/miniboss/boss)
PrintInfo('[NREPROBE] build 2026-08-04-K charge (main.lua) -- PREMIERE ligne attendue, au LANCEMENT du jeu. Si absente: la copie du mod chargee par le jeu n est PAS celle du depot.')

math.randomseed(os.time())