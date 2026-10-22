-- GÉNÉRÉ par dev/tools/sky_compile_hub_npcs.py — NE PAS ÉDITER À LA MAIN.
-- NPC résidents canoniques du hub s01p02a (enter.sse ROM Sky EU: placements SSA exacts,
-- dialogues enterNN.ssb 5 langues; talk=nil = script ROM sans dialogue compilable, tracé).
local SkySceneKit = require 'halcyon.skyscenes.kit'
local function talk_npc_perippaa1(hero, partner)
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="Hello! Would you like to go on a\nrescue?", french="Salut! Vous voulez partir en\nmission de sauvetage?", german="Hallo! Möchtest du dich auf eine\nRettungsmission begeben?", italian="Ciao! Vuoi fare un tentativo di\nPronto Intervento?", spanish="¡Hola! ¿Queréis iniciar un\nrescate?"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="Greetings![K] Welcome to [CS:P]Pelipper\nIsland[CR].", french="Bonjour![K] Bienvenue sur l'[CS:P]Ile\nBekipan[CR].", german="Grüße![K] Willkommen auf der\n[CS:P]Pelipper-Insel[CR].", italian="Buongiorno![K] Ti do il benvenuto\nall'[CS:P]Isola Pelipper[CR].", spanish="¡Saludos![K] Os doy la bienvenida\na la [CS:P]Isla Pelipper[CR]."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="We [CS:K]Pelipper[CR] will help all your\nrescue efforts.", french="Nous, les [CS:K]Bekipan[CR], nous vous\naiderons dans toutes vos tentatives de\nsauvetage.", german="Wir [CS:K]Pelipper[CR] werden dich bei all\ndeinen Rettungsaktionen unterstützen.", italian="Noi [CS:K]Pelipper[CR] ti saremo d'aiuto\nper le missioni di Pronto Intervento.", spanish="Los [CS:K]Pelipper[CR] os ayudaremos\nen cualquier intento de rescate."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="If you would like to rescue a\nfriend, please return with his or her [CS:E]SOS Mail[CR].", french="Si vous souhaitez secourir un\nami, revenez avec sa [CS:E]Lettre S.O.S.[CR]", german="Falls du einen Freund befreien\nmöchtest, kehre bitte mit ihrem oder seinem\n[CS:E]SOS-Brief[CR] zurück.", italian="Se vuoi salvare un amico,\ndevi avere ricevuto il suo [CS:E]SOS[CR].", spanish="Si queréis rescatar a algún\namigo, venid con su [CS:E]carta de SOS[CR]."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="If you succeed with a rescue,\nwe can provide you with a reward. We hope\nyou do your best.", french="En cas de sauvetage réussi, nous\nvous donnerons certainement une récompense.\nFaites de votre mieux.", german="Falls du bei einer Rettung Erfolg\nhast, können wir dich mit einer Vergütung\nbelohnen. Wir hoffen, du gibst dein Bestes.", italian="Se la missione di Pronto\nIntervento va a buon fine, riceverai una\nricompensa. Fai del tuo meglio.", spanish="Si el rescate tiene éxito,\npodremos daros una recompensa.\nEsperamos que lo hagáis muy bien."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="Oh, yes...[K] You can't recruit new\nmembers to your team while on a rescue.", french="Ah, oui...[K] Vous ne serez pas\nen mesure de recruter de nouveaux\ncoéquipiers pendant une mission de sauvetage.", german="Oh ja.[K] Du kannst keine weiteren\nneuen Team-Mitglieder rekrutieren, während\ndu auf einer Rettungsmission bist.", italian="Ah, già...[K] Durante una missione\ndi soccorso non puoi reclutare nuovi membri\nper la squadra.", spanish="Ah, sí...[K] Recordad que durante\nlos rescates no podéis reclutar nuevos\nmiembros."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="Also, if your team is defeated on\na rescue, you can't call for your own rescue.", french="Et si votre équipe est vaincue\npendant un sauvetage, il vous sera impossible\nde demander de l'aide à votre tour.", german="Ferner kannst du nicht selbst\nHilfe anfordern, wenn dein Team während\neiner Rettungsmission besiegt wird.", italian="Inoltre, se la tua squadra\nviene sconfitta durante un soccorso, non\npotrai ricevere aiuto a tua volta.", spanish="Y también que si vuestro equipo\nes derrotado no podréis pedir a nadie que\nos rescate."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="Items and money you obtain\nduring a rescue must be put in storage if you\nwant to take them out in Treasure Town.", french="Déposez l'argent et stockez les\nobjets obtenus en cours de sauvetage pour\npouvoir les récupérer à Bourg-Trésor.", german="Während Rettungen erworbene\nItems und Geld müssen zum Transfer nach\nSchatzstadt im Speicher abgelegt werden.", italian="Strumenti e soldi ottenuti in una\nmissione di soccorso devono essere depositati\nse vuoi riaverli a Borgo Tesoro.", spanish="Almacenad los objetos y el dinero\nque obtengáis en los rescates si queréis\ndisponer de ellos en Aldea Tesoro."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="Would you like to go on a rescue\nright away?", french="Souhaitez-vous partir en mission\nde sauvetage immédiatement?", german="Möchtest du dich sofort auf eine\nRettungsmission begeben?", italian="Vuoi provare una missione di\nPronto Intervento adesso?", spanish=" ¿Queréis rescatar a alguien?"})
end
return {
  {species="pelipper", x=232, y=120, dir=Direction.Down, name="NPC_PERIPPAA1", talk=talk_npc_perippaa1},
  {species="duskull", x=288, y=152, dir=Direction.DownLeft, name="NPC_YOMAWARU", talk=nil},
  {species="kangaskhan", x=168, y=152, dir=Direction.DownRight, name="NPC_GARUURA", talk=nil},
  {species="chimecho", x=176, y=240, dir=Direction.Down, name="NPC_CHIRIIN", talk=nil},
}
