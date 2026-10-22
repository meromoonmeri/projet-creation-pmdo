--[[
  LivingWorld.lua — façade persistante du monde vivant New Era.

  Ce module N'EST PAS une deuxième implémentation des saisons, de la météo
  ou des raids. Il relie les systèmes validés existants :
    Seasons.lua, Weather.lua, TownNight.lua, TownRaid.lua.
  Seuls le réseau d'information et ses délais de propagation sont nouveaux.
]]
require 'origin.common'
require 'halcyon.Seasons'
require 'halcyon.Weather'

LivingWorld = {}

LivingWorld.VILLES = { metano = true, treasure = true, guild = true }
LivingWorld.METEOS = {
  pluie_legere=true, pluie=true, pluie_forte=true, orage=true,
  neige=true, blizzard=true, brouillard=true, sable=true, vent=true
}

local function jour()
  return (SV.ChapterProgression and SV.ChapterProgression.DaysPassed) or 0
end

function LivingWorld.Ensure()
  SV.WorldState = SV.WorldState or {}
  local s = SV.WorldState
  s.Information = s.Information or {}
  s.Knowledge = s.Knowledge or { metano={}, treasure={}, guild={} }
  s.Delivered = s.Delivered or {}
  s.Weather = s.Weather or { Current=nil, Since=-1, Source='natural' }
  s.ForcedTime = s.ForcedTime or ''
  s.Schema = 1
  return s
end

-- L'heure réutilise les variantes de Ground et le forçage des scènes.
function LivingWorld.Time(ground)
  local s=LivingWorld.Ensure()
  if s.ForcedTime~='' then return s.ForcedTime end
  ground=string.lower(ground or '')
  if string.find(ground,'nuit') or string.find(ground,'night') or string.find(ground,'01c') then return 'night' end
  if string.find(ground,'evening') or string.find(ground,'01b') then return 'evening' end
  return 'day'
end

function LivingWorld.Season()
  return Seasons.Actuelle().id
end

-- Persiste seulement les météos de monde. Weather.Set reste disponible
-- pour les scènes locales et ne se met donc pas soudain à persister.
function LivingWorld.SetWeather(preset, source)
  local s=LivingWorld.Ensure()
  if preset~=nil and not LivingWorld.METEOS[preset] then
    PrintInfo('[LivingWorld] météo inconnue : '..tostring(preset)); return false
  end
  s.Weather.Current=preset; s.Weather.Since=jour(); s.Weather.Source=source or 'natural'
  return Weather.Set(preset)
end

function LivingWorld.ApplyOutdoor(allowSeason)
  local s=LivingWorld.Ensure()
  if allowSeason~=false then pcall(function() Seasons.Apply() end) end
  pcall(function() Weather.Set(s.Weather.Current) end)
end

-- Publication avec provenance obligatoire. Une information sans source
-- n'entre pas dans le réseau : elle ne peut pas devenir omnisciente.
function LivingWorld.Publish(id, source, text, destinations, delay)
  if type(id)~='string' or id=='' or type(source)~='string' or source=='' then return false end
  local s=LivingWorld.Ensure()
  if s.Information[id]~=nil then return false end
  local info={ Id=id, Source=source, Text=text or '', Created=jour(), Destinations={}, Delivered={} }
  for _,city in ipairs(destinations or {'guild','treasure','metano'}) do
    if LivingWorld.VILLES[city] then info.Destinations[city]=jour()+(delay or 0) end
  end
  s.Information[id]=info
  return true
end

function LivingWorld.Tick()
  local s=LivingWorld.Ensure(); local now=jour(); local newly={}
  for id,info in pairs(s.Information) do
    info.Delivered=info.Delivered or {}
    for city,due in pairs(info.Destinations or {}) do
      if now>=due and not info.Delivered[city] then
        info.Delivered[city]=true
        s.Knowledge[city]=s.Knowledge[city] or {}
        s.Knowledge[city][id]={ Day=now, Source=info.Source }
        table.insert(newly,{Id=id,City=city,Source=info.Source,Text=info.Text})
      end
    end
  end
  return newly
end

function LivingWorld.Knows(city,id)
  local s=LivingWorld.Ensure(); LivingWorld.Tick()
  return s.Knowledge[city]~=nil and s.Knowledge[city][id]~=nil
end

function LivingWorld.Context(city,ground)
  local s=LivingWorld.Ensure(); LivingWorld.Tick()
  return {
    City=city, Ground=ground or '', Day=jour(), Time=LivingWorld.Time(ground),
    Season=LivingWorld.Season(), Weather=s.Weather.Current,
    Raid=SV.TownRaid or {}, Knowledge=s.Knowledge[city] or {}
  }
end

-- Synchronise les événements déjà réels du scénario ; aucune rumeur
-- synthétique n'est créée. Les délais représentent le trajet du courrier.
function LivingWorld.SyncStory()
  local ch=(SV.ChapterProgression and SV.ChapterProgression.Chapter) or 1
  if ch>=7 then LivingWorld.Publish('cloven_quake','guild_report','Des secousses ont été signalées près des Ruines Fendues.',{'guild','treasure','metano'},1) end
  if ch>=8 then LivingWorld.Publish('crystal_sanctuary','explorer_report','Un sanctuaire cristallin a été confirmé.',{'guild','treasure','metano'},1) end
  if ch>=10 then LivingWorld.Publish('celestial_disturbance','pelipper_dispatch','Des perturbations ont été observées dans les hauteurs.',{'guild','treasure','metano'},0) end
  local raid=SV.TownRaid or {}
  if (raid.Repelled or 0)>0 then LivingWorld.Publish('metano_raid_repelled_'..tostring(raid.Repelled),'pelipper_dispatch','La garde de Metano a repoussé une attaque nocturne.',{'metano','guild','treasure'},1) end
  return LivingWorld.Tick()
end

return LivingWorld
