--[[ Cinématique de retrouvailles sur le panorama nocturne du cliffdaytest.
     Aller : le partenaire traverse Lost Wood seul et arrive au ground où le
     héros est allongé. Il le réveille ; ils regardent la montagne lointaine
     et discutent longuement du paysage et de leur avenir : devenir de grands
     explorateurs, porter secours, découvrir des lieux et trouver des trésors.
     Retour : à la fin de cette discussion, ils retraversent Lost Wood ensemble.
     Échec du retour : bref rappel, puis nouvelle tentative en duo.
     Textes originaux PMD Destiny. Honnêteté : runtime_tested false.
]]

require 'common'

local reveil_nuit = {}

function reveil_nuit.Init(map)
  COMMON.RespawnAllies()
end

function reveil_nuit.Enter(map)
  reveil_nuit.PlotScripting()
end

function reveil_nuit.Exit(map)
end

function reveil_nuit.Update(map)
end

function reveil_nuit.GameSave(map)
end

function reveil_nuit.GameLoad(map)
  reveil_nuit.PlotScripting()
end

local function lancer_retour()
  SV.Destiny = SV.Destiny or {}
  SV.Destiny.LostWoodTrip = 'retour'
  SV.Destiny.LostWoodRetourEchec = false
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  GAME:CutsceneMode(false)
  GAME:EnterDungeon('lost_wood', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function reveil_nuit.PlotScripting()
  SV.Destiny = SV.Destiny or {}
  if SV.Destiny.RetrouvaillesFaites then
    if SV.Destiny.LostWoodTrip == 'retour' and SV.Destiny.LostWoodRetourEchec then
      local partner = CH('Teammate1')
      GAME:CutsceneMode(true)
      UI:SetSpeaker(partner)
      UI:SetSpeakerEmotion("Worried")
      UI:WaitShowDialogue("Le sentier nous a repoussés cette fois. On reprend notre souffle… puis on repart ensemble.")
      UI:SetSpeakerEmotion("Happy")
      UI:WaitShowDialogue("Nous savons maintenant comment nous aider. Lost Wood ne nous séparera pas.")
      lancer_retour()
    end
    return
  end
  reveil_nuit.CinematiqueRetrouvailles()
end

-- ----------------------------------------------------- réveil + discussion

function reveil_nuit.CinematiqueRetrouvailles()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local wake = MRKR('WakeupLocation')
  local overlook = MRKR('ScenicOverlook')
  local entrance = MRKR('Main_Entrance_Marker')

  SOUND:StopBGM()
  GAME:CutsceneMode(true)
  UI:ResetSpeaker()
  AI:DisableCharacterAI(partner)

  -- Le partenaire rentre du premier trajet ; le héros attend, inconscient,
  -- dans le même panorama nocturne. La caméra gardera la montagne en vue.
  GROUND:CharSetAnim(hero, 'Laying', true)
  GROUND:TeleportTo(hero, wake.Position.X, wake.Position.Y, Direction.Right)
  GROUND:TeleportTo(partner, entrance.Position.X, entrance.Position.Y, Direction.Up)
  GAME:MoveCamera(overlook.Position.X, overlook.Position.Y, 1, false)
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(45)
  UI:WaitHideTitle(20)
  GAME:FadeIn(60)
  SOUND:PlayBGM("Welcome to the World of Pokémon!.ogg", true)

  -- Il aperçoit le héros, quitte le chemin et s'approche.
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("J'ai traversé Lost Wood ! Sept étages, du début à la fin… et je suis revenu jusqu'ici !")
  UI:WaitShowDialogue("Je pensais que le plus dur était derrière moi. Mais… attends. Qu'est-ce qui bouge dans l'herbe ?")
  SOUND:PlayBattleSE('EVT_Emote_Exclaim')
  GROUND:CharSetEmote(partner, "exclaim", 1)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Hé ! Tu m'entends ? Tu es blessé ?")
  GROUND:MoveToPosition(partner, wake.Position.X + 24, wake.Position.Y, false, 1)
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("Tu es inconscient… Je ne vais pas te laisser seul au milieu de la nuit.")
  UI:WaitShowDialogue("Allez, réveille-toi. Je suis là. Tu peux ouvrir les yeux.")
  GAME:WaitFrames(40)

  -- Réveil du héros.
  UI:SetSpeaker(hero)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("…Mmh… Ma tête… Qu'est-ce qui s'est passé ?")
  GROUND:CharSetAnim(hero, 'Wake', false)
  GAME:WaitFrames(35)
    UI:WaitShowDialogue("Où suis-je ? Je ne reconnais rien… et je ne me rappelle pas comment je suis arrivé ici.")
  SOUND:PlayBattleSE('EVT_Emote_Confused')
  GROUND:CharSetEmote(hero, "question", 1)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Sigh")
  UI:WaitShowDialogue("Pfiou… tu m'as fait peur. Je reviens tout juste de Lost Wood et je t'ai trouvé là, étendu dans l'herbe.")
  UI:WaitShowDialogue("Tu te souviens de ton nom ? D'un endroit où tu voudrais aller ? De quelqu'un qui t'attend ?")
  UI:SetSpeaker(hero)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Rien. C'est comme si ma mémoire était une page blanche.")
  UI:WaitShowDialogue("Et pourtant, juste avant de me réveiller, j'entendais une voix dans mon rêve…")
  UI:WaitShowDialogue("Elle disait : « Retrouve le chemin que tu as perdu… nos routes finiront par se rejoindre. »")
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Je ne sais pas ce que ça signifie. Mais tu n'as pas à résoudre ça tout seul, pas cette nuit.")
  UI:WaitShowDialogue("D'abord, regarde autour de toi. Laisse tes yeux s'habituer à l'obscurité.")

  -- Déplacement lent vers le point de vue ; le cadre révèle le panorama
  -- nocturne du cliffdaytest, en particulier la montagne à l'horizon.
  GROUND:MoveToPosition(partner, overlook.Position.X, overlook.Position.Y, false, 1)
  GROUND:MoveToPosition(hero, overlook.Position.X - 20, overlook.Position.Y, false, 1)
  GAME:MoveCamera(overlook.Position.X, overlook.Position.Y, 45, false)
  GAME:WaitFrames(45)
  GROUND:CharAnimateTurnTo(partner, Direction.Up, 8)
  GROUND:CharAnimateTurnTo(hero, Direction.Up, 8)
  GAME:WaitFrames(30)

  -- Une discussion en plusieurs temps sur le paysage, le rêve du partenaire,
  -- l'entraide, les secours et les trésors. Environ dix minutes selon le
  -- rythme de lecture et les pauses du joueur.
  local discussion = {
    {partner,"Normal","Tu vois cette grande silhouette sombre, là-bas, derrière les collines ?"},
    {hero,"Normal","La montagne ? Sa cime disparaît dans les nuages."},
    {partner,"Happy","Oui. De jour, on distingue ses pentes. La nuit, elle ressemble à une porte ouverte sur l'inconnu."},
    {hero,"Worried","Elle paraît si loin. Est-ce qu'il y a un chemin qui monte jusque-là ?"},
    {partner,"Normal","Je ne sais pas. C'est justement ce que j'aimerais découvrir un jour."},
    {partner,"Normal","Depuis que je suis petit, je regarde cette montagne en me demandant ce qu'il y a de l'autre côté."},
    {hero,"Normal","Tu rêves de l'explorer ?"},
    {partner,"Happy","Oui. Pas seulement d'y grimper. Je veux comprendre les chemins, les forêts et les vallées qui l'entourent."},
    {partner,"Normal","Je voudrais dessiner une carte assez précise pour que personne ne se perde en route."},
    {hero,"Happy","Une carte qui aiderait tous ceux qui viendront après toi."},
    {partner,"Happy","C'est ça ! Une carte qui ne serait pas juste à moi, mais qui pourrait servir à toute une équipe."},
    {partner,"Worried","Mais quand je pense à partir vraiment, à quitter les sentiers connus… j'ai parfois le trac."},
    {hero,"Normal","Tu avais peur d'entrer dans Lost Wood aussi ?"},
    {partner,"Worried","Un peu. Je me demandais si j'étais assez fort, assez malin, assez courageux."},
    {partner,"Normal","À l'entrée, j'ai failli faire demi-tour. Puis j'ai pensé à tout ce que je ne saurais jamais si je n'essayais pas."},
    {hero,"Happy","Et tu as essayé. Tu as traversé les sept étages et tu es revenu."},
    {partner,"Happy","Oui. Mais un explorateur, ce n'est pas seulement quelqu'un qui revient avec une histoire à raconter."},
    {hero,"Normal","Qu'est-ce que tu veux dire ?"},
    {partner,"Normal","Je veux devenir un grand explorateur pour être utile. Pour aller là où quelqu'un appelle à l'aide, même si le chemin fait peur."},
    {partner,"Worried","Imagine un Pokémon perdu dans la montagne, blessé, sans savoir où trouver la sortie…"},
    {partner,"Normal","Je voudrais pouvoir le retrouver, le rassurer et le ramener auprès des siens."},
    {hero,"Worried","Tu partirais même si tu ne connaissais pas la personne ?"},
    {partner,"Happy","Bien sûr. Quand quelqu'un a besoin d'aide, on n'attend pas de savoir s'il est déjà notre ami."},
    {partner,"Normal","On commence par le secourir. Les présentations pourront attendre le retour."},
    {hero,"Happy","C'est une bonne raison de devenir explorateur."},
    {partner,"Happy","Et il y a aussi les découvertes ! Des endroits que personne n'a encore cartographiés, des passages cachés…"},
    {partner,"Happy","Des trésors enfouis, des objets oubliés, des traces d'anciennes expéditions !"},
    {hero,"Normal","Tu aimerais trouver un trésor ?"},
    {partner,"Normal","Oui, mais pas pour le garder tout seul. Un trésor peut aider une équipe, ou financer une mission de secours."},
    {partner,"Happy","Et puis, avoue : ouvrir un coffre au bout d'un long chemin, ça doit être merveilleux !"},
    {hero,"Happy","Je crois que je comprends. Le trésor, c'est aussi tout le chemin qu'on a fait pour le trouver."},
    {partner,"Happy","Exactement ! Les rencontres, les détours, les cartes qu'on complète… tout ça fait partie de la découverte."},
    {partner,"Worried","Mais il faut aussi savoir quand renoncer. Un bon explorateur ne met pas son équipe en danger juste par orgueil."},
    {hero,"Normal","Alors comment savoir quand continuer et quand s'arrêter ?"},
    {partner,"Normal","On s'écoute. On regarde nos forces, nos provisions, les objets qu'il nous reste et le chemin déjà parcouru."},
    {partner,"Happy","Et surtout, on en parle. À deux, on remarque souvent une chose qu'on n'avait pas vue seul."},
    {hero,"Worried","Je ne me souviens même pas de ce que je sais faire. Je ne sais pas si je peux t'aider."},
    {partner,"Normal","Tu n'as pas besoin de tout savoir dès le premier jour. On apprendra en avançant, et on fera attention l'un à l'autre."},
    {hero,"Worried","Et si je ne retrouve jamais mes souvenirs ?"},
    {partner,"Worried","Alors on vivra avec cette question, un pas après l'autre. Tu n'es pas obligé d'avoir toutes les réponses avant de choisir la suite."},
    {partner,"Normal","La voix de ton rêve te demande de la retrouver. Peut-être qu'en explorant, tu trouveras aussi des indices."},
    {hero,"Normal","Tu crois qu'un explorateur pourrait m'aider à comprendre ce qui m'est arrivé ?"},
    {partner,"Happy","Je crois qu'une équipe peut chercher beaucoup plus loin qu'un Pokémon tout seul."},
    {hero,"Normal","Tu viens juste de traverser Lost Wood sans moi. Pourquoi voudrais-tu repartir avec un inconnu ?"},
    {partner,"Normal","Parce que je t'ai trouvé seul et désorienté. Et parce que je sais ce que c'est que d'hésiter au bord d'un chemin."},
    {partner,"Happy","Je ne te demande pas de me faire confiance aveuglément. Je te propose qu'on avance ensemble et qu'on apprenne à se connaître."},
    {hero,"Worried","Et si je ralentis ton rêve ?"},
    {partner,"Happy","Un rêve qui ne laisse aucune place à un compagnon n'est pas le genre d'aventure que je veux vivre."},
    {partner,"Normal","Secourir, découvrir, trouver des trésors… ces choses-là ont plus de sens quand on peut les partager."},
    {hero,"Happy","Je ne sais pas encore qui j'étais. Mais je veux bien découvrir qui je peux devenir."},
    {partner,"Happy","Alors faisons un premier choix ensemble : nous allons revenir au croisement, tous les deux."},
    {hero,"Normal","Par Lost Wood ? Il faudra retraverser les sept étages ?"},
    {partner,"Normal","Oui. Cette fois, je connais déjà les passages. Mais à deux, on devra rester attentifs l'un à l'autre."},
    {partner,"Normal","On se garde des objets de soin, on surveille nos PP et notre faim, et on ne fonce pas dans chaque combat."},
    {hero,"Happy","Et si l'un de nous ne voit pas l'escalier, l'autre pourra l'aider à le chercher."},
    {partner,"Happy","C'est exactement ça. Une équipe, ce n'est pas deux Pokémon qui marchent côte à côte : c'est deux Pokémon qui veillent l'un sur l'autre."},
    {hero,"Normal","Alors je viens avec toi. Je ne sais pas où ce chemin nous conduira, mais je veux le découvrir."},
    {partner,"Happy","Et moi, je veux voir jusqu'où on peut aller ensemble."},
    {partner,"Happy","Un jour, on atteindra cette montagne. On portera secours à ceux qu'on y trouvera et on découvrira les trésors qu'elle garde."},
    {hero,"Happy","Et on dessinera la route pour que d'autres puissent la suivre après nous."},
    {partner,"Happy","Marché conclu ! Notre première expédition à deux commence par le chemin du retour."},
    {hero,"Normal","Alors, guide-moi. Je marcherai à tes côtés."},
    {partner,"Happy","D'accord. On reprend notre souffle, puis on repart. Cette fois, personne ne traverse Lost Wood seul."},
  }

  for _, ligne in ipairs(discussion) do
    UI:SetSpeaker(ligne[1])
    UI:SetSpeakerEmotion(ligne[2])
    UI:WaitShowDialogue(ligne[3])
  end

  -- Dernier regard vers la montagne, puis seconde traversée à deux.
  GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 8)
  GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 8)
  GAME:WaitFrames(60)
  GROUND:CharAnimateTurnTo(partner, Direction.Down, 8)
  GROUND:CharAnimateTurnTo(hero, Direction.Down, 8)
  GAME:WaitFrames(30)

  SV.Destiny = SV.Destiny or {}
  SV.Destiny.RetrouvaillesFaites = true
  SV.Destiny.LostWoodTrip = 'retour'
  SV.Destiny.LostWoodRetourEchec = false
  COMMON.RespawnAllies()
  lancer_retour()
end

return reveil_nuit
