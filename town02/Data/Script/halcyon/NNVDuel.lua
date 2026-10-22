--[[
    NNVDuel.lua — duel sauvage émergent, dans le lieu exact du Ground
    ==================================================================

    QUAND CE MODULE EST APPELÉ
    ------------------------------------------------------------------
    Uniquement par NNVEcology.MaybeDuel(), quand DEUX conditions rares se
    rencontrent :
      - deux individus territoriaux d'espèces autorisées (E.DUEL_PAIRS)
        entrent en posture de confrontation ;
      - le cooldown de duel de la room est écoulé (2 minutes de jeu).
    Le joueur ne déclenche rien. Il peut ne jamais en voir.

    POURQUOI UNE .rsmap ET PAS UN COMBAT SUR PLACE
    ------------------------------------------------------------------
    GroundChar n'a pas de HP et la couche Ground n'a ni faction ni tour
    (RogueEssence 0.8.12, vérifié). Aucun combat n'est possible sur un
    Ground. Le patron moteur validé — et déjà utilisé deux fois dans ce
    dépôt (duel Team Dazzling, pillards de Metano) — est :

        Ground -> cinématique -> ContinueDungeon -> .rsmap -> retour

    L'EMPRISE VISUELLE
    ------------------------------------------------------------------
    La .rsmap n'est pas une arène générique : c'est une fenêtre de
    26x14 tuiles de 24 px (624x336 px) DÉCOUPÉE PIXEL À PIXEL dans le rendu
    du Ground, centrée sur le lieu de l'affrontement. Le ViewRect du moteur
    est en pixels et identique en Ground et en donjon
    (BaseGroundScene.cs l.155 / BaseDungeonScene.cs l.167), donc le joueur
    voit strictement le même décor, plein écran, sans bord ni bande noire.
    Preuve : reports/fauna-ecology/duel-maps/*_proof.json
    -> pixel_identical = true, differing_pixels = 0 sur 6 biomes.

    Couvrir les 4992x4992 px du Ground coûterait ~139 Mo par duel pour des
    pixels que le joueur ne peut pas voir : voir DUEL_EMPRISE_ECRAN.md.
]]
require 'origin.common'

NNVDuel = {}
local D = NNVDuel

-- Zone hôte des duels sauvages. Les segments sont IsRelevant = false : ils
-- ne comptent dans aucune progression, aucun drapeau d'histoire.
D.ZONE = 'nnv_wild'

-- room -> index de segment portant la .rsmap du lieu.
-- Rempli par l'installateur ; un lieu sans entrée ici ne peut pas duel.
D.SEGMENTS = {
  rm35 = 0,  -- nnv_duel_rm35_summer
  rm59 = 1,  -- nnv_duel_rm59_summer
  rm82 = 2,  -- nnv_duel_rm82_summer
  rm83 = 3,  -- nnv_duel_rm83_summer
  rm84 = 4,  -- nnv_duel_rm84_summer
  rmvillage = 5,  -- nnv_duel_rmvillage_summer
}

D.active = false

local function say(text)
  pcall(function()
    UI:ResetSpeaker()
    UI:WaitShowDialogue(text)
  end)
end

-- ----------------------------------------------------------------------
-- Le duel est-il possible ici et maintenant ?
-- ----------------------------------------------------------------------
function D.CanDuel(room)
  if D.active then return false end
  if not D.SEGMENTS[room] then return false end
  return true
end

-- ----------------------------------------------------------------------
-- Déclenchement. a et b sont deux entrées du roster de NNVEcology.
-- Retourne true si le duel a réellement été lancé.
-- ----------------------------------------------------------------------
function D.Trigger(room, a, b)
  if not D.CanDuel(room) then return false end

  local seg = D.SEGMENTS[room]
  if not seg then return false end

  D.active = true
  local ok = pcall(function()
    -- Le joueur n'est PAS un participant : il assiste. On le laisse où il
    -- est, on cadre simplement la scène.
    local ca = CH(a.name)
    if ca then
      GAME:FadeOut(false, 20)
      GAME:MoveCamera(ca.Position.X, ca.Position.Y, 30, false)
    end
    say("Deux Pokémon sauvages se disputent le terrain.")
    -- Bascule vers la fenêtre du lieu, retuilée en 24 px.
    GAME:ContinueDungeon(D.ZONE, seg, 0, 0)
  end)

  if not ok then
    D.active = false
    return false
  end
  return true
end

-- ----------------------------------------------------------------------
-- Retour au Ground après le duel. Appelé par le script de fin de segment.
-- Le monde doit reprendre exactement comme avant.
-- ----------------------------------------------------------------------
function D.Finish(room, marker)
  D.active = false
  pcall(function()
    GAME:EnterGroundMap(room, marker or 'Main_Entrance_Marker', true)
  end)
  -- NNVEcology reprend sa boucle au prochain Update du Ground : rien à
  -- réinitialiser, les colonies sont reconstruites depuis le Ground.
  return true
end

return NNVDuel
