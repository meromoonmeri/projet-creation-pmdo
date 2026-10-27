--[[
  guild_second_floor — script de Ground (squelette de banc d'essai).

  Composition : Halcyon (Palika), réemploi avec accord de l'auteur
  (confirmé le 2026-10-27 — voir BIBLIOTHEQUE_MAPS/CREDITS.md).
  Copie clampée livrée par la bibliothèque (84x56 cases,
  TexSize 1, EdgeView=Clamp — voir manifest.json).

  Tilesets : art du pool PMDO (filiation PMD Sky). La bibliothèque ne
  redistribue pas ces pixels : fournir les .tile depuis l'installation
  PMDO locale dans Content/Tile, puis reconstruire l'index.
  Sheets peintes par cette carte : Guild_Second_Floor_Floor, Guild_Second_Floor_Fringe, Guild_Second_Floor_Objects, Guild_Second_Floor_Objects_Over, Guild_Second_Floor_Objects_Under, Guild_Second_Floor_Shadows, Guild_Second_Floor_Supports, Guild_Second_Floor_Walls

  Adaptation Destiny à venir : nom français, chaînes via strings.fr.resx,
  PNJ/marqueurs replacés, collisions et entrées revérifiées en éditeur.
  Cinématiques futures : modules _ch_N.lua chargés par require ici (L2),
  toute SV.* déclarée dans ../../scriptvars.lua (L14).
]]

local guild_second_floor = {}

return guild_second_floor
