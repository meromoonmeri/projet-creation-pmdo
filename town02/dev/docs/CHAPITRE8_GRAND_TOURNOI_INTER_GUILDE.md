# Spécification de Réalisation & Design : Le Grand Tournoi Inter-Guilde (Chapitre 8)
## Spécifications des 10 Guildes, de la Traque de Zorua et du Quizz de Kirlia

Ce document constitue la charte de design absolue pour le **Chapitre 8**, l'un des chapitres les plus denses et épiques d'*Abyss to Ascension*. Il détaille l'organisation du **Grand Tournoi Inter-Guilde**, le catalogue des 10 guildes invitées, la structure des 3 épreuves espacées de 3 jours, et fournit les modèles de scripts Lua complets pour le Quizz de Kirlia et l'embuscade de Zorua.

---

## 1. Vue d'ensemble du Tournoi (Organisateurs : Spinda, Qulbutoké, Okéoké)

Pour apaiser l'anxiété croissante de la population face aux séismes, **Spinda** décide d'organiser un événement d'exception à Metano Town : **Le Grand Tournoi Inter-Guilde**. Il s'associe à **Qulbutoké (Wobbuffet)** et **Okéoké (Wynaut)** pour la logistique, et invite la célèbre **Guilde de Grodoudou (Bourg Comptoir / Treasure Town)** ainsi que **10 autres guildes venues du monde entier**.

### Le Roster des 10 Nouvelles Guildes Inventées

Chaque guilde possède son propre style de combat, son blason thématique et ses membres phares :

1.  **La Guilde des Vents (Wind Guild)** :
    *   *Blason* : Plume d'argent sur fond bleu ciel.
    *   *Chef* : **Noctali (Umbreon)**.
    *   *Membres* : Altaria, Swanna, Pijako.
2.  **La Guilde de la Fournaise (Furnace Guild)** :
    *   *Blason* : Flamme incandescente sur charbon noir.
    *   *Chef* : **Camerupt**.
    *   *Membres* : Arcanin, Pyroli, Némélios.
3.  **La Guilde des Abysses (Abyss Guild)** :
    *   *Blason* : Ancre marine sertie de perles.
    *   *Chef* : **Relicanth**.
    *   *Membres* : Aligatueur, Laggron, Sharpedo.
4.  **La Guilde du Bosquet (Grove Guild)** :
    *   *Blason* : Feuille de chêne gravée de runes vertes.
    *   *Chef* : **Tropius**.
    *   *Membres* : Méganium, Jungko, Roserade.
5.  **La Guilde de l'Acier (Steel Guild)** :
    *   *Blason* : Épée d'acier croisée sur un bouclier.
    *   *Chef* : **Bisharp (Scalproie)**.
    *   *Membres* : Galeking, Lucario, Métalosse.
6.  **La Guilde de l'Éclair (Spark Guild)** :
    *   *Blason* : Éclair d'or fendant un nuage.
    *   *Chef* : **Luxray**.
    *   *Membres* : Élecsprint, Voltali, Pharamp.
7.  **La Guilde des Songes (Dream Guild)** :
    *   *Blason* : Œil mystique entouré d'une brume violette.
    *   *Chef* : **Musharna (Mushana)**.
    *   *Membres* : Hypnomade, Symbios, Gardevoir (invitée).
8.  **La Guilde de la Plume (Feather Guild)** :
    *   *Blason* : Aile déployée sous un soleil levant.
    *   *Chef* : **Talonflame (Flambusard)**.
    *   *Membres* : Étouraptor, Archéduc, Flambusard.
9.  **La Guilde de l'Ombre (Shadow Guild)** :
    *   *Blason* : Ombre rampante aux yeux violets.
    *   *Chef* : **Gengar (Ectoplasma)**.
    *   *Membres* : Noctunoir, Branette, Ténéfix.
10. **La Guilde du Glacier (Glacier Guild)** :
    *   *Blason* : Flocon de givre géant taillé dans la glace.
    *   *Chef* : **Weavile (Dimoret)**.
    *   *Membres* : Mammochon, Givrali, Momartik.

---

## 2. Épreuve I : La Traque de Zorua/Zoroark (Les Boss du Vol)

Un Zoroark et son complice Zorua ont cambriolé l'immense réseau des Compagnies Kecleon à travers le monde, dérobant des milliers d'objets précieux. Spinda fait de leur capture la première épreuve du tournoi. Les guildes doivent les pourchasser à travers plusieurs donjons successifs, chacun gardé par un lieutenant ou un monstre enragé :

*   **Donjon A (Mont Tonnerre)** : Boss : **Raichu** escorté de **8 Pikachu/Pichu**.
*   **Donjon B (Forêt Givrée)** : Boss : **Blizzaroi (Abomasnow)** et ses Blizzi.
*   **Donjon C (Croisée de Cristal)** : Boss : **La famille Évoli** au complet (Aquali, Voltali, Pyroli, Mentali, Noctali, Phyllali, Givrali, Nymphali).
*   **Donjon Final (Forêt Embuscade)** :
    *   Le joueur triomphe du donjon et parvient à coincer **Zorua**.
    *   *Le Piège de Zorua (L'Ambuscade)* : Zorua ricane, révèle sa nature d'illusionniste et déclenche une seconde phase de combat immédiate en embuscade avec une équipe redoutable composée de : **Cornèbre (Murkrow), Corboss (Honchkrow), Mimiqui (Mimikyu), Ténéfix (Sableye), et Cizayox (Scizor)** !

---

## 3. Épreuve II : Le Quizz de Kirlia (Questions Théoriques)

Pour la seconde épreuve (située 3 jours après la première), la Guilde de Metano mande **Kirlia**, l'érudite des donjons, pour soumettre les participants à un quizz théorique rigoureux sur les secrets du monde Pokémon.

### Script d'Implémentation Lua pour le Quizz de Kirlia

Ce code gère l'évaluation interactive du joueur avec point d'embranchement et point d'évaluation :

```lua
-- kirlia_quiz.lua
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

kirlia_quiz = {}

function kirlia_quiz.PlayQuiz()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local kirlia = CH('Kirlia')
  
  GAME:CutsceneMode(true)
  UI:SetSpeaker(kirlia)
  
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Bienvenue, candidats, à la seconde épreuve du Grand Tournoi :[pause=15] le Quizz Théorique d'Exploration !")
  UI:WaitShowDialogue("Je vais vous poser 3 questions cruciales. Chaque bonne réponse vous rapproche de la finale. Êtes-vous prêts ?")
  
  local score = 0
  
  -- QUESTION 1 : Affinités de Types
  UI:WaitShowDialogue("Question 1 :[pause=10] Quel type de capacité est super efficace contre un Pokémon de type Acier et Spectre comme Exagide ?")
  local q1_choices = {"Type Combat", "Type Feu", "Type Normal", "Type Psy"}
  UI:BeginChoiceMenu("Choisissez votre réponse :", q1_choices, 1, 4)
  UI:WaitForChoice()
  if UI:ChoiceResult() == 2 then
    score = score + 1
    SOUND:PlaySE("DUN_Hit_Weak") -- Son de validation
    UI:WaitShowDialogue("Exact ! Le type Feu fait fondre l'Acier. Très bien.")
  else
    SOUND:PlaySE("DUN_Worry_Seed") -- Son d'échec
    UI:WaitShowDialogue("Hélas non ! L'Acier résiste au Psy, et le Spectre est immunisé contre le Combat et le Normal.")
  end
  
  -- QUESTION 2 : Histoire des Donjons
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("Question 2 :[pause=10] Qui est le gardien ancestral qui veille au sommet de la Tour Céleste ?")
  local q2_choices = {"Lugia", "Rayquaza", "Dialga", "Ho-Oh"}
  UI:BeginChoiceMenu("Choisissez votre réponse :", q2_choices, 1, 4)
  UI:WaitForChoice()
  if UI:ChoiceResult() == 2 then
    score = score + 1
    SOUND:PlaySE("DUN_Hit_Weak")
    UI:WaitShowDialogue("Parfait ! Rayquaza, le régulateur de l'atmosphère, veille sur la Tour Céleste.")
  else
    SOUND:PlaySE("DUN_Worry_Seed")
    UI:WaitShowDialogue("Non. C'est Rayquaza qui réside au sommet de la Tour céleste.")
  end
  
  -- QUESTION 3 : Survie en Donjon
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("Question 3 :[pause=10] Quel objet dissipe instantanément toutes les altérations de statut de votre équipe au sein d'un étage ?")
  local q3_choices = {"La Graine Guérison", "L'Orbe Échappée", "L'Orbe Purge", "Le Ruban Statut"}
  UI:BeginChoiceMenu("Choisissez votre réponse :", q3_choices, 1, 4)
  UI:WaitForChoice()
  if UI:ChoiceResult() == 3 then
    score = score + 1
    SOUND:PlaySE("DUN_Hit_Weak")
    UI:WaitShowDialogue("Magnifique ! L'Orbe Purge rétablit l'ensemble de votre équipe.")
  else
    SOUND:PlaySE("DUN_Worry_Seed")
    UI:WaitShowDialogue("Faux ! C'est l'Orbe Purge qui possède cette propriété.")
  end
  
  -- ÉVALUATION DU SCORE
  GAME:WaitFrames(30)
  UI:WaitShowDialogue("L'épreuve est terminée ![pause=15] Passons au verdict de votre score...")
  
  if score == 3 then
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue("Incroyable ! Un score parfait de 3 sur 3 ! Kirlia est impressionnée par votre érudition !")
    SV.Chapter8.QuizScore = "Perfect"
  elseif score >= 1 then
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue("Vous avez obtenu " .. score .. " point(s) sur 3. C'est suffisant pour vous qualifier, mais restez vigilants !")
    SV.Chapter8.QuizScore = "Pass"
  else
    GeneralFunctions.SetEmotion("Sad")
    UI:WaitShowDialogue("Zéro point... Quelle déception. Kirlia vous conseille de relire vos guides d'exploration.")
    SV.Chapter8.QuizScore = "Fail"
  end
  
  GAME:CutsceneMode(false)
end

return kirlia_quiz
```

---

## 4. Épreuve III : Le Tournoi en Arène (La Finale)

La troisième épreuve (située 3 jours après le quizz) est le cœur de l'affrontement physique : un **Tournoi par Équipe de Secours** se déroulant dans l'arène de Metano Town décorée pour l'occasion (`Metano_Arene_Base.tile` etc.).

### L'Arbre de Combat (Tournament Bracket)
Le tournoi oppose le joueur à plusieurs des 10 guildes invitées jusqu'à la grande finale :
1.  **Quart de Finale** : Joueur contre la **Guilde du Glacier** (Dimoret, Mammochon, Givrali).
2.  **Demi-Finale** : Joueur contre la **Team Dazzling** (Sucreine, Lockpin, Magirêve), une confrontation théâtrale et rythmée où Lockpin et Sucreine rivalisent de répliques cinglantes.
3.  **Grande Finale** : Joueur contre la légendaire **Team Alakazam** (Alakazam, Tyranitar, Dracaufeu). Le combat ultime du tournoi, avec des effets de foule, des encouragements des habitants et une musique d'arène survoltée.

---

## 5. Processus de Validation Technique pour l'Agent

Avant d'intégrer ce quizz et cette structure de tournoi dans les fichiers de chapitres (`metano_town_ch_8.lua`) :
1.  Vérifier que les variables `SV.Chapter8.QuizScore` et les étapes de quête sont correctement déclarées dans `scriptvars.lua`.
2.  Valider la connexité de la nouvelle carte de l'arène de combat avec `python3 tools/validate_all.py` pour éviter toute fausse liaison physique de mur.
3.  Vérifier l'absence de toute fonction fantôme avec `python3 tools/verify_lua_globals.py`.
