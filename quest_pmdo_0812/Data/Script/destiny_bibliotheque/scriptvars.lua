--[[
  scriptvars.lua — valeurs par défaut des variables de sauvegarde (SV)
  de la quest-bibliothèque PMDO 0.8.12.

  Règle du projet (L14) : toute variable SV.* utilisée par un script de
  carte ou de zone est déclarée ICI, avec sa valeur initiale. Ce fichier
  n'est lu qu'à la création d'une sauvegarde : modifier un défaut ne
  change pas les parties déjà commencées.

  Namespace du mod : destiny_bibliotheque (cf. Mod.xml — ne jamais changer
  Namespace/UUID après publication).
]]

SV = {}

-- Suivi du banc d'essai : cartes déjà visitées/valides en jeu.
-- Exemple d'usage futur : SV.Bibliotheque.CartesValidees["cliffdaytest"] = true
SV.Bibliotheque = {
  CartesValidees = {},
}
