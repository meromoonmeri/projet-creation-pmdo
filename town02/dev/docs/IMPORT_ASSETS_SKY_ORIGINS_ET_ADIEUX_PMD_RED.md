# Guide d'Importation EsEo (Explorers of Sky Origins) & Chorégraphie des Adieux de PMD Red
## Intégration Native des Décors d'Explorateurs du Ciel et Restitution Émotionnelle de la Scène de PMD Rouge

Ce document rassemble les analyses techniques et structurelles permettant d'intégrer de manière invisible les richesses graphiques d'**Explorers of Sky Origins (EsEo)** et de recréer à la perfection la scène d'adieux légendaire de **PMD Rouge (pret/pmd-red)** au sommet de la Colline des Anciens.

---

## PARTIE 1 — Intégration Invisible des Assets d'Explorers of Sky Origins (EsEo)

L'importation de décors, de paysages et de structures de donjons depuis le projet de remake `Minemaker0430/ExplorersOfSkyOrigins` (et sa bibliothèque sœur `slothplaysnecro/PMDO-Explorers-Maps`) doit être menée de manière à ce que le joueur croie fermement qu'il s'agit de contenu natif à *New Era*.

### 1. Structure des Décors de Fond (Scenery & Backgrounds)
Dans le moteur RogueEssence/PMDO, les images de paysages de fond (paysages de cinématiques, écrans de titre, panoramas) sont stockées sous forme de dossiers de ressources dans `Content/BG/` (ex: `Content/BG/Title_Screen_Background.dir`).
*   Chaque dossier `.dir` de `Content/BG/` contient l'image PNG désaturée/découpée et un fichier de configuration XML décrivant les calques, les vitesses de défilement (*parallax*) et les offsets.
*   **Méthode d'Importation Propre** :
    1.  Extraire les dossiers de paysages de fond depuis `ExplorersOfSkyOrigins/Content/BG/` (ex: le paysage de la Plage au crépuscule `Dusk_Beach.dir` ou de la colline `Hill_Of_The_Ancients.dir`).
    2.  Les copier dans `Content/BG/` de *New Era*.
    3.  Les déclarer dans `Content/ContentParams.xml` sous la catégorie `<Backgrounds>` pour que le moteur puisse charger les textures au lancement.

### 2. Intégration Intelligente des Donjons EsEo
Pour que les donjons de Pokémon Sky se fondent dans l'ambiance *New Era*, ils ne doivent pas être de simples copier-coller linéaires. Ils doivent adopter notre structure en trois segments, avec des variations de géométrie et des spawn tables cohérentes :
*   **La gradation visuelle via les BGs de couloirs** : EsEo utilise des fichiers d'art de couloirs alternatifs. En important ces pièces d'art de couloirs dans `Content/Tile/`, nous pouvons modifier la structure de rendu des murs du donjon pour qu'à chaque segment franchi, le joueur voie les piliers de pierre se craqueler ou se couvrir de mousse.
*   **Règle de fusion des zones** : Chaque zone importée de Sky (ex: *Grotte de Vapeur*, *Faille Spatiale*) doit être déclarée dans `Data/Zone/` sous le namespace `halcyon` et son point d'entrée unique enregistré dans `master_zone.json` et `index.idx` pour éviter tout crash de type NRE ou désynchronisation de carte.

---

## PARTIE 2 — La Scène d'Adieux Classique de PMD Rouge (pret/pmd-red)

Dans `pret/pmd-red`, la scène des adieux est l'un des sommets d'émotion de l'histoire. Elle ne se déroule pas dans un lit ou sur une place quelconque, mais à la **Colline des Anciens (Hill of the Ancients)**, l'autel sacré situé au-dessus du Grand Canyon, là où réside Xatu.

### Le Déroulement Canonique et sa Transcription dans New Era

Après la destruction de la météorite par Rayquaza au sommet de la Tour Céleste, le Héros et son Partenaire sont projetés au sol, épuisés. Ils se réveillent à la **Colline des Anciens**, entourés de tous les Pokémon qu'ils ont rencontrés et secourus durant leur voyage (la ville entière de Metano, l'équipe d'Alakazam, etc.), qui célèbrent la fin des catastrophes climatiques.

Soudain, la réalité physique de la dimension s'impose : la mission du Héros est accomplie, son âme d'humain doit quitter ce monde. Le processus de disparition s'enclenche devant tous ses amis réunis.

### Directives de Mise en Scène et Chorégraphie en Lua (`autel_celeste/init.lua` ou `colline_anciens/init.lua`)

Voici comment nous codons cette scène pour restituer exactement l'émotion de PMD Rouge sous RogueEssence :

```lua
-- Extrait de la cinématique des Adieux à la Colline des Anciens
function colline_anciens.PlayRedRescueFarewell()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  
  -- Tous les amis sont disposés en cercle sur la Colline des Anciens
  local alakazam = CH('Alakazam')
  local charizard = CH('Charizard')
  local tyranitar = CH('Tyranitar')
  local xatu = CH('Xatu')
  local wigglytuff = CH('Wigglytuff')
  
  GAME:CutsceneMode(true)
  
  -- Le Héros commence à briller. Première phase de scintillement.
  SOUND:PlaySE("DUN_Light_Screen")
  GAME:FadeOut(false, 10)
  GAME:WaitFrames(10)
  GAME:FadeIn(10)
  
  -- Tous les visages se tournent vers le Héros (Stupeur collective)
  local foule = {partner, alakazam, charizard, tyranitar, xatu, wigglytuff}
  for _, pnj in ipairs(foule) do
    if pnj ~= nil then
      GROUND:CharAnimateTurn(pnj, Direction.DownLeft, 4) -- Tous orientés vers le héros
      GROUND:CharSetAnim(pnj, 'Surprised', true)
    end
  end
  
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue("Héraut... ?[pause=20] Regarde tes pattes...[pause=15] Pourquoi tu brilles comme ça ?")
  
  -- Le Héros regarde son corps. Il s'élève lentement dans les airs.
  -- Sous RogueEssence, on utilise un décalage d'offset vertical (Y) pour le faire flotter.
  SOUND:PlaySE("DUN_Reflect")
  local offset_y = 0
  for i = 1, 40 do
    offset_y = offset_y - 1
    GROUND:CharSetOffsetY(hero, offset_y) -- Le héros s'élève de 40 pixels au-dessus du sol
    BossFX.SpawnGlowParticles(hero, "LightGold", 2)
    GAME:WaitFrames(2)
  end
  
  -- Rayquaza parle par télépathie depuis le ciel étoilé
  UI:ResetSpeaker(false)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "Rayquaza", 384, "", false)
  UI:WaitShowDialogue("Humain... Ta tâche en ce monde est accomplie.[pause=25] Le flux dimensionnel te rappelle à ton époque d'origine.")
  
  -- Le Partenaire tente de sauter pour le rattraper, mais retombe au sol (Crying)
  GROUND:CharSetAnim(partner, 'Run', true)
  GAME:WaitFrames(15)
  GROUND:CharSetAnim(partner, 'Crying', true)
  
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue("Non...[pause=15] Attends ! Ne t'en va pas ![pause=20] On vient juste de sauver le monde !")
  UI:WaitShowDialogue("On s'est promis de rester ensemble...[pause=20] Je t'en supplie, héraut, ne me laisse pas seul ici !")
  
  -- Le Héros, flottant parmi les étoiles, adresse un dernier adieu télépathique collectif.
  -- Des lignes de dialogue apparaissent à l'écran sans portrait, représentant la pureté de son esprit.
  UI:SetSpeaker(hero)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue("Merci à vous tous...[pause=20] Équipe Alakazam, Grodoudou, Xatu...[pause=15] Merci de m'avoir fait confiance.")
  UI:WaitShowDialogue("Et à toi, mon précieux partenaire...[pause=25] Ne pleure pas. Tu as prouvé au monde entier à quel point tu es fort.")
  UI:WaitShowDialogue("Même si je disparais dans le ciel étoilé...[pause=20] notre amitié brillera pour toujours dans l'éternité.")
  
  -- Le Héros explose doucement en une magnifique constellation de particules scintillantes
  SOUND:PlaySE("DUN_Fling_Throw")
  BossFX.SpawnMassiveGlowParticles(hero, "LightGold", 120)
  GROUND:Hide('PLAYER') -- Le héros disparaît de la carte
  
  GAME:WaitFrames(60)
  
  -- Le Partenaire lève la tête vers les étoiles, pleurant toutes les larmes de son corps
  GROUND:CharAnimateTurn(partner, Direction.Up, 4)
  GAME:WaitFrames(30)
  
  -- La foule garde un silence solennel. Alakazam baisse la tête, Xatu ferme les yeux.
  if alakazam ~= nil then GROUND:CharSetAnim(alakazam, 'Sad', true) end
  if xatu ~= nil then GROUND:CharSetAnim(xatu, 'Sad', true) end
  
  SOUND:PlaySE("DUN_Cry_Melancholy")
  UI:SetSpeaker(partner)
  UI:WaitShowDialogue("HÉRAUT !!![pause=60]")
  
  -- Fondu noir final menant aux crédits
  GAME:FadeOut(false, 120)
  GAME:WaitFrames(60)
  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("credits_screen", "Main_Entrance_Marker", true)
end
```

### Éléments Clés de Restitution Émotionnelle
1.  **L'Élévation Physique (Offset Y)** : Le fait que le sprite du Héros s'élève lentement au-dessus du sol par incrément de pixel (`GROUND:CharSetOffsetY`) crée un effet d'envol divin et poignant, identique au moteur GBA.
2.  **La Constellation de Particules** : L'utilisation intensive des émetteurs de particules dorées (`BossFX.SpawnMassiveGlowParticles`) pendant sa disparition donne l'impression qu'il fusionne avec la nuit étoilée de la Colline des Anciens.
3.  **Les Regards de la Foule Réunie** : Avoir toute la communauté témoin de ce sacrifice et réagissant en direct (Alakazam affaissé, Xatu immobile, Grodoudou triste) démultiplie l'impact dramatique pour le joueur.
