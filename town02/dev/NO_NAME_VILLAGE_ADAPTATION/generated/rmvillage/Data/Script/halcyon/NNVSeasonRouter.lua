-- Candidate NNV seasonal router. Dormant until the four-Ground runtime flow passes.
require 'origin.common'
require 'halcyon.Seasons'
local Router = {}
Router.ASSETS = {
  printemps = 'nnv_rmvillage_spring',
  ete = 'nnv_rmvillage_summer',
  automne = 'nnv_rmvillage_autumn',
  hiver = 'nnv_rmvillage_winter',
}
function Router.ResolveId(id)
  local asset = Router.ASSETS[id]
  if asset == nil then error('unsupported canonical NNV season: '..tostring(id)) end
  return asset
end
function Router.ResolveCurrent()
  local season = Seasons.Actuelle()
  if season == nil or season.id == nil then error('New Era season state unavailable') end
  return Router.ResolveId(season.id)
end
function Router.Enter(marker)
  local asset = Router.ResolveCurrent()
  GAME:EnterGroundMap(asset, marker or 'Entry_South')
  return asset
end
return Router
