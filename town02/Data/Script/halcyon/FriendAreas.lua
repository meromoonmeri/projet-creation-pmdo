-- Zones d'accueil PMD Red vendues par Grodoudou; jamais des arènes.
FriendAreas={}
FriendAreas.IDS={
 'h01p01','h01p02','h01p03','h02p01','h02p02','h02p03','h03p01','h04p01','h04p02','h05p01','h05p02',
 'h06p01','h06p02','h06p03','h06p04','h06p05','h06p06','h07p01','h07p02','h07p03','h07p04','h07p05','h07p06','h07p07','h07p08',
 'h08p01','h09p01','h09p02','h10p01','h10p02','h11p01','h12p01','h13p01','h13p02','h13p03','h13p04',
 'h14p01','h15p01','h16p01','h17p01','h18p01','h19p01','h20p01','h21p01','h21p02','h22p01','h23p01','h24p01','h25p01','h26p01','h27p01','h28p01','h28p02','h29p01','h29p02','h29p03','h29p04'
}
function FriendAreas.Ensure()
 SV.FriendAreas=SV.FriendAreas or {Owned={},Residents={}}
 SV.FriendAreas.Owned=SV.FriendAreas.Owned or {};SV.FriendAreas.Residents=SV.FriendAreas.Residents or {}
end
function FriendAreas.Grant(id)
 FriendAreas.Ensure();if SV.FriendAreas.Owned[id] then return false end
 SV.FriendAreas.Owned[id]=true;return true
end
function FriendAreas.GrantRandom()
 FriendAreas.Ensure();local free={}
 for _,id in ipairs(FriendAreas.IDS) do if not SV.FriendAreas.Owned[id] then table.insert(free,id) end end
 if #free==0 then return nil end
 local id=free[math.random(#free)];SV.FriendAreas.Owned[id]=true;return id
end
return FriendAreas
