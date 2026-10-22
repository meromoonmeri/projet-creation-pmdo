-- Canonical Rescue Team campaign adapted to New Era's chronology.
-- Canonical dungeon data remains authoritative; New Era additions are overlays.
local Campaign = {}

Campaign.ExistingStory = {
  {chapter=6,  id='sinister_woods', zones={'gloomy_forest'}},
  {chapter=7,  id='magma_cavern', zones={'magma_cavern'}},
  {chapter=8,  id='crystal_sanctuary', zones={'waterfall_pond'}},
  {chapter=10, id='sky_tower_legacy', zones={'sky_tower'}},
}

-- Opened after the existing New Era narrative.  Entries sharing a quest wave
-- are parallel, avoiding a fictitious linear order between Red postgame arcs.
Campaign.PostgameWaves = {
  {id='sea_guardian', requires='chapter_11_complete', dungeons={'stormy_sea','silver_trench'}},
  {id='buried_legacy', requires='sea_guardian', dungeons={'buried_relic','solar_cave'}},
  {id='southern_skies', requires='buried_legacy', dungeons={'northern_range','pitfall_valley'}},
  {id='legendary_beasts', requires='buried_legacy', dungeons={'fiery_field','lightning_field','northwind_field','mt_faraway'}},
  {id='western_shadow', requires='southern_skies', dungeons={'western_cave','meteor_cave'}},
  {id='wish_and_purity', requires='buried_legacy', dungeons={'wish_cave','joyous_tower','purity_forest'}},
  {id='ocean_routes', requires='sea_guardian', dungeons={'grand_sea','faroff_sea','wondrous_sea','marvelous_sea','fantasy_strait'}},
  {id='guild_requests', requires='chapter_11_complete', dungeons={'uproar_forest','howling_forest','murky_cave','waterfall_pond','unown_relic','darknight_relic'}},
  {id='survey_routes', requires='chapter_11_complete', dungeons={'desert_region','southern_cavern','wyvern_hill','oddity_cave','remains_island'}},
}

-- Main-story locations already adapted in chapters 6–10 remain replayable as
-- thirty-years-later locations. This registry never rewrites their chronology.
Campaign.LegacyLocations = {
 'tiny_woods','thunderwave_cave','mt_steel','sinister_woods','silent_chasm',
 'mt_thunder','great_canyon','lapis_cave','mt_blaze','frosty_forest','mt_freeze',
 'magma_cavern','sky_tower','rock_path','snow_path'
}

function Campaign.EnsureState()
  SV.PostgameRed = SV.PostgameRed or {Unlocked=false, Waves={}, Cleared={}, Bosses={}, Seen={}}
end
function Campaign.UnlockAfterChapter11()
  Campaign.EnsureState()
  SV.PostgameRed.Unlocked = true
  SV.PostgameRed.Waves.chapter_11_complete = true
end
function Campaign.IsWaveOpen(id)
  Campaign.EnsureState()
  if id == 'chapter_11_complete' then return SV.PostgameRed.Unlocked end
  return SV.PostgameRed.Waves[id] == true
end
function Campaign.CompleteWave(id)
  Campaign.EnsureState(); SV.PostgameRed.Waves[id] = true
end
return Campaign
