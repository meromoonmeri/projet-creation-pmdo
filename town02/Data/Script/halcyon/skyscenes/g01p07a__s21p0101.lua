-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/s21p0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 78) -- $SCENARIO_MAIN = scn[29,78] (ROM)
  -- back_SetGround(LEVEL_G01P07A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 208, 184, Direction.Right, "NPC_RURIRI")
  -- SetAnimation(45) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 168, 160, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="...I see.[K] So you encountered\n[CS:N]Cresselia[CR].", french="... Je vois.[K] Ainsi vous avez\nrencontré [CS:N]Cresselia[CR].", german="...Ich verstehe.[K] Ihr seid also\n[CS:N]Cresselia[CR] begegnet.", italian="... Capisco.[K] Quindi avete\nincontrato [CS:N]Cresselia[CR].", spanish="Ajá.[K] Así que os encontrasteis\ncon [CS:N]Cresselia[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And she said that [CS:N]Azurill[CR]'s\nnightmare is caused by the distortion in the\nfabric of space.", french="Et elle a dit que le cauchemar\nd'[CS:N]Azurill[CR] était causé par la distorsion\ndans la trame de l'espace.", german="Und sie sagte, dass der Albtraum\nvon [CS:N]Azurill[CR] durch eine Verzerrung im\nRaumgefüge verursacht werde.", italian="E vi ha detto che l'incubo di\n[CS:N]Azurill[CR] è causato dalla distorsione della\nstruttura dello spazio.", spanish="Y os dijo que la pesadilla de\n[CS:N]Azurill[CR] se debe a la deformación del\nespacio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup.", french=" Oui.", german=" Jep.", italian=" Sì.", spanish=" Sí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes.", french=" Oui.", german=" Ja.", italian=" Sì.", spanish=" Sí."})
  else
  SkySceneKit.say({english=" Yep.", french=" Oui.", german=" Jep.", italian=" Sì.", spanish=" Sí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="If nothing is done about it...[K]\nall Pokémon will join [CS:N]Azurill[CR] in unending sleep.", french="Si rien n'y est fait...[K] tous\nles Pokémon rejoindront [CS:N]Azurill[CR] dans\nun sommeil sans fin.", german="Wenn sich nichts daran\nändert...[K] Dann werden alle Pokémon genau wie\n[CS:N]Azurill[CR] in einen unendlichen Schlaf versinken.", italian="Se nessuno fa niente...[K]\ntutti i Pokémon faranno la fine di [CS:N]Azurill[CR].", spanish="Si no hacemos nada...[K] todos los\nPokémon entrarán, como [CS:N]Azurill[CR], en un sueño\neterno."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That is what [CS:N]Cresselia[CR] said?", french="C'est bien ce que [CS:N]Cresselia[CR]\na dit?", german=" Das hat [CS:N]Cresselia[CR] gesagt?", italian="È questo che vi ha\ndetto [CS:N]Cresselia[CR]?", spanish=" ¿Eso fue lo que dijo [CS:N]Cresselia[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup...", french=" Oui...", german=" Jep...", italian=" Già...", spanish=" Sí..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes...", french=" Oui...", german=" Ja...", italian=" Sì...", spanish=" Sí..."})
  else
  SkySceneKit.say({english=" Yep...", french=" Oui...", german=" Jep...", italian=" Già...", spanish=" Sí..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Squawk! If that's all true...[K]\nthis is terrible trouble, to be sure!", french="Couac! Si c'est vrai...[K]\nla situation est très grave!", german="Kreisch! Wenn das alles\nstimmt,[K] haben wir ein schlimmes Problem!", italian="Squack! Se è tutto vero...[K]\nsiamo proprio nei guai, poco ma sicuro!", spanish="¡Cruac! Si es eso cierto...[K]\n¡la situación es muy grave!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" We've got to do something!", french=" Nous devons faire quelque chose!", german=" Wir müssen etwas tun!", italian=" Dobbiamo fare qualcosa!", spanish=" ¡Tenemos que hacer algo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So [CS:N]Chatot[CR], what do you know\nabout [CS:N]Cresselia[CR]?", french="[CS:N]Pijako[CR], qu'est-ce que tu sais\nsur [CS:N]Cresselia[CR]?", german="Also, [CS:N]Plaudagei[CR], was weißt du\nüber [CS:N]Cresselia[CR]?", italian="[CS:N]Chatot[CR], cosa sai di\n[CS:N]Cresselia[CR]?", spanish="[CS:N]Chatot[CR], ¿qué sabes de\n[CS:N]Cresselia[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So [CS:N]Chatot[CR], what do you know\nabout [CS:N]Cresselia[CR]?", french="[CS:N]Pijako[CR], qu'est-ce que tu sais\nsur [CS:N]Cresselia[CR]?", german="Also, [CS:N]Plaudagei[CR], was weißt du\nüber [CS:N]Cresselia[CR]?", italian="[CS:N]Chatot[CR], cosa sai di\n[CS:N]Cresselia[CR]?", spanish="[CS:N]Chatot[CR], ¿qué sabes de\n[CS:N]Cresselia[CR]?"})
  else
  SkySceneKit.say({english="So [CS:N]Chatot[CR], what do you know\nabout [CS:N]Cresselia[CR]?", french="[CS:N]Pijako[CR], qu'est-ce que tu sais\nsur [CS:N]Cresselia[CR]?", german="Also, [CS:N]Plaudagei[CR], was weißt du\nüber [CS:N]Cresselia[CR]?", italian="[CS:N]Chatot[CR], cosa sai di\n[CS:N]Cresselia[CR]?", spanish="[CS:N]Chatot[CR], ¿qué sabes de\n[CS:N]Cresselia[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I know of the Pokémon...[K]but only\nfrom rumors.", french="J'en ai entendu parler...[K] mais ce\nne sont que des rumeurs.", german="Ich weiß von diesem\nPokémon...[K] Aber nur vom Hörensagen.", italian="Conosco il Pokémon...[K] ma solo\ndi fama.", spanish="He oído algo...[K] pero no son más\nque rumores."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It is said [CS:N]Cresselia[CR] appears\nonly during the night of the quarter moon.", french="On dit que [CS:N]Cresselia[CR] apparaît\npendant les nuits où la lune se montre en\nquartiers.", german="Es heißt, [CS:N]Cresselia[CR] erscheine nur\nin der Nacht des Viertelmondes.", italian="Si dice che [CS:N]Cresselia[CR] appaia\nsolo nelle notti di quarto di luna.", spanish="Se dice que [CS:N]Cresselia[CR] aparece\nsolamente durante el cuarto creciente."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It is also said that this Pokémon\ncan heal others' emotional scars simply with\nthe gentle light from her body.", french="On dit aussi que ce Pokémon\npeut apaiser le chagrin avec la douce lumière\nqui émane de son corps.", german="Es heißt weiter, sie könne\nemotionale Wunden anderer Pokémon einfach\nmit dem sanften Licht ihres Körpers heilen.", italian="Si dice anche che questo\nPokémon sia in grado di curare le ferite\nemotive degli altri grazie alla sua luce.", spanish="También se rumorea que puede\ncurar daños emocionales con la luz que\nemana de su cuerpo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk![K] She didn't seem so kindly...", french="Argh![K] Elle ne semblait pas\nsi aimable l'autre fois...", german="Uff![K] Sie machte keinen so\nfreundlichen Eindruck...", italian="Uh![K] Non mi è sembrata\ncosì gentile...", spanish="¡Uf![K] Pues no parecía muy\nsimpática..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk![K] She didn't seem so kindly...", french="Argh![K] Elle ne semblait pas\nsi aimable l'autre fois...", german="Uff![K] Sie machte keinen so\nfreundlichen Eindruck...", italian="Uh![K] Non mi è sembrata\ncosì gentile...", spanish="¡Uf![K] Pues no parecía muy\nsimpática..."})
  else
  SkySceneKit.say({english=" Urk![K] She didn't seem so kindly...", french="Argh![K] Elle ne semblait pas\nsi aimable l'autre fois...", german="Uff![K] Sie machte keinen so\nfreundlichen Eindruck...", italian="Uh![K] Non mi è sembrata\ncosì gentile...", spanish="¡Uf![K] Pues no parecía muy\nsimpática..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="There is one more thing about\n[CS:N]Cresselia[CR].", french=" Encore une chose sur [CS:N]Cresselia[CR].", german=" Noch eine Sache über [CS:N]Cresselia[CR].", italian=" C'è un'altra cosa.", spanish=" También se dice que [CS:N]Cresselia[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="This Pokémon is said to possess\na mystical power that can banish darkness.", french="On dit que ce Pokémon possède\nun pouvoir mystique capable de bannir\nl'ombre.", german="Man sagt, dieses Pokémon habe\neine mystische Kraft, die Dunkelheit\nbannen könne.", italian="Si mormora che questo Pokémon\nabbia un potere magico in grado di scacciare\nl'oscurità.", spanish="Tiene un poder místico capaz\nde desterrar la oscuridad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The power to banish darkness...", french=" La puissance de bannir l'ombre...", german=" Die Kraft, Dunkelheit zu bannen...", italian="Il potere di scacciare\nl'oscurità...", spanish="El poder de desterrar la\noscuridad..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The power to banish darkness...", french=" La puissance de bannir l'ombre...", german=" Die Kraft, Dunkelheit zu bannen...", italian="Il potere di scacciare\nl'oscurità...", spanish="El poder de desterrar la\noscuridad..."})
  else
  SkySceneKit.say({english=" The power to banish darkness...", french=" La puissance de bannir l'ombre...", german=" Die Kraft, Dunkelheit zu bannen...", italian="Il potere di scacciare\nl'oscurità...", spanish="El poder de desterrar la\noscuridad..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 232, 176, Direction.Left, "NPC_HEIGANI")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! So let's get this\nstraight.[K] If we don't do something...", french="Eh dis donc! Je veux être sûr\nde bien comprendre.[K] Si on ne fait rien...", german="Hey, hey! Nur, damit ich es nicht\nfalsch verstehe.[K] Wenn wir nichts\nunternehmen...", italian="Ehi, ehi! Fatemi capire.[K]\nSe non facciamo qualcosa...", spanish="¡Oye, oye! A ver si me aclaro...[K]\nSi no hacemos algo..."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="All the Pokémon in the world\nare going to fall asleep forever?", french="... tous les Pokémon du monde\nvont s'endormir pour l'éternité?", german="Dann werden alle Pokémon der\nWelt für immer einschlafen?", italian="... tutti i Pokémon del mondo\nsi addormenteranno per sempre?", spanish="¿Todos los Pokémon de este\nmundo se quedarán dormidos para toda\nla eternidad?"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! That means we have to\ndo something now to fix the space distortion!", french="Eh dis donc! Ça veut dire qu'il\nfaut faire quelque chose tout de suite\npour résoudre ce problème de distorsion!", german="Hey, hey! Das bedeutet, wir\nmüssen jetzt etwas tun, um die Verzerrung des\nRaumes zu beheben!", italian="Ehi, ehi! Significa che dobbiamo\nsubito metterci all'opera per sistemare la\ndistorsione dello spazio!", spanish="¡Oye, oye! ¡Hay que hacer algo\npara arreglar la deformación del espacio!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 208, 208, Direction.UpLeft, "NPC_SURIIPU")
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Hey, [partner].", french=" Dis, [partner].", german=" Hey, [partner].", italian=" Ehi, [partner].", spanish=" Oye, [partner]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_suriipu, 4) end)
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 176, 216, Direction.Up, "NPC_DOGOOMU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_suriipu, 4) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 224, 200, Direction.UpLeft, "NPC_KIMAWARI")
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 136, 208, Direction.UpRight, "NPC_CHIRIIN")
  GROUND:EntTurn(npc_npc_chiriin, Direction.Right)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 136, 160, Direction.DownRight, "NPC_PUKURIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_suriipu, 4) end)
  GROUND:EntTurn(npc_npc_heigani, Direction.DownLeft)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 136, 184, Direction.Right, "NPC_BIPPA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_suriipu, 4) end)
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 208, 168, Direction.DownLeft, "NPC_MARIRU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_suriipu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Did [CS:N]Cresselia[CR] say anything\nabout...", french=" Est-ce que [CS:N]Cresselia[CR] a dit...", german="Sagte [CS:N]Cresselia[CR] zufällig\netwas von...", italian="[CS:N]Cresselia[CR] vi ha detto\nqualcosa...", spanish=" ¿Dijo [CS:N]Cresselia[CR] algo sobre...?"})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="how the distortion of space can\nbe stopped?", french="... comment on pouvait annuler\nla distorsion?", german="Nun, sagte sie etwas darüber,\nwie die Verzerrung des Raumes aufgehalten\nwerden kann?", italian="Vi ha detto come arrestare la\ndistorsione dello spazio?", spanish="¿Cómo se podría detener esa\ndeformación del espacio?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wh-what?! Er...[K]how to stop the\ndistortion of space?!", french="Qu... quoi?! Euh...[K] Comment\nannuler la distorsion de l'espace?!", german="W-was?!?[K] Wie man die\nVerzerrung des Raumes aufhalten kann?!?", italian="C-Cosa?! Ehm...[K] Come fermare\nla distorsione dello spazio?!", spanish="¿Quéee? Esto...[K] ¿Sobre cómo\ndetener la deformación del espacio?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wh-what?! Er...[K]how to stop the\ndistortion of space?!", french="Qu... quoi?! Euh...[K] Comment\nannuler la distorsion de l'espace?!", german="W-was?!?[K] Wie man die\nVerzerrung des Raumes aufhalten kann?!?", italian="C-Cosa?! Ehm...[K] Come fermare\nla distorsione dello spazio?!", spanish="¿Quéee? Esto...[K] ¿Sobre cómo\ndetener la deformación del espacio?"})
  else
  SkySceneKit.say({english="Wh-what?! Er...[K]how to stop the\ndistortion of space?!", french="Qu... quoi?! Euh...[K] Comment\nannuler la distorsion de l'espace?!", german="W-was?!?[K] Wie man die\nVerzerrung des Raumes aufhalten kann?!?", italian="C-Cosa?! Ehm...[K] Come fermare\nla distorsione dello spazio?!", spanish="¿Quéee? Esto...[K] ¿Sobre cómo\ndetener la deformación del espacio?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Waaah![K] Wh-why are you jumpy?", french="Ouah![K] Mais pourquoi êtes-vous\nsi fébriles, vous deux?", german="Uaaah![K] Warum bist du so\nhibbelig?", italian="Waaah![K] Perché\ntanto nervosismo?", spanish=" ¡Eh![K] ¿Por qué tantos nervios?"})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" D-did I ask something weird...?", french="Euh... est-ce que ma question\nvous paraît déplacée...?", german="H-hab ich dich irgendwas\nSeltsames gefragt?", italian="H-Ho chiesto\nqualcosa di strano...?", spanish=" ¿He preguntado algo extraño?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" N-no. It's nothing you said.", french=" Non... non. Ça n'a rien à voir.", german="N-nein. Das hat nichts mit dem\nGesagten zu tun.", italian="N-No. Non ha niente a che vedere\ncon quello che hai detto.", spanish="No... No te preocupes.\nNo ha sido por lo que has dicho."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" N-no. It's not what you said.", french=" Non... non. Ça n'a rien à voir.", german="N-nein. Das hat nichts mit dem\nzu tun, was du gesagt hast.", italian="N-No. Non ha niente a che vedere\ncon quello che hai detto.", spanish="No... No te preocupes.\nNo ha sido por lo que has dicho."})
  else
  SkySceneKit.say({english=" N-no. It isn't anything you said.", french=" Non... non. Ça n'a rien à voir.", german="N-nein. Das Gesagte hat nichts\ndamit zu tun.", italian="N-No. Non ha niente a che vedere\ncon quello che hai detto.", spanish="No... No te preocupes.\nNo ha sido por lo que has dicho."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Sorry.[K] I was just thinking about\nsomething else...", french="Désolé.[K] Je pensais à autre\nchose...", german="Tut mir leid.[K] Ich habe gerade an\netwas anderes gedacht...", italian="Scusa.[K] Stavo pensando a\nun'altra cosa...", spanish="Lo siento.[K] Estaba pensando en\notra cosa..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Sorry.[K] I was thinking about\nsomething else...", french="Désolé.[K] Je pensais à autre\nchose...", german="Tut mir leid.[K] Ich habe gerade an\netwas anderes gedacht...", italian="Scusa.[K] Stavo pensando a\nun'altra cosa...", spanish="Lo siento.[K] Estaba pensando en\notra cosa..."})
  else
  SkySceneKit.say({english="I'm sorry.[K] I was thinking about\nsomething else...", french="Désolée.[K] Je pensais à autre\nchose...", german="Tut mir leid.[K] Ich habe gerade an\netwas anderes gedacht...", italian="Scusa.[K] Stavo pensando a\nun'altra cosa...", spanish="Lo siento.[K] Estaba pensando en\notra cosa..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So, uh...[K]a way of stopping the\ndistortion of space...", french="Alors, euh...[K] le moyen d'annuler\nla distorsion de l'espace...", german="So, ähem...[K] Ein Weg, um die\nVerzerrung des Raumes aufzuhalten...", italian="Quindi, eh...[K] Un modo per\nfermare la distorsione dello spazio...", spanish="Entonces...[K] queréis saber si dijo\nalgo acerca de cómo detener la deformación\ndel espacio..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So, uh...[K]a way of stopping the\ndistortion of space...", french="Alors, euh...[K] le moyen d'annuler\nla distorsion de l'espace...", german="So, ähem...[K] Ein Weg, um die\nVerzerrung des Raumes aufzuhalten...", italian="Quindi, eh...[K] Un modo per\nfermare la distorsione dello spazio...", spanish="Entonces...[K] queréis saber si dijo\nalgo acerca de cómo detener la deformación\ndel espacio..."})
  else
  SkySceneKit.say({english="So, uh...[K]a way of stopping the\ndistortion of space...", french="Alors, euh...[K] le moyen d'annuler\nla distorsion de l'espace...", german="So, ähem...[K] Ein Weg, um die\nVerzerrung des Raumes aufzuhalten...", italian="Quindi, eh...[K] Un modo per\nfermare la distorsione dello spazio...", spanish="Entonces...[K] queréis saber si dijo\nalgo acerca de cómo detener la deformación\ndel espacio..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ........................", french=" ........................", german=" ........................", italian=" ........................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ........................", french=" ........................", german=" ........................", italian=" ........................", spanish=" ..."})
  else
  SkySceneKit.say({english=" ........................", french=" ........................", german=" ........................", italian=" ........................", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hmm...[K] Nope! I don't remember\n[CS:N]Cresselia[CR] saying a single thing about that!", french="Hum...[K] Non! Je ne me rappelle\npas que [CS:N]Cresselia[CR] ait dit quoi que ce soit\nà propos de ça!", german="Hmm...[K] Nö! Ich erinnere mich\nnicht, dass [CS:N]Cresselia[CR] etwas dazu gesagt hätte!", italian="Mmm...[K] No! [CS:N]Cresselia[CR] non ha\ndetto niente al riguardo!", spanish="Hum...[K] ¡No! ¡No recuerdo que\n[CS:N]Cresselia[CR] dijera nada de eso!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hmm...[K] Nope! I don't remember\n[CS:N]Cresselia[CR] saying a single thing about that!", french="Hum...[K] Non! Je ne me rappelle\npas que [CS:N]Cresselia[CR] ait dit quoi que ce soit\nà propos de ça!", german="Hmm...[K] Nö! Ich erinnere mich\nnicht, dass [CS:N]Cresselia[CR] etwas dazu gesagt hätte!", italian="Mmm...[K] No! [CS:N]Cresselia[CR] non ha\ndetto niente al riguardo!", spanish="Hum...[K] ¡No! ¡No recuerdo que\n[CS:N]Cresselia[CR] dijera nada de eso!"})
  else
  SkySceneKit.say({english="Hmm...[K] Nope! I don't remember\n[CS:N]Cresselia[CR] saying a single thing about that!", french="Hum...[K] Non! Je ne me rappelle\npas que [CS:N]Cresselia[CR] ait dit quoi que ce soit\nà propos de ça!", german="Hmm...[K] Nö! Ich erinnere mich\nnicht, dass [CS:N]Cresselia[CR] etwas dazu gesagt hätte!", italian="Mmm...[K] No! [CS:N]Cresselia[CR] non ha\ndetto niente al riguardo!", spanish="Hum...[K] ¡No! ¡No recuerdo que\n[CS:N]Cresselia[CR] dijera nada de eso!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Ah, I see...[K] That is unfortunate...", french=" Ah, je vois...[K] Dommage...", german="Ah, verstehe...[K] Das ist\nbedauerlich...", italian=" Ah, capisco...[K] Peccato...", spanish=" En fin...[K] Qué lástima..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(4), p.Y+(4), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Well, anyway! ♪", french=" Enfin bref! ♪", german=" Na ja, was soll's! ♪", italian=" Beh, non scoraggiamoci! ♪", spanish=" ¡Bueno! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_suriipu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Let's look into the distortion\nof space together! ♪", french="Nous devons enquêter sur\nla distorsion de l'espace tous ensemble! ♪", german="Schauen wir uns die Verzerrung\ndes Raumes einmal gemeinsam an! ♪", italian="Dobbiamo occuparci del\nproblema tutti insieme! ♪", spanish="¡Investiguemos todos juntos\nla deformación del espacio! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="If we don't, we won't be able to\nstop the nightmare from spreading! ♪", french="Sinon, nous ne pourrons pas\nempêcher le cauchemar de s'étendre! ♪", german="Wenn wir das nicht tun, können\nwir die Ausbreitung des Albtraums nicht\nverhindern! ♪", italian="Se non lo facciamo, non saremo\nin grado di fermare la diffusione\ndell'incubo! ♪", spanish="¡Si no, no lograremos detener\nel avance de la pesadilla! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Y-yes, Guildmaster!", french=" Oui... oui, Maître!", german=" J-ja, Gildenmeister!", italian=" S-Sì, Capitano!", spanish=" ¡Sí, Gran Bluff...!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="All right, everyone![K] We'll\ndisband for the day.", french="Ecoutez, vous autres![K] Vous\npouvez disposer pour l'instant.", german="Alles klar, Leute![K] Wir gehen für\nheute auseinander.", italian="Molto bene, gente![K] È tutto\nper oggi.", spanish=" ¡De acuerdo![K] Ya podemos irnos."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And starting tomorrow, you are\nto individually investigate the distortion\nof space itself!", french="A partir de demain, vous allez\ntous enquêter sur la distorsion de l'espace!", german="Und ab morgen forscht jeder\nindividuell nach, was es mit der Verzerrung\ndes Raumes selbst auf sich hat!", italian="E da domani, il vostro\ncompito sarà indagare sulla distorsione\ndello spazio!", spanish="Y a partir de mañana todos a\ninvestigar. ¡Cada uno por su cuenta!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Yup yup! Will do!", french=" Ouaip ouaip! J'ai tout pigé!", german=" Jawollja! Wird erledigt!", italian=" Già, già! Va bene!", spanish=" ¡Sí, señor! ¡A la orden!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" All right, dismissed!", french=" Très bien, rompez!", german=" Alles klar, wegtreten!", italian=" D'accordo, potete andare!", spanish=" ¡De acuerdo, retiraos!"})
  -- message_Close
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
