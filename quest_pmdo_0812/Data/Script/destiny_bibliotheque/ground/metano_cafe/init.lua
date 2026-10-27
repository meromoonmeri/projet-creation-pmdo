--[[
  metano_cafe — script de Ground (squelette de banc d'essai).

  Composition : Halcyon (Palika), réemploi avec accord de l'auteur
  (confirmé le 2026-10-27 — voir BIBLIOTHEQUE_MAPS/CREDITS.md).
  Copie clampée livrée par la bibliothèque (57x40 cases,
  TexSize 1, EdgeView=Clamp — voir manifest.json).

  Tilesets : art du pool PMDO (filiation PMD Sky). La bibliothèque ne
  redistribue pas ces pixels : fournir les .tile depuis l'installation
  PMDO locale dans Content/Tile, puis reconstruire l'index.
  Sheets peintes par cette carte : Metano_Town_Cafe_Base, Metano_Town_Cafe_Objects, Metano_Town_Cafe_Objects_Fringe, Metano_Town_Cafe_Objects_Over, Metano_Town_Cafe_Objects_Under

  Adaptation Destiny à venir : nom français, chaînes via strings.fr.resx,
  PNJ/marqueurs replacés, collisions et entrées revérifiées en éditeur.
  Cinématiques futures : modules _ch_N.lua chargés par require ici (L2),
  toute SV.* déclarée dans ../../scriptvars.lua (L14).
]]

local metano_cafe = {}

return metano_cafe
