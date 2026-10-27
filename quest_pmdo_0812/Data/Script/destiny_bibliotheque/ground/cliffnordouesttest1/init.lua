--[[
  cliffnordouesttest1 — script de Ground (squelette de banc d'essai).

  Carte livrée par BIBLIOTHEQUE_MAPS (copie clampée : EdgeView=Clamp,
  coordonnées bornées — voir manifest.json, entrée « cliffnordouesttest1 »).
  Composition originale de l'utilisateur (138x98 cases,
  TexSize 1).

  À câbler dans l'éditeur PMDO 0.8.12 avant tout test en jeu :
    - marqueur d'entrée (aucun marqueur « entr* » détecté par l'audit) ;
    - collisions sur la grille (vérifier mer/falaises/structures) ;
    - tilesets absents du dépôt, à fournir dans Content/Tile :
      00_ciel, INVERSEPATHWAY, Metano_Altere_Transition_Base, terrain, terrain (2), terrain (3), terrain (4), v2_promontoire_jour_03

  Les cinématiques futures vivront dans des modules _ch_N.lua de ce
  dossier, chargés ici par require explicites (règle L2), et toute
  variable SV.* sera déclarée dans ../../scriptvars.lua (règle L14).
]]

local cliffnordouesttest1 = {}

return cliffnordouesttest1
