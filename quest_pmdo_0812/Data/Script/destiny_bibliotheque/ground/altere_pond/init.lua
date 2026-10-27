--[[
  altere_pond — script de Ground (squelette de banc d'essai).

  Composition : Halcyon (Palika), réemploi avec accord de l'auteur
  (confirmé le 2026-10-27 — voir BIBLIOTHEQUE_MAPS/CREDITS.md).
  Copie clampée livrée par la bibliothèque (116x96 cases,
  TexSize 1, EdgeView=Clamp — voir manifest.json).

  Tilesets : art du pool PMDO (filiation PMD Sky). La bibliothèque ne
  redistribue pas ces pixels : fournir les .tile depuis l'installation
  PMDO locale dans Content/Tile, puis reconstruire l'index.
  Sheets peintes par cette carte : Altere_Pond_Base, Altere_Pond_Cliffs, Altere_Pond_Fringe, Altere_Pond_Objects, Altere_Pond_Objects_Over, Altere_Pond_Objects_Under, Altere_Pond_River_Animations, Altere_Pond_Shadows, Metano_Town_Animation_Tileset

  Adaptation Destiny à venir : nom français, chaînes via strings.fr.resx,
  PNJ/marqueurs replacés, collisions et entrées revérifiées en éditeur.
  Cinématiques futures : modules _ch_N.lua chargés par require ici (L2),
  toute SV.* déclarée dans ../../scriptvars.lua (L14).
]]

local altere_pond = {}

return altere_pond
