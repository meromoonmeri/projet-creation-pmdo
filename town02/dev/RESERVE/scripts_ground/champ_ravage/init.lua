--[[ Champ Ravagé — Friend Area importee 1:1 (arene/cinematique de boss, vague 6).
     Assignation : arène Yveltal ch29 (Cocon de la Ruine) - cinématique
     Squelette : casting et cinematique a poser au cablage du chapitre. ]]
local champ_ravage = {}

function champ_ravage.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_champ_ravage")
  COMMON.RespawnAllies()
end

function champ_ravage.Enter(map)
  GAME:FadeIn(20)
end

function champ_ravage.Update(map, time)
end

return champ_ravage
