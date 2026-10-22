-- Canonical Explorers of Sky locations, thirty years after the original story.
-- A legendary may only be encountered in the dungeon listed here.
local S={}
S.Dungeons={
 aegis_cave={zone='cloven_ruins',legendary={'regice','regirock','registeel','regigigas'},era='restored',chapter=5},
 temporal_tower={zone='temporal_tower',legendary={'dialga'},era='restored',corrupted=false},
 spacial_rift={zone='spacial_rift',legendary={'palkia'},era='stable'},
 world_abyss={zone='world_abyss',legendary={'giratina'},era='stable'},
 dark_crater={zone='dark_crater',legendary={'darkrai'},era='postgame'},
 sky_peak={zone='sky_peak',legendary={'shaymin'},era='restored'},
 sky_stairway={zone='sky_stairway',legendary={'rayquaza'},era='stable'},
 bottomless_sea={zone='bottomless_sea',legendary={'kyogre'},era='stable'},
 shimmer_desert={zone='shimmer_desert',legendary={'groudon'},era='stable'},
 giant_volcano={zone='giant_volcano',legendary={'heatran'},era='stable'},
 mystery_jungle={zone='mystery_jungle',legendary={'mew'},era='protected'},
 destiny_tower={zone='destiny_tower',legendary={'arceus'},era='postgame'},
 mt_avalanche={zone='mt_avalanche',legendary={'articuno'},era='stable'},
 mt_mistral={zone='mt_mistral',legendary={'ho_oh'},era='stable'},
 marine_resort={zone='marine_resort',legendary={'manaphy'},era='restored'},
 concealed_ruins={zone='concealed_ruins',legendary={},era='restored'},
 zero_isle={zone='zero_isle',legendary={},era='postgame'},
 mystifying_forest={zone='mystifying_forest',legendary={},era='restored'},
 hidden_land={zone='hidden_land',legendary={},era='restored'},
 temporal_spire={zone='temporal_tower',legendary={'dialga'},era='restored',subzone=true},
}
function S.Ensure()
 SV.SkyCanon=SV.SkyCanon or {Unlocked={},Cleared={},Bosses={},Scenes={},Restored={}}
end
function S.LocationFor(species)
 for id,d in pairs(S.Dungeons) do for _,s in ipairs(d.legendary) do if s==species then return id,d.zone end end end
 return nil,nil
end
function S.CanEncounter(species,zone)
 local _,canonical=S.LocationFor(species);return canonical~=nil and canonical==zone
end
return S
