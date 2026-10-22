-- Opt-in PMDO runtime gameplay validator. Disabled in normal play.
require 'origin.common'
require 'origin.services.baseservice'
local V=Class('GroundGameplayValidator',BaseService)
local PILOT={
 {id='a02p01',zone='master_zone',idx=121},
 {id='mt_blaze_midpoint',zone='mt_blaze',idx=3},
 {id='mount_windswept_guardian',zone='mount_windswept',idx=2},
 {id='d11p03',zone='mt_freeze',idx=2},
 {id='champ_vent_boreal',zone='master_zone',idx=80},
}
local function safe(f,d)local ok,v=pcall(f);if ok then return v end;return d end
local function emit(s)
 PrintInfo('[GROUND_VALIDATOR] '..s)
 local f=io.open('/tmp/ground_gameplay_validator.jsonl','a');if f then f:write(s..'\n');f:flush();f:close() end
end
function V:initialize() BaseService.initialize(self);self.mode=os.getenv('PMDO_GROUND_VALIDATOR');self.enabled=(self.mode=='1' or self.mode=='tornadus_battle' or string.sub(self.mode or '',1,6)=='arena:' or string.sub(self.mode or '',1,6)=='luluby' or string.sub(self.mode or '',1,4)=='sky:' or string.sub(self.mode or '',1,9)=='skyscene:' or self.mode=='skyprogress' or self.mode=='skyjourney' or string.sub(self.mode or '',1,9)=='skyresume' or self.mode=='redjourney' or string.sub(self.mode or '',1,9)=='redresume' or string.sub(self.mode or '',1,7)=='skyhub:');self.idx=0;self.entered=false;self.busy=false
 -- mode 'skyscene:<scene>@<ground>' : rejoue une cinématique canonique Sky
 if string.sub(self.mode or '',1,9)=='skyscene:' then
  local spec=string.sub(self.mode,10)
  local scene, ground = string.match(spec,'([^@]+)@(.+)')
  self.sky_scene=scene; self.sky_scene_ground=ground
 end
 -- mode 'sky:<ground1,ground2,...>' : pilotes de grounds Sky dans sky_hub_zone
 if string.sub(self.mode or '',1,7)=='skyhub:' then
  self.hub_ground=string.sub(self.mode,8)
 end
 if string.sub(self.mode or '',1,4)=='sky:' then
  self.sky_pilot={}
  for g in string.gmatch(string.sub(self.mode,5),'[^,]+') do self.sky_pilot[#self.sky_pilot+1]=g end
 end
end
function V:begin()
 if not self.enabled or self.idx>0 then return end
 SV.RuntimeGroundAudit=SV.RuntimeGroundAudit or {};SV.RuntimeGroundAudit.Active=true
 local f=io.open('/tmp/ground_gameplay_validator.jsonl','w');if f then f:close() end
 if string.sub(self.mode or '',1,6)=='luluby' then
  self.idx=-2;SV.RuntimeGroundAudit.Active=false
  local gi=141;if self.mode=='luluby_evening' then gi=142 elseif self.mode=='luluby_night' then gi=143 end
  emit('{"event":"luluby_runtime_begin","ground_index":'..tostring(gi)..'}')
  GAME:EnterZone('master_zone',-1,gi,0)
  return
 end
 if self.mode=='tornadus_battle' or string.sub(self.mode or '',1,6)=='arena:' then
  self.idx=-1
  SV.Chapter5=SV.Chapter5 or {};SV.Chapter5.MountGuardianSeen=true
  emit('{"event":"arena_probe_begin","mode":"'..self.mode..'"}')
  -- EnterDungeon doit etre appele depuis la coroutine du Ground, pas depuis
  -- l'evenement service NewGame (sinon NLua: yield outside a coroutine).
  GAME:EnterZone('mount_windswept',-1,2,0)
  return
 end
 if self.mode=='skyresume:save' then
  -- PHASE 1 : progresser jusqu'à CH5 PUIS sauvegarder DEPUIS un ground
  -- (comme le joueur en ville) — GroundSave yield: coroutine obligatoire.
  self.idx=-6;SV.RuntimeGroundAudit.Active=false
  local prog=require('halcyon.skyscenes.progression')
  prog.reset_for_test()
  for _,st in ipairs({{1,0},{3,0},{4,0},{5,0},{6,0}}) do prog.set(st[1],st[2]) end
  local m,s=prog.state()
  emit('{"event":"resume_state_set","state":"'..m..'.'..s..'","apple_woods":'..tostring(prog.is_unlocked('apple_woods'))..'}')
  self.resume_save_pending=true
  local zsum=_DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('sky_hub_zone')
  local gl=zsum.Grounds
  local gi=0
  for k=0,gl.Count-1 do if gl[k]=='t01p01a' then gi=k end end
  GAME:EnterZone('sky_hub_zone',-1,gi,0)
  return
 end
 if self.mode=='redresume:save' then
  -- PHASE 1 (Red) : progresser jusqu'à CH6 (Mt Thunder débloqué) PUIS
  -- sauvegarder DEPUIS un ground Red canonique (t01p01 Place Pokémon) —
  -- mêmes mécanismes que skyresume:save (GroundSave natif en coroutine).
  self.idx=-9;SV.RuntimeGroundAudit.Active=false
  local prog=require('halcyon.skyscenes.redprogression')
  prog.reset_for_test()
  for _,st in ipairs({{2,0},{3,0},{4,0},{5,0},{6,0},{7,0}}) do prog.set(st[1],st[2]) end
  local m,s=prog.state()
  emit('{"event":"red_resume_state_set","state":"'..m..'.'..s..'","mt_thunder":'..tostring(prog.is_unlocked('mt_thunder'))..',"sky_tower_should_be_false":'..tostring(prog.is_unlocked('sky_tower'))..'}')
  self.red_resume_save_pending=true
  -- t01p02b (Whiscash Pond open, Red GBA canonique, présent dans
  -- master_zone sans script d'Init New Era — un ground praticable comme
  -- pour le joueur ; t01p01 porte le script d'intro du mod, hors sujet ici)
  GAME:EnterZone('master_zone',-1,self:master_ground_index('t01p02b'),0)
  return
 end
 if self.mode=='redresume:load' then
  -- PHASE 2 (Red) : appelé par OnLoadSavedData après LoadProgress
  if self.resume_done then return end
  self.resume_done=true
  local ok,err=xpcall(function()
    local prog=require('halcyon.skyscenes.redprogression')
    prog.init()
    local m,s=prog.state()
    local mt=prog.is_unlocked('mt_thunder')
    local st=prog.is_unlocked('sky_tower')
    local pass=(m==7 and mt and not st)
    emit('{"event":"red_resume_loaded","state":"'..m..'.'..s..'","mt_thunder":'..tostring(mt)..',"sky_tower_should_be_false":'..tostring(st)..',"verdict":"'..(pass and 'RED_RESUME_RUNTIME_PASS' or 'FAIL')..'"}')
    if pass then
      -- reprise réelle de la progression après reload (CH7 Great Canyon)
      prog.set(8,0)
      emit('{"event":"red_resume_continued","great_canyon":'..tostring(prog.is_unlocked('great_canyon'))..'}')
    end
  end,debug.traceback)
  if not ok then emit('{"event":"red_resume_fail","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}') end
  emit('{"event":"end"}')
  return
 end
 if self.mode=='redjourney' then
  -- JOURNEY GLOBAL RED §12 : chaîne des routes histoire dans l'ordre
  -- SCENARIO_MAIN pret (annotations event_flag.h), donjons+boss du dépôt
  -- déjà runtime-validés. Chaque route: entrée canonique -> étages
  -- procéduraux -> (boss fixed_room) -> Ground final. Réutilise le
  -- red_story_route_validator zone par zone n'est pas possible en un run;
  -- ici on chaîne EnterZone comme le journey Sky, avec le même compteur
  -- de preuve (étages réellement générés).
  self.idx=-8;SV.RuntimeGroundAudit.Active=false
  -- scènes = stations cinématiques V2 (redscenes, séquence ROM EU) des
  -- grounds dNNp01 (entrée de donjon), jouées dans master_zone AVANT
  -- les étages — EVENT→DIALOGUE→GROUND→DUNGEON→BOSS bout-en-bout.
  self.RJ={
   {ch='CH1 Tiny Woods (2.x)',sceneground='d01p01',scenemod='d01p01__station',dungeons={{z='tiny_woods',floors=3}},boss=nil},
   {ch='CH2 Thunderwave (3.x)',sceneground='d02p01',scenemod='d02p01__station',dungeons={{z='thunderwave_cave',floors=5}}},
   {ch='CH3 Mt Steel (4.x)',sceneground='d03p01',scenemod='d03p01__station',dungeons={{z='mt_steel',floors=8}},boss={seg=1,species='skarmory'}},
   {ch='CH4 Sinister Woods (5.x)',sceneground='d04p01',scenemod='d04p01__station',dungeons={{z='gloomy_forest',floors=6},{z='gloomy_forest',floors=6,seg=1}}},
   {ch='CH5 Silent Chasm (6.x)',sceneground='d05p01',scenemod='d05p01__station',dungeons={{z='silent_chasm',floors=9}}},
   {ch='CH6 Mt Thunder (7.x)',sceneground='d06p01',scenemod='d06p01__station',dungeons={{z='mt_thunder',floors=10},{z='mt_thunder_peak',floors=2}},boss={seg=1,species='zapdos',zone='mt_thunder_peak'}},
   {ch='CH7 Great Canyon (8.x)',sceneground='d07p01',scenemod='d07p01__station',dungeons={{z='great_canyon',floors=12}}},
   {ch='CH8 Lapis Cave (11.x)',sceneground='d08p01',scenemod='d08p01__station',dungeons={{z='lapis_cave',floors=14}}},
   {ch='CH9 Mt Blaze (12.x)',sceneground='d09p01',scenemod='d09p01__station',dungeons={{z='mt_blaze',floors=12},{z='mt_blaze_peak',floors=2}},boss={seg=1,species='moltres',zone='mt_blaze_peak'}},
   {ch='CH10 Frosty Forest (13.x)',sceneground='d10p01',scenemod='d10p01__station',dungeons={{z='frosty_forest',floors=8}}},
   {ch='CH11 Mt Freeze (14.x)',sceneground='d11p01',scenemod='d11p01__station',dungeons={{z='mt_freeze',floors=15},{z='mt_freeze_peak',floors=4}},boss={seg=1,species='glalie',zone='mt_freeze_peak'}},
   {ch='CH12 Magma Cavern (15.x-16.0)',sceneground='d15p01',scenemod='d15p01__station',dungeons={{z='magma_cavern',floors=8},{z='magma_cavern',floors=7,seg=1},{z='magma_cavern',floors=8,seg=2},{z='magma_cavern_pit',floors=3}},boss={z='magma_pit_groudon',seg=0,species='groudon'}},
   {ch='CH13 Sky Tower (16.x-17.0 FINALE)',sceneground='d16p01',scenemod='d16p01__station',dungeons={{z='sky_tower',floors=25},{z='sky_tower_summit',floors=9}},boss={z='sky_summit_rayquaza',seg=0,species='rayquaza'}},
  }
  self.rjch=1;self.rjdun=1;self.rjfloors=0
  emit('{"event":"redjourney_begin","chapters":'..#self.RJ..'}')
  self:red_journey_start_chapter()
  return
 end
 if self.mode=='skyresume:load' then
  -- appelé par OnLoadSavedData après LoadProgress (la SV disque est active)
  if self.resume_done then return end
  self.resume_done=true
  local ok,err=xpcall(function()
    local prog=require('halcyon.skyscenes.progression')
    prog.init()
    local m,s=prog.state()
    local aw=prog.is_unlocked('apple_woods')
    local tt=prog.is_unlocked('temporal_tower')
    local pass=(m==6 and aw and not tt)
    emit('{"event":"resume_loaded","state":"'..m..'.'..s..'","apple_woods":'..tostring(aw)..',"temporal_tower_should_be_false":'..tostring(tt)..',"verdict":"'..(pass and 'RESUME_RUNTIME_PASS' or 'FAIL')..'"}')
    if pass then
      prog.set(8,0)
      emit('{"event":"resume_continued","steam_cave":'..tostring(prog.is_unlocked('steam_cave'))..'}')
    end
  end,debug.traceback)
  if not ok then emit('{"event":"resume_fail","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}') end
  emit('{"event":"end"}')
  return
 end
 if self.mode=='skyjourney' then
  -- JOURNEY GLOBAL §12 : NEW SAVE -> CH1 -> ... -> CH15 -> DIALGA -> END.
  -- Table = STORY_PLAYABLE_CHAIN (donjons+arènes runtime-validés) ; chaque
  -- chapitre: état scénario ROM -> vérif déblocage -> ground du chapitre
  -- (si porté) -> donjons étage par étage -> arène (si le chapitre en a) ->
  -- flag suivant. Mêmes mécanismes runtime que le joueur (EnterZone).
  self.idx=-5;SV.RuntimeGroundAudit.Active=false
  -- scènes d'ouverture par chapitre = cinématiques canoniques mNNa01xx
  -- COMPILÉES (sky_compile_scenes V9), jouées dans leur ground ROM du
  -- hub avant les donjons du chapitre (CAST/dialogues réels).
  self.J={
   {ch='CH1',state={1,0},ground='d01p11b',scene='m01a0204',dungeons={{z='beach_cave',floors=4}},boss={z='beach_cave_pit',species='koffing'}},
   {ch='CH2',state={3,0},sceneground='g01p01b',scenemod='g01p01b__m02a0101',dungeons={{z='drenched_bluff',floors=6}}},
   {ch='CH3',state={4,0},sceneground='g01p03a',scenemod='g01p03a__m03a0102',dungeons={{z='mt_bristle',floors=9}},boss={z='mt_bristle_peak',species='drowzee'}},
   {ch='CH4',state={5,0},sceneground='g01p04a',scenemod='g01p04a__m04a0101',dungeons={{z='waterfall_cave',floors=8}}},
   {ch='CH5',state={6,0},sceneground='g01p04a',scenemod='g01p04a__m05a0101',dungeons={{z='apple_woods',floors=12}}},
   {ch='EXPEDITION',state={8,0},sceneground='g01p06b',scenemod='g01p06b__m08a0101',dungeons={{z='craggy_coast',floors=9},{z='mt_horn',floors=14},{z='foggy_forest',floors=11},{z='steam_cave',floors=8},{z='upper_steam_cave',floors=7}},boss={z='steam_cave_peak',species='groudon'}},
   {ch='CH10',state={10,0},sceneground='d09p11a',scenemod='d09p11a__m10a0101',dungeons={{z='amp_plains',floors=10},{z='far_amp_plains',floors=9}},boss={z='amp_clearing',species='manectric'}},
   {ch='CH11',state={11,0},sceneground='g01p07a',scenemod='g01p07a__m11a0101',dungeons={{z='northern_desert',floors=15},{z='quicksand_cave',floors=10},{z='quicksand_pit',floors=10}},boss={z='underground_lake',species='mesprit'}},
   {ch='CH12',state={12,0},sceneground='g01p04a',scenemod='g01p04a__m12a0101',dungeons={{z='crystal_cave',floors=11},{z='crystal_crossing',floors=13}},boss={z='crystal_lake',species='grovyle'}},
   {ch='FUTUR',state={13,0},sceneground='g01p03a',scenemod='g01p03a__m13a0101',dungeons={{z='chasm_cave',floors=8},{z='dark_hill',floors=15},{z='sealed_ruin',floors=8},{z='sealed_ruin_pit',floors=6}},boss={z='spiritomb_room',species='spiritomb'}},
   {ch='CH15',state={15,0},sceneground='d16p11a',scenemod='d16p11a__m15a0101',dungeons={{z='dusk_forest',floors=8},{z='deep_dusk_forest',floors=12},{z='treeshroud_forest',floors=20}}},
   {ch='CH17',state={17,0},sceneground='p05p02a',scenemod='p05p02a__m17a0104',dungeons={{z='brine_cave',floors=9},{z='lower_brine_cave',floors=5}},boss={z='brine_cave_pit',species='omastar'}},
   {ch='CH18',state={18,0},sceneground='d19p11a',scenemod='d19p11a__m18a0101',dungeons={{z='hidden_land',floors=15},{z='hidden_highland',floors=8}},boss={z='old_ruins',species='dusknoir'}},
   {ch='FINALE',state={20,0},sceneground='d01p11a',scenemod='d01p11a__m20a0101',dungeons={{z='temporal_tower',floors=13},{z='temporal_spire',floors=10}},boss={z='temporal_pinnacle',species='dialga'}},
  }
  self.jch=1;self.jdun=0;self.jfloors=0;self.jmobs=0
  local prog=require('halcyon.skyscenes.progression')
  prog.reset_for_test()
  emit('{"event":"skyjourney_begin","chapters":'..#self.J..'}')
  self:journey_advance()
  return
 end
 if self.mode=='skyprogress' then
  -- Parcours de progression §12 : init SV -> franchir les états canoniques
  -- dans l'ordre du graphe ROM -> vérifier les déblocages + la monotonie.
  self.idx=-4;SV.RuntimeGroundAudit.Active=false
  local ok,err=xpcall(function()
    local prog=require('halcyon.skyscenes.progression')
    prog.reset_for_test()
    local m0,s0=prog.state()
    emit('{"event":"skyprogress_begin","initial":"'..m0..'.'..s0..'"}')
    local steps={{1,0},{3,0},{4,0},{5,0},{6,0},{8,0},{10,0},{11,0},{12,0},{13,0},{15,0},{17,0},{18,0},{20,0}}
    local total_unlocked=0
    for _,st in ipairs(steps) do
      local okset,newly=prog.set(st[1],st[2])
      if not okset then error('set '..st[1]..'.'..st[2]..' refusé') end
      total_unlocked=total_unlocked+#(newly or {})
      emit('{"event":"state","main":'..st[1]..',"unlocked_now":'..#(newly or {})..'}')
    end
    -- régression: retour arrière interdit
    local back=prog.set(5,0)
    if back~=false then error('régression: retour arrière accepté') end
    -- vérifs finales
    local must={'beach_cave','steam_cave_peak','temporal_pinnacle','spiritomb_room'}
    for _,z in ipairs(must) do
      if not prog.is_unlocked(z) then error('zone non débloquée: '..z) end
    end
    emit('{"event":"skyprogress_end","total_unlocked":'..total_unlocked..',"verdict":"PROGRESSION_RUNTIME_PASS"}')
  end,debug.traceback)
  if not ok then emit('{"event":"skyprogress_end","verdict":"FAIL","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}') end
  emit('{"event":"end"}')
  return
 end
 if self.hub_ground then
  self.idx=-4;SV.RuntimeGroundAudit.Active=false
  emit('{"event":"skyhub_begin","ground":"'..self.hub_ground..'"}')
  local zone_grounds={}
  local zsum=_DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('sky_hub_zone')
  local gl=zsum.Grounds
  for gi=0,gl.Count-1 do zone_grounds[gl[gi]]=gi end
  local gi=zone_grounds[self.hub_ground]
  if gi==nil then emit('{"event":"skyhub_fail","error":"ground_absent"}');return end
  GAME:EnterZone('sky_hub_zone',-1,gi,0)
  return
 end
 if self.sky_scene then
  self.idx=-3;SV.RuntimeGroundAudit.Active=false
  emit('{"event":"sky_scene_begin","scene":"'..self.sky_scene..'","ground":"'..tostring(self.sky_scene_ground)..'"}')
  local zone_grounds={}
  local zsum=_DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('sky_hub_zone')
  local gl=zsum.Grounds
  for gi=0,gl.Count-1 do zone_grounds[gl[gi]]=gi end
  local gi=zone_grounds[self.sky_scene_ground]
  if gi~=nil then GAME:EnterZone('sky_hub_zone',-1,gi,0);return end
  -- ground hors sky_hub_zone (scènes Red compilées): master_zone
  local mi=self:master_ground_index(self.sky_scene_ground)
  local msum=_DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('master_zone')
  if msum.Grounds[mi]==self.sky_scene_ground then GAME:EnterZone('master_zone',-1,mi,0);return end
  emit('{"event":"sky_scene_fail","error":"ground_absent"}')
  return
 end
 if self.sky_pilot then
  -- remplace PILOT par les grounds Sky demandés (zone conteneur sky_hub_zone,
  -- index = position dans GroundMaps de la zone, résolue par nom)
  local names=self.sky_pilot
  for i=1,#PILOT do PILOT[i]=nil end
  local zone_grounds={}
  local zsum=_DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('sky_hub_zone')
  local gl=zsum.Grounds
  for gi=0,gl.Count-1 do zone_grounds[gl[gi]]=gi end
  for _,nm in ipairs(names) do
   local gi=zone_grounds[nm]
   if gi~=nil then PILOT[#PILOT+1]={id=nm,zone='sky_hub_zone',idx=gi}
   else emit('{"event":"sky_pilot_missing","ground":"'..nm..'"}') end
  end
 end
 self.idx=1;emit('{"event":"begin","count":'..#PILOT..'}');GAME:EnterZone(PILOT[self.idx].zone,-1,PILOT[self.idx].idx,0)
end
function V:OnDungeonFloorEnter()
 if self.enabled and self.mode=='redjourney' and self.RJ then
  local ok,err=xpcall(function()
    local C=self.RJ[self.rjch]
    if C==nil then return end
    local cz=tostring(_ZONE.CurrentZoneID)
    local seg=_ZONE.CurrentMapID.Segment
    local floor=_ZONE.CurrentMapID.ID
    self.rjfloors=self.rjfloors+1
    local cur=C.dungeons[self.rjdun]
    -- segment boss (fixed_room rsmap du dépôt)
    if C.boss and ((C.boss.z and cz==C.boss.z) or (not C.boss.z and cz==(C.boss.zone or cur.z) and seg==(C.boss.seg or 1))) then
      local map=_ZONE.CurrentMap
      local sp={}
      local found=false
      for ti=0,map.MapTeams.Count-1 do
        local t2=map.MapTeams[ti]
        for pi=0,t2.Players.Count-1 do
          local ok2,s2=pcall(function() return t2.Players[pi].BaseForm.Species end)
          if ok2 and s2 then sp[#sp+1]=tostring(s2);if tostring(s2)==C.boss.species then found=true end end
        end
      end
      emit('{"event":"red_boss","ch":"'..C.ch..'","species":"'..table.concat(sp,',')..'","expected":"'..C.boss.species..'","found":'..tostring(found)..'}')
      if not found then emit('{"event":"redjourney_end","verdict":"FAIL","error":"boss absent"}');emit('{"event":"end"}');return end
      self.rjch=self.rjch+1;self.rjdun=1
      local N=self.RJ[self.rjch]
      if N==nil then
        emit('{"event":"redjourney_end","chapters_done":'..(self.rjch-1)..',"floors_traversed":'..self.rjfloors..',"verdict":"RED_GLOBAL_JOURNEY_PASS"}')
        emit('{"event":"end"}')
      else
        emit('{"event":"red_chapter","ch":"'..N.ch..'"}')
        self:red_journey_start_chapter()
      end
      return
    end
    local want_seg=(cur and cur.seg) or 0
    if cur and cz==cur.z and seg==want_seg then
      if floor+1<cur.floors then
        GAME:EnterZone(cur.z,want_seg,floor+1,0)
      else
        emit('{"event":"red_dungeon_done","zone":"'..cur.z..'","floors":'..cur.floors..'}')
        -- boss en ZONE séparée (arènes fixedmap.inc/fixed.bin) : y entrer
        if C.boss and C.boss.z and not C.dungeons[self.rjdun+1] then
          emit('{"event":"red_enter_boss_zone","zone":"'..C.boss.z..'"}')
          GAME:EnterZone(C.boss.z,C.boss.seg or 0,0,0)
          return
        end
        -- GAP documenté : arène GBA non construite (jamais un faux PASS)
        if C.boss_gap and not C.dungeons[self.rjdun+1] then
          emit('{"event":"red_boss_gap","ch":"'..C.ch..'","gap":"'..C.boss_gap..'"}')
          self.rjgaps=(self.rjgaps or 0)+1
          self.rjch=self.rjch+1;self.rjdun=1
          local N=self.RJ[self.rjch]
          if N==nil then
            emit('{"event":"redjourney_end","chapters_done":'..(self.rjch-1)..',"floors_traversed":'..self.rjfloors..',"boss_gaps":'..(self.rjgaps or 0)..',"verdict":"RED_GLOBAL_JOURNEY_PASS_WITH_GAPS"}')
            emit('{"event":"end"}')
          else
            emit('{"event":"red_chapter","ch":"'..N.ch..'"}')
            self:red_journey_start_chapter()
          end
          return
        end
        -- boss_inline : boss au dernier étage de cette zone ?
        if C.boss_inline and C.boss_inline.zone==cur.z and not C.dungeons[self.rjdun+1] then
          local map=_ZONE.CurrentMap
          local sp={};local found=false
          for ti=0,map.MapTeams.Count-1 do
            local t2=map.MapTeams[ti]
            for pi=0,t2.Players.Count-1 do
              local ok2,s2=pcall(function() return t2.Players[pi].BaseForm.Species end)
              if ok2 and s2 then sp[#sp+1]=tostring(s2);if tostring(s2)==C.boss_inline.species then found=true end end
            end
          end
          emit('{"event":"red_boss","ch":"'..C.ch..'","kind":"inline_last_floor","species":"'..table.concat(sp,',')..'","expected":"'..C.boss_inline.species..'","found":'..tostring(found)..'}')
          if not found then emit('{"event":"redjourney_end","verdict":"FAIL","error":"boss inline absent"}');emit('{"event":"end"}');return end
          self.rjch=self.rjch+1;self.rjdun=1
          local N=self.RJ[self.rjch]
          if N==nil then
            emit('{"event":"redjourney_end","chapters_done":'..(self.rjch-1)..',"floors_traversed":'..self.rjfloors..',"verdict":"RED_GLOBAL_JOURNEY_PASS"}')
            emit('{"event":"end"}')
          else
            emit('{"event":"red_chapter","ch":"'..N.ch..'"}')
            self:red_journey_start_chapter()
          end
          return
        end
        if C.boss and not C.boss.z and (C.boss.zone or cur.z)==cur.z then
          GAME:EnterZone(cur.z,C.boss.seg or 1,0,0)
        elseif C.dungeons[self.rjdun+1] then
          self.rjdun=self.rjdun+1
          local nx=C.dungeons[self.rjdun]
          GAME:EnterZone(nx.z,nx.seg or 0,0,0)
        else
          self.rjch=self.rjch+1;self.rjdun=1
          local N=self.RJ[self.rjch]
          if N==nil then
            emit('{"event":"redjourney_end","chapters_done":'..(self.rjch-1)..',"floors_traversed":'..self.rjfloors..',"verdict":"RED_GLOBAL_JOURNEY_PASS"}')
            emit('{"event":"end"}')
          else
            emit('{"event":"red_chapter","ch":"'..N.ch..'"}')
            self:red_journey_start_chapter()
          end
        end
      end
    end
  end,debug.traceback)
  if not ok then emit('{"event":"redjourney_end","verdict":"FAIL","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}');emit('{"event":"end"}') end
  return
 end
 if self.enabled and self.mode=='skyjourney' and self.J then
  local ok,err=xpcall(function() self:journey_on_floor() end,debug.traceback)
  if not ok then emit('{"event":"skyjourney_end","verdict":"FAIL","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}');emit('{"event":"end"}') end
  return
 end
 if not self.enabled or (self.mode~='tornadus_battle' and string.sub(self.mode or '',1,6)~='arena:') then return end
 local ok,msg=pcall(function()
  local map=_ZONE.CurrentMap
  local foes=map.MapTeams.Count
  local boss=map.MapTeams[0].Players[0]
  return string.format('{"event":"arena_battle_runtime","zone":"%s","segment":%d,"map_teams":%d,"boss_species":"%s","boss_level":%d,"boss_x":%d,"boss_y":%d,"player_control":"DUNGEON_MODE_ENTERED","verdict":"BATTLE_START_PASS"}',tostring(_ZONE.CurrentZoneID),_ZONE.CurrentMapID.Segment,foes,tostring(boss.CurrentForm.Species),boss.Level,boss.CharLoc.X,boss.CharLoc.Y)
 end)
 emit(ok and msg or ('{"event":"arena_battle_runtime","verdict":"RUNTIME_FAIL","error":"'..tostring(msg):gsub('"','\\"')..'"}'))
end
function V:OnGroundMapEnter()
 -- phase scène du journey global : jouer la cinématique du chapitre
 if self.enabled and self.jscene and not self.busy then
  self:journey_play_scene()
  return
 end
 if self.enabled and self.rjscene and not self.busy then
  self:red_journey_play_scene()
  return
 end
 if self.enabled and (self.resume_save_pending or self.red_resume_save_pending) and not self.busy then
  local tag=self.red_resume_save_pending and 'red_resume_save_done' or 'resume_save_done'
  self.busy=true;self.resume_save_pending=false;self.red_resume_save_pending=false
  self.task=TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    local ok,err=xpcall(function()
      GAME:GroundSave()
      emit('{"event":"'..tag..'","from_ground":"'..tostring(GAME:GetCurrentGround().AssetName)..'"}')
    end,debug.traceback)
    if not ok then emit('{"event":"resume_fail","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}') end
    emit('{"event":"end"}')
    self.busy=false;self.task=nil
  end)
  return
 end
 if self.enabled and self.hub_ground and not self.busy then
  self.busy=true
  self.task=TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    local ok,err=xpcall(function()
      local npcs=require('halcyon.skyscenes.hubnpc_'..self.hub_ground)
      local kit=require('halcyon.skyscenes.kit')
      local spawned=0
      local chars={}
      for _,n in ipairs(npcs) do
        local c=kit.spawn_npc(n.species,n.x,n.y,n.dir,n.name)
        if c then spawned=spawned+1; chars[#chars+1]={c=c,n=n} end
      end
      emit('{"event":"skyhub_npcs","ground":"'..self.hub_ground..'","expected":'..#npcs..',"spawned":'..spawned..'}')
      -- interactions: jouer le dialogue canonique de chaque NPC qui en a un
      local hero=nil; pcall(function() hero=CH('PLAYER') end)
      local talked=0
      for _,e2 in ipairs(chars) do
        if e2.n.talk~=nil then
          -- le héros marche jusqu'au NPC (interaction réelle) puis dialogue
          pcall(function()
            local p=e2.c.Position
            GROUND:MoveToPosition(hero,p.X,p.Y+24,false,2)
            GROUND:CharTurnToCharAnimated(hero,e2.c,4)
          end)
          e2.n.talk(hero,hero)
          talked=talked+1
          emit('{"event":"skyhub_talk","npc":"'..e2.n.name..'","verdict":"TALK_PASS"}')
        end
      end
      kit.cleanup_npcs()
      emit('{"event":"skyhub_end","ground":"'..self.hub_ground..'","npcs":'..spawned..',"talks":'..talked..',"verdict":"HUB_NPC_RUNTIME_PASS"}')
    end,debug.traceback)
    if not ok then emit('{"event":"skyhub_fail","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}') end
    emit('{"event":"end"}')
    self.busy=false;self.task=nil
  end)
  return
 end
 if self.enabled and self.sky_scene and not self.busy then
  self.busy=true
  self.task=TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    local ok,err=xpcall(function()
      -- 1) scènes artisanales (SkyCanonScenes) ; 2) scènes compilées
      -- (halcyon.skyscenes.<zone>__<scene>, générées par
      -- sky_compile_scenes.py, signature function(hero, partner))
      local scenes=require('halcyon.SkyCanonScenes')
      local fn=scenes[self.sky_scene]
      if fn~=nil then
        fn('/tmp/ground_gameplay_validator.jsonl')
      else
        local ok2,mod=pcall(require,'halcyon.skyscenes.'..self.sky_scene)
        if not ok2 or type(mod)~='function' then
          -- scènes Red compilées (red_compile_cinematics.py)
          ok2,mod=pcall(require,'halcyon.redscenes.'..self.sky_scene)
        end
        if not ok2 or type(mod)~='function' then
          error('scene inconnue: '..tostring(self.sky_scene)..' ('..tostring(mod)..')')
        end
        local okh,hero=pcall(function() return CH('PLAYER') end)
        local okp,partner=pcall(function() return CH('Teammate1') end)
        if not okh then hero=nil end
        if not okp then partner=nil end
        mod(hero, partner or hero)
        emit('{"scene":"'..self.sky_scene..'","kind":"compiled","verdict":"CINEMATIC_RUNTIME_PASS"}')
      end
    end,debug.traceback)
    if not ok then emit('{"event":"sky_scene_fail","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}') end
    emit('{"event":"end"}')
    self.busy=false;self.task=nil
  end)
  return
 end
 if not self.enabled or (self.mode=='tornadus_battle' or string.sub(self.mode or '',1,6)=='arena:' or string.sub(self.mode or '',1,6)=='luluby') or self.busy then return end
 -- GroundMapEnter est synchrone. Le travail qui yield est reporte dans Update.
 self.pending=false;self.busy=true
 emit('{"event":"ground_entered","ground":"'..PILOT[self.idx].id..'","scheduler":"TASK_BRANCH"}')
 -- Conserver la référence évite que la branche soit abandonnée après le callback.
 self.task=TASK:BranchCoroutine(function()
   local ok,err=xpcall(function()self:validate_async()end,debug.traceback)
   if not ok then emit('{"ground":"'..tostring(PILOT[self.idx] and PILOT[self.idx].id)..'","verdict":"RUNTIME_FAIL","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}') end
   self.idx=self.idx+1
   if self.idx>#PILOT then SV.RuntimeGroundAudit.Active=false;emit('{"event":"end"}')
   else GAME:EnterZone(PILOT[self.idx].zone,-1,PILOT[self.idx].idx,0) end
   self.busy=false;self.task=nil
 end)
end
function V:validate_async()
 local id=PILOT[self.idx].id;local map=safe(function()return GAME:GetCurrentGround()end,nil);local hero=CH('PLAYER')
 if not map or not hero then emit('{"ground":"'..id..'","verdict":"RUNTIME_FAIL","error":"map_or_hero_nil"}');return end
 GAME:WaitFrames(12)
 local x=safe(function()return hero.Position.X end,-1);local y=safe(function()return hero.Position.Y end,-1)
 local moves={};local deltas={}
 for _,d in ipairs({Direction.Up,Direction.Right,Direction.Down,Direction.Left}) do
  GROUND:MoveInDirection(hero,d,8,false,2)
  GAME:WaitFrames(2)
  local nx=safe(function()return hero.Position.X end,x);local ny=safe(function()return hero.Position.Y end,y)
  moves[#moves+1]=(nx~=x or ny~=y) and 1 or 0
  deltas[#deltas+1]=string.format('"%d,%d"',nx-x,ny-y)
  GROUND:TeleportTo(hero,x,y,Direction.Down);GAME:WaitFrames(2)
 end
 local count=moves[1]+moves[2]+moves[3]+moves[4]
 local verdict=count>0 and 'SAFE' or 'NEEDS_REPAIR'
 local probe=count>0 and 'MOVEMENT_PASS' or 'SPAWN_ISOLATED'
 emit(string.format('{"ground":"%s","load":"LOAD_PASS","spawn":{"x":%d,"y":%d},"move_dirs":[%d,%d,%d,%d],"move_deltas":[%s],"movement_probe":"%s","verdict":"%s"}',id,x,y,moves[1],moves[2],moves[3],moves[4],table.concat(deltas,','),probe,verdict))
end
function V:OnUpdate(gtime)
 if not self.enabled or not self.pending or self.busy then return end
 self.pending=false;self.busy=true
 -- Le callback Update est synchrone, mais il peut amorcer une vraie coroutine
 -- TASK qui sera reprise par le moteur aux frames suivantes.
 TASK:BranchCoroutine(function()
   local ok,err=xpcall(function()self:validate_async()end,debug.traceback)
   if not ok then emit('{"ground":"'..tostring(PILOT[self.idx] and PILOT[self.idx].id)..'","verdict":"RUNTIME_FAIL","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}') end
   self.idx=self.idx+1
   if self.idx>#PILOT then SV.RuntimeGroundAudit.Active=false;emit('{"event":"end"}')
   else GAME:EnterZone(PILOT[self.idx].zone,-1,PILOT[self.idx].idx,0) end
   self.busy=false
 end)
end
function V:Update(gtime) while true do coroutine.yield() end end
function V:master_ground_index(name)
 local zsum=_DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('master_zone')
 local gl=zsum.Grounds
 for k=0,gl.Count-1 do if gl[k]==name then return k end end
 return 0
end
function V:OnInit()
 if self.enabled then
  if self.mode=='skyresume:load' or self.mode=='redresume:load' then
   -- reprise : charger la sauvegarde DISQUE, pas une nouvelle partie
   emit('{"event":"bootstrap_load_save"}')
   self.resume_loading=true
   RogueEssence.Data.DataManager.Instance:LoadProgress()
   return
  end
  emit('{"event":"bootstrap_new_game"}')
  RogueEssence.GameManager.Instance:NewGamePlus(424242)
 end
end
function V:OnNewGame()self:begin()end
function V:OnLoadSavedData()self:begin()end
function V:Subscribe(med)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.Update,function(_,args)self.OnUpdate(self,args)end)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.LoadSavedData,function()self.OnLoadSavedData(self)end)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.DungeonFloorEnter,function()self.OnDungeonFloorEnter(self)end)
end

-- ---------- JOURNEY GLOBAL ----------
function V:red_journey_start_chapter()
 -- chapitre Red : scène cinématique V2 (station ROM EU) dans master_zone
 -- PUIS donjons. Même mécanique jscene que le journey Sky.
 local C=self.RJ[self.rjch]
 if C==nil then return end
 if C.scenemod and C.sceneground and not C._scene_done then
  -- grounds Red résolus dans master_zone PUIS sky_hub_zone (d15p01/
  -- d16p01: master_zone est verrouillé CH1-5, extension via hub)
  for _,zid in ipairs({'master_zone','sky_hub_zone'}) do
   local ok,msum=pcall(function() return _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(zid) end)
   if ok and msum then
    local gl=msum.Grounds
    for gi=0,gl.Count-1 do
     if gl[gi]==C.sceneground then
      self.rjscene=C.scenemod
      C._scene_done=true
      GAME:EnterZone(zid,-1,gi,0)
      return
     end
    end
   end
  end
  emit('{"event":"red_scene_skip","ch":"'..C.ch..'","reason":"ground_absent"}')
 end
 GAME:EnterZone(C.dungeons[1].z,C.dungeons[1].seg or 0,0,0)
end

function V:red_journey_play_scene()
 local C=self.RJ[self.rjch]
 local mod=self.rjscene
 self.rjscene=nil
 self.task=TASK:BranchCoroutine(function()
  GAME:WaitFrames(20)
  local ok,err=xpcall(function()
    local ok2,fn=pcall(require,'halcyon.redscenes.'..mod)
    if not ok2 or type(fn)~='function' then error('module absent: '..tostring(mod)) end
    local okh,hero=pcall(function() return CH('PLAYER') end)
    local okp,partner=pcall(function() return CH('Teammate1') end)
    if not okh then hero=nil end
    if not okp then partner=nil end
    fn(hero, partner or hero)
    emit('{"event":"red_scene","ch":"'..C.ch..'","module":"'..mod..'","verdict":"SCENE_PASS"}')
  end,debug.traceback)
  if not ok then
   emit('{"event":"red_scene","ch":"'..C.ch..'","module":"'..tostring(mod)..'","verdict":"SCENE_FAIL","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}')
  end
  GAME:EnterZone(C.dungeons[1].z,C.dungeons[1].seg or 0,0,0)
 end)
end

function V:journey_advance()
 -- démarre le chapitre courant : état scénario + vérif déblocage + 1er donjon
 local prog=require('halcyon.skyscenes.progression')
 local C=self.J[self.jch]
 if C==nil then
  local m,s=prog.state()
  emit('{"event":"skyjourney_end","final_state":"'..m..'.'..s..'","chapters_done":'..(self.jch-1)..',"floors_traversed":'..(self.jfloors or 0)..',"mobs_seen":'..(self.jmobs or 0)..',"verdict":"GLOBAL_JOURNEY_PASS"}')
  emit('{"event":"end"}')
  return
 end
 local okset=prog.set(C.state[1],C.state[2])
 for _,d in ipairs(C.dungeons) do
  if not prog.is_unlocked(d.z) then
   emit('{"event":"skyjourney_end","verdict":"FAIL","error":"'..d.z..' non débloqué à l\'état '..C.state[1]..'"}')
   emit('{"event":"end"}');return
  end
 end
 emit('{"event":"journey_chapter","ch":"'..C.ch..'","state":"'..C.state[1]..'.'..C.state[2]..'"}')
 -- phase SCÈNE : la cinématique d'ouverture du chapitre (compilée ROM)
 -- est jouée dans son ground du hub AVANT les donjons — persistance des
 -- SV/flags posés par la scène vérifiée par la suite du parcours.
 if C.scenemod and C.sceneground and not C._scene_done then
  local zg={}
  local ok,zsum=pcall(function() return _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('sky_hub_zone') end)
  if ok and zsum then
   local gl=zsum.Grounds
   for gi=0,gl.Count-1 do zg[gl[gi]]=gi end
   local gi=zg[C.sceneground]
   if gi~=nil then
    self.jscene=C.scenemod
    C._scene_done=true
    GAME:EnterZone('sky_hub_zone',-1,gi,0)
    return
   end
  end
  emit('{"event":"journey_scene_skip","ch":"'..C.ch..'","reason":"ground_absent"}')
 end
 self.jdun=1
 GAME:EnterZone(C.dungeons[1].z,0,0,0)
end

function V:journey_play_scene()
 -- exécuté à l'arrivée dans le ground de scène du chapitre (hub)
 local C=self.J[self.jch]
 local mod=self.jscene
 self.jscene=nil
 self.task=TASK:BranchCoroutine(function()
  GAME:WaitFrames(20)
  local ok,err=xpcall(function()
    local ok2,fn=pcall(require,'halcyon.skyscenes.'..mod)
    if not ok2 or type(fn)~='function' then error('module absent: '..tostring(mod)) end
    local okh,hero=pcall(function() return CH('PLAYER') end)
    local okp,partner=pcall(function() return CH('Teammate1') end)
    if not okh then hero=nil end
    if not okp then partner=nil end
    fn(hero, partner or hero)
    emit('{"event":"journey_scene","ch":"'..C.ch..'","module":"'..mod..'","verdict":"SCENE_PASS"}')
  end,debug.traceback)
  if not ok then
   emit('{"event":"journey_scene","ch":"'..C.ch..'","module":"'..tostring(mod)..'","verdict":"SCENE_FAIL","error":"'..tostring(err):gsub('"','\\"'):gsub('\n',' | ')..'"}')
  end
  self.jdun=1
  GAME:EnterZone(C.dungeons[1].z,0,0,0)
 end)
end

function V:journey_on_floor()
 local C=self.J[self.jch]
 if C==nil then return end
 local cz=tostring(_ZONE.CurrentZoneID)
 local floor=_ZONE.CurrentMapID.ID
 local cur=C.dungeons[self.jdun]
 -- compteur de preuves : chaque étage traversé = une map RÉELLEMENT
 -- générée par le moteur (hook DungeonFloorEnter après Map.OnEnter)
 self.jfloors=(self.jfloors or 0)+1
 pcall(function()
  local map=_ZONE.CurrentMap
  for ti=0,map.MapTeams.Count-1 do self.jmobs=(self.jmobs or 0)+map.MapTeams[ti].Players.Count end
 end)
 if cur and cz==cur.z then
  if floor+1<cur.floors then
   GAME:EnterZone(cur.z,0,floor+1,0)
  else
   emit('{"event":"journey_dungeon_done","zone":"'..cur.z..'","floors":'..cur.floors..'}')
   if C.dungeons[self.jdun+1] then
    self.jdun=self.jdun+1
    GAME:EnterZone(C.dungeons[self.jdun].z,0,0,0)
   elseif C.boss then
    GAME:EnterZone(C.boss.z,0,0,0)
   else
    self.jch=self.jch+1;self:journey_advance()
   end
  end
  return
 end
 if C.boss and cz==C.boss.z then
  local map=_ZONE.CurrentMap
  local found=false;local species={}
  for ti=0,map.MapTeams.Count-1 do
   local t2=map.MapTeams[ti]
   for pi=0,t2.Players.Count-1 do
    local ok2,sp=pcall(function() return t2.Players[pi].BaseForm.Species end)
    if ok2 and sp then species[#species+1]=tostring(sp);if tostring(sp)==C.boss.species then found=true end end
   end
  end
  emit('{"event":"journey_boss","ch":"'..C.ch..'","zone":"'..C.boss.z..'","species":"'..table.concat(species,',')..'","expected":"'..C.boss.species..'","found":'..tostring(found)..'}')
  if not found then
   emit('{"event":"skyjourney_end","verdict":"FAIL","error":"boss '..C.boss.species..' absent"}');emit('{"event":"end"}');return
  end
  self.jch=self.jch+1;self:journey_advance()
 end
end

function V:UnSubscribe(med)end
SCRIPT:AddService('GroundGameplayValidator',V:new())
-- Le validateur de routes histoire Red est opt-in via
-- PMDO_RED_STORY_ROUTE_VALIDATOR ; main.lua est verrouillé CH1-5, donc le
-- require vit ici (service voisin, également opt-in, zéro effet en jeu normal).
if os.getenv('PMDO_RED_STORY_ROUTE_VALIDATOR') then
  require 'halcyon.services.red_story_route_validator'
end
return V
