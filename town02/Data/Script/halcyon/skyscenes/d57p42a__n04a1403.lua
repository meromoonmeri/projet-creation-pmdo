-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P42A/n04a1403.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D57P42A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  -- GAP: BGM BGM_HEAVY_WIND2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Then [CS:N]Loudred[CR] was just being\n[CS:N]Loudred[CR]...", french="Enfin, [CS:N]Ramboum[CR],\nc'est [CS:N]Ramboum[CR]...", german="Und dann war [CS:N]Krakeelo[CR] auch\nschon wieder ganz der alte [CS:N]Krakeelo[CR]...", italian="In quel momento [CS:N]Loudred[CR]\nfaceva il duro, come al solito...", spanish="[CS:N]Loudred[CR] simplemente se estaba\ncomportando como [CS:N]Loudred[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="He was really concerned\nabout me...", french="Il se faisait vraiment du souci\npour moi...", german="Er hat sich wirklich Sorgen um\nmich gemacht.", italian="Ma era davvero preoccupato\nper me...", spanish=" Estaba preocupado por mí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]What?!", french=" ...[K] Quoi?!", german=" ...[K]Was?!?", italian=" ...[K] Come?!", spanish=" Hum...[K] ¡Eso!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" W-wait a minute!", french=" U-une minute!", german=" W-warte mal einen Augenblick!", italian=" A-Aspetta un attimo!", spanish=" ¡Un... Un momento!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Loudred[CR]...[K] What [CS:N]Loudred[CR] said...", french="[CS:N]Ramboum[CR]...[K] Ce que\n[CS:N]Ramboum[CR] a dit...", german="[CS:N]Krakeelo[CR]...[K]\nWas [CS:N]Krakeelo[CR] gesagt hat...", italian=" [CS:N]Loudred[CR]...[K] Quello che ha detto...", spanish=" [CS:N]Loudred[CR]...[K] Lo que [CS:N]Loudred[CR] dijo..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(45) end) -- bgm_ChangeVolume vers 0 (silence)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN](You DID just take a LOT of DAMAGE.)", french="[CN](Tu as PRIS un PAQUET de DEGATS.)", german="[CN](Aber du HAST ganz schön\n[CN]etwas ABBEKOMMEN...)", italian="[CN](EPPURE, hai subito MOLTI DANNI.)", spanish="[CN](La verdad es que has recibido\n[CN]un montón de daño.)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN](On THAT note, I just GOT here...)", french="[CN](Mais MOI, je viens d'arriver...)", german="[CN](DAHER ist es wohl GUT, dass ich\n[CN]hier RECHTZEITIG aufgetaucht bin...)", italian="[CN](A proposito, io SONO appena arrivato QUI...)", spanish="[CN](Por cierto, yo acabo de llegar...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN](So I'm doing FINE...)", french="[CN](... alors je vais BIEN!)", german="[CN](Das FREUT mich...)", italian="[CN](Quindi sto BENE!)", spanish="[CN](Así que estoy como una rosa...)"})
  -- message_Close
  GAME:WaitFrames(15)
  -- bgm_ChangeVolume(60,256) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...! (Don't tell me...)", french=" ...! (Ne me dites pas que...)", german=" ...(Sag nicht...)", italian=" ...! (Non mi dire che...)", spanish=" ¡Ostras! (Sería muy fuerte...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" But...[K] But that would mean...", french=" Mais...[K] ça voudrait dire...", german="Aber...[K]\nAber das würde ja bedeuten...", italian="Ma...[K] Ma questo significherebbe\nche...", spanish=" Pero...[K] eso significaría que..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-40), g.ViewCenter.Y+(0), 40, false) end) -- MovePositionOffset performer/caméra
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-40), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I think it's connected to what\nI've been trying to puzzle out up to now...", french="Je crois que ça a un rapport\navec ce mystère que j'essaye de résoudre\ndepuis le début...", german="Ich glaube, das hängt mit dem\nzusammen, was ich gerade versuche,\nherauszubekommen...", italian="Credo sia collegato a quello che\nho cercato di capire finora...", spanish="Creo que guarda relación con\nlo que llevo rato intentando entender..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I think I understand.", french=" Je crois que je comprends.", german=" Ich glaube, ich habe es.", italian=" E credo di aver svelato l'arcano.", spanish=" Ahora lo comprendo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Haunter[CR] says that he's\ninvincible...[K] That's a trick...", french="[CS:N]Spectrum[CR] prétend qu'il\nest invincible...[K] Il y a un truc...", german="[CS:N]Alpollo[CR] behauptet, unbesiegbar\nzu sein...[K] Aber das ist natürlich ein Trick...", italian="[CS:N]Haunter[CR] dice di essere\ninvincibile...[K] ma è un trucco...", spanish="[CS:N]Haunter[CR] dice que es invencible...[K]\nPero es solo un truco..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(150) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- main_EnterDungeon(162, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
