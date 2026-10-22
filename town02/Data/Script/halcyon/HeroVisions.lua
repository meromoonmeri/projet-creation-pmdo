--[[
    HeroVisions.lua

    LES VISIONS DU PASSE
    ================================================================
    Le heros de New Era voit des fragments d'un autre temps. Ce ne sont pas
    ses souvenirs : ce sont ceux d'un monde qui a deja vecu tout cela.

    Cinq visions, reprises des moments les plus marquants des jeux officiels
    et rejouees ici comme des echos que le heros ne comprend pas :

      1. LA CHASSE      — un heros accuse, traque par une equipe d'elite.
                          (Rouge/Bleu : la rumeur, puis la traque.)
      2. LA METEORE     — un dragon du ciel brise la pierre qui tombe.
                          (Rouge/Bleu : le sommet de la Tour Celeste.)
      3. LE ROUAGE      — des mecanismes arretes, un monde fige sans soleil.
                          (Ciel : la planete paralysee.)
      4. LE SOMMET      — un gardien du temps affronte deux intrus au faite
                          d'une tour qui s'effondre. (Ciel : le duel final.)
      5. L'EFFACEMENT   — celui qui a tout accompli disparait, et personne
                          ne se souvient de lui. (Ciel : la separation.)

    ------------------------------------------------------------------
    REGLES RESPECTEES
    ------------------------------------------------------------------
    * AUCUN nom propre des jeux d'origine n'est prononce. Ni Dialga, ni
      Rayquaza, ni Alakazam, ni Grovyle, ni Ténéfix. Le joueur RECONNAIT,
      le heros NON. C'est ce qui rend les visions troublantes plutot
      qu'explicatives.
    * Aucun nom interdit du projet.
    * La Voix reste anonyme partout.

    ------------------------------------------------------------------
    CONTRAINTE DE FORMAT PMDO (verifiee, pas supposee)
    ------------------------------------------------------------------
    Le viewport PMDO fait 320x240. Un fond de cinematique doit avoir des
    FRAMES de 320x240 pour couvrir l'ecran sans bande noire ni etirement.
    Les .dir de Content/BG stockent la taille de frame dans leurs 16 derniers
    octets (fw, fh, 0, nbFrames en uint32 little-endian) — ce n'est PAS la
    taille du PNG, qui est une planche de frames.

    Dream_Back et Dream_Front ont des frames de 192x240 : plus ETROITES que
    l'ecran. Ils avaient ete choisis a la premiere ecriture sur leur seul nom
    ('Dream'), sans verifier leurs dimensions — en fond plein ecran ils
    auraient donne des bandes laterales ou une image etiree. Remplaces.

    Fonds valides pour une vision (frame 320x240) :
      Chapter_1..4, Dusknoir, Wanted_Poster, Title_Screen_Background  (1 frame)
      Genesis_Fade (8), Genesis_Cores (12), Genesis_Void (12),
      Genesis_Life (16), Genesis_Mew (16)                       (animes)
    A NE PAS utiliser en plein ecran :
      Dream_Back / Dream_Front (192x240), SE5_Wind_Background (256x256,
      bandeau defilant), Steam (128x128, tuile).

    ------------------------------------------------------------------
    CHOIX TECHNIQUE : texte litteral
    ------------------------------------------------------------------
    Ce module est appele depuis PLUSIEURS grounds differents. Or
    STRINGS.MapStrings ne contient que les cles du ground courant : une cle
    definie dans un seul strings.resx serait introuvable ailleurs.
    On aligne donc sur SuaireArc.lua, module global lui aussi, qui ecrit le
    texte en clair dans le script. C'est le patron sur du projet.
]]
require 'origin.common'
require 'halcyon.VoiceVisions'

HeroVisions = {}

--Table des visions. `ch` = chapitre minimal requis.
--`plates` : les planches. `lines` passe en voix off (pas de boite, pas de
--speaker), format des visions de Ciel.
HeroVisions.LIST = {
  ------------------------------------------------------------------
  -- 1. LA CHASSE — chapitre 3
  ------------------------------------------------------------------
  chasse = {
    ch = 3,
    music = 'Team Skull.ogg',
    level = 2,
    plates = {
      { bg='Wanted_Poster', hold=220, lines={
          "Une affiche, clouée sur un arbre.[pause=25] Un visage dessiné à la hâte.",
          "En dessous, un seul mot revient, écrit trop gros :[pause=20] COUPABLE." } },
      { bg='Chapter_3', hold=200, shake=5, lines={
          "Ils sont quatre à le poursuivre.[pause=20] Des secouristes. Les meilleurs de leur temps.",
          "Ils ne le haïssent pas.[pause=25] Ils croient sincèrement bien faire.[pause=20] C'est pire." } },
      { bg='Genesis_Fade', hold=180, lines={
          "Le fugitif ne se défend pas.[pause=25] Il court, et il pleure,[pause=15] et personne ne l'écoute." } },
    },
    lastWord = "« ...Ils ne m'ont jamais laissé m'expliquer. »",
    heroLine = "(Je ne connais pas ce visage.[pause=20] Alors pourquoi j'ai envie de courir ?)",
    witnessLine = "Hé...[pause=15] Tu es tout pâle.[pause=20] Tu t'es arrêté d'un coup, là.",
  },

  ------------------------------------------------------------------
  -- 2. LA METEORE — chapitre 5
  ------------------------------------------------------------------
  meteore = {
    ch = 5,
    music = 'Sky Tower.ogg',
    level = 3,
    plates = {
      { bg='Chapter_2', hold=200, lines={
          "Le ciel est rouge.[pause=25] Une pierre énorme descend, lentement, comme si elle avait tout son temps.",
          "En bas, un monde entier a cessé de respirer." } },
      { bg='Genesis_Void', hold=220, shake=9, lines={
          "Quelque chose monte à sa rencontre.[pause=20] Vert. Immense. Furieux.",
          "L'impact fait un bruit que personne n'oubliera.[pause=30] La pierre se fend en deux." } },
      { bg='Genesis_Fade', hold=180, lines={
          "Des éclats retombent en pluie de feu.[pause=25] Le monde est sauvé.[pause=20] Pour cette fois." } },
    },
    lastWord = "« ...Il a payé pour nous, et nous ne savons même pas son nom. »",
    heroLine = "(J'ai senti la chaleur.[pause=25] Sur ma peau. Maintenant. Comment c'est possible ?)",
    witnessLine = "Tu trembles...[pause=20] Tu veux qu'on s'arrête un moment ?",
  },

  ------------------------------------------------------------------
  -- 3. LE ROUAGE — chapitre 7
  ------------------------------------------------------------------
  rouage = {
    ch = 7,
    music = 'Time Gear Remix.ogg',
    level = 2,
    plates = {
      { bg='Genesis_Cores', hold=210, lines={
          "Des rouages tournent dans le vide.[pause=25] Lents. Réguliers. Puis un s'arrête.",
          "Et tout ce qui dépendait de lui s'arrête avec." } },
      { bg='Dusknoir', hold=200, shake=4, lines={
          "Un fleuve figé en pleine chute.[pause=25] Des oiseaux immobiles en plein ciel.",
          "Un monde sans soleil, où plus rien ne pousse et où plus rien ne meurt." } },
    },
    lastWord = "« ...Le temps ne s'est pas arrêté. Il a été retenu. »",
    heroLine = "(Un monde où le temps s'est arrêté...[pause=25] Ce n'est pas une histoire. Je l'ai VU.)",
    witnessLine = "Tu as encore eu un malaise ?[pause=25] Ça fait trois fois cette semaine.",
  },

  ------------------------------------------------------------------
  -- 4. LE SOMMET — chapitre 9
  ------------------------------------------------------------------
  sommet = {
    ch = 9,
    music = 'Temporal Tower.ogg',
    level = 3,
    plates = {
      { bg='Chapter_4', hold=200, lines={
          "Une tour immense, au bout du monde.[pause=25] Elle se fissure de la base au sommet.",
          "Deux silhouettes montent quand même.[pause=20] Elles savent qu'elles ne redescendront pas." } },
      { bg='Dusknoir', hold=210, shake=10, lines={
          "Au sommet, quelque chose les attend.[pause=25] Un gardien. Bleu. Enorme. Fou de douleur.",
          "« Vous êtes venus achever ce que vous avez commencé. »[pause=30] Il se trompe.[pause=20] Il ne le saura jamais." } },
      { bg='Genesis_Void', hold=190, lines={
          "Le combat déchire l'air.[pause=25] Ce n'est pas une bataille pour gagner.[pause=20] C'est une bataille pour réparer." } },
    },
    lastWord = "« ...Pardonnez-nous. Nous n'avions pas d'autre chemin. »",
    heroLine = "(Il défendait son monde.[pause=25] Et ils ont dû le combattre pour le sauver.[pause=20] Où est le bien, là-dedans ?)",
    witnessLine = "Reste avec moi.[pause=20] Respire.[pause=25] ...Voilà. Doucement.",
  },

  ------------------------------------------------------------------
  -- 5. L'EFFACEMENT — chapitre 10
  ------------------------------------------------------------------
  effacement = {
    ch = 10,
    music = 'Goodnight.ogg',
    level = 3,
    plates = {
      { bg='Genesis_Life', hold=220, dreamSky=true, lines={
          "Le monde est sauvé.[pause=25] Le soleil se lève sur une plage.",
          "Deux amis regardent la mer.[pause=20] L'un des deux commence à devenir transparent." } },
      { bg='Genesis_Fade', hold=230, dreamSky=true, lines={
          "« Je crois que je vais disparaître. »[pause=30] Il le dit calmement.[pause=20] Comme on annonce la pluie.",
          "L'autre hurle.[pause=25] Il n'y a rien à faire.[pause=20] Il n'y a jamais rien eu à faire." } },
      { bg='Genesis_Void', hold=200, lines={
          "Il s'efface.[pause=30] Et avec lui s'efface le souvenir qu'il ait jamais existé.",
          "Le monde continue, heureux, sauvé,[pause=20] et personne ne sait par qui." } },
    },
    lastWord = "« ...Merci. Pour tout. Vraiment. »",
    heroLine = "(Il a tout donné.[pause=25] Et le monde ne se souvient même pas de son nom.[pause=30] ...Est-ce que ça m'attend, moi aussi ?)",
    witnessLine = "Tu pleures...[pause=25] Qu'est-ce que tu as vu ?[pause=20] Dis-le-moi. S'il te plaît.",
  },
}

--Tente de declencher la vision `id`. Ne joue rien si elle a deja ete vue ou
--si le chapitre requis n'est pas atteint. Renvoie true si elle a ete jouee.
function HeroVisions.TryTrigger(id, witness)
  local v = HeroVisions.LIST[id]
  if v == nil then
    PrintInfo('[HeroVisions] vision inconnue : '..tostring(id))
    return false
  end
  if VoiceVisions.HasSeen(id) then return false end

  local chapter = 0
  pcall(function() chapter = SV.ChapterProgression.Chapter or 0 end)
  if chapter < v.ch then return false end

  return VoiceVisions.PlayOnce(id, {
    literal      = true,
    level        = v.level,
    music        = v.music,
    witness      = witness,
    plates       = v.plates,
    heroLine     = v.heroLine,
    lastWord     = v.lastWord,
    witnessLines = { v.witnessLine },
  })
end

--Combien de visions le heros a-t-il traversees ?
function HeroVisions.Count()
  VoiceVisions.EnsureSV()
  return SV.Visions.Count or 0
end

return HeroVisions
