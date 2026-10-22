-- Explicit NDS s04 scene routing for Cloven Ruin (Aegis Cave, +30 years).
-- This module preserves scene order/role; only cast ownership is adapted.
require 'origin.common'
local S={}
S.MATRIX={
 s04p0501={ground='D32P31A',role='Regice challenge',cast='New Era expedition'},
 s04p0601={ground='D32P31A',role='Regice pledge/recruitment',cast='New Era expedition'},
 s04p1001={ground='D32P32A',role='Regirock challenge',cast='New Era expedition'},
 s04p1101={ground='D32P32A',role='Regirock pledge/recruitment',cast='New Era expedition'},
 s04p1301={ground='D32P33A',role='Registeel challenge',cast='New Era expedition'},
 s04p1401={ground='D32P33A',role='rescue and reinforcement offer',cast='Guild reinforcements replace Team Charm'},
 s04p1501={ground='D32P33A',role='Registeel pledge/recruitment',cast='New Era expedition'},
 s04p1601={ground='D32P44A',role='first Regigigas awakening with allied reinforcements',cast='Guild reinforcements'},
 s04p1701={ground='D32P44A',role='second Regigigas visit with allies',cast='Guild reinforcements'},
 s04p1801={ground='D32P44A',role='later solo worthiness trial',cast='New Era active team'},
 s04p1901={ground='D32P44A',role='Regigigas rises, earthquake, escape',cast='New Era expedition'},
 s04p1902={ground='D32P14A',role='Concealed Ruins awakening outside',cast='New Era expedition'},
 s04p2001={ground='D32P44A',role='Regigigas pledge/recruitment',cast='New Era active team'},
 s04p2101={ground='D32P44A',role='post-recruitment chamber state',cast='New Era active team'},
}
local function state() SV.Ruines=SV.Ruines or {};SV.Ruines.NDSScenes=SV.Ruines.NDSScenes or {};return SV.Ruines.NDSScenes end
function S.Begin(id)
 if not S.MATRIX[id] then error('Unknown Aegis Cave NDS scene '..tostring(id)) end
 local st=state();st.Current=id;st[id]=st[id] or {};st[id].Started=true
 PrintInfo('[Cloven NDS] BEGIN '..id..' '..S.MATRIX[id].role)
end
function S.Complete(id)
 local st=state();st[id]=st[id] or {};st[id].Started=true;st[id].Complete=true;st.Current=nil
 PrintInfo('[Cloven NDS] COMPLETE '..id)
end
function S.RegigigasIntro()
 local st=state();local visits=st.RegigigasVisits or 0;st.RegigigasVisits=visits+1
 local id=visits==0 and 's04p1601' or (visits==1 and 's04p1701' or 's04p1801');S.Begin(id);return id
end
return S
