-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py (V2 séquence ROM) — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground s01 — ordre = commands des scripts EU décodés (adresses ROM).
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Welcome!", french="Bienvenue!", german="Herzlich willkommen!", italian="Ti do il benvenuto!", spanish="¡Te doy la bienvenida!"})
  SkySceneKit.say({english="This is the portal that leads to the world of Pokémon!", french="Ceci est le portail qui mène au monde des Pokémon!", german="Dies ist das Portal zur Welt der Pokémon!", italian="Da qui puoi accedere al mondo dei Pokémon!", spanish="¡Este es el portal de entrada al mundo de los Pokémon!"})
  SkySceneKit.say({english="But before I can let you through, I have several questions for you.", french="Mais avant de vous laisser entrer, j'ai plusieurs questions à vous poser.", german="Doch bevor ich dich passieren lassen kann, muss ich dir ein paar Fragen stellen.", italian="Ma prima di lasciarti passare, devo farti un bel po' di domande.", spanish="Pero antes de dejarte entrar, debo hacerte varias preguntas."})
  SkySceneKit.say({english="I want you to answer them sincerely.", french="Je veux que vous y répondiez avec sincérité.", german="Ich möchte, dass du alle Fragen ehrlich beantwortest.", italian="Cerca di rispondere con sincerità.", spanish="Quiero que respondas con sinceridad."})
  SkySceneKit.say({english="Are you ready?", french="On peut commencer?", german="Bist du bereit?", italian="Possiamo cominciare?", spanish="¿Podemos empezar?..."})
  SkySceneKit.say({english="OK... Let the interview begin!", french="D'accord... Commençons l'entretien!", german="Gut... Fangen wir an!", italian="OK... Diamo inizio all'intervista!", spanish="Vale. ¡Que empiece la entrevista!"})
  pcall(function() SOUND:PlayBGM("Welcome to the World of Pokemon.ogg", true) end) -- 0x44 music_id 12 (ROM)
end
