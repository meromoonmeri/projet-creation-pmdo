# Manifeste Narratif & Guide Cinématographique Ultime : L'Apogée d'Abyss to Ascension
## Spécification de la Confrontation d'Ultra-Necrozma et de la Séquence des Adieux (*Farewell*)

Ce document constitue la charte artistique, émotionnelle et technique suprême pour la réalisation de la dernière partie du mod *New Era: Abyss to Ascension* (Chapitres 10 à la Conclusion). Il transcrit les directives de la Charte Nintendo-Grade en instructions de mise en scène précises sous le moteur RogueEssence/PMDO.

---

## I. L'ADN de Pokémon Donjon Mystère : Philosophie et Rythme

Notre objectif est de recréer l'enchantement et les larmes de notre enfance. Pour que l'émotion fonctionne, elle doit s'appuyer sur un contraste permanent :
1.  **L'Humour et le Quotidien** : Les disputes ridicules des marchands, les maladresses des enfants d'Axoloto, et les sarcasmes de la Team Dazzling sont indispensables. Sans ces moments de joie et de légèreté, la tristesse du final n'aurait aucun poids.
2.  **La Menace Muette** : Le monde ne s'effondre pas d'un coup. Il s'éteint par petites touches (la poussière dans l'air, le tarissement des fontaines, le silence des oiseaux).
3.  **L'Évolution des Liens** : Le Partenaire commence comme un être craintif et dépendant, mais au fil des chapitres (et particulièrement pendant l'Arc Fugitif), il devient le pilier spirituel du duo, préparant ainsi le déchirement du final.

---

## II. Chapitre 10 au Climax : La Montée des Enjeux

À partir du Chapitre 10, le dôme de brume et d'électricité statique s'étend sur toute la carte du monde. Le sentiment d'isolement et de condamnation doit imprégner chaque ruelle de Metano Town :

*   **Le Dérèglement Temporel** : Les cycles jour/nuit (`TownNight.lua`) se dérèglent. Le ciel reste bloqué dans une pénombre monochrome perpétuelle.
*   **La Paranoïa Finale** : La Fédération barricade le village. Les dialogues de tous les PNJ (`metano_town_ch_10.lua`) reflètent la peur de l'inconnu, la méfiance envers le Héros (toujours accusé d'avoir provoqué la colère céleste) et le désespoir.
*   **L'Ascension de l'Abîme** : Le donjon final menant à la faille dimensionnelle est une route de **80 étages**, caractérisée par une distorsion visuelle de l'espace (les décors se fissurent et laissent apparaître le vide étoilé sous forme de calques parallaxes mouvants).

---

## III. La Dimension Monochrome : Le Monde Figé

La confrontation finale se déroule dans la **Dimension de l'Abîme**, un lieu en ruines évoquant le futur dévasté d'Explorateurs du Ciel :
*   **Identité Visuelle** : Palette graphique entièrement désaturée (monochrome, noir et blanc, avec uniquement les yeux d'Ultra-Necrozma qui brillent d'un éclat doré aveuglant pour symboliser la lumière volée au monde).
*   **Ambiance Sonore** : Un silence lourd interrompu uniquement par des souffles de vent sourds et une mélodie de boîte à musique mélancolique, désaccordée, jouée en boucle lente.
*   **Géométrie du Donjon** : Salles asymétriques, colonnes brisées flottant dans le vide, absence totale de lignes droites. Les Pokémon sauvages sont des formes spectrales et corrompues de haut niveau (Niveaux 60-70).

---

## IV. Le Combat Suprême contre Ultra-Necrozma

Ce duel est l'aboutissement de toute la progression de gameplay et de narration :
*   **Phase 1 (Le Gardien du Vide)** : Combat tactique difficile. Ultra-Necrozma utilise des capacités de zone qui modifient le sol de l'arène, forçant le joueur et son partenaire à se déplacer constamment.
*   **Phase 2 (Le Cri de la Lumière)** : À 50% de ses PV, une cinématique en plein combat s'enclenche. Ultra-Necrozma absorbe l'énergie spirituelle du Partenaire. L'écran tremble violemment (`GAME:MoveCamera`), un flash blanc aveugle le joueur, et la musique de combat explose dans une orchestration symphonique déchirante.
*   **La Victoire** : Ultra-Necrozma s'effondre dans un cri de cristal strident, se dissipant en une onde de choc lumineuse qui balaye la dimension monochrome, ramenant instantanément les couleurs et la vie sur le monde réel.

---

## V. La Séquence des Adieux (*Farewell*) — Spécification Cinématique

C'est le moment le plus marquant du jeu. Inspiré de l'émotion de PMD Explorateurs du Ciel, cette scène doit être réalisée avec une sobriété absolue : **privilégier les regards, les silences, les mouvements de caméra et les larmes plutôt que de longues lignes de dialogue.**

### Cadrage et Directives Techniques sous RogueEssence

```lua
-- Extrait de la logique cinématique finale
function climax_aftermath.PlayFarewellScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  
  GAME:CutsceneMode(true)
  GAME:MoveCamera(272, 280, 1, false) -- Cadrage serré sur le duo
  
  -- Le Héros s'arrête brusquement de marcher
  GROUND:CharSetAnim(hero, 'Idle', true)
  GAME:WaitFrames(40)
  
  -- Le Partenaire fait deux pas, remarque l'arrêt du Héros, et se retourne
  GROUND:CharAnimateTurn(partner, Direction.Down, 4)
  GAME:WaitFrames(20)
  
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("...?[pause=15] Qu'est-ce qu'il y a, héraut ?[pause=20] Pourquoi tu t'arrêtes ?")
  UI:WaitShowDialogue("On a réussi...[pause=10] Regarde le ciel ![pause=15] Les couleurs sont revenues !")
  
  -- Le Héros baisse la tête (Animation de tristesse/résignation)
  GROUND:CharSetAnim(hero, 'Sad', true)
  GAME:WaitFrames(60)
  
  -- Les premières particules de lumière s'échappent du Héros
  SOUND:PlaySE("DUN_Reflect") -- Son doux et cristallin
  BossFX.SpawnGlowParticles(hero, "LightGold", 20) -- Particules lumineuses qui montent
  
  -- Le Partenaire fait un pas en arrière (Surpris)
  GROUND:CharAnimateTurn(partner, Direction.Down, 4)
  SOUND:PlaySE("DUN_Surprise")
  GeneralFunctions.SetEmotion("Surprised")
  GAME:WaitFrames(10)
  
  UI:WaitShowDialogue("Mais...[pause=20] qu'est-ce qui t'arrive ?[pause=30] Ton corps...[pause=15] il brille...")
  
  -- Le Héros regarde le partenaire avec un sourire triste (Émotion : Inspired)
  GROUND:CharSetAnim(hero, 'Inspired', true)
  GAME:WaitFrames(30)
  
  UI:SetSpeaker(hero)
  UI:WaitShowDialogue("Ma mission ici est terminée...[pause=25] Le monde est sauvé.[pause=30] Mais la distorsion dimensionnelle prend fin... et je ne peux plus rester dans cette époque.")
  
  -- Le Partenaire s'approche en courant, mais traverse la collision intangible du Héros
  GROUND:CharSetAnim(partner, 'Run', true)
  -- Mouvement rapide du partenaire vers le héros, qui s'arrête en pleurs
  SOUND:PlaySE("DUN_Hit_Weak")
  GROUND:CharSetAnim(partner, 'Crying', true)
  
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue("Non...[pause=20] NON ![pause=25] C'est impossible !")
  UI:WaitShowDialogue("Tu ne peux pas partir comme ça...[pause=20] Pas après tout ce qu'on a traversé !")
  UI:WaitShowDialogue("On est une équipe, pas vrai ?![pause=20] On s'est promis de toujours rester ensemble ! S'il te plaît... ne m'abandonne pas...")
  
  -- Pause de caméra : zoom lent sur les visages (80 frames de silence)
  GAME:WaitFrames(80)
  
  -- Le Héros fait un dernier pas, pose sa patte intangible près du partenaire
  UI:SetSpeaker(hero)
  UI:WaitShowDialogue("Merci d'avoir été mon ami...[pause=30] Grâce à toi, j'ai compris ce que signifiait avoir un vrai foyer.")
  UI:WaitShowDialogue("Continue de veiller sur Metano...[pause=25] et sur notre guilde.[pause=30] Je ne t'oublierai jamais.")
  
  -- Le Héros se dissipe entièrement sous forme de particules d'or qui s'élèvent vers le ciel bleu
  SOUND:PlaySE("DUN_Fling_Throw")
  GAME:FadeOut(false, 120) -- Fondu noir très lent et progressif
  BossFX.SpawnMassiveGlowParticles(hero, "LightGold", 100)
  
  GAME:WaitFrames(60)
  
  -- Les pleurs déchirants du partenaire résonnent sur le noir
  SOUND:PlaySE("DUN_Cry_Melancholy")
  UI:SetSpeaker(partner)
  UI:WaitShowDialogue("HÉRAUT !!![pause=60]")
  
  -- Fin de l'aventure principale — Transition vers le générique final
  GAME:EnterGroundMap("credits_screen", "Main_Entrance_Marker", true)
end
```

### Directives d'Animation et de Staging (Farewell)
1.  **Le Silence comme Force** : Entre chaque dialogue des adieux, laisser au moins **40 à 60 frames de vide** sans texte ni bruitage. C'est dans ces silences que s'installe la véritable détresse des personnages.
2.  **La Présence de la Foule** : En arrière-plan, les membres de la Guilde (`Noctowl`, `Tropius`, `Audino`) et les habitants de Metano Town assistent à la scène. Ils ne bougent pas, ils gardent la tête basse, orientés vers le Héros. Aucun d'eux n'intervient, respectant le deuil du Partenaire.
3.  **La Musique des Larmes** : L'accompagnement musical doit être un arrangement épuré au piano solo du thème principal de *New Era*, se terminant sur une note suspendue lors de la disparition totale du Héros.

---

## VI. Garantie de l'Onboarding et Processus Qualitatif

Pour que cet objectif soit atteint, toute future production de code ou de carte sur la fin de l'histoire devra :
1.  **Vérifier chaque ligne de dialogue** par rapport à l'historique émotionnel (Le Héros ne doit jamais paraître détaché ou froid).
2.  **Auditer la caméra et les collisions** (`tools/audit_spatial.py`) pour s'assurer qu'aucun personnage secondaire ne bloque le cadrage dramatique du Partenaire et du Héros.
3.  **Prioriser l'expressivité graphique** en utilisant toutes les émotions de portrait disponibles dans le moteur PMDO pour refléter l'effondrement intérieur du Partenaire.
