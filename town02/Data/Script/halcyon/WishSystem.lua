require 'halcyon.FriendAreas'
WishSystem={}
function WishSystem.Grant()
 UI:ResetSpeaker();UI:SetCenter(true)
 UI:BeginChoiceMenu('Quel vœu souhaitez-vous ?',{'Beaucoup d’argent','Beaucoup d’objets','Une zone d’accueil','Plus de puissance','Quelque chose de bien'},1,5)
 UI:WaitForChoice();local c=UI:ChoiceResult() or 5
 if c==1 then GAME:AddToPlayerMoney(15000);UI:WaitShowDialogue('Le vœu remplit votre bourse.')
 elseif c==2 then
  for i=1,5 do GAME:GivePlayerItem('seed_reviver',1) end
  for i=1,5 do GAME:GivePlayerItem('berry_oran',1) end
  UI:WaitShowDialogue('Des objets apparaissent autour de vous.')
 elseif c==3 then
  local id=FriendAreas.GrantRandom()
  UI:WaitShowDialogue(id and ('Grodoudou pourra désormais vous conduire vers la zone d’accueil '..id..'.') or 'Toutes les zones d’accueil sont déjà acquises.')
 elseif c==4 then
  for i=1,3 do GAME:GivePlayerItem('boost_hp_up',1) end
  UI:WaitShowDialogue('Une énergie durable traverse votre équipe.')
 else
  GAME:AddToPlayerMoney(10000);UI:WaitShowDialogue('Quelque chose de bien vous attend au retour.')
 end
 UI:SetCenter(false);SV.WishCave.WishGranted=true
end
return WishSystem
