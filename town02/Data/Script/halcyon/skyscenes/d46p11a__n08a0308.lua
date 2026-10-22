-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D46P11A/n08a0308.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Ooogh...", french=" Aargh...", german=" Uuuuff...", italian=" Oooh...", spanish=" Ay..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Feels like my wounds haven't\nfully healed yet...[K] I'm not at my best...", french="Mes blessures ne sont toujours\npas guéries...[K] Je suis très diminué...", german="Meine Wunden sind wohl noch\nnicht richtig verheilt...[K]\nIch bin noch nicht wieder auf der Höhe...", italian="A quanto pare le mie ferite non\nsono ancora guarite del tutto...[K]\nNon mi sento molto bene...", spanish="Parece que la pelea me ha dejado\nhecho polvo...[K] Me duele todo el cuerpo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I should turn back for now.", french="Je devrais me reposer\npour l'instant.", german=" Ich sollte noch einmal beginnen.", italian="È meglio che torni indietro\nper ora.", spanish="Por ahora tendré que\nretroceder."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D46P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_BARREN_VALLEY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Dusknoir[CR] isn't here...[K] That's\nnot a surprise...", french="[CS:N]Noctunoir[CR] n'est pas là...[K] Comme\nje m'y attendais...", german="[CS:N]Zwirrfinst[CR] ist nicht hier...[K]\nDas überrascht mich kaum...", italian="[CS:N]Dusknoir[CR] non c'è...[K] Ma non\nne sono sorpreso...", spanish="[CS:N]Dusknoir[CR] no está aquí...[K] Eso\nno me extraña, claro."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'd rather avoid another fight\nwith him.", french="J'aimerais autant éviter d'avoir\nà le combattre à nouveau.", german="Ich sollte einen weiteren Kampf\nmit ihm besser vermeiden.", italian="Farei volentieri a meno\ndi scontrarmi con lui un'altra volta.", spanish="La verdad es que preferiría\nno tener que volver a pelear con él."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="The smartest thing I can do is\nsave my strength until I reach [CS:N]Dialga[CR]'s place.", french="La meilleure chose à faire, c'est\nde m'économiser en vue de mon combat contre\n[CS:N]Dialga[CR].", german="Das Beste, was ich jetzt tun\nkann, ist, meine Kräfte zu sparen, bis ich\n[CS:N]Dialga[CR] erreiche.", italian="La cosa migliore è risparmiare\nle forze finché non raggiungo [CS:N]Dialga[CR].", spanish="Lo más inteligente será ahorrar\nenergías para mi encuentro con [CS:N]Dialga[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Right. I'll get prepared and then\nhead out.", french=" Bien. Je me prépare et j'y vais.", german="Gut. Am besten bereite ich mich\ngleich vor und mache mich dann auf den Weg.", italian=" Ok. Ora mi preparo e vado.", spanish="Eso será lo mejor.\nVoy a prepararme antes de partir."})
  -- message_Close
end
